Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39736 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753475AbcB2WGC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 17:06:02 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 089/113] rtl8xxxu: Handle 40 byte TX descriptors for rtl8723bu
Date: Mon, 29 Feb 2016 17:05:27 -0500
Message-Id: <1456783551-28315-90-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160229_232950_846720_45E1C1D0)
In-Reply-To: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Note the descriptor checksum is still only calculated over the initial
32 bytes of the descriptor, ignoring the last 8 bytes of the
descriptor.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 35 ++++++++++++++++--------
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h |  3 +-
 2 files changed, 25 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index 6825351..c69a062 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -6787,7 +6787,12 @@ static u32 rtl8xxxu_queue_select(struct ieee80211_hw *hw, struct sk_buff *skb)
 	return queue;
 }
 
-static void rtl8xxxu_calc_tx_desc_csum(struct rtl8xxxu_tx_desc *tx_desc)
+/*
+ * Despite newer chips 8723b/8812/8821 having a larger TX descriptor
+ * format. The descriptor checksum is still only calculated over the
+ * initial 32 bytes of the descriptor!
+ */
+static void rtl8xxxu_calc_tx_desc_csum(struct rtl8723au_tx_desc *tx_desc)
 {
 	__le16 *ptr = (__le16 *)tx_desc;
 	u16 csum = 0;
@@ -6799,7 +6804,7 @@ static void rtl8xxxu_calc_tx_desc_csum(struct rtl8xxxu_tx_desc *tx_desc)
 	 */
 	tx_desc->csum = cpu_to_le16(0);
 
-	for (i = 0; i < (sizeof(struct rtl8xxxu_tx_desc) / sizeof(u16)); i++)
+	for (i = 0; i < (sizeof(struct rtl8723au_tx_desc) / sizeof(u16)); i++)
 		csum = csum ^ le16_to_cpu(ptr[i]);
 
 	tx_desc->csum |= cpu_to_le16(csum);
@@ -6868,13 +6873,15 @@ static void rtl8xxxu_tx_complete(struct urb *urb)
 	struct sk_buff *skb = (struct sk_buff *)urb->context;
 	struct ieee80211_tx_info *tx_info;
 	struct ieee80211_hw *hw;
+	struct rtl8xxxu_priv *priv;
 	struct rtl8xxxu_tx_urb *tx_urb =
 		container_of(urb, struct rtl8xxxu_tx_urb, urb);
 
 	tx_info = IEEE80211_SKB_CB(skb);
 	hw = tx_info->rate_driver_data[0];
+	priv = hw->priv;
 
-	skb_pull(skb, sizeof(struct rtl8xxxu_tx_desc));
+	skb_pull(skb, priv->fops->tx_desc_size);
 
 	ieee80211_tx_info_clear_status(tx_info);
 	tx_info->status.rates[0].idx = -1;
@@ -6885,7 +6892,7 @@ static void rtl8xxxu_tx_complete(struct urb *urb)
 
 	ieee80211_tx_status_irqsafe(hw, skb);
 
-	rtl8xxxu_free_tx_urb(hw->priv, tx_urb);
+	rtl8xxxu_free_tx_urb(priv, tx_urb);
 }
 
 static void rtl8xxxu_dump_action(struct device *dev,
@@ -6935,7 +6942,7 @@ static void rtl8xxxu_tx(struct ieee80211_hw *hw,
 	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_rate *tx_rate = ieee80211_get_tx_rate(hw, tx_info);
 	struct rtl8xxxu_priv *priv = hw->priv;
-	struct rtl8xxxu_tx_desc *tx_desc;
+	struct rtl8723au_tx_desc *tx_desc;
 	struct rtl8xxxu_tx_urb *tx_urb;
 	struct ieee80211_sta *sta = NULL;
 	struct ieee80211_vif *vif = tx_info->control.vif;
@@ -6944,16 +6951,17 @@ static void rtl8xxxu_tx(struct ieee80211_hw *hw,
 	u16 pktlen = skb->len;
 	u16 seq_number;
 	u16 rate_flag = tx_info->control.rates[0].flags;
+	int tx_desc_size = priv->fops->tx_desc_size;
 	int ret;
 
-	if (skb_headroom(skb) < sizeof(struct rtl8xxxu_tx_desc)) {
+	if (skb_headroom(skb) < tx_desc_size) {
 		dev_warn(dev,
 			 "%s: Not enough headroom (%i) for tx descriptor\n",
 			 __func__, skb_headroom(skb));
 		goto error;
 	}
 
-	if (unlikely(skb->len > (65535 - sizeof(struct rtl8xxxu_tx_desc)))) {
+	if (unlikely(skb->len > (65535 - tx_desc_size))) {
 		dev_warn(dev, "%s: Trying to send over-sized skb (%i)\n",
 			 __func__, skb->len);
 		goto error;
@@ -6977,12 +6985,11 @@ static void rtl8xxxu_tx(struct ieee80211_hw *hw,
 	if (control && control->sta)
 		sta = control->sta;
 
-	tx_desc = (struct rtl8xxxu_tx_desc *)
-		skb_push(skb, sizeof(struct rtl8xxxu_tx_desc));
+	tx_desc = (struct rtl8723au_tx_desc *)skb_push(skb, tx_desc_size);
 
-	memset(tx_desc, 0, sizeof(struct rtl8xxxu_tx_desc));
+	memset(tx_desc, 0, tx_desc_size);
 	tx_desc->pkt_size = cpu_to_le16(pktlen);
-	tx_desc->pkt_offset = sizeof(struct rtl8xxxu_tx_desc);
+	tx_desc->pkt_offset = tx_desc_size;
 
 	tx_desc->txdw0 =
 		TXDESC_OWN | TXDESC_FIRST_SEGMENT | TXDESC_LAST_SEGMENT;
@@ -8077,7 +8084,7 @@ static int rtl8xxxu_probe(struct usb_interface *interface,
 	SET_IEEE80211_DEV(priv->hw, &interface->dev);
 	SET_IEEE80211_PERM_ADDR(hw, priv->mac_addr);
 
-	hw->extra_tx_headroom = sizeof(struct rtl8xxxu_tx_desc);
+	hw->extra_tx_headroom = priv->fops->tx_desc_size;
 	ieee80211_hw_set(hw, SIGNAL_DBM);
 	/*
 	 * The firmware handles rate control
@@ -8134,6 +8141,7 @@ static struct rtl8xxxu_fileops rtl8723au_fops = {
 	.writeN_block_size = 1024,
 	.mbox_ext_reg = REG_HMBOX_EXT_0,
 	.mbox_ext_width = 2,
+	.tx_desc_size = sizeof(struct rtl8723au_tx_desc),
 	.adda_1t_init = 0x0b1b25a0,
 	.adda_1t_path_on = 0x0bdb25a0,
 	.adda_2t_path_on_a = 0x04db25a4,
@@ -8157,6 +8165,7 @@ static struct rtl8xxxu_fileops rtl8723bu_fops = {
 	.writeN_block_size = 1024,
 	.mbox_ext_reg = REG_HMBOX_EXT0_8723B,
 	.mbox_ext_width = 4,
+	.tx_desc_size = sizeof(struct rtl8723bu_tx_desc),
 	.has_s0s1 = 1,
 	.adda_1t_init = 0x01c00014,
 	.adda_1t_path_on = 0x01c00014,
@@ -8179,6 +8188,7 @@ static struct rtl8xxxu_fileops rtl8192cu_fops = {
 	.writeN_block_size = 128,
 	.mbox_ext_reg = REG_HMBOX_EXT_0,
 	.mbox_ext_width = 2,
+	.tx_desc_size = sizeof(struct rtl8723au_tx_desc),
 	.adda_1t_init = 0x0b1b25a0,
 	.adda_1t_path_on = 0x0bdb25a0,
 	.adda_2t_path_on_a = 0x04db25a4,
@@ -8200,6 +8210,7 @@ static struct rtl8xxxu_fileops rtl8192eu_fops = {
 	.writeN_block_size = 128,
 	.mbox_ext_reg = REG_HMBOX_EXT0_8723B,
 	.mbox_ext_width = 4,
+	.tx_desc_size = sizeof(struct rtl8723au_tx_desc),
 	.has_s0s1 = 1,
 	.adda_1t_init = 0x0fc01616,
 	.adda_1t_path_on = 0x0fc01616,
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
index f06b88b..d53912a 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
@@ -332,7 +332,7 @@ struct rtl8723bu_rx_desc {
 	__le32 tsfl;
 };
 
-struct rtl8xxxu_tx_desc {
+struct rtl8723au_tx_desc {
 	__le16 pkt_size;
 	u8 pkt_offset;
 	u8 txdw0;
@@ -1190,6 +1190,7 @@ struct rtl8xxxu_fileops {
 	int writeN_block_size;
 	u16 mbox_ext_reg;
 	char mbox_ext_width;
+	char tx_desc_size;
 	char has_s0s1;
 	u32 adda_1t_init;
 	u32 adda_1t_path_on;
-- 
2.5.0

