Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:36330 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612Ab0I1R4I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Sep 2010 13:56:08 -0400
Message-ID: <4CA22C34.1000107@candelatech.com>
Date: Tue, 28 Sep 2010 10:56:04 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: RFC:  Store premable and g-mode flags in ieee80211_tx_info
References: <4CA224FF.3030103@candelatech.com> <1285696089.32597.0.camel@jlt3.sipsolutions.net>
In-Reply-To: <1285696089.32597.0.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/28/2010 10:48 AM, Johannes Berg wrote:
> On Tue, 2010-09-28 at 10:25 -0700, Ben Greear wrote:
>> This way, you don't need to pass vif to ieee80211_rts_duration.
>
>
>> --- a/net/mac80211/tx.c
>> +++ b/net/mac80211/tx.c
>> @@ -1264,6 +1264,14 @@ ieee80211_tx_prepare(struct ieee80211_sub_if_data *sdata,
>>           }
>>           info->flags |= IEEE80211_TX_CTL_FIRST_FRAGMENT;
>>
>> +       /* Set this here so drivers don't need to reference vif
>> +        * when calling ieee80211_rts_duration
>> +        */
>> +       if (sdata->vif.bss_conf.use_short_preamble)
>> +               tx.flags |= IEEE80211_TX_SHORT_PREABLE;
>> +       if (sdata->flags&  IEEE80211_SDATA_OPERATING_GMODE)
>> +               tx.flags |= IEEE80211_TX_GMODE
>
> Don't understand -- tx.flags? Drivers don't reference that? How would a
> driver use this?

Sorry, it should be info->flags,
and missing a semi-colon...I guess I forgot to compile :P

Anyway, the reason is that the driver may not know the VIF (and
vif may be deleted) when calling the ieee80211_rts_duration, so it needs to be stored
in the tx_info structure.

Thanks,
Ben

>
> johannes


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

