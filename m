Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:36566 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752205AbYFLPDg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jun 2008 11:03:36 -0400
Subject: Re: [ipw3945-devel] [BUG] iwlwifi 3945 works only with
	disable_hw_scan=1
From: Dan Williams <dcbw@redhat.com>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Zhu Yi <yi.zhu@intel.com>, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net
In-Reply-To: <48511B1D.4010901@gmail.com>
References: <484FF375.8010002@gmail.com>
	 <1213237561.7814.688.camel@debian.sh.intel.com>
	 <48511B1D.4010901@gmail.com>
Content-Type: text/plain
Date: Thu, 12 Jun 2008 11:02:50 -0400
Message-Id: <1213282970.6589.9.camel@localhost.localdomain> (sfid-20080612_170339_313095_7C100090)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2008-06-12 at 15:48 +0300, Maxim Levitsky wrote:
> Zhu Yi wrote:
> > On Wed, 2008-06-11 at 18:47 +0300, Maxim Levitsky wrote:
> >> I found why I can't reenable wireless with wireless button.
> >>
> >> It turns out that iwlwifi doesn't enable the wireless function after a
> >> R/F kill switch was enabled ether by the button or explicitly.
> >>
> >> I bisected this to commit 5a66926aa9230810704fd5a127966215fd58881e
> >> in linus tree.
> > 
> > The card will receive an interrupt when you disable the rf kill switch
> > anyway whatever the wireless function is enabled or not. So the driver
> > will enable the wireless function again. Please check if the interface
> > (wlan0) is up when you disable the rf kill switch later. If it is not,
> > you have to bring it up manually (i.e. ifconfig wlan0 up) to enable the
> > wireless function. Otherwise please provide the dmesg with
> > debug=0x20000.
> > 
> > Thanks,
> > -yi
> > 
> 
> Why didn't I thought about this before...
> This is exactly what happens, so this isn't a bug.
> 
> What happens is the Network manager brings wlan0 down is it detects that
> there is no link, but this now removes the firmware.
> 
> I guess that the right solution is to listen to the wireless button (via 
> input layer), and turn card on manually.
> 
> If I remember correctly there is something like that in kernel, I try to 
> enable this.
> 
> Otherwise this can be implemented in userspace.

The right solution is for NM to not take the device down (essentially
doing SIOCSIFFLAGS with !IFF_UP), but to set the TX power off.  However,
that's not possible right now, because HAL doesn't provide enough
information about the killswitches to distinguish between a software
rfkill (which means we can turn the power back on) and a hardware rfkill
(which means the user has to flip something).  On ipw2100, 2200, and
2915, setting the TX power off looks exactly like a hardware kill to
HAL, so if you chose unchecked "Enable Wireless" in the nm applet, you'd
never be able to turn wireless back on, because HAL and NM think there's
a hardware kill active.

The kernel rfkill layer needs to be supported in all drivers, and second
we need to figure out the HW vs. SW kill thing whether that happens in
rfkill or not.

Dan

