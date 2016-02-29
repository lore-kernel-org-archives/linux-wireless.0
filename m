Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52332 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753559AbcB2WGE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 17:06:04 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 096/113] rtl8xxxu: TX RTS rate is word 4 for 8723a
Date: Mon, 29 Feb 2016 17:05:34 -0500
Message-Id: <1456783551-28315-97-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160229_230638_405072_F213246E)
In-Reply-To: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Correct the setting of TX RTS for 8723a generation chips. In addition
update documentation to match that this is part of data word 4, note
data word 5.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 3 ++-
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h | 4 ++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index 9a1b4ee..10714e6 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -7084,7 +7084,8 @@ static void rtl8xxxu_tx(struct ieee80211_hw *hw,
 
 	if (rate_flag & IEEE80211_TX_RC_USE_RTS_CTS) {
 		/* Use RTS rate 24M - does the mac80211 tell us which to use? */
-		tx_desc->txdw4 |= cpu_to_le32(DESC_RATE_24M);
+		tx_desc->txdw4 |= cpu_to_le32(DESC_RATE_24M <<
+					      TXDESC_RTS_RATE_SHIFT_8723A);
 		tx_desc->txdw4 |= cpu_to_le32(TXDESC_RTS_CTS_ENABLE_8723A);
 		tx_desc->txdw4 |= cpu_to_le32(TXDESC_HW_RTS_ENABLE_8723A);
 	}
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
index 5f60f19..b015c75 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
@@ -475,6 +475,8 @@ struct rtl8723bu_tx_desc {
 #define TXDESC_SEQ_MASK_8723A		0x0fff0000
 
 /* Word 4 */
+#define TXDESC_RTS_RATE_SHIFT_8723A	0
+#define TXDESC_RTS_RATE_MASK_8723A	0x3f
 #define TXDESC_QOS			BIT(6)
 #define TXDESC_HW_SEQ_ENABLE_8723A	BIT(7)
 #define TXDESC_USE_DRIVER_RATE_8723A	BIT(8)
@@ -496,8 +498,6 @@ struct rtl8723bu_tx_desc {
 #define TXDESC_RTS_RATE_MASK_8723B	0x3f000000
 
 /* Word 5 */
-#define TXDESC_RTS_RATE_SHIFT_8723A	0
-#define TXDESC_RTS_RATE_MASK_8723A	0x3f
 #define TXDESC_SHORT_GI			BIT(6)
 #define TXDESC_CCX_TAG			BIT(7)
 #define TXDESC_RETRY_LIMIT_ENABLE_8723A	BIT(17)
-- 
2.5.0

