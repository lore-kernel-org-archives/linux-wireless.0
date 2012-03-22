Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aldebaran.gro-tsen.net ([88.191.60.176]:35929 "EHLO
	aldebaran.gro-tsen.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754036Ab2CVA35 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Mar 2012 20:29:57 -0400
Date: Thu, 22 Mar 2012 01:29:55 +0100
From: David Madore <david+ml@madore.org>
To: Adrian Chadd <adrian@freebsd.org>
Cc: linux-wireless@vger.kernel.org
Subject: Re: ath9k_htc fails with "Target is unresponsive"
Message-ID: <20120322002955.GA9391@aldebaran.gro-tsen.net> (sfid-20120322_013000_710846_94174858)
References: <20120321175800.GA28516@aldebaran.gro-tsen.net>
 <CAJ-Vmom2fPUuuT8mUa2fWrbBQGuDtd7nh7Tkn3Sa2_TmhjtJaA@mail.gmail.com>
 <20120321220242.GA26363@aldebaran.gro-tsen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20120321220242.GA26363@aldebaran.gro-tsen.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 21, 2012 at 11:02:42PM +0100, David Madore wrote:
> Or, to summarize all of this: the dongle works if and only if
> ath9k_htc is initializing it for the very first time since it was
> physically plugged in or powered on.  No reset, USB reset or software
> reset of any kind seems to help.

More accurately: the dongle fails to work if and only if, since it was
last plugged in, there has been a reboot (=anything short of a full
power cycle) after it has been initialized by ath9k_htc.

Unloading and reloading the kernel modules does not cause a failure
(but neither does it solve the problem).  Rebooting[#] the machine
causes the problem if and only if ath9k_htc has been loaded prior to
reboot (even if there have been other intermediate reboots).  Powering
the machine down, or unplugging the dongle, are the only way I've
found of restoring a sane state: no lesser kind of USB reset has
worked.

[#] I should try kexec, but I haven't been able to get it to work.

I'm willing to run any other experience which might elucidate things,
of course.

-- 
     David A. Madore
   ( http://www.madore.org/~david/ )
