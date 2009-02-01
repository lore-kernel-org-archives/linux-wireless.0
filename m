Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.30]:53263 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948AbZBAFOb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Feb 2009 00:14:31 -0500
Received: by yw-out-2324.google.com with SMTP id 9so389962ywe.1
        for <linux-wireless@vger.kernel.org>; Sat, 31 Jan 2009 21:14:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <49852E03.7090003@openwrt.org>
References: <20090131023147.GE3342@makis>
	 <20090131170802.GA16826@hash.localnet>
	 <40f31dec0901311048t3834612cgc6b1dd01aa42a5c0@mail.gmail.com>
	 <20090131223809.GA17413@hash.localnet>
	 <40f31dec0901311950q27e28bb8we145c79488b1c7e1@mail.gmail.com>
	 <49851F73.4050204@openwrt.org>
	 <40f31dec0901312050t1c8e50b5y2e63a05f8f5f4f89@mail.gmail.com>
	 <49852E03.7090003@openwrt.org>
Date: Sun, 1 Feb 2009 07:14:30 +0200
Message-ID: <40f31dec0901312114k1b29e6d7o750fa306bfa7b257@mail.gmail.com> (sfid-20090201_061443_022391_340029EC)
Subject: Re: [ath5k-devel] [PATCH 5/5] ath5k: Update reset code
From: Nick Kossifidis <mickflemm@gmail.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: Bob Copeland <me@bobcopeland.com>, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	jirislaby@gmail.com, mcgrof@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/2/1 Felix Fietkau <nbd@openwrt.org>:
> Nick Kossifidis wrote:
>> 2009/2/1 Felix Fietkau <nbd@openwrt.org>:
>>> Nick Kossifidis wrote:
>>>> 2009/2/1 Bob Copeland <me@bobcopeland.com>:
>>>>> On Sat, Jan 31, 2009 at 08:48:02PM +0200, Nick Kossifidis wrote:
>>>>>> > Heh, we should write a little tool to check the shifts and masks :)
>>>>>> >
>>>>>>
>>>>>> Yup :P
>>>>>
>>>>> I just wrote one, I can post it later :)   It also found:
>>>>>
>>>>> AR5K_PHY_SIGMA_DELTA_ADC_CLIP 0x01ff3000 13
>>>>>
>>>>> Should be 12 or a different mask...
>>>>>
>>>>
>>>> 13 is correct
>>>>
>>>> 0x01ff3000 -> 1111111111110000000000000
>>> I think it's    1111111110011000000000000? :)
>>>
>>> This mask makes 12 seem more likely.
>>>
>>> - Felix
>>>
>>
>> Maybe it's in big endian format (we don't know anything about this reg
>> anyway :P), both HALs have 13 plus it doesn't make sense to have a
>> field split.
> Ah, figured it out. It's a typo :)
> Here are the settings from Sam's HAL:
>
> #define   AR_PHY_SIGMA_DELTA_ADC_CLIP     0x01FFE000
> #define   AR_PHY_SIGMA_DELTA_ADC_CLIP_S   13
>
> Which does make a lot more sense than     0x01FF3000 :)
>
> - Felix
>

/me has to get a new pair of glasses :P


-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
