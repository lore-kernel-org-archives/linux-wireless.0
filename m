Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:45771 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752671AbaFLHna (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jun 2014 03:43:30 -0400
Message-ID: <53995A1F.6000405@broadcom.com> (sfid-20140612_094333_618630_0312AC3F)
Date: Thu, 12 Jun 2014 09:43:27 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Emmanuel Grumbach <egrumbach@gmail.com>,
	=?UTF-8?B?UmFmYcWCIE1pxYJlY2s=?= =?UTF-8?B?aQ==?=
	<zajec5@gmail.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	<b43-dev@lists.infradead.org>, Aaro Koskinen <aaro.koskinen@iki.fi>
Subject: Re: [RFC: which stable kernels?] b43: fix frequency reported on G-PHY
 with /new/ firmware
References: <1402558118-25777-1-git-send-email-zajec5@gmail.com> <CANUX_P1RA6PUDiFrT0wta57BNW9oRVAkNstT5ieiBjA9sHWnfw@mail.gmail.com>
In-Reply-To: <CANUX_P1RA6PUDiFrT0wta57BNW9oRVAkNstT5ieiBjA9sHWnfw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12-06-14 09:35, Emmanuel Grumbach wrote:
>> ---
>> This bug was there for years, however didn't cause any problems. It was
>> exposed recently by the 3.15 release by the:
>>
>> commit 3afc2167f60a327a2c1e1e2600ef209a3c2b75b7
>> Author: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
>> Date:   Tue Mar 4 16:50:13 2014 +0200
>>
>>      cfg80211/mac80211: ignore signal if the frame was heard on wrong channel
>>
>> Should we mark it for stable for 3.15 only? Or all olders kernels as well?
>
> Up to you - my patch is in 3.15 only I think.

Is there any scenario that would expose the worng info. Maybe when using 
monitor mode?

Gr. AvS

>> ---
>>   drivers/net/wireless/b43/xmit.c | 10 +++++++---
>>   1 file changed, 7 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/net/wireless/b43/xmit.c b/drivers/net/wireless/b43/xmit.c
>> index 4f38f19..6e6ef3f 100644
>> --- a/drivers/net/wireless/b43/xmit.c
>> +++ b/drivers/net/wireless/b43/xmit.c
>> @@ -811,9 +811,13 @@ void b43_rx(struct b43_wldev *dev, struct sk_buff *skb, const void *_rxhdr)
>>                  break;
>>          case B43_PHYTYPE_G:
>>                  status.band = IEEE80211_BAND_2GHZ;
>> -               /* chanid is the radio channel cookie value as used
>> -                * to tune the radio. */
>> -               status.freq = chanid + 2400;
>> +               /* Somewhere between 478.104 and 508.1084 firmware for G-PHY
>> +                * has been modified to be compatible with N-PHY and others.
>> +                */
>> +               if (dev->fw.rev >= 508)
>> +                       status.freq = ieee80211_channel_to_frequency(chanid, status.band);
>> +               else
>> +                       status.freq = chanid + 2400;
>>                  break;
>>          case B43_PHYTYPE_N:
>>          case B43_PHYTYPE_LP:
>> --
>> 1.8.4.5
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

