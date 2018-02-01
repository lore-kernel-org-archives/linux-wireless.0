Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:36362 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751976AbeBAWdQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Feb 2018 17:33:16 -0500
Subject: Re: lockdep warning in mac80211/tx.c, 4.13.16+ kernel, ath9k related
To: Johannes Berg <johannes@sipsolutions.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <d4632910-7dd9-b066-0c10-b21dd7cbfc61@candelatech.com>
 <1517523817.28814.10.camel@sipsolutions.net>
From: Ben Greear <greearb@candelatech.com>
Message-ID: <e8f8b910-ffa8-fbc7-3152-58ccf70b1ace@candelatech.com> (sfid-20180201_233320_958086_7ECF76CE)
Date: Thu, 1 Feb 2018 14:33:14 -0800
MIME-Version: 1.0
In-Reply-To: <1517523817.28814.10.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/01/2018 02:23 PM, Johannes Berg wrote:
> On Wed, 2018-01-31 at 16:53 -0800, Ben Greear wrote:
>>
>> Any idea why this might be complaining?
>
>>   30917 Jan 31 15:21:01 2u-6n kernel: =============================
>>   30918 Jan 31 15:21:01 2u-6n kernel: WARNING: suspicious RCU usage
>
> well, that's why? :-)

All of RCU is suspicious as far as my feeble brain is concerned...I was wondering *why*
it was suspicious.  I see you answered below... :)

>
>>   30933                               stack backtrace:
>>   30934 Jan 31 15:21:01 2u-6n kernel: CPU: 1 PID: 19628 Comm: ip Tainted: G        W  O    4.13.16+ #2
>>   30935 Jan 31 15:21:01 2u-6n kernel: Hardware name: Iron_Systems,Inc CS-CAD-2U-A02/X10SRL-F, BIOS 2.0b 05/02/2017
>>   30936 Jan 31 15:21:01 2u-6n kernel: Call Trace:
>>   30937 Jan 31 15:21:01 2u-6n kernel:  dump_stack+0x85/0xc7
>>   30938 Jan 31 15:21:01 2u-6n kernel:  lockdep_rcu_suspicious+0xc5/0x100
>>   30939 Jan 31 15:21:01 2u-6n kernel:  ieee80211_tx_h_select_key+0x1c9/0x4e0 [mac80211]
>>   30940 Jan 31 15:21:01 2u-6n kernel:  ieee80211_tx_dequeue+0x376/0xca0 [mac80211]
>>   30941 Jan 31 15:21:01 2u-6n kernel:  ath_tid_dequeue+0x9c/0x110 [ath9k]
>>   30942 Jan 31 15:21:01 2u-6n kernel:  ath_tx_node_cleanup+0xa4/0x160 [ath9k]
>>   30943 Jan 31 15:21:01 2u-6n kernel:  ath9k_sta_state+0x6b/0x1e0 [ath9k]
>>   30944 Jan 31 15:21:01 2u-6n kernel:  drv_sta_state+0xad/0xa80 [mac80211]
>
> I'd argue your hacks are at fault - somewhere in your modifications
> around this call stack you lost the necessary rcu_read_lock()
> protection.

Ok, I'll go looking for bugs like that.

Thanks!
--Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
