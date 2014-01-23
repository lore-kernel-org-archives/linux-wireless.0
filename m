Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:42852 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162AbaAWHbt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jan 2014 02:31:49 -0500
Message-ID: <1390462306.4189.56.camel@porter.coelho.fi> (sfid-20140123_083153_633123_753D8CA3)
Subject: Re: [PATCH 5/7] mac80211: improve CSA locking
From: Luca Coelho <luca@coelho.fi>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Otcheretianski, Andrei" <andrei.otcheretianski@intel.com>
Date: Thu, 23 Jan 2014 09:31:46 +0200
In-Reply-To: <CA+BoTQnyd5HQxU9n=7G8bhJTukMJqZwNmD1FgWowHm2LJ=NUsA@mail.gmail.com>
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
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

(adding Andrei, since he should be aware of these discussions as well ;)

On Thu, 2014-01-23 at 07:41 +0100, Michal Kazior wrote:
> On 23 January 2014 07:31, Luca Coelho <luca@coelho.fi> wrote:
> > On Thu, 2014-01-23 at 07:22 +0100, Michal Kazior wrote:
> >> On 22 January 2014 16:13, Luca Coelho <luca@coelho.fi> wrote:
> >> > On Wed, 2014-01-22 at 16:10 +0100, Johannes Berg wrote:
> >> >> On Wed, 2014-01-22 at 14:36 +0200, Luca Coelho wrote:
> >> >>
> >> >> > I don't think we should try to merge the channel switches.  We should
> >> >> > just perform them separately, especially because the exact time of the
> >> >> > switch will most likely not be the same (since the TBTTs are not in
> >> >> > sync).
> >> >>
> >> >> Do you mean that we shouldn't even have all that new API to switch
> >> >> multiple interfaces simultaneously?
> >> >
> >> > Right, I'm not really sure it's necessary.  PErhaps with non-chanctx we
> >> > need something like that, but maybe it would still be better not to do
> >> > this in the nl80211 API, but sync/merge in cfg80211/mac80211?
> >>
> >> I was thinking about it. This should work, mostly, as long as you're
> >> able to submit CSA requests fast enough and you don't use count 0 or
> >> 1, in which case it becomes racy.
> >
> > CSA with count 0 or 1 are really tricky in many respects.  But still I
> > don't see why it would get racy.  The interfaces will switch
> > independently, making their own chanctx reservations and so on...
> 
> You can't really switch multiple interfaces independently with a
> single-channel hardware. You'll either end up with some interfaces
> disconnected or dragged to a different channel forcefully.

Right... I think there's no way around dragging them all forcefully.

What about this: when mac80211 sees that one interface is about to
switch channel and there are other interfaces in a single-channel
device, it automatically starts channel switch on the other interfaces
as well (really, there's no way around it).  Obviously it needs to
inform userspace in this case and then it's up to the userspace to
decide what to do (drop the connection, or accept the change).

In multi-channel interfaces, we don't switch automatically, but let the
userspace decide what to do with the other interfaces.  If it doesn't do
anything, we end up with each interface on a different channel.

Actually this could be generalized too.  We don't switch automatically
only when we have single-channel interfaces, but when we don't have a
free context for the new channel.

--
Luca.

