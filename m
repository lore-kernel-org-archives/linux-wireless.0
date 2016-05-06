Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f171.google.com ([209.85.223.171]:33738 "EHLO
	mail-io0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753786AbcEFADH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 May 2016 20:03:07 -0400
Received: by mail-io0-f171.google.com with SMTP id f89so100227634ioi.0
        for <linux-wireless@vger.kernel.org>; Thu, 05 May 2016 17:03:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <3L}.2TJP.BPtk86KPbh.1NAtDW@seznam.cz>
References: <3Fn.2TId.FHuvjLBV4z.1NAsIY@seznam.cz>
	<75r.2THk.1aVrEGdo1ry.1N96yR@seznam.cz>
	<CACna6rypnsgK4DeMxL6F8jwuFpzYhvG8O_TA1M4A6j8X6Eh5_A@mail.gmail.com>
	<CACna6rx90=u7ZSY6ZXjWw4CicEQR6Ty-iEc_G9ACLL0j9EfJLg@mail.gmail.com>
	<3L}.2TJP.BPtk86KPbh.1NAtDW@seznam.cz>
Date: Fri, 6 May 2016 02:03:06 +0200
Message-ID: <CACna6rwe9mbcHW+AvtcXvpdvnwZMxkLKzvOLeNp0-XTLB5k6_A@mail.gmail.com> (sfid-20160506_020312_477111_709761A6)
Subject: Re: Planned Support for BCM 43162 [14e4:43ae] rev 02 ?
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Jan Sobotka <xSobotkaJ@seznam.cz>,
	brcm80211 development <brcm80211-dev-list@broadcom.com>
Cc: b43-dev <b43-dev@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 5 May 2016 at 18:22, Jan Sobotka <xSobotkaJ@seznam.cz> wrote:
> Great, now it works. Output:
>
> root@chobot-lenovo-laptop:/home/chobot# echo "14e4 43ae" > /sys/bus/pci/drivers/bcma-pci-bridge/new_id
> root@chobot-lenovo-laptop:/home/chobot# dmesg | egrep "bcma|b43"
> [ 5295.114902] bcma: bus0: Found chip with id 0x4335, rev 0x02 and package 0x01
> [ 5295.114950] bcma: bus0: Core 0 found: ChipCommon (manuf 0x4BF, id 0x800, rev 0x2E, class 0x0)
> [ 5295.114974] bcma: bus0: Core 1 found: IEEE 802.11 (manuf 0x4BF, id 0x812, rev 0x2E, class 0x0)
> [ 5295.115026] bcma: bus0: Core 2 found: ARM CR4 (manuf 0x4BF, id 0x83E, rev 0x04, class 0x0)
> [ 5295.115073] bcma: bus0: Core 3 found: PCIe Gen2 (manuf 0x4BF, id 0x83C, rev 0x04, class 0x0)
> [ 5295.115096] bcma: bus0: Core 4 found: USB 2.0 Device (manuf 0x4BF, id 0x81A, rev 0x14, class 0x0)
> [ 5295.115119] bcma: bus0: Core 5 found: SDIO Device (manuf 0x4BF, id 0x829, rev 0x15, class 0x0)
> [ 5295.115170] bcma: bus0: Bridge found
> [ 5295.115221] bcma-pci-bridge: probe of 0000:02:00.0 failed with error -84

So this is device with BCM4335 chipset which is a FullMAC one AFAIK.
It may be supported by brcmfmac. There is already support for BCM4335
in brcmfmac but it was developed for SDIO devices only. I don't think
we ever met BCM4335 on PCIe device.

You may try:
sudo su
rmmod bcma
echo "14e4 43ae" > /sys/bus/pci/drivers/brcmfmac/new_id
dmesg | grep brcmfmac

However I think brcmfmac may need some extra changes to support
BCM4335 on PCIe. Lets also see if Broadcom team can help us with this.
