Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh06.mail.saunalahti.fi ([62.142.5.116]:35621 "EHLO
	emh06.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998AbaAXHlt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jan 2014 02:41:49 -0500
Message-ID: <1390549306.19968.6.camel@porter.coelho.fi> (sfid-20140124_084153_316380_EF056C82)
Subject: Re: [PATCH 5/7] mac80211: improve CSA locking
From: Luca Coelho <luca@coelho.fi>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Otcheretianski, Andrei" <andrei.otcheretianski@intel.com>
Date: Fri, 24 Jan 2014 09:41:46 +0200
In-Reply-To: <CA+BoTQkd6XLYpJPAb-HLosbmT3duVCdpEStpxNCcHCGTx9djzw@mail.gmail.com>
References: <1390227670-19030-1-git-send-email-michal.kazior@tieto.com>
	 <1390227670-19030-6-git-send-email-michal.kazior@tieto.com>
	 <1390316761.6199.27.camel@jlt4.sipsolutions.net>
	 <CA+BoTQmsROawL=bcyiXM+zCWKfKr7KPRvDoojKfoCByV97zSUw@mail.gmail.com>
	 <1390380726.4334.4.camel@jlt4.sipsolutions.net>
	 <CA+BoTQm+DipFGQhVnGoVM4JvLgXZv1EZ0Ve4UNnFwnifsKXoCA@mail.gmail.com>
	 <1390382020.4334.17.camel@jlt4.sipsolutions.net>
	 <CA+BoTQ=iQ26EMyOS4Eroqf2G-uLtUUZHAxN6rD3Eq6CvSUj5Xg@mail.gmail.com>
	 <1390385995.4334.27.camel@jlt4.sipsolutions.net>
	 <1390394166.4189.28.camel@porter.coelho.fi>
	 <1390403432.4334.33.camel@jlt4.sipsolutions.net>
	 <1390403634.4189.39.camel@porter.coelho.fi>
	 <CA+BoTQ=+TGFo0f0z1SymiN5DkeLZUPC_p_YVZ59s=FFqpGV3vQ@mail.gmail.com>
	 <1390458664.4189.48.camel@porter.coelho.fi>
	 <CA+BoTQnyd5HQxU9n=7G8bhJTukMJqZwNmD1FgWowHm2LJ=NUsA@mail.gmail.com>
	 <1390462306.4189.56.camel@porter.coelho.fi>
	 <CA+BoTQn-wjQYfUVxJU+xOUoANKE=8ajmq=ytmzAqVuiqMXJj=w@mail.gmail.com>
	 <1390470648.4189.88.camel@porter.coelho.fi>
	 <CA+BoTQm768pE7w1x9p5dN+qTxYjzf8R5u4WASd4zEaQ=v717BQ@mail.gmail.com>
	 <1390479620.4142.14.camel@jlt4.sipsolutions.net>
	 <CA+BoTQkd6XLYpJPAb-HLosbmT3duVCdpEStpxNCcHCGTx9djzw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-01-23 at 13:38 +0100, Michal Kazior wrote:
> On 23 January 2014 13:20, Johannes Berg <johannes@sipsolutions.net> wrote:
> > On Thu, 2014-01-23 at 11:33 +0100, Michal Kazior wrote:
> >
> >> An extreme approach would to actually update AP IEs in mac80211. This
> >> way it would be possible to pull any interface into CSA implicitly if
> >> you're out of channels. This way single-channel multi-BSS AP could
> >> probably switch atomically without races and your multi-channel
> >> GO-possibly-follows-STA would still work.
> >
> > I don't really like updating IEs in mac80211 much. Asking userspace
> > shouldn't be *that* much slower.
> 
> I'm not really fond the idea either. Though it's not about being
> slower but about the 'dragging other interfaces along' being possibly
> automatic when you're out of channels.

Yeah, I agree that updating the IEs in mac80211 is not a good idea.
That's why I would prefer to have the notifications to the user space
("your interface must switch channel") and wait for the userspace to
request a channel switch (with all the necessary information).


> >> > The CAC might take too long.  If we have an AP1 and a STA and the STA
> >> > gets the CSA from its AP2 with a short count, AP1 may not have the time
> >> > to CAC.  In this case, AP1 have two choices: trust that AP2 is doing the
> >> > right thing and moving to a usable DFS channel or shut itself down.
> >>
> >> That's the point. AP1 doesn't have time to perform CAC in this case,
> >> but it should still be possible for AP1 to _just_ beacon CSA as it's
> >> only a hint. AP1 could then be stopped to perform CAC, and once it's
> >> completed restart the AP1.
> >
> > I don't get this side discussion about CAC. There's no time to do CAC in
> > the middle of a CSA *anyway* since you can't be beaconing on the old
> > channel while doing CAC on the new channel, and if you stop beaconing
> > entirely for the time of the CAC then all clients will likely go away...
> 
> You're right, but..
> 
> 
> > I'm not sure I understand how you can ever do a CSA to a radar channel
> > that would still need CAC?
> 
> You're supposed to fulfil a uniform channel usage spread which
> includes "usable" DFS channels.
> 
> With CSA you're at least able to tell stations to stop Tx and should
> wait for you (the AP) on a different channel.

I think that we should stop transmission in all interfaces that are on a
certain channel when that channel receives a CSA with "quiet" mode.  I'm
not sure this would help your CAC case, but I think it's a wise thing to
do to prevent the other interfaces from transmitting.

--
Luca.

