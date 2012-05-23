Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:55154 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755382Ab2EWJPV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 May 2012 05:15:21 -0400
Message-ID: <4FBCAA9C.10209@hauke-m.de> (sfid-20120523_111527_222927_98438515)
Date: Wed, 23 May 2012 11:15:08 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Seth Forshee <seth.forshee@canonical.com>
CC: Arend van Spriel <arend@broadcom.com>,
	linux-wireless@vger.kernel.org,
	Stefano Brivio <stefano.brivio@polimi.it>,
	=?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Subject: Re: BCM4331 tx failures after S3
References: <20120522165251.GA31347@thinkpad-t410>
In-Reply-To: <20120522165251.GA31347@thinkpad-t410>
Content-Type: multipart/mixed;
 boundary="------------070507000008030207060602"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------070507000008030207060602
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 05/22/2012 06:52 PM, Seth Forshee wrote:
> Hi Arend,
> 
> I've inquired about this issue on the list once before, but I thought
> I'd try once again to see if Broadcom can offer any suggestions.
> 
> Recent MacBook Pros with BCM4331 wireless have a strange problem. Tx
> doesn't work after S3, but only if no external power is applied during
> the resume. mac80211 reports mostly timeouts for responses to probe
> requests, but analysis with wireshark shows no frames from the BCM4331
> on the air. The only way I've found to recover is to reload both b43 and
> bcma; reloading b43 alone is not enough.
> 
> I've checked the values of MACCTL and the DMA TXCTL registers, since
> these are the ones used by brcmsmac to mute tx, but those look okay. Any
> suggestions of other things to check? My next step would be to start
> looking at the state of the phy and radio, but since we don't have much
> information about what the registers there actually do some suggestions
> would be helpful.
> 
> Thanks,
> Seth

Hi Seth,

as reloading bcma helps could you try the attached patch which runs the
code for pci core initialisation on resume again. I saw some comments
about some functions which should be called on resume for pci core
initialisation in brcmsmac.

The other patch adds some pci workarounds for recent apple devices like
yours.

Both patches are not even compile tested.

Hauke

--------------070507000008030207060602
Content-Type: text/x-patch;
 name="0001-bcma-run-pci-init-on-resume.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0001-bcma-run-pci-init-on-resume.patch"

>From aaa99211d85738de8baf413ac7284133139187eb Mon Sep 17 00:00:00 2001
From: Hauke Mehrtens <hauke@hauke-m.de>
Date: Wed, 23 May 2012 11:12:21 +0200
Subject: [PATCH 1/2] bcma: run pci init on resume

---
 drivers/bcma/main.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/bcma/main.c b/drivers/bcma/main.c
index 7e138ec..cfa9624 100644
--- a/drivers/bcma/main.c
+++ b/drivers/bcma/main.c
@@ -276,6 +276,13 @@ int bcma_bus_resume(struct bcma_bus *bus)
 		bcma_core_chipcommon_init(&bus->drv_cc);
 	}
 
+	/* Init PCIE core */
+	core = bcma_find_core(bus, BCMA_CORE_PCIE);
+	if (core) {
+		bus->drv_pci.setup_done = false;
+		bcma_core_pci_init(&bus->drv_pci);
+	}
+
 	list_for_each_entry(core, &bus->cores, list) {
 		struct device_driver *drv = core->dev.driver;
 		if (drv) {
-- 
1.7.9.5


--------------070507000008030207060602
Content-Type: text/x-patch;
 name="0002-bcma-add-some-workarround-for-apple.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0002-bcma-add-some-workarround-for-apple.patch"

>From a9870cd156dbe7564960ad5db411143bbb0f63f2 Mon Sep 17 00:00:00 2001
From: Hauke Mehrtens <hauke@hauke-m.de>
Date: Wed, 23 May 2012 11:12:40 +0200
Subject: [PATCH 2/2] bcma: add some workarround for apple

---
 drivers/bcma/driver_pci.c |   22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/drivers/bcma/driver_pci.c b/drivers/bcma/driver_pci.c
index 9a96f14..fd1fc9a 100644
--- a/drivers/bcma/driver_pci.c
+++ b/drivers/bcma/driver_pci.c
@@ -55,7 +55,7 @@ static void bcma_pcie_mdio_set_phy(struct bcma_drv_pci *pc, u8 phy)
 	}
 }
 
-static u16 bcma_pcie_mdio_read(struct bcma_drv_pci *pc, u8 device, u8 address)
+static u16 bcma_pcie_mdio_read(struct bcma_drv_pci *pc, u16 device, u8 address)
 {
 	int max_retries = 10;
 	u16 ret = 0;
@@ -98,7 +98,7 @@ static u16 bcma_pcie_mdio_read(struct bcma_drv_pci *pc, u8 device, u8 address)
 	return ret;
 }
 
-static void bcma_pcie_mdio_write(struct bcma_drv_pci *pc, u8 device,
+static void bcma_pcie_mdio_write(struct bcma_drv_pci *pc, u16 device,
 				u8 address, u16 data)
 {
 	int max_retries = 10;
@@ -203,6 +203,23 @@ static void bcma_core_pci_config_fixup(struct bcma_drv_pci *pc)
 	}
 }
 
+static void bcma_core_pci_apple_fixup(struct bcma_drv_pci *pc)
+{
+	struct bcma_bus *bus =  pc->core->bus;
+
+	if (bus->boardinfo.vendor == PCI_VENDOR_ID_APPLE) {
+		if (bus->boardinfo.type == 0x8d) {
+			/* change the TX drive strength to max */
+			bcma_pcie_mdio_write(pc, 0x820, 0x18, 0x7f);
+			bcma_pcie_mdio_read(pc, 0x820, 0x18);
+		} else if (bus->chipinfo.id == 0x4331) {
+			/* change the drive strength for X19b & X28 to 700mv */
+			bcma_pcie_mdio_write(pc, 0x820, 0x18, 0x70);
+			bcma_pcie_mdio_read(pc, 0x820, 0x18);
+		}
+	}
+}
+
 /**************************************************
  * Init.
  **************************************************/
@@ -212,6 +229,7 @@ static void __devinit bcma_core_pci_clientmode_init(struct bcma_drv_pci *pc)
 	bcma_core_pci_fixcfg(pc);
 	bcma_pcicore_serdes_workaround(pc);
 	bcma_core_pci_config_fixup(pc);
+	bcma_core_pci_apple_fixup(pc);
 }
 
 void __devinit bcma_core_pci_init(struct bcma_drv_pci *pc)
-- 
1.7.9.5


--------------070507000008030207060602--
