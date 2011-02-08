Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:27817 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752491Ab1BHLNK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Feb 2011 06:13:10 -0500
Subject: Re: [PATCH] wl12xx: Allow wl12xx interrupts to wake up the host
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: ext Kalle Valo <kvalo@adurom.com>
Cc: ext Ohad Ben-Cohen <ohad@wizery.com>, coelho@ti.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <87aai696lv.fsf@purkki.adurom.net>
References: <1297078254-4664-1-git-send-email-juuso.oikarinen@nokia.com>
	 <AANLkTinKyrP2fiE-3+nFeHxvKvg_pn02dLc=t-_+VUJS@mail.gmail.com>
	 <1297081781.2064.12.camel@wimaxnb.nmp.nokia.com>
	 <AANLkTim2H+s0mM+7HBubEHbYj5O+PRHDkeJefx64zRKx@mail.gmail.com>
	 <1297083534.2064.19.camel@wimaxnb.nmp.nokia.com>
	 <AANLkTim6J9yizLPcj-ERwVEcp=VXSymXBfFdszHUMp80@mail.gmail.com>
	 <1297151826.2064.68.camel@wimaxnb.nmp.nokia.com>
	 <87aai696lv.fsf@purkki.adurom.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Feb 2011 13:13:02 +0200
Message-ID: <1297163582.3389.7.camel@wimaxnb.nmp.nokia.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-02-08 at 12:13 +0200, ext Kalle Valo wrote:
> Juuso Oikarinen <juuso.oikarinen@nokia.com> writes:
> 
> >> > I'm currently trying to find out if this is really needed or not.
> >> 
> >> Sure, thanks.
> >
> > They are saying this is needed for OMAP's retention mode too, so AFAIK
> > this is needed, not just for suspend.
> 
> Why make this change in the driver? Doesn't it mean that all drivers
> need to be changed so that they will work in your platform? I would
> have expected that this is done automatically somewhere in the core
> kernel and without any changes to the driver.
> 
> To me platform specific changes in drivers are always problematic.

Yeah I tend to agree.

But then for some reason there is this interface in interrupts.h to do
this, and AFAIU the one requesting the IRQ and controlling enabling and
disabling of it is supposed to also tune this wakeing on/off. Apparently
it should even do this when just enabling/disabling the interrupt -
which are things performed in the driver.

So in this case this would need to be a flag in the interrupt
registration itself, so that the interrupt enable/disable calls could
automatically control wake-up. I guess.

-Juuso


