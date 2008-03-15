Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:42421 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752075AbYCOSKH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Mar 2008 14:10:07 -0400
Date: Sat, 15 Mar 2008 19:08:36 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>
Subject: Re: [PATCH] [RFT] b43legacy: fix bcm4303 crash
Message-ID: <20080315190836.5020b884@morte> (sfid-20080315_182427_160097_F716B310)
In-Reply-To: <20080315190121.70edbfcd@morte>
References: <20080315190121.70edbfcd@morte>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 15 Mar 2008 19:01:21 +0100
Stefano Brivio <stefano.brivio@polimi.it> wrote:

> This should fix an hard crash which happened upon driver loading on bcm4303
> rev. 2 devices. The bug was originally reported here:
> https://bugzilla.redhat.com/show_bug.cgi?id=384981.
> Please test.

Ehr, sure. :/ Here it comes:

Signed-off-by: Stefano Brivio <stefano.brivio@polimi.it>
---
Index: wireless-testing/drivers/net/wireless/b43legacy/main.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43legacy/main.c
+++ wireless-testing/drivers/net/wireless/b43legacy/main.c
@@ -3047,7 +3047,6 @@ static void b43legacy_wireless_core_exit
 	}
 
 	ssb_device_disable(dev->dev, 0);
-	ssb_bus_may_powerdown(dev->dev->bus);
 }
 
 static void prepare_phy_data_for_init(struct b43legacy_wldev *dev)
@@ -3214,7 +3213,6 @@ err_kfree_tssitbl:
 err_kfree_lo_control:
 	kfree(phy->lo_control);
 	phy->lo_control = NULL;
-	ssb_bus_may_powerdown(bus);
 	B43legacy_WARN_ON(b43legacy_status(dev) != B43legacy_STAT_UNINIT);
 	return err;
 }
@@ -3534,7 +3532,7 @@ static int b43legacy_wireless_core_attac
 
 	err = b43legacy_phy_versioning(dev);
 	if (err)
-		goto err_powerdown;
+		goto out;
 	/* Check if this device supports multiband. */
 	if (!pdev ||
 	    (pdev->device != 0x4312 &&
@@ -3560,10 +3558,10 @@ static int b43legacy_wireless_core_attac
 
 	err = b43legacy_validate_chipaccess(dev);
 	if (err)
-		goto err_powerdown;
+		goto out;
 	err = b43legacy_setup_modes(dev, have_bphy, have_gphy);
 	if (err)
-		goto err_powerdown;
+		goto out;
 
 	/* Now set some default "current_dev" */
 	if (!wl->current_dev)
@@ -3573,14 +3571,9 @@ static int b43legacy_wireless_core_attac
 	b43legacy_radio_turn_off(dev, 1);
 	b43legacy_switch_analog(dev, 0);
 	ssb_device_disable(dev->dev, 0);
-	ssb_bus_may_powerdown(bus);
 
 out:
 	return err;
-
-err_powerdown:
-	ssb_bus_may_powerdown(bus);
-	return err;
 }
 
 static void b43legacy_one_core_detach(struct ssb_device *dev)
Index: wireless-testing/drivers/ssb/main.c
===================================================================
--- wireless-testing.orig/drivers/ssb/main.c
+++ wireless-testing/drivers/ssb/main.c
@@ -1082,6 +1082,10 @@ int ssb_bus_may_powerdown(struct ssb_bus
 		goto out;
 
 	cc = &bus->chipco;
+
+	if (cc->dev->id.revision < 5)
+		goto out;
+
 	ssb_chipco_set_clockmode(cc, SSB_CLKMODE_SLOW);
 	err = ssb_pci_xtal(bus, SSB_GPIO_XTAL | SSB_GPIO_PLL, 0);
 	if (err)


-- 
Ciao
Stefano
