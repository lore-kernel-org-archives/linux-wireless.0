Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:14952 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754324Ab0J1Md5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Oct 2010 08:33:57 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 28 Oct 2010 05:33:45 -0700
Message-ID: <4CC96DB0.6040708@atheros.com>
Date: Thu, 28 Oct 2010 18:03:52 +0530
From: Mohammed Shafi <mshajakhan@atheros.com>
MIME-Version: 1.0
To: Rajkumar Manoharan <rajkumarvm@live.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFC] ath9k: Fix incorrect access of rate flags in RC
References: <1288021004-7315-1-git-send-email-mshajakhan@atheros.com> <AANLkTi=M9AR6ubFfuZb3rDLit_DvrkL14emM7OQYdmSb@mail.gmail.com>,<4CC65C42.70604@atheros.com> <COL121-W4399D19465DDBEEFA3FBA9A1440@phx.gbl>
In-Reply-To: <COL121-W4399D19465DDBEEFA3FBA9A1440@phx.gbl>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 28 October 2010 05:45 PM, Rajkumar Manoharan wrote:
>    
>> looks like ,but not very sure Luis,need to consult Senthil and will tell
>> you.
>> thanks,
>> shafi
>>
>> On Monday 25 October 2010 10:06 PM, Luis R. Rodriguez wrote:
>>      
>>> On Mon, Oct 25, 2010 at 8:36 AM, Mohammed Shafi Shajakhan
>>>   wrote:
>>>
>>>        
>>>> From: Mohammed Shafi Shajakhan
>>>>
>>>> The index variable to access the rate flags should be obtained from the
>>>> inner loop counter which corresponds to rate table structure.
>>>>
>>>> Signed-off-by: Mohammed Shafi Shajakhan
>>>>
>>>>          
>>> Is this a stable fix?
>>>
>>> Luis
>>>
>>>        
> Yes it is a stable fix. It solves the invalid rate selection when the supported basic rate
>
> is invalid on a purticular band. This patch fixed the following warning message.
>
>
>
> Call Trace:
>
>   [<ffffffff8104ee4a>] warn_slowpath_common+0x7a/0xb0
>
>   [<ffffffff8104ee95>] warn_slowpath_null+0x15/0x20
>
>   [<ffffffffa0583c45>] ath_get_rate+0x595/0x5b0 [ath9k]
>
>   [<ffffffff811a0636>] ? cpumask_next_and+0x36/0x50
>
>   [<ffffffffa0405186>] rate_control_get_rate+0x86/0x160 [mac80211]
>
>   [<ffffffffa040dfac>] invoke_tx_handlers+0x81c/0x12d0 [mac80211]
>
>   [<ffffffffa040eae9>] ieee80211_tx+0x89/0x2b0 [mac80211]
>
>   [<ffffffff812891bc>] ? pskb_expand_head+0x1cc/0x1f0
>
>   [<ffffffffa040edc5>] ieee80211_xmit+0xb5/0x1c0 [mac80211]
>
>   [<ffffffffa041026f>] ieee80211_tx_skb+0x4f/0x60 [mac80211]
>
>   [<ffffffffa03fe016>] ieee80211_send_nullfunc+0x46/0x60 [mac80211]
>
>   [<ffffffffa03f91d7>] ieee80211_offchannel_stop_station+0x107/0x150 [mac80211]
>
>   [<ffffffff812891bc>] ? pskb_expand_head+0x1cc/0x1f0
>
>   [<ffffffffa040edc5>] ieee80211_xmit+0xb5/0x1c0 [mac80211]
>
>   [<ffffffffa041026f>] ieee80211_tx_skb+0x4f/0x60 [mac80211]
>
>   [<ffffffffa03fe016>] ieee80211_send_nullfunc+0x46/0x60 [mac80211]
>
>   [<ffffffffa03f91d7>] ieee80211_offchannel_stop_station+0x107/0x150 [mac80211]
>
>   [<ffffffffa03f8896>] ieee80211_scan_work+0x146/0x600 [mac80211]
>
>   [<ffffffff8133a375>] ? schedule+0x2f5/0x8e0
>
>   [<ffffffffa03f8750>] ? ieee80211_scan_work+0x0/0x600 [mac80211]
>
>   [<ffffffff81064fcf>] process_one_work+0x10f/0x380
>
>   [<ffffffff81066bc2>] worker_thread+0x162/0x340
>
>   [<ffffffff81066a60>] ? worker_thread+0x0/0x340
>
> - Rajkumar
>   		 	   		  .
>
>    
Thanks Raj.
shafi
