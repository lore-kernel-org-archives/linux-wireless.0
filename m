Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38802 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751449Ab1ELIOa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 May 2011 04:14:30 -0400
Subject: Re: [PATCH] cfg80211: restrict AP beacon intervals
From: Johannes Berg <johannes@sipsolutions.net>
To: =?ISO-8859-1?Q?Bj=F6rn?= Smedman <bjorn.smedman@venatech.se>
Cc: Ben Greear <greearb@candelatech.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <BANLkTikL0iLEWcseFdq572rZcVxVkKg8Hg@mail.gmail.com> (sfid-20110511_233935_918883_4942EA3F)
References: <1304959275.12202.4.camel@jlt3.sipsolutions.net>
	 <4DC81A61.9080101@candelatech.com>
	 <1304959783.12202.7.camel@jlt3.sipsolutions.net>
	 <BANLkTinHqMi=sy=sEzQPTz4QEsoucQXYVA@mail.gmail.com>
	 <1305132500.17892.1.camel@jlt3.sipsolutions.net>
	 <BANLkTikL0iLEWcseFdq572rZcVxVkKg8Hg@mail.gmail.com>
	 (sfid-20110511_233935_918883_4942EA3F)
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 12 May 2011 10:14:23 +0200
Message-ID: <1305188063.3461.3.camel@jlt3.sipsolutions.net> (sfid-20110512_101434_936178_8A548006)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-05-11 at 23:39 +0200, Björn Smedman wrote:
> 2011/5/11 Johannes Berg <johannes@sipsolutions.net>:
> > On Wed, 2011-05-11 at 17:58 +0200, Björn Smedman wrote:
> >
> >> > Yes, in theory that's possible, but apparently no driver actually did
> >> > this correctly. Also, it didn't seem like anyone really cares, and we
> >> > need to enforce some restrictions because otherwise drivers will end up
> >> > doing it wrong, and you'll end up having a beacon interval of 200 while
> >> > advertising 150 for example, which will totally throw off powersaving
> >> > clients.
> >>
> >> I'm very interested in having multiple AP vifs with different beacon
> >> intervals. If we're going to just fail anyway in this case can't we do
> >> that from the drivers instead? I would also prefer that from an
> >> aesthetic point of view, instead of having broken logic in the drivers
> >> "protected" by extra verification in cfg80211.
> >
> > We can't fail from the drivers, they don't have a failure path.
> 
> Wouldn't it be best to add a failure path? Based a quick look it seems
> a little complicated but not unmanageable... Or what do you think?

It's not overly complicated, but I don't like it anyway, that just opens
the door to the drivers failing all kinds of things and to userspace
that'll look random.

> Is there anything else where the driver may not support a certain
> combination of bss configurations? From the top of my head I can think
> of mac address. That should fail as well depending on HW capability,
> right? That seems to be another code path but the same problem (no
> failure path).

That has a failure path, and recently I posted a patch to advertise the
interface type combinations. I don't think MAC addresses impose any sort
of restriction.


Bottom line is this: We currently don't have a driver that handles this
correctly. Therefore, the patch is absolutely correct. If somebody
enhances drivers, they're free to also enhance the checking code, and
(hopefully) include some advertising of what is possible. Currently,
however, the best assumption is that it's not possible, and we should
encode that assumption somewhere in the userspace API.

johannes

