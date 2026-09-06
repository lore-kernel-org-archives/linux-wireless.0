Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A4CB279DB1
	for <linux-wireless@vger.kernel.org>; Sun,  6 Sep 2026 14:03:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788703382; cv=none; b=DjqERlP/qOh9In2l9hRUnU2vfr9dfvJr1YkhvRBydMmKoEBk3UqvEHEPQSC9GrkduCOepJyQLKUqd7/ZtWm3aGqfXowEasTnt83769PQbjEr3eHu/aB5PkYbS3IwOQYUiSrUyrfOxwaNI+yHwxMXS3vMqtA2K7jnRjhX23FOdKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788703382; c=relaxed/simple;
	bh=aBL2Q+ay9Sl1XHHZAUW1SLris8znZOlctUEWmfLEiGs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cu45tdc1iYXCZ+H/SCS6U4TZqPpopvxepj/6uDd3F4b2uzRYTR1QRKMNPIwtr0reTpzTHYS2aPhmY/fTT5j2TkN38e7VSRJojjj6AgK7IPylvVqwdGpblWoH8KzUSjzMkS5qpvlEZ/jqAqg1hBd1wQJHFv+Dv4XtyIkuuhHqbDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QCFcKbjh; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QCFcKbjh"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-499b2981a7bso27301985e9.3
        for <linux-wireless@vger.kernel.org>; Sun, 06 Sep 2026 07:03:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788703379; x=1789308179; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=14jJVZF46y58TMyS39OsdlGX+U+N7xxuWdF3HxtoPb4=;
        b=QCFcKbjhD2vue5f7VklaFEihv1dXKUUaubJ3ggN7JwdPCT3yzjB3CJsLH4fKe54GXn
         Ax+QG9SGsIH048tYbKyDxPgHcfo8Zb+U5NE0OVx1bEl22CzQ79O4ovvu5AMkL6GbnI6A
         6MfcE9wVvQfmo8tWCiOZMDteKJv/mZtCE0/reXnT5PD7sm4Sv0YgcRSxRqN5AvUDAHhF
         iCGa78h6gwSuoRBOqN34+0F+/SUj5g7gSPcKuMw0IzFB6AGTcYuK7KLVfS8mQgEDQlGt
         73BK7axhgBEyoI7q1XxreiTH+2euXcqXdIh7BABA9j/qxme6Zs53LR6irY5sdHOpUitU
         F+Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788703379; x=1789308179;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=14jJVZF46y58TMyS39OsdlGX+U+N7xxuWdF3HxtoPb4=;
        b=gTHAW6EuU+bBcbIA41/vg361PQ5NN6rTZqukAA8qNK2x871ezKFUBW5ECQDyt8g+i2
         lppuEs7tPYMC1FKNrxcmnUQJrk48g+jeWTMr/EAfpMPIBNdkZsJQvLtnnYQSlSSL3360
         XSNekAjtQfpeRDZxbhQBnEMPTTAmhweIjNQV9gk/oW8ws01zoRwGWceFNYVGAs90Y2o/
         SF6Ab9ooJHBY9jwDCvTrM9Oj2TcBXFcthXOXcyMH9IGROG5rNsamMGLFLqp4NnLCn1Zs
         9WVO5lJjCvKQYLPr/6dJSYOk5jjcNALz9ZhaeVGSDij7hxIKiWtqlvFZFt3yTCa1K+kC
         wcDA==
X-Forwarded-Encrypted: i=1; AKwUvBx0qnQNqRRKwwmH049rIZlUDDe3BbTAWM7wxbi2XZKeg9o6M3jN5FFUhxLAPDgVUEjElm9sUi2smUdLa70XfA==@vger.kernel.org
X-Gm-Message-State: AFuF++l7IWTMX+2cHo2P+NveliYq18w79hl1bZe0oYPvnyDW/S1GzwQq
	3lEbuyKQ2ZvsLfsW8lI34xDfPvw4EZJ8XGc4BsXdvA06HG9Ze4hdECVV
X-Gm-Gg: AYBFou0dxcBfk6YksVxs+EjXj2m2FVMR2kzq1UFfl/6i8bP44C/c3t9rg7xmyNxH3Cd
	xmhpTDwRNwsQrTIw29k5KlQ6xJtnFWNFTq6vUWbnoPyhwgLWuyNrms6i44/QcOPTJ0GElu82sQJ
	8i/H029RH2xFK4D7OhA4vu9ErSYu59/xwQLwPUnJeLkjdguia/iHJqd34uhwH8vtJ3GdZfRqZWA
	jOTTepTEnQW6v4ItsTyhIFIVs4OLR4z3DaBEXflbatROnrau6wD80q+0xqnY6Y1kYxG8Jlah66C
	RWE3E3vUXht3Iw3afEvQLbjQtrSEMWRHbXQIcOv0lK6MNyD+LESxba5Sw7zcmiRw25cUGYNnU4Q
	m6UewrsL3iU6SaewNH+nBgFrw/nNKiLksHuKauoNkpxeCyjXsReFRC7+9XKOkDgVCDhYkwzCbJU
	+Nl7pR6EXal5s/SULr6IHi+i0iOuglfDv3MXFuJPmwxY66U9hD2SugESnopssbyDs/uqJS3P+XD
	waDOF40bxjxIDzwv6ATSPHE/Xki8cBzGfUIyyOFtv/ZAlI+PLBx1YoK3UVjoX+qaZR2zpIWhzUK
	Tg==
