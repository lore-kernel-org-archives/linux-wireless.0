Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49047 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753232AbcB2WF5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 17:05:57 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 094/113] rtl8xxxu: Set sequence number correctly for 40 byte TX descriptors
Date: Mon, 29 Feb 2016 17:05:32 -0500
Message-Id: <1456783551-28315-95-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160229_230806_827019_1AE417DD)
In-Reply-To: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

SEQ changed location in the 40 byte TX descriptor. Set it correctly.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 24 ++++++++++++++++--------
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h |  8 ++++++--
 2 files changed, 22 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index 48a669e..14f6a2b 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -6943,6 +6943,7 @@ static void rtl8xxxu_tx(struct ieee80211_hw *hw,
 	struct ieee80211_rate *tx_rate = ieee80211_get_tx_rate(hw, tx_info);
 	struct rtl8xxxu_priv *priv = hw->priv;
 	struct rtl8723au_tx_desc *tx_desc;
+	struct rtl8723bu_tx_desc *tx_desc40;
 	struct rtl8xxxu_tx_urb *tx_urb;
 	struct ieee80211_sta *sta = NULL;
 	struct ieee80211_vif *vif = tx_info->control.vif;
@@ -6953,7 +6954,7 @@ static void rtl8xxxu_tx(struct ieee80211_hw *hw,
 	u16 rate_flag = tx_info->control.rates[0].flags;
 	int tx_desc_size = priv->fops->tx_desc_size;
 	int ret;
-	bool txdesc40, ampdu_enable;
+	bool usedesc40, ampdu_enable;
 
 	if (skb_headroom(skb) < tx_desc_size) {
 		dev_warn(dev,
@@ -6981,7 +6982,7 @@ static void rtl8xxxu_tx(struct ieee80211_hw *hw,
 	if (ieee80211_is_action(hdr->frame_control))
 		rtl8xxxu_dump_action(dev, hdr);
 
-	txdesc40 = (tx_desc_size == 40);
+	usedesc40 = (tx_desc_size == 40);
 	tx_info->rate_driver_data[0] = hw;
 
 	if (control && control->sta)
@@ -7017,9 +7018,6 @@ static void rtl8xxxu_tx(struct ieee80211_hw *hw,
 		}
 	}
 
-	seq_number = IEEE80211_SEQ_TO_SN(le16_to_cpu(hdr->seq_ctrl));
-	tx_desc->txdw3 = cpu_to_le32((u32)seq_number << TXDESC_SEQ_SHIFT);
-
 	if (rate_flag & IEEE80211_TX_RC_MCS)
 		rate = tx_info->control.rates[0].idx + DESC_RATE_MCS0;
 	else
@@ -7043,16 +7041,26 @@ static void rtl8xxxu_tx(struct ieee80211_hw *hw,
 		}
 	}
 
-	if (!txdesc40) {
+	seq_number = IEEE80211_SEQ_TO_SN(le16_to_cpu(hdr->seq_ctrl));
+	if (!usedesc40) {
+		tx_desc->txdw3 =
+			cpu_to_le32((u32)seq_number << TXDESC_SEQ_SHIFT_8723A);
+
 		if (ampdu_enable)
 			tx_desc->txdw1 |= cpu_to_le32(TXDESC_AGG_ENABLE_8723A);
 		else
 			tx_desc->txdw1 |= cpu_to_le32(TXDESC_AGG_BREAK_8723A);
 	} else {
+		tx_desc40 = (struct rtl8723bu_tx_desc *)tx_desc;
+
+		tx_desc40->txdw9 =
+			cpu_to_le32((u32)seq_number << TXDESC_SEQ_SHIFT_8723B);
+
 		if (ampdu_enable)
-			tx_desc->txdw2 |= cpu_to_le32(TXDESC_AGG_ENABLE_8723B);
+			tx_desc40->txdw2 |=
+				cpu_to_le32(TXDESC_AGG_ENABLE_8723B);
 		else
-			tx_desc->txdw2 |= cpu_to_le32(TXDESC_AGG_BREAK_8723B);
+			tx_desc40->txdw2 |= cpu_to_le32(TXDESC_AGG_BREAK_8723B);
 	};
 
 	if (ieee80211_is_data_qos(hdr->frame_control))
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
index 6ba12ab..8f95896 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
@@ -467,8 +467,8 @@ struct rtl8723bu_tx_desc {
 #define TXDESC_GID_8723B		BIT(24)
 
 /* Word 3 */
-#define TXDESC_SEQ_SHIFT		16
-#define TXDESC_SEQ_MASK			0x0fff0000
+#define TXDESC_SEQ_SHIFT_8723A		16
+#define TXDESC_SEQ_MASK_8723A		0x0fff0000
 
 /* Word 4 */
 #define TXDESC_QOS			BIT(6)
@@ -498,6 +498,10 @@ struct rtl8723bu_tx_desc {
 /* Word 6 */
 #define TXDESC_MAX_AGG_SHIFT		11
 
+/* Word 9 */
+#define TXDESC_SEQ_SHIFT_8723B		12
+#define TXDESC_SEQ_MASK_8723B		0x00fff000
+
 struct phy_rx_agc_info {
 #ifdef __LITTLE_ENDIAN
 	u8	gain:7, trsw:1;
-- 
2.5.0

