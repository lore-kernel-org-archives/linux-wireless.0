Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:41542 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751946Ab2DUVmW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Apr 2012 17:42:22 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net
Subject: [PATCH v3 1/2] mac80211: rename AP variable num_sta_authorized to num_mcast_sta
Date: Sat, 21 Apr 2012 23:42:12 +0200
Message-Id: <1335044533-37359-1-git-send-email-nbd@openwrt.org> (sfid-20120421_234239_855067_F909D942)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It is only used to test for BSS multicast receivers.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 net/mac80211/debugfs_netdev.c |    4 ++--
 net/mac80211/ieee80211_i.h    |    2 +-
 net/mac80211/sta_info.c       |    4 ++--
 net/mac80211/tx.c             |    2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
index e7af522..ea0122d 100644
--- a/net/mac80211/debugfs_netdev.c
+++ b/net/mac80211/debugfs_netdev.c
@@ -394,7 +394,7 @@ static ssize_t ieee80211_if_parse_uapsd_max_sp_len(
 __IEEE80211_IF_FILE_W(uapsd_max_sp_len);
 
 /* AP attributes */
-IEEE80211_IF_FILE(num_sta_authorized, u.ap.num_sta_authorized, ATOMIC);
+IEEE80211_IF_FILE(num_mcast_sta, u.ap.num_mcast_sta, ATOMIC);
 IEEE80211_IF_FILE(num_sta_ps, u.ap.num_sta_ps, ATOMIC);
 IEEE80211_IF_FILE(dtim_count, u.ap.dtim_count, DEC);
 
@@ -540,7 +540,7 @@ static void add_sta_files(struct ieee80211_sub_if_data *sdata)
 
 static void add_ap_files(struct ieee80211_sub_if_data *sdata)
 {
-	DEBUGFS_ADD(num_sta_authorized);
+	DEBUGFS_ADD(num_mcast_sta);
 	DEBUGFS_ADD(num_sta_ps);
 	DEBUGFS_ADD(dtim_count);
 	DEBUGFS_ADD(num_buffered_multicast);
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index bd7a451..4404753 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -282,7 +282,7 @@ struct ieee80211_if_ap {
 	u8 tim[sizeof(unsigned long) * BITS_TO_LONGS(IEEE80211_MAX_AID + 1)];
 	struct sk_buff_head ps_bc_buf;
 	atomic_t num_sta_ps; /* number of stations in PS mode */
-	atomic_t num_sta_authorized; /* number of authorized stations */
+	atomic_t num_mcast_sta; /* number of stations receiving multicast */
 	int dtim_count;
 	bool dtim_bc_mc;
 };
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 7fd7ac4..4c04eb5 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -1418,14 +1418,14 @@ int sta_info_move_state(struct sta_info *sta,
 			set_bit(WLAN_STA_ASSOC, &sta->_flags);
 		} else if (sta->sta_state == IEEE80211_STA_AUTHORIZED) {
 			if (sta->sdata->vif.type == NL80211_IFTYPE_AP)
-				atomic_dec(&sta->sdata->u.ap.num_sta_authorized);
+				atomic_dec(&sta->sdata->u.ap.num_mcast_sta);
 			clear_bit(WLAN_STA_AUTHORIZED, &sta->_flags);
 		}
 		break;
 	case IEEE80211_STA_AUTHORIZED:
 		if (sta->sta_state == IEEE80211_STA_ASSOC) {
 			if (sta->sdata->vif.type == NL80211_IFTYPE_AP)
-				atomic_inc(&sta->sdata->u.ap.num_sta_authorized);
+				atomic_inc(&sta->sdata->u.ap.num_mcast_sta);
 			set_bit(WLAN_STA_AUTHORIZED, &sta->_flags);
 		}
 		break;
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 0abbef95..44001c7 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -306,7 +306,7 @@ ieee80211_tx_h_check_assoc(struct ieee80211_tx_data *tx)
 		}
 	} else if (unlikely(tx->sdata->vif.type == NL80211_IFTYPE_AP &&
 			    ieee80211_is_data(hdr->frame_control) &&
-			    !atomic_read(&tx->sdata->u.ap.num_sta_authorized))) {
+			    !atomic_read(&tx->sdata->u.ap.num_mcast_sta))) {
 		/*
 		 * No associated STAs - no need to send multicast
 		 * frames.
-- 
1.7.3.2

