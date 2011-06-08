Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:58524 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912Ab1FHTEv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Jun 2011 15:04:51 -0400
Received: by pvg12 with SMTP id 12so383760pvg.19
        for <linux-wireless@vger.kernel.org>; Wed, 08 Jun 2011 12:04:51 -0700 (PDT)
MIME-Version: 1.0
From: Jim Cromie <jim.cromie@gmail.com>
Date: Wed, 8 Jun 2011 13:04:21 -0600
Message-ID: <BANLkTikQwGCYOdtqFiMBbO85oWgJ-r_MOg@mail.gmail.com> (sfid-20110608_210453_896126_8287B900)
Subject: extending support in drivers/net/wireless/mwl8k.c
To: linux-wireless@vger.kernel.org,
	Lennert Buytenhek <buytenh@wantstofly.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I recently got a mini-pci card out of an old/dead Netgear router,
and would like to add support for it in  drivers/net/wireless/mwl8k.c

Ive hacked the PCI-ID into the driver

@@ -5160,6 +5160,7 @@ MODULE_FIRMWARE("mwl8k/fmimage_8366.fw");
 MODULE_FIRMWARE(MWL8K_8366_AP_FW(MWL8K_8366_AP_FW_API));

 static DEFINE_PCI_DEVICE_TABLE(mwl8k_pci_id_table) = {
+       { PCI_VDEVICE(MARVELL, 0x2a02), .driver_data = MWL8363, },
        { PCI_VDEVICE(MARVELL, 0x2a0a), .driver_data = MWL8363, },
        { PCI_VDEVICE(MARVELL, 0x2a0c), .driver_data = MWL8363, },
        { PCI_VDEVICE(MARVELL, 0x2a24), .driver_data = MWL8363, },

such that it registers,

00:0e.0 Ethernet controller: Marvell Technology Group Ltd. 88W8361
[TopDog] 802.11n )
	Subsystem: Marvell Technology Group Ltd. 88W8361 [TopDog] 802.11n Wireless
	Flags: 66MHz, medium devsel, IRQ 5
	Memory at a0010000 (32-bit, non-prefetchable) [size=64K]
	Memory at a0020000 (32-bit, non-prefetchable) [size=64K]
	Capabilities: [40] Power Management version 2
	Kernel modules: mwl8k

but this only gets me an  error loading firmware.
Ive been unable to locate any firmware so far.
I did pull the GPL tarball from netgear; its a 2.4.27
kernel, with 1 firmware mentioned in the -readme:

[jimc@groucho marvell_WNR854T]$ grep 11 WNR854T_README.txt
        This package contains Marvell 11n-draft wireless driver v.2.1.11.p0

but the apparently mentioned file is an ARM executable,
which is quite different from the firmwares that the driver uses.

[jimc@groucho marvell_WNR854T]$ file romfs.src/etc/ap8x-2.1.11.p0.o
romfs.src/etc/ap8x-2.1.11.p0.o: ELF 32-bit LSB relocatable, ARM,
version 1, not stripped

vs

[jimc@groucho marvell_WNR854T]$ file /lib/firmware/mwl8k/*
/lib/firmware/mwl8k/fmimage_8366_ap-1.fw: data
/lib/firmware/mwl8k/fmimage_8366.fw:      data
/lib/firmware/mwl8k/fmimage_8687.fw:      data
/lib/firmware/mwl8k/helper_8366.fw:       DBase 3 data file (5 records)
/lib/firmware/mwl8k/helper_8687.fw:       DBase 3 data file (5 records)

Could someone explain that arm object to me ?
Does this wifi chip have an ARM core in it, and this is the "firmware" ?

fwiw, I get errors when trying to read those dbase 3 files:
[jimc@groucho netgear]$ dumprecs helper_8366.fw
Could not open file helper_8366.fw
Database or Index Open Error


Ive signed up to Marvell extra-net, but havent heard back
re NDA, or any of the technical info I would need.
