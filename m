Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:60067 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755394Ab2EKTuF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 May 2012 15:50:05 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1SSvql-0004cW-9R
	for linux-wireless@vger.kernel.org; Fri, 11 May 2012 21:50:03 +0200
Received: from 152.178.50.1 ([152.178.50.1])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 11 May 2012 21:50:03 +0200
Received: from robert.bouterse by 152.178.50.1 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 11 May 2012 21:50:03 +0200
To: linux-wireless@vger.kernel.org
From: Robert Bouterse <robert.bouterse@dmh-global.com>
Subject: Re: =?utf-8?b?YXRoOWtfaHRj?= fails with 
Date: Fri, 11 May 2012 19:47:25 +0000 (UTC)
Message-ID: <loom.20120511T213645-406@post.gmane.org> (sfid-20120511_215011_726624_33ABE343)
References: <20120321175800.GA28516@aldebaran.gro-tsen.net> <CAJ-Vmom2fPUuuT8mUa2fWrbBQGuDtd7nh7Tkn3Sa2_TmhjtJaA@mail.gmail.com> <20120321220242.GA26363@aldebaran.gro-tsen.net> <20120322002955.GA9391@aldebaran.gro-tsen.net> <20331.61854.29639.644902@gargle.gargle.HOWL> <20120323174708.GA2797@aldebaran.gro-tsen.net> <20337.31328.528725.786517@gargle.gargle.HOWL>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sujith Manoharan <c_manoha@...> writes:

> 
> David Madore wrote:
> > In other words: loading the module seems to place the dongle in a bad
> > state that goes away after ifconfig up (but not by removing the
> > modules), and if a reboot happens while the dongle is in that bad
> > state, it will fail permanently.
> 
> Right, there's a difference here, a 'reboot' of the card is done only when
> if the interface is brought up. The device status from the USB subsystem
> is used to handle this - it works on x86.
> 
> On your platform, I think that a full reboot is required even when doing just
> a simple load/unload cycle. I'll come up with a patch to test this.
> 
> Thanks for the detailed log.
> 
> Sujith
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@...
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
Hi Sujith,
I seem to running into this same issue, mine is that the driver emits the
"Target unresponsive" error if the unit is powered-up with the TL-WN721N plugged
in already. I think my issue is that the USB subsytem event is not recieved by
the atk9k_htc driver, and therefore the hardware is not reset.

Has this ben fixed already? Can you give me the commit sha1 in wireless-testing?
I am using compat-wireless, so I am lagging master a bit.

If not, can you point me at where in the driver code the reset happens? Maybe I
can come up with a patch.


