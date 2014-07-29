Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:59548 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753510AbaG2QFy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jul 2014 12:05:54 -0400
Message-ID: <53D7C661.2040107@candelatech.com> (sfid-20140729_180559_769193_1A17001E)
Date: Tue, 29 Jul 2014 09:05:53 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	antonio@open-mesh.com
Subject: Re: [PATCH] ath9k: fix aggregation session lockup
References: <1406122854-60239-1-git-send-email-nbd@openwrt.org> <53D6B87D.6080007@candelatech.com> <53D6BC7F.2020002@openwrt.org>
In-Reply-To: <53D6BC7F.2020002@openwrt.org>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/28/2014 02:11 PM, Felix Fietkau wrote:
> On 2014-07-28 22:54, Ben Greear wrote:
>> On 07/23/2014 06:40 AM, Felix Fietkau wrote:
>>> If an aggregation session fails, frames still end up in the driver queue
>>> with IEEE80211_TX_CTL_AMPDU set.
>>> This causes tx for the affected station/tid to stall, since
>>> ath_tx_get_tid_subframe returning packets to send.
>>>
>>> Fix this by clearing IEEE80211_TX_CTL_AMPDU as long as no aggregation
>>> session is running.
>>
>> Did this and your previous patch about 'pending tx frames accounting'
>> fix the issues reported?
> Yes.
> 
>> They at least do not fix the problems I see where tx appears to hang,
>> but my setup is pretty 'special'....
> Interesting. Maybe you should ask Antonio for an updated version of the
> patch that he used to debug this issue. If you give me the output of it
> while it's locked up, I might be able to figure out what's going on in
> your setup.

What is the easiest upstream tree for you to debug?

Thanks,
Ben

> 
> - Felix
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

