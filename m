Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purr.warmcat.com ([87.106.142.209]:40859 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759575AbXHCKfp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Aug 2007 06:35:45 -0400
Message-ID: <46B304FF.3000305@warmcat.com>
Date: Fri, 03 Aug 2007 11:35:43 +0100
From: Andy Green <andy@warmcat.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Ulrich Kunitz <kune@deine-taler.de>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Daniel Drake <dsd@gentoo.org>
Subject: Re: mac80211 driver interface semantics
References: <46B27729.5030406@gentoo.org>	 <20070803052935.GA12683@deine-taler.de>  <46B2E06F.4090706@warmcat.com>	 <1186134894.4647.24.camel@johannes.berg>  <46B3032C.5040306@warmcat.com> <1186137166.4647.34.camel@johannes.berg>
In-Reply-To: <1186137166.4647.34.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Somebody in the thread at some point said:
> On Fri, 2007-08-03 at 11:27 +0100, Andy Green wrote:
> 
>> Inside that question, if you mark up skb->ip_summed with CHECKSUM_NONE,
>> include/linux/skbuff.h says this:
>>
>> /* A. Checksumming of received packets by device.
>>  *
>>  *      NONE: device failed to checksum this packet.
>>  *              skb->csum is undefined.
>>
>> If we mark up the skb with FCS-broken packets with that, maybe it would
>> be compatible with the networking stack for this purpose.
> 
> No, that's the IP checksum. It may or may not be broken if the FCS CRC
> fails.

Right, but since we marked up the skb "the integrity of the IP checksum
is unknown", if anything wants to use the packet it should re-check it
itself.  Won't that do?

-Andy

