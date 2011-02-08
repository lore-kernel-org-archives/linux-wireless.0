Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.24]:21897 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751286Ab1BHMim (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Feb 2011 07:38:42 -0500
Subject: Re: [PATCH] wl12xx: Allow wl12xx interrupts to wake up the host
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: ext Kalle Valo <kvalo@adurom.com>
Cc: ext Ohad Ben-Cohen <ohad@wizery.com>, coelho@ti.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <8762su929t.fsf@purkki.adurom.net>
References: <1297078254-4664-1-git-send-email-juuso.oikarinen@nokia.com>
	 <AANLkTinKyrP2fiE-3+nFeHxvKvg_pn02dLc=t-_+VUJS@mail.gmail.com>
	 <1297081781.2064.12.camel@wimaxnb.nmp.nokia.com>
	 <AANLkTim2H+s0mM+7HBubEHbYj5O+PRHDkeJefx64zRKx@mail.gmail.com>
	 <1297083534.2064.19.camel@wimaxnb.nmp.nokia.com>
	 <AANLkTim6J9yizLPcj-ERwVEcp=VXSymXBfFdszHUMp80@mail.gmail.com>
	 <1297151826.2064.68.camel@wimaxnb.nmp.nokia.com>
	 <87aai696lv.fsf@purkki.adurom.net>
	 <1297163582.3389.7.camel@wimaxnb.nmp.nokia.com>
	 <8762su929t.fsf@purkki.adurom.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Feb 2011 14:38:30 +0200
Message-ID: <1297168710.3389.43.camel@wimaxnb.nmp.nokia.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-02-08 at 13:47 +0200, ext Kalle Valo wrote:
> Juuso Oikarinen <juuso.oikarinen@nokia.com> writes:
> 
> > On Tue, 2011-02-08 at 12:13 +0200, ext Kalle Valo wrote:
> >> Juuso Oikarinen <juuso.oikarinen@nokia.com> writes:
> >> 
> >> To me platform specific changes in drivers are always problematic.
> >
> > Yeah I tend to agree.
> >
> > But then for some reason there is this interface in interrupts.h to do
> > this, and AFAIU the one requesting the IRQ and controlling enabling and
> > disabling of it is supposed to also tune this wakeing on/off. Apparently
> > it should even do this when just enabling/disabling the interrupt -
> > which are things performed in the driver.
> 
> Yeah, you have a point. There has to be some reason for adding this.
> Unfortunately the documentation I found was scarse and I didn't get
> how it should be used. For example, wakeup from what? Only from
> suspend? Or also from sleep states? But then again, isn't it obvious
> that an irq from the device should wake the cpu from sleep states?
> 
> And to make this more generic: should all wifi drivers use
> enable_irq_wake()?
> 
> (Just trying to understand this.)
> 

Luca, please discard this patch.

Based on the text in interrupt.h this is for waking up from suspend and
the like, which is not why I'm calling it here - the wl12xx is switched
off in suspend anyway, so no IRQ's.

As you say, it should be self-evident that a WLAN driver (or most other
drivers for that matter) will want to wake the host from
cpu-power-saving state without explicitly having to say that.

Starts to sound like there is some weird hack in our kernel tree. I'll
need to pursue that further.

-Juuso

