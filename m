Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:38969 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932140Ab2KZWZM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2012 17:25:12 -0500
Message-ID: <50B3EC3F.7070303@candelatech.com> (sfid-20121126_232516_688848_4003AC80)
Date: Mon, 26 Nov 2012 14:25:03 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Kernel splat from 3.5.7+ (tainted)
References: <50B3A275.3010302@candelatech.com>   <50B3AAEB.3070709@candelatech.com>  (sfid-20121126_184631_765629_DC554BCF) <1353952597.2800.12.camel@jlt4.sipsolutions.net>  <50B3C505.3090407@candelatech.com> <1353967234.9820.0.camel@jlt4.sipsolutions.net>
In-Reply-To: <1353967234.9820.0.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/26/2012 02:00 PM, Johannes Berg wrote:
> On Mon, 2012-11-26 at 11:37 -0800, Ben Greear wrote:
>
>>>> 0x182f9 is in __ieee80211_tx (/home/greearb/git/linux-3.5.dev.y/net/mac80211/tx.c:1256).
>>>> 1251					skb_queue_splice_init(skbs, &local->pending[q]);
>>>> 1252				} else {
>>>> 1253					u32 len = skb_queue_len(&local->pending[q]);
>>>> 1254					if (len >= max_pending_qsize) {
>>>> 1255						__skb_unlink(skb, skbs);
>>>> 1256						dev_kfree_skb(skb);
>>>> 1257						/* TODO:  Add counter for this */
>>>> 1258					} else {
>>>
>>> Wait .. this appears to be a local patch you have, it doesn't exist.
>>> That explains why, the bug doesn't exist upstream (all freeing there is
>>> outside the queue lock)
>>
>> Ahh, sorry about that..it is entirely my bug it seems.
>>
>> I added a patch to keep from queing too many skbs since it can
>> OOM my system (for instance, when using pktgen to generate traffic,
>> if I recall correctly).
>>
>> Probably this bug isn't normally hit even in my code because
>> we rarely over-drive it like this, and upstream probably never
>> hits the OOM bug for similar reasons.
>>
>> In case you are still feeling generous of your time, do you think just
>> changing the call to dev_kfree_skb_any() and moving it outside
>> the spin-lock would be a proper fix?
>
> Either one will fix it, I believe, no need to do both.

Thanks.  I went ahead and did both...didn't seem like it
should hurt, at least.

Will beat on this for a while.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

