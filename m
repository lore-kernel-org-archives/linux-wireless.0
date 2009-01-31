Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:46184 "EHLO ds10.mine.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752839AbZAaS4o (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 Jan 2009 13:56:44 -0500
Message-ID: <49849ED9.6080300@openwrt.org> (sfid-20090131_195648_533960_421712F4)
Date: Sat, 31 Jan 2009 19:56:25 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Nick Kossifidis <mickflemm@gmail.com>
CC: Bob Copeland <me@bobcopeland.com>, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	jirislaby@gmail.com, mcgrof@gmail.com
Subject: Re: [ath5k-devel] [PATCH 5/5] ath5k: Update reset code
References: <20090131023147.GE3342@makis>	 <20090131170802.GA16826@hash.localnet> <40f31dec0901311048t3834612cgc6b1dd01aa42a5c0@mail.gmail.com>
In-Reply-To: <40f31dec0901311048t3834612cgc6b1dd01aa42a5c0@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Nick Kossifidis wrote:
>>> [...]
>>> @@ -2156,7 +2157,8 @@
>>>  #define      AR5K_PHY_ANT_CTL_TXRX_EN        0x00000001      /* Enable TX/RX (?) */
>>>  #define      AR5K_PHY_ANT_CTL_SECTORED_ANT   0x00000004      /* Sectored Antenna */
>>>  #define      AR5K_PHY_ANT_CTL_HITUNE5        0x00000008      /* Hitune5 (?) */
>>> -#define      AR5K_PHY_ANT_CTL_SWTABLE_IDLE   0x00000010      /* Switch table idle (?) */
>>> +#define      AR5K_PHY_ANT_CTL_SWTABLE_IDLE   0x000003f9      /* Switch table idle (?) */
>>> +#define      AR5K_PHY_ANT_CTL_SWTABLE_IDLE_S 4
>>
>> That doesn't look right.. should be 3f0?  (still probably works, I guess).
>>
> 
> I know, but HAL does this...
> 	AR_PHY_BIS(ah, 68, 0xFFFFFC06,
> 		(ee->ee_antennaControl[0][arrayMode] << 4) | 0x1);
> 
> ~0xFFFFFC06 = 3F9
How about splitting it up and making the 0x1 a separate flag?

> My intention is to reimplement hw_htoclock to account for half/quarter
> rate so it'll soon be
> clock = ath5k_hw_htoclock(1, channel->hw_value);
AFAIK Sam's HAL might have a bug there. If I remember correctly, the MAC
runs at the same clock speed with Half/Quarter rate.
It's done that way in the legacy HAL. Though there is a possibility of
it being hardware dependent, I'm pretty sure that it is that way at least
on 5413.

>>> +     /* Set DAC/ADC delays */
>>> +     if (ah->ah_version == AR5K_AR5212) {
>>> +             if (ah->ah_mac_version == (AR5K_SREV_AR2417 >> 4))
>>> +                     data = AR5K_PHY_SCAL_32MHZ_2417;
>>> +             else if (ath5k_eeprom_is_hb63(ah))
>>> +                     data = AR5K_PHY_SCAL_32MHZ_HB63;
>>> +             else
>>> +                     data = AR5K_PHY_SCAL_32MHZ;
>>> +             ath5k_hw_reg_write(ah, data, AR5K_PHY_SCAL);
>>> +             data = 0;
>>
>> why data = 0; ?
>>
> Instead of having multiple temporary variables, i use only "data". To
> be sure that "data" is ok for use i always zero it each time i use it
> so that we don't write any weird stuff by mistake.
Wouldn't multiple temporary values be preferable, since the compiler
optimizes that stuff anyway?

- Felix
