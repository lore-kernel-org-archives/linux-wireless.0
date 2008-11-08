Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:60727 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751080AbYKHMer (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Nov 2008 07:34:47 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Ben Greear <greearb@candelatech.com>
Subject: Re: Trouble with bcm4312 rev 01 on the HP 2133
Date: Sat, 8 Nov 2008 13:33:55 +0100
Cc: linux-wireless@vger.kernel.org
References: <49151F8A.7040901@candelatech.com>
In-Reply-To: <49151F8A.7040901@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200811081333.55833.mb@bu3sch.de> (sfid-20081108_133452_316653_1233CF0B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 08 November 2008 06:11:38 Ben Greear wrote:
> lspci -x
> 02:00.0 Network controller: Broadcom Corporation BCM4312 802.11b/g (rev 01)
> 00: e4 14 15 43 06 01 10 00 01 00 80 02 08 00 00 00

Try this, please.

Index: wireless-testing/drivers/ssb/b43_pci_bridge.c
===================================================================
--- wireless-testing.orig/drivers/ssb/b43_pci_bridge.c	2008-05-16 00:25:42.000000000 +0200
+++ wireless-testing/drivers/ssb/b43_pci_bridge.c	2008-11-08 13:33:06.000000000 +0100
@@ -21,6 +21,7 @@ static const struct pci_device_id b43_pc
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4307) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4311) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4312) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4315) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4318) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4319) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4320) },

-- 
Greetings Michael.
