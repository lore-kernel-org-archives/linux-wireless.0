Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:35619 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762024Ab0HFU3p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Aug 2010 16:29:45 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Michael Buesch <mb@bu3sch.de>,
	Larry Finger <Larry.Finger@wfinger.net>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] b43: move hwrng registration driver to wireless core initialization
Date: Fri,  6 Aug 2010 16:26:52 -0400
Message-Id: <1281126412-5089-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

...and unregistration to core shutdown.  Previously, the driver
remained registered even when the hardware was shutdown.  That
causes the driver to return -ENODEV if the b43 device is IFF_DOWN.
This change causes the driver to disappear in that case, allowing
/dev/hwrng to still function if another hwrng device is available.

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/b43/main.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 20631ae..4062c07 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -4250,6 +4250,10 @@ static void b43_wireless_core_exit(struct b43_wldev *dev)
 	B43_WARN_ON(dev && b43_status(dev) > B43_STAT_INITIALIZED);
 	if (!dev || b43_status(dev) != B43_STAT_INITIALIZED)
 		return;
+
+	/* Unregister HW RNG driver */
+	b43_rng_exit(dev->wl);
+
 	b43_set_status(dev, B43_STAT_UNINIT);
 
 	/* Stop the microcode PSM. */
@@ -4379,6 +4383,9 @@ static int b43_wireless_core_init(struct b43_wldev *dev)
 
 	b43_set_status(dev, B43_STAT_INITIALIZED);
 
+	/* Register HW RNG driver */
+	b43_rng_init(dev->wl);
+
 out:
 	return err;
 
@@ -4984,7 +4991,6 @@ static int b43_probe(struct ssb_device *dev, const struct ssb_device_id *id)
 		if (err)
 			goto err_one_core_detach;
 		b43_leds_register(wl->current_dev);
-		b43_rng_init(wl);
 	}
 
       out:
@@ -5020,7 +5026,6 @@ static void b43_remove(struct ssb_device *dev)
 	b43_one_core_detach(dev);
 
 	if (list_empty(&wl->devlist)) {
-		b43_rng_exit(wl);
 		b43_leds_unregister(wl);
 		/* Last core on the chip unregistered.
 		 * We can destroy common struct b43_wl.
-- 
1.7.2

