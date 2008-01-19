Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:25803 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752266AbYASJ2d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Jan 2008 04:28:33 -0500
From: bruno randolf <bruno@thinktube.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: merge errors on 'everything'
Date: Sat, 19 Jan 2008 18:28:47 +0900
Cc: Kalle Valo <kalle.valo@nokia.com>, Pavel Roskin <proski@gnu.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <200801091043.02204.bruno@thinktube.com> <200801101029.44985.bruno@thinktube.com> <20080110153435.GB3109@tuxdriver.com>
In-Reply-To: <20080110153435.GB3109@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200801191828.47417.bruno@thinktube.com> (sfid-20080119_092851_084151_2E8D1C73)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 11 January 2008 00:34:35 John W. Linville wrote:
> On Thu, Jan 10, 2008 at 10:29:44AM +0900, bruno randolf wrote:
> > On Wednesday 09 January 2008 18:05:26 Kalle Valo wrote:
> > > Pavel Roskin <proski@gnu.org> writes:
> > > >> You'll need to get a fresh clone of the repository -- sorry.
> > > >
> > > > While it's reassuring to see that I'm not missing some elegant
> > > > solution, I think cloning the repository is a major overkill.
> > >
> > > I agree.
> > >
> > > > "git-reset --hard origin/everything" does the trick for me, while
> > > > using much less bandwidth and time.
> > >
> > > I do the same and it has worked for me, at least.
> >
> > thanks for that hint, but still, that sucks if you want to rebase your
> > local work against an updated 'everything'...
> >
> > how do you guys manage your pending patches and local work then?
>
> What I recommend is that you start with your own branch from
> 'everything':
>
> 	git checkout -b work everything
>
> And for convenience, create another branch representing where you
> started:
>
> 	git branch work-start
>
> Now do whatever work you want to do on that branch.  You can continue
> to pull into everything as you like (remember to 'git checkout
> everything' first) -- I generally try to preserve a continuous
> everything branch between -rc releases.  So long as the pull is clean,
> you can rebase your work branch quite easily:
>
> 	git checkout work
> 	git rebase everything
>
> 	# don't forget to move work-start as well
> 	git branch -D work-start
> 	git branch work-start everything
>
> After a rebase of wireless-2.6#everything, you won't have a clean pull
> (as you have observed).  In that case you can reclone (be sure to
> save the old clone!) or use git-reset as described above.  Then you
> can use some simple commands to rebase the patches:
>
> 	git checkout -b new-work everything
> 	git branch new-work-start
>
> 	git format-patch --stdout work-start..work > work.mbox
> 	git am work.mbox
>
> An alternative to the git-format-patch/git-am combination would be
> to use the attached 'rangepick' script.
>
> Hth!
>
> John
>
> P.S.  I have no experience with StGit -- some have said it is
> functionaly similar to what I describe above yet perhaps simpler
> to use...YMMV.

thanks for that! i tried StGIT and it works fine for me, also since i usually 
have to fixup my patches several times before i send them and it can do that 
nicely too.

bruno
