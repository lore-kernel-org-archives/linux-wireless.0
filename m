Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33925 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753353AbcDNS7J (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Apr 2016 14:59:09 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net
Subject: [PATCH 11/26] rtl8xxxu: Name RX descriptor types rxdesc16/rxdesc24
Date: Thu, 14 Apr 2016 14:58:52 -0400
Message-Id: <1460660347-26299-12-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160414_212529_737081_8336E472)
In-Reply-To: <1460660347-26299-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1460660347-26299-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

This caught a bug where too little memory was allocated for RX urbs
for parts using 24 byte RX descriptors

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 38 ++++++++++++++----------
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h |  5 ++--
 2 files changed, 25 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index 6545012..4b309a6 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -8826,21 +8826,22 @@ static void rtl8xxxu_rx_urb_work(struct work_struct *work)
 	}
 }
 
-static int rtl8723au_parse_rx_desc(struct rtl8xxxu_priv *priv,
+static int rtl8xxxu_parse_rxdesc16(struct rtl8xxxu_priv *priv,
 				   struct sk_buff *skb,
 				   struct ieee80211_rx_status *rx_status)
 {
-	struct rtl8xxxu_rx_desc *rx_desc = (struct rtl8xxxu_rx_desc *)skb->data;
+	struct rtl8xxxu_rxdesc16 *rx_desc =
+		(struct rtl8xxxu_rxdesc16 *)skb->data;
 	struct rtl8723au_phy_stats *phy_stats;
 	__le32 *_rx_desc_le = (__le32 *)skb->data;
 	u32 *_rx_desc = (u32 *)skb->data;
 	int drvinfo_sz, desc_shift;
 	int i;
 
-	for (i = 0; i < (sizeof(struct rtl8xxxu_rx_desc) / sizeof(u32)); i++)
+	for (i = 0; i < (sizeof(struct rtl8xxxu_rxdesc16) / sizeof(u32)); i++)
 		_rx_desc[i] = le32_to_cpu(_rx_desc_le[i]);
 
-	skb_pull(skb, sizeof(struct rtl8xxxu_rx_desc));
+	skb_pull(skb, sizeof(struct rtl8xxxu_rxdesc16));
 
 	phy_stats = (struct rtl8723au_phy_stats *)skb->data;
 
@@ -8872,22 +8873,22 @@ static int rtl8723au_parse_rx_desc(struct rtl8xxxu_priv *priv,
 	return RX_TYPE_DATA_PKT;
 }
 
-static int rtl8723bu_parse_rx_desc(struct rtl8xxxu_priv *priv,
+static int rtl8xxxu_parse_rxdesc24(struct rtl8xxxu_priv *priv,
 				   struct sk_buff *skb,
 				   struct ieee80211_rx_status *rx_status)
 {
-	struct rtl8723bu_rx_desc *rx_desc =
-		(struct rtl8723bu_rx_desc *)skb->data;
+	struct rtl8xxxu_rxdesc24 *rx_desc =
+		(struct rtl8xxxu_rxdesc24 *)skb->data;
 	struct rtl8723au_phy_stats *phy_stats;
 	__le32 *_rx_desc_le = (__le32 *)skb->data;
 	u32 *_rx_desc = (u32 *)skb->data;
 	int drvinfo_sz, desc_shift;
 	int i;
 
-	for (i = 0; i < (sizeof(struct rtl8723bu_rx_desc) / sizeof(u32)); i++)
+	for (i = 0; i < (sizeof(struct rtl8xxxu_rxdesc24) / sizeof(u32)); i++)
 		_rx_desc[i] = le32_to_cpu(_rx_desc_le[i]);
 
-	skb_pull(skb, sizeof(struct rtl8723bu_rx_desc));
+	skb_pull(skb, sizeof(struct rtl8xxxu_rxdesc24));
 
 	phy_stats = (struct rtl8723au_phy_stats *)skb->data;
 
@@ -9018,14 +9019,15 @@ static int rtl8xxxu_submit_rx_urb(struct rtl8xxxu_priv *priv,
 {
 	struct sk_buff *skb;
 	int skb_size;
-	int ret;
+	int ret, rx_desc_sz;
 
-	skb_size = sizeof(struct rtl8xxxu_rx_desc) + RTL_RX_BUFFER_SIZE;
+	rx_desc_sz = priv->fops->rx_desc_size;
+	skb_size = rx_desc_sz + RTL_RX_BUFFER_SIZE;
 	skb = __netdev_alloc_skb(NULL, skb_size, GFP_KERNEL);
 	if (!skb)
 		return -ENOMEM;
 
-	memset(skb->data, 0, sizeof(struct rtl8xxxu_rx_desc));
+	memset(skb->data, 0, rx_desc_sz);
 	usb_fill_bulk_urb(&rx_urb->urb, priv->udev, priv->pipe_in, skb->data,
 			  skb_size, rtl8xxxu_rx_complete, skb);
 	usb_anchor_urb(&rx_urb->urb, &priv->rx_anchor);
@@ -9779,7 +9781,7 @@ static struct rtl8xxxu_fileops rtl8723au_fops = {
 	.llt_init = rtl8xxxu_init_llt_table,
 	.phy_iq_calibrate = rtl8723au_phy_iq_calibrate,
 	.config_channel = rtl8723au_config_channel,
-	.parse_rx_desc = rtl8723au_parse_rx_desc,
+	.parse_rx_desc = rtl8xxxu_parse_rxdesc16,
 	.enable_rf = rtl8723a_enable_rf,
 	.disable_rf = rtl8723a_disable_rf,
 	.set_tx_power = rtl8723a_set_tx_power,
@@ -9789,6 +9791,7 @@ static struct rtl8xxxu_fileops rtl8723au_fops = {
 	.mbox_ext_reg = REG_HMBOX_EXT_0,
 	.mbox_ext_width = 2,
 	.tx_desc_size = sizeof(struct rtl8xxxu_txdesc32),
+	.rx_desc_size = sizeof(struct rtl8xxxu_rxdesc16),
 	.adda_1t_init = 0x0b1b25a0,
 	.adda_1t_path_on = 0x0bdb25a0,
 	.adda_2t_path_on_a = 0x04db25a4,
@@ -9806,7 +9809,7 @@ static struct rtl8xxxu_fileops rtl8723bu_fops = {
 	.phy_init_antenna_selection = rtl8723bu_phy_init_antenna_selection,
 	.phy_iq_calibrate = rtl8723bu_phy_iq_calibrate,
 	.config_channel = rtl8723bu_config_channel,
-	.parse_rx_desc = rtl8723bu_parse_rx_desc,
+	.parse_rx_desc = rtl8xxxu_parse_rxdesc24,
 	.init_aggregation = rtl8723bu_init_aggregation,
 	.init_statistics = rtl8723bu_init_statistics,
 	.enable_rf = rtl8723b_enable_rf,
@@ -9818,6 +9821,7 @@ static struct rtl8xxxu_fileops rtl8723bu_fops = {
 	.mbox_ext_reg = REG_HMBOX_EXT0_8723B,
 	.mbox_ext_width = 4,
 	.tx_desc_size = sizeof(struct rtl8xxxu_txdesc40),
+	.rx_desc_size = sizeof(struct rtl8xxxu_rxdesc24),
 	.has_s0s1 = 1,
 	.adda_1t_init = 0x01c00014,
 	.adda_1t_path_on = 0x01c00014,
@@ -9837,7 +9841,7 @@ static struct rtl8xxxu_fileops rtl8192cu_fops = {
 	.llt_init = rtl8xxxu_init_llt_table,
 	.phy_iq_calibrate = rtl8723au_phy_iq_calibrate,
 	.config_channel = rtl8723au_config_channel,
-	.parse_rx_desc = rtl8723au_parse_rx_desc,
+	.parse_rx_desc = rtl8xxxu_parse_rxdesc16,
 	.enable_rf = rtl8723a_enable_rf,
 	.disable_rf = rtl8723a_disable_rf,
 	.set_tx_power = rtl8723a_set_tx_power,
@@ -9847,6 +9851,7 @@ static struct rtl8xxxu_fileops rtl8192cu_fops = {
 	.mbox_ext_reg = REG_HMBOX_EXT_0,
 	.mbox_ext_width = 2,
 	.tx_desc_size = sizeof(struct rtl8xxxu_txdesc32),
+	.rx_desc_size = sizeof(struct rtl8xxxu_rxdesc16),
 	.adda_1t_init = 0x0b1b25a0,
 	.adda_1t_path_on = 0x0bdb25a0,
 	.adda_2t_path_on_a = 0x04db25a4,
@@ -9865,7 +9870,7 @@ static struct rtl8xxxu_fileops rtl8192eu_fops = {
 	.llt_init = rtl8xxxu_auto_llt_table,
 	.phy_iq_calibrate = rtl8192eu_phy_iq_calibrate,
 	.config_channel = rtl8723bu_config_channel,
-	.parse_rx_desc = rtl8723bu_parse_rx_desc,
+	.parse_rx_desc = rtl8xxxu_parse_rxdesc24,
 	.enable_rf = rtl8723b_enable_rf,
 	.disable_rf = rtl8723b_disable_rf,
 	.set_tx_power = rtl8192e_set_tx_power,
@@ -9875,6 +9880,7 @@ static struct rtl8xxxu_fileops rtl8192eu_fops = {
 	.mbox_ext_reg = REG_HMBOX_EXT0_8723B,
 	.mbox_ext_width = 4,
 	.tx_desc_size = sizeof(struct rtl8xxxu_txdesc40),
+	.rx_desc_size = sizeof(struct rtl8xxxu_rxdesc24),
 	.has_s0s1 = 0,
 	.adda_1t_init = 0x0fc01616,
 	.adda_1t_path_on = 0x0fc01616,
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
index 4545e10..2f0709e 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
@@ -101,7 +101,7 @@ enum rtl8xxxu_rx_type {
 	RX_TYPE_ERROR = -1
 };
 
-struct rtl8xxxu_rx_desc {
+struct rtl8xxxu_rxdesc16 {
 #ifdef __LITTLE_ENDIAN
 	u32 pktlen:14;
 	u32 crc32:1;
@@ -237,7 +237,7 @@ struct rtl8xxxu_rx_desc {
 #endif
 };
 
-struct rtl8723bu_rx_desc {
+struct rtl8xxxu_rxdesc24 {
 #ifdef __LITTLE_ENDIAN
 	u32 pktlen:14;
 	u32 crc32:1;
@@ -1303,6 +1303,7 @@ struct rtl8xxxu_fileops {
 	u16 mbox_ext_reg;
 	char mbox_ext_width;
 	char tx_desc_size;
+	char rx_desc_size;
 	char has_s0s1;
 	u32 adda_1t_init;
 	u32 adda_1t_path_on;
-- 
2.5.5

