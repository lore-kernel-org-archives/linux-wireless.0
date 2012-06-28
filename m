Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:53432 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995Ab2F1Usn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jun 2012 16:48:43 -0400
Received: by werb14 with SMTP id b14so701411wer.19
        for <linux-wireless@vger.kernel.org>; Thu, 28 Jun 2012 13:48:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1340913949.2602.27.camel@joe2Laptop>
References: <1340912688-3089-1-git-send-email-zajec5@gmail.com>
	<1340912894.5257.0.camel@jlt3.sipsolutions.net>
	<CACna6rwXrspQ_PDfwZbL7jk=hZ6EmhCnebLcp82LaC4T-Khscw@mail.gmail.com>
	<1340913949.2602.27.camel@joe2Laptop>
Date: Thu, 28 Jun 2012 22:48:38 +0200
Message-ID: <CACna6ryT5x5GtDpxb=ukQMhhSTt4CB9AnbYvsFyX566KUjBKEw@mail.gmail.com> (sfid-20120628_224921_237409_F73C1E83)
Subject: Re: [PATCH option A] bcma: use custom printing functions
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2012/6/28 Joe Perches <joe@perches.com>:
> I think it'd be better to add and use:
>
> #define bcma_bus_err(bus, fmt, ...)                             \
>        pr_err("bus %d: " fmt, (bus)->num, ##__VA_ARGS__)
>
> #define bcma_bus_info(bus, fmt, ...)                            \
>        pr_info("bus %d: " fmt, (bus)->num, ##__VA_ARGS__)
>
> or some other equivalent use if you're wedded
> to wanting "bcma-%d:" prefixed output.
>
> I'd rather have the prefix be something like "bcma: <bus#>: ",
> so a dmesg grep pattern can be "^bcma:" but hey, it ain't my code.

It doesn't seem to be sth common to have grep-pable "bcma:". Some examples:
pci_root PNP0A08:00: host bridge window [mem 0x000d8000-0x000dbfff]
pci 0000:00:01.0: [8086:2a41] type 1 class 0x000604
pnp 00:00: [bus 00-ff]
system 00:03: [mem 0xfed00000-0xfed003ff] has been reserved
pci_bus 0000:0a: resource 5 [io  0x0d00-0xffff]
ahci 0000:00:1f.2: version 3.0
scsi0 : ahci
scsi1 : ahci
usb 2-6: New USB device found, idVendor=054c, idProduct=0377
sky2 0000:08:00.0: Yukon-2 EC Ultra chip revision 3
iwlagn 0000:06:00.0: HW Revision ID = 0x0

My decision will be to use
bcma 0:
bcma 1:
bcma 2:
etc. That will be the most compatible solution with the rest of the kernel.

-- 
Rafał
