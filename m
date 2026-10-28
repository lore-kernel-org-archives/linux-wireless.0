Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209302;
	b=g1MOOjQRCE98WUx7KbgYwmJhlAzx2pJfnfK0kOOw9I7wnbHOGp2J+eDtqwh5Yg0BvlLI
	 MFah4TLFyKSgXA+tvjZmqdp5VYqhNwnI1dj4McMHJCSwZp8UtKO23h6wBrOMhNWlsCCf7
	 0fNGzg9ZS79tjczMTkXgueI1lCa108SI4JBflFhfzQI8qgaORGuiyxIhxdmeU/GZryEyS
	 LQ8wCaH+euYSv8+cH7DTShblUMhJbfq3Yhi5W1I1RZCGInsn6pCsmohB40fJ1JZJXr0+w
	 jSeYLuSuJvAJ2Ew/0Fz76+L24F38R4l1hQGeapl9HcUfosbLyjVTYVXvOcmJtd2JXqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209302;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=x/l/zKeelwRJBhxZfMNH6sAqhzKzVG26GZyZjVVGRF0=;
	b=43yjpoZQgvmok8q4MMBTos8nfLBmkfedw0zL5E0tMtTCqVaSYQF/E/hdnnZw6N6v+0yB
	 M4VJ72H+eAcyynWBzwPAcJtKl67xmJgh0OZM8D98vEfGSVNPBM8xD//PbMvh8iHsiFBpM
	 tKLZ5eX0l94iIlTqYahnpkWjeifFsbzsDH8ZXnpAvJ62xrVd9PfxuASIfdh0zNfx5NyPd
	 SaLv+MYwxrLhysGolSCYJclSmXHFsNV+beVqonXCfGkTcXrK2VYDkMwhgsC0oFrCfv6W5
	 FNToeDfng+YzPaHj+FT/0i8zMxIwA7wc7vWpUMpYtGfId3HoSdCGYBcpTabyAv8giGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=CHId1680;
	arc=none smtp.remote-ip=209.85.128.48
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28DF7606A31F
	for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 17:41:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 28DF7606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=CHId1680
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4a5b2be99a8so11006415e9.2
        for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 10:41:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793209300; x=1793814100; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=x/l/zKeelwRJBhxZfMNH6sAqhzKzVG26GZyZjVVGRF0=;
        b=CHId1680KI71HT4YHSV0SKQhY5xMgtWI8PMVmdM13OzjVP+F8Jbax0Z4x6vwGF9t7U
         w7dpqQH89fr0g+/ig11wj1XA4EzxJNA23cMcZdlKqIeVfSdL9cm9W9B3YP+Jkp7136W4
         dx3c4I+NAITe1XEmeDVTNesxCIfNfiVX/V9rETPJxJGWndspgI+nPK5vlr+WWVhW9Zyp
         Gtwn/tXiwCVkb9GRlyiS0Q+7MT5xeYxdG4bXC+68TEb+XlqlBaRb80YJZK+ugo+5KQVs
         291a/XDwZ2xTzsmtGrt9zmr223+xI42LdNfdY+/bA1a4AblSDfIGn1NxvC2wcBgWnPi/
         O0Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793209300; x=1793814100;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=x/l/zKeelwRJBhxZfMNH6sAqhzKzVG26GZyZjVVGRF0=;
        b=Vx0J6p0tjq8ORNNgXFqh2yx/xkrXeWq4Fjv07OEaRlNgpFq/4wzX05U6wj63azBHcr
         UBc0BEG9NS68S9vgBfB0J0kjOJWsjqsuKBoOtvrRw/RFk5sb0kncQHcPBLBEnguYCAJd
         iLCu1un2rtTGmiW6EpYHGIvRrMiGGQFEZpR3VRTfqesb4ht1sJM3EMOp1hO/90L6tRry
         2e8HdfzNedg5HhH0Zmh1T2SM9lbwy1e+oJILJ2KikPjv8hpP1NnvehmPEPQqp5ELXuiM
         80KoxRGiEV4dOqau+u8O2vQ0iARf1XR+ICBfoJtdPgeDbL+x2byPlPH+CMUCA4tND7j8
         kD+g==
