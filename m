Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793307989;
	b=nYwfR4OTA/vzN/CADMNLLlBXBJsDIKdQ9C5pgbpd8lSRo1/bu7BDrzcfkwkkV/npKcI2
	 7Ejsz7DuLPHwZvkyvVCnHDZKNTWPCeUANUgPB5NSSKWXOtuAY+Pwnyz19bKFGh+0rjRRr
	 nXNG/o0qp/iqL6qVQf2R73JVrMkQyFyECnFkGTVx51A4umyrlT82Lv83Wi8YWYhYeIj8U
	 CI8q8q/n8/2bEeSzDQsMrxPVutyybeIg8l8tUoxhTCN7ZW+hhe6TDqaXERVPfzNnZFcTO
	 OxG7IaRWIauGMA1oDw4Wd4XI7mU+3UTxb9QVVcrB1mREXnoe1vEEXEVbAVIzUmNCAgw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793307989;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=pje08CmZc9P5C0SfAaGfTaTOwlE9I2uMu9N8DOOWPDU=;
	b=eD6Q6pGrRJOppK9ZQRAhzyb7InHhC1BzWBCsqgwjTFd2Ku36p43QjWjF5dJHISEz/DFg
	 IGx/b7UVjol2Nj1yP8IJAkVYu1PUkruaA9gD+HWUGybluGHJBWTCebttHnUXSmp8CvmRJ
	 NAzAHa89X/bA3Vm+LSddn09/4AFF2rFAm5z0AFvWRYnKAztEv0FXFFh60v79RBdgDER4d
	 EZFnhp+ie0ajXlcsEYorfaAOAM6pSC39Fp3GEtASVmqIRUgtS52walgBKhdzbE0iNGaW9
	 J0Qe9d2AJn1QdPPRbQ9lEU2RJNwaZemD/uB+8aNn7UQIdiZzO8nA86CvYxDtZhWQbrw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=lM6mnFGp;
	arc=none smtp.remote-ip=209.85.128.49
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52D35606A31A
	for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2026 21:06:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 52D35606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=lM6mnFGp
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4a208d93758so23925e9.3
        for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2026 14:06:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793307988; x=1793912788; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pje08CmZc9P5C0SfAaGfTaTOwlE9I2uMu9N8DOOWPDU=;
        b=lM6mnFGplgnyst1dRqLil2diqd30DDuzkMC5q2+9WrvXPJ+NgBTPByC3O8TlG+sVo1
         GmjU5R3edirEXQm5USWgUthnelc2Xjzc7aNpCmnDuG6sZjCloKi+j8IUfyr/wyd7McKH
         TEjX2BMBZ5qYqLUudMamZ4nDgg2LlnJxyzKcRjXYiexbo0S3D52RrNJxv4A87IYgbctG
         N501cUdqehdJJHVk5hXrA7wzWcNm9Z1JzrdDDFR+v89v9S25jarV++HH416PHeMKKs9t
         7r0YFQc/A+uQfqHnBzVyl7VQVgxcMCyARiSKnvGqQVxJchpTcLmlDHCxHOPlxnHuXEYb
         S5WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793307988; x=1793912788;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pje08CmZc9P5C0SfAaGfTaTOwlE9I2uMu9N8DOOWPDU=;
        b=25oDlQ3aVTsCQS12H84lrQfH/GUAPUkzM5IXYYCuG8NZdIESv1ErAYRA5lkhWboJiN
         Q/EUzprnG2PEQPeG8FBw8bfzcvJhZAZ1HCPLl1fWIR7LC6ei5VzuBD6hiOmunzV1Fzq7
         cupKjRhNVkTyw/+8Casv3bONUw7F2WDcL4G0RlfYPy6/iUNuewqGs6K92RuETcrjdUw8
         YdFyDIbxMewabnoTSvth8lxS2KcvcUeQI15Vqf7X5z+h+jO9pm5ygdHAHhYOaTnerd0c
         ybPkXKVYvJrRYltputmhQTi6htlovuA/3lKFkfEgfLAMF04v618q3owO4TB06LuRMSRu
         s1Xw==
X-Forwarded-Encrypted: i=1; AKwUvBx4Yx5HcH9OhIng8hbOZPq5z+Zn4Hw1y0rfd8+zuqredwSSajxQOiSqQI59wAjFwyD42qk4ud9AfWONQbxMPQ==@vger.kernel.org
X-Gm-Message-State: AFq9FYLdnxxz/5HmTbgTrM1EVi+pxwfA+hvBwIB/esFakzqDTEUKdYiM
	VMpblh8sJiIj/AmXKPA6REQwxXY+Sg+VbooLosLHxi4V5y8HtL0gxK0W
X-Gm-Gg: AYBFou0OmY5/7ElNHykgJflX57TP/d5JtT9Qehxu14S7IyYQhYaFpj2rmLvA7ziZ6l2
	lbY+IacxPoaPdkjcS0LDU4KScvqjPKCBylj6mp8EYpeLGfT4biiFmeg9ITq/Yw0rMW85hKenDFs
	vYJR1OhWyAn9SbjeUOpArEa2sgRnSU47hBY9FGMkN75As3QykqOoeYOVEkhmEWJTb1AabII9QQp
	4L+wj6eGYJTnJZjgOsSvr1+EwGaN/2FZ/DhALRf8JhH2liDqySSvHhCqE/N02AHVk2+PXIc6of+
	IisA67xNGadVTOaDY9xv17bpcjnPw0P+wXpHbsF8+tCLs5+uAgs4ZI3HYiBJ6ygKMqhfWMjPVko
	TTD7t3t2DbtyGzLXN5+jRg9yBcUO9LfOPaC+7AZV3LB6XyQA2HVMU35pI0DCJFxpAj0lFBx8dQ8
	SitOzs2YC/j8WqIpuZ3BjoDDuS2oNuv6ALilbWqAM9DfiTwjmwrJdKcD3ktzuU2re+ocL2BAXip
	j3Dqxl0aKSFR+/c3t3AJQ9I4FXpVv8Aly42mk/4MhH1UwgswzN+7MtH2EYKNKk6/pIS4WemJV4s
	+fiD0hz025lcZqInduua25x+zch2Qd9H2yrUhSAk+cXPqYLMeXUD8Fj05Q==
