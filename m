Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3200 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754503AbYAJPvp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jan 2008 10:51:45 -0500
Date: Thu, 10 Jan 2008 10:34:35 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: bruno randolf <bruno@thinktube.com>
Cc: Kalle Valo <kalle.valo@nokia.com>, Pavel Roskin <proski@gnu.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: merge errors on 'everything'
Message-ID: <20080110153435.GB3109@tuxdriver.com> (sfid-20080110_155148_884329_C0B06337)
References: <200801091043.02204.bruno@thinktube.com> <1199845968.3697.22.camel@dv> <87myrf74ix.fsf@nokia.com> <200801101029.44985.bruno@thinktube.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="ReaqsoxgOBHFXBhH"
In-Reply-To: <200801101029.44985.bruno@thinktube.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--ReaqsoxgOBHFXBhH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 10, 2008 at 10:29:44AM +0900, bruno randolf wrote:
> On Wednesday 09 January 2008 18:05:26 Kalle Valo wrote:
> > Pavel Roskin <proski@gnu.org> writes:
> > >> You'll need to get a fresh clone of the repository -- sorry.
> > >
> > > While it's reassuring to see that I'm not missing some elegant solution,
> > > I think cloning the repository is a major overkill.
> >
> > I agree.
> >
> > > "git-reset --hard origin/everything" does the trick for me, while using
> > > much less bandwidth and time.
> >
> > I do the same and it has worked for me, at least.
> 
> thanks for that hint, but still, that sucks if you want to rebase your local 
> work against an updated 'everything'...
> 
> how do you guys manage your pending patches and local work then?

What I recommend is that you start with your own branch from
'everything':

	git checkout -b work everything

And for convenience, create another branch representing where you
started:

	git branch work-start

Now do whatever work you want to do on that branch.  You can continue
to pull into everything as you like (remember to 'git checkout
everything' first) -- I generally try to preserve a continuous
everything branch between -rc releases.  So long as the pull is clean,
you can rebase your work branch quite easily:

	git checkout work
	git rebase everything

	# don't forget to move work-start as well
	git branch -D work-start
	git branch work-start everything

After a rebase of wireless-2.6#everything, you won't have a clean pull
(as you have observed).  In that case you can reclone (be sure to
save the old clone!) or use git-reset as described above.  Then you
can use some simple commands to rebase the patches:

	git checkout -b new-work everything
	git branch new-work-start

	git format-patch --stdout work-start..work > work.mbox
	git am work.mbox

An alternative to the git-format-patch/git-am combination would be
to use the attached 'rangepick' script.

Hth!

John

P.S.  I have no experience with StGit -- some have said it is
functionaly similar to what I describe above yet perhaps simpler
to use...YMMV.
-- 
John W. Linville
linville@tuxdriver.com

--ReaqsoxgOBHFXBhH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=rangepick

#!/bin/sh

git log --no-merges $1 | grep ^commit | awk '{ print $2 }' | tac | \
while read commit
do
	if ! git cherry-pick $commit
	then
		echo Failed to cherry-pick commit ${commit}!
		break
	fi
done

--ReaqsoxgOBHFXBhH--
