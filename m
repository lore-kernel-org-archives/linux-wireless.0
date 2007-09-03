Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail5.sea5.speakeasy.net ([69.17.117.7]:37391 "EHLO
	mail5.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008AbXICX65 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Sep 2007 19:58:57 -0400
Date: Mon, 3 Sep 2007 16:57:14 -0700
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Michael Wu <flamingice@sourmilk.net>
Subject: Re: bridge packets option
Message-ID: <20070903235714.GT1835@jm.kir.nu>
References: <1188405071.1757.5.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1188405071.1757.5.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 29, 2007 at 06:31:11PM +0200, Johannes Berg wrote:

> Looking through the receive code, the bridge_packets config option has
> the effect of copying multicast traffic to the air right away and
> passing frames to a station without having them go all the way through
> the network stack.

Yes or to be more exact, this is always enabled by default, so the
effect of disabling this would be to stop copying received frames back
to wireless interface immediately.

> I think there's a flaw with this: when you turn it off, nothing will
> copy multicast frames to the network as expected by an AP, as far as I
> can tell. Hence, I think that the bridge_packets must not be honoured
> for multicast packets.

This is by design and in most cases you would not disable
bridge_packets. This option is to allow the AP to be configured in a
mode where wireless stations are more isolated from each other, i.e., if
the multicast source were indeed the wireless client associated to the
AP, other associated clients would not see these frames (unless
something else in the network stack were configured to push them back to
the same interface which is less likely to happen). Multicast packets
from other interfaces (e.g., wired Ethernet) would go through to the
wireless clients regardless of the bridge_packets option.

> OTOH, for multicast, is it actually correct? Doesn't the AP need to
> rewrite some fields?

Yes, the 802.11 header changes, but this is taken care of by "bridging"
the frame after the header conversion to 802.3. When the frame is going
back up through the master interface, it will be converted to 802.11
header with the correct header fields.

> As for unicast packets, what is the gain? There's obviously the loss
> that netfilter won't see the packet which is generally very much frowned
> upon. Is the performance benefit really that high?

The gain of what? Enabling bridge_packets? Disabling bridge_packets? The
benefit of enabling it is to make things actually work ;-). Kernel
bridging code does not (or at least did not the last time I looked)
allow packets to be bridged back to the same interface which would be
needed for the case of two wireless stations which are associated to the
same AP sending packets to each other.

If the bridging code were to be changed to be more aware of 802.11
interface, I would be happy to get rid of the bridge_packet=1 code in
mac80211. If I remember correctly, a patch for doing this was submitted
long time ago and there has been some discussions on this topic, but not
much progress on this area has happened. Consequently, all 802.11 AP
implementations will need to continue doing this in the 802.11 code (or
by using a patched bridge code or custom module for doing this somewhere
else).

Disabling bridge_packets would be the option that some networks (e.g.,
public hotspots) might prefer to isolate the clients from other
associated clients. Not that this is secure in an unencrypted network,
but anyway, public hotspot would be the most likely user of
bridge_packets=0.

-- 
Jouni Malinen                                            PGP id EFC895FA
