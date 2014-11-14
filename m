Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:41035 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752609AbaKNHCf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Nov 2014 02:02:35 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 8.0 \(1990.1\))
Subject: Re: Can fb4e156886ce6e8309e912d8b370d192330d19d3 be reverted ?
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <1415933712.2629.12.camel@dcbw.local>
Date: Fri, 14 Nov 2014 16:02:33 +0900
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Stanislaw Gruszka <sgruszka@redhat.com>,
	linux-wireless@vger.kernel.org
Message-Id: <6E4E0F42-B794-4F90-8AE9-0C208E40F7CD@holtmann.org> (sfid-20141114_080238_687008_F17EE1F6)
References: <20141113123313.GA1926@redhat.com> <1415882683.2021.3.camel@sipsolutions.net> <A21755E2-3054-46B2-9BA6-07347FB91E1E@holtmann.org> <1415933712.2629.12.camel@dcbw.local>
To: Dan Williams <dcbw@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dan,

>>>> I've updated wireless code on RHEL and get complain that now
>>>> cfg80211 and rfkill modules are loaded on machines that do not have
>>>> wireless hardware. Modules are auto-loaded because NetworkManager send
>>>> nl80211 messages to check if there are wireless devices in the system.
>>>> 
>>>> Hence my question, can we revert commit fb4e156886ce
>>>> "nl80211: Add generic netlink module alias for cfg80211/nl80211" ?
>>> 
>>> Realistically, we can't revert it, but only remove the
>>> MODULE_ALIAS_GENL_FAMILY() line.
>>> 
>>>> Auto loading nl80211 does not seems to be necessary, if there are
>>>> wireless devices nl80211 will be loaded anyway.
>>> 
>>> Maybe other applications would like to see an empty list of devices? But
>>> OTOH, if they're robust at all, they have to cope with kernels not even
>>> compiled with nl80211, so I guess for me I don't really see a big
>>> difference in whether the module alias exists or not.
>> 
>> auto-loading cfg80211 module when userspace requests nl80211 netlink family is exactly the right thing to do. Systems compiled without nl80211 support and systems with no wireless device attached are two different things.
>> 
>> Someone can fix NetworkManager to not send nl80211 messages or just plain accept that cfg80211 will be loaded.
> 
> NM uses nl80211 initially to determine whether *any* ethernet-type
> interface (a) is actually WiFi, and (b) should be driven by nl80211 or
> WEXT.  Because of the variety of drivers (both in-kernel and
> out-of-kernel) and the variety of kernel versions (NM supports back to
> early 3.x series) we cannot rely on specific behavior.
> 
> So given an ethernet-type interface, how do we determine that it is
> wifi?
> 
> DEVTYPE=wlan - not always reliable due to driver and kernel versions

if anybody wants to write kernel patches, then making sure that all wireless drivers expose DEVTYPE=wlan is the way to go. If for some reason a driver does not do it, that is a bug.

> "phy80211" in sysfs: same reason; also doesn't capture WEXT or
> out-of-tree drivers
> 
> nl80211 calls: this is the only 100% reliable mechanism to detect
> whether an ethernet-type interface is actually WiFi and nl80211-capable.
> 
> And unfortunately calling nl80211 loads the module...

So be it then, the cfg80211 modules gets loaded. People have to live with that.

And just to be clear, this is not a kernel bug. Exposing the correct module alias for its netlink family is what the module should be doing.

Regards

Marcel

