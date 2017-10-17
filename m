Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lists.laptop.org ([18.85.44.157]:53242 "EHLO swan.laptop.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1761589AbdJQXgJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 17 Oct 2017 19:36:09 -0400
Date: Wed, 18 Oct 2017 10:35:58 +1100
From: James Cameron <quozl@laptop.org>
To: Mario Theodoridis <mario@schmut.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: iwlwifi crash with hostapd
Message-ID: <20171017233558.GD6841@us.netrek.org> (sfid-20171018_013617_451096_FE6043D7)
References: <6e51916a-6178-5620-8f45-54705c1b4d98@schmut.com>
 <20171012212454.GB4362@us.netrek.org>
 <b985bbb0-ec49-0506-871e-b65837b05be2@schmut.com>
 <20171016033727.GB13209@us.netrek.org>
 <2f83cea3-1760-1557-c0ff-0d40ab20f9e8@schmut.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <2f83cea3-1760-1557-c0ff-0d40ab20f9e8@schmut.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 17, 2017 at 09:35:39PM +0200, Mario Theodoridis wrote:
> On 16.10.2017 05:37, James Cameron wrote:
> >On Sun, Oct 15, 2017 at 06:21:36PM +0200, Mario Theodoridis wrote:
> >>Thanks for the pointers, James.
> >>
> >>On 12.10.2017 23:24, James Cameron wrote:
> >>>There's a good chance this problem has been fixed already.  You
> >>>are using a v4.4 kernel with many patches applied by Ubuntu.  Here, we
> >>>are more concerned with the latest kernels, and v4.4 is quite old.
> >>>
> >>>Please test some of the later kernels, see
> >>>https://wiki.ubuntu.com/Kernel/MainlineBuilds
> >>>
> >>>In particular, test v4.13 or v4.14-rc4.
> >>
> >>I'm having a hard time with that, because the virtualbox-dkms build fails
> >>with the 4.13 kernel, and virtualbox unfortunately is essential.
> >
> >Is virtualbox essential for reproducing the problem, or essential for
> >your general use?
> 
> It is essential for general use, like Internet connectivity.

Okay, good, that means we can ignore virtualbox, and leave that to
you.

Please test v4.13 or v4.14-rc5, ignoring virtualbox for the time being.

> >If the former, then that's interesting.
> >
> >If the latter, then you might instead test the v4.13 or v14-rc4
> >kernels for only the problem, and then revert to an older kernel after
> >testing.
> >
> >Either way, to use virtualbox-dkms with a later kernel you may be able
> >to upgrade just the virtualbox packages from a later Ubuntu release.
> >
> >See https://packages.ubuntu.com/virtualbox-dkms and
> >https://packages.ubuntu.com/virtualbox for the later versions available.
> >
> >Purpose of the test can be to help isolate the cause, not only to
> >solve your problem.
> 
> Thanks for the info.
> 
> >
> >[...]
> >You might also try with later firmware package.
> >See https://packages.ubuntu.com/linux-firmware
> >
> >You might also test with booting installation media in live-mode,
> >ignoring the internal disk.
> 
> Ok, that was completely off the radar.

Updating linux-firmware may run different firmware on the wireless
card, and the change in behaviour may fix the problem.  A gamble.

A test with later installation media is useful, because you can verify
problems with different kernels and wireless firmware without change
to configuration.  You might try Ubuntu 17.10 Artful ISO.

> I ended up going the other way. I still had a 4.4.0-79-generic kernel and
> booted that. It does not have this problem.
> After checking out
> git://git.launchpad.net/~ubuntu-kernel/ubuntu/+source/linux/+git/xenial
> i tried to find the culprit but was not able to trace the back trace to a
> potential null pointer or some such. I got stuck at
> iwl_mvm_send_cmd_pdu_status not finding a reference to iwl_mvm_disable_txq
> from there.
> 
> I did got the following diff though
> 
> git diff Ubuntu-4.4.0-79.100 Ubuntu-4.4.0-93.116 --
> drivers/net/wireless/iwlwifi/ drivers/net/wireless/mac80211_hwsim.c >
> wifi.patch
> 
> I don't know whether this came from upstream or was ubuntu sourced.

Upstream.

You found your problem was introduced in an Ubuntu kernel, in the
update from -79 to -93.  This contained Ubuntu backports of two
stable kernel patches, which are also upstream patches;

8fbcfeb8a9cc ("mac80211_hwsim: Replace bogus hrtimer clockid")
from v4.4.69

50ea05efaf3b ("mac80211: pass block ack session timeout to to driver")
from v4.4.77

git log Ubuntu-4.4.0-79.100..Ubuntu-4.4.0-93.116 -- \
drivers/net/wireless/iwlwifi/ drivers/net/wireless/mac80211_hwsim.c

git remote add stable \
git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git
git fetch stable
git log v4.4.68..v4.4.92 -- \
drivers/net/wireless/iwlwifi/ drivers/net/wireless/mac80211_hwsim.c

> This fixed the issue for now, but now i'm stuck on that kernel :(

Yes.

Here in upstream, we would run the latest kernel v4.13 and work to
fix that.  Trouble you had with virtualbox packages would be
eventually solvable, but aren't really a problem with the kernel
itself.

So your next step may be to report an Ubuntu bug, and say that -79
worked fine, and -93 did not.

> While i'm perfectly comfortable with user land C, i have no kernel
> experience (clue stick links definitely welcome).

You might verify the above patches caused the problem by doing a
bisection between -79 and -93.

https://wiki.ubuntu.com/Kernel/KernelBisection

Or by reverting only those patches.

Then report to Ubuntu which patch caused the problem.

> [...]

Hope that helps.

-- 
James Cameron
http://quozl.netrek.org/
