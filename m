Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39909 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752569AbcB2WFx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 17:05:53 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 007/113] rtl8xxxu: Init page boundaries before starting the firmware
Date: Mon, 29 Feb 2016 17:04:05 -0500
Message-Id: <1456783551-28315-8-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160229_232952_772822_EB7DFCE1)
In-Reply-To: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

This reorganizes the device initialization to init page boundaries
before starting the firmware. This matches the flow in the 8192eu
vendor driver.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 68 ++++++++++++------------
 1 file changed, 34 insertions(+), 34 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index 2f31c2a..a17d88e 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -4315,6 +4315,40 @@ static int rtl8xxxu_init_device(struct ieee80211_hw *hw)
 
 	dev_dbg(dev, "%s: macpower %i\n", __func__, macpower);
 	if (!macpower) {
+		if (priv->ep_tx_normal_queue)
+			val8 = TX_PAGE_NUM_NORM_PQ;
+		else
+			val8 = 0;
+
+		rtl8xxxu_write8(priv, REG_RQPN_NPQ, val8);
+
+		val32 = (TX_PAGE_NUM_PUBQ << RQPN_NORM_PQ_SHIFT) | RQPN_LOAD;
+
+		if (priv->ep_tx_high_queue)
+			val32 |= (TX_PAGE_NUM_HI_PQ << RQPN_HI_PQ_SHIFT);
+		if (priv->ep_tx_low_queue)
+			val32 |= (TX_PAGE_NUM_LO_PQ << RQPN_LO_PQ_SHIFT);
+
+		rtl8xxxu_write32(priv, REG_RQPN, val32);
+
+		/*
+		 * Set TX buffer boundary
+		 */
+		val8 = TX_TOTAL_PAGE_NUM + 1;
+		rtl8xxxu_write8(priv, REG_TXPKTBUF_BCNQ_BDNY, val8);
+		rtl8xxxu_write8(priv, REG_TXPKTBUF_MGQ_BDNY, val8);
+		rtl8xxxu_write8(priv, REG_TXPKTBUF_WMAC_LBK_BF_HD, val8);
+		rtl8xxxu_write8(priv, REG_TRXFF_BNDY, val8);
+		rtl8xxxu_write8(priv, REG_TDECTRL + 1, val8);
+	}
+
+	ret = rtl8xxxu_init_queue_priority(priv);
+	dev_dbg(dev, "%s: init_queue_priority %i\n", __func__, ret);
+	if (ret)
+		goto exit;
+
+	dev_dbg(dev, "%s: macpower %i\n", __func__, macpower);
+	if (!macpower) {
 		ret = priv->fops->llt_init(priv, TX_TOTAL_PAGE_NUM);
 		if (ret) {
 			dev_warn(dev, "%s: LLT table init failed\n", __func__);
@@ -4392,40 +4426,6 @@ static int rtl8xxxu_init_device(struct ieee80211_hw *hw)
 	priv->rf_mode_ag[0] = rtl8xxxu_read_rfreg(priv, RF_A,
 						  RF6052_REG_MODE_AG);
 
-	dev_dbg(dev, "%s: macpower %i\n", __func__, macpower);
-	if (!macpower) {
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
-		/*
-		 * Set TX buffer boundary
-		 */
-		val8 = TX_TOTAL_PAGE_NUM + 1;
-		rtl8xxxu_write8(priv, REG_TXPKTBUF_BCNQ_BDNY, val8);
-		rtl8xxxu_write8(priv, REG_TXPKTBUF_MGQ_BDNY, val8);
-		rtl8xxxu_write8(priv, REG_TXPKTBUF_WMAC_LBK_BF_HD, val8);
-		rtl8xxxu_write8(priv, REG_TRXFF_BNDY, val8);
-		rtl8xxxu_write8(priv, REG_TDECTRL + 1, val8);
-	}
-
-	ret = rtl8xxxu_init_queue_priority(priv);
-	dev_dbg(dev, "%s: init_queue_priority %i\n", __func__, ret);
-	if (ret)
-		goto exit;
-
 	/*
 	 * Set RX page boundary
 	 */
-- 
2.5.0

