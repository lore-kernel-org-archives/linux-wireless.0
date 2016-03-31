Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50989 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932274AbcCaVIs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Mar 2016 17:08:48 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net
Subject: [PATCH 04/10] rtl8xxxu: TXDESC_SHORT_GI is txdesc32 only
Date: Thu, 31 Mar 2016 17:08:36 -0400
Message-Id: <1459458522-28686-5-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160331_230858_700327_8C35A09D)
In-Reply-To: <1459458522-28686-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1459458522-28686-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

This is no short GI bit in the txdesc40 format.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 2 +-
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index d736316..484d08f 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -7295,7 +7295,7 @@ static void rtl8xxxu_tx(struct ieee80211_hw *hw,
 		    (ieee80211_is_data_qos(hdr->frame_control) &&
 		     sta && sta->ht_cap.cap &
 		     (IEEE80211_HT_CAP_SGI_40 | IEEE80211_HT_CAP_SGI_20))) {
-			tx_desc->txdw5 |= cpu_to_le32(TXDESC_SHORT_GI);
+			tx_desc->txdw5 |= cpu_to_le32(TXDESC32_SHORT_GI);
 		}
 
 		if (rate_flag & IEEE80211_TX_RC_USE_RTS_CTS) {
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
index af1d504..f211c5d 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
@@ -501,7 +501,7 @@ struct rtl8xxxu_txdesc40 {
 
 /* Word 5 */
 #define TXDESC40_SHORT_PREAMBLE		BIT(4)
-#define TXDESC_SHORT_GI			BIT(6)
+#define TXDESC32_SHORT_GI		BIT(6)
 #define TXDESC_CCX_TAG			BIT(7)
 #define TXDESC32_RETRY_LIMIT_ENABLE	BIT(17)
 #define TXDESC32_RETRY_LIMIT_SHIFT	18
-- 
2.5.5

