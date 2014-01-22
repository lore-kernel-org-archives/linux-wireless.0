Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh04.mail.saunalahti.fi ([62.142.5.110]:44178 "EHLO
	emh04.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755190AbaAVMgJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jan 2014 07:36:09 -0500
Message-ID: <1390394166.4189.28.camel@porter.coelho.fi> (sfid-20140122_133612_438466_767ADB31)
Subject: Re: [PATCH 5/7] mac80211: improve CSA locking
From: Luca Coelho <luca@coelho.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Michal Kazior <michal.kazior@tieto.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 22 Jan 2014 14:36:06 +0200
In-Reply-To: <1390385995.4334.27.camel@jlt4.sipsolutions.net>
References: <1390227670-19030-1-git-send-email-michal.kazior@tieto.com>
	 <1390227670-19030-6-git-send-email-michal.kazior@tieto.com>
	 <1390316761.6199.27.camel@jlt4.sipsolutions.net>
	 <CA+BoTQmsROawL=bcyiXM+zCWKfKr7KPRvDoojKfoCByV97zSUw@mail.gmail.com>
	 <1390380726.4334.4.camel@jlt4.sipsolutions.net>
	 <CA+BoTQm+DipFGQhVnGoVM4JvLgXZv1EZ0Ve4UNnFwnifsKXoCA@mail.gmail.com>
	 <1390382020.4334.17.camel@jlt4.sipsolutions.net>
	 <CA+BoTQ=iQ26EMyOS4Eroqf2G-uLtUUZHAxN6rD3Eq6CvSUj5Xg@mail.gmail.com>
	 (sfid-20140122_111301_086907_C6814DB8) <1390385995.4334.27.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-01-22 at 11:19 +0100, Johannes Berg wrote:
> On Wed, 2014-01-22 at 11:13 +0100, Michal Kazior wrote:
> 
> > > That seems pretty much fine, though I was talking to Luca yesterday and
> > > there is actually a case where a CSA chanctx should be usable later, for
> > > example if you have this:
> > >  * managed mode interface receives a channel switch announcements and
> > > acts on it
> > >  * it also sends an event to userspace (this is a TODO but we're on it)
> > >  * wpa_s decides that a concurrent GO should also switch
> > 
> > Hmm. This sounds interesting. But it makes me wonder..
> > 
> > If STA iface receives CSA it starts it right away? It doesn't care if
> > other interfaces are using a given channel context too? It just
> > assumes other intefaces may actively request channel switch and if
> > they do, the CSA will be 'aggregated/merged'?
> 
> Well, in Luca's implementation a new channel context has to be
> available. In the current implementation, it will simply disconnect if
> using chanctx, or if there's any other interface using the channel (I
> believe)

Yes, that's right.  Unless the channel context we're going to switch to
already exists.  Let's say: we have a STA in channel 1 and a GO in
channel 11; the STA receives a CSA from its AP to change to channel 11;
the STA interface "reserves" the channel 11 context.  The context
already exists, so we don't need a new one and, since we reserve it, it
will remain available, even if the GO goes away from it.

I don't think we should try to merge the channel switches.  We should
just perform them separately, especially because the exact time of the
switch will most likely not be the same (since the TBTTs are not in
sync).

In the STA and GO sharing the context case, the idea is that the STA
interface will send a notification to userspace and let the userspace
take action.  In this case, the userspace will trigger a GO CSA as well.
The userspace will decide the exact timing of the GO CSA (it should be
as close as possible to the original STA CSA).  The userspace will
probably tell the GO to switch to the same context as the STA is
switching to, so both will end up reserving the same channel context.

The non-chanctx case needs to be considered separately.  As Johannes
already mentioned, I simply ignored non-chanctx in my patch for now. :P


> > What about cfg80211 intf combinations? If GO sends a channel switch it
> > will fail on num_available_channels unless you implicitly consider the
> > userspace event you mentioned or export CSA state down to cfg80211.
> 
> Yeah, that's a good point, need to consider that.

Very good point.  I hadn't thought about it.  When mac80211 decides to
change channel to an existing context, it needs to know whether the
combination will be valid or not.


> > At one point I was wondering if channel contexts should be actually
> > exposed in cfg80211. It would probably make it easier to coordinate
> > some CSA scenarios like this in a sane way, don't you think? But then
> > again that's quite big of a change.
> 
> Yeah that'd be a bit of a change, but maybe it's worth it? Not sure.

That's probably going to be necessary.  How would mac80211 be able to
know if the future combination would be possible or not? I thought about
asking cfg80211 if the combination would be okay when reserving a
context, but that wouldn't work if we have >= 2 reservations.  cfg80211
needs to know about the reservations as well. :(

--
Luca.

