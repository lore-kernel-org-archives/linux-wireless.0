Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E19B472F76
	for <linux-wireless@vger.kernel.org>; Wed,  5 Aug 2026 13:56:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785938221; cv=none; b=CAAMCyflRBx4VPDePuiz2fWY2AXXHGDBowNOYCgoX6wT9hLV63jOj0zNM3q1krW+caS+ic8CVJyziACkSaEUXQT/dWZdvkc19rnd7cnIgvgEkyI9cr9EGRGqa+2obQ0XimkVtbT9x1aBIJjiqT8Y1M1m6h2YsKvWRxep9I877Bo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785938221; c=relaxed/simple;
	bh=diyEuWZHzf/RCzjjtbeq9XwF5mD+mihbuH8CpbkLkYg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qj3/ssUEGGiHi3I/XHjT2amGE2OQ6JGRstofZ9321Q7ob8dho2p6JtWhnZohQIZ6LL5fmpKPwdntsjYgbPdsmsv5b7cb/WiK1s2IjmBvkJFTFc2RAk+jbq0CWXK9Qw4SLm1FUP3/3BAR2w1CcBMzlE/vWL8o8weBHte4lVkqezM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=B/4U90Cj; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="B/4U90Cj"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-495590dde14so10841185e9.0
        for <linux-wireless@vger.kernel.org>; Wed, 05 Aug 2026 06:56:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785938218; x=1786543018; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rF8eP1OY8L9QuXVHd7iT1kdFN9+aOh7P/1wr7uIkXmw=;
        b=B/4U90CjfvZptma4FljMtbpqX0wqCMuXmZBWOlyZkGut3jIyimv4UiB0+r3WH42z6l
         1uTco/AiuGJg0R3PS1S7RRON74MsS/tkzTpAXkSDTEzgHr8+k+DPzwpyUfQPkHKBQ8DS
         ZLhuDhkLJJYsn90PZvFPdVNMSlQgzsUvE7r23OIAdRmwADgJ7be1sN1o9v2ABvDa3WEU
         UET8talAO60CrZM0QSb+tx7BnWT9iUrADSklyWnb5HiQ+iwNkiitdYz2v9/Ttav1XOZ8
         tf4Dp7BJ0CcQfYAHOxbRtNJDk8nH388XMWxI3e55p8nk7gr//Y+unk8zlKll2uCdTyPo
         x72A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785938218; x=1786543018;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rF8eP1OY8L9QuXVHd7iT1kdFN9+aOh7P/1wr7uIkXmw=;
        b=KD1UG9SYAA2qMHCCGPZENRLvDCh6UswJPapJSR5i8+Dt0GZ0cjHp4E/qacyrXVh7oX
         V88Kkd0dlY7P1p/9b+htIoi58xt09FqLybqHvj18nLi93QUba8KCfsdimS1yrYR6qYMj
         85gPF7Yd/ZOfJckFwp74a494PGcfgpC9D2X+CT8rulmvS8lXY241jOjRs8+Olq2qtF+U
         8xGXY0s0WPRdz9sx01jw2ipGzJkQYW31kE8VW8Re3icz2VOJI+PG82uSFRXHI4rW44Ex
         68DENkfu9jKkc6SrK9ulP72RKHrUy803EX26iOK1ViRRwfR8nWPPjstRS1a6rrnIesfe
         CbhQ==
X-Forwarded-Encrypted: i=1; AHgh+RrPgkhLKJbzA8Z38M/zTaf5ryMwZhiWqfT1lSB0vKaFEq+y0jTkvgB8+jqe1i+lu1ag/VRG6IWSMQTtglE4hQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzgtFEK3KXh+bUrKGi6cqdE9CqLZCUH3BBi5w/KpjrMvGBYusN0
	SVdBIyk0kY4M6Rlx6OZkQO7HLg+5u+SQadtqVXWkv4xAnAc1wEElSZhq
X-Gm-Gg: AR+sD11Q8FvdZbs8x5YLVdlkEjNJMBEEBVZNntLkonbey5h/PZE3/t+BVPVBcKZpz9J
	AkHiQxkfbw/k+0ywRZy9G8iXtR4jTdya++lr1JbyeEGgRKn70xnWpGu3MWrHwCPslUuYK6czYs8
	CZ7ZHol5cRlFKc7pztITGkCb4OO8RlfNzn6PRifphMPWK/ixMa3ALMhTWmxMjHHM5LUhmQQ5eJm
	3MvcrhCagr0Jq35JuNjwBIKA/WVrn+qWlMXwemiCCYHKtN6HRWW/ub6BNXInoLXulINayRqSnmK
	soPXClRbvWhH5ENpcX03CcJNc2bQ31frILxEGgK4zUAsc20R2HqEjfOvlHNuywxUxwLrLdAD/vd
	9p/21mERTQEp6U6gqUfH2S298fWnlULoS1Us+jZ7BHqOwwUk1ugw3bEg05aL0f9/SyTdlENE/Wc
	yFG7/mUhY4DyOJnS1fZmFhIiV5R9hK9hwZbiXcLhkUid+MqA+If08+Cd4/8WPE1jZb1ao=
