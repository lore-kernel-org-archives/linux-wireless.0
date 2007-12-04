Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:44337 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753206AbXLDP34 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Dec 2007 10:29:56 -0500
Subject: Re: [PATCH] less eventcause shifts
From: David Woodhouse <dwmw2@infradead.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org,
	Holger Schurig <hs4233@mail.mn-solutions.de>,
	libertas-dev@lists.infradead.org
In-Reply-To: <20071204152122.GE19911@tuxdriver.com>
References: <200711280915.11300.hs4233@mail.mn-solutions.de>
	 <1196704681.21151.13.camel@localhost.localdomain>
	 <1196714939.13978.171.camel@pmac.infradead.org>
	 <20071204145437.GC19911@tuxdriver.com>
	 <1196780866.13978.275.camel@pmac.infradead.org>
	 <20071204152122.GE19911@tuxdriver.com>
Content-Type: text/plain
Date: Tue, 04 Dec 2007 15:29:30 +0000
Message-Id: <1196782170.13978.296.camel@pmac.infradead.org> (sfid-20071204_153000_129584_6CC5F541)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Tue, 2007-12-04 at 10:21 -0500, John W. Linville wrote:
> On Tue, Dec 04, 2007 at 03:07:46PM +0000, David Woodhouse wrote:
> > On Tue, 2007-12-04 at 09:54 -0500, John W. Linville wrote:
> > > The result is a nice, rebased set of patches on top of the current
> > > upstream work.	If you simply did a "commit, pull, commit, pull,
> > > etc" cycle then you would end-up with a set of patches that might
> > > no longer apply on top of a clean upstream branch -- been there,
> > > wireless-dev RIP.
> > 
> > Ah, I understand your confusion. It reflects akpm's confusion when he
> > first started trying to use git-bisect.
> > 
> > This thing is, there is no actual need for a 'set of patches'. Git isn't
> > about patches. It's about commits and pulls. It doesn't _matter_ if you
> > had to fix up something when you merged from Linus, because when Linus
> > pulls from your tree, he pulls your manual merge effort too.
> 
> Well I'm a bit hemmed-in -- Linus pull's from Dave and Jeff, they
> pull from me.  Both of them are a bit prone to rebasing as well.
> Even if I just "let it ride" (i.e. didn't rebase), I would still be
> prone to some of the merge difficulties I described when I pulled
> duplicate patches back in from Linus later.
> 
> FWIW, I've seen Linus complain about dirty git history on several
> occassions.  So even if he were pulling directly from me I imagine
> that there would still be a need for some of this quilt-like use of
> git to clean-up things from time to time.

Very occasionally. Never, in my experience, when I'm careful about when
I actually merge. As I said, daily merges are probably a bad idea. :)

> Still, it is true that I might be able to maintain a more consistent
> 'everything' branch if I weren't "serving two masters"...alas.

Yeah, I don't really mean to tell you how to handle it -- I'm just
trying to find a way to work that actually allows me to use git
properly, rather than forcing me in to the old method of stacks of
patches.

Basically, trees which get rebased aren't suitable for git users to base
their work on. It just doesn't work.

> > > [1] If your work does _not_ rely on patches already merged in my tree
> > > then by all means just use Linus' tree.
> > 
> > That was my intention, right up to the point at which a bunch of
> > libertas patches appeared in your tree :)
> 
> It was my understanding that you were working on top of these patches
> anyway (i.e. not rewriting or replacing them).  Anyway they are all
> destined for 2.6.25 so your "Linus + libertas patches" just still be
> just as valid...?

The important question is: is the commit sha1sum the same?

And the answer is no -- the commit corresponding to a given patch may
have a different sha1sum from day to day, in your tree, and when it
finally gets to Linus. That's fair enough -- you deal with patches, not
git. But it sucks for anyone who wants to use git and to base their work
on stuff you have in those patches.

Which is why I thought we'd agreed that I'll commit libertas-related
stuff to libertas-2.6.git for now, where Holger and I can play to our
hearts' content, then ask you to pull when we're done.

I'm open to better suggestions, as long as they're not "you are not
allowed to use git, except as a primitive way of storing patches". :)

-- 
dwmw2