X-Forwarded-Encrypted: i=1; AKwUvByxZW+BypTbFWYOwxa99ZfZ4bbtryLYSOPCqZdWVVj4qtN7jzNYzu+GaPwVyP5bhTGYYG9kztPwekdNfcEEcQ==@vger.kernel.org
X-Gm-Message-State: AFq9FYJhWawLArlBphbriUNib6BRS4ZKL/+pyYAQo01c9sSb7+2ILzrM
	OUo57OK513OdPBXbPNDgBwc/Md8kC6p5o5TWj49DEkfcPKnjLZ3AcWFB
X-Gm-Gg: AYBFou3AM8H74aPoN6BCZZHX8SLmCkaAsoVih4w0slYpgkatjwd8efwc+FAjdVuZhFF
	eCxbzVT5eFfhJUqn1kMuU4qLUGEMeEoHhZ84/1nvIvmFfIuQ9m022bNxPehFmV+WsB+VIuVHa/V
	Ytu52aRTVxcoUI16bWjZjb0OuxeNVlZM90IVCMLTNqmeqH8F29f+Iq/2Mjn6vRBd3qN64ZW4iGX
	P1BBkPkYCM/lBauvMD0ubb7H5Hmd/z788c5vQHK4KTtelL1wNZ2aD23KFeEZWVFqisS4FnctzSN
	co2Xnon5N/G0NjNvPn4eKAd7cnHYNfwhteFYxtCfrhEL6CRduB43R0rUoASpJdhQiaih4BT6mFV
	FHyaPLTNoOPpW0iQAiO74esXYl+arDN26I59OlplK+fEyFGbzq0Ye+S0F5Vq8rbcfpydHNV9Trb
	5vo1AtdxcBa0z8CmBT8LBOW/3SKxcF5T/4bBr/Y7i1Tg2IN6bvhMg6H84p7SOW+j8aZoHIEjJN0
	M+Ls3C8YBd6vnL3akU7sglag6VzmO5WxuZd+S+HANvZFiYvAtj40SrOy1/PxVpCbUup3bbAkqc6
	qNfkYyNe4llkQH9LL/1YsgmCqI5f1/ID44QL
X-Received: by 2002:a05:600c:37cc:b0:4a2:677:ad8e with SMTP id 5b1f17b1804b1-4a968552939mr68565885e9.34.1793209300362;
        Wed, 28 Oct 2026 10:41:40 -0700 (PDT)
Received: from [192.168.1.50] ([81.196.40.70])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4aa7c5063e3sm7909065e9.0.2026.10.28.10.41.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Oct 2026 10:41:39 -0700 (PDT)
Message-ID: <152bc5bf-4e5e-443e-b191-198205ad81bc@gmail.com>
Date: Wed, 28 Oct 2026 19:41:38 +0200
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
Subject: Re: [PATCH rtw-next 0/5] wifi: rtw88: pci: Support an older design,
 like RTL8821AE/RTL8812AE
To: Ping-Ke Shih <pkshih@realtek.com>,
 "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <2033f1b1-fb12-4a04-aef4-923590e64463@gmail.com>
 <4c0eae7568334475b3b9a57e50f5c912@realtek.com>
Content-Language: en-US
From: Bitterblue Smith <rtl8821cerfe2@gmail.com>
In-Reply-To: <4c0eae7568334475b3b9a57e50f5c912@realtek.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 27/10/2026 03:52, Ping-Ke Shih wrote:
> Bitterblue Smith <rtl8821cerfe2@gmail.com> wrote:
>> This series extends rtw88_pci to support an older design, like
>> RTL8821AE, RTL8812AE, RTL8723BE, etc.
> 
> The older design is own-bit ring, and the new is read/write index ring
> with buffer descriptor. Can we use 'own-bit' instead of 'old' as the file
> name ?
> 

