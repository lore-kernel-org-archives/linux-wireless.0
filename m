Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail4.sea5.speakeasy.net ([69.17.117.6]:52988 "EHLO
	mail4.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311AbXIECij (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Sep 2007 22:38:39 -0400
Date: Tue, 4 Sep 2007 19:38:24 -0700
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Michael Wu <flamingice@sourmilk.net>
Subject: Re: bridge packets option
Message-ID: <20070905023824.GE5273@jm.kir.nu>
References: <1188405071.1757.5.camel@johannes.berg> <20070903235714.GT1835@jm.kir.nu> <1188915742.9942.33.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1188915742.9942.33.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 04, 2007 at 04:22:22PM +0200, Johannes Berg wrote:
> On Mon, 2007-09-03 at 16:57 -0700, Jouni Malinen wrote:

> > Kernel
> > bridging code does not (or at least did not the last time I looked)
> > allow packets to be bridged back to the same interface which would be
> > needed for the case of two wireless stations which are associated to the
> > same AP sending packets to each other.
> 
> I was thinking more of routing in the unicast case, if a packet comes in
> you'd have to route it back to wireless if the destination is there.
> Isn't that possible?

Well, it may be possible, but that would not be the way IEEE 802.11
access points normally work. AP is a layer 2 bridge and it should bridge
the packets regardless of what ethertype is used. There is no need for
it to keep up ARP tables for the associated stations to figure out where
to route packets. Furthermore, I would rather not see ICMP redirects
showing up on the wireless interface because IP routing needed to send
the packet back to the same interface. I would assume that this can be
disabled, but anyway, layer 2 bridge is the location that would be much
close to what AP does between two associated wireless stations.

-- 
Jouni Malinen                                            PGP id EFC895FA
