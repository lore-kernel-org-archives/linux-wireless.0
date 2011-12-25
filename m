Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:43543 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751148Ab1LYIWU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Dec 2011 03:22:20 -0500
Received: by lami14 with SMTP id i14so4151607lam.20
        for <linux-wireless@vger.kernel.org>; Sun, 25 Dec 2011 00:22:17 -0800 (PST)
Subject: Re: [PATCH v2 0/2] report stop sched scan when actually done
From: Luciano Coelho <coelho@ti.com>
To: Eyal Shapira <eyal@wizery.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <CAF8O4-zLgwyUhfnZObooN=VLkkVb7QzTS+08VULJSGtGaZ3g8w@mail.gmail.com>
References: <1324462262-10277-1-git-send-email-eyal@wizery.com>
	 <1324480244.3401.6.camel@jlt3.sipsolutions.net>
	 <1324629966.2182.317.camel@cumari>
	 <CAF8O4-wpjuV6j-beXn8d7bNA7jvSeCXMhV=kXDHNYKPgxQUbyw@mail.gmail.com>
	 <CAF8O4-zLgwyUhfnZObooN=VLkkVb7QzTS+08VULJSGtGaZ3g8w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 25 Dec 2011 10:22:14 +0200
Message-ID: <1324801334.2182.403.camel@cumari> (sfid-20111225_092238_526729_F4379285)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2011-12-25 at 01:49 +0200, Eyal Shapira wrote: 
> On Sun, Dec 25, 2011 at 1:48 AM, Eyal Shapira <eyal@wizery.com> wrote:
> > On Fri, Dec 23, 2011 at 10:46 AM, Luciano Coelho <coelho@ti.com> wrote:
> >>
> >> Could the code be changed so that we delay the STOP_SCHED_SCAN command
> >> completion instead? Then userspace can rely on that (as it should
> >> anyway, because the command can fail) instead of having to wait for the
> >> stopped event (which is a change in the API).
> >>
> > Sounds like this would be the best way to go and I'll do that. So no need
> > for these patches. I misunderstood the STOP_SCHED_SCAN NL API to be async (due to the NL events) but it can and should be synchronous AFAIU.
> > (and might sleep / block).

Yep, this sounds better.

> > The only mac80211 change I'd be glad to add is to make sched_scan_stop op return
> > a value so errors can be reported back like it's being done in the sched_scan_stop cfg80211 op

Returning errors from driver errors is not exactly the same things as we
already do now.  If sched_scan_stop in cfg80211 fails it is either
because the userspace screwed up (and sent a stop when it was not
running) or because someone else already stopped the scan.  In both
cases, it is okay, because the userspace can just ignore it and be sure
the scan is stopped.

Now, if the driver fails for some other reason and we return the error
to the userspace, how should it react? In this case it would mean that
the scan is still running, but should the userspace try again? Or
ignore? Hard to know what to do.  (This was Johannes's original opinion
about returning errors there, IIRC).

-- 
Cheers,
Luca.

