Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f221.google.com ([209.85.220.221]:58945 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759681AbZKLAC6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Nov 2009 19:02:58 -0500
Received: by fxm21 with SMTP id 21so1657677fxm.21
        for <linux-wireless@vger.kernel.org>; Wed, 11 Nov 2009 16:03:02 -0800 (PST)
Message-ID: <4AFB50B4.10508@gmail.com>
Date: Thu, 12 Nov 2009 01:03:00 +0100
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org,
	Ivo van Doorn <IvDoorn@gmail.com>,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [PATCH] rt2x00: Fix rt2800lib RF chip programming selection.
References: <1257803998-5412-1-git-send-email-gwingerde@gmail.com> <20091111220755.GN4392@tuxdriver.com> <4AFB4732.8090801@gmail.com> <20091111233541.GO4392@tuxdriver.com>
In-Reply-To: <20091111233541.GO4392@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/12/09 00:35, John W. Linville wrote:
> On Thu, Nov 12, 2009 at 12:22:26AM +0100, Gertjan van Wingerde wrote:
>> On 11/11/09 23:07, John W. Linville wrote:
>>> On Mon, Nov 09, 2009 at 10:59:58PM +0100, Gertjan van Wingerde wrote:
>>>> Mirror the legacy Ralink driver with respect to rt2800 RF register programming. Execute
>>>> rt2800_config_channel_rt3x for all RF2020, RF3020, RF3021 & RF3022 chipsets when operating on RT3070
>>>> devices.
>>>>
>>>> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
>>>> ---
>>>>  drivers/net/wireless/rt2x00/rt2800lib.c |   10 +++++++---
>>>>  1 files changed, 7 insertions(+), 3 deletions(-)
>>>>
>>>> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
>>>> index 2c91c44..446087e 100644
>>>> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
>>>> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
>>>> @@ -806,10 +806,14 @@ static void rt2800_config_channel(struct rt2x00_dev *rt2x00dev,
>>>>  	unsigned int tx_pin;
>>>>  	u8 bbp;
>>>>  
>>>> -	if (rt2x00_rev(&rt2x00dev->chip) != RT3070_VERSION)
>>>> -		rt2800_config_channel_rt2x(rt2x00dev, conf, rf, info);
>>>> -	else
>>>> +	if (rt2x00_rt(&rt2x00dev->chip, RT3070) &&	
>>>> +           (rt2x00_rf(&rt2x00dev->chip, RF2020) ||
>>>> +	     rt2x00_rf(&rt2x00dev->chip, RF3020) ||
>>>> +	     rt2x00_rf(&rt2x00dev->chip, RF3021) ||
>>>> +	     rt2x00_rf(&rt2x00dev->chip, RF3022)))
>>>>  		rt2800_config_channel_rt3x(rt2x00dev, conf, rf, info);
>>>> +	else
>>>> +		rt2800_config_channel_rt2x(rt2x00dev, conf, rf, info);
>>>>  
>>>>  	/*
>>>>  	 * Change BBP settings
>>>
>>>   CC [M]  drivers/net/wireless/rt2x00/rt2800lib.o
>>> drivers/net/wireless/rt2x00/rt2800lib.c: In function ‘rt2800_config_channel’:
>>> drivers/net/wireless/rt2x00/rt2800lib.c:809: error: ‘RF3070’ undeclared (first use in this function)
>>> drivers/net/wireless/rt2x00/rt2800lib.c:809: error: (Each undeclared identifier is reported only once
>>> drivers/net/wireless/rt2x00/rt2800lib.c:809: error: for each function it appears in.)
>>>
>>
>> Me very confused here. This patch doesn't even introduce the RF3070 symbol, nor can I see where it is used.
>> It does use symbol RT3070 on line 809, but that one is introduced in an earlier patch.
>> Ah, did you apply the RT3070 USB chipset detection patch before this one?
>>
>> Still wouldn't explain the compile error on symbol RF3070 though.
> 
> RF3070 is a copy-n-paste error, sorry...the symbol is RT3070.
> 
> What patch introduces it?
> 

The one I sent with subject: [PATCH v2] rt2x00: Properly detect Ralink RT3070 devices.

It can be found at:

http://marc.info/?l=linux-wireless&m=125788935007988&w=2

Sorry for not making these patch dependencies clear.

---
Gertjan.
