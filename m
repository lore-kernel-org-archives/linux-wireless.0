Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59651 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881Ab0J0Rih (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Oct 2010 13:38:37 -0400
Received: by bwz11 with SMTP id 11so814942bwz.19
        for <linux-wireless@vger.kernel.org>; Wed, 27 Oct 2010 10:38:35 -0700 (PDT)
Message-ID: <4CC8639A.9070409@27m.se>
Date: Wed, 27 Oct 2010 19:38:34 +0200
From: Jones Desougi <jones.desougi@27m.se>
MIME-Version: 1.0
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org
Subject: [PATCH] ath5k: Fix double free on hw attach error path
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If ath5k_hw_attach fails it will free sc->ah (local variable ah) before
returning. However, when it reports failure the caller (ath5k_pci_probe)
will also free sc->ah. Let the caller handle the deallocation, it does
so on further errors as well.

Signed-off-by: Jones Desougi <jones.desougi@27m.se>
---
The patch is generated from a week-old compat-wireless, but applies
cleanly with -p1 to wireless-testing today.

diff -r -u -p
compat-wireless-2010-10-19.orig/drivers/net/wireless/ath/ath5k/attach.c
compat-wireless-2010-10-19/drivers/net/wireless/ath/ath5k/attach.c
---
compat-wireless-2010-10-19.orig/drivers/net/wireless/ath/ath5k/attach.c
2010-10-19 23:41:54.000000000 +0200
+++ compat-wireless-2010-10-19/drivers/net/wireless/ath/ath5k/attach.c
2010-10-22 14:28:29.000000000 +0200
@@ -139,12 +139,12 @@ int ath5k_hw_attach(struct ath5k_softc *
 	/* Fill the ath5k_hw struct with the needed functions */
 	ret = ath5k_hw_init_desc_functions(ah);
 	if (ret)
-		goto err_free;
+		goto err;

 	/* Bring device out of sleep and reset its units */
 	ret = ath5k_hw_nic_wakeup(ah, 0, true);
 	if (ret)
-		goto err_free;
+		goto err;

 	/* Get MAC, PHY and RADIO revisions */
 	ah->ah_mac_srev = srev;
@@ -234,7 +234,7 @@ int ath5k_hw_attach(struct ath5k_softc *
 		} else {
 			ATH5K_ERR(sc, "Couldn't identify radio revision.\n");
 			ret = -ENODEV;
-			goto err_free;
+			goto err;
 		}
 	}

@@ -244,7 +244,7 @@ int ath5k_hw_attach(struct ath5k_softc *
 	(srev < AR5K_SREV_AR2425)) {
 		ATH5K_ERR(sc, "Device not yet supported.\n");
 		ret = -ENODEV;
-		goto err_free;
+		goto err;
 	}

 	/*
@@ -252,7 +252,7 @@ int ath5k_hw_attach(struct ath5k_softc *
 	 */
 	ret = ath5k_hw_post(ah);
 	if (ret)
-		goto err_free;
+		goto err;

 	/* Enable pci core retry fix on Hainan (5213A) and later chips */
 	if (srev >= AR5K_SREV_AR5213A)
@@ -265,7 +265,7 @@ int ath5k_hw_attach(struct ath5k_softc *
 	ret = ath5k_eeprom_init(ah);
 	if (ret) {
 		ATH5K_ERR(sc, "unable to init EEPROM\n");
-		goto err_free;
+		goto err;
 	}

 	ee = &ah->ah_capabilities.cap_eeprom;
@@ -307,7 +307,7 @@ int ath5k_hw_attach(struct ath5k_softc *
 	if (ret) {
 		ATH5K_ERR(sc, "unable to get device capabilities: 0x%04x\n",
 			sc->pdev->device);
-		goto err_free;
+		goto err;
 	}

 	/* Crypto settings */
@@ -341,8 +341,7 @@ int ath5k_hw_attach(struct ath5k_softc *
 	ath5k_hw_set_ledstate(ah, AR5K_LED_INIT);

 	return 0;
-err_free:
-	kfree(ah);
+err:
 	return ret;
 }

