Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f192.google.com ([209.85.222.192]:62345 "EHLO
	mail-pz0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306AbZFRBdk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Jun 2009 21:33:40 -0400
Received: by pzk30 with SMTP id 30so203023pzk.33
        for <linux-wireless@vger.kernel.org>; Wed, 17 Jun 2009 18:33:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <ec2083b20906171821x242f4139u5f0176e66fe71538@mail.gmail.com>
References: <ec2083b20906120654j370e5bdo724a7c3b6d505a6c@mail.gmail.com>
	 <4A326771.6030301@lwfinger.net>
	 <ec2083b20906120759x4a8c247eh61d1f6bdb6f194f6@mail.gmail.com>
	 <4A32E645.1040002@lwfinger.net>
	 <69e28c910906130644i1b0cf636w4a912bbb5ae78d5@mail.gmail.com>
	 <ec2083b20906161209i5318b104w2796915059bd0a08@mail.gmail.com>
	 <ec2083b20906171821x242f4139u5f0176e66fe71538@mail.gmail.com>
Date: Wed, 17 Jun 2009 20:33:43 -0500
Message-ID: <ec2083b20906171833v531f3050i1563f9e8720ce35b@mail.gmail.com>
Subject: Re: 4311 not detected at all
From: "Fabio A. Correa" <facorread@gmail.com>
Cc: wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
To: unlisted-recipients:; (no To-header on input)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

OK, I found new data on my problem, this might shed light on some
fix/enhancement for the driver.

When the system starts, the iomem of the 4311 card is specified to be
pci 0000:06:00.0: reg 10 32bit mmio: [0xd0000000-0xd0003fff]

The iomem of 4311 cannot be allocated:
arch/x86/pci/i386.c:173: pci 0000:06:00.0: BAR 0: can't allocate resource

the next two instructions of file i386.c mean that the iomem range
converts from 0xd0000000-0xd0003fff to 0x000000-0x003fff. Then
b43-pci-bridge tries to allocate this iomem resource, which is
invalid:
drivers/pci/setup-res.c:290: b43-pci-bridge 0000:06:00.0: device not
available because of BAR 0 [0x000000-0x003fff] collisions
drivers/base/dd.c:143: b43-pci-bridge: probe of 0000:06:00.0 failed
with error -22

The 4311 card (06:00.0) is in the PCI Express port 00:1c.2, with
resources that are reported later:
pci 0000:00:1c.2: PCI bridge, secondary bus 0000:06
pci 0000:00:1c.2:   MEM window: 0x88000000-0x880fffff

After booting, lspci -vvv shows:

00:1c.2 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express
Port 3 (rev 01) (prog-if 00 [Normal decode])
        Memory behind bridge: 88000000-880fffff
06:00.0 Network controller: Broadcom Corporation BCM4311 802.11b/g WLAN (rev 01)
        Region 0: Memory at 88000000 (32-bit, non-prefetchable)
[size=16K]

16K = 3fff.

Well then; the b43 controller stops probing my 4311 card because the
wrong resource is probed for.

I am not sure who should I direct this message to.

-- 
Fabio Andrés Correa Durán
