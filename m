Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 26.mail-out.ovh.net ([91.121.27.225]:45655 "HELO
	26.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756437Ab0BOWYl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Feb 2010 17:24:41 -0500
Message-ID: <4B79C9A4.1060509@free.fr>
Date: Mon, 15 Feb 2010 23:24:36 +0100
From: Benoit PAPILLAULT <benoit.papillault@free.fr>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/2] mac80211: Improved IBSS merges even if BSSID is the
 same
References: <1266190435-2355-1-git-send-email-benoit.papillault@free.fr>	 <1266190435-2355-2-git-send-email-benoit.papillault@free.fr> <1266226106.6052.0.camel@jlt3.sipsolutions.net>
In-Reply-To: <1266226106.6052.0.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg a écrit :
> On Mon, 2010-02-15 at 00:33 +0100, Benoit Papillault wrote:
>   
>> According to IEEE 802.11, we should merge even if the BSSID from the
>> received beacon is the same as our since merge can update more things
>> that BSSID itself.
>>
>> This is specifically true for ath9k where the merge updates TBTT
>> timers
>> as a side effect and this is indeed needed if the TSF has been updated
>> (if TSF is updated, we need to update TBTT timers as well).
>>
>> However, it could cause continuous merges if the RX timestamp or
>> drv_get_tsf() is not accurate or not implemented.
>>     
>
> It can't actually. Please do your own research on things like that
> before posting a patch :)
>
> johannes
>   
For Zydas chipset for instance, the TSF is not merged at the hardware 
level (I sent another patch to fix that). As such, if we receive a 
beacon with a higher TSF and did a merge at the software level, then on 
the next beacon, our own TSF has moved by the same delta as the value in 
the received beacon, so the beacon TSF is still higher than our own TSF, 
thus merging again (since we now accept merge with the same BSSID).

For the not implemented case (ie local->ops->get_tsf is null), 
drv_get_tsf() will returns -1 and then no merge could happen. You are 
right. I put part of our discussion into the changelog, mostly to 
acknowledge your toughts without checking myself. My bad!

Regards,
Benoit

