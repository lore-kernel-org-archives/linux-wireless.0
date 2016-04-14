Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57098 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752635AbcDNS7J (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Apr 2016 14:59:09 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net
Subject: [PATCH 02/26] rtl8xxxu: Reorg more code to match the flow of the 8192eu vendor driver
Date: Thu, 14 Apr 2016 14:58:43 -0400
Message-Id: <1460660347-26299-3-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160414_205924_064372_6BA0AA56)
In-Reply-To: <1460660347-26299-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1460660347-26299-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

This further reorganizes the init code flow to match that of the
8192eu vendor driver. This helps diffing the register write log
against that of the vendor driver.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 109 ++++++++++++-----------
 1 file changed, 56 insertions(+), 53 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index d67b886..c6c41ba 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -7468,34 +7468,39 @@ static int rtl8xxxu_init_device(struct ieee80211_hw *hw)
 		goto exit;
 	}
 
-	dev_dbg(dev, "%s: macpower %i\n", __func__, macpower);
 	if (!macpower) {
-		ret = priv->fops->llt_init(priv, TX_TOTAL_PAGE_NUM);
-		if (ret) {
-			dev_warn(dev, "%s: LLT table init failed\n", __func__);
-			goto exit;
-		}
+		if (priv->ep_tx_normal_queue)
+			val8 = TX_PAGE_NUM_NORM_PQ;
+		else
+			val8 = 0;
 
-		/*
-		 * Presumably this is for 8188EU as well
-		 * Enable TX report and TX report timer
-		 */
-		if (priv->rtl_chip == RTL8723B) {
-			val8 = rtl8xxxu_read8(priv, REG_TX_REPORT_CTRL);
-			val8 |= TX_REPORT_CTRL_TIMER_ENABLE;
-			rtl8xxxu_write8(priv, REG_TX_REPORT_CTRL, val8);
-			/* Set MAX RPT MACID */
-			rtl8xxxu_write8(priv, REG_TX_REPORT_CTRL + 1, 0x02);
-			/* TX report Timer. Unit: 32us */
-			rtl8xxxu_write16(priv, REG_TX_REPORT_TIME, 0xcdf0);
+		rtl8xxxu_write8(priv, REG_RQPN_NPQ, val8);
 
-			/* tmp ps ? */
-			val8 = rtl8xxxu_read8(priv, 0xa3);
-			val8 &= 0xf8;
-			rtl8xxxu_write8(priv, 0xa3, val8);
-		}
+		val32 = (TX_PAGE_NUM_PUBQ << RQPN_NORM_PQ_SHIFT) | RQPN_LOAD;
+
+		if (priv->ep_tx_high_queue)
+			val32 |= (TX_PAGE_NUM_HI_PQ << RQPN_HI_PQ_SHIFT);
+		if (priv->ep_tx_low_queue)
+			val32 |= (TX_PAGE_NUM_LO_PQ << RQPN_LO_PQ_SHIFT);
+
+		rtl8xxxu_write32(priv, REG_RQPN, val32);
 	}
 
+	ret = rtl8xxxu_init_queue_priority(priv);
+	dev_dbg(dev, "%s: init_queue_priority %i\n", __func__, ret);
+	if (ret)
+		goto exit;
+
+	/*
+	 * Set RX page boundary
+	 */
+	if (priv->rtl_chip == RTL8723B)
+		rtl8xxxu_write16(priv, REG_TRXFF_BNDY + 2, 0x3f7f);
+	else if (priv->rtl_chip == RTL8192E)
+		rtl8xxxu_write16(priv, REG_TRXFF_BNDY + 2, 0x3cff);
+	else
+		rtl8xxxu_write16(priv, REG_TRXFF_BNDY + 2, 0x27ff);
+
 	ret = rtl8xxxu_download_firmware(priv);
 	dev_dbg(dev, "%s: download_fiwmare %i\n", __func__, ret);
 	if (ret)
@@ -7634,22 +7639,6 @@ static int rtl8xxxu_init_device(struct ieee80211_hw *hw)
 	}
 
 	if (!macpower) {
-		if (priv->ep_tx_normal_queue)
-			val8 = TX_PAGE_NUM_NORM_PQ;
-		else
-			val8 = 0;
-
-		rtl8xxxu_write8(priv, REG_RQPN_NPQ, val8);
-
-		val32 = (TX_PAGE_NUM_PUBQ << RQPN_NORM_PQ_SHIFT) | RQPN_LOAD;
-
-		if (priv->ep_tx_high_queue)
-			val32 |= (TX_PAGE_NUM_HI_PQ << RQPN_HI_PQ_SHIFT);
-		if (priv->ep_tx_low_queue)
-			val32 |= (TX_PAGE_NUM_LO_PQ << RQPN_LO_PQ_SHIFT);
-
-		rtl8xxxu_write32(priv, REG_RQPN, val32);
-
 		/*
 		 * Set TX buffer boundary
 		 */
@@ -7668,20 +7657,6 @@ static int rtl8xxxu_init_device(struct ieee80211_hw *hw)
 		rtl8xxxu_write8(priv, REG_TDECTRL + 1, val8);
 	}
 
-	ret = rtl8xxxu_init_queue_priority(priv);
-	dev_dbg(dev, "%s: init_queue_priority %i\n", __func__, ret);
-	if (ret)
-		goto exit;
-
-	/*
-	 * Set RX page boundary
-	 */
-	if (priv->rtl_chip == RTL8723B)
-		rtl8xxxu_write16(priv, REG_TRXFF_BNDY + 2, 0x3f7f);
-	else if (priv->rtl_chip == RTL8192E)
-		rtl8xxxu_write16(priv, REG_TRXFF_BNDY + 2, 0x3cff);
-	else
-		rtl8xxxu_write16(priv, REG_TRXFF_BNDY + 2, 0x27ff);
 	/*
 	 * Transfer page size is always 128
 	 */
@@ -7693,6 +7668,34 @@ static int rtl8xxxu_init_device(struct ieee80211_hw *hw)
 			(PBP_PAGE_SIZE_128 << PBP_PAGE_SIZE_TX_SHIFT);
 	rtl8xxxu_write8(priv, REG_PBP, val8);
 
+	dev_dbg(dev, "%s: macpower %i\n", __func__, macpower);
+	if (!macpower) {
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
+		if (priv->rtl_chip == RTL8723B) {
+			val8 = rtl8xxxu_read8(priv, REG_TX_REPORT_CTRL);
+			val8 |= TX_REPORT_CTRL_TIMER_ENABLE;
+			rtl8xxxu_write8(priv, REG_TX_REPORT_CTRL, val8);
+			/* Set MAX RPT MACID */
+			rtl8xxxu_write8(priv, REG_TX_REPORT_CTRL + 1, 0x02);
+			/* TX report Timer. Unit: 32us */
+			rtl8xxxu_write16(priv, REG_TX_REPORT_TIME, 0xcdf0);
+
+			/* tmp ps ? */
+			val8 = rtl8xxxu_read8(priv, 0xa3);
+			val8 &= 0xf8;
+			rtl8xxxu_write8(priv, 0xa3, val8);
+		}
+	}
+
 	/*
 	 * Unit in 8 bytes, not obvious what it is used for
 	 */
-- 
2.5.5

