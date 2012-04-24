Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:63055 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754543Ab2DXI3x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Apr 2012 04:29:53 -0400
Received: by vbbff1 with SMTP id ff1so305847vbb.19
        for <linux-wireless@vger.kernel.org>; Tue, 24 Apr 2012 01:29:52 -0700 (PDT)
Message-ID: <4F96647F.9060803@gmail.com> (sfid-20120424_102959_655501_A5F8C510)
Date: Tue, 24 Apr 2012 04:29:51 -0400
From: Jonathan Bither <jonbither@gmail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: ath5k: add missing iounmap to AHB probe removal
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When our driver device is removed on the AHB bus, our IO memory is never unmapped.

Signed-off-by: Jonathan Bither <jonbither@gmail.com>

diff --git a/drivers/net/wireless/ath/ath5k/ahb.c b/drivers/net/wireless/ath/ath5k/ahb.c
index 8c50d9d..eebf439 100644
--- a/drivers/net/wireless/ath/ath5k/ahb.c
+++ b/drivers/net/wireless/ath/ath5k/ahb.c
@@ -197,12 +197,14 @@ static int ath_ahb_remove(struct platform_device *pdev)
 	struct ar231x_board_config *bcfg = pdev->dev.platform_data;
 	struct ieee80211_hw *hw = platform_get_drvdata(pdev);
 	struct ath5k_hw *ah;
+	void __iomem *mem;
 	u32 reg;
 
 	if (!hw)
 		return 0;
 
 	ah = hw->priv;
+	mem = ah->iobase;
 
 	if (bcfg->devid >= AR5K_SREV_AR2315_R6) {
 		/* Disable WMAC AHB arbitration */
@@ -222,6 +224,7 @@ static int ath_ahb_remove(struct platform_device *pdev)
 	ath5k_deinit_ah(ah);
 	platform_set_drvdata(pdev, NULL);
 	ieee80211_free_hw(hw);
+	iounmap(mem);
 
 	return 0;
 }
