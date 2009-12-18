Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:24767 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932115AbZLRQS4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Dec 2009 11:18:56 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 18 Dec 2009 08:18:56 -0800
Date: Fri, 18 Dec 2009 08:18:54 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>
Subject: Re: [ath9k-devel] No probe response from AP after 500ms,
 disconnecting.
Message-ID: <20091218161854.GA6231@tux>
References: <20091216172356.15849.qmail@stuge.se>
 <20091216174112.GD11461@tux>
 <20091216222157.28840.qmail@stuge.se>
 <20091216234308.GA425@tux>
 <20091218115708.14617.qmail@stuge.se>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20091218115708.14617.qmail@stuge.se>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 18, 2009 at 03:57:08AM -0800, Peter Stuge wrote:
> (linux-wireless posters, please Cc me since I am only subscribed to
> ath9k-devel.)
> 
> 
> Hello,
> 
> I get the above error (and thus loss of connectivity) using
> wireless-testing/master as of Dec 13.
> 
> phy0: Atheros AR5416 MAC/BB Rev:2 AR5133 RF Rev:81: mem=0xf8320000, irq=21
> 
> I've previously posted various other info starting at
> http://bugzilla.kernel.org/show_bug.cgi?id=14664#c1
> and
> http://bugzilla.kernel.org/show_bug.cgi?id=14267#c53
> 
> I recently installed this card in my laptop. I had drm-intel.git at
> 2.6.32-rc6 at that time and after seeing the error there I merged
> wireless-testing/master since I thought that was the most recent
> ath9k source. I'm happy to switch to something else if that helps,
> just tell me where to get it.
> 
> I searched for a bug to add my information and find hints. I found
> the above bugs which describe this very symptom, but Luis asked me to
> move over to mailing lists since I see this also in wireless-testing.
> 
> I think I've tried all suggestions in bug 14267, but the issue
> remains.

This seems like your old comments from an old e-mail, but I guess you
include them since you now include linux-wireless.

> Manually disabling power management for the interface (iwconfig eth1
> power off) makes it much more stable but I've still seen the error
> twice. The first time after about a day and then again after a few
> hours. I've been running with power management off since then, a
> couple of days, so far without seeing the problem again.

Neat.

> My attachment in bug 14267 is a log from the first occurence but it
> does not have very many messages leading up to the error. I also have
> a longer debug log from the second time it happened, with about 5000
> lines before the disconnect: http://stuge.se/ath9kdisconn.txt
> 
> 
> I have applied these 6 patches posted by Sujith this week:
> 
> ath9k: Fix bug in assigning sequence number
> ath9k: Clarify Interrupt mitigation
> ath9k: Stop ANI when doing a reset
> ath9k: Remove ANI lock
> ath9k: Fix TX poll routine
> ath9k: Fix TX queue draining
> 
> I then enabled power management and was disconnected after the
> interface had been up for no more than a few minutes. I am now
> running with PM off again, so that I can use the interface. :)

Thanks for testing.

> Luis R. Rodriguez wrote:
> > > > The fix on 2.6.32 which should help AR5416 (so far concrete
> > > > device with issues) is to disable PS by default.
> ..
> > > This worked well for me during brief testing with the -rc6 kernel. I
> > > then switched to wl-testing to be up to date.
> >
> > That's indeed a good move to test.
> 
> To clarify; I only tested with power management off on -rc6 for a few
> minutes, and then I switched to the wireless-testing/master kernel
> that I am running now.

Understood, thanks for the clarification.

> > > The fix to disable by default is included in my kernel, and PS is
> > > off. I still observe the problem,
> >
> > Well so depending on the device you have you may need some patches
> > which may or may not have been present on wireless-testing.
> 
> What exactly does "on wireless-testing" mean? Are they in the
> ath9k-devel archive or the linux-wireless archive? I would prefer to
> fetch from a git, but email works too. Are patches committed to a
> branch on wireless-testing.git? Or is there an ath9k.git?

Wireless-testing is that git tree you cloned. Bleedinge edge wireless
patches posted to linux-wireless get merged to there by John in
preparation for the next merge window.

