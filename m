Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCD6938A722
	for <linux-wireless@vger.kernel.org>; Wed,  5 Aug 2026 15:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785943250; cv=none; b=fxaclp1uBdiPzUbshC3B+QgfVJEChYIf7xZnE+2/IxAaH2Rua7yGeLxsQvvdrUBwsoy7e44rCsl0inQ2LUpkVuviB3joVmmgWb02gwXLoaaLBgih0yYCI9Jdz/Tq1JKRuzZfJeZvWwq5L5c0se51yVJyNzDBrnIEJ8C6kQfc4OE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785943250; c=relaxed/simple;
	bh=pOsm6FrgunrEy4xg3MPZYoossqKIYDfdKu6pzcmAxos=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bAR0n0/ItVWOU95+52JSvK2Hf05jtZK/g+rsECp2PGjGdskmPQl1HkvFjR9HtglBMfd4TX6wex3bBLKr28Kuhj8zC1tbdw2T1yzwiTDfWyySwTK5yjuOIVzURpn0jakDpevOezy9veJ+FXAWfeH/N2cxlSStYIwc5O2d2Kh6+A4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=D19LSXRi; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="D19LSXRi"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c1712a04ddaso189189466b.2
        for <linux-wireless@vger.kernel.org>; Wed, 05 Aug 2026 08:20:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785943247; x=1786548047; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=v9epO7gQb+z39xQJcQzm+4bGloNLtTUWyXFpKMh1ihQ=;
        b=D19LSXRiGyVozi6GbgWJYbekjASR+eZww+KbfIimimQwHx4h/y9/oG/nP7csmpbpT8
         HkZi19zWxL2QLa+IfqhcqJbQPkDHm5ex4joiOZAXKh/0hjvDclaQMaP1XLWHQw23Xx7z
         9CvHurB4i2O6GnaTsFmMX7Bzx5+49+SF1vs/zGMH7Y3hb2VFtBX5KbTIn/3JvGgNU5BL
         h+BAoVFZkNunpaim8njVSj0BNjUmXAgN71QpC7cWYrWSUZFRCL9NLbivYTF+NuKCuEEn
         dTBNEBi4JU96B0Rd3DphMuMKvD8Kp4jdO+YXLOzetcUpz61aqM2aRYMKizKKPJHBpwOF
         x1gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785943247; x=1786548047;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=v9epO7gQb+z39xQJcQzm+4bGloNLtTUWyXFpKMh1ihQ=;
        b=WQQ0oeDuVxfPJ8Wvu53so703Y3b5+IsrpCUZenYZvr9aUSt7VlpWFR5sCJrhc8jH3w
         FGZy4ZMzEu64l06fTsfxO4WvyqDlLFecLRFv17MXVBcbDuRdzSHvZcI5xS52xIn1VivQ
         x/MlMzSxoYz8N0NdcLbvRUAag+iTan3CHBfNQBdjBsdyCMUVbSOOyIR9nE3nnvl2SFdD
         z9UoYcax26yaFhPtvzCP2s5zPQhpC00kX/kpAJJC3jLPL8/b6AVWCNhE3SoGrGXArXdp
         knwTVQlIOQOolBd0FNLDBm9luZjzNcDU7D3vq/TrTYzAyNuzuNuVSMWnhoKt7/gUlwRs
         OJmw==
X-Forwarded-Encrypted: i=1; AHgh+Rpwz4sMvYwN1NOY46HW/LDLIya1aAEVDY/4iClWs/il7p0qF1V5bXjBdhQz+YRgqemlFZPraTmIPXYDmpkaGg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz1YvjP0N7UN+R/C90oHGuZXndG4o6p/uafyhiM7oHInb/x6YZ7
	ifvWrmHVuwum7Tqh0hNi7CG++7E5LKuBNbT3USSRtcvolL1Bx6L+5scH
