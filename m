Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37725 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753268AbcB2WF5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 17:05:57 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 097/113] rtl8xxxu: Improve handling of txdesc32 vs txdesc40 handling
Date: Mon, 29 Feb 2016 17:05:35 -0500
Message-Id: <1456783551-28315-98-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160229_232950_359370_90096E42)
In-Reply-To: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Further correct the handling of 40 byte TX descriptors.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 123 ++++++++++++++++-------
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h |   7 +-
 2 files changed, 92 insertions(+), 38 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index 10714e6..f4842aa 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -7018,15 +7018,6 @@ static void rtl8xxxu_tx(struct ieee80211_hw *hw,
 		}
 	}
 
-	if (rate_flag & IEEE80211_TX_RC_MCS)
-		rate = tx_info->control.rates[0].idx + DESC_RATE_MCS0;
-	else
-		rate = tx_rate->hw_value;
-	tx_desc->txdw5 = cpu_to_le32(rate);
-
-	if (ieee80211_is_data(hdr->frame_control))
-		tx_desc->txdw5 |= cpu_to_le32(0x0001ff00);
-
 	/* (tx_info->flags & IEEE80211_TX_CTL_AMPDU) && */
 	ampdu_enable = false;
 	if (ieee80211_is_data_qos(hdr->frame_control) && sta) {
@@ -7041,8 +7032,18 @@ static void rtl8xxxu_tx(struct ieee80211_hw *hw,
 		}
 	}
 
