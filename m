Received: from mail-pj1-f98.google.com (mail-pj1-f98.google.com [209.85.216.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 387EF78F2F
	for <linux-wireless@vger.kernel.org>; Wed,  5 Aug 2026 15:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785942998; cv=none; b=LpUgdk5oVRKluMI5Asmpf93xvr+YS/8eMnBFOs+I/g+OeCqre2cY+Ai1vJAvpHnMWY3uBPxBDeA7up80w0NV3m25a77LFUcezzr4GCjdRr8fndXTCsHnkmaJXGwT7wpjelSXsyXOBrtvbq/9scX52KOnxOUqp7AcpU3ZjB5FJFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785942998; c=relaxed/simple;
	bh=Zm5dvm6C/uBIvS3P/ulTagzCr2lXpSwhgEkQHY5C7/c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JQxsxrm7oenYOmoKhtT1iBfWkRbu0tZLR9hzdr8NPHT/40dYALGnQD/3p3EnF6ta07DkOlxuSf4L4yuaykv8kdDjJV9QbTJPJnAugTHE7QnCzgQBjiYWbJuBRfxTFC0EGq3jytqGL/7Sxw7AXqZqNM62UDjM30sHwALolWJtGxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=Zp+HFGGL; arc=none smtp.client-ip=209.85.216.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Zp+HFGGL"
Received: by mail-pj1-f98.google.com with SMTP id 98e67ed59e1d1-38f620399a0so998101a91.2
        for <linux-wireless@vger.kernel.org>; Wed, 05 Aug 2026 08:16:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785942996; x=1786547796;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:dkim-signature:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=JJ1jC68Ns2mHBB9nXhjFPTzovfe3N8pJMz4GD5FJ1vo=;
        b=NiS7ccQsWtiLGFl0pDPJc3jrcpUaxtlH3sGxippc10Z3fgyux0jvrz81HTFTshuYl+
         26S7EYod5J8oL5pev+b6TbzipYxNgCmlq46g030ZVoAhrG4QFn6wzPn/G8sUA19GZbSH
         9I4d9gkuzHEkVBTVffxP6bhwrFIoJNQcuQ8nbGqPG8UHgsAy0S6PQkhmJUfhKI9011jm
         SGXf4oyDKbX5kX6EekF1qTxsM9sro5/p8tZzsBJXCzjD0YR3WrhSacczSQDRQtU7sK2L
         ajil2oK466lSMwyMoQhhIp1HkeYQtvie5AOYm1r3tbK+hAiUojYearN/mIFxk7204jm8
         /RSA==
X-Forwarded-Encrypted: i=1; AHgh+RrZc1oWQEJx/3x+xKCIP168MokobKphqqwoV5qXXF4ZL4OUXTonr2PSeP8zcTpTwn9Xpt+R1kGg9pDEgon3QA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzWoGGBexmO9/7uLZyfegRO8smazXpzCnK/t2R4bYhO0q19Xg8t
	9BxUH0XWC1HbGJQxRA9SGCkR0uvrnL0dhErHBVX+3bRQfid8b8x69OGm/6v8nxn9C6HLkpLIBBA
	QPIL7yvbtgKOpnsXEgtTTXcuCwVniVO9WKhV7mUSV8ZJCjB75xiXOW7/ix/Ps6M2ZNIRAnwG0Jc
	jTxYQya5HiAROvEa2kAnq6VnqZdrY6ENA3L0Ut/Ypo5pLbAYqQzpZFwrHHaE3kfMSn1pzKtWy5C
	BJ68q6BuuQ5mbqKud2bVacaUsqq
X-Gm-Gg: AR+sD13v5XqV92nhiS89cGNNF2DgGW+s0Up12OQA+7i40VIOCLgLWnrTxhOnWJ0LJ4g
	gj/64y3pVx117lBmHW8ZiSF215u3x7qzJ1bdfjW9S7aRYsXrrUFLpRLMHi6K6xS0m8eA7VSBYT0
	cfY60bCPvDIDiJc7vSGru9v484CHjJrMuTfoJmy8QGtcgf6ia8nn8MPFE7W2ZmRf+lA18QwKqvN
	qZDIp5LjZChBuftmJoUrJ0T0/R5cCJ1ePG1dFGOsZinoD/hrqDWZ+JXeuENxsOja0KzbWyhzO0J
	I5vOA8JMhB22/sW6m7BWuZXUyFZFeGW6jCne5vx+JMIteIdLZjN0lBDCd6ymo0n9a1M+nt6iygX
	xOObHSdf+Tmyfe/MNRsMrK9i8zRWCIOim4LkYJJhBrXiM0lMGPtGy8zraIwMw3usK8u05RuE8xY
	a3OJFl4o9W5kM6tLkcqovYmCttnLUjsNpR26lL0RQ=
X-Received: by 2002:a17:90a:da83:b0:38e:500:3975 with SMTP id 98e67ed59e1d1-3903c5d82a3mr7248044a91.18.1785942996251;
        Wed, 05 Aug 2026 08:16:36 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-22.dlp.protect.broadcom.com. [144.49.247.22])
        by smtp-relay.gmail.com with ESMTPS id a92af1059eb24-13fca7d3aefsm715926c88.6.2026.08.05.08.16.35
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 05 Aug 2026 08:16:36 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-c1c232fa136so192130666b.0
        for <linux-wireless@vger.kernel.org>; Wed, 05 Aug 2026 08:16:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1785942994; x=1786547794; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JJ1jC68Ns2mHBB9nXhjFPTzovfe3N8pJMz4GD5FJ1vo=;
        b=Zp+HFGGL7IeCEfQkQq6zro2nsfV32WxWTSsE9Ni0AtzQqIdH674v1ic7M0WRSzuHeg
         YpG5Mx+8x9ERt9qOEkv3sSz3n5WCfZR1rdG2n650xir2LuJHCppZWPfiJWxNPKWrAtA5
         oTgdFKR3a8sSkGNxLA2drA9pOr97+pm4WpM0c=
X-Forwarded-Encrypted: i=1; AHgh+RqpqQ552yeEL46n6C/GBv+xu7dg8nWs/tFFRaObWve1wcsw/2QUrjQeff1U1LngnAi+IUGZuaw2ukHjBUFmZA==@vger.kernel.org
X-Received: by 2002:a17:907:9410:b0:c12:525b:4e7d with SMTP id a640c23a62f3a-c203856aaf6mr433649766b.15.1785942993775;
        Wed, 05 Aug 2026 08:16:33 -0700 (PDT)
X-Received: by 2002:a17:907:9410:b0:c12:525b:4e7d with SMTP id a640c23a62f3a-c203856aaf6mr433642666b.15.1785942993107;
        Wed, 05 Aug 2026 08:16:33 -0700 (PDT)
Received: from [192.168.178.26] (f215227.upc-f.chello.nl. [80.56.215.227])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c20363e7638sm134090366b.30.2026.08.05.08.16.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Aug 2026 08:16:32 -0700 (PDT)
Message-ID: <2ca5662a-4946-4b38-bd1d-adc27f86aa16@broadcom.com>
Date: Wed, 5 Aug 2026 17:16:33 +0200
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH wireless-next v2] wifi: brcmfmac: Add support for BCM4361
 PCIe chipset