X-Received: by 2002:a05:600c:6383:b0:49c:e88b:b7ce with SMTP id 5b1f17b1804b1-49cf823f147mr339885125e9.11.1788703379146;
        Sun, 06 Sep 2026 07:02:59 -0700 (PDT)
Received: from shift.daheim (p200300d5ff3cee0050f496fffe46beef.dip0.t-ipconnect.de. [2003:d5:ff3c:ee00:50f4:96ff:fe46:beef])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49d057f4778sm131583525e9.8.2026.09.06.07.02.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Sep 2026 07:02:58 -0700 (PDT)
Received: from localhost ([127.0.0.1])
	by shift with esmtp (Exim 4.100)
	(envelope-from <chunkeey@gmail.com>)
	id 1x3DST-00000000Dzs-36fv;
	Sun, 06 Sep 2026 16:02:57 +0200
Message-ID: <fc0a0908-aff5-47b0-8575-0016a3cc7b6f@gmail.com>
Date: Sun, 6 Sep 2026 16:02:57 +0200
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] wifi: p54: validate curve data length in the
 calibration curve converters
To: Shengzhuo Wei <me@cherr.cc>, Johannes Berg <johannes@sipsolutions.net>
Cc: "David S. Miller" <davem@davemloft.net>, linux-wireless@vger.kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20260831-p54-pda-validation-v2-0-dae566b388c8@cherr.cc>
 <20260831-p54-pda-validation-v2-1-dae566b388c8@cherr.cc>
 <f3eb0dfe-3b9c-483b-b802-2207fe8b747b@gmail.com> <ap1R0jU3UMVGI3ml@pve>
Content-Language: de-DE
From: Christian Lamparter <chunkeey@gmail.com>
In-Reply-To: <ap1R0jU3UMVGI3ml@pve>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 9/6/26 1:43 PM, Shengzhuo Wei wrote:
> On 2026-09-06 11:31, Christian Lamparter wrote:
>>> diff --git a/drivers/net/wireless/intersil/p54/eeprom.c b/drivers/net/wireless/intersil/p54/eeprom.c
>>> index 95580921d933..0dc848d77c5e 100644
>>> --- a/drivers/net/wireless/intersil/p54/eeprom.c
>>> +++ b/drivers/net/wireless/intersil/p54/eeprom.c
>>> @@ -414,17 +414,22 @@ static int p54_generate_channel_lists(struct ieee80211_hw *dev)
>>>    }
>>>    static int p54_convert_rev0(struct ieee80211_hw *dev,
>>> -			    struct pda_pa_curve_data *curve_data)
>>> +			    struct pda_pa_curve_data *curve_data, size_t len)
>>>    {
>>>    	struct p54_common *priv = dev->priv;
>>>    	struct p54_pa_curve_data_sample *dst;
>>>    	struct pda_pa_curve_data_sample_rev0 *src;
>>> +	size_t needed = curve_data->channels *
>>> +		(sizeof(*src) * curve_data->points_per_channel + 2);
>>>    	size_t cd_len = sizeof(*curve_data) +
>>>    		(curve_data->points_per_channel*sizeof(*dst) + 2) *
>>>    		 curve_data->channels;
>>>    	unsigned int i, j;
>>>    	void *source, *target;
>>> +	if (len < sizeof(*curve_data) + needed)
>>> +		return -EINVAL;
>>> +
>>
>> Hmm, Puh. Interessting. Several things. But yeah, this should work.
>>
>> Acked-by: Christian Lamparter <chunkeey@gmail.com>
> 
> Hi Christian,
> 
> Thanks for the review and the Ack.
> 
>> Still I have some questions: Did you write/touch any of this yourself?
>> Or is this patch straight from the model?
> 
> AI found the bug. I wrote the fix myself and used AI to review it
> afterwards.
>   
>> It's because I can grok (heh) why "needed" ended up as a separate variable next to cd_len.
>> But why was the sizeof(*curve_data) not included there too? It's only used once in the
>> if check so and this sounds like the "needed" needed some extra? Maybe because it was
>> already checked?
> 
> I kept sizeof(*curve_data) separate because I was thinking of needed
> as the input data size without the header. But since it is only used
> in that check, adding the header there too would be simpler.
> 
> Would you like me to send a v3 that makes just this change in both
> converters?

Well... I think Johannes already added v2 two days ago to wireless + wireless-next.
<https://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless.git/commit/?id=ce858fa6b8a214dee5adb82358885fa024cdd887>

So: 🤷. I don't think you need to bother with making/sending a v3.

Cheers,
Christian