+	if (rate_flag & IEEE80211_TX_RC_MCS)
+		rate = tx_info->control.rates[0].idx + DESC_RATE_MCS0;
+	else
+		rate = tx_rate->hw_value;
+
 	seq_number = IEEE80211_SEQ_TO_SN(le16_to_cpu(hdr->seq_ctrl));
 	if (!usedesc40) {
+		tx_desc->txdw5 = cpu_to_le32(rate);
+
+		if (ieee80211_is_data(hdr->frame_control))
+			tx_desc->txdw5 |= cpu_to_le32(0x0001ff00);
+
 		tx_desc->txdw3 =
 			cpu_to_le32((u32)seq_number << TXDESC_SEQ_SHIFT_8723A);
 
@@ -7050,9 +7051,56 @@ static void rtl8xxxu_tx(struct ieee80211_hw *hw,
 			tx_desc->txdw1 |= cpu_to_le32(TXDESC_AGG_ENABLE_8723A);
 		else
 			tx_desc->txdw1 |= cpu_to_le32(TXDESC_AGG_BREAK_8723A);
+
+		if (ieee80211_is_mgmt(hdr->frame_control)) {
+			tx_desc->txdw5 = cpu_to_le32(tx_rate->hw_value);
+			tx_desc->txdw4 |=
+				cpu_to_le32(TXDESC_USE_DRIVER_RATE_8723A);
+			tx_desc->txdw5 |=
+				cpu_to_le32(6 <<
+					    TXDESC_RETRY_LIMIT_SHIFT_8723A);
+			tx_desc->txdw5 |=
+				cpu_to_le32(TXDESC_RETRY_LIMIT_ENABLE_8723A);
+		}
+
+		if (ieee80211_is_data_qos(hdr->frame_control))
+			tx_desc->txdw4 |= cpu_to_le32(TXDESC_QOS_8723A);
+
+		if (rate_flag & IEEE80211_TX_RC_USE_SHORT_PREAMBLE ||
+		    (sta && vif && vif->bss_conf.use_short_preamble))
+			tx_desc->txdw4 |=
+				cpu_to_le32(TXDESC_SHORT_PREAMBLE_8723A);
+
+		if (rate_flag & IEEE80211_TX_RC_SHORT_GI ||
+		    (ieee80211_is_data_qos(hdr->frame_control) &&
+		     sta && sta->ht_cap.cap &
+		     (IEEE80211_HT_CAP_SGI_40 | IEEE80211_HT_CAP_SGI_20))) {
+			tx_desc->txdw5 |= cpu_to_le32(TXDESC_SHORT_GI);
+		}
+
+		if (rate_flag & IEEE80211_TX_RC_USE_RTS_CTS) {
+			/*
+			 * Use RTS rate 24M - does the mac80211 tell
+			 * us which to use?
+			 */
+			tx_desc->txdw4 |=
+				cpu_to_le32(DESC_RATE_24M <<
+					    TXDESC_RTS_RATE_SHIFT_8723A);
+			tx_desc->txdw4 |=
+				cpu_to_le32(TXDESC_RTS_CTS_ENABLE_8723A);
+			tx_desc->txdw4 |=
+				cpu_to_le32(TXDESC_HW_RTS_ENABLE_8723A);
+		}
 	} else {
 		tx_desc40 = (struct rtl8723bu_tx_desc *)tx_desc;
 
+		tx_desc40->txdw4 = cpu_to_le32(rate);
+		if (ieee80211_is_data(hdr->frame_control)) {
+			tx_desc->txdw4 |=
+				cpu_to_le32(0x1f <<
+					    TXDESC_DATA_RATE_FB_SHIFT_8723B);
+		}
+
 		tx_desc40->txdw9 =
 			cpu_to_le32((u32)seq_number << TXDESC_SEQ_SHIFT_8723B);
 
@@ -7061,34 +7109,37 @@ static void rtl8xxxu_tx(struct ieee80211_hw *hw,
 				cpu_to_le32(TXDESC_AGG_ENABLE_8723B);
 		else
 			tx_desc40->txdw2 |= cpu_to_le32(TXDESC_AGG_BREAK_8723B);
-	};
 
-	if (ieee80211_is_data_qos(hdr->frame_control))
-		tx_desc->txdw4 |= cpu_to_le32(TXDESC_QOS);
-	if (rate_flag & IEEE80211_TX_RC_USE_SHORT_PREAMBLE ||
-	    (sta && vif && vif->bss_conf.use_short_preamble))
-		tx_desc->txdw4 |= cpu_to_le32(TXDESC_SHORT_PREAMBLE);
-	if (rate_flag & IEEE80211_TX_RC_SHORT_GI ||
-	    (ieee80211_is_data_qos(hdr->frame_control) &&
-	     sta && sta->ht_cap.cap &
-	     (IEEE80211_HT_CAP_SGI_40 | IEEE80211_HT_CAP_SGI_20))) {
-		tx_desc->txdw5 |= cpu_to_le32(TXDESC_SHORT_GI);
-	}
-	if (ieee80211_is_mgmt(hdr->frame_control)) {
-		tx_desc->txdw5 = cpu_to_le32(tx_rate->hw_value);
-		tx_desc->txdw4 |= cpu_to_le32(TXDESC_USE_DRIVER_RATE_8723A);
-		tx_desc->txdw5 |=
-			cpu_to_le32(6 << TXDESC_RETRY_LIMIT_SHIFT_8723A);
-		tx_desc->txdw5 |= cpu_to_le32(TXDESC_RETRY_LIMIT_ENABLE_8723A);
-	}
-
-	if (rate_flag & IEEE80211_TX_RC_USE_RTS_CTS) {
-		/* Use RTS rate 24M - does the mac80211 tell us which to use? */
-		tx_desc->txdw4 |= cpu_to_le32(DESC_RATE_24M <<
-					      TXDESC_RTS_RATE_SHIFT_8723A);
-		tx_desc->txdw4 |= cpu_to_le32(TXDESC_RTS_CTS_ENABLE_8723A);
-		tx_desc->txdw4 |= cpu_to_le32(TXDESC_HW_RTS_ENABLE_8723A);
-	}
+		if (ieee80211_is_mgmt(hdr->frame_control)) {
+			tx_desc40->txdw4 = cpu_to_le32(tx_rate->hw_value);
+			tx_desc40->txdw3 |=
+				cpu_to_le32(TXDESC_USE_DRIVER_RATE_8723B);
+			tx_desc40->txdw4 |=
+				cpu_to_le32(6 <<
+					    TXDESC_RETRY_LIMIT_SHIFT_8723B);
+			tx_desc40->txdw4 |=
+				cpu_to_le32(TXDESC_RETRY_LIMIT_ENABLE_8723B);
+		}
+
+		if (rate_flag & IEEE80211_TX_RC_USE_SHORT_PREAMBLE ||
+		    (sta && vif && vif->bss_conf.use_short_preamble))
+			tx_desc40->txdw5 |=
+				cpu_to_le32(TXDESC_SHORT_PREAMBLE_8723B);
+
+		if (rate_flag & IEEE80211_TX_RC_USE_RTS_CTS) {
+			/*
+			 * Use RTS rate 24M - does the mac80211 tell
+			 * us which to use?
+			 */
+			tx_desc->txdw4 |=
+				cpu_to_le32(DESC_RATE_24M <<
+					    TXDESC_RTS_RATE_SHIFT_8723B);
+			tx_desc->txdw3 |=
+				cpu_to_le32(TXDESC_RTS_CTS_ENABLE_8723B);
+			tx_desc->txdw3 |=
+				cpu_to_le32(TXDESC_HW_RTS_ENABLE_8723B);
+		}
+	};
 
 	rtl8xxxu_calc_tx_desc_csum(tx_desc);
 
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
index b015c75..687b9a9 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
@@ -477,7 +477,7 @@ struct rtl8723bu_tx_desc {
 /* Word 4 */
 #define TXDESC_RTS_RATE_SHIFT_8723A	0
 #define TXDESC_RTS_RATE_MASK_8723A	0x3f
-#define TXDESC_QOS			BIT(6)
+#define TXDESC_QOS_8723A		BIT(6)
 #define TXDESC_HW_SEQ_ENABLE_8723A	BIT(7)
 #define TXDESC_USE_DRIVER_RATE_8723A	BIT(8)
 #define TXDESC_DISABLE_DATA_FB		BIT(10)
@@ -486,11 +486,13 @@ struct rtl8723bu_tx_desc {
 #define TXDESC_HW_RTS_ENABLE_8723A	BIT(13)
 #define TXDESC_PRIME_CH_OFF_LOWER	BIT(20)
 #define TXDESC_PRIME_CH_OFF_UPPER	BIT(21)
-#define TXDESC_SHORT_PREAMBLE		BIT(24)
+#define TXDESC_SHORT_PREAMBLE_8723A	BIT(24)
 #define TXDESC_DATA_BW			BIT(25)
 #define TXDESC_RTS_DATA_BW		BIT(27)
 #define TXDESC_RTS_PRIME_CH_OFF_LOWER	BIT(28)
 #define TXDESC_RTS_PRIME_CH_OFF_UPPER	BIT(29)
+#define TXDESC_DATA_RATE_FB_SHIFT_8723B	8
+#define TXDESC_DATA_RATE_FB_MASK_8723B	0x00001f00
 #define TXDESC_RETRY_LIMIT_ENABLE_8723B	BIT(17)
 #define TXDESC_RETRY_LIMIT_SHIFT_8723B	18
 #define TXDESC_RETRY_LIMIT_MASK_8723B	0x00fc0000
@@ -498,6 +500,7 @@ struct rtl8723bu_tx_desc {
 #define TXDESC_RTS_RATE_MASK_8723B	0x3f000000
 
 /* Word 5 */
+#define TXDESC_SHORT_PREAMBLE_8723B	BIT(4)
 #define TXDESC_SHORT_GI			BIT(6)
 #define TXDESC_CCX_TAG			BIT(7)
 #define TXDESC_RETRY_LIMIT_ENABLE_8723A	BIT(17)
-- 
2.5.0

