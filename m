Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:42760 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752321AbZHSSeQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Aug 2009 14:34:16 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2009 11:34:18 -0700
Date: Wed, 19 Aug 2009 11:34:16 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Pavel Roskin <proski@gnu.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	<linux-wireless@vger.kernel.org>
Subject: Re: bisecting with wireless-testing
Message-ID: <20090819183416.GE7126@mosca>
References: <19075.41714.450997.244874@gargle.gargle.HOWL>
 <1250142042.2352.26.camel@ct>
 <200908182346.29416.kunal.gangakhedkar@gmail.com>
 <1250629490.7534.20.camel@mj>
 <43e72e890908181407w2d658392w1f61b7f37beb04d1@mail.gmail.com>
 <1250630158.7534.29.camel@mj>
 <43e72e890908181424l770b3356ie990e9cadcb39877@mail.gmail.com>
 <1250631900.7534.44.camel@mj>
 <20090818215748.GJ20633@mosca>
 <20090819175809.GD5905@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20090819175809.GD5905@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Renaming subject and adding linux-wireless.

On Wed, Aug 19, 2009 at 10:58:09AM -0700, John W. Linville wrote:
> On Tue, Aug 18, 2009 at 02:57:48PM -0700, Luis R. Rodriguez wrote:
> > On Tue, Aug 18, 2009 at 02:45:00PM -0700, Pavel Roskin wrote:
> > > On Tue, 2009-08-18 at 14:24 -0700, Luis R. Rodriguez wrote:
> > >
> > > > > Anyway, why is it better for bisecting?

Just for reference for linux-wireles readers here I had indicated
wireless-next-2.6 was better for bisecting than wireless-testing.

> > > >
> > > > Because to help developers not have to do:
> > > >
> > > > git branch -m poo
> > > > git checkout -b master origin/master
> > > > # Then apply patches manually
> > > >
> > > > Instead of the better rebasing:
> > > >
> > > > git branch -m save-my-stuff
> > > > git checkout -b master origin/master
> > > > git checkout save-my-stuff
> > > > git rebase master
> > >
> > > I use STGit, so perhaps I miss all that fun.  I have never had any
> > > trouble tracking wireless-testing while keeping my patches.
> >
> > Oh this was a long time ago, pre ath5k I think.
> >
> > > > john reverts his patches on wireless-testing before rebasing to Linus'
> > > > tree. There may be some other added benefit other than helping us
> > > > rebase cleanly, not sure. But I do remember before that I never was
> > > > able to rebase my patches, and now rebasing works quite nicely.
> > >
> > > You mean it's better to track wireless-next-2.6 for those of us trying
> > > to stay on top of the wireless development?
> >
> > No, not at all, I meant wireless-next-2.6 is best for bisecting.
> >
> > wireless-testing is indeed the place to look at for development.
> >
> > > I must have missed the
> > > memo.
> >
> > I don't think we ever really publized this much, because technically
> > the reverting won't happen unless John rebases and typically between
> > rebases to a next RC kernel you *could* technically bisect an issue.
> > But not all the times.
> >
> > > Indeed, wireless-next-2.6 has a couple of commits that
> > > wireless-testing doesn't have yet.
> > >
> > > I agree that having to bisect through reverts is not fun, and it takes
> > > one or two extra iterations.
> >
> > Right, which is why I wanted to mention it, will extend the info on
> > the wiki on the development section once John ACKs/NACKs this.
> 
> It should not be necessary to bisect through reverts.  I maintain
> different tags for such purposes.
>
> Always use the lastest merge-* tag as the base for bisection.
> This should be equivalent to whichever -rc release from Linus is the
> current base for wireless-testing.  If you need to go any earlier
> than that, you should be using linux-2.6.
>
> So for example with current tree:
> 
>         git bisect start
>         git bisect bad master-2009-08-19
>         git bisect good merge-2009-08-14
> 
> This should include all of the current wireless patches in
> wireless-testing but not in the base linux-2.6 kernel.

This does indeed help alot. Just to be clear let me provide an
example. So say git tag -l | grep merge | tail -3 yields:

merge-2009-07-24
merge-2009-08-03
merge-2009-08-14

I believe what you are indicating if you are bisecting using to avoid
running into the reverts you'd have to ensure then that you bisect between
a bad commit and the next dated merge tag. So if you ran into a snag say
on master-2009-08-06, you should test if merge-2009-08-03 is good first,
and if its not then consider using linux-2.6.git ? If so wouldn't
the code on master-2009-08-06 not yet be available on linux-2.6.git?

> I haven't tracked-down this thread in the archives...am I addressing
> the issue correctly?

Indeed! Thanks a lot.

  Luis
