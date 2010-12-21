Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 80-190-117-144.ip-home.de ([80.190.117.144]:43370 "EHLO
	bu3sch.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753241Ab0LUW0A (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Dec 2010 17:26:00 -0500
Subject: Re: [PATCH 2/4] b43: N-PHY: implement radio 2056 init steps
From: Michael =?ISO-8859-1?Q?B=FCsch?= <mb@bu3sch.de>
To: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org
In-Reply-To: <AANLkTi=--XSasFtDpiq-uXDrMWjQzrK-cnGZVyqFsSif@mail.gmail.com> (sfid-20101221_072059_167761_B6991268)
References: <1292928622-27651-1-git-send-email-zajec5@gmail.com>
	 <1292928622-27651-2-git-send-email-zajec5@gmail.com>
	 <1292931273.13493.2.camel@maggie>
	 <AANLkTi=--XSasFtDpiq-uXDrMWjQzrK-cnGZVyqFsSif@mail.gmail.com>
	 (sfid-20101221_072059_167761_B6991268)
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 21 Dec 2010 23:25:54 +0100
Message-ID: <1292970354.27806.10.camel@maggie>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-12-21 at 13:20 +0100, Rafał Miłecki wrote: 
> W dniu 21 grudnia 2010 12:34 użytkownik Michael Büsch <mb@bu3sch.de> napisał:
> > On Tue, 2010-12-21 at 11:50 +0100, Rafał Miłecki wrote:
> >> +static void b43_radio_init2056_post(struct b43_wldev *dev)
> >> +{
> >> +     b43_radio_set(dev, B2056_SYN_COM_CTRL, 0xB);
> >> +     b43_radio_set(dev, B2056_SYN_COM_PU, 0x2);
> >> +     b43_radio_set(dev, B2056_SYN_COM_RESET, 0x2);
> >> +     mdelay(1);
> >
> > Please don't use mdelay() ever. The driver is fully preemptible.
> > Use msleep() instead.
> 
> So, using "msleep" allows kernel to switch context, while using
> "mdelay" does not?

Yeah well. msleep() does switch context (at least to the idle task,
if there's nothing else to do). Whereas mdelay() busy-waits in a tight
loop. So on a non-preemptible kernel you will lock up the CPU (and if
there's only one CPU, the whole system) for a millisecond by using
mdelay(). On a preemptible kernel it's somewhat mitigated, but I think
explicit sleep is still better there. Also for advanced speedstep and
powersaving considerations.
In the past we did significant efforts to make the whole driver (Except
the very tiny hardirq handler) preemptible. This improved things a
lot. In the old days, bringing the interface up came along with 
about one-second system lockup (on UP, nonpreempt) and the periodic work
frequently caused things like audio to break. Today that's not an issue
anymore due to removal of huge mdelay() calls and preemptible locking.
Always remember that a millisecond really is a _huge_ amount of time
on a modern CPU.

> If so, should be convert our longer udelay calls (like 300us) to usleep?

Well, in my opinion, yes. I'm pretty sure opinions on that will diverge
from developer to developer, but I think at least in stuff like
periodically happening tasks we should avoid those delays and
use msleep(1) instead.

-- 
Greetings Michael.

