Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3187 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752889AbXLDO5c (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Dec 2007 09:57:32 -0500
Date: Tue, 4 Dec 2007 09:54:37 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Dan Williams <dcbw@redhat.com>,
	Holger Schurig <hs4233@mail.mn-solutions.de>,
	linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org
Subject: Re: [PATCH] less eventcause shifts
Message-ID: <20071204145437.GC19911@tuxdriver.com> (sfid-20071204_145735_812470_8260D68F)
References: <200711280915.11300.hs4233@mail.mn-solutions.de> <1196704681.21151.13.camel@localhost.localdomain> <1196714939.13978.171.camel@pmac.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1196714939.13978.171.camel@pmac.infradead.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 03, 2007 at 08:48:59PM +0000, David Woodhouse wrote:
> 
> On Mon, 2007-12-03 at 12:58 -0500, Dan Williams wrote:
> > I'm sort of sitting on these patches until you and Woodhouse start using
> > the same git tree until he's done with the command rework...  It's going
> > to be near impossible to handle both of your patches with any certainty.
> > Any progress on whether you've both been able to work in the same repo?
> 
> http://git.infradead.org/?p=libertas-2.6.git
> 
> It's based on Linus' tree -- we've abandoned John's wireless-dev tree
> altogether. He rebases it and uses branches -- it's just an exercise in
> making git hard.

Re: branches -- I don't see why they bother you.  Mostly you can just
ignore them.

Without branches I would have to have at least two trees (one for
feeding Dave, the other for feeding Jeff) and maybe a third for
development/integration, and it would be more difficult to cherry-pick
commits between them.  How would that be any better?

Re: rebasing -- again it shouldn't matter to you when I rebase most
of the branches.  All the branches besides 'everything' are there
for my own organizational purposes.

I have been rebasing 'everything' when Linus releases an -rc.  If I
don't rebase then over time it becomes a mess.  It becomes difficult
to see what is "in" and what is "out", you get duplicate changelog
entries, you get merge conflicts where there shouldn't be any, etc.
I've been through that with the old wireless-dev tree (RIP) and I
would rather not repeat it.  That said, I _do_ try to avoid rebasing
'everything' when possible.  I don't think I've rebased within an
-rc period in quite some time.

As for "making git hard", git is what makes this easy.  If you are
doing development that relies on patches already merged [1], then
you might start development based on wireless-2.6 like this:

	git clone --reference linux-2.6.git git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git
	git checkout -b work origin/everything
	git branch work-start

That way you have a record of where your patches start.  From there
you happily make you commits until you want to rebase your work on
the latest wireless-2.6 tree.  Then you start by saving a copy of
your work:

	git format-patch --stdout work-start..work > work.mbox

Then you need the updated wireless-2.6.  As you point-out, it may have
been rebased -- a straight pull won't always work.  So, just save your
tree, re-clone the current wireless-2.6, and make a new work branch:

	# rename your old tree
	mv wireless-2.6 wireless-2.6-old

	# This should look familiar!
	git clone --reference linux-2.6.git git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git
	git checkout -b work origin/everything
	git branch work-start

Then replay your work on top of it:

	git-am -s ../wireless-2.6-old/work.mbox

The result is a nice, rebased set of patches on top of the current
upstream work.	If you simply did a "commit, pull, commit, pull,
etc" cycle then you would end-up with a set of patches that might
no longer apply on top of a clean upstream branch -- been there,
wireless-dev RIP.

I really think this is the best methodology for processing patches
so that they are ready for merging when posted.

Hth!

John

[1] If your work does _not_ rely on patches already merged in my tree
then by all means just use Linus' tree.
-- 
John W. Linville
linville@tuxdriver.com
