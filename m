Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail6.sea5.speakeasy.net ([69.17.117.8]:56569 "EHLO
	mail6.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748AbXIDBSb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Sep 2007 21:18:31 -0400
Date: Mon, 3 Sep 2007 18:16:48 -0700
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] hostapd: use nl80211 instead of prism ioctls to create  interfaces
Message-ID: <20070904011648.GX1835@jm.kir.nu>
References: <1187987850.24933.29.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1187987850.24933.29.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 24, 2007 at 10:37:30PM +0200, Johannes Berg wrote:
> This makes hostapd use nl80211 (via libnl) to create/remove interfaces.
> Also lays the foundation for using nl80211 in hostapd.

Where are things like NL80211_ATTR_IFNAME and
NL80211_CMD_ADD_VIRTUAL_INTERFACE defined? I would assume these are from
linux/nl80211.h, but where should I get the version that includes these?
This is making it a bit difficult to build driver_devicescape.c and same
goes for the requirement for svn trunk version of libnl.. Any idea how
much code from libnl is needed here? Would it be major effort to do the
needed calls without having to rely on libnl at or (or at least not on
an unreleased svn trunk version)?

> -#ifdef USE_KERNEL_HEADERS
> -#include <asm/types.h>
> +#include <netlink/genl/genl.h>
> +#include <netlink/genl/family.h>
> +#include <netlink/genl/ctrl.h>
> +#include <netlink/msg.h>
> +#include <netlink/attr.h>
> +#include <linux/nl80211.h>
> +#include <net/if.h>
>  #include <linux/if_packet.h>
>  #include <linux/if_ether.h>   /* The L2 protocols */
> -#include <linux/if_arp.h>
>  #include <linux/wireless.h>
> -#else /* USE_KERNEL_HEADERS */

This is not good direction to go to.. I would really not like to include
linux/*.h unless absolutely needed since these header files have been
very likely to conflict with glibc ones and there is not really that
much guarantees in people wanting to keep kernel header files suitable
for inclusion into user space programs.

>  #include <net/if_arp.h>
> -#include <netpacket/packet.h>
> -#include "wireless_copy.h"
> -#include "priv_netlink.h"

I would much rather use these for now and should the /usr/include/linux
directory in most distributions some day have all the needed stuff, then
we could move towards using those.

-- 
Jouni Malinen                                            PGP id EFC895FA
