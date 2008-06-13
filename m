Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:1666 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754533AbYFMCBE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jun 2008 22:01:04 -0400
Subject: Re: [ipw3945-devel] [BUG] iwlwifi 3945 works only with
	disable_hw_scan=1
From: Zhu Yi <yi.zhu@intel.com>
To: Dan Williams <dcbw@redhat.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>,
	linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
In-Reply-To: <1213282970.6589.9.camel@localhost.localdomain>
References: <484FF375.8010002@gmail.com>
	 <1213237561.7814.688.camel@debian.sh.intel.com>
	 <48511B1D.4010901@gmail.com>
	 <1213282970.6589.9.camel@localhost.localdomain>
Content-Type: text/plain
Date: Fri, 13 Jun 2008 10:00:39 +0800
Message-Id: <1213322439.7814.770.camel@debian.sh.intel.com> (sfid-20080613_040130_398814_CBFF50C7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2008-06-12 at 11:02 -0400, Dan Williams wrote:
> > I guess that the right solution is to listen to the wireless button
> (via 
> > input layer), and turn card on manually.
> > 
> > If I remember correctly there is something like that in kernel, I
> try to 
> > enable this.
> > 
> > Otherwise this can be implemented in userspace.
> 
> The right solution is for NM to not take the device down (essentially
> doing SIOCSIFFLAGS with !IFF_UP), but to set the TX power off.
> However,
> that's not possible right now, because HAL doesn't provide enough
> information about the killswitches to distinguish between a software
> rfkill (which means we can turn the power back on) and a hardware
> rfkill
> (which means the user has to flip something).  On ipw2100, 2200, and
> 2915, setting the TX power off looks exactly like a hardware kill to
> HAL, so if you chose unchecked "Enable Wireless" in the nm applet,
> you'd never be able to turn wireless back on, because HAL and NM think
> there's a hardware kill active.

I think who takes the interface down is responsible to bring it up. Even
if the driver receives a rf_kill switch disabled interrupt, it should
keep the current IFF_UP status. It should never bring it up or down
itself. (Think about the carrier on/off in ethernet).

I wonder why NM need to ifdown or "txpower off" when rf_kill switch
(both for SW and HW) is enabled. The driver already handles it. Could it
save more power?

Thanks,
-yi

