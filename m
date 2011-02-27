Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:58753 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751293Ab1B0VIM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Feb 2011 16:08:12 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net
Subject: [PATCH v2 2/2] mac80211: add support for showing the last rx bitrate
Date: Sun, 27 Feb 2011 22:08:01 +0100
Message-Id: <1298840881-62357-2-git-send-email-nbd@openwrt.org>
In-Reply-To: <1298840881-62357-1-git-send-email-nbd@openwrt.org>
References: <1298840881-62357-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 net/mac80211/cfg.c      |   31 ++++++++++++++++++++++---------
 net/mac80211/rx.c       |   11 ++++++++++-
 net/mac80211/sta_info.h |    4 ++++
 3 files changed, 36 insertions(+), 10 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 8b436c7..7b701dc 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -316,6 +316,17 @@ static int ieee80211_config_default_mgmt_key(struct wiphy *wiphy,
 	return 0;
 }
 
+static void rate_idx_to_bitrate(struct rate_info *rate, struct sta_info *sta, int idx)
+{
+	if (!(rate->flags & RATE_INFO_FLAGS_MCS)) {
+		struct ieee80211_supported_band *sband;
+		sband = sta->local->hw.wiphy->bands[
+				sta->local->hw.conf.channel->band];
+		rate->legacy = sband->bitrates[idx].bitrate;
+	} else
+		rate->mcs = idx;
+}
+
 static void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
 {
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
@@ -330,6 +341,7 @@ static void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
 			STATION_INFO_TX_RETRIES |
 			STATION_INFO_TX_FAILED |
 			STATION_INFO_TX_BITRATE |
+			STATION_INFO_RX_BITRATE |
 			STATION_INFO_RX_DROP_MISC;
 
 	sinfo->inactive_time = jiffies_to_msecs(jiffies - sta->last_rx);
@@ -355,15 +367,16 @@ static void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
 		sinfo->txrate.flags |= RATE_INFO_FLAGS_40_MHZ_WIDTH;
 	if (sta->last_tx_rate.flags & IEEE80211_TX_RC_SHORT_GI)
 		sinfo->txrate.flags |= RATE_INFO_FLAGS_SHORT_GI;
-
-	if (!(sta->last_tx_rate.flags & IEEE80211_TX_RC_MCS)) {
-		struct ieee80211_supported_band *sband;
-		sband = sta->local->hw.wiphy->bands[
-				sta->local->hw.conf.channel->band];
-		sinfo->txrate.legacy =
-			sband->bitrates[sta->last_tx_rate.idx].bitrate;
-	} else
-		sinfo->txrate.mcs = sta->last_tx_rate.idx;
+	rate_idx_to_bitrate(&sinfo->txrate, sta, sta->last_tx_rate.idx);
+
+	sinfo->rxrate.flags = 0;
+	if (sta->last_rx_rate_flag & RX_FLAG_HT)
+		sinfo->rxrate.flags |= RATE_INFO_FLAGS_MCS;
+	if (sta->last_rx_rate_flag & RX_FLAG_40MHZ)
+		sinfo->rxrate.flags |= RATE_INFO_FLAGS_40_MHZ_WIDTH;
+	if (sta->last_rx_rate_flag & RX_FLAG_SHORT_GI)
+		sinfo->rxrate.flags |= RATE_INFO_FLAGS_SHORT_GI;
+	rate_idx_to_bitrate(&sinfo->rxrate, sta, sta->last_rx_rate_idx);
 
 	if (ieee80211_vif_is_mesh(&sdata->vif)) {
 #ifdef CONFIG_MAC80211_MESH
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 5b53423..5c1930b 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1156,14 +1156,23 @@ ieee80211_rx_h_sta_process(struct ieee80211_rx_data *rx)
 	if (rx->sdata->vif.type == NL80211_IFTYPE_ADHOC) {
 		u8 *bssid = ieee80211_get_bssid(hdr, rx->skb->len,
 						NL80211_IFTYPE_ADHOC);
-		if (compare_ether_addr(bssid, rx->sdata->u.ibss.bssid) == 0)
+		if (compare_ether_addr(bssid, rx->sdata->u.ibss.bssid) == 0) {
 			sta->last_rx = jiffies;
+			if (ieee80211_is_data(hdr->frame_control)) {
+				sta->last_rx_rate_idx = status->rate_idx;
+				sta->last_rx_rate_flag = status->flag;
+			}
+		}
 	} else if (!is_multicast_ether_addr(hdr->addr1)) {
 		/*
 		 * Mesh beacons will update last_rx when if they are found to
 		 * match the current local configuration when processed.
 		 */
 		sta->last_rx = jiffies;
+		if (ieee80211_is_data(hdr->frame_control)) {
+			sta->last_rx_rate_idx = status->rate_idx;
+			sta->last_rx_rate_flag = status->flag;
+		}
 	}
 
 	if (!(status->rx_flags & IEEE80211_RX_RA_MATCH))
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index ca0b690..5768114 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -209,6 +209,8 @@ enum plink_state {
  * @rate_ctrl_priv: rate control private per-STA pointer
  * @last_tx_rate: rate used for last transmit, to report to userspace as
  *	"the" transmit rate
+ * @last_rx_rate_idx: rx status rate index of the last data packet
+ * @last_rx_rate_flag: rx status flag of the last data packet
  * @lock: used for locking all fields that require locking, see comments
  *	in the header file.
  * @flaglock: spinlock for flags accesses
@@ -311,6 +313,8 @@ struct sta_info {
 	unsigned long tx_bytes;
 	unsigned long tx_fragments;
 	struct ieee80211_tx_rate last_tx_rate;
+	int last_rx_rate_idx;
+	int last_rx_rate_flag;
 	u16 tid_seq[IEEE80211_QOS_CTL_TID_MASK + 1];
 
 	/*
-- 
1.7.3.2

