Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-dm3nam03on0071.outbound.protection.outlook.com ([104.47.41.71]:36026
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754774AbdIFQXH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 6 Sep 2017 12:23:07 -0400
Date: Wed, 6 Sep 2017 19:22:53 +0300
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>
Subject: Re: [PATCH 3/8] qtnfmac: implement AP_VLAN iftype support
Message-ID: <20170906162252.vn6iogwjpz7j6zoq@bars> (sfid-20170906_182325_058308_89C7F5F6)
References: <20170620195517.18373-1-sergey.matyukevich.os@quantenna.com>
 <20170620195517.18373-4-sergey.matyukevich.os@quantenna.com>
 <1504619151.12380.16.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1504619151.12380.16.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes and all,

> > 1. Passing dynamic VLAN tag to firmware
> 
> There's no such thing as a "VLAN tag" with AP_VLAN interfaces. You want
> 802.1Q, which can be done on top of them if needed, but it's an
> unrelated concept.
> 
> > Currently there is no established way to pass VLAN tag assigned to
> > STA by Radius server to wireless driver. It is assumed that hostapd
> > is able to setup all the bridging and tagging on its own.
> 
> I don't even know if this is true? Does hostapd in fact set up 802.1Q
> tagging in any way? Can you say how to configure this?

Yes, hostapd supports this feature when it is built with option
CONFIG_FULL_DYNAMIC_VLAN enabled. There is a set of hostapd configuration
options and additional files that make it possible to specify 'WAN'
interface, naming conventions for those dynamic bridges, and more.

However I agree that using 802.1Q is only one of possible ways to isolate
stations attached to different AP_VLAN intefaces.

> > 2. Packet routing to/from AP/VLAN interfaces
> > Firmware operates with tagged packets after dynamic VLAN mode is
> > configured. In particular, packets destined to STAs should be
> > properly tagged before they can be passed to firmware. Packets
> > received from STAs are properly tagged by firmware and then
> > passed to wireless driver. As a result, packet routing to AP/VLAN
> > interfaces is straightforward: it is enough to check VLAN tags.
> 
> Ok, so here the whole tagging comes - a bit - into play. Technically
> you could, however, do the following:
> 
>  * assign "fake" tags as I suggested above
>  * pack/unpack the 802.1Q header from the firmware (or put it into
>    metadata) in the driver and just tx/rx untagged packets into the
>    right interface
>  * if the AP_VLAN has a real 802.1Q on top, then it's re-packed again
>    by the ethernet driver when the data goes out

Yes, this is approach with 'fake' tags is how it can be done provided
we do not want to use any hacks with naming conventions for AP_VLAN
interfaces enforced by hostapd.

In fact, the 802.1Q approach has been chosen since in our case it is
possible to make use of 802.1Q acceleration in firmware. So we could
save some cycles on host CPU, tagging/untagging packets on the card.
But again, I agree that using 802.1Q is only one of the possible ways
to isolate stations attached to different AP_VLAN. Thus there is no
point to complicate/drop other usecases only because we are able
to support 802.1Q case better due to acceleration in firmware.

> > Normally hostapd expects untagged packets from AP/VLAN interfaces.
> 
> hostapd doesn't really expect anything there, does it?

In fact, hostapd does not expect 802.1Q tagged packets. IIRC when
CONFIG_FULL_DYNAMIC_VLAN enabled, then hostapd creates bridges
and VLAN interfaces dynamically, connecting them to 'WAN' network
interface specified by vlan_tagged_interface configuration option.

> > Meanwhile firmware performs tagging using h/w acceleration. That
> > is why it makes sense to avoid untagging packets in driver if
> > they are supposed to by tagged again on host. To enable this
> > behavior a new module parameter 'dyn_vlan_tagged' has been
> > introduced:
> >
> > - dyn_vlan_tagged = 0 (default)
> > In this case untagged packets are sent to and expected from AP/VLAN
> > interfaces.
> > Driver tags/untags packets going to/from firmware. This behaviour is
> > expected
> > by hostapd which is able to create bridges and VLAN interfaces
> > automatically
> > when hostapd is built with CONFIG_FULL_DYNAMIC_VLAN option enabled.
> >
> > - dyn_vlan_tagged = 1
> > In this case tagged packets are sent to and expected from AP/VLAN
> > interfaces.
> > Hostapd build option CONFIG_FULL_DYNAMIC_VLAN should be disabled.
> > Setup of
> > networking topology on host is left up to the implementers.
> 
> This is all very hacky, I really don't think we can accept that.

Fair enough. I didn't like it that much anyway :) I will rework the whole
patch using opaque tags for 802.1Q headers from the firmware, leaving AP_VLAN
interface management to hostapd or any other userspace tool.

Regards,
Sergey
