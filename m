Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:52363 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756044Ab0KXWlm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Nov 2010 17:41:42 -0500
Received: by qwb7 with SMTP id 7so259002qwb.19
        for <linux-wireless@vger.kernel.org>; Wed, 24 Nov 2010 14:41:41 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTimEZnDrXYa4WOKn=9VvL0qwYUTbABy1WgmSqe4m@mail.gmail.com>
References: <20101123191533.GP4303@makis.mantri> <AANLkTi=YLPnqRzzfXaeghQ-w5vDgfCX5v59tGbgSp8zA@mail.gmail.com>
 <AANLkTimEZnDrXYa4WOKn=9VvL0qwYUTbABy1WgmSqe4m@mail.gmail.com>
From: Jonathan Guerin <jonathan@guerin.id.au>
Date: Thu, 25 Nov 2010 08:41:25 +1000
Message-ID: <AANLkTim6G7rO852RCma7qg=LqTwNav6E_OdqwLD7esCP@mail.gmail.com>
Subject: Re: [ath5k-devel] [PATCH 16/30] ath5k: Set all IFS intervals, not
 just slot time
To: Nick Kossifidis <mickflemm@gmail.com>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, me@bobcopeland.com, mcgrof@gmail.com,
	jirislaby@gmail.com, nbd@openwrt.org, br1@einfach.org
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 24, 2010 at 10:55 PM, Nick Kossifidis <mickflemm@gmail.com> wrote:
> 2010/11/24 Jonathan Guerin <jonathan@guerin.id.au>:
>>
>>> diff --git a/drivers/net/wireless/ath/ath5k/pcu.c b/drivers/net/wireless/ath/ath5k/pcu.c
>>> index e691378..4556f29 100644
>>> --- a/drivers/net/wireless/ath/ath5k/pcu.c
>>> +++ b/drivers/net/wireless/ath/ath5k/pcu.c
>>> @@ -763,7 +763,7 @@ ath5k_hw_check_beacon_timers(struct ath5k_hw *ah, int intval)
>>>  * @ah: The &struct ath5k_hw
>>>  * @coverage_class: IEEE 802.11 coverage class number
>>>  *
>>> - * Sets slot time, ACK timeout and CTS timeout for given coverage class.
>>> + * Sets IFS intervals and ACK/CTS timeouts for given coverage class.
>>>  */
>>>  void ath5k_hw_set_coverage_class(struct ath5k_hw *ah, u8 coverage_class)
>>>  {
>>> @@ -772,7 +772,7 @@ void ath5k_hw_set_coverage_class(struct ath5k_hw *ah, u8 coverage_class)
>>>        int ack_timeout = ath5k_hw_get_default_sifs(ah) + slot_time;
>>
>> This is not quite right:
>>
>> According to the 802.11-2007 spec document, the ACKTimeout value is
>> (Section 9.2.8 ACK procedure):
>> ACKTimeout = aSIFSTime + aSlotTime + aPHY-RX-START-Delay
>>
>> From Table 17-15—OFDM PHY characteristics, the values are:
>> aSIFSTime = 16
>> aSlotTime = 9
>> aPHY-RX-START-Delay = 25
>>
>> Therefore, ACKTimeout = 50
>>
>> Ignoring my uniformed comments from before, this is the only thing I
>> can see that's wrong.
>>
>> Cheers,
>>
>> Jonathan
>
> Hmm I didn't mess with set_coverage_class so i didn't look up for ack
> timeout. That phy-rx-start-delay is standard value or hw specific ?
> Also does it change with clockrate (bwmodes) ? We already have a phy
> activation -> rx start delay (check patch 25). It's 10.000 on RF5111
> and 2.000 on RF5112 and later, if we divide by A clock it's 250 on
> RF5111 and 50 on RF5112 and later. Do you think it's related ?

The phy-rx-start-delay is set in the standard. I'll find you the
relevant pages soon.

I'll look up the others tomorrow. I'm feeling pretty sick today, so
not sure if I'll get a chance.

Cheers,

Jonathan

>
> --
> GPG ID: 0xD21DB2DB
> As you read this post global entropy rises. Have Fun ;-)
> Nick
>
