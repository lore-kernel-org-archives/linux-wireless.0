Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793718375;
	b=cVy+kzrqpwEVb3DoXKB+p6mQsKYg0WUxTgFs/884b8bbybc93qkopU7sCxQmH5PHP9AT
	 m2S3LbEIt/oQ+wwhvRJm52ugVl36hGu5mbmWSB6UwHNIhoPijuBiK0/NUaUklsu166pBZ
	 UXY9aeA3Rbq676Ai99vMl680/y7YQ7uld1njuzMj0f4Gl0z5KmBBax/dK3ROP42jhdtZI
	 6fqSHr8rRvHzy6GBcYSeEMAw69vhAIcchkq+ZxRsgkfkUxlIh0hnHtyrGroxuLgB5II36
	 dD6240An87/UeyegmagEa3riahSIQzdrD6oqnFrjfukPc42+30a6zKv2YiHRff7wjbg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793718375;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=WU1/Ti5vxbY29W1twRVtNnFD14T2IhZUCkb7kizaXd4=;
	b=21FPog9cSQAZP48jT8H2PTBD4su1QFKyS/4P6TQPthQNISe8xkRcbP48JhvMQLOnnFq6
	 jeLie8WrAkVcFo1uaD+XaQRBhH/wrj/7buihMA8xwYigmbIoaDdy4PpzlrwFzDOLkRGUX
	 NfwHytRm1ZtZhmmhLFUC75M+1wbAf1Vf3ZuA91w4dOc+MmwZCsFti3yXRSgNmCAZyFx9i
	 TQic7PO1FbfDVtUlBGaPHuruFZM7ZKuA6LPy+N9GYEOaYupOcvfSGywkShEXRpJG+4hxb
	 5IPScNBh6lyIPeVM4zVm2udBM0mQmXte+2/K9P45VB+bjYnuwS3nbwEPZZr9yrO2Geg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=VErpi5Rc;
	arc=none smtp.remote-ip=209.85.128.47
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C21D7606A78D
	for <linux-wireless@vger.kernel.org>; Tue,  3 Nov 2026 15:06:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C21D7606A78D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=VErpi5Rc
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4a59100fa83so38654495e9.0
        for <linux-wireless@vger.kernel.org>; Tue, 03 Nov 2026 07:06:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793718373; x=1794323173; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WU1/Ti5vxbY29W1twRVtNnFD14T2IhZUCkb7kizaXd4=;
        b=VErpi5RcqMq3SW/3qWGD0WYex0zau9GVRc37Ezu3qMLjkAUbCc5dgrUUKCZ+D/+gu7
         l1h09vcIHO+B6fDy0+PlH4JKE5hUQP03OGvOGDPsv/KO+lSwd9Lr71jCpiO9YwkHTEAV
         Adb7zG/+53hfZOchByDb99HjRJC6cJ/WIKoayyd/ru0sdepFScAs6Dy9NhjhQrvUgjaL
         25hSlVOcbhzCWdp2WmSdxbg8V1iNTwG+ST0Fn/rs6OkepuuqBp9Nl1uSsZ68eVz9pCU5
         MaGgqyDSuEOACgRd7194eODVg3LIXnAG3+/9gR72ouRZRfpglT4wuzxdXnvT61ohFXiu
         afXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793718373; x=1794323173;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WU1/Ti5vxbY29W1twRVtNnFD14T2IhZUCkb7kizaXd4=;
        b=VqVmfwrZqx+4ORuytUTKxjeeQaGp0aaQrYbg3hp1a70PkI82Hbg+kij32s0GbM0jPl
         1UtrKXxUbBbXtoqEtCBUgfwoe7gvwhGOjrTdnN7LDSu7v2zcHNMmIGq+9dWbNq5omKoO
         JAgSd41rUAv0OPRv1Mcpxu5nLNjMQgPi+NAlA0U2kJy4s6Cx038QYU0hmHsdn35eRdIN
         SXel0AIpe/unGvodo40SCxdn1f87+npWo2ivzdqyU2ohemEkwZlUPdFSZpTTKZ6PJAtN
         iT7JWXHuaCEfGTaKVOLk+deJnq7Ra4AZkmqQlj0MpUoEF8a99XILMPYoJ423QDx9gG3U
         CkBw==