To: Markuss Broks <markuss.broks@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
 linux-wireless@vger.kernel.org, brcm80211@lists.linux.dev,
 brcm80211-dev-list.pdl@broadcom.com, linux-kernel@vger.kernel.org
References: <20260804-broadcom-staging-v2-1-cebdc69e938c@gmail.com>
 <2dc55d93-544f-47ec-b349-c206f5414f22@broadcom.com>
 <15ce55e2-c4cc-4579-811f-4c13e19bc6e5@gmail.com>
Content-Language: en-US
From: Arend van Spriel <arend.vanspriel@broadcom.com>
In-Reply-To: <15ce55e2-c4cc-4579-811f-4c13e19bc6e5@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

On 05/08/2026 15:56, Markuss Broks wrote:
> Hi Arend,
> 
> On 8/5/26 8:46 AM, Arend van Spriel wrote:
>> On 04/08/2026 16:07, Markuss Broks via B4 Relay wrote:
>>> From: Markuss Broks <markuss.broks@gmail.com>
>>>
>>> Those are the required changes for the BCM4361 PCIe chipset support.
>>
>> Hi Markuss,
>>
>> That is a brief commit message. Maybe you can provide a bit of context 
>> for this patch answering these questions: Are you using this device in 
>> some project? What platform are you using (if any)? What works and 
>> what does not?
> I was just looking at similar device additions in brcmfmac, and noticed 
> they didn't have much of a description, so I decided not to add much 
> either. Should I add some general info about the BCM4361 into the commit 
> message?
> 
> BCM4361 is used on the Samsung Galaxy S9 device (samsung-starlte), based 
> on Exynos9810. There it's connected via PCIe link. Not sure if perhaps 
> there's SDIO or USB or other variants of this chipset. Everything 
> "basic" seems to work, seems to connect to both 2.4GHz and 5GHz 
> networks, download speed looks good. Haven't tried station mode, but I'm 
> not sure what's the proper way to set it up anyway.

