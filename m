Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:52862 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737AbZLTFBI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Dec 2009 00:01:08 -0500
Date: Sat, 19 Dec 2009 23:01:05 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: [PATCH] b43: Clear PCI configuration reg. 0x41 to avoid
 interference with C3 processor state
Message-ID: <4b2daf91.VB5IdAW/+fSDNPPV%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In exploring the cause of DMA errors for BCM4312 devices on Atom
processors, other drivers that work write to PCI configuration
register 0x40. The code fragment below was found in the open-code
portion of the Broadcom hybrid wl driver. It is also used in the
ipw2100 and ath9k drivers. In the latter case, it had been removed
and later restored to prevent fatal interrupt errors.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

I think this is 2.6.34 material. By itself, it does not affect the
DMA errors in BCM4312 devices. If it is found to help in the resolution
of that long-standing problem, I will request a change in the status.

Larry
---

Index: wireless-testing/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/main.c
+++ wireless-testing/drivers/net/wireless/b43/main.c
@@ -4292,6 +4292,15 @@ static int b43_wireless_core_init(struct
 	setup_struct_wldev_for_init(dev);
 	phy->ops->prepare_structs(dev);
 
+	/* We disable the RETRY_TIMEOUT register (0x41) to keep
+	 * PCI Tx retries from interfering with C3 CPU state
+	 */
+	if (bus->bustype == SSB_BUSTYPE_PCI) {
+		pci_read_config_dword(bus->host_pci, 0x40, &tmp);
+		pci_write_config_dword(bus->host_pci, 0x40, tmp &
+				       ~(0x0000ff00));
+	}
+
 	/* Enable IRQ routing to this device. */
 	ssb_pcicore_dev_irqvecs_enable(&bus->pcicore, dev->dev);
 
Index: wireless-testing/drivers/ssb/pcihost_wrapper.c
===================================================================
--- wireless-testing.orig/drivers/ssb/pcihost_wrapper.c
+++ wireless-testing/drivers/ssb/pcihost_wrapper.c
@@ -35,6 +35,7 @@ static int ssb_pcihost_resume(struct pci
 {
 	struct ssb_bus *ssb = pci_get_drvdata(dev);
 	int err;
+	u32 val;
 
 	pci_set_power_state(dev, 0);
 	err = pci_enable_device(dev);
