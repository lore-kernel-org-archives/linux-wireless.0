Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vc0-f178.google.com ([209.85.220.178]:42013 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753266AbaIZGPu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Sep 2014 02:15:50 -0400
Received: by mail-vc0-f178.google.com with SMTP id lf12so6506084vcb.37
        for <linux-wireless@vger.kernel.org>; Thu, 25 Sep 2014 23:15:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <542448C0.9040505@Informatik.TU-Cottbus.DE>
References: <542448C0.9040505@Informatik.TU-Cottbus.DE>
Date: Fri, 26 Sep 2014 08:15:49 +0200
Message-ID: <CA+BoTQnTqjp0-CqptLEm=Zm2T9zYUvsfiF9Op7c2NhrQS5ahMg@mail.gmail.com> (sfid-20140926_081554_425788_67A72224)
Subject: Re: Question about debugging mac80211 without printk
From: Michal Kazior <michal.kazior@tieto.com>
To: Pink <pink@informatik.tu-cottbus.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 25 September 2014 18:54, Pink <pink@informatik.tu-cottbus.de> wrote:
> Hi,
>
> actually if have the following problem, if have a lot of debug messages
> using printk inside the mac layer but if there is a
> critical bug in the source code of the mac80211 module
> the system goes into kernel panic state during execution. Unfortunately so
> far i now, it isn't possible
> after a system restart to identify the rough position of the bug looking for
> the debug msg's written before the bug has occured in
> dmesg or syslog because the messages were not saved in follow of the crash.
>
> Now i thought user mode linux (uml) is maybe a potential solution to
> identify the bug, if the kernel running the mac layer
> is executed as virtual machine in uml. But i didn't found any kind of
> description how to forward the physical wireless card except using TAP/TUN
> device to the vm so
> that the kernel inside the vm can run its mac layer directly on the card.
>
> Now my question what tools are you use for the development and testing of
> the ath wireless driver
> as well as the complete wireless stack including mac80211. Is it user mode
> linux or something else?
> If user mode linux is used, is there any howto available to forward the
> atheros card to the vm.

You can try using KVM and pass through devices to a virtual machine.
Passing USB through has no extra requirements albeit from my
experience some USB controllers and USB devices have some issues
sometimes. PCI pass-through requires VT-d or AMD-v to be supported on
both CPU and motherboard.

I actually use this kind of setup (I'm using QEMU) myself. I can
attach gdb, emulate serial console, pass-through rootfs via 9p and
just boot a kernel in the VM omitting bootloader which is really
convenient. If it crashes I can get pretty much all info I need.


Michał
