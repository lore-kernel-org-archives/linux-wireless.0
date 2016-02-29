Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11222 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753540AbcB2WGE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 17:06:04 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 092/113] rtl8xxxu: Add more 40 byte TX desc bit definitions
Date: Mon, 29 Feb 2016 17:05:30 -0500
Message-Id: <1456783551-28315-93-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160229_230637_504041_4F1584EA)
In-Reply-To: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Add additional bit definitions for 40 byte TX descriptors, and rename
bits for 32 byte descriptors that are located differently in the 40
byte descriptor format.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c |  7 +++---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h | 27 +++++++++++++++++++++---
 2 files changed, 28 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index d137915c..62ed6af 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -7035,11 +7035,12 @@ static void rtl8xxxu_tx(struct ieee80211_hw *hw,
 			ampdu = (u32)sta->ht_cap.ampdu_density;
 			val32 = ampdu << TXDESC_AMPDU_DENSITY_SHIFT;
 			tx_desc->txdw2 |= cpu_to_le32(val32);
-			tx_desc->txdw1 |= cpu_to_le32(TXDESC_AGG_ENABLE);
+
+			tx_desc->txdw1 |= cpu_to_le32(TXDESC_AGG_ENABLE_8723A);
 		} else
-			tx_desc->txdw1 |= cpu_to_le32(TXDESC_BK);
+			tx_desc->txdw1 |= cpu_to_le32(TXDESC_AGG_BREAK_8723A);
 	} else
-		tx_desc->txdw1 |= cpu_to_le32(TXDESC_BK);
+		tx_desc->txdw1 |= cpu_to_le32(TXDESC_AGG_BREAK_8723A);
 
 	if (ieee80211_is_data_qos(hdr->frame_control))
 		tx_desc->txdw4 |= cpu_to_le32(TXDESC_QOS);
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
index 9364a31..6ba12ab 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
@@ -417,9 +417,15 @@ struct rtl8723bu_tx_desc {
 #endif
 
 /* Word 1 */
+/*
+ * Bits 0-7 differ dependent on chip generation. For 8723au bits 5/6 are
+ * aggregation enable and break respectively. For 8723bu, bits 0-7 are macid.
+ */
 #define TXDESC_PKT_OFFSET_SZ		0
-#define TXDESC_AGG_ENABLE		BIT(5)
-#define TXDESC_BK			BIT(6)
+#define TXDESC_AGG_ENABLE_8723A		BIT(5)
+#define TXDESC_AGG_BREAK_8723A		BIT(6)
+#define TXDESC_MACID_SHIFT_8723B	0
+#define TXDESC_MACID_MASK_8723B		0x00f0
 #define TXDESC_QUEUE_SHIFT		8
 #define TXDESC_QUEUE_MASK		0x1f00
 #define TXDESC_QUEUE_BK			0x2
@@ -431,6 +437,9 @@ struct rtl8723bu_tx_desc {
 #define TXDESC_QUEUE_MGNT		0x12
 #define TXDESC_QUEUE_CMD		0x13
 #define TXDESC_QUEUE_MAX		(TXDESC_QUEUE_CMD + 1)
+#define TXDESC_RDG_NAV_EXT_8723B	BIT(13)
+#define TXDESC_LSIG_TXOP_ENABLE_8723B	BIT(14)
+#define TXDESC_PIFS_8723B		BIT(15)
 
 #define DESC_RATE_ID_SHIFT		16
 #define DESC_RATE_ID_MASK		0xf
@@ -442,8 +451,20 @@ struct rtl8723bu_tx_desc {
 #define TXDESC_HWPC			BIT(31)
 
 /* Word 2 */
-#define TXDESC_ACK_REPORT		BIT(19)
+#define TXDESC_PAID_SHIFT_8723B		0
+#define TXDESC_PAID_MASK_8723B		0x1ff
+#define TXDESC_CCA_RTS_SHIFT_8723B	10
+#define TXDESC_CCA_RTS_MASK_8723B	0xc00
+#define TXDESC_AGG_ENABLE_8723B		BIT(12)
+#define TXDESC_RDG_ENABLE_8723B		BIT(13)
+#define TXDESC_AGG_BREAK_8723B		BIT(16)
+#define TXDESC_MORE_FRAG_8723B		BIT(17)
+#define TXDESC_RAW_8723B		BIT(18)
+#define TXDESC_ACK_REPORT_8723A		BIT(19)
+#define TXDESC_SPE_RPT_8723B		BIT(19)
 #define TXDESC_AMPDU_DENSITY_SHIFT	20
+#define TXDESC_BT_INT_8723B		BIT(23)
+#define TXDESC_GID_8723B		BIT(24)
 
 /* Word 3 */
 #define TXDESC_SEQ_SHIFT		16
-- 
2.5.0

