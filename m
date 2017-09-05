Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:35682 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751002AbdIENpx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 5 Sep 2017 09:45:53 -0400
Message-ID: <1504619151.12380.16.camel@sipsolutions.net> (sfid-20170905_154707_931614_625FC941)
Subject: Re: [PATCH 3/8] qtnfmac: implement AP_VLAN iftype support
From: Johannes Berg <johannes@sipsolutions.net>
To: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>,
        linux-wireless@vger.kernel.org
Cc: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>
Date: Tue, 05 Sep 2017 15:45:51 +0200
In-Reply-To: <20170620195517.18373-4-sergey.matyukevich.os@quantenna.com> (sfid-20170620_215603_912928_26F5E0B9)
References: <20170620195517.18373-1-sergey.matyukevich.os@quantenna.com>
         <20170620195517.18373-4-sergey.matyukevich.os@quantenna.com>
         (sfid-20170620_215603_912928_26F5E0B9)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Sergey, all,

On Tue, 2017-06-20 at 22:55 +0300, Sergey Matyukevich wrote:
> This patch implements AP_VLAN interface type support enabling
> the use of dynamic VLAN mode in hostapd.

My first thought here is that this is completely wrong.

AP_VLAN interfaces have no relation to 802.1Q, but it seems that you're
trying to use them as such.

I'll comment a bit below, but I'd like to ask you to actually explain
what you're trying to achieve, because then I think I can comment
better on what you need to be doing.

> Implementation notes.
> 
> 1. Passing dynamic VLAN tag to firmware

There's no such thing as a "VLAN tag" with AP_VLAN interfaces. You want
802.1Q, which can be done on top of them if needed, but it's an
unrelated concept.

> Currently there is no established way to pass VLAN tag assigned to
> STA by Radius server to wireless driver. It is assumed that hostapd
> is able to setup all the bridging and tagging on its own. 

I don't even know if this is true? Does hostapd in fact set up 802.1Q
tagging in any way? Can you say how to configure this?

This might actually be your problem - what you *want* is doing 802.1Q
tagging which hostapd doesn't support, and so you're actually doing
client isolation which hostapd *does* support, instead?

As far as I can tell hostapd only has the ability to put different
types of clients into different AP_VLANs to achieve *over the air*
isolation. It has no isolation over the backend (yet) - that's
typically set up by putting the AP_VLAN interfaces into different
bridges or whatever.


> However qtnf firmware needs to know the assigned dynamic VLAN tags in
> order to perform various internal tasks including group key
> management, filtering, acceleration, and more.

This doesn't make any sense - what does it need the *tag* for? I can
understand it needing *a* tag, but not *the* tag that the RADIUS server
gave it?

IOW - I can understand it needing an identifier of the VLAN or
something like that, but then why can't you just number the AP_VLAN
interfaces 1,2,3,4,...?

> Current implementation makes use of the following workaround.
[snip]

This really shouldn't be done.

> 2. Packet routing to/from AP/VLAN interfaces
> Firmware operates with tagged packets after dynamic VLAN mode is
> configured. In particular, packets destined to STAs should be
> properly tagged before they can be passed to firmware. Packets
> received from STAs are properly tagged by firmware and then
> passed to wireless driver. As a result, packet routing to AP/VLAN
> interfaces is straightforward: it is enough to check VLAN tags.

Ok, so here the whole tagging comes - a bit - into play. Technically
you could, however, do the following:

 * assign "fake" tags as I suggested above
 * pack/unpack the 802.1Q header from the firmware (or put it into
   metadata) in the driver and just tx/rx untagged packets into the
   right interface
 * if the AP_VLAN has a real 802.1Q on top, then it's re-packed again
   by the ethernet driver when the data goes out

> Normally hostapd expects untagged packets from AP/VLAN interfaces.

hostapd doesn't really expect anything there, does it?

> Meanwhile firmware performs tagging using h/w acceleration. That
> is why it makes sense to avoid untagging packets in driver if
> they are supposed to by tagged again on host. To enable this
> behavior a new module parameter 'dyn_vlan_tagged' has been
> introduced:
> 
> - dyn_vlan_tagged = 0 (default)
> In this case untagged packets are sent to and expected from AP/VLAN
> interfaces.
> Driver tags/untags packets going to/from firmware. This behaviour is
> expected
> by hostapd which is able to create bridges and VLAN interfaces
> automatically
> when hostapd is built with CONFIG_FULL_DYNAMIC_VLAN option enabled.
> 
> - dyn_vlan_tagged = 1
> In this case tagged packets are sent to and expected from AP/VLAN
> interfaces.
> Hostapd build option CONFIG_FULL_DYNAMIC_VLAN should be disabled.
> Setup of
> networking topology on host is left up to the implementers.

This is all very hacky, I really don't think we can accept that.

Firewalling and similar things will likely not work correctly if
there's an 802.1Q packet coming in that they don't expect, for example.
We don't want to go around all the Linux infrastructure for something
like this.

In a way this feature seems mis-designed - you never have 802.1Q tags
over the air, but you're inserting them on RX and stripping them on TX,
probably in order to make bridging to ethernet easier and not have to
have 802.1Q acceleration on the ethernet port, or - well - in order to
have an ability to do this with an ethernet card that only has a single
CPU port.


In a way this is more like a switch or bridge feature, but I don't
think we have any abstraction for this in Linux. I think this is
something we should discuss over on netdev and perhaps in person at the
wireless workshop/netdev conference?

johannes
