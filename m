Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purr.warmcat.com ([87.106.142.209]:34462 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759261AbXHCK16 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Aug 2007 06:27:58 -0400
Message-ID: <46B3032C.5040306@warmcat.com>
Date: Fri, 03 Aug 2007 11:27:56 +0100
From: Andy Green <andy@warmcat.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Ulrich Kunitz <kune@deine-taler.de>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Daniel Drake <dsd@gentoo.org>
Subject: Re: mac80211 driver interface semantics
References: <46B27729.5030406@gentoo.org>	 <20070803052935.GA12683@deine-taler.de>  <46B2E06F.4090706@warmcat.com> <1186134894.4647.24.camel@johannes.berg>
In-Reply-To: <1186134894.4647.24.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Somebody in the thread at some point said:
> On Fri, 2007-08-03 at 08:59 +0100, Andy Green wrote:
> 
>> There seems to be some agreement that in the future the number of
>> virtual interfaces that happen to be lying around shouldn't determine
>> the functionality of Monitor mode like that.
> 
> I think that only happens if you don't have monitor_during_oper set;
> otherwise it's a bug.
> 
> I am, however, not entirely sure we should be forwarding packets with
> failed CRC on hard monitor interfaces. Because if you have both a hard
> monitor and a regular interface (monitor_during_oper allowed) then we
> will never check the CRC on frames that enter the networking path and
> can get corrupted TCP packets in etc.

Hm well outside of that question I don't think failed CRC packets should
be on by default for Monitor mode.  It should be something you can ask
for explicitly if you are interested.

Inside that question, if you mark up skb->ip_summed with CHECKSUM_NONE,
include/linux/skbuff.h says this:

/* A. Checksumming of received packets by device.
 *
 *      NONE: device failed to checksum this packet.
 *              skb->csum is undefined.

If we mark up the skb with FCS-broken packets with that, maybe it would
be compatible with the networking stack for this purpose.

-Andy
