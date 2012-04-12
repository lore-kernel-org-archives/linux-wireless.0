Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:63709 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757419Ab2DLLDM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Apr 2012 07:03:12 -0400
Received: by qcro28 with SMTP id o28so1130137qcr.19
        for <linux-wireless@vger.kernel.org>; Thu, 12 Apr 2012 04:03:11 -0700 (PDT)
Message-ID: <4F86B66D.3050707@gmail.com> (sfid-20120412_130342_493498_69600308)
Date: Thu, 12 Apr 2012 07:03:09 -0400
From: Jonathan Bither <jonbither@gmail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: [PATCH] ath5k: unmap io memory on probe failure
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Jonathan Bither <jonbither@gmail.com>

diff --git a/drivers/net/wireless/ath/ath5k/ahb.c b/drivers/net/wireless/ath/ath5k/ahb.c
index 8faa129..95926a1 100644
--- a/drivers/net/wireless/ath/ath5k/ahb.c
+++ b/drivers/net/wireless/ath/ath5k/ahb.c
@@ -119,7 +119,7 @@ static int ath_ahb_probe(struct platform_device *pdev)
 	if (res == NULL) {
 		dev_err(&pdev->dev, "no IRQ resource found\n");
 		ret = -ENXIO;
-		goto err_out;
+		goto err_iounmap;
 	}
 
 	irq = res->start;
@@ -128,7 +128,7 @@ static int ath_ahb_probe(struct platform_device *pdev)
 	if (hw == NULL) {
 		dev_err(&pdev->dev, "no memory for ieee80211_hw\n");
 		ret = -ENOMEM;
-		goto err_out;
+		goto err_iounmap;
 	}
 
 	ah = hw->priv;
@@ -185,6 +185,8 @@ static int ath_ahb_probe(struct platform_device *pdev)
  err_free_hw:
 	ieee80211_free_hw(hw);
 	platform_set_drvdata(pdev, NULL);
+ err_iounmap:
+        iounmap(mem);
  err_out:
 	return ret;
 }
