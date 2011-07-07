Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:50038 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755675Ab1GGMGY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jul 2011 08:06:24 -0400
Date: Thu, 7 Jul 2011 13:56:39 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: Jim Cromie <jim.cromie@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: extending support in drivers/net/wireless/mwl8k.c
Message-ID: <20110707115639.GE7810@wantstofly.org> (sfid-20110707_140629_033233_D70849CE)
References: <BANLkTikQwGCYOdtqFiMBbO85oWgJ-r_MOg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <BANLkTikQwGCYOdtqFiMBbO85oWgJ-r_MOg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 08, 2011 at 01:04:21PM -0600, Jim Cromie wrote:

> I recently got a mini-pci card out of an old/dead Netgear router,
> and would like to add support for it in  drivers/net/wireless/mwl8k.c
> 
> Ive hacked the PCI-ID into the driver
> 
> @@ -5160,6 +5160,7 @@ MODULE_FIRMWARE("mwl8k/fmimage_8366.fw");
>  MODULE_FIRMWARE(MWL8K_8366_AP_FW(MWL8K_8366_AP_FW_API));
> 
>  static DEFINE_PCI_DEVICE_TABLE(mwl8k_pci_id_table) = {
> +       { PCI_VDEVICE(MARVELL, 0x2a02), .driver_data = MWL8363, },
>         { PCI_VDEVICE(MARVELL, 0x2a0a), .driver_data = MWL8363, },
>         { PCI_VDEVICE(MARVELL, 0x2a0c), .driver_data = MWL8363, },
>         { PCI_VDEVICE(MARVELL, 0x2a24), .driver_data = MWL8363, },
> 
> such that it registers,
> 
> 00:0e.0 Ethernet controller: Marvell Technology Group Ltd. 88W8361
> [TopDog] 802.11n )
> 	Subsystem: Marvell Technology Group Ltd. 88W8361 [TopDog] 802.11n Wireless
> 	Flags: 66MHz, medium devsel, IRQ 5
> 	Memory at a0010000 (32-bit, non-prefetchable) [size=64K]
> 	Memory at a0020000 (32-bit, non-prefetchable) [size=64K]
> 	Capabilities: [40] Power Management version 2
> 	Kernel modules: mwl8k
> 
> but this only gets me an  error loading firmware.

That'll be because this way, it tries to load the 8363 firmware, while
this is a 8361 card.


> Ive been unable to locate any firmware so far.
> I did pull the GPL tarball from netgear; its a 2.4.27
> kernel, with 1 firmware mentioned in the -readme:
> 
> [jimc@groucho marvell_WNR854T]$ grep 11 WNR854T_README.txt
>         This package contains Marvell 11n-draft wireless driver v.2.1.11.p0
> 
> but the apparently mentioned file is an ARM executable,
> which is quite different from the firmwares that the driver uses.
> 
> [jimc@groucho marvell_WNR854T]$ file romfs.src/etc/ap8x-2.1.11.p0.o
> romfs.src/etc/ap8x-2.1.11.p0.o: ELF 32-bit LSB relocatable, ARM,
> version 1, not stripped

This is an ARM kernel module for the wireless driver, to be used on an
access point or router with an ARM CPU.  It also contains the firmware
for the wireless card.


> [jimc@groucho marvell_WNR854T]$ file /lib/firmware/mwl8k/*
> /lib/firmware/mwl8k/fmimage_8366_ap-1.fw: data
> /lib/firmware/mwl8k/fmimage_8366.fw:      data
> /lib/firmware/mwl8k/fmimage_8687.fw:      data
> /lib/firmware/mwl8k/helper_8366.fw:       DBase 3 data file (5 records)
> /lib/firmware/mwl8k/helper_8687.fw:       DBase 3 data file (5 records)
> 
> Could someone explain that arm object to me ?
> Does this wifi chip have an ARM core in it, and this is the "firmware" ?

These firmware images are for use with the upstream mwl8k driver, where
the firmware isn't supplied with the kernel tree or part of the wireless
driver kernel module.


> fwiw, I get errors when trying to read those dbase 3 files:
> [jimc@groucho netgear]$ dumprecs helper_8366.fw
> Could not open file helper_8366.fw
> Database or Index Open Error

They aren't dbase3 files, they probably just happen to have the right
(wrong) signature bytes to confuse file(1) into thinking that they are.


cheers,
Lennert
