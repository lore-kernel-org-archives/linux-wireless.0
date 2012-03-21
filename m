Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aldebaran.gro-tsen.net ([88.191.60.176]:35704 "EHLO
	aldebaran.gro-tsen.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754164Ab2CUWCo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Mar 2012 18:02:44 -0400
Date: Wed, 21 Mar 2012 23:02:42 +0100
From: David Madore <david+ml@madore.org>
To: Adrian Chadd <adrian@freebsd.org>
Cc: linux-wireless@vger.kernel.org
Subject: Re: ath9k_htc fails with "Target is unresponsive"
Message-ID: <20120321220242.GA26363@aldebaran.gro-tsen.net> (sfid-20120321_230314_873940_14D213DE)
References: <20120321175800.GA28516@aldebaran.gro-tsen.net>
 <CAJ-Vmom2fPUuuT8mUa2fWrbBQGuDtd7nh7Tkn3Sa2_TmhjtJaA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAJ-Vmom2fPUuuT8mUa2fWrbBQGuDtd7nh7Tkn3Sa2_TmhjtJaA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 21, 2012 at 01:16:44PM -0700, Adrian Chadd wrote:
> Are you sure this isn't partially a USB controller/initialisation problem?

Could be.  I wish I knew how to be sure.  If it helps, I tried putting
the dongle behind a USB switch, which made no difference whatsoever.

> What's the exact combination that works/fails?
> 
> * power on boot with the dongle plugged in;

Works.

> * reset pins shorted with the dongle plugged in;

The reset button on the box doesn't work.  If I reset through the JTAG
interface, the Wifi dongle fails to work.

> * "reboot" from a running system with the dongle plugged in;

Fails.

> .. then repeat the above with the dongle unplugged during system
> POST/boot, then plug it in once everything has initialised to
> multi-user mode?

Plugging the dongle always makes it work, no matter how the system was
initialized.

Or, to summarize all of this: the dongle works if and only if
ath9k_htc is initializing it for the very first time since it was
physically plugged in or powered on.  No reset, USB reset or software
reset of any kind seems to help.

-- 
     David A. Madore
   ( http://www.madore.org/~david/ )
