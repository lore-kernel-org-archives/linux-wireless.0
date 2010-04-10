Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:1536 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751050Ab0DJTOF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Apr 2010 15:14:05 -0400
Message-ID: <4BC0CDF8.4030609@gmail.com>
Date: Sat, 10 Apr 2010 21:14:00 +0200
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: Ivo van Doorn <ivdoorn@gmail.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [PATCH 5/9] rt2x00: Align rt2800 register initialization with
 vendor driver.
References: <1270763437-29526-1-git-send-email-gwingerde@gmail.com> <1270763437-29526-6-git-send-email-gwingerde@gmail.com> <201004090033.29518.IvDoorn@gmail.com>
In-Reply-To: <201004090033.29518.IvDoorn@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/09/10 00:33, Ivo van Doorn wrote:
> On Thursday 08 April 2010, Gertjan van Wingerde wrote:
>> Align the rt2800 register initializations with the latest versions of the
>> Ralink vendor driver.
>> This patch is also preparation for the addition of support for RT3070 /
>> RT3071 / RT3090 / RT3390 based devices.
>>
>> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
>> ---
>>  drivers/net/wireless/rt2x00/rt2800lib.c |  155 +++++++++++++++++++++++--------
>>  drivers/net/wireless/rt2x00/rt2800pci.c |   13 ---
>>  2 files changed, 114 insertions(+), 54 deletions(-)
> 
>> @@ -531,12 +526,8 @@ void rt2800_config_filter(struct rt2x00_dev *rt2x00dev,
>>  			   !(filter_flags & FIF_PLCPFAIL));
>>  	rt2x00_set_field32(&reg, RX_FILTER_CFG_DROP_NOT_TO_ME,
>>  			   !(filter_flags & FIF_PROMISC_IN_BSS));
>> -	rt2x00_set_field32(&reg, RX_FILTER_CFG_DROP_NOT_MY_BSSD, 0);
>> -	rt2x00_set_field32(&reg, RX_FILTER_CFG_DROP_VER_ERROR, 1);
>>  	rt2x00_set_field32(&reg, RX_FILTER_CFG_DROP_MULTICAST,
>>  			   !(filter_flags & FIF_ALLMULTI));
>> -	rt2x00_set_field32(&reg, RX_FILTER_CFG_DROP_BROADCAST, 0);
>> -	rt2x00_set_field32(&reg, RX_FILTER_CFG_DROP_DUPLICATE, 1);
>>  	rt2x00_set_field32(&reg, RX_FILTER_CFG_DROP_CF_END_ACK,
>>  			   !(filter_flags & FIF_CONTROL));
>>  	rt2x00_set_field32(&reg, RX_FILTER_CFG_DROP_CF_END,
>> @@ -549,8 +540,6 @@ void rt2800_config_filter(struct rt2x00_dev *rt2x00dev,
>>  			   !(filter_flags & FIF_CONTROL));
>>  	rt2x00_set_field32(&reg, RX_FILTER_CFG_DROP_PSPOLL,
>>  			   !(filter_flags & FIF_PSPOLL));
>> -	rt2x00_set_field32(&reg, RX_FILTER_CFG_DROP_BA, 1);
>> -	rt2x00_set_field32(&reg, RX_FILTER_CFG_DROP_BAR, 0);
>>  	rt2x00_set_field32(&reg, RX_FILTER_CFG_DROP_CNTL,
>>  			   !(filter_flags & FIF_CONTROL));
>>  	rt2800_register_write(rt2x00dev, RX_FILTER_CFG, reg);
> 
> I'm not a big fan of these changes. Unless the filters don't work as expected,
> I rather see the entire list of filters set to their correct values here.

OK. I'll back this out for now. I removed these bits as they now are being set at initialization
time already, and it didn't seem necessary to program these particular filters again to the same
value. But it is not critical, and it doesn't fix anything anyway.

> 
>> @@ -1176,6 +1179,31 @@ int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
>>  	rt2x00_set_field32(&reg, BCN_TIME_CFG_TX_TIME_COMPENSATE, 0);
>>  	rt2800_register_write(rt2x00dev, BCN_TIME_CFG, reg);
>>  
>> +	rt2800_register_read(rt2x00dev, RX_FILTER_CFG, &reg);
>> +	rt2x00_set_field32(&reg, RX_FILTER_CFG_DROP_CRC_ERROR, 1);
>> +	rt2x00_set_field32(&reg, RX_FILTER_CFG_DROP_PHY_ERROR, 1);
>> +	rt2x00_set_field32(&reg, RX_FILTER_CFG_DROP_NOT_TO_ME, 1);
>> +	rt2x00_set_field32(&reg, RX_FILTER_CFG_DROP_NOT_MY_BSSD, 0);
>> +	rt2x00_set_field32(&reg, RX_FILTER_CFG_DROP_VER_ERROR, 1);
>> +	rt2x00_set_field32(&reg, RX_FILTER_CFG_DROP_MULTICAST, 0);
>> +	rt2x00_set_field32(&reg, RX_FILTER_CFG_DROP_BROADCAST, 0);
>> +	rt2x00_set_field32(&reg, RX_FILTER_CFG_DROP_DUPLICATE, 1);
>> +	rt2x00_set_field32(&reg, RX_FILTER_CFG_DROP_CF_END_ACK, 1);
>> +	rt2x00_set_field32(&reg, RX_FILTER_CFG_DROP_CF_END, 1);
>> +	rt2x00_set_field32(&reg, RX_FILTER_CFG_DROP_ACK, 1);
>> +	rt2x00_set_field32(&reg, RX_FILTER_CFG_DROP_CTS, 1);
>> +	rt2x00_set_field32(&reg, RX_FILTER_CFG_DROP_RTS, 1);
>> +	rt2x00_set_field32(&reg, RX_FILTER_CFG_DROP_PSPOLL, 1);
>> +	rt2x00_set_field32(&reg, RX_FILTER_CFG_DROP_BA, 1);
>> +	rt2x00_set_field32(&reg, RX_FILTER_CFG_DROP_BAR, 0);
>> +	rt2x00_set_field32(&reg, RX_FILTER_CFG_DROP_CNTL, 1);
>> +	rt2800_register_write(rt2x00dev, RX_FILTER_CFG, reg);
> 
> Can't we just fix this by calling the config_filter() function with the proper settings?
> This function is getting huge by now, so we could try to reduce it a bit.

Yep, it should be doable to do this by calling config_filter.

> 
>> @@ -1214,38 +1243,61 @@ int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
>>  	rt2x00_set_field32(&reg, MAX_LEN_CFG_MIN_MPDU, 0);
>>  	rt2800_register_write(rt2x00dev, MAX_LEN_CFG, reg);
>>  
>> +	rt2800_register_read(rt2x00dev, LED_CFG, &reg);
>> +	rt2x00_set_field32(&reg, LED_CFG_ON_PERIOD, 70);
>> +	rt2x00_set_field32(&reg, LED_CFG_OFF_PERIOD, 30);
>> +	rt2x00_set_field32(&reg, LED_CFG_SLOW_BLINK_PERIOD, 3);
>> +	rt2x00_set_field32(&reg, LED_CFG_R_LED_MODE, 3);
>> +	rt2x00_set_field32(&reg, LED_CFG_G_LED_MODE, 3);
>> +	rt2x00_set_field32(&reg, LED_CFG_Y_LED_MODE, 3);
>> +	rt2x00_set_field32(&reg, LED_CFG_LED_POLAR, 1);
>> +	rt2800_register_write(rt2x00dev, LED_CFG, reg);
> 
> Same here.

That's difficult. We have no other function simply manipulating the LED_CFG register.
There is rt2800_blink_set, but that is working completely different.
I'd prefer to leave this as is, instead of introducing another small helper.

> 
>>  	rt2800_register_write(rt2x00dev, PBF_MAX_PCNT, 0x1f3fbf9f);
>>  
>> +	rt2800_register_read(rt2x00dev, TX_RTY_CFG, &reg);
>> +	rt2x00_set_field32(&reg, TX_RTY_CFG_SHORT_RTY_LIMIT, 15);
>> +	rt2x00_set_field32(&reg, TX_RTY_CFG_LONG_RTY_LIMIT, 31);
>> +	rt2x00_set_field32(&reg, TX_RTY_CFG_LONG_RTY_THRE, 2000);
>> +	rt2x00_set_field32(&reg, TX_RTY_CFG_NON_AGG_RTY_MODE, 0);
>> +	rt2x00_set_field32(&reg, TX_RTY_CFG_AGG_RTY_MODE, 0);
>> +	rt2x00_set_field32(&reg, TX_RTY_CFG_TX_AUTO_FB_ENABLE, 1);
>> +	rt2800_register_write(rt2x00dev, TX_RTY_CFG, reg);
> 
> And here.

Same as for LED_CFG. Using rt2800_config_retry_limit would involve setting up a
complete libconf structure. Seems like a bit of overkill for the purpose.

> 
>> +	if (rt2x00_is_pci(rt2x00dev) || rt2x00_is_soc(rt2x00dev))
>> +		rt2x00_set_field32(&reg, MM40_PROT_CFG_PROTECT_CTRL, 1);
>> +	else if (rt2x00_is_usb(rt2x00dev))
>> +		rt2x00_set_field32(&reg, MM40_PROT_CFG_PROTECT_CTRL, 0);
> 
> perhaps:
> 	rt2x00_set_field32(&reg, MM40_PROT_CFG_PROTECT_CTRL, !rt2x00_is_usb(rt2x00dev));

Hmm, could be. Not too fond of that construction though. I think the somewhat more verbose
variant I had is clearer and easier to understand what is going on.

> 
>> @@ -1323,6 +1382,15 @@ int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
>>  	rt2800_register_write(rt2x00dev, TX_RTS_CFG, reg);
>>  
>>  	rt2800_register_write(rt2x00dev, EXP_ACK_TIME, 0x002400ca);
>> +
>> +	rt2800_register_read(rt2x00dev, XIFS_TIME_CFG, &reg);
>> +	rt2x00_set_field32(&reg, XIFS_TIME_CFG_CCKM_SIFS_TIME, 32);
>> +	rt2x00_set_field32(&reg, XIFS_TIME_CFG_OFDM_SIFS_TIME, 32);
>> +	rt2x00_set_field32(&reg, XIFS_TIME_CFG_OFDM_XIFS_TIME, 4);
>> +	rt2x00_set_field32(&reg, XIFS_TIME_CFG_EIFS, 314);
>> +	rt2x00_set_field32(&reg, XIFS_TIME_CFG_BB_RXEND_ENABLE, 1);
>> +	rt2800_register_write(rt2x00dev, XIFS_TIME_CFG, reg);
> 
> Not really fond of the magical values written to the device, while mac80211
> sends us the proper values later. This is probably a register initialization ordering issue?

These magical values come straight from the Ralink vendor driver. As you know that code isn't
the best documented code we've seen, so I don't know what these magical values actually represent.
They are just initialization values for the time until we get associated.

For code clarity in comparison to the Ralink vendor driver I prefer to leave these in.

---
Gertjan
