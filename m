Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:48653 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755701Ab1EaTQo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 May 2011 15:16:44 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net
Subject: [PATCH 3/3] mac80211: receive action frames for WDS interfaces
Date: Tue, 31 May 2011 21:16:34 +0200
Message-Id: <1306869394-83047-3-git-send-email-nbd@openwrt.org> (sfid-20110531_211647_427380_EBBFC8A4)
In-Reply-To: <1306869394-83047-2-git-send-email-nbd@openwrt.org>
References: <1306869394-83047-1-git-send-email-nbd@openwrt.org>
 <1306869394-83047-2-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Adds support for aggregation

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 net/mac80211/agg-rx.c |    2 ++
 net/mac80211/agg-tx.c |    6 ++++--
 net/mac80211/rx.c     |   16 ++++++++++------
 3 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/net/mac80211/agg-rx.c b/net/mac80211/agg-rx.c
index 9c0d76c..0f83b37 100644
--- a/net/mac80211/agg-rx.c
+++ b/net/mac80211/agg-rx.c
@@ -161,6 +161,8 @@ static void ieee80211_send_addba_resp(struct ieee80211_sub_if_data *sdata, u8 *d
 		memcpy(mgmt->bssid, sdata->vif.addr, ETH_ALEN);
 	else if (sdata->vif.type == NL80211_IFTYPE_STATION)
 		memcpy(mgmt->bssid, sdata->u.mgd.bssid, ETH_ALEN);
+	else if (sdata->vif.type == NL80211_IFTYPE_WDS)
+		memcpy(mgmt->bssid, da, ETH_ALEN);
 
 	mgmt->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
 					  IEEE80211_STYPE_ACTION);
diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
index cd5125f..7117108 100644
--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -79,7 +79,8 @@ static void ieee80211_send_addba_request(struct ieee80211_sub_if_data *sdata,
 	memcpy(mgmt->da, da, ETH_ALEN);
 	memcpy(mgmt->sa, sdata->vif.addr, ETH_ALEN);
 	if (sdata->vif.type == NL80211_IFTYPE_AP ||
-	    sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
+	    sdata->vif.type == NL80211_IFTYPE_AP_VLAN ||
+	    sdata->vif.type == NL80211_IFTYPE_WDS)
 		memcpy(mgmt->bssid, sdata->vif.addr, ETH_ALEN);
 	else if (sdata->vif.type == NL80211_IFTYPE_STATION)
 		memcpy(mgmt->bssid, sdata->u.mgd.bssid, ETH_ALEN);
@@ -388,7 +389,8 @@ int ieee80211_start_tx_ba_session(struct ieee80211_sta *pubsta, u16 tid,
 	 */
 	if (sdata->vif.type != NL80211_IFTYPE_STATION &&
 	    sdata->vif.type != NL80211_IFTYPE_AP_VLAN &&
-	    sdata->vif.type != NL80211_IFTYPE_AP)
+	    sdata->vif.type != NL80211_IFTYPE_AP &&
+	    sdata->vif.type != NL80211_IFTYPE_WDS)
 		return -EINVAL;
 
 	if (test_sta_flags(sta, WLAN_STA_BLOCK_BA)) {
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 683a46b..33f1fb5 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2137,7 +2137,8 @@ ieee80211_rx_h_action(struct ieee80211_rx_data *rx)
 		 */
 		if (sdata->vif.type != NL80211_IFTYPE_STATION &&
 		    sdata->vif.type != NL80211_IFTYPE_AP_VLAN &&
-		    sdata->vif.type != NL80211_IFTYPE_AP)
+		    sdata->vif.type != NL80211_IFTYPE_AP &&
+		    sdata->vif.type != NL80211_IFTYPE_WDS)
 			break;
 
 		/* verify action_code is present */
@@ -2681,13 +2682,16 @@ static int prepare_for_handlers(struct ieee80211_rx_data *rx,
 		}
 		break;
 	case NL80211_IFTYPE_WDS:
-		if (bssid) {
-			if (!ieee80211_is_beacon(hdr->frame_control))
-				return 0;
-		} else if (!ieee80211_is_data(hdr->frame_control))
-			return 0;
 		if (compare_ether_addr(sdata->u.wds.remote_addr, hdr->addr2))
 			return 0;
+
+		if (ieee80211_is_data(hdr->frame_control) ||
+		    ieee80211_is_action(hdr->frame_control)) {
+			if (compare_ether_addr(sdata->vif.addr, hdr->addr1))
+				return 0;
+		} else if (!ieee80211_is_beacon(hdr->frame_control))
+			return 0;
+
 		break;
 	default:
 		/* should never get here */
-- 
1.7.3.2

