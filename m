Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58012 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753449AbcB2WGB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 17:06:01 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 062/113] rtl8xxxu: Do queue init in same order as 8723bu vendor driver
Date: Mon, 29 Feb 2016 17:05:00 -0500
Message-Id: <1456783551-28315-63-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160229_232953_616288_189ECDDA)
In-Reply-To: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Reorganize the init sequence in order to be able to compare to the
8723bu vendor driver's init sequence.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 68 +++++++++++++-----------
 1 file changed, 37 insertions(+), 31 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index 8b91edc..7e525fa 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -6017,32 +6017,6 @@ static int rtl8xxxu_init_device(struct ieee80211_hw *hw)
 			val8 &= 0xf8;
 			rtl8xxxu_write8(priv, 0xa3, val8);
 		}
-
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
 	}
 
 	ret = rtl8xxxu_download_firmware(priv);
@@ -6054,11 +6028,6 @@ static int rtl8xxxu_init_device(struct ieee80211_hw *hw)
 	if (ret)
 		goto exit;
 
-	ret = rtl8xxxu_init_queue_priority(priv);
-	dev_dbg(dev, "%s: init_queue_priority %i\n", __func__, ret);
-	if (ret)
-		goto exit;
-
 	/* Fix USB interface interference issue */
 	if (priv->rtlchip == 0x8723a) {
 		rtl8xxxu_write8(priv, 0xfe40, 0xe0);
@@ -6158,6 +6127,43 @@ static int rtl8xxxu_init_device(struct ieee80211_hw *hw)
 		rtl8xxxu_write32(priv, REG_AFE_PLL_CTRL, 0xf0ffff83);
 	}
 
+	if (!macpower){
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
+
+		if (priv->rtlchip == 0x8723b)
+			val8 -= 1;
+
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
 	/* RFSW Control - clear bit 14 ?? */
 	rtl8xxxu_write32(priv, REG_FPGA0_TX_INFO, 0x00000003);
 	/* 0x07000760 */
-- 
2.5.0

