Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:33279 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754130AbYGGWAn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jul 2008 18:00:43 -0400
Subject: Re: [BUG] iwl4965: huge latency and errors when unblocking the
	hardware rfkill
From: Dan Williams <dcbw@redhat.com>
To: Andrew Lutomirski <andy@luto.us>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <cb0375e10807071301r678a2155m322f40635b19dc73@mail.gmail.com>
References: <cb0375e10807071156x26df8332j4b167e8cc9bb289@mail.gmail.com>
	 <1215459906.23993.2.camel@localhost.localdomain>
	 <cb0375e10807071301r678a2155m322f40635b19dc73@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 07 Jul 2008 17:59:10 -0400
Message-Id: <1215467950.2972.4.camel@localhost.localdomain> (sfid-20080708_000048_143661_EF6EA69D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-07-07 at 16:01 -0400, Andrew Lutomirski wrote:
> On Mon, Jul 7, 2008 at 3:45 PM, Dan Williams <dcbw@redhat.com> wrote:
> > On Mon, 2008-07-07 at 14:56 -0400, Andrew Lutomirski wrote:
> >> This is wireless-testing c80200cd38c265da90f0d9d031ace84aa56b0453, pulled today.
> >>
> >> I have a Lenovo X61s with a physical rfkill switch (the kind that
> >> slides between blocked and unblocked).
> >>
> >> If I turn off the hardware rfkill switch (set to block) while
> >> associated, I lose the connection (obviously).  If I turn it back on
> >> again (set to unblock), I get a lot of latency (my mouse stops moving
> >> for a second or two) and I sometimes get errors in the syslog like
> >> this:
> >>
> >> iwl4965: Error sending REPLY_CT_KILL_CONFIG_CMD: time out after 500ms.
> >>
> >> The card fails to associate afterwards.  If I tell network-manager to
> >> turn off wireless, then block rfkill, then wait a few seconds, then
> >> unblock it, then turn nm back on, everything works again.
> >>
> >> This seems like at least two different bugs:
> >>
> >>  - iwl4965 causes latency.  This latency issue has been reproducible
> >> every time for me on 2.6.24-ubuntu_something, 2.5.25, wireless-compat
> >> (recent), and current wireless-testing.
> >>  - iwl4965 doesn't work right after hard unblocking rfkill.
> >>
> >> I'm happy to do further troubleshooting and/or test patches.
> >
> > It depends on what HAL reports for the killswitch's status.  NM asks HAL
> > what the radio's rfkill state is every 6 seconds (since we can't get
> > event notifications when the state changes until 2.6.27).  If HAL
> > reports the radio is killed, NM won't touch the device.  It sounds like
> > something is trying to poke the device before it's ready, which may mean
> > that either NM isn't aware you have a killswitch, or HAL isn't correctly
> > talking to the iwlwifi killswitch bits (either old-style or new-style
> > with Henrique's patches).
> 
> OK.  But IMO iwl4965 should still avoid freaking out when this happens.
> 
> >
> > Can you post some logs from /var/log/daemon.log around when flipping the
> > killswitch to BLOCKED, waiting about 20 seconds, then flipping it back
> > to UNBLOCKED and waiting 10 seconds?  That will tell whether NM is
> > correctly talking to HAL or not.
> 
> Attached.  While the connection was failing to happen after
> re-enabling the radio, dmesg showed a lot of crap like:
> 
> [ 4514.797450] wlan0: authenticated
> [ 4514.797450] wlan0: associate with AP 00:11:88:06:72:98
> [ 4514.800735] wlan0: RX ReassocResp from 00:11:88:06:72:98
> (capab=0x401 status=0 aid=164)
> [ 4514.800743] wlan0: associated
> [ 4516.834866] wlan0: No ProbeResp from current AP 00:11:88:06:72:98 -
> assume out of range

This doesn't look like /var/log/daemon.log...

Dan

