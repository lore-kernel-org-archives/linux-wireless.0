Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33475 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753463AbcB2WGC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 17:06:02 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 055/113] rtl8xxxu: Setup LLT before downloading firmware
Date: Mon, 29 Feb 2016 17:04:53 -0500
Message-Id: <1456783551-28315-56-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160229_232952_958997_3C2A8312)
In-Reply-To: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

This matches the order of the 8723bu vendor driver

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 29 ++++++++++++++++--------
 1 file changed, 20 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index a8b7b75..15e27ab3 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -5955,6 +5955,26 @@ static int rtl8xxxu_init_device(struct ieee80211_hw *hw)
 
 	dev_dbg(dev, "%s: macpower %i\n", __func__, macpower);
 	if (!macpower) {
+		ret = priv->fops->llt_init(priv, TX_TOTAL_PAGE_NUM);
+		if (ret) {
+			dev_warn(dev, "%s: LLT table init failed\n", __func__);
+			goto exit;
+		}
+
+		/*
+		 * Presumably this is for 8188EU as well
+		 * Enable TX report and TX report timer
+		 */
+		if (priv->rtlchip == 0x8723bu) {
+			val8 = rtl8xxxu_read8(priv, REG_TX_REPORT_CTRL);
+			val8 |= BIT(1);
+			rtl8xxxu_write8(priv, REG_TX_REPORT_CTRL, val8);
+			/* Set MAX RPT MACID */
+			rtl8xxxu_write8(priv, REG_TX_REPORT_CTRL + 1, 0x02);
+			/* TX report Timer. Unit: 32us */
+			rtl8xxxu_write16(priv, REG_TX_REPORT_TIME, 0xcdf0);
+		}
+
 		if (priv->ep_tx_normal_queue)
 			val8 = TX_PAGE_NUM_NORM_PQ;
 		else
@@ -5996,15 +6016,6 @@ static int rtl8xxxu_init_device(struct ieee80211_hw *hw)
 	if (ret)
 		goto exit;
 
-	dev_dbg(dev, "%s: macpower %i\n", __func__, macpower);
-	if (!macpower) {
-		ret = priv->fops->llt_init(priv, TX_TOTAL_PAGE_NUM);
-		if (ret) {
-			dev_warn(dev, "%s: LLT table init failed\n", __func__);
-			goto exit;
-		}
-	}
-
 	/* Fix USB interface interference issue */
 	if (priv->rtlchip == 0x8723a) {
 		rtl8xxxu_write8(priv, 0xfe40, 0xe0);
-- 
2.5.0

