Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f178.google.com ([209.85.223.178]:57164 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752397AbZI1TzZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Sep 2009 15:55:25 -0400
Received: by iwn8 with SMTP id 8so2743775iwn.33
        for <linux-wireless@vger.kernel.org>; Mon, 28 Sep 2009 12:55:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090927210252.GA31472@bombadil.infradead.org>
References: <1253811559.4579.44.camel@pc3.dido> <4ABBAB47.8040300@canonical.com>
	<4ABBBB8C.8080401@hauke-m.de> <43e72e890909241137o7e853edfxb9e159df34927d7b@mail.gmail.com>
	<4ABF8184.9060904@verizon.net> <43e72e890909271250g2936947fj314aad65e10d9788@mail.gmail.com>
	<20090927210252.GA31472@bombadil.infradead.org>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Mon, 28 Sep 2009 12:55:09 -0700
Message-ID: <43e72e890909281255n1cca5b84q871365259077a1bc@mail.gmail.com>
Subject: Re: A problem loading ssb module
To: "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>
Cc: Clyde McPherson <ccmcphe@verizon.net>,
	Hauke Mehrtens <hauke@hauke-m.de>,
	Tim Gardner <tim.gardner@canonical.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	bcm43xx-dev@lists.berlios.de
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Sep 27, 2009 at 2:02 PM, Luis R. Rodriguez
<mcgrof@bombadil.infradead.org> wrote:
> On Sun, Sep 27, 2009 at 12:50:19PM -0700, Luis R. Rodriguez wrote:
>> On Sun, Sep 27, 2009 at 8:15 AM, Clyde McPherson <ccmcphe@verizon.net> wrote:
>> >
>> >
>> >> On Thu, Sep 24, 2009 at 11:33 AM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
>> >>
>> >>>
>> >>> Bryan Wu wrote:
>> >>>
>> >>>>
>> >>>> Mauro Di Domenico wrote:
>> >>>>
>> >>>>>
>> >>>>> Hi,
>> >>>>> I'm testing new b43 modules for my 14e4:4315 broadcom card.
>> >>>>> I've compiled and installed compat-wireless-2009-09-16 in a debian
>> >>>>> machine with kernel version 2.6.30-6.
>> >>>>>
>> >>>>> During the boot I experience this problem:
>> >>>>>
>> >>>>> $ dmesg|egrep "b43|ssb"
>> >>>>>
>> >>>>> [    2.384463] b43-pci-bridge 0000:06:00.0: PCI INT A -> GSI 17 (level,
>> >>>>> low) -> IRQ 17
>> >>>>> [    2.384477] b43-pci-bridge 0000:06:00.0: setting latency timer to 64
>> >>>>> [    2.544344] ssb: Sonics Silicon Backplane found on PCI device
>> >>>>> 0000:06:00.0
>> >>>>> [    6.968981] b43: disagrees about version of symbol
>> >>>>> ssb_device_is_enabled
>> >>>>> [    6.968986] b43: Unknown symbol ssb_device_is_enabled
>> >>>>> [    6.969280] b43: Unknown symbol ssb_pmu_set_ldo_paref
>> >>>>> [    6.969407] b43: disagrees about version of symbol
>> >>>>> ssb_pcicore_dev_irqvecs_enable
>> >>>>> [    6.969410] b43: Unknown symbol ssb_pcicore_dev_irqvecs_enable
>> >>>>> .....
>> >>>>> ....
>> >>>>> ...
>> >>>>>
>> >>>>>
>> >>>>
>> >>>> I faced the exactly same issue as Mauro did. +1 from me, but currently
>> >>>> have
>> >>>> no time to take a deeper look.
>> >>>>
>> >>>> Thanks
>> >>>>
>> >>>
>> >>> Hi,
>> >>>
>> >>> I had the same problem with the ssb module and compat-wireless in ubuntu
>> >>> 9.04. The problem is that the ssb module is integrated into the
>> >>> initramfs image. The version out of the initramfs image is loaded on
>> >>> startup and not the version of compat-wireless. Running "sudo
>> >>> update-initramfs -u" after installing compat-wireless and restaing the
>> >>> system fixes the problem for me. Either Debian/Ubuntu should remove ssb
>> >>> form default initramfs image or compat-wireless should update the image
>> >>> with the install command. At least the compat-wireless documentation
>> >>> needs an update.
>> >>>
>> >>> Hauke
>> >>>
>> >>> (adding Luis and linux-wireless list)
>> >>>
>> >>
>> >> Tim, do you guys update the initramfs upon installation of lbm? If a
>> >> user does not use lbm and uses compat-wireless I suppose we need to do
>> >> something similar.
>> >>
>> >>  Luis
>> >> _______________________________________________
>> >> Bcm43xx-dev mailing list
>> >> Bcm43xx-dev@lists.berlios.de
>> >> https://lists.berlios.de/mailman/listinfo/bcm43xx-dev
>> >>
>> >
>> > All:
>> > I have a large group that uses the ssb module along with the Broadcom 4318,
>> > in a CF form factor. If the CF card is inserted before boot, and the ssb
>> > module is not in the initrd process, the laptops lock up and do not become
>> > operational. The solution to this problem is/was adding the ssb.ko to the
>> > initrd process. So I agree with Luis on this, the ssb module will have to be
>> > added/updated to the initrd process. As for PCI operations, I don't know,
>> > but for PCMCIA operations ssb.ko has to be added and/or updated. Anytime I
>> > am testing new releases of b43, I run "update-initramfs -u" to update the
>> > ssb module. (Sometimes you can do a rmmod ssb and rmmod b43, and then
>> > modprobe them back in. - This saves a reboot)
>>
>> But why is ssb, b43, b44 needed upon early boot?
>
> OK the reason seems to be netboot. Yeah the only fix for distros who want
> this on the initramfs is to update it after a compat-wireless package is
> installed. I suppose we can add a hook to compat-wireless for each distro.
> I'm only familiar with Ubuntu way of doing this so if people are interested
> in other distros you'll need to point/test how to do this on there.
>
> Please try this patch against compat-wireless: (also attached)
>
> From 99af88246c2de71aa799de2b63f9d9ccac41634f Mon Sep 17 00:00:00 2001
> From: Luis R. Rodriguez <lrodriguez@atheros.com>
> Date: Sun, 27 Sep 2009 13:58:22 -0700
> Subject: [PATCH] Add scripts/update-initramfs and use it
>
> Some distributions may ship b44 and ssb on the initramfs for
> netboot. To help with this we need to update the initrafms
> for those distributions.
>
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>

I didn't see much feedback but I'm going to merge this in so that it
gets out with the 2.6.32-rc1 stable compat-wireless release.

  Luis
