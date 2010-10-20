Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:38602 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753028Ab0JTO7Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Oct 2010 10:59:25 -0400
Date: Wed, 20 Oct 2010 09:59:33 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>
Cc: b43-dev@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: [PATCH] ssb: Clear RETRY_TIMEOUT in PCI Configuration for normal
 devices
Message-ID: <4cbf03d5.sBoVK5FZiEsbJ8xu%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The previous patch of this type fixed the case where a PCI device is behind
an SSB->PCI bridge as found on an embedded device. This one treats the normal
case of a "normal" Broadcom wireless PCI core on an SSB interconnect.

MMIO log traces obtained using the Broadcom wl hybrid driver show that
the RETRY_TIMEOUT register (0x41) in PCI configuration space is cleared
if non-zero. Similar code found in other drivers such as ipw2100 show
this operation is needed to keep PCI Tx retries from interfering with
C3 CPU state. There are no known cases where omission of this code has
caused a problem, but this patch is offered just in case such a situation
occurs.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

No particular urgency for this patch.

Larry
---

Index: wireless-testing/drivers/ssb/pcihost_wrapper.c
===================================================================
--- wireless-testing.orig/drivers/ssb/pcihost_wrapper.c
+++ wireless-testing/drivers/ssb/pcihost_wrapper.c
@@ -59,6 +59,7 @@ static int ssb_pcihost_probe(struct pci_
 	struct ssb_bus *ssb;
 	int err = -ENOMEM;
 	const char *name;
+	u32 val;
 
 	ssb = kzalloc(sizeof(*ssb), GFP_KERNEL);
 	if (!ssb)
@@ -74,6 +75,12 @@ static int ssb_pcihost_probe(struct pci_
 		goto err_pci_disable;
 	pci_set_master(dev);
 
+	/* Disable the RETRY_TIMEOUT register (0x41) to keep
+	 * PCI Tx retries from interfering with C3 CPU state */
+	pci_read_config_dword(dev, 0x40, &val);
+	if ((val & 0x0000ff00) != 0)
+		pci_write_config_dword(dev, 0x40, val & 0xffff00ff);
+
 	err = ssb_bus_pcibus_register(ssb, dev);
 	if (err)
 		goto err_pci_release_regions;
