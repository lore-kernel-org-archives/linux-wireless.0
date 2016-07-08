Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:54369 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754134AbcGHKdV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jul 2016 06:33:21 -0400
Message-ID: <1467973953.4837.3.camel@sipsolutions.net> (sfid-20160708_123325_459115_126EA0D1)
Subject: Re: [PATCH 0/5] Improve wireless netdev detection
From: Johannes Berg <johannes@sipsolutions.net>
To: Denis Kenzior <denkenz@gmail.com>, linux-wireless@vger.kernel.org
Date: Fri, 08 Jul 2016 12:32:33 +0200
In-Reply-To: <1467875330-7835-1-git-send-email-denkenz@gmail.com> (sfid-20160707_010855_453684_CF867D15)
References: <1467875330-7835-1-git-send-email-denkenz@gmail.com>
	 (sfid-20160707_010855_453684_CF867D15)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2016-07-07 at 02:08 -0500, Denis Kenzior wrote:
> The current mechanism to detect hot-plug / unplug of wireless devices
> is
> somewhat arcane.  One has to listen to NEW_WIPHY/DEL_WIPHY events
> over
> nl80211 as well as RTM_NEWLINK / RTM_DELLINK events over rtnl, then
> somehow find a correlation between these events.  This involves
> userspace
> sending GET_INTERFACE or GET_WIPHY commands to the kernel, which
> incurs
> additional roundtrips.
> 
> This patch series proposes that NEW_INTERFACE and DEL_INTERFACE
> events are
> always emitted, regardless of whether a netdev was added/removed by
> the
> driver or explicitly via NEW_INTERFACE/DEL_INTERFACE commands.
> 
> One side effect of this approach is that multiple
> NEW_INTERFACE/DEL_INTERFACE
> events might be generated for P2P interfaces.  Once when a wdev is
> created
> or destroyed, and once when the associated p2p netdev is connecte or 
> disconnected.  

I think you got some things mixed up. Are you talking of P2P GO/client
interfaces, which have netdevs, but are really the same as AP/BSS
client and thus the issue here would affect the others? Or are you
talking about the P2P-Device wdev? but that has no netdev.

> It is likely that only the caller of P2P oriented
> NEW_INTERFACE / DEL_INTERFACE commands is interested in the status of
> these
> operations.  E.g. the caller is / should be using SOCKET_OWNER
> attribute.
> Thus one possibility is to not emit NEW_INTERFACE/DEL_INTERFACE
> events in
> such cases.
> 

The breaking up of patches is also confusing. You seem to be
introducing things in the first, then breaking them again, and then
fixing them?

Couldn't the whole thing be done in one or maybe two (new/del)
patch(es)?

(You obviously also need to sign off your patches, see the kernel
Documentation/)

johannes
