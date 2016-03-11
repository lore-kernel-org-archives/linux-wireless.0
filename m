Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36802 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932308AbcCKT5g (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Mar 2016 14:57:36 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net
Subject: [PATCH 1/7] rtl8xxxu: Change name of struct tx_desc to be more decriptive
Date: Fri, 11 Mar 2016 14:57:28 -0500
Message-Id: <1457726254-28178-2-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160311_205748_138626_4255D594)
In-Reply-To: <1457726254-28178-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1457726254-28178-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

There are two major types of TX descriptor formats for the RTL parts,
the old 32 byte descriptor, and the newer 40 byte descriptor used by
the 8723bu, 8192eu, and 88xx series.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 20 ++++++++++----------
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h |  4 ++--
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index abdff45..13feb18 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -7014,7 +7014,7 @@ static u32 rtl8xxxu_queue_select(struct ieee80211_hw *hw, struct sk_buff *skb)
  * format. The descriptor checksum is still only calculated over the
  * initial 32 bytes of the descriptor!
  */
-static void rtl8xxxu_calc_tx_desc_csum(struct rtl8723au_tx_desc *tx_desc)
+static void rtl8xxxu_calc_tx_desc_csum(struct rtl8xxxu_txdesc32 *tx_desc)
 {
 	__le16 *ptr = (__le16 *)tx_desc;
 	u16 csum = 0;
@@ -7026,7 +7026,7 @@ static void rtl8xxxu_calc_tx_desc_csum(struct rtl8723au_tx_desc *tx_desc)
 	 */
 	tx_desc->csum = cpu_to_le16(0);
 
-	for (i = 0; i < (sizeof(struct rtl8723au_tx_desc) / sizeof(u16)); i++)
+	for (i = 0; i < (sizeof(struct rtl8xxxu_txdesc32) / sizeof(u16)); i++)
 		csum = csum ^ le16_to_cpu(ptr[i]);
 
 	tx_desc->csum |= cpu_to_le16(csum);
@@ -7164,8 +7164,8 @@ static void rtl8xxxu_tx(struct ieee80211_hw *hw,
 	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_rate *tx_rate = ieee80211_get_tx_rate(hw, tx_info);
 	struct rtl8xxxu_priv *priv = hw->priv;
-	struct rtl8723au_tx_desc *tx_desc;
-	struct rtl8723bu_tx_desc *tx_desc40;
+	struct rtl8xxxu_txdesc32 *tx_desc;
+	struct rtl8xxxu_txdesc40 *tx_desc40;
 	struct rtl8xxxu_tx_urb *tx_urb;
 	struct ieee80211_sta *sta = NULL;
 	struct ieee80211_vif *vif = tx_info->control.vif;
@@ -7210,7 +7210,7 @@ static void rtl8xxxu_tx(struct ieee80211_hw *hw,
 	if (control && control->sta)
 		sta = control->sta;
 
-	tx_desc = (struct rtl8723au_tx_desc *)skb_push(skb, tx_desc_size);
+	tx_desc = (struct rtl8xxxu_txdesc32 *)skb_push(skb, tx_desc_size);
 
 	memset(tx_desc, 0, tx_desc_size);
 	tx_desc->pkt_size = cpu_to_le16(pktlen);
@@ -7314,7 +7314,7 @@ static void rtl8xxxu_tx(struct ieee80211_hw *hw,
 				cpu_to_le32(TXDESC_HW_RTS_ENABLE_8723A);
 		}
 	} else {
-		tx_desc40 = (struct rtl8723bu_tx_desc *)tx_desc;
+		tx_desc40 = (struct rtl8xxxu_txdesc40 *)tx_desc;
 
 		tx_desc40->txdw4 = cpu_to_le32(rate);
 		if (ieee80211_is_data(hdr->frame_control)) {
@@ -8454,7 +8454,7 @@ static struct rtl8xxxu_fileops rtl8723au_fops = {
 	.writeN_block_size = 1024,
 	.mbox_ext_reg = REG_HMBOX_EXT_0,
 	.mbox_ext_width = 2,
-	.tx_desc_size = sizeof(struct rtl8723au_tx_desc),
+	.tx_desc_size = sizeof(struct rtl8xxxu_txdesc32),
 	.adda_1t_init = 0x0b1b25a0,
 	.adda_1t_path_on = 0x0bdb25a0,
 	.adda_2t_path_on_a = 0x04db25a4,
@@ -8482,7 +8482,7 @@ static struct rtl8xxxu_fileops rtl8723bu_fops = {
 	.writeN_block_size = 1024,
 	.mbox_ext_reg = REG_HMBOX_EXT0_8723B,
 	.mbox_ext_width = 4,
-	.tx_desc_size = sizeof(struct rtl8723bu_tx_desc),
+	.tx_desc_size = sizeof(struct rtl8xxxu_txdesc40),
 	.has_s0s1 = 1,
 	.adda_1t_init = 0x01c00014,
 	.adda_1t_path_on = 0x01c00014,
@@ -8510,7 +8510,7 @@ static struct rtl8xxxu_fileops rtl8192cu_fops = {
 	.writeN_block_size = 128,
 	.mbox_ext_reg = REG_HMBOX_EXT_0,
 	.mbox_ext_width = 2,
-	.tx_desc_size = sizeof(struct rtl8723au_tx_desc),
+	.tx_desc_size = sizeof(struct rtl8xxxu_txdesc32),
 	.adda_1t_init = 0x0b1b25a0,
 	.adda_1t_path_on = 0x0bdb25a0,
 	.adda_2t_path_on_a = 0x04db25a4,
@@ -8537,7 +8537,7 @@ static struct rtl8xxxu_fileops rtl8192eu_fops = {
 	.writeN_block_size = 128,
 	.mbox_ext_reg = REG_HMBOX_EXT0_8723B,
 	.mbox_ext_width = 4,
-	.tx_desc_size = sizeof(struct rtl8723au_tx_desc),
+	.tx_desc_size = sizeof(struct rtl8xxxu_txdesc32),
 	.has_s0s1 = 1,
 	.adda_1t_init = 0x0fc01616,
 	.adda_1t_path_on = 0x0fc01616,
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
index 7b73654..05579a0 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
@@ -332,7 +332,7 @@ struct rtl8723bu_rx_desc {
 	__le32 tsfl;
 };
 
-struct rtl8723au_tx_desc {
+struct rtl8xxxu_txdesc32 {
 	__le16 pkt_size;
 	u8 pkt_offset;
 	u8 txdw0;
@@ -346,7 +346,7 @@ struct rtl8723au_tx_desc {
 	__le16 txdw7;
 };
 
-struct rtl8723bu_tx_desc {
+struct rtl8xxxu_txdesc40 {
 	__le16 pkt_size;
 	u8 pkt_offset;
 	u8 txdw0;
-- 
2.5.0

