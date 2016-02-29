Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46743 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753390AbcB2WF7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 17:05:59 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 095/113] rtl8723au: Update TX descriptor words 4 and 5 definitions
Date: Mon, 29 Feb 2016 17:05:33 -0500
Message-Id: <1456783551-28315-96-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160229_232953_717100_BC11FD7E)
In-Reply-To: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

TX data words 4 and 5 differ significantly between 32 byte and 40 byte
descriptors.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 11 ++++----
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h | 32 ++++++++++++++++--------
 2 files changed, 28 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index 14f6a2b..9a1b4ee 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -7076,16 +7076,17 @@ static void rtl8xxxu_tx(struct ieee80211_hw *hw,
 	}
 	if (ieee80211_is_mgmt(hdr->frame_control)) {
 		tx_desc->txdw5 = cpu_to_le32(tx_rate->hw_value);
-		tx_desc->txdw4 |= cpu_to_le32(TXDESC_USE_DRIVER_RATE);
-		tx_desc->txdw5 |= cpu_to_le32(6 << TXDESC_RETRY_LIMIT_SHIFT);
-		tx_desc->txdw5 |= cpu_to_le32(TXDESC_RETRY_LIMIT_ENABLE);
+		tx_desc->txdw4 |= cpu_to_le32(TXDESC_USE_DRIVER_RATE_8723A);
+		tx_desc->txdw5 |=
+			cpu_to_le32(6 << TXDESC_RETRY_LIMIT_SHIFT_8723A);
+		tx_desc->txdw5 |= cpu_to_le32(TXDESC_RETRY_LIMIT_ENABLE_8723A);
 	}
 
 	if (rate_flag & IEEE80211_TX_RC_USE_RTS_CTS) {
 		/* Use RTS rate 24M - does the mac80211 tell us which to use? */
 		tx_desc->txdw4 |= cpu_to_le32(DESC_RATE_24M);
-		tx_desc->txdw4 |= cpu_to_le32(TXDESC_RTS_CTS_ENABLE);
-		tx_desc->txdw4 |= cpu_to_le32(TXDESC_HW_RTS_ENABLE);
+		tx_desc->txdw4 |= cpu_to_le32(TXDESC_RTS_CTS_ENABLE_8723A);
+		tx_desc->txdw4 |= cpu_to_le32(TXDESC_HW_RTS_ENABLE_8723A);
 	}
 
 	rtl8xxxu_calc_tx_desc_csum(tx_desc);
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
index 8f95896..5f60f19 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
@@ -467,17 +467,21 @@ struct rtl8723bu_tx_desc {
 #define TXDESC_GID_8723B		BIT(24)
 
 /* Word 3 */
+#define TXDESC_USE_DRIVER_RATE_8723B	BIT(8)
+#define TXDESC_CTS_SELF_ENABLE_8723B	BIT(11)
+#define TXDESC_RTS_CTS_ENABLE_8723B	BIT(12)
+#define TXDESC_HW_RTS_ENABLE_8723B	BIT(13)
 #define TXDESC_SEQ_SHIFT_8723A		16
 #define TXDESC_SEQ_MASK_8723A		0x0fff0000
 
 /* Word 4 */
 #define TXDESC_QOS			BIT(6)
-#define TXDESC_HW_SEQ_ENABLE		BIT(7)
-#define TXDESC_USE_DRIVER_RATE		BIT(8)
+#define TXDESC_HW_SEQ_ENABLE_8723A	BIT(7)
+#define TXDESC_USE_DRIVER_RATE_8723A	BIT(8)
 #define TXDESC_DISABLE_DATA_FB		BIT(10)
-#define TXDESC_CTS_SELF_ENABLE		BIT(11)
-#define TXDESC_RTS_CTS_ENABLE		BIT(12)
-#define TXDESC_HW_RTS_ENABLE		BIT(13)
+#define TXDESC_CTS_SELF_ENABLE_8723A	BIT(11)
+#define TXDESC_RTS_CTS_ENABLE_8723A	BIT(12)
+#define TXDESC_HW_RTS_ENABLE_8723A	BIT(13)
 #define TXDESC_PRIME_CH_OFF_LOWER	BIT(20)
 #define TXDESC_PRIME_CH_OFF_UPPER	BIT(21)
 #define TXDESC_SHORT_PREAMBLE		BIT(24)
@@ -485,19 +489,27 @@ struct rtl8723bu_tx_desc {
 #define TXDESC_RTS_DATA_BW		BIT(27)
 #define TXDESC_RTS_PRIME_CH_OFF_LOWER	BIT(28)
 #define TXDESC_RTS_PRIME_CH_OFF_UPPER	BIT(29)
+#define TXDESC_RETRY_LIMIT_ENABLE_8723B	BIT(17)
+#define TXDESC_RETRY_LIMIT_SHIFT_8723B	18
+#define TXDESC_RETRY_LIMIT_MASK_8723B	0x00fc0000
+#define TXDESC_RTS_RATE_SHIFT_8723B	24
+#define TXDESC_RTS_RATE_MASK_8723B	0x3f000000
 
 /* Word 5 */
-#define TXDESC_RTS_RATE_SHIFT		0
-#define TXDESC_RTS_RATE_MASK		0x3f
+#define TXDESC_RTS_RATE_SHIFT_8723A	0
+#define TXDESC_RTS_RATE_MASK_8723A	0x3f
 #define TXDESC_SHORT_GI			BIT(6)
 #define TXDESC_CCX_TAG			BIT(7)
-#define TXDESC_RETRY_LIMIT_ENABLE	BIT(17)
-#define TXDESC_RETRY_LIMIT_SHIFT	18
-#define TXDESC_RETRY_LIMIT_MASK		0x00fc0000
+#define TXDESC_RETRY_LIMIT_ENABLE_8723A	BIT(17)
+#define TXDESC_RETRY_LIMIT_SHIFT_8723A	18
+#define TXDESC_RETRY_LIMIT_MASK_8723A	0x00fc0000
 
 /* Word 6 */
 #define TXDESC_MAX_AGG_SHIFT		11
 
+/* Word 8 */
+#define TXDESC_HW_SEQ_ENABLE_8723B	BIT(15)
+
 /* Word 9 */
 #define TXDESC_SEQ_SHIFT_8723B		12
 #define TXDESC_SEQ_MASK_8723B		0x00fff000
-- 
2.5.0

