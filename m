Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:65092 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753995Ab1APVxq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Jan 2011 16:53:46 -0500
Received: by gyb11 with SMTP id 11so1720637gyb.19
        for <linux-wireless@vger.kernel.org>; Sun, 16 Jan 2011 13:53:45 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTik=WDsehr0EgW7QemfdmokvaLzg1ugASwiuCOXt@mail.gmail.com>
References: <1295156534-4178-1-git-send-email-arik@wizery.com>
 <1295156534-4178-7-git-send-email-arik@wizery.com> <1295167829.3574.10.camel@jlt3.sipsolutions.net>
 <AANLkTik=WDsehr0EgW7QemfdmokvaLzg1ugASwiuCOXt@mail.gmail.com>
From: Arik Nemtsov <arik@wizery.com>
Date: Sun, 16 Jan 2011 23:53:30 +0200
Message-ID: <AANLkTi=FRAjCxOBAtXFdzwSqG6DQ+oneoe-THQjsd_Wx@mail.gmail.com>
Subject: Fwd: [PATCH 06/10] mac80211: add HW flag for disabling auto link-PS
 in AP mode
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Luciano Coelho <coelho@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[ resending - html mail rejected ]

On Sun, Jan 16, 2011 at 10:50, Johannes Berg <johannes@sipsolutions.net> wrote:
>
> > +/**
> > + * ieee80211_start_ps - start PS for connected sta
> > + *
> > + * When operating in AP mode, use this function to inform mac80211
> > + * about a station entering PS mode.
> > + * Note that by default mac80211 will automatically call the internal
> > + * equivalent of this function according to the PM bit of incoming frames.
> > + * Use the IEEE80211_HW_AP_LINK_PS flag to change this.
>
> I think that explanation should be clearer and say that you must call
> this only when the flag is set and vice versa. Also, there should be a
>
> WARN_ON(hw->flags & HW_AP_LINK_PS)
>
> in the functions.

will fix in v2.

>
> Also, maybe just a single function with a bool argument would be more
> appropriate? Call it "ieee80211_sta_ps_transition()" or something like
> that. You should also remove the text about calling the internal
> equivalent -- the internal details might change at any time but the API
> should be documented in a way that makes sense without the internal
> details for the benefit of both sides -- people implementing a driver
> don't need to know about the internal details, and people changing the
> internal details know what semantics to keep.

a single function sounds good. v2.

>
> > + * This function may not be called in IRQ context or process context.
>
> This can't be true -- the latter part you must mean "or with softirqs
> enabled".

Yes you're right.
(While looking at this I discovered that I forgot to disable softirqs
myself. These functions are called from a workqueue in wl12xx - will
be fixed in v2)

>
> Also, I'm worried about races between this and RX. All of the RX path
> assumes that it is running at the same time. The ap_sta_ps_{start,end}
> functions won't be called from the RX path when the flag is set, and
> this is dependent on setting the flag, but is there really nothing in
> them that could race?

They might race if the user is not careful. On a SMP machine a user
can call ieee80211_rx() and ap_sta_ps_start() from two different
workqueues for example.
I can add an explicit mutex, but a documentation warning will suffice here no?

>
> Finally, I'm worried about this calling back into the driver's
> sta_notify callback. If that is to remain that way, it needs to be
> *very* clearly documented, I'd *much* prefer it not doing that but
> handing off to a work struct or so internally.
>

sta_notify is pretty useless when the low level driver calls toggles
the PS-mode by itself. How about I simply remove the call to
sta_notify in case IEEE80211_HW_AP_LINK_PS is set?
If a low level driver needs to do some deferred processing after a
PS-mode transition, it can queue a work on its own..

Regards,
Arik
