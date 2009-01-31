Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f21.google.com ([209.85.217.21]:46734 "EHLO
	mail-gx0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752279AbZAaUuN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 Jan 2009 15:50:13 -0500
Received: by gxk14 with SMTP id 14so789773gxk.13
        for <linux-wireless@vger.kernel.org>; Sat, 31 Jan 2009 12:50:12 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <49849ED9.6080300@openwrt.org>
References: <20090131023147.GE3342@makis>
	 <20090131170802.GA16826@hash.localnet>
	 <40f31dec0901311048t3834612cgc6b1dd01aa42a5c0@mail.gmail.com>
	 <49849ED9.6080300@openwrt.org>
Date: Sat, 31 Jan 2009 22:50:11 +0200
Message-ID: <40f31dec0901311250q6a669849x1dfbf08d967787be@mail.gmail.com> (sfid-20090131_215019_948350_6245E40D)
Subject: Re: [ath5k-devel] [PATCH 5/5] ath5k: Update reset code
From: Nick Kossifidis <mickflemm@gmail.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: Bob Copeland <me@bobcopeland.com>, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	jirislaby@gmail.com, mcgrof@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/1/31 Felix Fietkau <nbd@openwrt.org>:
> Nick Kossifidis wrote:
>>>> [...]
>>>> @@ -2156,7 +2157,8 @@
>>>>  #define      AR5K_PHY_ANT_CTL_TXRX_EN        0x00000001      /* Enable TX/RX (?) */
>>>>  #define      AR5K_PHY_ANT_CTL_SECTORED_ANT   0x00000004      /* Sectored Antenna */
>>>>  #define      AR5K_PHY_ANT_CTL_HITUNE5        0x00000008      /* Hitune5 (?) */
>>>> -#define      AR5K_PHY_ANT_CTL_SWTABLE_IDLE   0x00000010      /* Switch table idle (?) */
>>>> +#define      AR5K_PHY_ANT_CTL_SWTABLE_IDLE   0x000003f9      /* Switch table idle (?) */
>>>> +#define      AR5K_PHY_ANT_CTL_SWTABLE_IDLE_S 4
>>>
>>> That doesn't look right.. should be 3f0?  (still probably works, I guess).
>>>
>>
>> I know, but HAL does this...
>>       AR_PHY_BIS(ah, 68, 0xFFFFFC06,
>>               (ee->ee_antennaControl[0][arrayMode] << 4) | 0x1);
>>
>> ~0xFFFFFC06 = 3F9
> How about splitting it up and making the 0x1 a separate flag?
>

Agree, i'll change eeprom.c too...

	/* Get antenna modes */
	ah->ah_antenna[mode][0] =
	    (ee->ee_ant_control[mode][0] << 4) | 0x1;

>> My intention is to reimplement hw_htoclock to account for half/quarter
>> rate so it'll soon be
>> clock = ath5k_hw_htoclock(1, channel->hw_value);
> AFAIK Sam's HAL might have a bug there. If I remember correctly, the MAC
> runs at the same clock speed with Half/Quarter rate.
> It's done that way in the legacy HAL. Though there is a possibility of
> it being hardware dependent, I'm pretty sure that it is that way at least
> on 5413.
>

Both HALs tweak clock this way on ar5212SetDeltaSlope on all chips. If
clock depends on channel bandwidth for turbo it makes sense to also
change on half/quarter rate operation.

>>>> +     /* Set DAC/ADC delays */
>>>> +     if (ah->ah_version == AR5K_AR5212) {
>>>> +             if (ah->ah_mac_version == (AR5K_SREV_AR2417 >> 4))
>>>> +                     data = AR5K_PHY_SCAL_32MHZ_2417;
>>>> +             else if (ath5k_eeprom_is_hb63(ah))
>>>> +                     data = AR5K_PHY_SCAL_32MHZ_HB63;
>>>> +             else
>>>> +                     data = AR5K_PHY_SCAL_32MHZ;
>>>> +             ath5k_hw_reg_write(ah, data, AR5K_PHY_SCAL);
>>>> +             data = 0;
>>>
>>> why data = 0; ?
>>>
>> Instead of having multiple temporary variables, i use only "data". To
>> be sure that "data" is ok for use i always zero it each time i use it
>> so that we don't write any weird stuff by mistake.
> Wouldn't multiple temporary values be preferable, since the compiler
> optimizes that stuff anyway?
>

Hmm, you are right, i just opened ath5k.o with IDA and it seems
hw_reset has too many ints so what i'm doing is probably confusing for
gcc.



-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
