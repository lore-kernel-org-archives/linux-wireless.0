Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:62827 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752594Ab1AGUBG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Jan 2011 15:01:06 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 07 Jan 2011 12:00:48 -0800
Date: Fri, 7 Jan 2011 12:01:01 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Peter Stuge <peter@stuge.se>
CC: Ben Greear <greearb@candelatech.com>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@venema.h4ckr.net" <ath9k-devel@venema.h4ckr.net>
Subject: Re: [ath9k-devel] [PATCH 3/3] ath9k: Keep track of stations for
 debugfs.
Message-ID: <20110107200101.GE21588@tux>
References: <1294361165-15308-1-git-send-email-greearb@candelatech.com>
 <1294361165-15308-3-git-send-email-greearb@candelatech.com>
 <AANLkTikjjKe96Ok09Yz1R_nqsoO+n-9X-abeF8VUoOwQ@mail.gmail.com>
 <4D267E4D.7000608@candelatech.com>
 <20110107024909.GD20431@tux>
 <4D2685CC.7020502@candelatech.com>
 <20110107153607.11061.qmail@stuge.se>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20110107153607.11061.qmail@stuge.se>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 07, 2011 at 07:36:07AM -0800, Peter Stuge wrote:
> Ben Greear wrote:
> > > but at least other clueless users would not go over stable limit
> > > you have found.
> > 
> > I think it's very likely that the problems I find are general
> > issues that are just much easier to hit with lots of stations.
> 
> I strongly support this. I recognize several of your problems from my
> attempts at using ath9k with only a single STA which was all but stable.

Sure, see my other e-mail.

> > There is probably no 'safe' number of stations...just takes longer
> > to see bugs with fewer stations.
> > 
> > For instance, you still see the failure-to-stop-DMA errors with a
> > single station, right? And the tx locking stuff was just easier to
> > exercise with lots of stations, but it would have been possible to
> > hit it with 2 stations.
> > 
> > The current tx-hang stuff I'm chasing seems like logic bugs in the
> > queueing, probably nothing in particular about the chipset.
> 
> This is also my impression. Since it is important for Atheros to have
> bugzilla reports rather than discussion on list

I'm trying to tell you how you can more efficiently work with developers
on reporting issues, I'm not singling you out but I am telling you that
the energy you spend on complaining on things not being addressed can be
better put on reporting issues more efficiently.

Reporting issues on the list helps but what helps is a describin the
issue for a specific release but the most difficult thing to do sometimes
is to come up with a recipe for a way to reproduce a specific issue. Without
this it is harder to debug issues. If you can come up with ways to reproduce
issues then it becomes easier for engineers to start digging. Additionally
if an issue is seen that was not observed before the reporter may also
do a git bisect to try to identify the culprit commit. Be aware though that
bisecting on wireless-testing can only be done against the master-* tags,
and not on the entire tree due to the way John updates his tree. If you
see the issue on a stable kernel though you can just use Linus' tree or
the linux-2.6-allstable git tree which will have the stable extra versioned
kernels as well.

Reporting issues for stable kernels should go through the kernel bugzilla,
but can start off on the mailing list. ath9k-devel though is not ideal for
reporting major issues and I recommend linux-wireless to be used instead
for that. If an issue is reporting for wireless-testing with a good series
of reproducible steps chances are very high it will be addressed. Motivated
highly technical users willing to help further get bonus points if they go
the extra mile and bisect.

Furthermore, issues can be kept track on here:

http://wireless.kernel.org/en/users/Drivers/ath9k/bugs

This keeps track of major issues reported, and what people are working on.

> I will try to find
> time for creating more and/or new bug reports about my problems.

Good, the bug reports will not be necessary if the issue is not on a
stable kernel as it will just be a regression against the last stable
kernel. If the issue is seen on a 

> (But the ones I have created so far did not really receive very good
> response.)

Try to increase the quality of your reports and I assure you that your
issues will be addressed.

> Note that my AR9280 is not even detected correctly on PCI now so I
> may switch back to AR5008 for that.
> 
> I really should try out FreeBSD too.

Good luck with that ;)

  Luis