X-Received: by 2002:a05:600c:840e:b0:4a1:813f:2a60 with SMTP id 5b1f17b1804b1-4ac17d168b1mr4023675e9.11.1793307987542;
        Thu, 29 Oct 2026 14:06:27 -0700 (PDT)
Received: from [192.168.1.50] ([81.196.40.70])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4abf5b27e46sm16875975e9.3.2026.10.29.14.06.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Oct 2026 14:06:27 -0700 (PDT)
Message-ID: <8b058551-e608-4f8b-b3a5-2ee9f17bfa29@gmail.com>
Date: Thu, 29 Oct 2026 23:06:26 +0200
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/6] wifi: rtw88: 88xxa: receive VHT SU beamformed
 transmissions
To: Ho Jie Feng <hjf3108@gmail.com>, linux-wireless@vger.kernel.org
Cc: Ping-Ke Shih <pkshih@realtek.com>
References: <20261029055212.84711-1-hjf3108@gmail.com>
 <20261029055212.84711-3-hjf3108@gmail.com>
 <a437b090-8285-4fda-b695-da4b66c8f365@gmail.com>
 <20261029141357.152345-1-hjf3108@gmail.com>
Content-Language: en-US
From: Bitterblue Smith <rtl8821cerfe2@gmail.com>
In-Reply-To: <20261029141357.152345-1-hjf3108@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 29/10/2026 16:13, Ho Jie Feng wrote:
> On 29/10/2026 14:33, Bitterblue Smith wrote:
>> On 29/10/2026 07:52, Ho Jie Feng wrote:
>>> Implement beamformee support for 88xxa since they have
>>> support for it.
>>>
>>> Signed-off-by: Ho Jie Feng <hjf3108@gmail.com>
>>> ---
>>>  drivers/net/wireless/realtek/rtw88/bf.h       |  2 +
>>>  drivers/net/wireless/realtek/rtw88/main.c     | 12 ++--
>>>  drivers/net/wireless/realtek/rtw88/reg.h      |  1 +
>>>  drivers/net/wireless/realtek/rtw88/rtw8812a.c |  3 +-
>>>  drivers/net/wireless/realtek/rtw88/rtw8814a.c | 36 ++++++++++-
>>>  drivers/net/wireless/realtek/rtw88/rtw8821a.c |  3 +-
>>>  drivers/net/wireless/realtek/rtw88/rtw88xxa.c | 62 +++++++++++++++++++
>>>  drivers/net/wireless/realtek/rtw88/rtw88xxa.h |  2 +
>>>  8 files changed, 112 insertions(+), 9 deletions(-)
>>>
>>
>> Is it really this simple? The vendor driver has a lot more
>> beamforming code than this.
> 
> Yes, this is the beamformee code, not the beamformer,
> which has way more code than this. The RTL8812AU is acting as
> the target for the AP to beamform to for this one.
> 

Oh, I see. I didn't look very closely at the vendor code.

> I have the beamformer code, which the RTL8812AU
> beamforms, but I dropped it since it reduces throughput.
> 
> I can put the patch out if you wish to see it, but
> won't be enabling for 88xxa.
> 
> Reference:
> https://github.com/aircrack-ng/rtl8812au/blob/v5.6.4.2/hal/phydm/txbf/haltxbfjaguar.c#L229
> 

By the way, there is a newer version:
https://github.com/morrownr/8812au-20210820

I don't know if there are any differences in the beamforming code.

> Vendor driver and rtw88 can be sometimes confusing for
> the bfee vs bfer distinction.
> 
>>> ...
>>>  	if (rtwdev->hal.rf_path_num > 1)
>>>  		vht_cap->cap |= IEEE80211_VHT_CAP_TXSTBC;
>>> -	vht_cap->cap |= IEEE80211_VHT_CAP_MU_BEAMFORMEE_CAPABLE |
>>> -			IEEE80211_VHT_CAP_SU_BEAMFORMEE_CAPABLE;
>>> -	vht_cap->cap |= (rtwdev->hal.bfee_sts_cap <<
>>> -			IEEE80211_VHT_CAP_BEAMFORMEE_STS_SHIFT);
>>> +	if (rtw_bf_support && chip->bfer_su_max_num) {
>>> +		vht_cap->cap |= IEEE80211_VHT_CAP_SU_BEAMFORMEE_CAPABLE;
>>> +		vht_cap->cap |= rtwdev->hal.bfee_sts_cap <<
>>> +				IEEE80211_VHT_CAP_BEAMFORMEE_STS_SHIFT;
>>> +	}
>>> +	if (rtw_bf_support && chip->bfer_mu_max_num)
>>> +		vht_cap->cap |= IEEE80211_VHT_CAP_MU_BEAMFORMEE_CAPABLE;
>>>  
>>>  	if (rtw_chip_has_rx_ldpc(rtwdev))
>>>  		vht_cap->cap |= IEEE80211_VHT_CAP_RXLDPC;
>>
>> This could be a separate patch, since it doesn't look related to 88xxa.
> 
> I can put this in v2.
> 
>>> ...

