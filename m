Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:39031 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751954Ab1BGM7D (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Feb 2011 07:59:03 -0500
Subject: Re: [PATCH] wl12xx: Allow wl12xx interrupts to wake up the host
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: ext Ohad Ben-Cohen <ohad@wizery.com>
Cc: coelho@ti.com, linux-wireless@vger.kernel.org
In-Reply-To: <AANLkTim2H+s0mM+7HBubEHbYj5O+PRHDkeJefx64zRKx@mail.gmail.com>
References: <1297078254-4664-1-git-send-email-juuso.oikarinen@nokia.com>
	 <AANLkTinKyrP2fiE-3+nFeHxvKvg_pn02dLc=t-_+VUJS@mail.gmail.com>
	 <1297081781.2064.12.camel@wimaxnb.nmp.nokia.com>
	 <AANLkTim2H+s0mM+7HBubEHbYj5O+PRHDkeJefx64zRKx@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 Feb 2011 14:58:54 +0200
Message-ID: <1297083534.2064.19.camel@wimaxnb.nmp.nokia.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-02-07 at 14:38 +0200, ext Ohad Ben-Cohen wrote:
> On Mon, Feb 7, 2011 at 2:29 PM, Juuso Oikarinen
> <juuso.oikarinen@nokia.com> wrote:
> > On Mon, 2011-02-07 at 14:09 +0200, ext Ohad Ben-Cohen wrote:
> >> On Mon, Feb 7, 2011 at 1:30 PM, <juuso.oikarinen@nokia.com> wrote:
> >> >
> >> > From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
> >> >
> >> > Currently the wl12xx interrupts are not configured to wake up the host, which
> >> > leads to reduced performance.
> >>
> >> Can you elaborate what do you mean ?
> >>
> >> Today the chip is powered off at system suspend, so it won't trigger
> >> any interrupts anyway.
> >>
> >> When additional suspend modes will be introduced (e.g. WoWL) this will
> >> be needed of course.
> >
> > These are not just for suspend, AFAIK, but apply also to power saving
> > states.
> 
> What power states do you mean ? do you mean the cpuidle path ? I don't
> think it's related.
> 
> Can you please describe what was the reduced performance that this
> solved for you ? performance is a hot topic for us now :)

Actually this I don't see any performance impact for better or worse of
this patch on brief testing. I was instructed by some of our other
kernel-dudes that this is actually needed for the cpuidle path too, or
there might be some implications.

I'm currently trying to find out if this is really needed or not.

-Juuso


