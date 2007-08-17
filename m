Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.sea5.speakeasy.net ([69.17.117.4]:37113 "EHLO
	mail2.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166AbXHQDHw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Aug 2007 23:07:52 -0400
Date: Thu, 16 Aug 2007 20:06:49 -0700
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] hostapd: remove vlan stuff
Message-ID: <20070817030649.GB1415@jm.kir.nu>
References: <1187131269.31200.3.camel@johannes.berg> <1187180689.3998.41.camel@johannes.berg> <20070816012239.GQ1415@jm.kir.nu> <1187270414.5141.42.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1187270414.5141.42.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 16, 2007 at 03:20:14PM +0200, Johannes Berg wrote:
> On Wed, 2007-08-15 at 18:22 -0700, Jouni Malinen wrote:
> 
> > This doesn't sound like a good idea. How would macvlan-based alternative
> > solve the problem of having different group keys for each VLAN?
> 
> Ah. I never considered that was even possible. Wouldn't it make more
> sense to allow binding group keys to STAs too, instead of making the
> only within the interface? That way you could possibly even get hw accel
> for those.

That would break the broadcast domain and if someone really want that,
they could create a VLAN per STA.. The purpose of using different group
keys per VLAN is to allow each VLAN to have a separate broadcast domain,
i.e., all broadcast packets to STAs bound to this VLAN are available to
all STAs in this VLAN (and only to them).

Since in 802.11 BSS networks, broadcast frames are only sent by the AP,
hw acceleration can be made to work fine with this kind of
configuration. As far as the clients are concerned, they don't even know
about the existance of different VLANs and group keys and as such, this
looks a standard AP to them. As far as the AP is concerned, it will need
to have support for using multiple keys with hwaccel and way of indexing
them with each transmitted frame. Taken into account how support for
hwaccel to unicast frames is implemented, this is quite a simple
extension to that.

-- 
Jouni Malinen                                            PGP id EFC895FA
