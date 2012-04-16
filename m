Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:41847 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892Ab2DPQLJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Apr 2012 12:11:09 -0400
Message-ID: <4F8C4494.2020909@candelatech.com> (sfid-20120416_181113_042899_B86EAEF8)
Date: Mon, 16 Apr 2012 09:11:00 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	ath5k-devel@venema.h4ckr.net
Subject: Re: [PATCH] ath5k: add possible wiphy interface combinations
References: <1334590102-83386-1-git-send-email-nbd@openwrt.org> <4F8C427C.3020505@candelatech.com> <4F8C43BD.2070403@openwrt.org>
In-Reply-To: <4F8C43BD.2070403@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/16/2012 09:07 AM, Felix Fietkau wrote:
> On 2012-04-16 6:02 PM, Ben Greear wrote:
>> On 04/16/2012 08:28 AM, Felix Fietkau wrote:
>>> Signed-off-by: Felix Fietkau<nbd@openwrt.org>
>>> ---
>>>    drivers/net/wireless/ath/ath5k/base.c |   16 ++++++++++++++++
>>>    1 files changed, 16 insertions(+), 0 deletions(-)
>>>
>>> diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
>>> index 3007bba..2e385f5 100644
>>> --- a/drivers/net/wireless/ath/ath5k/base.c
>>> +++ b/drivers/net/wireless/ath/ath5k/base.c
>>> @@ -2415,6 +2415,19 @@ ath5k_tx_complete_poll_work(struct work_struct *work)
>>>    * Initialization routines *
>>>    \*************************/
>>>
>>> +static const struct ieee80211_iface_limit if_limits[] = {
>>> +	{ .max = 256,	.types = BIT(NL80211_IFTYPE_STATION) },
>>> +	{ .max = 4,	.types = BIT(NL80211_IFTYPE_AP) |
>>> +				 BIT(NL80211_IFTYPE_MESH_POINT) },
>>> +};
>>
>> The station max is just an arbitrary number or is 256 really
>> the max it can handle?  At least on ath9k, more are supported,
>> but I haven't tested ath5k lately....
> It is an arbitrary number.

I think the actual max for a channel (AP?) is somewhere around 2000, so maybe
make it 2048 just to make sure we are not adding artificial limitations?

Same with ath9k.

Thanks,
Ben

>
> - Felix


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