Mentioning the platform you tested these patches on is sufficient. So 
when you say "connect to both 2.4GHz and 5GHz networks" I somehow 
suspect you already covered station mode.
  >>
>>> Signed-off-by: Markuss Broks <markuss.broks@gmail.com>
>>> ---
>>> Changes in v2:
>>> - EDITME: describe what is new in this series revision.
>>> - EDITME: use bulletpoints and terse descriptions.
>>
>> This really does not look very useful. Those EDITME: are for you! As the
>> actual patch did not change you can probably say:
>>   - fix subject format indicating wifi subsystem and wireless-next repo.
> 
> Oh, sorry, I did not notice that b4 puts the changelog there if it's not 
> in the cover letter. It's been a while since I last submitted 
> something :) I will add the changelog there for v2 and v3 once I submit 
> a v3.

Sure. No problem.

>>
>>> - Link to v1: https://patch.msgid.link/20260803-broadcom-staging- 
>>> v1-1-f6f77e55b72e@gmail.com
>>> ---
>>> drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c       | 3 +++
>>> drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c       | 3 +++
>>> drivers/net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h | 2 ++
>>> 3 files changed, 8 insertions(+)
>>
>> [...]
>>
>>> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c 
>>> b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
>>> index 55f4d7b970f2..914ae72a7b74 100644
>>> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
>>> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
>>> @@ -59,6 +59,7 @@ BRCMF_FW_CLM_DEF(43570, "brcmfmac43570-pcie");
>>> BRCMF_FW_DEF(4358, "brcmfmac4358-pcie");
>>> BRCMF_FW_DEF(4359, "brcmfmac4359-pcie");
>>> BRCMF_FW_DEF(4359C, "brcmfmac4359c-pcie");
>>> +BRCMF_FW_CLM_DEF(4361, "brcmfmac4361-pcie");
>>
>> Are you sure the CLM blob is required? Can you test without it being 
>> present in /lib/firmware?
> I have tried without the CLM blob, it says "no clm blob available, 
> device might have limited channels available" but seems to at least 
> somewhat work, I haven't noticed a difference. It's still a good idea to 
> load it probably, right?

Right. I was just curious whether it has a working CLM blob compiled in 
firmware or not.

>>
>>> BRCMF_FW_CLM_DEF(4364B2, "brcmfmac4364b2-pcie");
>>> BRCMF_FW_CLM_DEF(4364B3, "brcmfmac4364b3-pcie");
>>> BRCMF_FW_DEF(4365B, "brcmfmac4365b-pcie");
>>
>> [...]
>>
>>> diff --git a/drivers/net/wireless/broadcom/brcm80211/include/ 
>>> brcm_hw_ids.h b/drivers/net/wireless/broadcom/brcm80211/include/ 
>>> brcm_hw_ids.h
>>> index df3b67ba4db2..b800cbfdece1 100644
>>> --- a/drivers/net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h
>>> +++ b/drivers/net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h
>>
>> [...]
>>
>>> @@ -86,6 +87,7 @@
>>> #define BRCM_PCIE_43602_2G_DEVICE_ID 0x43bb
>>> #define BRCM_PCIE_43602_5G_DEVICE_ID 0x43bc
>>> #define BRCM_PCIE_43602_RAW_DEVICE_ID 43602
>>> +#define BRCM_PCIE_4361_DEVICE_ID 0x441f
>>
>> Please add:
>> +#define BRCM_PCIE_4361_2G_DEVICE_ID 0x4420
>> +#define BRCM_PCIE_4361_5G_DEVICE_ID 0x4421
> 
> Are those some special variants of the chipset?

Not really. The difference is in the radio frontend. 0x441f is a 
dual-band. The other two have only a single band so the board gets a bit 
cheaper. The device id is programmed in on-chip OTP so firmware knows 
what type of board it is running on.

Regards,
Arend
