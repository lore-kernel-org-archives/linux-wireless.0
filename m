Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:58867 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754579Ab0CGSbm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Mar 2010 13:31:42 -0500
Message-ID: <4B93F109.2000607@openwrt.org>
Date: Sun, 07 Mar 2010 19:31:37 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@googlemail.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Derek Smithies <derek@indranet.co.nz>,
	Benoit PAPILLAULT <benoit.papillault@free.fr>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	=?ISO-8859-1?Q?Bj=F6rn_Smedman?= <bjorn.smedman@venatech.se>,
	Bob Copeland <me@bobcopeland.com>
Subject: Re: [RFC v2] minstrel_ht: new rate control module for 802.11n
References: <4B93D6D3.80702@openwrt.org> <201003071859.25848.chunkeey@googlemail.com>
In-Reply-To: <201003071859.25848.chunkeey@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-03-07 6:59 PM, Christian Lamparter wrote:
> On Sunday 07 March 2010 17:39:47 Felix Fietkau wrote:
>> here is an updated version of my minstrel_ht code. Since the last
>> version, I've added the following improvements:
>> 
>> - Use accurate A-MPDU statistics from tx feedback
>> - Rewrite the sampling algorithm to optimize for good A-MPDU lengths
>>   and faster throughput recovery
>> - Implement .rate_update to handle changes in HT capabilities or 
>>   channel bandwidth
>> - Remove the private tx flags hack
>> 
>> With the new version, performance has improved visibly for HT40 in all
>> of my tests. I think it's getting closer to being ready for inclusion.
>> ---
> Just released carl9170 1.0.3.1 which now uses minstrel_ht.
> 
> I found a few things, not sure if they are bugs in the driver
> or minstrel_ht code. (Patch attached, but added the comments
> as a response to the code) 
Thanks. How well does it perform in your tests compared to the old rc?

> on startup, carl9170 complains about non-aggregated
> (CTL_AMPDU not set) MCS frames. I had to add an
> alternative path for these _early_ frames. They are
> now send with the "lowest" legacy rate and aren't
> rejected by the driver/HW.
Why does it complain - is that a driver thing or does the hardware
really refuse it? I didn't see anything in the standard that mandates
the use of A-MPDU with MCS rates.

- Felix
