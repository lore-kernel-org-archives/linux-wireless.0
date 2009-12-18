Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from foo.birdnet.se ([213.88.146.6]:53051 "HELO foo.birdnet.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751060AbZLRMDv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Dec 2009 07:03:51 -0500
Message-ID: <20091218115708.14617.qmail@stuge.se>
Date: Fri, 18 Dec 2009 12:57:08 +0100
From: Peter Stuge <peter@stuge.se>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@lists.ath9k.org
Subject: No probe response from AP after 500ms, disconnecting.
References: <20091216172356.15849.qmail@stuge.se> <20091216174112.GD11461@tux> <20091216222157.28840.qmail@stuge.se> <20091216234308.GA425@tux>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20091216234308.GA425@tux>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

(linux-wireless posters, please Cc me since I am only subscribed to
ath9k-devel.)


Hello,

I get the above error (and thus loss of connectivity) using
wireless-testing/master as of Dec 13.

phy0: Atheros AR5416 MAC/BB Rev:2 AR5133 RF Rev:81: mem=0xf8320000, irq=21

I've previously posted various other info starting at
http://bugzilla.kernel.org/show_bug.cgi?id=14664#c1
and
http://bugzilla.kernel.org/show_bug.cgi?id=14267#c53

I recently installed this card in my laptop. I had drm-intel.git at
2.6.32-rc6 at that time and after seeing the error there I merged
wireless-testing/master since I thought that was the most recent
ath9k source. I'm happy to switch to something else if that helps,
just tell me where to get it.

I searched for a bug to add my information and find hints. I found
the above bugs which describe this very symptom, but Luis asked me to
move over to mailing lists since I see this also in wireless-testing.

I think I've tried all suggestions in bug 14267, but the issue
remains.

Manually disabling power management for the interface (iwconfig eth1
power off) makes it much more stable but I've still seen the error
twice. The first time after about a day and then again after a few
hours. I've been running with power management off since then, a
couple of days, so far without seeing the problem again.

My attachment in bug 14267 is a log from the first occurence but it
does not have very many messages leading up to the error. I also have
a longer debug log from the second time it happened, with about 5000
lines before the disconnect: http://stuge.se/ath9kdisconn.txt


I have applied these 6 patches posted by Sujith this week:

ath9k: Fix bug in assigning sequence number
ath9k: Clarify Interrupt mitigation
ath9k: Stop ANI when doing a reset
ath9k: Remove ANI lock
ath9k: Fix TX poll routine
ath9k: Fix TX queue draining

I then enabled power management and was disconnected after the
interface had been up for no more than a few minutes. I am now
running with PM off again, so that I can use the interface. :)


Luis R. Rodriguez wrote:
> > > The fix on 2.6.32 which should help AR5416 (so far concrete
> > > device with issues) is to disable PS by default.
..
> > This worked well for me during brief testing with the -rc6 kernel. I
> > then switched to wl-testing to be up to date.
> 
> That's indeed a good move to test.

To clarify; I only tested with power management off on -rc6 for a few
minutes, and then I switched to the wireless-testing/master kernel
that I am running now.


> > The fix to disable by default is included in my kernel, and PS is
> > off. I still observe the problem,
> 
> Well so depending on the device you have you may need some patches
> which may or may not have been present on wireless-testing.

What exactly does "on wireless-testing" mean? Are they in the
ath9k-devel archive or the linux-wireless archive? I would prefer to
fetch from a git, but email works too. Are patches committed to a
branch on wireless-testing.git? Or is there an ath9k.git?


> Some recent fixes for ath9k on 2.6.32 and wireless-testing are
> important,

As I wrote in one bug comment; I was running a wireless-testing
kernel per commit c770b16cd572bd434f90794be03ae20f5974e6e9 from Dec
13, and I saw the issue twice also with power management disabled.

It seems to me (of course I don't know the internals though) that
power management is not the single factor in this issue.


> Sujith also posted some recent fixes. They don't all pertain to
> power save but some do.

I applied the above 6 patches from Sujith. It's difficult to know if
I got the ones you mean without a more specific description. :)

The patches posted by you to linux-wireless@ on 2009-12-16 are
included in my wireless-testing/master kernel already:

ath9k: Fix TX hang poll routine
commit 73803a9b535b76f36afba4881af22fe7b84f49c0
CommitDate: Fri Dec 4 16:12:31 2009 -0500

ath9k: fix processing of TX PS null data frames
commit 87340fcfc6ada956132878a72efdc75431a684b3
CommitDate: Fri Dec 4 16:15:41 2009 -0500

ath9k: Fix maximum tx fifo settings for single stream devices
commit 499e75e2c226aa49ba1e801462a0bee02756984a
CommitDate: Fri Dec 4 16:15:42 2009 -0500

ath9k: fix tx status reporting
commit e8c6342d989e241513baeba4b05a04b6b1f3bc8b
CommitDate: Mon Dec 7 17:05:40 2009 -0500

mac80211: Fix dynamic power save for scanning.
commit fba4a86f5b2652fac0c508968a3a4b4e03d6b661
CommitDate: Mon Dec 7 17:05:35 2009 -0500


> On your bug report you did not indicate if you tested 2.6.32 with
> the latest patches I had suggested to Justin.

I did not test them on top of the .32-rc6 kernel but again they're in
the current kernel and I still reproduce the issue quickly with power
management on, and have seen it twice with PM off.

So far I have not seen the issue with PM off and 6 above patches
applied, that is what I am running with right now and I'll let you
know what happens. (With PM on the issue is still frequent.)


> OK you also have an AR5416, which is the first 11n chipset
> generation for Atheros, the bug report was originally for AR9280.
> Justin also has an AR5416.
> 
> Lets make sure to keep these separate.

The failure mode is the same, AR9280 is PCIe, AR9220 may be too
uncommon to have any data points and I see the issue only very
infrequently with power management off on AR5416. I think all these
factors can support that it is a single issue. But they are in no way
conclusive! Hopefully it can be fixed somewhere so that there will be
more data.


> > Nod. Let's go. How can I help further?
> 
> Try sucking in Sujith's recent posted patches, although none of
> those are PS fixes,

Did I get the right ones?


> and you can also follow the instructions I gave Justin to help
> debug things.

I tried to do that already. The debug log I attached didn't have too
much info leading up to the disconnect though. Feel free to get the
longer one.

Is there anything else can I do?


//Peter
