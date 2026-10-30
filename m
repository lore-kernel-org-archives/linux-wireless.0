Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793386027;
	b=wtEYM9RHkT33Wg08Hd+XsyCkAa9cS2EMXJ9qX2adXSbAQ0AieIDldlVWVp0UcNgObUkA
	 JHmFZDHfoZ7LQHVdktbf3S1URzeYDq6YxnYHUKxaOYfRy7FShqM9n1siJrjjnXNHd/MSl
	 GA7owjSNhdju5BgLpYJTKL2l1P/0eTxq/lDqWYMaWM1a4dmX8B9bjArdTH185LmHBSosM
	 3wQPEnGy8m1s5WTiKnaPFP2qOYMHs/TMDhvcETQ288fbr8ru5DrulaUERQle81DvAze0/
	 L6ybtqcY2zBBXgjqSfzRu7QOEGToEfpIVOUwlKQQFkOw4nZTfwE472fRNPzibR8Ke8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793386027;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=Dx284XKPNahI6ZPULMg2hrqY3os0sLeUSTJHBcHarFA=;
	b=J4IPG8WhGqQtxL4x+odjY+fahL8nUu1zvSd3PqmFPvvyDAtEuKhZQeTBbp3UwHehWe1m
	 ZEsDWXreRqoRmmgl8TuJP3Ga5Qz18R+68Vya6rk2jCzBmKrSv+0OoV6WuzY8jKlZa4O4d
	 kAR0tD8y4/7pM6h0MBlXaLKztgfGwRYJz2ONliLFuYcD0q7gv4C0UXeXhPrX4xCegO0Yv
	 T26pTvLhWr3WFPIelnRb45Gn5mZNLkSuD6rKpyBXH1VcHDcEMwMjt4eU0GmuVZvzkYBwl
	 JmoXBUcvaZEDINbpbTMYT5xeSw0xC/BoCt8rCEfRUush7eeFm47osN1hqKtDHaPR4Fw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ofazSOfF;
	arc=none smtp.remote-ip=209.85.221.42
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D745D606A31E
	for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 18:47:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D745D606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ofazSOfF
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-48af4d4e61fso626268f8f.2
        for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 11:47:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793386025; x=1793990825; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Dx284XKPNahI6ZPULMg2hrqY3os0sLeUSTJHBcHarFA=;
        b=ofazSOfFqRIukE1sfgLeZEwvyfossH/g2707soKlqtRsd60hfYkVJMwQJok1KoD9fi
         b0vQ7W7c3v+w+412mNAqPNxlrhwHO3gNYHcPDx7JJxS+PAnC4/nJqQ7/7pM9ea+s0W1U
         M0dZu9tvAOiVYCsf+i8riSzNrPAq+8ha3Q6cnsWRbXA4qNrqKFZUjhSGPtZIhwzkVPEY
         z4417aIYPp2wzWG1HOmSV1/7SBgjK2befPPzc+uTlU1r1MRqp1IT9I9iX8prvz1LkBgC
         A/zh/ssxJv5Ht1MiJDKIzSxn7EG2dSxkVwSXw1PawpccY/a9N6R+HfcfEK+ypOoEaHK4
         BbVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793386025; x=1793990825;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Dx284XKPNahI6ZPULMg2hrqY3os0sLeUSTJHBcHarFA=;
        b=B5O0CAdDMyg2ZC+qxpAvG4gg4IdIqIffgBRUmB/5xutBMIOh+H5I45f8vrOhIwgvFc
         Py3ld37VwGP4DRIalY86N+hXnmNk7XjhV1I4VSGMZLRunSZKFwPgVg42/W2MjeF3dbN0
         8iH4JC89Ltld0bELlxJTVsX3pxqRfyZX/RptlMwTTLZ84YZ9SDXqeXeXq5LPg8d025sR
         If3z5ppIFSGwp/pMkYFhkt+ouiLrFVpxPsuemdN2FCmMf9+TgsCuxzF235DW2Rpt8YFd
         hJKgkQt4caLTKoNjnbk0N29UcE/VXZ5LINc56QZKmkSv3jCgq8xtbyVarlcrdVmQ6cvq
         b6gQ==
X-Forwarded-Encrypted: i=1; AKwUvByKRgD3Kk2kt1wE3j8hOW3wHiDmTAEKLaQY+fEZvBiErWxewWF555h42FGUaWiasvvhtA4Hdj0Cd04skiw66w==@vger.kernel.org
X-Gm-Message-State: AFq9FYK3D8dlMoVu0HdPhNiE+IUg42kIkDItr9RAEyQzp1Kk0b9AILyL
	09PJU2aiPZDUKYU1/zPoCunSZnoj0jKBh45W3JEklsQh4cri3KEATa925bUAkg==
