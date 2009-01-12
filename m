Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:56274 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754990AbZALTgA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Jan 2009 14:36:00 -0500
Subject: Re: rfkill: how murderous can it be ?
From: Dan Williams <dcbw@redhat.com>
To: Werner Almesberger <werner@openmoko.org>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20090112191514.GA22112@almesberger.net>
References: <20090112191514.GA22112@almesberger.net>
Content-Type: text/plain
Date: Mon, 12 Jan 2009 14:34:44 -0500
Message-Id: <1231788884.28887.4.camel@localhost.localdomain> (sfid-20090112_203618_746676_F02EA570)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2009-01-12 at 17:15 -0200, Werner Almesberger wrote:
> I'd like to restart a discussion from last year, namely how aggressive
> an rfkill implementation is allowed to be when it comes to destroying
> MAC state.
> 
> The design suggested in rfkill.txt and also implemented in the existing
> drivers basically assumes a simple on/off switch that cuts power to the
> transmitter but doesn't change anything else. The question is if this 
> is already the full extent to which rfkill is allowed to affect MAC
> state or if it could go further.
> 
> In the AR6k, we don't have such a simple switch for the transmitter. We
> can control what the transmitter does very indirectly by temporarily
> reconfiguring the MAC, but this creates a fair amount of complexity,
> which also seems to be at odds with the design of rfkill.
> 
> Alternatively, we could just power down the whole WLAN module. That is
> easily done and very reliable. However, MAC state (ESSID, keys, and a
> host of other settings) is obliterated if we do this. A watchful user 
> space (e.g., wpa_supplicant) could then restore the status quo ante.
> 
> Now the question is whether this is still in the spirit of the design 
> of rfkill of if it would take things too far.
> 
> It seems that there is no consensus on this issue yet. I started the 
> implementation with the assumption that rfkill should always behave as 
> if it only cut transmitter power, so no other state of the MAC is
> allowed to be lost. This is also what Henrique suggested I should do.
> 
> However, Andy and recently Michael suggested that, given that an
> interface that has no connectivity for an extended period of time is
> likely to get reconfigured anyway, it may be sufficient if rfkill 
> leaves things in a state that allows user space to restore 
> connectivity, without having to worry about details beyond that.

Yes.  You have no guarantees about how long the RF is down when the
switch is flipped or the checkbox ticked.  Instead of putting a bunch of
complexity in the kernel and drivers that *already* has to be in
userspace, just punt it out to userspace where it's already done and
works well.

If there are any latency issues with this, then we need to fix those
latency issues in wpa_supplicant, not put complex state handling into
the stack drivers for this.  Treat rfkill the same as suspend/resume
from a state perspective, because they really have the same
consequences: you have no idea where you are when you wake up, what has
happened since RF was turned off, and whether your AP is still around.
Better to make scanning and associate fast and foolproof, which has to
happen in userspace anyway.

Dan


