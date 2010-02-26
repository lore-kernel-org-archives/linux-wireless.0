Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59616 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965910Ab0BZUIr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Feb 2010 15:08:47 -0500
Date: Fri, 26 Feb 2010 12:07:43 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Michael Buesch <mb@bu3sch.de>
cc: Larry Finger <Larry.Finger@lwfinger.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	"David S. Miller" <davem@davemloft.net>,
	wireless <linux-wireless@vger.kernel.org>,
	Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: Make b43 driver fall back gracefully to PIO mode after fatal
 DMA errors
In-Reply-To: <201002262059.02383.mb@bu3sch.de>
Message-ID: <alpine.LFD.2.00.1002261207020.4513@localhost.localdomain>
References: <alpine.LFD.2.00.1002261034140.4513@localhost.localdomain> <4B881C70.9030004@lwfinger.net> <201002262059.02383.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On Fri, 26 Feb 2010, Michael Buesch wrote:
> 
> Where is that patch? I can't find it in any list archives.

Here is the patch. I originally sent it to Larry directly (with John and 
David cc'd).

		Linus

---
 drivers/net/wireless/b43/Kconfig |    6 +++---
 drivers/net/wireless/b43/b43.h   |    5 +++--
 drivers/net/wireless/b43/main.c  |   10 +++++++++-
 3 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/b43/Kconfig b/drivers/net/wireless/b43/Kconfig
index 64c12e1..e6a7d8e 100644
--- a/drivers/net/wireless/b43/Kconfig
+++ b/drivers/net/wireless/b43/Kconfig
@@ -78,11 +78,11 @@ config B43_SDIO
 
 	  If unsure, say N.
 
-# Data transfers to the device via PIO
-# This is only needed on PCMCIA and SDIO devices. All others can do DMA properly.
+# Data transfers to the device via PIO. We want it as a fallback even
+# if we can do DMA.
 config B43_PIO
 	bool
-	depends on B43 && (B43_SDIO || B43_PCMCIA || B43_FORCE_PIO)
+	depends on B43
 	select SSB_BLOCKIO
 	default y
 
diff --git a/drivers/net/wireless/b43/b43.h b/drivers/net/wireless/b43/b43.h
index c484cc2..f2cfbc4 100644
--- a/drivers/net/wireless/b43/b43.h
+++ b/drivers/net/wireless/b43/b43.h
@@ -694,6 +694,7 @@ struct b43_wldev {
 	bool radio_hw_enable;	/* saved state of radio hardware enabled state */
 	bool qos_enabled;		/* TRUE, if QoS is used. */
 	bool hwcrypto_enabled;		/* TRUE, if HW crypto acceleration is enabled. */
+	bool use_pio;			/* TRUE if next init should use PIO */
 
 	/* PHY/Radio device. */
 	struct b43_phy phy;
@@ -885,9 +886,9 @@ static inline bool b43_using_pio_transfers(struct b43_wldev *dev)
 }
 
 #ifdef CONFIG_B43_FORCE_PIO
-# define B43_FORCE_PIO	1
+# define B43_PIO_DEFAULT 1
 #else
-# define B43_FORCE_PIO	0
+# define B43_PIO_DEFAULT 0
 #endif
 
 
diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 490fb45..d310ce7 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -98,6 +98,10 @@ static int modparam_btcoex = 1;
 module_param_named(btcoex, modparam_btcoex, int, 0444);
 MODULE_PARM_DESC(btcoex, "Enable Bluetooth coexistence (default on)");
 
+int b43_modparam_pio = B43_PIO_DEFAULT;
+module_param_named(pio, b43_modparam_pio, int, 0644);
+MODULE_PARM_DESC(pio, "Use PIO accesses by default: 0=DMA, 1=PIO");
+
 int b43_modparam_verbose = B43_VERBOSITY_DEFAULT;
 module_param_named(verbose, b43_modparam_verbose, int, 0644);
 MODULE_PARM_DESC(verbose, "Log message verbosity: 0=error, 1=warn, 2=info(default), 3=debug");
@@ -1795,6 +1799,9 @@ static void b43_do_interrupt_thread(struct b43_wldev *dev)
 			       "on your system. Please use PIO instead.\n");
 			b43err(dev->wl, "CONFIG_B43_FORCE_PIO must be set in "
 			       "your kernel configuration.\n");
+			/* Fall back to PIO transfers if we get fatal DMA errors! */
+			dev->use_pio = 1;
+			b43_controller_restart(dev, "DMA error");
 			return;
 		}
 		if (merged_dma_reason & B43_DMAIRQ_NONFATALMASK) {
@@ -4360,7 +4367,7 @@ static int b43_wireless_core_init(struct b43_wldev *dev)
 
 	if ((dev->dev->bus->bustype == SSB_BUSTYPE_PCMCIA) ||
 	    (dev->dev->bus->bustype == SSB_BUSTYPE_SDIO) ||
-	    B43_FORCE_PIO) {
+	    dev->use_pio) {
 		dev->__using_pio_transfers = 1;
 		err = b43_pio_init(dev);
 	} else {
@@ -4830,6 +4837,7 @@ static int b43_one_core_attach(struct ssb_device *dev, struct b43_wl *wl)
 	if (!wldev)
 		goto out;
 
+	wldev->use_pio = b43_modparam_pio;
 	wldev->dev = dev;
 	wldev->wl = wl;
 	b43_set_status(wldev, B43_STAT_UNINIT);
