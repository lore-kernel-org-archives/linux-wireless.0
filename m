Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:33783 "EHLO
	mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450AbcFYPJo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Jun 2016 11:09:44 -0400
Received: by mail-wm0-f65.google.com with SMTP id r201so12895277wme.0
        for <linux-wireless@vger.kernel.org>; Sat, 25 Jun 2016 08:08:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <2421107.Vh3zsAgVDf@debian64>
References: <20160624123430.4097-1-martin.blumenstingl@googlemail.com>
 <20160624123430.4097-4-martin.blumenstingl@googlemail.com> <2421107.Vh3zsAgVDf@debian64>
From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date: Sat, 25 Jun 2016 17:08:29 +0200
Message-ID: <CAFBinCBtjv4XoUyO6007hs0Aiut-mFxeq9jdEBq9d22dqzTvLw@mail.gmail.com> (sfid-20160625_170948_285862_C3374D13)
Subject: Re: [PATCH RFC v3 3/3] ath9k: parse the device configuration from an
 OF node
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: ath9k-devel@qca.qualcomm.com, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org, nbd@nbd.name, mark.rutland@arm.com,
	robh+dt@kernel.org, arend.vanspriel@broadcom.com,
	Mathias Kresin <dev@kresin.me>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jun 25, 2016 at 2:01 PM, Christian Lamparter
<chunkeey@googlemail.com> wrote:
> On Friday, June 24, 2016 02:34:30 PM Martin Blumenstingl wrote:
>> This makes it possible to configure ath9k based devices using
>> devicetree. That makes some out-of-tree "convert devicetree to
>> ath9k_platform_data glue"-code obsolete.
>
> Hm, what about the embedded ath9k pcie chips that need the early
> pci-fixup routine for the device to work properly [0], [1]? How
> will this be handled/integrated? I know that the ar71xx and the
> lantiq platforms use similar pci-fixup routines that need a few
> bytes from the eeprom/cal data. So lantiq has a few extra properties:
> "ath,pci-slot", "ath,device-id" and "ath,eep-flash".
that is exactly the use-case I want to use your owl-loader for (see
[0], it's a small kernel module which adds the PCI configuration for
ath9k devices).
This makes ath,pci-slot and ath,eep-flash obsolete.
As far as I'm aware ath,device-id is a bit of a special case (mtd_read
issues when the caldata is stored at an unaligned position on NOR
flash). So this might be obsolete as well when using owl-loader.

> As an example: the AR9280 in the Cisco Z1 AP is initially
> 0x168c:0xff1f (<-- ath9k doesn't know about that id). The
> pci-fixup routine will change it to  0x168c:0x002A. Only
> then ath9k can take it over and will initialize it.
> Thing is: this is all currently done by platform code for
> those architectures... And currently, the request_firmware
> doesn't work for caldata on UBI partitions.
request_firmware is working on UBI partitions in many cases.
It's just not working when request_firmware is called too early (and
this is not UBI specific, other filesystems might be affected as
well): if it is called before rootfs is mounted (which is the case
when you call it from a PCI fixup function) then it's not working
(like you said).
The "solution" to this is to compile the driver as kernel module (once
this is loadable everything else should be readable as well).
Not only ath9k is affected by this "issue", this is simply a
limitation of request_firmware and/or the linux boot chain.

A few words regarding your owl-loader:
First of all I would like to say "thank you"!
Mathias and I are working on changing the lantiq target in LEDE to use
owl-loader for all (ath9k) devices.
All I had to do was to add another OWL PCI ID, implement a fallback
for the firmware filename when there is no ath9k_platform_data (I'm
using the same pattern as in PATCH 3/3 in this series). You can find
the WIP code here: [1]


Regards,
Martin


[0] https://patchwork.ozlabs.org/patch/607682/
[1] https://github.com/xdarklight/source/commits/ath9k-owl-loader-20160624