> > Some recent fixes for ath9k on 2.6.32 and wireless-testing are
> > important,
> 
> As I wrote in one bug comment; I was running a wireless-testing
> kernel per commit c770b16cd572bd434f90794be03ae20f5974e6e9 from Dec
> 13, and I saw the issue twice also with power management disabled.
> 
> It seems to me (of course I don't know the internals though) that
> power management is not the single factor in this issue.

It should also be noted the issues are affecting AR5416 with PS enabled
by default, AR9280 and friends seem to be OK with the latest patches.

> > Sujith also posted some recent fixes. They don't all pertain to
> > power save but some do.
> 
> I applied the above 6 patches from Sujith. It's difficult to know if
> I got the ones you mean without a more specific description. :)
> 
> The patches posted by you to linux-wireless@ on 2009-12-16 are
> included in my wireless-testing/master kernel already:
> 
> ath9k: Fix TX hang poll routine
> commit 73803a9b535b76f36afba4881af22fe7b84f49c0
> CommitDate: Fri Dec 4 16:12:31 2009 -0500
> 
> ath9k: fix processing of TX PS null data frames
> commit 87340fcfc6ada956132878a72efdc75431a684b3
> CommitDate: Fri Dec 4 16:15:41 2009 -0500
> 
> ath9k: Fix maximum tx fifo settings for single stream devices
> commit 499e75e2c226aa49ba1e801462a0bee02756984a
> CommitDate: Fri Dec 4 16:15:42 2009 -0500
> 
> ath9k: fix tx status reporting
> commit e8c6342d989e241513baeba4b05a04b6b1f3bc8b
> CommitDate: Mon Dec 7 17:05:40 2009 -0500
> 
> mac80211: Fix dynamic power save for scanning.
> commit fba4a86f5b2652fac0c508968a3a4b4e03d6b661
> CommitDate: Mon Dec 7 17:05:35 2009 -0500

So these would apply to stable, but wireless-testing should have had
these already. The patche I was referring to from Sujith were posted
only to linux-wireless, these are now merged on wireless-testing.

> > On your bug report you did not indicate if you tested 2.6.32 with
> > the latest patches I had suggested to Justin.
> 
> I did not test them on top of the .32-rc6 kernel but again they're in
> the current kernel and I still reproduce the issue quickly with power
> management on, and have seen it twice with PM off.
> 
> So far I have not seen the issue with PM off and 6 above patches
> applied, that is what I am running with right now and I'll let you
> know what happens. (With PM on the issue is still frequent.)

OK so far this narrows down to a specific AR5416 issue with PM on
by default only.

> > OK you also have an AR5416, which is the first 11n chipset
> > generation for Atheros, the bug report was originally for AR9280.
> > Justin also has an AR5416.
> >
> > Lets make sure to keep these separate.
> 
> The failure mode is the same, AR9280 is PCIe, AR9220 may be too
> uncommon to have any data points and I see the issue only very
> infrequently with power management off on AR5416. I think all these
> factors can support that it is a single issue. But they are in no way
> conclusive! Hopefully it can be fixed somewhere so that there will be
> more data.

They are different hardware, newer hardware families (>= AR9280) are
single chip and quite a few changes went into them, so thinking of them
as equal would be wrong. They certain share a lot but for example the
radios are completely different. Now sure, the issue can be the similar
but it doesn't mean that it is not fixed for some chipsets, ignoring that
would be unfair for those users of the newer harware families.

> > > Nod. Let's go. How can I help further?
> >
> > Try sucking in Sujith's recent posted patches, although none of
> > those are PS fixes,
> 
> Did I get the right ones?

Those are indeed needed but Sujith posted some new patch fixes but
not related to PS. Some of these fixes are to be merged in the next
next 2.6.32.y so might as well go ahead and apply then if using stable
or even wireless-testing. So no, you mised them. Here they are:

http://marc.info/?l=linux-wireless&r=3&b=200912&w=2

Patchwork has them in git am'able form:

http://patchwork.kernel.org/project/linux-wireless/list/

> > and you can also follow the instructions I gave Justin to help
> > debug things.
> 
> I tried to do that already. The debug log I attached didn't have too
> much info leading up to the disconnect though. Feel free to get the
> longer one.
> 
> Is there anything else can I do?

Try with the above, although I doubt they will help AR5416.

  Luis
