Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lists.laptop.org ([18.85.44.157]:38416 "EHLO swan.laptop.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751477AbdJXVCF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 24 Oct 2017 17:02:05 -0400
Date: Wed, 25 Oct 2017 08:01:57 +1100
From: James Cameron <quozl@laptop.org>
To: Mario Theodoridis <mario@schmut.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: iwlwifi crash with hostapd
Message-ID: <20171024210157.GA19317@us.netrek.org> (sfid-20171024_230259_308099_C81DED9C)
References: <6e51916a-6178-5620-8f45-54705c1b4d98@schmut.com>
 <20171012212454.GB4362@us.netrek.org>
 <b985bbb0-ec49-0506-871e-b65837b05be2@schmut.com>
 <20171016033727.GB13209@us.netrek.org>
 <2f83cea3-1760-1557-c0ff-0d40ab20f9e8@schmut.com>
 <20171017233558.GD6841@us.netrek.org>
 <20171018213337.GA5595@us.netrek.org>
 <bc6a9aa0-8f13-4e8e-0c40-c19246ad2934@schmut.com>
 <20171019205933.GB7281@us.netrek.org>
 <8b961054-0b13-771b-387e-b47837c493ca@schmut.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <8b961054-0b13-771b-387e-b47837c493ca@schmut.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Summary: WARN_ON(iwl_mvm_is_dqa_supported(mvm)) in
iwl_mvm_rx_tx_cmd_single with v4.13, but code is since changed.

On Tue, Oct 24, 2017 at 09:56:31PM +0200, Mario Theodoridis wrote:
> Sorry for skipping the list one the last one.

Sorry, that was my fault.  It was a private message you replied to.

> On 19.10.2017 22:59, James Cameron wrote:
> >On Thu, Oct 19, 2017 at 08:56:46AM +0200, Mario Theodoridis wrote:
> >>On 18/10/17 23:33, James Cameron wrote:
> >>
> >>     For your interest, kernel v4.4.93 in stable series just released has
> >>     changes in relevant files.
> >>
> >>     https://lwn.net/Articles/736770/
> >>
> >>Thanks James,
> >>
> >>after looking into bisection last night, i found that just before
> >>i wanted to test out the 4.4.0-82 kernel, i found 3 stack traces
> >>in my syslog. :(
> >>
> >>I guess, i'm dealing with race conditions now. But it seems the 79
> >>kernel still crashes wifi a lot less than later ones.
> >>
> >>How do i get line numbers into these traces?
> 
> As the 4.4.0-79 kernel was sometimes crapping out, too, i decided to
> try to test the latest kernel instead of bisecting after all.  This
> took a while because virtualbox was being a bitch. virtualbox-5.0
> doesn't bode well with virtualbox-dkms-51, so i ended up rebuilding
> virtualbox-5.1 to prevent dependency hell.  The vb-dkms package
> doesn't do 4.14, so i ended up going with the 4.13 kernel that comes
> with artful.

You didn't say virtualbox was essential for reproducing the problem,
so I'm continuing to exclude it from thought.  If it is essential for
reproducing, then you might contact them.

Please do make sure you can exclude virtualbox as a cause.

> This one pretty quickly loads my syslog with new error stacks. I
> haven't tested actual behavior yet, but the logs don't look so hot.

Do connections frequently keep dying as before?

> I ran another wireless-info (attached) and appended some of the
> syslog stuff to it.

Thanks, you identified a line of code and cause; a WARN_ON in
iwl_mvm_rx_tx_cmd_single;

		case TX_STATUS_FAIL_DEST_PS:
			/* In DQA, the FW should have stopped the queue and not
			 * return this status
			 */
			WARN_ON(iwl_mvm_is_dqa_supported(mvm));
			info->flags |= IEEE80211_TX_STAT_TX_FILTERED;
			break;

But it is only a warning.  If connections aren't dying, it may not be
important to you.

Please check you are using the most recent linux-firmware?

> >Several methods, though by far the most common seems to be personal
> >experience with offsets.
> >
> >When you don't have that personal experience, the methods are;
> >
> >1.  using GDB against the .o file,
> >
> >2.  using binutils objdump to disassemble .o file or vmlinuz,
> >
> >3.  using GCC to generate assembly listings,
> >
> >See https://wiki.ubuntu.com/Kernel/KernelDebuggingTricks right down
> >the end of page for the GDB method.
> 
> I have gotten around to that part, yet, as i was busy with the
> above, but it seems later versions have issues, too.

However, you're still testing old source code.

Several changes made since are worth testing, please either
cherry-pick the patches or test a 4.14 rc kernel, and without
involving dkms or virtualbox.

Or, if new firmware fixes the problem, go with that instead.

> -- 
> Mit freundlichen Grüßen/Best regards
> 
> Mario Theodoridis

> 
> ########## wireless info START ##########
> [...]

-- 
James Cameron
http://quozl.netrek.org/