Sure, the file name is not a problem. What about the code? All the functions
in pci_old.c are prefixed with "rtw_pci_old", and there is rtw_pci_gen_old
and rtw_pci_gen_new. Should I rename all of these?

>>
>> After this, another ~20 small patches can enable support for RTL8821AE
>> and RTL8812AE.
> 
> Will you plan to implement RTL8723BE (you listed it above) in rtw88?
> 

I wouldn't mind, but I don't have that card.

>> Then rtl8821ae can be deleted from rtlwifi.
> 
> Luka asked me to merge AP mode for RTL8723BS, because the AP mode of staging
> rtl8723bs can work well. If you decide to delete it from rtlwifi, please
> make sure all features are implemented before deleting. However, I can't
> say what the exactly all features are. 
> 
> [1] https://lore.kernel.org/linux-wireless/d6af5cebfa1a46e2bc2da662634766d7@realtek.com/T/#maa2a3e897d5d488d0219399f9555d88b9ef6504f
> 
>> rtw88 is not without problems, but in my experience it's more reliable
>> with these two chips. In the 6-8 months I used this code, I observed
>> these problems with rtw88:
>>
>>  * The top speed is a bit lower: ~220 Mbps instead of ~300 Mbps. In the
>>    case of TX, the difference is due to the EDCA parameters. rtw88 uses
>>    the ones from mac80211 (rtw_conf_tx()), whereas rtlwifi uses its own
>>    "turbo" values when there are not too many non-BE packets
>>    (rtl8821ae_dm_check_edca_turbo()). Not sure why the RX speed is
>>    lower.
> 
> Maybe you can try to compare them by VO or VI packets?
> 

Do you mean for the TX speed comparison?

>>
>>  * RTL8821AE RX speed gets limited to 70-100 Mbps sometimes. If I watch
>>    a Youtube video with Bluetooth headphones for 10 minutes and then
>>    switch to another wifi adapter while the video is playing, leaving
>>    the RTL8821AE's wifi side idle, usually within 20 minutes it will
>>    start to raise IMR_RDU when it reaches the end of the RX ring and
>>    goes back to the beginning.
> 
> Does it still happen without Bluetooth? IIRC the rtw88 BT-coexistence 
> mainly supports RTL8822BE and RTL8822CE. I believe the algorithm can
> share with other chips, but control registers or additional settings might
> be missing.
> 

I think it was not likely to happen without the Bluetooth headphones.
The bug Luka pointed out may have something to do with this, so I will
retest the RTL8821AE. Right now I have the RTL8812AE installed.

https://lore.kernel.org/linux-wireless/152a5489440fbddb039d515af46fa46b30bfb109@linux.dev/

>>
>>    It uses RX descriptor number 511, then number 0, then it doesn't
>>    want to use number 1 for "a while". It raises IMR_RDU once or twice,
>>    and only then it moves on to number 1, 2...
>>
>>    Usually when it raises IMR_RDU there are 510 or 511 RX descriptors
>>    available (out of 512), so it has no excuse.
>>
>>    Once it has raised IMR_RDU the RX speed doesn't exceed 70-100 Mbps
>>    anymore.
> 
> If driver can receive packets on time, how does it raise ISR_RDU? 

It's a mystery for me.

> Is RX interrupt triggered on time?
> 

I'm not sure how to check this. I assume it is triggered on time because
the ring was always nearly empty when it raised IMR_RDU.

>>
>>    Powering off and on again, which happens a lot when the wifi
>>    interface is idle, doesn't help.
>>
>>    The only thing that seems to help is reloading the driver, but even
>>    that may not always work.
> 
> I think reloading the driver and interface idle are very similar (almost
> the same). No idea why they have different results. 
> 
>>
>>    Switching to another wifi adapter while playing some video is the
>>    most reliable way to trigger the problem, but it can also happen
>>    randomly, it just takes many hours.
> 
> Thanks for your effort. 
> 
> Ping-Ke

