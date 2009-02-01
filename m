Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:52163 "EHLO ds10.mine.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750794AbZBAFH2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Feb 2009 00:07:28 -0500
Message-ID: <49852E03.7090003@openwrt.org> (sfid-20090201_060744_933140_3EF79646)
Date: Sun, 01 Feb 2009 06:07:15 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Nick Kossifidis <mickflemm@gmail.com>
CC: Bob Copeland <me@bobcopeland.com>, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	jirislaby@gmail.com, mcgrof@gmail.com
Subject: Re: [ath5k-devel] [PATCH 5/5] ath5k: Update reset code
References: <20090131023147.GE3342@makis>	 <20090131170802.GA16826@hash.localnet>	 <40f31dec0901311048t3834612cgc6b1dd01aa42a5c0@mail.gmail.com>	 <20090131223809.GA17413@hash.localnet>	 <40f31dec0901311950q27e28bb8we145c79488b1c7e1@mail.gmail.com>	 <49851F73.4050204@openwrt.org> <40f31dec0901312050t1c8e50b5y2e63a05f8f5f4f89@mail.gmail.com>
In-Reply-To: <40f31dec0901312050t1c8e50b5y2e63a05f8f5f4f89@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Nick Kossifidis wrote:
> 2009/2/1 Felix Fietkau <nbd@openwrt.org>:
>> Nick Kossifidis wrote:
>>> 2009/2/1 Bob Copeland <me@bobcopeland.com>:
>>>> On Sat, Jan 31, 2009 at 08:48:02PM +0200, Nick Kossifidis wrote:
>>>>> > Heh, we should write a little tool to check the shifts and masks :)
>>>>> >
>>>>>
>>>>> Yup :P
>>>>
>>>> I just wrote one, I can post it later :)   It also found:
>>>>
>>>> AR5K_PHY_SIGMA_DELTA_ADC_CLIP 0x01ff3000 13
>>>>
>>>> Should be 12 or a different mask...
>>>>
>>>
>>> 13 is correct
>>>
>>> 0x01ff3000 -> 1111111111110000000000000
>> I think it's    1111111110011000000000000? :)
>>
>> This mask makes 12 seem more likely.
>>
>> - Felix
>>
> 
> Maybe it's in big endian format (we don't know anything about this reg
> anyway :P), both HALs have 13 plus it doesn't make sense to have a
> field split.
Ah, figured it out. It's a typo :)
Here are the settings from Sam's HAL:

#define   AR_PHY_SIGMA_DELTA_ADC_CLIP     0x01FFE000
#define   AR_PHY_SIGMA_DELTA_ADC_CLIP_S   13

Which does make a lot more sense than     0x01FF3000 :)

- Felix
