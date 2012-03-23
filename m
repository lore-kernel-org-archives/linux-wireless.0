Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:39109 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752327Ab2CWDpN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Mar 2012 23:45:13 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20331.61854.29639.644902@gargle.gargle.HOWL> (sfid-20120323_044519_200077_63D4463F)
Date: Fri, 23 Mar 2012 09:14:30 +0530
To: David Madore <david+ml@madore.org>
CC: Adrian Chadd <adrian@freebsd.org>, <linux-wireless@vger.kernel.org>
Subject: Re: ath9k_htc fails with "Target is unresponsive"
In-Reply-To: <20120322002955.GA9391@aldebaran.gro-tsen.net>
References: <20120321175800.GA28516@aldebaran.gro-tsen.net>
	<CAJ-Vmom2fPUuuT8mUa2fWrbBQGuDtd7nh7Tkn3Sa2_TmhjtJaA@mail.gmail.com>
	<20120321220242.GA26363@aldebaran.gro-tsen.net>
	<20120322002955.GA9391@aldebaran.gro-tsen.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

David Madore wrote:
> On Wed, Mar 21, 2012 at 11:02:42PM +0100, David Madore wrote:
> > Or, to summarize all of this: the dongle works if and only if
> > ath9k_htc is initializing it for the very first time since it was
> > physically plugged in or powered on.  No reset, USB reset or software
> > reset of any kind seems to help.
> 
> More accurately: the dongle fails to work if and only if, since it was
> last plugged in, there has been a reboot (=anything short of a full
> power cycle) after it has been initialized by ath9k_htc.
> 
> Unloading and reloading the kernel modules does not cause a failure
> (but neither does it solve the problem).  Rebooting[#] the machine
> causes the problem if and only if ath9k_htc has been loaded prior to
> reboot (even if there have been other intermediate reboots).  Powering
> the machine down, or unplugging the dongle, are the only way I've
> found of restoring a sane state: no lesser kind of USB reset has
> worked.
> 
> [#] I should try kexec, but I haven't been able to get it to work.
> 
> I'm willing to run any other experience which might elucidate things,
> of course.

Can you compile the driver/kernel with debugging enabled [1] ?
Then, load the driver with the module parameter 'debug=0x8701' and post the
kernel log here (a full run - load, use, reboot, load). Thanks.

[1] http://linuxwireless.org/en/users/Drivers/ath9k/debug

Sujith