X-Received: by 2002:a05:600c:1d10:b0:495:7a23:1eee with SMTP id 5b1f17b1804b1-4994e7ba86amr74594335e9.12.1785938217905;
        Wed, 05 Aug 2026 06:56:57 -0700 (PDT)
Received: from [192.168.68.75] ([95.46.73.2])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47febfda11csm8772460f8f.1.2026.08.05.06.56.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Aug 2026 06:56:57 -0700 (PDT)
Message-ID: <15ce55e2-c4cc-4579-811f-4c13e19bc6e5@gmail.com>
Date: Wed, 5 Aug 2026 16:56:56 +0300
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
Content-Language: en-US
From: Markuss Broks <markuss.broks@gmail.com>
In-Reply-To: <2dc55d93-544f-47ec-b349-c206f5414f22@broadcom.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Arend,

On 8/5/26 8:46 AM, Arend van Spriel wrote:
> On 04/08/2026 16:07, Markuss Broks via B4 Relay wrote:
>> From: Markuss Broks <markuss.broks@gmail.com>
>>
>> Those are the required changes for the BCM4361 PCIe chipset support.
>
> Hi Markuss,
>
> That is a brief commit message. Maybe you can provide a bit of context 
> for this patch answering these questions: Are you using this device in 
> some project? What platform are you using (if any)? What works and 
> what does not?
I was just looking at similar device additions in brcmfmac, and noticed 
they didn't have much of a description, so I decided not to add much 
either. Should I add some general info about the BCM4361 into the commit 
message?

BCM4361 is used on the Samsung Galaxy S9 device (samsung-starlte), based 
on Exynos9810. There it's connected via PCIe link. Not sure if perhaps 
there's SDIO or USB or other variants of this chipset. Everything 
"basic" seems to work, seems to connect to both 2.4GHz and 5GHz 
networks, download speed looks good. Haven't tried station mode, but I'm 
not sure what's the proper way to set it up anyway.
>
>> Signed-off-by: Markuss Broks <markuss.broks@gmail.com>
>> ---
>> Changes in v2:
>> - EDITME: describe what is new in this series revision.
>> - EDITME: use bulletpoints and terse descriptions.
>
> This really does not look very useful. Those EDITME: are for you! As the
> actual patch did not change you can probably say:
>   - fix subject format indicating wifi subsystem and wireless-next repo.

Oh, sorry, I did not notice that b4 puts the changelog there if it's not 
in the cover letter. It's been a while since I last submitted something 
:) I will add the changelog there for v2 and v3 once I submit a v3.

>
>> - Link to v1: 
>> https://patch.msgid.link/20260803-broadcom-staging-v1-1-f6f77e55b72e@gmail.com
>> ---
>> drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c       | 3 +++
>> drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c       | 3 +++
>> drivers/net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h | 2 ++
>> 3 files changed, 8 insertions(+)
>
> [...]
>
>> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c 
>> b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
>> index 55f4d7b970f2..914ae72a7b74 100644
>> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
>> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
>> @@ -59,6 +59,7 @@ BRCMF_FW_CLM_DEF(43570, "brcmfmac43570-pcie");
>> BRCMF_FW_DEF(4358, "brcmfmac4358-pcie");
>> BRCMF_FW_DEF(4359, "brcmfmac4359-pcie");
>> BRCMF_FW_DEF(4359C, "brcmfmac4359c-pcie");
>> +BRCMF_FW_CLM_DEF(4361, "brcmfmac4361-pcie");
>
> Are you sure the CLM blob is required? Can you test without it being 
> present in /lib/firmware?
I have tried without the CLM blob, it says "no clm blob available, 
device might have limited channels available" but seems to at least 
somewhat work, I haven't noticed a difference. It's still a good idea to 
load it probably, right?
>
>> BRCMF_FW_CLM_DEF(4364B2, "brcmfmac4364b2-pcie");
>> BRCMF_FW_CLM_DEF(4364B3, "brcmfmac4364b3-pcie");
>> BRCMF_FW_DEF(4365B, "brcmfmac4365b-pcie");
>
> [...]
>
>> diff --git 
>> a/drivers/net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h 
>> b/drivers/net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h
>> index df3b67ba4db2..b800cbfdece1 100644
>> --- a/drivers/net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h
>> +++ b/drivers/net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h
>
> [...]
>
>> @@ -86,6 +87,7 @@
>> #define BRCM_PCIE_43602_2G_DEVICE_ID 0x43bb
>> #define BRCM_PCIE_43602_5G_DEVICE_ID 0x43bc
>> #define BRCM_PCIE_43602_RAW_DEVICE_ID 43602
>> +#define BRCM_PCIE_4361_DEVICE_ID 0x441f
>
> Please add:
> +#define BRCM_PCIE_4361_2G_DEVICE_ID 0x4420
> +#define BRCM_PCIE_4361_5G_DEVICE_ID 0x4421

Are those some special variants of the chipset?

>
> Regards,
> Arend
>
>> #define BRCM_PCIE_4364_DEVICE_ID 0x4464
>> #define BRCM_PCIE_4365_DEVICE_ID 0x43ca
>> #define BRCM_PCIE_4365_2G_DEVICE_ID 0x43cb 

Thanks,

- Markuss

