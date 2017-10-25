Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from swan.laptop.org ([18.85.44.157]:44157 "EHLO swan.laptop.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751374AbdJYJGt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 25 Oct 2017 05:06:49 -0400
Received: from esk.lan (CPE-121-216-197-179.lnse3.ken.bigpond.net.au [121.216.197.179])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by swan.laptop.org (Postfix) with ESMTPSA id AACD34C097B
        for <linux-wireless@vger.kernel.org>; Wed, 25 Oct 2017 05:06:48 -0400 (EDT)
Date: Wed, 25 Oct 2017 20:06:42 +1100
From: James Cameron <quozl@laptop.org>
To: linux-wireless@vger.kernel.org
Subject: Re: iwlwifi crash with hostapd
Message-ID: <20171025090642.GD19317@us.netrek.org> (sfid-20171025_110655_719435_6061AF91)
References: <b985bbb0-ec49-0506-871e-b65837b05be2@schmut.com>
 <20171016033727.GB13209@us.netrek.org>
 <2f83cea3-1760-1557-c0ff-0d40ab20f9e8@schmut.com>
 <20171017233558.GD6841@us.netrek.org>
 <20171018213337.GA5595@us.netrek.org>
 <bc6a9aa0-8f13-4e8e-0c40-c19246ad2934@schmut.com>
 <20171019205933.GB7281@us.netrek.org>
 <8b961054-0b13-771b-387e-b47837c493ca@schmut.com>
 <20171024210157.GA19317@us.netrek.org>
 <cd09974a-fb0d-2e38-95ce-31dcb6ed10d3@schmut.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <cd09974a-fb0d-2e38-95ce-31dcb6ed10d3@schmut.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 25, 2017 at 09:08:17AM +0200, Mario Theodoridis wrote:
> On 24/10/17 23:01, James Cameron wrote:
> >Summary: WARN_ON(iwl_mvm_is_dqa_supported(mvm)) in
> >iwl_mvm_rx_tx_cmd_single with v4.13, but code is since changed.
> >
> >On Tue, Oct 24, 2017 at 09:56:31PM +0200, Mario Theodoridis wrote:
> >>Sorry for skipping the list one the last one.
> >
> >Sorry, that was my fault.  It was a private message you replied to.
> >
> >>On 19.10.2017 22:59, James Cameron wrote:
> >>[...]
> >
> >You didn't say virtualbox was essential for reproducing the problem,
> >so I'm continuing to exclude it from thought.  If it is essential for
> >reproducing, then you might contact them.
> >
> >Please do make sure you can exclude virtualbox as a cause.
> 
> Let me clarify the virtualbox thing. The machine in question is a VM host.
> It hosts several machines, one of which is my mail server, and another
> (openbsd) which acts as a gateway to the internet for all machines.
> If i run this machine without virtualbox, then my entire network topology is
> off-line. While one could argue, that this is bad design, the alternative
> would be to use openbsd as a virtual host, but i haven't seen many tutorials
> on that. I also would like to run just one machine 24/7 to keep a tap on the
> electricity consumption.
> 
> This machine also bridges several interfaces and acts as a hotspot for my
> wlan.
> 
> So i don't know whether virtualbox is responsible, but not running
> virtualbox is simply not an option.

Thanks.

I don't have a machine with the same wireless device, so I can't hope
to reproduce the problem or test fixes.  I do have a slightly later
wireless device which uses the same driver, but I'm not confident it
would reproduce the problem, because (a) I've not seen the same stack
traces, (b) the WARN_ON relates to device response coded in firmware,
and my wireless device may use different firmware, and (c) it isn't
clear to me what you did to enable the problem.

You do have a machine, and you might do tests without virtualbox,
but as you say, this is not an option for you.

> >>This one pretty quickly loads my syslog with new error stacks. I
> >>haven't tested actual behavior yet, but the logs don't look so hot.
> >
> >Do connections frequently keep dying as before?
> >
> >>I ran another wireless-info (attached) and appended some of the
> >>syslog stuff to it.
> >
> >Thanks, you identified a line of code and cause; a WARN_ON in
> >iwl_mvm_rx_tx_cmd_single;
> >
> >		case TX_STATUS_FAIL_DEST_PS:
> >			/* In DQA, the FW should have stopped the queue and not
> >			 * return this status
> >			 */
> >			WARN_ON(iwl_mvm_is_dqa_supported(mvm));
> >			info->flags |= IEEE80211_TX_STAT_TX_FILTERED;
> >			break;
> >
> >But it is only a warning.  If connections aren't dying, it may not be
> >important to you.
> >
> >Please check you are using the most recent linux-firmware?
> 
> I'm running
> ii  linux-firmware   1.169         all
> from artful.
> No difference to the xenial version.

Good, thanks.

> >>>Several methods, though by far the most common seems to be personal
> >>>experience with offsets.
> >>>
> >>>When you don't have that personal experience, the methods are;
> >>>
> >>>1.  using GDB against the .o file,
> >>>
> >>>2.  using binutils objdump to disassemble .o file or vmlinuz,
> >>>
> >>>3.  using GCC to generate assembly listings,
> >>>
> >>>See https://wiki.ubuntu.com/Kernel/KernelDebuggingTricks right down
> >>>the end of page for the GDB method.
> >>
> >>I have gotten around to that part, yet, as i was busy with the
> >>above, but it seems later versions have issues, too.
> >
> >However, you're still testing old source code.
> >
> >Several changes made since are worth testing, please either
> >cherry-pick the patches or test a 4.14 rc kernel, and without
> >involving dkms or virtualbox.
> 
> Then i'd have to patch those files so they build for 4.14 first.
> I've seen patches, but still need to figure out how to get them
> applied in the build process.

It may be more efficient to wait for your dkms packagers to catch up
so that the v4.14-rc6 or v4.14 kernel will work with your
package configuration.

> -- 
> Mit freundlichen Grüßen/Best Regards
> 
> Mario Theodoridis

-- 
James Cameron
http://quozl.netrek.org/
