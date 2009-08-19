Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:59383 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753030AbZHSSpM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Aug 2009 14:45:12 -0400
Date: Wed, 19 Aug 2009 14:44:31 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Pavel Roskin <proski@gnu.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	linux-wireless@vger.kernel.org
Subject: Re: bisecting with wireless-testing
Message-ID: <20090819184431.GH5905@tuxdriver.com>
References: <1250142042.2352.26.camel@ct> <200908182346.29416.kunal.gangakhedkar@gmail.com> <1250629490.7534.20.camel@mj> <43e72e890908181407w2d658392w1f61b7f37beb04d1@mail.gmail.com> <1250630158.7534.29.camel@mj> <43e72e890908181424l770b3356ie990e9cadcb39877@mail.gmail.com> <1250631900.7534.44.camel@mj> <20090818215748.GJ20633@mosca> <20090819175809.GD5905@tuxdriver.com> <20090819183416.GE7126@mosca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090819183416.GE7126@mosca>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 19, 2009 at 11:34:16AM -0700, Luis R. Rodriguez wrote:
> Renaming subject and adding linux-wireless.
> 
> On Wed, Aug 19, 2009 at 10:58:09AM -0700, John W. Linville wrote:

> > It should not be necessary to bisect through reverts.  I maintain
> > different tags for such purposes.
> >
> > Always use the lastest merge-* tag as the base for bisection.
> > This should be equivalent to whichever -rc release from Linus is the
> > current base for wireless-testing.  If you need to go any earlier
> > than that, you should be using linux-2.6.
> >
> > So for example with current tree:
> > 
> >         git bisect start
> >         git bisect bad master-2009-08-19
> >         git bisect good merge-2009-08-14
> > 
> > This should include all of the current wireless patches in
> > wireless-testing but not in the base linux-2.6 kernel.
> 
> This does indeed help alot. Just to be clear let me provide an
> example. So say git tag -l | grep merge | tail -3 yields:
> 
> merge-2009-07-24
> merge-2009-08-03
> merge-2009-08-14
> 
> I believe what you are indicating if you are bisecting using to avoid
> running into the reverts you'd have to ensure then that you bisect between
> a bad commit and the next dated merge tag. So if you ran into a snag say
> on master-2009-08-06, you should test if merge-2009-08-03 is good first,
> and if its not then consider using linux-2.6.git ? If so wouldn't
> the code on master-2009-08-06 not yet be available on linux-2.6.git?

If you look, merge-2009-08-03 is identical to 2.6.31-rc5:

	git diff merge-2009-08-03..v2.6.31-rc5

So if you have a problem in master-2009-08-06, then either the
problem exists in v2.6.31-rc5 or it is between merge-2009-08-03 and
master-2009-08-06.  (Read the tags carefully, they look similar.)

The point is, it never makes sense to use a good marker any
farther back than the most recent merge-* tag when trying to bisect
wireless-testing.  Otherwise, all the reverts and such will cause
confusion.  If the problem still exists at the most recent merge-*
tag, then the problem is in linux-2.6 and should be bisected there.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
