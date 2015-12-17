Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:58222 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752330AbbLQKf2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Dec 2015 05:35:28 -0500
Subject: Re: [RFC/RFT 1/2] mac80211: Add NEED_ALIGNED4_SKBS hw flag
To: Johannes Berg <johannes@sipsolutions.net>,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	linux-wireless@vger.kernel.org
References: <1450344029-5296-1-git-send-email-janusz.dziedzic@tieto.com>
 <1450348183.8247.24.camel@sipsolutions.net>
From: Felix Fietkau <nbd@openwrt.org>
Message-ID: <56728FE7.4090006@openwrt.org> (sfid-20151217_113531_867804_3ECE5703)
Date: Thu, 17 Dec 2015 11:35:19 +0100
MIME-Version: 1.0
In-Reply-To: <1450348183.8247.24.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2015-12-17 11:29, Johannes Berg wrote:
> On Thu, 2015-12-17 at 10:20 +0100, Janusz Dziedzic wrote:
>> HW/driver should set NEED_ALIGNED4_SKBS flag in case require
>> aligned skbs to four-byte boundaries.
>> 
>> Before we have to do memmove() in the driver before
>> pass this to HW and memmove() back in tx completion.
>> This patch allow to save CPU and skip such memmoves.
> 
> Can you quantify that btw? It shouldn't be that expensive since it's
> all in the cache for read, so just has to be written out to RAM before
> the DMA can happen...
On many devices that I'm using, the data path is definitely too bloated
for the packet to still be in cache, so I do think this will help.
Remember, having only 32 KiB Dcache (no L2) is not uncommon on devices
running ath9k.

> And on status it will be pulled into the cache
> anyway, and you don't even need the write to happen before you can
> continue.
This doesn't make sense to me. The write needs to happen before the
device can do DMA...

- Felix