X-Gm-Message-State: APuU4Z+9t9zXyWzQqkWwkDE/3ExK72MwTLokEVTyrhCDxrO4ZQpqrLdO
	XQRx5D3TAuOiy/laEhf2/DEmK0ohVrig5/RRlF/DrE8CPIe94FakmoY8XZLZHw==
X-Gm-Gg: AYBFou28K7LEGRXfSCfd7kcRHSrRZ5279QCV2G8kugYw9DDoh7MXaQrYkHWfD5cYy/7
	3yDOCG911XHUl6yRS/cafGHVIUzao1s1kMw6373sMoLdgFe/rO/sol0yKz0FbJzmvo1Cu5J7T6b
	wBN/IrDrH8H742DsiDJeDCxtIN3t3OWyLaDeKHvmKNLbWtt99gsBfuFPoZZjzyIifWY91fbc3ak
	b95YjOmF2v6plTI8boxkC6BA3oYp8CXyDBQzjy31xZsAUwYqXNmwbvA1Cp7MvXW4xV7yOmuvW8U
	0II1uqimGK/wnkdqwY2IjRS/iyuOjFnGAoSRliJgCXaLI5QlupEjrQQFQODgxIP9c33MSl9WloL
	3Ji5zsfdLjVIs+NkO1WAzAJaHDCYuuu6qK65bKawp7KZkUP0FjdW/EHxZFtII81FCH85MI9Pp38
	suNmE8iaIXHbm2tmGdMHG0r9unm9qKGReGuW7k2uBaWmsKR4z4XdPFga4s6Gfqz+d9rbpbJ7ATG
	pNY6qSgFDBBZ06/lCpJd5PWDlj2VIp2v6KlK38UeCUA9SfPLIrcorB2zTVvpmQ88au7hmNurhdP
	mU8JaY5y2fjg+Q9CurOxnVUl7vvgF9l9cKIMibzdTCgWd4cjO6wCLnNJGznZU/S2wqXUElvmI1A
	X
X-Received: by 2002:a05:600c:4ece:b0:4a2:40:8d2c with SMTP id 5b1f17b1804b1-4ac17b2c396mr294720925e9.26.1793718372761;
        Tue, 03 Nov 2026 07:06:12 -0800 (PST)
Received: from [192.168.1.2] ([31.176.171.4])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4ac09fadb75sm226623165e9.3.2026.11.03.07.06.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Nov 2026 07:06:10 -0800 (PST)
Message-ID: <314eaf43-34e0-4a44-8516-ce25220d4758@gmail.com>
Date: Tue, 3 Nov 2026 16:06:08 +0100
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
Subject: Re: [PATCH 1/2] mac80211: move static function from header to
 referenced file
To: Jeff Johnson <jeff.johnson@oss.qualcomm.com>, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20261017155509.128114-1-omer.e.idrissi@gmail.com>
 <20261017155509.128114-2-omer.e.idrissi@gmail.com>
 <b60d12eb-dad1-4482-89ca-155dfcb410b9@oss.qualcomm.com>
 <2070cf87-bc38-4237-a58b-6554572a8842@gmail.com>
 <936d7fdc-fd79-4869-b39a-7219d2ce4979@oss.qualcomm.com>
Content-Language: en-US
From: Omer El Idrissi <omer.e.idrissi@gmail.com>
In-Reply-To: <936d7fdc-fd79-4869-b39a-7219d2ce4979@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

> On 10/30/2026 6:21 AM, Omer El Idrissi wrote:
>>>> Move static function from header file to only c file it's used in.
>>> why? all the drv_ inlines are in driver-ops.h
>>>
>>> first rule of commit text is to describe the problem you are tying to solve.
>>>
>>> don't add unnecessary churn to the wireless code.
>> i moved it because multiple files include the header and when those are
>> compiled they don't see the tracepoint definition because the next patch
>> ifdef guards it under the same config that enables the only file the
>> static function that uses the tracepoint is called from.
>>
>> this static function was only used in that file and i didn't see any
>> obvious reason for it's existance in that header so i moved it to the
>> file where it's used.
>>
>> commit messages are kept in the git history. should i send a v2 with a
>> better commit message? or is the patch series problematic otherwise?
> I can't speak for Johannes (wireless maintainer) but I would not accept these
> patches. There are thousands of patches active in wireless, many of which
> solve real problems, so the maintainers usually don't have time for "noise"
> patches. I have over 400 patches in my ath.git queue alone.
>
> /jeff

i suggest you take this to your local union. i'm sure they can help you 
negotiate for less inhumane employment conditions.

