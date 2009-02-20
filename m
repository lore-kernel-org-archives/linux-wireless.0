Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:58825 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751125AbZBTNtp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Feb 2009 08:49:45 -0500
From: Michael Buesch <mb@bu3sch.de>
To: John W Linville <linville@tuxdriver.com>
Subject: [PATCH] b43: Honor the no-slow-clock boardflag
Date: Fri, 20 Feb 2009 14:47:56 +0100
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200902201447.57019.mb@bu3sch.de> (sfid-20090220_144949_377863_FAF52033)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Do not turn off the crystal, if the boardflags tell us so.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

John, this doesn't fix known bugs. Please queue for the next feature release.


Index: wireless-testing/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/main.c	2009-02-20 12:34:53.000000000 +0100
+++ wireless-testing/drivers/net/wireless/b43/main.c	2009-02-20 14:41:53.000000000 +0100
@@ -4185,12 +4185,14 @@ static int b43_wireless_core_init(struct
 	if (phy->radio_ver == 0x2050) {
 		if (phy->radio_rev == 6)
 			hf |= B43_HF_4318TSSI;
 		if (phy->radio_rev < 6)
 			hf |= B43_HF_VCORECALC;
 	}
+	if (sprom->boardflags_lo & B43_BFL_XTAL_NOSLOW)
+		hf |= B43_HF_DSCRQ; /* Disable slowclock requests from ucode. */
 	b43_hf_write(dev, hf);
 
 	b43_set_retry_limits(dev, B43_DEFAULT_SHORT_RETRY_LIMIT,
 			     B43_DEFAULT_LONG_RETRY_LIMIT);
 	b43_shm_write16(dev, B43_SHM_SHARED, B43_SHM_SH_SFFBLIM, 3);
 	b43_shm_write16(dev, B43_SHM_SHARED, B43_SHM_SH_LFFBLIM, 2);
@@ -4223,13 +4225,13 @@ static int b43_wireless_core_init(struct
 	if (err)
 		goto err_chip_exit;
 	b43_qos_init(dev);
 	b43_set_synth_pu_delay(dev, 1);
 	b43_bluetooth_coext_enable(dev);
 
-	ssb_bus_powerup(bus, 1);	/* Enable dynamic PCTL */
+	ssb_bus_powerup(bus, !(sprom->boardflags_lo & B43_BFL_XTAL_NOSLOW));
 	b43_upload_card_macaddress(dev);
 	b43_security_init(dev);
 	if (!dev->suspend_in_progress)
 		b43_rng_init(wl);
 
 	b43_set_status(dev, B43_STAT_INITIALIZED);

-- 
Greetings, Michael.
