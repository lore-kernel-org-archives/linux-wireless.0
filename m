Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f48.google.com ([74.125.83.48]:48552 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265AbaAVKNB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jan 2014 05:13:01 -0500
Received: by mail-ee0-f48.google.com with SMTP id t10so4693609eei.7
        for <linux-wireless@vger.kernel.org>; Wed, 22 Jan 2014 02:13:00 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1390382020.4334.17.camel@jlt4.sipsolutions.net>
References: <1390227670-19030-1-git-send-email-michal.kazior@tieto.com>
	<1390227670-19030-6-git-send-email-michal.kazior@tieto.com>
	<1390316761.6199.27.camel@jlt4.sipsolutions.net>
	<CA+BoTQmsROawL=bcyiXM+zCWKfKr7KPRvDoojKfoCByV97zSUw@mail.gmail.com>
	<1390380726.4334.4.camel@jlt4.sipsolutions.net>
	<CA+BoTQm+DipFGQhVnGoVM4JvLgXZv1EZ0Ve4UNnFwnifsKXoCA@mail.gmail.com>
	<1390382020.4334.17.camel@jlt4.sipsolutions.net>
Date: Wed, 22 Jan 2014 11:13:00 +0100
Message-ID: <CA+BoTQ=iQ26EMyOS4Eroqf2G-uLtUUZHAxN6rD3Eq6CvSUj5Xg@mail.gmail.com> (sfid-20140122_111307_588621_98BFBC36)
Subject: Re: [PATCH 5/7] mac80211: improve CSA locking
From: Michal Kazior <michal.kazior@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Luca Coelho <luca@coelho.fi>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 22 January 2014 10:13, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Wed, 2014-01-22 at 10:07 +0100, Michal Kazior wrote:
>
>> > Almost - where exactly do you need that? I'm just trying to weigh this
>> > patch vs. the other that I didn't like to see if this is needed
>> > regardless of the particular approach of how we switch channels later.
>>
>> Hmm.. ieee80211_check_concurrent_iface() checks for vif.csa_active so
>> I assumed it should be protected by a lock too. But now I'm
>> questioning if it should check csa_active at all? It's just an
>> interface type change. You can't change iftype of a running (i.e.
>> connected/associated/beaconing) interface, right? If interface isn't
>> actually running it doesn't use a channel context, so it is fine to
>> change iftype regardless of CSA state. What should actually be
>> forbidden is to bind to a channel context that is a part of a CSA
>> (which I do in the other patch).
>
> That seems pretty much fine, though I was talking to Luca yesterday and
> there is actually a case where a CSA chanctx should be usable later, for
> example if you have this:
>  * managed mode interface receives a channel switch announcements and
> acts on it
>  * it also sends an event to userspace (this is a TODO but we're on it)
>  * wpa_s decides that a concurrent GO should also switch

Hmm. This sounds interesting. But it makes me wonder..

If STA iface receives CSA it starts it right away? It doesn't care if
other interfaces are using a given channel context too? It just
assumes other intefaces may actively request channel switch and if
they do, the CSA will be 'aggregated/merged'?

What about cfg80211 intf combinations? If GO sends a channel switch it
will fail on num_available_channels unless you implicitly consider the
userspace event you mentioned or export CSA state down to cfg80211.

At one point I was wondering if channel contexts should be actually
exposed in cfg80211. It would probably make it easier to coordinate
some CSA scenarios like this in a sane way, don't you think? But then
again that's quite big of a change.


> In that case we'd want them to share the "new" chanctx that it's being
> switched into, so the rules may need to be a bit different.
>
> However, for the non-chanctx case, I completely agree, and we should
> probably invent a 'fake' or 'pending' chanctx for that like I had
> discussed in another email yesterday.
>
>> local->mtx is also used in the later patch to lock out conflicting
>> (current impl. just assumes concurrent = conflicting) CSA requests.
>> But I wonder (assuming we forege csa_active check in
>> ieee80211_check_concurrent_iface) - if we move CSA to be more chanctx
>> centric it might actually make more sense to depend on chanctx_mtx
>> instead of local->mtx, no?
>
> Well, not sure. You still would have to check for each interface that
> it's not already doing a CSA (two CSAs on the same interface seem odd),
> but that's an early check? And beyond that, why would two CSAs conflict?

That was just my assumption for a simplified/initial implementation.


Michał
