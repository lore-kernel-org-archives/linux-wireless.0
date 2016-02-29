Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39694 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753256AbcB2WF5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 17:05:57 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 049/113] rtl8xxxu: Handle 8723bu style rx descriptors
Date: Mon, 29 Feb 2016 17:04:47 -0500
Message-Id: <1456783551-28315-50-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160229_230811_537769_4DDF9D95)
In-Reply-To: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

This adds code to parse the new RX descriptor format used by the
8723bu/8192eu parts.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 125 +++++++++++++++++------
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h |   8 ++
 2 files changed, 103 insertions(+), 30 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index 6aa908e..b1b3e14 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -6730,6 +6730,91 @@ static void rtl8xxxu_rx_urb_work(struct work_struct *work)
 	}
 }
 
+static int rtl8723au_parse_rx_desc(struct rtl8xxxu_priv *priv,
+				   struct sk_buff *skb,
+				   struct ieee80211_rx_status *rx_status)
+{
+	struct rtl8xxxu_rx_desc *rx_desc = (struct rtl8xxxu_rx_desc *)skb->data;
+	struct rtl8723au_phy_stats *phy_stats;
+	int drvinfo_sz, desc_shift;
+
+	skb_pull(skb, sizeof(struct rtl8xxxu_rx_desc));
+
+	phy_stats = (struct rtl8723au_phy_stats *)skb->data;
+
+	drvinfo_sz = rx_desc->drvinfo_sz * 8;
+	desc_shift = rx_desc->shift;
+	skb_pull(skb, drvinfo_sz + desc_shift);
+
+	if (rx_desc->phy_stats)
+		rtl8xxxu_rx_parse_phystats(priv, rx_status, rx_desc, phy_stats);
+
+	rx_status->mactime = le32_to_cpu(rx_desc->tsfl);
+	rx_status->flag |= RX_FLAG_MACTIME_START;
+
+	if (!rx_desc->swdec)
+		rx_status->flag |= RX_FLAG_DECRYPTED;
+	if (rx_desc->crc32)
+		rx_status->flag |= RX_FLAG_FAILED_FCS_CRC;
+	if (rx_desc->bw)
+		rx_status->flag |= RX_FLAG_40MHZ;
+
+	if (rx_desc->rxht) {
+		rx_status->flag |= RX_FLAG_HT;
+		rx_status->rate_idx = rx_desc->rxmcs - DESC_RATE_MCS0;
+	} else {
+		rx_status->rate_idx = rx_desc->rxmcs;
+	}
+
+	return RX_TYPE_DATA_PKT;
+}
+
+static int rtl8723bu_parse_rx_desc(struct rtl8xxxu_priv *priv,
+				   struct sk_buff *skb,
+				   struct ieee80211_rx_status *rx_status)
+{
+	struct rtl8723bu_rx_desc *rx_desc =
+		(struct rtl8723bu_rx_desc *)skb->data;
+	struct rtl8723au_phy_stats *phy_stats;
+	int drvinfo_sz, desc_shift;
+	int rx_type;
+
+	skb_pull(skb, sizeof(struct rtl8723bu_rx_desc));
+
+	phy_stats = (struct rtl8723au_phy_stats *)skb->data;
+
+	drvinfo_sz = rx_desc->drvinfo_sz * 8;
+	desc_shift = rx_desc->shift;
+	skb_pull(skb, drvinfo_sz + desc_shift);
+
+	rx_status->mactime = le32_to_cpu(rx_desc->tsfl);
+	rx_status->flag |= RX_FLAG_MACTIME_START;
+
+	if (!rx_desc->swdec)
+		rx_status->flag |= RX_FLAG_DECRYPTED;
+	if (rx_desc->crc32)
+		rx_status->flag |= RX_FLAG_FAILED_FCS_CRC;
+	if (rx_desc->bw)
+		rx_status->flag |= RX_FLAG_40MHZ;
+
+	if (rx_desc->rxmcs >= DESC_RATE_MCS0) {
+		rx_status->flag |= RX_FLAG_HT;
+		rx_status->rate_idx = rx_desc->rxmcs - DESC_RATE_MCS0;
+	} else {
+		rx_status->rate_idx = rx_desc->rxmcs;
+	}
+
+	if (rx_desc->rpt_sel) {
+		struct device *dev = &priv->udev->dev;
+		dev_dbg(dev, "%s: C2H packet\n", __func__);
+		rx_type = RX_TYPE_C2H;
+	} else {
+		rx_type = RX_TYPE_DATA_PKT;
+	}
+
+	return rx_type;
+}
+
 static void rtl8xxxu_rx_complete(struct urb *urb)
 {
 	struct rtl8xxxu_rx_urb *rx_urb =
@@ -6737,54 +6822,30 @@ static void rtl8xxxu_rx_complete(struct urb *urb)
 	struct ieee80211_hw *hw = rx_urb->hw;
 	struct rtl8xxxu_priv *priv = hw->priv;
 	struct sk_buff *skb = (struct sk_buff *)urb->context;
-	struct rtl8xxxu_rx_desc *rx_desc = (struct rtl8xxxu_rx_desc *)skb->data;
-	struct rtl8723au_phy_stats *phy_stats;
 	struct ieee80211_rx_status *rx_status = IEEE80211_SKB_RXCB(skb);
 	struct device *dev = &priv->udev->dev;
 	__le32 *_rx_desc_le = (__le32 *)skb->data;
 	u32 *_rx_desc = (u32 *)skb->data;
-	int drvinfo_sz, desc_shift, i;
+	int rx_type, i;
 
 	for (i = 0; i < (sizeof(struct rtl8xxxu_rx_desc) / sizeof(u32)); i++)
 		_rx_desc[i] = le32_to_cpu(_rx_desc_le[i]);
 
-	drvinfo_sz = rx_desc->drvinfo_sz * 8;
-	desc_shift = rx_desc->shift;
 	skb_put(skb, urb->actual_length);
 
 	if (urb->status == 0) {
-		skb_pull(skb, sizeof(struct rtl8xxxu_rx_desc));
-		phy_stats = (struct rtl8723au_phy_stats *)skb->data;
-
-		skb_pull(skb, drvinfo_sz + desc_shift);
-
 		memset(rx_status, 0, sizeof(struct ieee80211_rx_status));
 
-		if (rx_desc->phy_stats)
-			rtl8xxxu_rx_parse_phystats(priv, rx_status,
-						   rx_desc, phy_stats);
+		rx_type = priv->fops->parse_rx_desc(priv, skb, rx_status);
 
 		rx_status->freq = hw->conf.chandef.chan->center_freq;
 		rx_status->band = hw->conf.chandef.chan->band;
 
-		rx_status->mactime = le32_to_cpu(rx_desc->tsfl);
-		rx_status->flag |= RX_FLAG_MACTIME_START;
-
-		if (!rx_desc->swdec)
-			rx_status->flag |= RX_FLAG_DECRYPTED;
-		if (rx_desc->crc32)
-			rx_status->flag |= RX_FLAG_FAILED_FCS_CRC;
-		if (rx_desc->bw)
-			rx_status->flag |= RX_FLAG_40MHZ;
-
-		if (rx_desc->rxht) {
-			rx_status->flag |= RX_FLAG_HT;
-			rx_status->rate_idx = rx_desc->rxmcs - DESC_RATE_MCS0;
-		} else {
-			rx_status->rate_idx = rx_desc->rxmcs;
-		}
+		if (rx_type == RX_TYPE_DATA_PKT)
+			ieee80211_rx_irqsafe(hw, skb);
+		else
+			dev_kfree_skb(skb);
 
-		ieee80211_rx_irqsafe(hw, skb);
 		skb = NULL;
 		rx_urb->urb.context = NULL;
 		rtl8xxxu_queue_rx_urb(priv, rx_urb);
@@ -7564,6 +7625,7 @@ static struct rtl8xxxu_fileops rtl8723au_fops = {
 	.llt_init = rtl8xxxu_init_llt_table,
 	.phy_iq_calibrate = rtl8723au_phy_iq_calibrate,
 	.config_channel = rtl8723au_config_channel,
+	.parse_rx_desc = rtl8723au_parse_rx_desc,
 	.writeN_block_size = 1024,
 	.mbox_ext_reg = REG_HMBOX_EXT_0,
 	.mbox_ext_width = 2,
@@ -7582,6 +7644,7 @@ static struct rtl8xxxu_fileops rtl8723bu_fops = {
 	.phy_iq_calibrate = rtl8723bu_phy_iq_calibrate,
 	.config_channel = rtl8723bu_config_channel,
 	.init_bt = rtl8723bu_init_bt,
+	.parse_rx_desc = rtl8723bu_parse_rx_desc,
 	.writeN_block_size = 1024,
 	.mbox_ext_reg = REG_HMBOX_EXT0_8723B,
 	.mbox_ext_width = 4,
@@ -7601,6 +7664,7 @@ static struct rtl8xxxu_fileops rtl8192cu_fops = {
 	.llt_init = rtl8xxxu_init_llt_table,
 	.phy_iq_calibrate = rtl8723au_phy_iq_calibrate,
 	.config_channel = rtl8723au_config_channel,
+	.parse_rx_desc = rtl8723au_parse_rx_desc,
 	.writeN_block_size = 128,
 	.mbox_ext_reg = REG_HMBOX_EXT_0,
 	.mbox_ext_width = 2,
@@ -7619,6 +7683,7 @@ static struct rtl8xxxu_fileops rtl8192eu_fops = {
 	.llt_init = rtl8xxxu_auto_llt_table,
 	.phy_iq_calibrate = rtl8723bu_phy_iq_calibrate,
 	.config_channel = rtl8723bu_config_channel,
+	.parse_rx_desc = rtl8723bu_parse_rx_desc,
 	.writeN_block_size = 128,
 	.mbox_ext_reg = REG_HMBOX_EXT0_8723B,
 	.mbox_ext_width = 4,
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
index a8a4f2b..4a3afe3 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
@@ -61,6 +61,12 @@
 #define EFUSE_BT_MAP_LEN_8723A		1024
 #define EFUSE_MAX_WORD_UNIT		4
 
+enum rtl8xxxu_rx_type {
+	RX_TYPE_DATA_PKT = 0,
+	RX_TYPE_C2H = 1,
+	RX_TYPE_ERROR = -1
+};
+
 struct rtl8xxxu_rx_desc {
 #ifdef __LITTLE_ENDIAN
 	u32 pktlen:14;
@@ -1010,6 +1016,8 @@ struct rtl8xxxu_fileops {
 	void (*phy_iq_calibrate) (struct rtl8xxxu_priv *priv);
 	void (*config_channel) (struct ieee80211_hw *hw);
 	void (*init_bt) (struct rtl8xxxu_priv *priv);
+	int (*parse_rx_desc) (struct rtl8xxxu_priv *priv, struct sk_buff *skb,
+			      struct ieee80211_rx_status *rx_status);
 	int writeN_block_size;
 	u16 mbox_ext_reg;
 	char mbox_ext_width;
-- 
2.5.0

