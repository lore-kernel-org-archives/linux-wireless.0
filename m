Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:57087 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964788Ab3FSVCo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Jun 2013 17:02:44 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@venema.h4ckr.net, Ben Greear <greearb@candelatech.com>
Subject: [PATCH-WN 2/2] ath9k_htc: Add ethtool stats support.
Date: Wed, 19 Jun 2013 14:02:15 -0700
Message-Id: <1371675735-28591-2-git-send-email-greearb@candelatech.com> (sfid-20130619_230247_979200_5BCD82C9)
In-Reply-To: <1371675735-28591-1-git-send-email-greearb@candelatech.com>
References: <1371675735-28591-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

This provides some of the same info found in
the ath9k_htc debugfs through the standard ethtool stats API.

This logic is only supported when ath9k_htc debugfs kernel
feature is enabled, since that is the only time stats
are actually gathered.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---

This patch is against wireless-next, and has been tested
against my 3.9 tree for quite a while.

 drivers/net/wireless/ath/ath9k/hif_usb.c       |    8 ++-
 drivers/net/wireless/ath/ath9k/htc.h           |   14 ++++
 drivers/net/wireless/ath/ath9k/htc_drv_debug.c |   81 ++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/htc_drv_main.c  |    6 ++
 4 files changed, 108 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index f5dda84..9e582e1 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -234,10 +234,15 @@ static inline void ath9k_skb_queue_complete(struct hif_device_usb *hif_dev,
 	struct sk_buff *skb;
 
 	while ((skb = __skb_dequeue(queue)) != NULL) {
+#ifdef CONFIG_ATH9K_HTC_DEBUGFS
+		int ln = skb->len;
+#endif
 		ath9k_htc_txcompletion_cb(hif_dev->htc_handle,
 					  skb, txok);
-		if (txok)
+		if (txok) {
 			TX_STAT_INC(skb_success);
+			TX_STAT_ADD(skb_success_bytes, ln);
+		}
 		else
 			TX_STAT_INC(skb_failed);
 	}
@@ -620,6 +625,7 @@ static void ath9k_hif_usb_rx_stream(struct hif_device_usb *hif_dev,
 
 err:
 	for (i = 0; i < pool_index; i++) {
+		RX_STAT_ADD(skb_completed_bytes, skb_pool[i]->len);
 		ath9k_htc_rx_msg(hif_dev->htc_handle, skb_pool[i],
 				 skb_pool[i]->len, USB_WLAN_RX_PIPE);
 		RX_STAT_INC(skb_completed);
diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index 6bd556d..055d7c2 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -324,7 +324,9 @@ static inline struct ath9k_htc_tx_ctl *HTC_SKB_CB(struct sk_buff *skb)
 #ifdef CONFIG_ATH9K_HTC_DEBUGFS
 
 #define TX_STAT_INC(c) (hif_dev->htc_handle->drv_priv->debug.tx_stats.c++)
+#define TX_STAT_ADD(c, a) (hif_dev->htc_handle->drv_priv->debug.tx_stats.c += a)
 #define RX_STAT_INC(c) (hif_dev->htc_handle->drv_priv->debug.rx_stats.c++)
+#define RX_STAT_ADD(c, a) (hif_dev->htc_handle->drv_priv->debug.rx_stats.c += a)
 #define CAB_STAT_INC   priv->debug.tx_stats.cab_queued++
 
 #define TX_QSTAT_INC(q) (priv->debug.tx_stats.queue_stats[q]++)
@@ -337,6 +339,7 @@ struct ath_tx_stats {
 	u32 buf_completed;
 	u32 skb_queued;
 	u32 skb_success;
+	u32 skb_success_bytes;
 	u32 skb_failed;
 	u32 cab_queued;
 	u32 queue_stats[IEEE80211_NUM_ACS];
@@ -345,6 +348,7 @@ struct ath_tx_stats {
 struct ath_rx_stats {
 	u32 skb_allocated;
 	u32 skb_completed;
+	u32 skb_completed_bytes;
 	u32 skb_dropped;
 	u32 err_crc;
 	u32 err_decrypt_crc;
@@ -362,10 +366,20 @@ struct ath9k_debug {
 	struct ath_rx_stats rx_stats;
 };
 
+void ath9k_htc_get_et_strings(struct ieee80211_hw *hw,
+			      struct ieee80211_vif *vif,
+			      u32 sset, u8 *data);
+int ath9k_htc_get_et_sset_count(struct ieee80211_hw *hw,
+				struct ieee80211_vif *vif, int sset);
+void ath9k_htc_get_et_stats(struct ieee80211_hw *hw,
+			    struct ieee80211_vif *vif,
+			    struct ethtool_stats *stats, u64 *data);
 #else
 
 #define TX_STAT_INC(c) do { } while (0)
+#define TX_STAT_ADD(c, a) do { } while (0)
 #define RX_STAT_INC(c) do { } while (0)
+#define RX_STAT_ADD(c, a) do { } while (0)
 #define CAB_STAT_INC   do { } while (0)
 
 #define TX_QSTAT_INC(c) do { } while (0)
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_debug.c b/drivers/net/wireless/ath/ath9k/htc_drv_debug.c
index 632d13d..7416d58 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_debug.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_debug.c
@@ -902,6 +902,87 @@ static const struct file_operations fops_modal_eeprom = {
 	.llseek = default_llseek,
 };
 
+
+/* Ethtool support for get-stats */
+#define AMKSTR(nm) #nm "_BE", #nm "_BK", #nm "_VI", #nm "_VO"
+static const char ath9k_htc_gstrings_stats[][ETH_GSTRING_LEN] = {
+	"tx_pkts_nic",
+	"tx_bytes_nic",
+	"rx_pkts_nic",
+	"rx_bytes_nic",
+
+	AMKSTR(d_tx_pkts),
+
+	"d_rx_crc_err",
+	"d_rx_decrypt_crc_err",
+	"d_rx_phy_err",
+	"d_rx_mic_err",
+	"d_rx_pre_delim_crc_err",
+	"d_rx_post_delim_crc_err",
+	"d_rx_decrypt_busy_err",
+
+	"d_rx_phyerr_radar",
+	"d_rx_phyerr_ofdm_timing",
+	"d_rx_phyerr_cck_timing",
+
+};
+#define ATH9K_HTC_SSTATS_LEN ARRAY_SIZE(ath9k_htc_gstrings_stats)
+
+void ath9k_htc_get_et_strings(struct ieee80211_hw *hw,
+			      struct ieee80211_vif *vif,
+			      u32 sset, u8 *data)
+{
+	if (sset == ETH_SS_STATS)
+		memcpy(data, *ath9k_htc_gstrings_stats,
+		       sizeof(ath9k_htc_gstrings_stats));
+}
+
+int ath9k_htc_get_et_sset_count(struct ieee80211_hw *hw,
+				struct ieee80211_vif *vif, int sset)
+{
+	if (sset == ETH_SS_STATS)
+		return ATH9K_HTC_SSTATS_LEN;
+	return 0;
+}
+
+#define STXBASE priv->debug.tx_stats
+#define SRXBASE priv->debug.rx_stats
+#define ASTXQ(a)					\
+	data[i++] = STXBASE.a[IEEE80211_AC_BE];		\
+	data[i++] = STXBASE.a[IEEE80211_AC_BK];		\
+	data[i++] = STXBASE.a[IEEE80211_AC_VI];		\
+	data[i++] = STXBASE.a[IEEE80211_AC_VO]
+
+void ath9k_htc_get_et_stats(struct ieee80211_hw *hw,
+			    struct ieee80211_vif *vif,
+			    struct ethtool_stats *stats, u64 *data)
+{
+	struct ath9k_htc_priv *priv = hw->priv;
+	int i = 0;
+
+	data[i++] = STXBASE.skb_success;
+	data[i++] = STXBASE.skb_success_bytes;
+	data[i++] = SRXBASE.skb_completed;
+	data[i++] = SRXBASE.skb_completed_bytes;
+
+	ASTXQ(queue_stats);
+
+	data[i++] = SRXBASE.err_crc;
+	data[i++] = SRXBASE.err_decrypt_crc;
+	data[i++] = SRXBASE.err_phy;
+	data[i++] = SRXBASE.err_mic;
+	data[i++] = SRXBASE.err_pre_delim;
+	data[i++] = SRXBASE.err_post_delim;
+	data[i++] = SRXBASE.err_decrypt_busy;
+
+	data[i++] = SRXBASE.err_phy_stats[ATH9K_PHYERR_RADAR];
+	data[i++] = SRXBASE.err_phy_stats[ATH9K_PHYERR_OFDM_TIMING];
+	data[i++] = SRXBASE.err_phy_stats[ATH9K_PHYERR_CCK_TIMING];
+
+	WARN_ON(i != ATH9K_HTC_SSTATS_LEN);
+}
+
+
 int ath9k_htc_init_debug(struct ath_hw *ah)
 {
 	struct ath_common *common = ath9k_hw_common(ah);
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index ef68857..be6baf7 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -1837,4 +1837,10 @@ struct ieee80211_ops ath9k_htc_ops = {
 	.set_bitrate_mask   = ath9k_htc_set_bitrate_mask,
 	.get_stats	    = ath9k_htc_get_stats,
 	.get_antenna	    = ath9k_htc_get_antenna,
+
+#ifdef CONFIG_ATH9K_HTC_DEBUGFS
+	.get_et_sset_count  = ath9k_htc_get_et_sset_count,
+	.get_et_stats       = ath9k_htc_get_et_stats,
+	.get_et_strings     = ath9k_htc_get_et_strings,
+#endif
 };
-- 
1.7.3.4