X-Gm-Gg: AR+sD12kmAYHtxCxVcACNyQ8MG8FInHVkB+LNpi4Mr82Q2TITrIOpb5+A2Fl2F9E3jn
	oT1lJP6/EhhkleZukZy2tHOadhPxj9+Hu6xH0qR6qXN9G6yFG/CGCHm1/o0m3LJNI0cay33Ttab
	HC3hMZ8MQECrOZDklOd1ZmyXrRGxjWWNyjt1uMZl7TQw8WXQdJRThyd1q2hlOpSiSfO8llRchnu
	oa06E16aX/sAUIiJFNDIVcUlEzp24DDQdVsm9vJpRH3Vloz+jf371q6REHIOlFxLH8EDmNeF683
	SjLqQIiLtI3tyD77DxTo0oB7OR8JQYmJQGtS32C64MvLsDycngJZUhE7Fq/AuI8Wr6lY58UzdiV
	qVbucUe+c/xDx/NhAFWqAblgcGox4s92TVlZuN14IdJRIl4DTejWjbcMmoQTCYwK7aRhH+V3o8W
	+28S75W3GkUQUmCvEiqlk5F0QBVkmmokAsTaPJYLRpbHW5cqqB3q2uOBEIx25GVG2/cg==
X-Received: by 2002:a17:907:ea8c:b0:bf0:b39:dcc8 with SMTP id a640c23a62f3a-c2039cc30d5mr394300766b.26.1785943246679;
        Wed, 05 Aug 2026 08:20:46 -0700 (PDT)
Received: from [192.168.68.75] ([95.46.73.2])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c20363e72eesm139084466b.40.2026.08.05.08.20.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Aug 2026 08:20:46 -0700 (PDT)
Message-ID: <568e2b4c-435b-4258-9137-8c22ba5af427@gmail.com>
Date: Wed, 5 Aug 2026 18:20:45 +0300
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH wireless-next v2] wifi: brcmfmac: Add support for BCM4361
 PCIe chipset
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
 linux-wireless@vger.kernel.org, brcm80211@lists.linux.dev,
 brcm80211-dev-list.pdl@broadcom.com, linux-kernel@vger.kernel.org
References: <20260804-broadcom-staging-v2-1-cebdc69e938c@gmail.com>
 <2dc55d93-544f-47ec-b349-c206f5414f22@broadcom.com>
 <15ce55e2-c4cc-4579-811f-4c13e19bc6e5@gmail.com>
 <2ca5662a-4946-4b38-bd1d-adc27f86aa16@broadcom.com>
Content-Language: en-US
From: Markuss Broks <markuss.broks@gmail.com>
In-Reply-To: <2ca5662a-4946-4b38-bd1d-adc27f86aa16@broadcom.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Arend,

