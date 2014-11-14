Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33638 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754505AbaKNIpu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Nov 2014 03:45:50 -0500
Date: Fri, 14 Nov 2014 09:42:55 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Dan Williams <dcbw@redhat.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: Can fb4e156886ce6e8309e912d8b370d192330d19d3 be reverted ?
Message-ID: <20141114084254.GC1949@redhat.com> (sfid-20141114_094552_916536_F8E2A8A0)
References: <20141113123313.GA1926@redhat.com>
 <1415882683.2021.3.camel@sipsolutions.net>
 <A21755E2-3054-46B2-9BA6-07347FB91E1E@holtmann.org>
 <1415933712.2629.12.camel@dcbw.local>
 <6E4E0F42-B794-4F90-8AE9-0C208E40F7CD@holtmann.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <6E4E0F42-B794-4F90-8AE9-0C208E40F7CD@holtmann.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 14, 2014 at 04:02:33PM +0900, Marcel Holtmann wrote:
> Hi Dan,
> 
> >>>> I've updated wireless code on RHEL and get complain that now
> >>>> cfg80211 and rfkill modules are loaded on machines that do not have
> >>>> wireless hardware. Modules are auto-loaded because NetworkManager send
> >>>> nl80211 messages to check if there are wireless devices in the system.
> >>>> 
> >>>> Hence my question, can we revert commit fb4e156886ce
> >>>> "nl80211: Add generic netlink module alias for cfg80211/nl80211" ?
> >>> 
> >>> Realistically, we can't revert it, but only remove the
> >>> MODULE_ALIAS_GENL_FAMILY() line.
> >>> 
> >>>> Auto loading nl80211 does not seems to be necessary, if there are
> >>>> wireless devices nl80211 will be loaded anyway.
> >>> 
> >>> Maybe other applications would like to see an empty list of devices? But
> >>> OTOH, if they're robust at all, they have to cope with kernels not even
> >>> compiled with nl80211, so I guess for me I don't really see a big
> >>> difference in whether the module alias exists or not.
> >> 
> >> auto-loading cfg80211 module when userspace requests nl80211 netlink family is exactly the right thing to do. Systems compiled without nl80211 support and systems with no wireless device attached are two different things.
> >> 
> >> Someone can fix NetworkManager to not send nl80211 messages or just plain accept that cfg80211 will be loaded.
> > 
> > NM uses nl80211 initially to determine whether *any* ethernet-type
> > interface (a) is actually WiFi, and (b) should be driven by nl80211 or
> > WEXT.  Because of the variety of drivers (both in-kernel and
> > out-of-kernel) and the variety of kernel versions (NM supports back to
> > early 3.x series) we cannot rely on specific behavior.
> > 
> > So given an ethernet-type interface, how do we determine that it is
> > wifi?
> > 
> > DEVTYPE=wlan - not always reliable due to driver and kernel versions
> 
> if anybody wants to write kernel patches, then making sure that all wireless drivers expose DEVTYPE=wlan is the way to go. If for some reason a driver does not do it, that is a bug.

NM can be run with older kernel versions, which does not have DEVTYPE=wlan.
I guess NM could check the kernel version and don't use nl80211 if
kernel is sufficiency modern.

> > "phy80211" in sysfs: same reason; also doesn't capture WEXT or
> > out-of-tree drivers
> > 
> > nl80211 calls: this is the only 100% reliable mechanism to detect
> > whether an ethernet-type interface is actually WiFi and nl80211-capable.
> > 
> > And unfortunately calling nl80211 loads the module...
> 
> So be it then, the cfg80211 modules gets loaded. People have to live with that.

It's 700k of kernel memory. People running many instances of guest OS
with this module loaded are quite unhappy.

> And just to be clear, this is not a kernel bug. Exposing the correct module alias for its netlink family is what the module should be doing.

This is not a kernel bug, but not having the alias is also not
a kernel bug :-)

Stanislaw
