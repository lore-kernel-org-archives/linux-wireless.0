Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:44760 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758001AbYBRC3X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Feb 2008 21:29:23 -0500
From: bruno randolf <bruno@thinktube.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: Upstream wireless process changes
Date: Mon, 18 Feb 2008 11:29:14 +0900
Cc: linux-wireless@vger.kernel.org
References: <20080214225728.GC2981@tuxdriver.com>
In-Reply-To: <20080214225728.GC2981@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200802181129.14291.bruno@thinktube.com> (sfid-20080218_022927_850828_D2F2EF85)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 15 February 2008 07:57:28 John W. Linville wrote:
> Greetings,
>
> Given current discussions, it seems timely to revamp some of the
> upstream wireless tree management policies.  I'm sure I still won't
> be able to please everyone, but maybe I can change who gets to be
> unhappy about the process... :-)
>
> Let's review the current process.  The wireless-2.6 tree has a number
> of branches, each with a specific use.  Most of these are for my own
> administrative purposes relating to coping with the processes upstream
> from me.  These include any "fixes", "upstream", or "pending" branches,
> as well as any "master-*" branches.  There are also "merged-*" branches
> which I maintain to assist me when rebases are necessary.  In addition,
> there have been topic branches such as "at76" and (formerly) "ath5k".
> And there is the "mm-master" branch, which primarily just collects
> the topic branches together for testing in -mm.
>
> The "everything" branch is an integration branch which collects patches
> from all the "fixes", "upstream", and "pending" branches as well
> as any topic branches.  This is the branch I ask developers to use.
> The purpose of this branch is to avoid having API-level patches miss
> any drivers as well as to avoid any similar conflicts.
>
> Finally, in the old process the "master" branch always just pointed
> at the most recent full or -rc release from Linus.  This always seemed
> to confuse users looking for the "latest and greatest" wireless bits.
> Moreover, all the branches created confusion among both users and
> developers.
>
> The new process shifts from reliance on branches to the use of
> several trees.  Each tree may have some placeholder branches used for
> administrative purposes, but the interesting bits will be committed
> on the "master" branches of those trees to avoid confusion about
> which tree normal people should use.
>
> The wireless-2.6 tree will primarily become a vehicle for pushing
> patches to the current -rc release.  This replaces the former "fixes"
> branches.  It is my intent that this will not be rebased except in
> the most extreme (and unforseen) circumstances.
>
> A new wireless-2.6.26 tree (or 2.6.x as appropriate in the future) will
> be the vehicle for queueing patches to net-2.6.26 (or its successors)
> in anticipation of the next merge window.  This tree will regularly
> be updated to correspond to the current state of net-2.6.26.  I will
> avoid rebasing this tree as much as possible, but given its dependence
> on net-2.6.26 I will be somewhat at Dave's mercy... :-)
>
> Finally, a new wireless-testing tree will be created to replace the
> usage of the former 'everything' branch.  This tree will be based
> on a current -rc release in hopes avoiding the churn in between
> -rc releases.  The tree may contain topic branches (e.g. "at76")
> as appropriate, as well as picked commits from wireless-2.6 and
> wireless-2.6.26.  I will attempt to limit rebasing this tree as much as
> practical, at the expense of having some ugly history.  However, this
> tree almost certainly will be rebased from time to time, and you should
> expect any patches in this tree to be re-committed in wireless-2.6
> or wireless-2.6.26 before going upstream -- you have been warned!
>
> I hope that this "covers all the bases" for our various process
> needs (merging fixes, queueing for the merge window, integration and
> on-going development).  Any coments or suggestions you might have
> are welcome now. :-)
>
> So, comments?

this might be a stupid question, but which tree do you expect us to base 
regular development patches on? i basically don't really care when my patches 
are merged upstream, and i don't know enough about upstream processes to 
decide that, so i think i'll better leave that decision up to you :)

thanks,
bruno
