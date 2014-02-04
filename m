Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:42309 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754370AbaBDK1U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Feb 2014 05:27:20 -0500
Message-ID: <1391509638.26522.72.camel@porter.coelho.fi> (sfid-20140204_112811_520036_B2246708)
Subject: Re: [RFC 0/2] cfg80211: add channel switching awareness
From: Luca Coelho <luca@coelho.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Michal Kazior <michal.kazior@tieto.com>,
	linux-wireless@vger.kernel.org
Date: Tue, 04 Feb 2014 12:27:18 +0200
In-Reply-To: <1391431407.4488.9.camel@jlt4.sipsolutions.net>
References: <1391421529-6067-1-git-send-email-michal.kazior@tieto.com>
	 (sfid-20140203_110347_817013_693B94E8) <1391431407.4488.9.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-02-03 at 13:43 +0100, Johannes Berg wrote:
> On Mon, 2014-02-03 at 10:58 +0100, Michal Kazior wrote:
> 
> > The patchset aims at making cfg80211 aware of
> > channel switches.
> 
> That seems like a worthy goal :)

I like the "awareness", but I don't like the control over channel switch
so much.


> > This makes it possible for more elegant channel
> > switching behavior by moving the decision up to
> > cfg80211.
> > 
> > Until now mac80211 could start channel switching
> > internally for STA, mesh and IBSS interfaces
> > without userspace interaction. This bypassed
> > interface combination checks at the very least.
> > 
> > Now mac80211 requests cfg80211 to channel switch
> > an interface, in a similar manner as userspace
> > asks cfg80211 for a channel switch. This makes it
> > possible to perform interface combination checks
> > (albeit it is not implemented yet).
> 
> Couldn't you just return the decision to mac80211? It would also have to
> keep track of start/end of the CSA period, I guess, since a few things
> that Ilan is working on shouldn't be allowed while the AP announces CSA.

mac80211 could keep track of the start/finalize callbacks.  But I don't
think that's a good idea, as I mentioned in the other email.

I think mac80211 should keep the client CSA control and the userspace
should control the host interfaces.  cfg80211 should keep track of the
channel switches and be asked if the switch is okay (so it can take the
interface combinations and regulatory into consideration).

Maybe mac80211 could call a cfg80211_reserve_channel() function? If that
call fails, it means the switch cannot be done.  If it succeeds,
cfg80211 keeps the reservation.  Same thing if the switch is coming from
userspace, nl80211 could call cfg80211_reserve_channel() in the same
way.


> > The channel switch is split into two phases now -
> > start and finalize. This is required to make
> > cfg80211 in control of the whole channel
> > switching process. It also makes it apparent that
> > mac80211's STA CSA offload doesn't work quite well
> > here. Can we kill it?
> 
> No. Well, you could make cfg80211 be in charge, but not wpa_supplicant,
> I think.
> 
> > The initial patchset has a lot of TODOs in the
> > code and the idea is to provide follow up patches
> > that implement missing functionality.
> > 
> > Major drawback now is cfg80211 will refuse a
> > channel switch if there's one in progress already,
> > although this shouldn't be much of a problem in
> > most use cases.
> > 
> > This approach should be suited for multi-interface
> > CSA as well as some other cases such as
> > "GO-follows-STA".
> > 
> > The patchset seemed to work in my limited testing
> > (ath9k as AP and iwldvm as STA).
> 
> Nice. I hope Luca can take a look too :)

I did. :) Hopefully I have added good points and not only complicated
things further. :P

--
Luca.