X-Gm-Gg: AYBFou3Km19lpBYHYKAmKmsAgGH7r7R5czXAg69jwDZ+i90GCUukrVRRAhEdPb5iR21
	c778MKYAzTv8xK4nKWnrOxhXn4vIh7uIDS0UcevDzPbKdjQpEZmci4HPZH2xGaRqE9TbDBVtCHF
	pMdYPT9KuHYQHvBbpKjUV74AT95fzhyKfhNwhqs+hp53XdhQ72gcNn9idAxnvGWdI6SgibAJwjm
	YD6rSQ0xGwnqmDqQatQfU9Lj3rFoKAcb5m3IUZ9tQiZAZONdie2jOnneW/8Pw5xiK3Sfvlx8cb0
	GpXBNM6wViCprm3VetZP+4RQQ+THwooSmYGJx1u5pmJ33mHC0IvkoqJ/J6GixUzPrukXWbddhPY
	StTgGCXmdstDEUtENtRnSyQLXdALAeaA/U15l168wtxpTtOvHUBsLSUdxnCHZkcyjj3i4aD+8dB
	N+PV0Aciot+zu1gFXJaTdRW9nLrs4AYbMmZ+x1/K+mfGVSMQwiVgQczd/1y8fzcF1vj1sqOX0J9
	Qb2/aTCxvHMcsNyVawYRTsfpHkoeWPRG5CHpAC/vTRo6ey2qV/lu1Q8yvYw37zDxLNFfhKOqFda
	MhMUdoDrLdI/3UH5flfAYyw1qVIHw1Yi2nfz
X-Received: by 2002:a5d:5d81:0:b0:488:89c7:31aa with SMTP id ffacd0b85a97d-48e6e30976fmr7970021f8f.39.1793386025159;
        Fri, 30 Oct 2026 11:47:05 -0700 (PDT)
Received: from [192.168.1.50] ([81.196.40.70])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71b959c1sm4606853f8f.45.2026.10.30.11.47.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Oct 2026 11:47:04 -0700 (PDT)
Message-ID: <716e083d-93c1-4236-bfa2-ec88d0c84ca4@gmail.com>
Date: Fri, 30 Oct 2026 20:47:03 +0200
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
 <152bc5bf-4e5e-443e-b191-198205ad81bc@gmail.com>
 <f5ec572f354f4c67a2a65b2b1676eae0@realtek.com>
 <ca4921aa-c8aa-4f88-880a-bc717aa103d4@gmail.com>
 <08b040fc2f7e4311aa7721cf4969896f@realtek.com>
Content-Language: en-US
From: Bitterblue Smith <rtl8821cerfe2@gmail.com>
In-Reply-To: <08b040fc2f7e4311aa7721cf4969896f@realtek.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 30/10/2026 02:43, Ping-Ke Shih wrote:
> Bitterblue Smith <rtl8821cerfe2@gmail.com> wrote:
>>>>>>
>>>>>>    It uses RX descriptor number 511, then number 0, then it doesn't
>>>>>>    want to use number 1 for "a while". It raises IMR_RDU once or twice,
>>>>>>    and only then it moves on to number 1, 2...
>>>>>>
>>>>>>    Usually when it raises IMR_RDU there are 510 or 511 RX descriptors
>>>>>>    available (out of 512), so it has no excuse.
>>>>>>
>>>>>>    Once it has raised IMR_RDU the RX speed doesn't exceed 70-100 Mbps
>>>>>>    anymore.
>>>>>
>>>>> If driver can receive packets on time, how does it raise ISR_RDU?
>>>>
>>>> It's a mystery for me.
>>>>
>>>>> Is RX interrupt triggered on time?
>>>>>
>>>>
>>>> I'm not sure how to check this. I assume it is triggered on time because
>>>> the ring was always nearly empty when it raised IMR_RDU.
>>>
>>> If interrupt handler can handle (ignore) "empty" RX ring , it might be harmless
>>> to see raised IMR_RDU, right?
>>
>> It is harmless in the sense that everything keeps working, just the RX
>> speed is low.
> 
> Have you dug the cause RX speed is low? The PHY rate becomes low at that time? 
> Or can air capture see any weird packets? Or did you think PCIE get stuck
> somehow?

I think it's a PCIE problem. Before the first IMR_RDU the RX speed is normal.
After, it's low. I will test the RTL8821AE again probably next week.
