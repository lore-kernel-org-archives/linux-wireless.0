Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43366 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753004AbcB2WFz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 17:05:55 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 063/113] rtl8xxxu: Do not set FPGA0_TX_INFO for 8723bu and use a larger PBP page size
Date: Mon, 29 Feb 2016 17:05:01 -0500
Message-Id: <1456783551-28315-64-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160229_230953_752024_373B08BB)
In-Reply-To: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

The vendor driver does not set FPGA0_TX_INFO here. In additiona the
8723bu can handler a larger PBP page size.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index 7e525fa..3a7fd2c 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -6165,7 +6165,8 @@ static int rtl8xxxu_init_device(struct ieee80211_hw *hw)
 		goto exit;
 
 	/* RFSW Control - clear bit 14 ?? */
-	rtl8xxxu_write32(priv, REG_FPGA0_TX_INFO, 0x00000003);
+	if (priv->rtlchip != 0x8723b)
+		rtl8xxxu_write32(priv, REG_FPGA0_TX_INFO, 0x00000003);
 	/* 0x07000760 */
 	val32 = FPGA0_RF_TRSW | FPGA0_RF_TRSWB | FPGA0_RF_ANTSW |
 		FPGA0_RF_ANTSWB | FPGA0_RF_PAPE |
@@ -6185,8 +6186,12 @@ static int rtl8xxxu_init_device(struct ieee80211_hw *hw)
 	/*
 	 * Transfer page size is always 128
 	 */
-	val8 = (PBP_PAGE_SIZE_128 << PBP_PAGE_SIZE_RX_SHIFT) |
-		(PBP_PAGE_SIZE_128 << PBP_PAGE_SIZE_TX_SHIFT);
+	if (priv->rtlchip == 0x8723b)
+		val8 = (PBP_PAGE_SIZE_256 << PBP_PAGE_SIZE_RX_SHIFT) |
+			(PBP_PAGE_SIZE_256 << PBP_PAGE_SIZE_TX_SHIFT);
+	else
+		val8 = (PBP_PAGE_SIZE_128 << PBP_PAGE_SIZE_RX_SHIFT) |
+			(PBP_PAGE_SIZE_128 << PBP_PAGE_SIZE_TX_SHIFT);
 	rtl8xxxu_write8(priv, REG_PBP, val8);
 
 	/*
-- 
2.5.0

