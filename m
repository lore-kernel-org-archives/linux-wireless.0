Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hogsmeade.leitwerk.net ([217.28.96.50]:55576 "EHLO
	hogsmeade.leitwerk.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758183AbZJPJtu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Oct 2009 05:49:50 -0400
From: Simon Raffeiner <sturmflut@lieberbiber.de>
To: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/2] rt2x00: Implement support for rt2800pci
Date: Fri, 16 Oct 2009 11:49:11 +0200
References: <200910152137.58164.IvDoorn@gmail.com> <200910152204.16407.IvDoorn@gmail.com>
In-Reply-To: <200910152204.16407.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <200910161149.11661.sturmflut@lieberbiber.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello List,

I was comparing rt2800pci and the INF file of the original RT2860 windows 
driver out curiosity. The original INF file contains 108 PCI id entries, 
rt2800pci.c only 20. At first I thought that an entry like 

PCI\VEN_1814&DEV_0601&SUBSYS_77281432

(Edimax card) in the INF file will be automatically matched by rt2800pci for 
the "1814:0601" vendor/device id, but then I found an additional entry for 
"1432:7728" (the susbsystem id) in the rt2800pci pci_device_id table. 

I am a bit confused: Should every entry from the INF file have a PCI_DEVICE() 
counterpart in our driver (resulting in 108 entries), or is this a special 
case where the Manufacturer (Edimax) produces cards that actually have 
"1432:7728" as vendor/device id.

You can probably tell that I don't have much experience developing kernel 
drivers, but I am willing to get it right.

regards,
Simon Raffeiner




Am Donnerstag, 15. Oktober 2009 22:04:14 schrieb Ivo van Doorn:
> Add support for the rt2860/rt3090 chipsets from Ralink.
> 
> Includes various patches from a lot of people who helped
> getting this driver into the current shape.
> 
> Signed-off-by: Alban Browaeys <prahal@yahoo.com>
> Signed-off-by: Benoit PAPILLAULT <benoit.papillault@free.fr>
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> Signed-off-by: Luis Correia <luis.f.correia@gmail.com>
> Signed-off-by: Mattias Nissler <mattias.nissler@gmx.de>
> Signed-off-by: Mark Asselstine <asselsm@gmail.com>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
> ---
> http://kernel.org/pub/linux/kernel/people/ivd/patches/0003-rt2x00-Implement
> -support-for-rt2800pci.patch --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless"
>  in the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
