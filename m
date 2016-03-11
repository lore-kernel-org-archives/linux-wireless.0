Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40353 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932159AbcCKT5f (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Mar 2016 14:57:35 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net
Subject: [PATCH 2/7] rtl8xxxu: Rename TX descriptor bits to map them to 32/40 byte descriptors
Date: Fri, 11 Mar 2016 14:57:29 -0500
Message-Id: <1457726254-28178-3-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160311_205739_444295_8C5D7862)
In-Reply-To: <1457726254-28178-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1457726254-28178-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

With the size based naming of TX descriptors. Change the bit
definition namings to indicate which descriptor format they match,
rather than having a device name in the bit name.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 51 ++++++------
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h | 98 ++++++++++++------------
 2 files changed, 71 insertions(+), 78 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index 13feb18..d736316 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -7267,31 +7267,29 @@ static void rtl8xxxu_tx(struct ieee80211_hw *hw,
 			tx_desc->txdw5 |= cpu_to_le32(0x0001ff00);
 
 		tx_desc->txdw3 =
-			cpu_to_le32((u32)seq_number << TXDESC_SEQ_SHIFT_8723A);
+			cpu_to_le32((u32)seq_number << TXDESC32_SEQ_SHIFT);
 
 		if (ampdu_enable)
-			tx_desc->txdw1 |= cpu_to_le32(TXDESC_AGG_ENABLE_8723A);
+			tx_desc->txdw1 |= cpu_to_le32(TXDESC32_AGG_ENABLE);
 		else
-			tx_desc->txdw1 |= cpu_to_le32(TXDESC_AGG_BREAK_8723A);
+			tx_desc->txdw1 |= cpu_to_le32(TXDESC32_AGG_BREAK);
 
 		if (ieee80211_is_mgmt(hdr->frame_control)) {
 			tx_desc->txdw5 = cpu_to_le32(tx_rate->hw_value);
 			tx_desc->txdw4 |=
-				cpu_to_le32(TXDESC_USE_DRIVER_RATE_8723A);
+				cpu_to_le32(TXDESC32_USE_DRIVER_RATE);
 			tx_desc->txdw5 |=
-				cpu_to_le32(6 <<
-					    TXDESC_RETRY_LIMIT_SHIFT_8723A);
+				cpu_to_le32(6 << TXDESC32_RETRY_LIMIT_SHIFT);
 			tx_desc->txdw5 |=
-				cpu_to_le32(TXDESC_RETRY_LIMIT_ENABLE_8723A);
+				cpu_to_le32(TXDESC32_RETRY_LIMIT_ENABLE);
 		}
 
 		if (ieee80211_is_data_qos(hdr->frame_control))
-			tx_desc->txdw4 |= cpu_to_le32(TXDESC_QOS_8723A);
+			tx_desc->txdw4 |= cpu_to_le32(TXDESC32_QOS);
 
 		if (rate_flag & IEEE80211_TX_RC_USE_SHORT_PREAMBLE ||
 		    (sta && vif && vif->bss_conf.use_short_preamble))
-			tx_desc->txdw4 |=
-				cpu_to_le32(TXDESC_SHORT_PREAMBLE_8723A);
+			tx_desc->txdw4 |= cpu_to_le32(TXDESC32_SHORT_PREAMBLE);
 
 		if (rate_flag & IEEE80211_TX_RC_SHORT_GI ||
 		    (ieee80211_is_data_qos(hdr->frame_control) &&
@@ -7307,11 +7305,10 @@ static void rtl8xxxu_tx(struct ieee80211_hw *hw,
 			 */
 			tx_desc->txdw4 |=
 				cpu_to_le32(DESC_RATE_24M <<
-					    TXDESC_RTS_RATE_SHIFT_8723A);
-			tx_desc->txdw4 |=
-				cpu_to_le32(TXDESC_RTS_CTS_ENABLE_8723A);
+					    TXDESC32_RTS_RATE_SHIFT);
 			tx_desc->txdw4 |=
-				cpu_to_le32(TXDESC_HW_RTS_ENABLE_8723A);
+				cpu_to_le32(TXDESC32_RTS_CTS_ENABLE);
+			tx_desc->txdw4 |= cpu_to_le32(TXDESC32_HW_RTS_ENABLE);
 		}
 	} else {
 		tx_desc40 = (struct rtl8xxxu_txdesc40 *)tx_desc;
@@ -7320,33 +7317,31 @@ static void rtl8xxxu_tx(struct ieee80211_hw *hw,
 		if (ieee80211_is_data(hdr->frame_control)) {
 			tx_desc->txdw4 |=
 				cpu_to_le32(0x1f <<
-					    TXDESC_DATA_RATE_FB_SHIFT_8723B);
+					    TXDESC40_DATA_RATE_FB_SHIFT);
 		}
 
 		tx_desc40->txdw9 =
-			cpu_to_le32((u32)seq_number << TXDESC_SEQ_SHIFT_8723B);
+			cpu_to_le32((u32)seq_number << TXDESC40_SEQ_SHIFT);
 
 		if (ampdu_enable)
-			tx_desc40->txdw2 |=
-				cpu_to_le32(TXDESC_AGG_ENABLE_8723B);
+			tx_desc40->txdw2 |= cpu_to_le32(TXDESC40_AGG_ENABLE);
 		else
-			tx_desc40->txdw2 |= cpu_to_le32(TXDESC_AGG_BREAK_8723B);
+			tx_desc40->txdw2 |= cpu_to_le32(TXDESC40_AGG_BREAK);
 
 		if (ieee80211_is_mgmt(hdr->frame_control)) {
 			tx_desc40->txdw4 = cpu_to_le32(tx_rate->hw_value);
 			tx_desc40->txdw3 |=
-				cpu_to_le32(TXDESC_USE_DRIVER_RATE_8723B);
+				cpu_to_le32(TXDESC40_USE_DRIVER_RATE);
 			tx_desc40->txdw4 |=
-				cpu_to_le32(6 <<
-					    TXDESC_RETRY_LIMIT_SHIFT_8723B);
+				cpu_to_le32(6 << TXDESC40_RETRY_LIMIT_SHIFT);
 			tx_desc40->txdw4 |=
-				cpu_to_le32(TXDESC_RETRY_LIMIT_ENABLE_8723B);
+				cpu_to_le32(TXDESC40_RETRY_LIMIT_ENABLE);
 		}
 
 		if (rate_flag & IEEE80211_TX_RC_USE_SHORT_PREAMBLE ||
 		    (sta && vif && vif->bss_conf.use_short_preamble))
 			tx_desc40->txdw5 |=
-				cpu_to_le32(TXDESC_SHORT_PREAMBLE_8723B);
+				cpu_to_le32(TXDESC40_SHORT_PREAMBLE);
 
 		if (rate_flag & IEEE80211_TX_RC_USE_RTS_CTS) {
 			/*
@@ -7355,11 +7350,9 @@ static void rtl8xxxu_tx(struct ieee80211_hw *hw,
 			 */
 			tx_desc->txdw4 |=
 				cpu_to_le32(DESC_RATE_24M <<
-					    TXDESC_RTS_RATE_SHIFT_8723B);
-			tx_desc->txdw3 |=
-				cpu_to_le32(TXDESC_RTS_CTS_ENABLE_8723B);
-			tx_desc->txdw3 |=
-				cpu_to_le32(TXDESC_HW_RTS_ENABLE_8723B);
+					    TXDESC40_RTS_RATE_SHIFT);
+			tx_desc->txdw3 |= cpu_to_le32(TXDESC40_RTS_CTS_ENABLE);
+			tx_desc->txdw3 |= cpu_to_le32(TXDESC40_HW_RTS_ENABLE);
 		}
 	}
 
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
index 05579a0..38d4f56 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
@@ -422,10 +422,10 @@ struct rtl8xxxu_txdesc40 {
  * aggregation enable and break respectively. For 8723bu, bits 0-7 are macid.
  */
 #define TXDESC_PKT_OFFSET_SZ		0
-#define TXDESC_AGG_ENABLE_8723A		BIT(5)
-#define TXDESC_AGG_BREAK_8723A		BIT(6)
-#define TXDESC_MACID_SHIFT_8723B	0
-#define TXDESC_MACID_MASK_8723B		0x00f0
+#define TXDESC32_AGG_ENABLE		BIT(5)
+#define TXDESC32_AGG_BREAK		BIT(6)
+#define TXDESC40_MACID_SHIFT		0
+#define TXDESC40_MACID_MASK		0x00f0
 #define TXDESC_QUEUE_SHIFT		8
 #define TXDESC_QUEUE_MASK		0x1f00
 #define TXDESC_QUEUE_BK			0x2
@@ -437,9 +437,9 @@ struct rtl8xxxu_txdesc40 {
 #define TXDESC_QUEUE_MGNT		0x12
 #define TXDESC_QUEUE_CMD		0x13
 #define TXDESC_QUEUE_MAX		(TXDESC_QUEUE_CMD + 1)
-#define TXDESC_RDG_NAV_EXT_8723B	BIT(13)
-#define TXDESC_LSIG_TXOP_ENABLE_8723B	BIT(14)
-#define TXDESC_PIFS_8723B		BIT(15)
+#define TXDESC40_RDG_NAV_EXT		BIT(13)
+#define TXDESC40_LSIG_TXOP_ENABLE	BIT(14)
+#define TXDESC40_PIFS			BIT(15)
 
 #define DESC_RATE_ID_SHIFT		16
 #define DESC_RATE_ID_MASK		0xf
@@ -451,71 +451,71 @@ struct rtl8xxxu_txdesc40 {
 #define TXDESC_HWPC			BIT(31)
 
 /* Word 2 */
-#define TXDESC_PAID_SHIFT_8723B		0
-#define TXDESC_PAID_MASK_8723B		0x1ff
-#define TXDESC_CCA_RTS_SHIFT_8723B	10
-#define TXDESC_CCA_RTS_MASK_8723B	0xc00
-#define TXDESC_AGG_ENABLE_8723B		BIT(12)
-#define TXDESC_RDG_ENABLE_8723B		BIT(13)
-#define TXDESC_AGG_BREAK_8723B		BIT(16)
-#define TXDESC_MORE_FRAG_8723B		BIT(17)
-#define TXDESC_RAW_8723B		BIT(18)
-#define TXDESC_ACK_REPORT_8723A		BIT(19)
-#define TXDESC_SPE_RPT_8723B		BIT(19)
+#define TXDESC40_PAID_SHIFT		0
+#define TXDESC40_PAID_MASK		0x1ff
+#define TXDESC40_CCA_RTS_SHIFT		10
+#define TXDESC40_CCA_RTS_MASK		0xc00
+#define TXDESC40_AGG_ENABLE		BIT(12)
+#define TXDESC40_RDG_ENABLE		BIT(13)
+#define TXDESC40_AGG_BREAK		BIT(16)
+#define TXDESC40_MORE_FRAG		BIT(17)
+#define TXDESC40_RAW			BIT(18)
+#define TXDESC32_ACK_REPORT		BIT(19)
+#define TXDESC40_SPE_RPT		BIT(19)
 #define TXDESC_AMPDU_DENSITY_SHIFT	20
-#define TXDESC_BT_INT_8723B		BIT(23)
-#define TXDESC_GID_8723B		BIT(24)
+#define TXDESC40_BT_INT			BIT(23)
+#define TXDESC40_GID			BIT(24)
 
 /* Word 3 */
-#define TXDESC_USE_DRIVER_RATE_8723B	BIT(8)
-#define TXDESC_CTS_SELF_ENABLE_8723B	BIT(11)
-#define TXDESC_RTS_CTS_ENABLE_8723B	BIT(12)
-#define TXDESC_HW_RTS_ENABLE_8723B	BIT(13)
-#define TXDESC_SEQ_SHIFT_8723A		16
-#define TXDESC_SEQ_MASK_8723A		0x0fff0000
+#define TXDESC40_USE_DRIVER_RATE	BIT(8)
+#define TXDESC40_CTS_SELF_ENABLE	BIT(11)
+#define TXDESC40_RTS_CTS_ENABLE		BIT(12)
+#define TXDESC40_HW_RTS_ENABLE		BIT(13)
+#define TXDESC32_SEQ_SHIFT		16
+#define TXDESC32_SEQ_MASK		0x0fff0000
 
 /* Word 4 */
-#define TXDESC_RTS_RATE_SHIFT_8723A	0
-#define TXDESC_RTS_RATE_MASK_8723A	0x3f
-#define TXDESC_QOS_8723A		BIT(6)
-#define TXDESC_HW_SEQ_ENABLE_8723A	BIT(7)
-#define TXDESC_USE_DRIVER_RATE_8723A	BIT(8)
+#define TXDESC32_RTS_RATE_SHIFT		0
+#define TXDESC32_RTS_RATE_MASK		0x3f
+#define TXDESC32_QOS			BIT(6)
+#define TXDESC32_HW_SEQ_ENABLE		BIT(7)
+#define TXDESC32_USE_DRIVER_RATE	BIT(8)
 #define TXDESC_DISABLE_DATA_FB		BIT(10)
-#define TXDESC_CTS_SELF_ENABLE_8723A	BIT(11)
-#define TXDESC_RTS_CTS_ENABLE_8723A	BIT(12)
-#define TXDESC_HW_RTS_ENABLE_8723A	BIT(13)
+#define TXDESC32_CTS_SELF_ENABLE	BIT(11)
+#define TXDESC32_RTS_CTS_ENABLE		BIT(12)
+#define TXDESC32_HW_RTS_ENABLE		BIT(13)
 #define TXDESC_PRIME_CH_OFF_LOWER	BIT(20)
 #define TXDESC_PRIME_CH_OFF_UPPER	BIT(21)
-#define TXDESC_SHORT_PREAMBLE_8723A	BIT(24)
+#define TXDESC32_SHORT_PREAMBLE		BIT(24)
 #define TXDESC_DATA_BW			BIT(25)
 #define TXDESC_RTS_DATA_BW		BIT(27)
 #define TXDESC_RTS_PRIME_CH_OFF_LOWER	BIT(28)
 #define TXDESC_RTS_PRIME_CH_OFF_UPPER	BIT(29)
-#define TXDESC_DATA_RATE_FB_SHIFT_8723B	8
-#define TXDESC_DATA_RATE_FB_MASK_8723B	0x00001f00
-#define TXDESC_RETRY_LIMIT_ENABLE_8723B	BIT(17)
-#define TXDESC_RETRY_LIMIT_SHIFT_8723B	18
-#define TXDESC_RETRY_LIMIT_MASK_8723B	0x00fc0000
-#define TXDESC_RTS_RATE_SHIFT_8723B	24
-#define TXDESC_RTS_RATE_MASK_8723B	0x3f000000
+#define TXDESC40_DATA_RATE_FB_SHIFT	8
+#define TXDESC40_DATA_RATE_FB_MASK	0x00001f00
+#define TXDESC40_RETRY_LIMIT_ENABLE	BIT(17)
+#define TXDESC40_RETRY_LIMIT_SHIFT	18
+#define TXDESC40_RETRY_LIMIT_MASK	0x00fc0000
+#define TXDESC40_RTS_RATE_SHIFT		24
+#define TXDESC40_RTS_RATE_MASK		0x3f000000
 
 /* Word 5 */
-#define TXDESC_SHORT_PREAMBLE_8723B	BIT(4)
+#define TXDESC40_SHORT_PREAMBLE		BIT(4)
 #define TXDESC_SHORT_GI			BIT(6)
 #define TXDESC_CCX_TAG			BIT(7)
-#define TXDESC_RETRY_LIMIT_ENABLE_8723A	BIT(17)
-#define TXDESC_RETRY_LIMIT_SHIFT_8723A	18
-#define TXDESC_RETRY_LIMIT_MASK_8723A	0x00fc0000
+#define TXDESC32_RETRY_LIMIT_ENABLE	BIT(17)
+#define TXDESC32_RETRY_LIMIT_SHIFT	18
+#define TXDESC32_RETRY_LIMIT_MASK	0x00fc0000
 
 /* Word 6 */
 #define TXDESC_MAX_AGG_SHIFT		11
 
 /* Word 8 */
-#define TXDESC_HW_SEQ_ENABLE_8723B	BIT(15)
+#define TXDESC40_HW_SEQ_ENABLE		BIT(15)
 
 /* Word 9 */
-#define TXDESC_SEQ_SHIFT_8723B		12
-#define TXDESC_SEQ_MASK_8723B		0x00fff000
+#define TXDESC40_SEQ_SHIFT		12
+#define TXDESC40_SEQ_MASK		0x00fff000
 
 struct phy_rx_agc_info {
 #ifdef __LITTLE_ENDIAN
-- 
2.5.0

