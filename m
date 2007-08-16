Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail7.sea5.speakeasy.net ([69.17.117.9]:54955 "EHLO
	mail7.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758529AbXHPBXn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Aug 2007 21:23:43 -0400
Date: Wed, 15 Aug 2007 18:22:39 -0700
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] hostapd: remove vlan stuff
Message-ID: <20070816012239.GQ1415@jm.kir.nu>
References: <1187131269.31200.3.camel@johannes.berg> <1187180689.3998.41.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1187180689.3998.41.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 15, 2007 at 02:24:49PM +0200, Johannes Berg wrote:

> This removes the VLAN stuff from hostapd.
> 
> The VLAN stuff in mac80211 cannot possibly work, it doesn't actually do
> anything with those VLAN type interfaces. Also, when I added the VLAN
> type to cfg80211 I must have been rather convinced of the idea; I no
> longer am in favour of doing it in the wireless stack. The recently
> added "macvlan" "driver" shows how you can do VLANs based on destination
> address, what we will need is something like "smacvlan" that does VLANs
> based on source address.

This doesn't sound like a good idea. How would macvlan-based alternative
solve the problem of having different group keys for each VLAN?

-- 
Jouni Malinen                                            PGP id EFC895FA
