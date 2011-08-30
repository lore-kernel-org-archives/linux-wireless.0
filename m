Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:50989 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756364Ab1H3TPY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Aug 2011 15:15:24 -0400
Date: Tue, 30 Aug 2011 15:14:37 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Sven Neumann <s.neumann@raumfeld.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	libertas-dev@lists.infradead.org, daniel@zonque.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] cfg80211: hold reg_mutex when updating regulatory
Message-ID: <20110830191437.GC2660@tuxdriver.com> (sfid-20110830_211710_790621_83BF7A8F)
References: <1310456639-16468-1-git-send-email-s.neumann@raumfeld.com>
 <1310457159-16698-2-git-send-email-s.neumann@raumfeld.com>
 <20110715173240.GD2566@tuxdriver.com>
 <1311367076.27468.4.camel@bender>
 <CAB=NE6U+3VgAz19-r-oY=WCbvw=LtX5OZc-c3Nop3Zdm9m3fvQ@mail.gmail.com>
 <1312100661.687.8.camel@bender>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1312100661.687.8.camel@bender>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jul 31, 2011 at 10:24:21AM +0200, Sven Neumann wrote:
> On Mon, 2011-07-25 at 13:21 -0700, Luis R. Rodriguez wrote:
> > On Fri, Jul 22, 2011 at 1:37 PM, Sven Neumann <s.neumann@raumfeld.com> wrote:
> > > Hi,
> > >
> > > On Fri, 2011-07-15 at 13:32 -0400, John W. Linville wrote:
> > >> Luis, any comment on this?
> > >>
> > >> On Tue, Jul 12, 2011 at 09:52:39AM +0200, Sven Neumann wrote:
> > >> > The function wiphy_update_regulatory() uses the static variable
> > >> > last_request and thus needs to be called with reg_mutex held.
> > >> > This is the case for all users in reg.c, but the function was
> > >> > exported for use by wiphy_register(), from where it is called
> > >> > without the lock being held.
> > >> >
> > >> > Fix this by making wiphy_update_regulatory() private and introducing
> > >> > regulatory_update() as a wrapper that acquires and holds the lock.
> > >> >
> > >> > Signed-off-by: Sven Neumann <s.neumann@raumfeld.com>
> > >
> > > I'd appreciate if someone would review this patch. But probably this is
> > > not really an issue except that it's somewhat ugly to export a function
> > > that should be called with a lock held and that lock is actually
> > > private. But in this particular case it is not a problem, as far as I
> > > can see, since the only user of wiphy_update_regulatory() outside
> > > net/wireless/reg.c is initialization code. So there is not likely going
> > > to be a race condition here.
> > 
> > Apologies for the delay and thanks for the patch. The patch seems good
> > except for the fact that there are so many changes reflected on the
> > patch itself and this can be avoided by splitting the work into a few
> > more patches so that the actual code changes required are reflected
> > cleanly in one patch. Can you perhaps split up your changes so that
> > moves of code are just that and actual code changes are reflected
> > elsewhere?
> 
> Sure, I can do that. But I won't get to it before next week as I am
> currently on vacation.

Did you have a nice vacation?  Are you ready to work on Linux again? :-)

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
