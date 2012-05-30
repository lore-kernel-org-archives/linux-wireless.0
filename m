Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:38634 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399Ab2E3G7c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 May 2012 02:59:32 -0400
Message-ID: <4FC5C547.8040503@qca.qualcomm.com> (sfid-20120530_085935_196937_7457DCCD)
Date: Wed, 30 May 2012 12:29:19 +0530
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH V2 1/2] ath6kl: Fix race in aggregation reorder logic
References: <1337941158-14895-1-git-send-email-vthiagar@qca.qualcomm.com> <4FC4AF40.3060702@qca.qualcomm.com> <4FC4B132.60209@qca.qualcomm.com> <4FC4B37E.2080002@qca.qualcomm.com>
In-Reply-To: <4FC4B37E.2080002@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On Tuesday 29 May 2012 05:01 PM, Kalle Valo wrote:
> On 05/29/2012 02:21 PM, Vasanthakumar Thiagarajan wrote:
>> On Tuesday 29 May 2012 04:43 PM, Kalle Valo wrote:
>>> On 05/25/2012 01:19 PM, Vasanthakumar Thiagarajan wrote:
>>>
>>>> @@ -1188,6 +1189,7 @@ static bool aggr_process_recv_frm(struct aggr_info_conn *agg_conn, u8 tid,
>>>>    		rxtid->progress = true;
>>>>    	else
>>>>    		for (idx = 0 ; idx<   rxtid->hold_q_sz; idx++) {
>>>> +			spin_lock_bh(&rxtid->lock);
>>>>    			if (rxtid->hold_q[idx].skb) {
>>>>    				/*
>>>>    				 * There is a frame in the queue and no
>>>> @@ -1201,8 +1203,10 @@ static bool aggr_process_recv_frm(struct aggr_info_conn *agg_conn, u8 tid,
>>>>    					   HZ * (AGGR_RX_TIMEOUT) / 1000));
>>>>    				rxtid->progress = false;
>>>>    				rxtid->timer_mon = true;
>>>> +				spin_unlock_bh(&rxtid->lock);
>>>>    				break;
>>>>    			}
>>>> +			spin_unlock_bh(&rxtid->lock);
>>>>    		}
>>>
>>> Here you take and release the lock multiple times inside the loop. Why
>>> not take the lock before the loop?
>>
>> Sounds better to acquire the lock before loop and releasing it after
>> the loop. I was kind of thinking about protecting the data only
>> in critical section, but in this case we can bring the loop
>> in the lock, it is not going to make much difference.
>
> It's also the question of does the lock protect hold_q_sz.

No, it does not.

>
> Also, can you please fix the comment I added to core.h about the lock
> and document properly what the lock is actually supposed to protect:
>
> 	/*
> 	 * FIXME: No clue what this should protect. Apparently it should
> 	 * protect some of the fields above but they are also accessed
> 	 * without taking the lock.
> 	 */

Good point, thanks.

Vasanth
