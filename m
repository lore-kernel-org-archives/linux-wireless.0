Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:54704 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932075Ab1EFAQi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 May 2011 20:16:38 -0400
Message-ID: <4DC33DE2.1070508@candelatech.com> (sfid-20110506_021644_309418_99CD12FE)
Date: Thu, 05 May 2011 17:16:34 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Bisected:  ath9k: fix powersave frame filtering/buffering in
 AP mode broke STA association.
References: <4DC30C42.6070402@candelatech.com> <4DC3109F.6080601@openwrt.org> <4DC3135C.4040601@candelatech.com> <4DC31A0B.4040409@candelatech.com> <4DC31C91.1030303@openwrt.org>
In-Reply-To: <4DC31C91.1030303@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/05/2011 02:54 PM, Felix Fietkau wrote:
> On 2011-05-05 11:43 PM, Ben Greear wrote:
>> On 05/05/2011 02:15 PM, Ben Greear wrote:
>>> On 05/05/2011 02:03 PM, Felix Fietkau wrote:
>>>> On 2011-05-05 10:44 PM, Ben Greear wrote:
>>>>> I bisected the problem I was having with ath9k STA configured for WPA
>>>>> not being able to authenticate. I'm using nohwcrypt=1, which may
>>>>> be why no one else sees it.
>>>
>>>>> I'll be happy to test patches, it seems very easy to reproduce on
>>>>> my setup.
>>>> How about this?
>>>>
>>>> --- a/net/mac80211/tx.c
>>>> +++ b/net/mac80211/tx.c
>>>> @@ -1270,6 +1270,9 @@ ieee80211_tx_prepare(struct ieee80211_su
>>>> info->flags |= IEEE80211_TX_CTL_CLEAR_PS_FILT;
>>>> else if (test_and_clear_sta_flags(tx->sta, WLAN_STA_CLEAR_PS_FILT))
>>>> info->flags |= IEEE80211_TX_CTL_CLEAR_PS_FILT;
>>>> + else if (sdata->vif.type != NL80211_IFTYPE_AP&&
>>>> + sdata->vif.type != NL80211_IFTYPE_AP_VLAN)
>>>> + info->flags |= IEEE80211_TX_CTL_CLEAR_PS_FILT;
>>>>
>>>> hdrlen = ieee80211_hdrlen(hdr->frame_control);
>>>> if (skb->len> hdrlen + sizeof(rfc1042_header) + 2) {
>>>
>>> Yes, that seems to fix the problem.
>>>
>>> Thanks for the quick fix!
>>
>> Well, that appeared to fix the problem on -rc1, but when I go
>> back to -rc6 and apply that patch, it still doesn't work.
>>
>> Might be some other issue though...
> Odd. Please try bisecting by applying the patch for each test and
> reverting it before running git bisect again.

Unless I made a mistake, it's this patch that causes the next problem:

[greearb@build-32 linux.wt]$ git bisect bad
93ae2dd2230393566738a5f211ffbaa33b056d56 is the first bad commit
commit 93ae2dd2230393566738a5f211ffbaa33b056d56
Author: Felix Fietkau <nbd@openwrt.org>
Date:   Sun Apr 17 23:28:10 2011 +0200

     ath9k: assign keycache slots to unencrypted stations

Makes me wonder if I'm the only one crazy enough to actually use
wireless testing :P

Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

