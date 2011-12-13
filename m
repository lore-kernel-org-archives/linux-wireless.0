Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37860 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753731Ab1LMUPT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Dec 2011 15:15:19 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.77)
	(envelope-from <johannes@sipsolutions.net>)
	id 1RaYkw-00036Z-Nz
	for linux-wireless@vger.kernel.org; Tue, 13 Dec 2011 21:15:18 +0100
Message-Id: <20111213201449.989844540@sipsolutions.net> (sfid-20111213_211526_331033_7D1B8B63)
Date: Tue, 13 Dec 2011 21:07:21 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [RFC 4/4] mac80211: count authorized stations per BSS
References: <20111213200717.465896579@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Currently, each AP interface will send multicast
traffic if any interface has a station entry even
if that station entry is allocated only. With the
new station state management we can easily fix it
by adding a counter that counts each authorized
station only and send multicast traffic only when
the correct interface has at least one authorized
station.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/debugfs_netdev.c |    2 ++
 net/mac80211/ieee80211_i.h    |    1 +
 net/mac80211/sta_info.c       |   14 +++++++++-----
 net/mac80211/tx.c             |   19 ++++++++-----------
 4 files changed, 20 insertions(+), 16 deletions(-)

--- a/net/mac80211/debugfs_netdev.c	2011-12-13 20:30:53.000000000 +0100
+++ b/net/mac80211/debugfs_netdev.c	2011-12-13 20:31:16.000000000 +0100
@@ -321,6 +321,7 @@ static ssize_t ieee80211_if_parse_tkip_m
 __IEEE80211_IF_FILE_W(tkip_mic_test);
 
 /* AP attributes */
+IEEE80211_IF_FILE(num_sta_authorized, u.ap.num_sta_authorized, ATOMIC);
 IEEE80211_IF_FILE(num_sta_ps, u.ap.num_sta_ps, ATOMIC);
 IEEE80211_IF_FILE(dtim_count, u.ap.dtim_count, DEC);
 
@@ -458,6 +459,7 @@ static void add_ap_files(struct ieee8021
 	DEBUGFS_ADD(rc_rateidx_mask_2ghz);
 	DEBUGFS_ADD(rc_rateidx_mask_5ghz);
 
+	DEBUGFS_ADD(num_sta_authorized);
 	DEBUGFS_ADD(num_sta_ps);
 	DEBUGFS_ADD(dtim_count);
 	DEBUGFS_ADD(num_buffered_multicast);
--- a/net/mac80211/ieee80211_i.h	2011-12-13 20:30:53.000000000 +0100
+++ b/net/mac80211/ieee80211_i.h	2011-12-13 20:31:16.000000000 +0100
@@ -243,6 +243,7 @@ struct ieee80211_if_ap {
 	u8 tim[sizeof(unsigned long) * BITS_TO_LONGS(IEEE80211_MAX_AID + 1)];
 	struct sk_buff_head ps_bc_buf;
 	atomic_t num_sta_ps; /* number of stations in PS mode */
+	atomic_t num_sta_authorized; /* number of authorized stations */
 	int dtim_count;
 	bool dtim_bc_mc;
 };
--- a/net/mac80211/sta_info.c	2011-12-13 20:31:16.000000000 +0100
+++ b/net/mac80211/sta_info.c	2011-12-13 20:31:16.000000000 +0100
@@ -1542,17 +1542,21 @@ int sta_info_move_state_checked(struct s
 			return -EINVAL;
 		break;
 	case IEEE80211_STA_ASSOC:
-		if (sta->sta_state == IEEE80211_STA_AUTH)
+		if (sta->sta_state == IEEE80211_STA_AUTH) {
 			set_bit(WLAN_STA_ASSOC, &sta->_flags);
-		else if (sta->sta_state == IEEE80211_STA_AUTHORIZED)
+		} else if (sta->sta_state == IEEE80211_STA_AUTHORIZED) {
+			if (sta->sdata->vif.type == NL80211_IFTYPE_AP)
+				atomic_dec(&sta->sdata->u.ap.num_sta_authorized);
 			clear_bit(WLAN_STA_AUTHORIZED, &sta->_flags);
-		else
+		} else
 			return -EINVAL;
 		break;
 	case IEEE80211_STA_AUTHORIZED:
-		if (sta->sta_state == IEEE80211_STA_ASSOC)
+		if (sta->sta_state == IEEE80211_STA_ASSOC) {
+			if (sta->sdata->vif.type == NL80211_IFTYPE_AP)
+				atomic_inc(&sta->sdata->u.ap.num_sta_authorized);
 			set_bit(WLAN_STA_AUTHORIZED, &sta->_flags);
-		else
+		} else
 			return -EINVAL;
 		break;
 	default:
--- a/net/mac80211/tx.c	2011-12-13 20:30:53.000000000 +0100
+++ b/net/mac80211/tx.c	2011-12-13 20:31:16.000000000 +0100
@@ -304,17 +304,14 @@ ieee80211_tx_h_check_assoc(struct ieee80
 			I802_DEBUG_INC(tx->local->tx_handlers_drop_not_assoc);
 			return TX_DROP;
 		}
-	} else {
-		if (unlikely(ieee80211_is_data(hdr->frame_control) &&
-			     tx->local->num_sta == 0 &&
-			     tx->sdata->vif.type != NL80211_IFTYPE_ADHOC)) {
-			/*
-			 * No associated STAs - no need to send multicast
-			 * frames.
-			 */
-			return TX_DROP;
-		}
-		return TX_CONTINUE;
+	} else if (unlikely(tx->sdata->vif.type == NL80211_IFTYPE_AP &&
+			    ieee80211_is_data(hdr->frame_control) &&
+			    !atomic_read(&tx->sdata->u.ap.num_sta_authorized))) {
+		/*
+		 * No associated STAs - no need to send multicast
+		 * frames.
+		 */
+		return TX_DROP;
 	}
 
 	return TX_CONTINUE;