On 8/5/26 6:16 PM, Arend van Spriel wrote:
> On 05/08/2026 15:56, Markuss Broks wrote:
>> Hi Arend,
>>
>> On 8/5/26 8:46 AM, Arend van Spriel wrote:
>>> On 04/08/2026 16:07, Markuss Broks via B4 Relay wrote:
>>>> From: Markuss Broks <markuss.broks@gmail.com>
>>>>
>>>> Those are the required changes for the BCM4361 PCIe chipset support.
>>>
>>> Hi Markuss,
>>>
>>> That is a brief commit message. Maybe you can provide a bit of 
>>> context for this patch answering these questions: Are you using this 
>>> device in some project? What platform are you using (if any)? What 
>>> works and what does not?
>> I was just looking at similar device additions in brcmfmac, and 
>> noticed they didn't have much of a description, so I decided not to 
>> add much either. Should I add some general info about the BCM4361 
>> into the commit message?
>>
>> BCM4361 is used on the Samsung Galaxy S9 device (samsung-starlte), 
>> based on Exynos9810. There it's connected via PCIe link. Not sure if 
>> perhaps there's SDIO or USB or other variants of this chipset. 
>> Everything "basic" seems to work, seems to connect to both 2.4GHz and 
>> 5GHz networks, download speed looks good. Haven't tried station mode, 
>> but I'm not sure what's the proper way to set it up anyway.
>
> Mentioning the platform you tested these patches on is sufficient. So 
> when you say "connect to both 2.4GHz and 5GHz networks" I somehow 
> suspect you already covered station mode.
Okay, sure. I guess I kinda mixed up the terminology here, I meant to 
say that I haven't tested the AP mode, not the station mode, sorry for 
the confusion.
>  >>
>>>> Signed-off-by: Markuss Broks <markuss.broks@gmail.com>
>>>> ---
>>>> Changes in v2:
>>>> - EDITME: describe what is new in this series revision.
>>>> - EDITME: use bulletpoints and terse descriptions.
>>>
>>> This really does not look very useful. Those EDITME: are for you! As 
>>> the
>>> actual patch did not change you can probably say:
>>>   - fix subject format indicating wifi subsystem and wireless-next 
>>> repo.
>>
>> Oh, sorry, I did not notice that b4 puts the changelog there if it's 
>> not in the cover letter. It's been a while since I last submitted 
>> something :) I will add the changelog there for v2 and v3 once I 
>> submit a v3.
>
> Sure. No problem.
>
>>>
>>>> - Link to v1: https://patch.msgid.link/20260803-broadcom-staging- 
>>>> v1-1-f6f77e55b72e@gmail.com
>>>> ---
>>>> drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c       | 3 +++
>>>> drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c       | 3 +++
>>>> drivers/net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h | 2 ++
>>>> 3 files changed, 8 insertions(+)
>>>
>>> [...]
>>>
>>>> diff --git 
>>>> a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c 
>>>> b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
>>>> index 55f4d7b970f2..914ae72a7b74 100644
>>>> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
>>>> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
>>>> @@ -59,6 +59,7 @@ BRCMF_FW_CLM_DEF(43570, "brcmfmac43570-pcie");
>>>> BRCMF_FW_DEF(4358, "brcmfmac4358-pcie");
>>>> BRCMF_FW_DEF(4359, "brcmfmac4359-pcie");
>>>> BRCMF_FW_DEF(4359C, "brcmfmac4359c-pcie");
>>>> +BRCMF_FW_CLM_DEF(4361, "brcmfmac4361-pcie");
>>>
>>> Are you sure the CLM blob is required? Can you test without it being 
>>> present in /lib/firmware?
>> I have tried without the CLM blob, it says "no clm blob available, 
>> device might have limited channels available" but seems to at least 
>> somewhat work, I haven't noticed a difference. It's still a good idea 
>> to load it probably, right?
>
> Right. I was just curious whether it has a working CLM blob compiled 
> in firmware or not.
>
>>>
>>>> BRCMF_FW_CLM_DEF(4364B2, "brcmfmac4364b2-pcie");
>>>> BRCMF_FW_CLM_DEF(4364B3, "brcmfmac4364b3-pcie");
>>>> BRCMF_FW_DEF(4365B, "brcmfmac4365b-pcie");
>>>
>>> [...]
>>>
>>>> diff --git a/drivers/net/wireless/broadcom/brcm80211/include/ 
>>>> brcm_hw_ids.h b/drivers/net/wireless/broadcom/brcm80211/include/ 
>>>> brcm_hw_ids.h
>>>> index df3b67ba4db2..b800cbfdece1 100644
>>>> --- a/drivers/net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h
>>>> +++ b/drivers/net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h
>>>
>>> [...]
>>>
>>>> @@ -86,6 +87,7 @@
>>>> #define BRCM_PCIE_43602_2G_DEVICE_ID 0x43bb
>>>> #define BRCM_PCIE_43602_5G_DEVICE_ID 0x43bc
>>>> #define BRCM_PCIE_43602_RAW_DEVICE_ID 43602
>>>> +#define BRCM_PCIE_4361_DEVICE_ID 0x441f
>>>
>>> Please add:
>>> +#define BRCM_PCIE_4361_2G_DEVICE_ID 0x4420
>>> +#define BRCM_PCIE_4361_5G_DEVICE_ID 0x4421
>>
>> Are those some special variants of the chipset?
>
> Not really. The difference is in the radio frontend. 0x441f is a 
> dual-band. The other two have only a single band so the board gets a 
> bit cheaper. The device id is programmed in on-chip OTP so firmware 
> knows what type of board it is running on.
Okay, I see, thanks for the explanation!
>
> Regards,
> Arend

-Markuss

