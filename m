Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:51462 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753928Ab3AaRQS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jan 2013 12:16:18 -0500
Message-ID: <510AA6D6.3000801@candelatech.com> (sfid-20130131_181622_176744_942DBC11)
Date: Thu, 31 Jan 2013 09:16:06 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC] Expand byte counters in struct station_info
References: <6017229.5ECEUbBVAL@lx-vladimir> <1359628924.8415.5.camel@jlt4.sipsolutions.net>
In-Reply-To: <1359628924.8415.5.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/31/2013 02:42 AM, Johannes Berg wrote:
> On Thu, 2013-01-31 at 11:46 +0200, Vladimir Kondratiev wrote:
>> Hi,
>>
>> Now wifi drivers reports per-station info using struct station_info;
>> and currently for the data counters it has:
>> 	u32 rx_bytes;
>> 	u32 tx_bytes;
>>
>> while for device-wide statistics one can use ndo_get_stats64() to fill
>> 64-bit counters in the struct rtnl_link_stats64, per-station statistics
>> are 32-bit.
>>
>> This becomes problematic with gigabit speeds now observed for .11ac and .11ad -
>> counters overflown every few seconds.
>>
>> I'd like to extend rx and tx byte counters to 64-bit.
>>
>> What is better - expand existing fields in struct station_info as:
>> 	u64 rx_bytes;
>> 	u64 tx_bytes;
>
> This.
>
>> or add ne ones like:
>> 	u64 rx_bytes64;
>> 	u64 tx_bytes64;
>
> I don't see a reason to do this.
>
>>
>> Then, I'll add
>> 	NL80211_STA_INFO_RX_BYTES64,
>> 	NL80211_STA_INFO_TX_BYTES64,
>> to the enum nl80211_sta_info
>>
>> Before doing patch, I'd like to hear comments.
>> Any consideration why is this not to be done or done differently?
>
> Sounds good to me.
>
> Two points:
>
> 1) You should provide the RX_TX_BYTES attributes, but I think only if
> the value fits into 32 bits. That way, we don't report invalid
> information.

There are already a large amounts of '64-bit' counters reported by
netlink that really wrap at 32-bits, so any solid user-space
code already has to deal with this by making assumptions (ie, if cur
value is < last value, then it wrapped at 32-bits, because there is no way you
actually missed polling a real 64-bit counter wrap).

So, you might not have to worry about this so much.

In my own work, my biggest problem is that stations reset their
counters when they got ifdown and then back to ifup.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

