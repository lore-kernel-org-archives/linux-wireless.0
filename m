Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:39996 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901AbaAVJNp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jan 2014 04:13:45 -0500
Message-ID: <1390382020.4334.17.camel@jlt4.sipsolutions.net> (sfid-20140122_101350_480720_1585031B)
Subject: Re: [PATCH 5/7] mac80211: improve CSA locking
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Luca Coelho <luca@coelho.fi>
Date: Wed, 22 Jan 2014 10:13:40 +0100
In-Reply-To: <CA+BoTQm+DipFGQhVnGoVM4JvLgXZv1EZ0Ve4UNnFwnifsKXoCA@mail.gmail.com> (sfid-20140122_100715_279178_6AB79543)
References: <1390227670-19030-1-git-send-email-michal.kazior@tieto.com>
	 <1390227670-19030-6-git-send-email-michal.kazior@tieto.com>
	 <1390316761.6199.27.camel@jlt4.sipsolutions.net>
	 <CA+BoTQmsROawL=bcyiXM+zCWKfKr7KPRvDoojKfoCByV97zSUw@mail.gmail.com>
	 <1390380726.4334.4.camel@jlt4.sipsolutions.net>
	 <CA+BoTQm+DipFGQhVnGoVM4JvLgXZv1EZ0Ve4UNnFwnifsKXoCA@mail.gmail.com>
	 (sfid-20140122_100715_279178_6AB79543)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-01-22 at 10:07 +0100, Michal Kazior wrote:

> > Almost - where exactly do you need that? I'm just trying to weigh this
> > patch vs. the other that I didn't like to see if this is needed
> > regardless of the particular approach of how we switch channels later.
> 
> Hmm.. ieee80211_check_concurrent_iface() checks for vif.csa_active so
> I assumed it should be protected by a lock too. But now I'm
> questioning if it should check csa_active at all? It's just an
> interface type change. You can't change iftype of a running (i.e.
> connected/associated/beaconing) interface, right? If interface isn't
> actually running it doesn't use a channel context, so it is fine to
> change iftype regardless of CSA state. What should actually be
> forbidden is to bind to a channel context that is a part of a CSA
> (which I do in the other patch).

That seems pretty much fine, though I was talking to Luca yesterday and
there is actually a case where a CSA chanctx should be usable later, for
example if you have this:
 * managed mode interface receives a channel switch announcements and
acts on it
 * it also sends an event to userspace (this is a TODO but we're on it)
 * wpa_s decides that a concurrent GO should also switch

In that case we'd want them to share the "new" chanctx that it's being
switched into, so the rules may need to be a bit different.

However, for the non-chanctx case, I completely agree, and we should
probably invent a 'fake' or 'pending' chanctx for that like I had
discussed in another email yesterday.

> local->mtx is also used in the later patch to lock out conflicting
> (current impl. just assumes concurrent = conflicting) CSA requests.
> But I wonder (assuming we forege csa_active check in
> ieee80211_check_concurrent_iface) - if we move CSA to be more chanctx
> centric it might actually make more sense to depend on chanctx_mtx
> instead of local->mtx, no?

Well, not sure. You still would have to check for each interface that
it's not already doing a CSA (two CSAs on the same interface seem odd),
but that's an early check? And beyond that, why would two CSAs conflict?

johannes

