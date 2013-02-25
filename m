Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:43746 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754288Ab3BYRYr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Feb 2013 12:24:47 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1UA1nU-0004My-Do
	for linux-wireless@vger.kernel.org; Mon, 25 Feb 2013 18:25:04 +0100
Received: from ip4.capo.montpellier-agglo.com ([91.213.82.4])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 25 Feb 2013 18:25:04 +0100
Received: from yvan.labadie by ip4.capo.montpellier-agglo.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 25 Feb 2013 18:25:04 +0100
To: linux-wireless@vger.kernel.org
From: Yvan <yvan.labadie@gmail.com>
Subject: Re: ath6kl: AR6004 failed to start on computer boot
Date: Mon, 25 Feb 2013 17:19:49 +0000 (UTC)
Message-ID: <loom.20130225T175854-850@post.gmane.org> (sfid-20130225_182450_783156_BDEE3D25)
References: <CADGp=QfF1bBgqP_X9=+PXfH0xCgPFn=h2VG19uV8_cJ8xzg8gg@mail.gmail.com> <87ehghanxe.fsf@kamboji.qca.qualcomm.com> <CADGp=Qf=j+kWA4EM1Z-xyKkuutW64Fi0vfUNqm1tPM1+4WEKyQ@mail.gmail.com> <511E44B8.3000308@qca.qualcomm.com> <CADGp=QfOyyTpwEg1=XXiyvRE7ZOGsn6TfiPQHs3+Jc3C69RM6Q@mail.gmail.com> <51265413.9080609@lwfinger.net> <87mwuwqtgh.fsf@kamboji.qca.qualcomm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@...> writes:

> 
> Larry Finger <Larry.Finger@...> writes:
> 
> > On 02/21/2013 08:03 AM, Julien Massot wrote:
> >> Hi,
> >> I just find a quick and dirty patch to workaround this issue.
> >> I just reset the device on initialization failure.
> >>
> >> I hope this helps to understand the real issue.
> >>
> 
> [...]
> 
> > I am certain that the real problem here is that ath6kl is requesting
> > firmware with a synchronous call using request_firmware() rather than
> > with the asynchronous request_firmware_nowait(). That used to work,
> > but updates to udev caused the firmware read operation to time out. It
> > works after a reset because the file reading routines are now running;
> > however, the correct fix is to rewrite the firmware reading section.
> 
> I haven't looked at all the details yet, but AFAIK this is about cold vs
> warm booting the chip. When rebooting the host while maintaining the
> power to ar6004 ("warm boot") ath6kl probe fails as the chip is in odd
> state and needs to be reset. It's not about dowloading the firmware
> image from user space, it's about starting the firmware inside the chip.
> 
> And besides, didn't udev finally fix that (after some "feedback" from
> Linus) so that we don't need to change all the drivers?
> 

Hi,

I'm having the exact same problem than Julien, (my kernel log are _exactly_ the 
same than his).

A difference on the behavior: the problem is not on reboot, it's always present 
(normal boot and reboot...).

But the "quick fix" witch consist in adding "reset_device" doesn't work, it just 
goes into a loop (hardware_init fail->reset device->hardware_init fail->...)

Main difference is the linux system:
the architecture is ARM9 (armv4) with a buildroot system and kernel 3.6.7
note: hardware USB port is usb_v1.1 only.

I've tried ath6kl drivers from the kernel and the one from compat-
driver_next(2013-02-20)
=>same result.

The wireless USB dongle is working properly on my linux computer with the same 
compat-driver and same firmware files, so it shouldn't have hardware problem

Another wireless dongle based on RALINK chipset is working properly on my ARM 
system, so this shouldn't be an hardware problem from the board.

Any clue?

KR,
Yvan.



