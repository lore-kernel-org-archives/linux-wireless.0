Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:41881 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756600Ab2DXJUS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Apr 2012 05:20:18 -0400
Received: by vbbff1 with SMTP id ff1so325248vbb.19
        for <linux-wireless@vger.kernel.org>; Tue, 24 Apr 2012 02:20:17 -0700 (PDT)
Message-ID: <4F96704F.8050406@gmail.com> (sfid-20120424_112025_520221_11818D1B)
Date: Tue, 24 Apr 2012 05:20:15 -0400
From: Jonathan Bither <jonbither@gmail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: [PATCH V2] ath5k: add missing iounmap to AHB probe removal
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When our driver device is removed on the AHB bus, our IO memory is never unmapped.

Signed-off-by: Jonathan Bither <jonbither@gmail.com>

diff --git a/drivers/net/wireless/ath/ath5k/ahb.c b/drivers/net/wireless/ath/ath5k/ahb.c
index 8c50d9d..aec33cc 100644
--- a/drivers/net/wireless/ath/ath5k/ahb.c
+++ b/drivers/net/wireless/ath/ath5k/ahb.c
@@ -220,6 +220,7 @@ static int ath_ahb_remove(struct platform_device *pdev)
 	}
 
 	ath5k_deinit_ah(ah);
+	iounmap(ah->iobase);
 	platform_set_drvdata(pdev, NULL);
 	ieee80211_free_hw(hw);
