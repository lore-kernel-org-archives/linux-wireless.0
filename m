Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:58564 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677Ab1AQWrq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Jan 2011 17:47:46 -0500
Received: by yxt3 with SMTP id 3so2115866yxt.19
        for <linux-wireless@vger.kernel.org>; Mon, 17 Jan 2011 14:47:46 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1295256929.3726.2.camel@jlt3.sipsolutions.net>
References: <1295156534-4178-1-git-send-email-arik@wizery.com>
 <1295156534-4178-7-git-send-email-arik@wizery.com> <1295167829.3574.10.camel@jlt3.sipsolutions.net>
 <AANLkTik=WDsehr0EgW7QemfdmokvaLzg1ugASwiuCOXt@mail.gmail.com>
 <AANLkTi=FRAjCxOBAtXFdzwSqG6DQ+oneoe-THQjsd_Wx@mail.gmail.com> <1295256929.3726.2.camel@jlt3.sipsolutions.net>
From: Arik Nemtsov <arik@wizery.com>
Date: Tue, 18 Jan 2011 00:47:30 +0200
Message-ID: <AANLkTiky+j6P9oibrWzDzfNugrADtb9p21TVn7WFAY6_@mail.gmail.com>
Subject: Re: Fwd: [PATCH 06/10] mac80211: add HW flag for disabling auto
 link-PS in AP mode
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Luciano Coelho <coelho@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 17, 2011 at 11:35, Johannes Berg <johannes@sipsolutions.net> wrote:
>
> On Sun, 2011-01-16 at 23:53 +0200, Arik Nemtsov wrote:
>
> > > Also, I'm worried about races between this and RX. All of the RX path
> > > assumes that it is running at the same time. The ap_sta_ps_{start,end}
> > > functions won't be called from the RX path when the flag is set, and
> > > this is dependent on setting the flag, but is there really nothing in
> > > them that could race?
> >
> > They might race if the user is not careful. On a SMP machine a user
> > can call ieee80211_rx() and ap_sta_ps_start() from two different
> > workqueues for example.
> > I can add an explicit mutex, but a documentation warning will suffice here no?
>
> Well, a mutex won't be possible, and we don't do "code path locking"

I meant a spinlock of course (but its not really a good idea)

>
> anyway. I'd appreciate if you could actually see which things would
> potentially race -- I took a brief look into these functions and it
> didn't look like there are actually races except of these two against
> each other maybe?

Upon closer examination, I could find no races in the RX path. A race
of ps_start/stop is possible of course, but I guess we can demand the
calls to be synchronized against each other?

I did notice some concurrency that can happen in the TX path. I think
the same essential race is described in
ieee80211_handle_filtered_frame() between RX and TX paths. Only this
time the PS state is changed manually and not in the RX handler. The
warning in ieee80211_handle_filtered_frame() can be expanded to
include:
"always change PS state of connected stations before TX status events
if ordering can be unknown, for example with different interrupt
status bits."

> > sta_notify is pretty useless when the low level driver calls toggles
> > the PS-mode by itself. How about I simply remove the call to
> > sta_notify in case IEEE80211_HW_AP_LINK_PS is set?
> > If a low level driver needs to do some deferred processing after a
> > PS-mode transition, it can queue a work on its own..
>
> Yes, that's probably a good idea -- but definitely needs to be
> documented in the sta_notify docs. OTOH, mac80211 de-bounces sta_notify
> in a way. Maybe that needs to be done for the function call as well,
> maybe via a return value?
>

I'm afraid I didn't catch your meaning here.

Regards,
Arik
