Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D86253803E3
	for <linux-wireless@vger.kernel.org>; Tue, 11 Aug 2026 18:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786473423; cv=none; b=rszyw+tqNB111qbFtstyG0ay0oFQjsGuozxYJSZP3c8V0rSd7hnXmXr3+nc9Dv6OE6JUNvQgT+s2i4UG7j0R2xUAVgxsfGNbHoTXxpKcUiMffiE4IagAdvMLLLD/IBjo/R35cG5cekxIyJ4BjdAeC0eWyoEM8MWuDQP/rw+Ugbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786473423; c=relaxed/simple;
	bh=+xk0YRRHFXWWxXx4K4tc+WTEpaRgU+AXG1t5LiJ3az0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=q+2X0M4CPGeMhe873MbT+2pJv1WUf2fXT7Y3PAWUoef33XEzqMLhlJY3/QVPWS+aP35FdUUYar5NDk6i0hPL/6W6XY4qDTlyj6kZYPmKKpozYwsB4JzvAQN+kch/WoseAvVY9sF4mzvb8p/WLb9wyMoLfROrcR9h2r1VKBb+2r4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MjsM43MQ; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MjsM43MQ"
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-cbb973e6749so105818a12.1
        for <linux-wireless@vger.kernel.org>; Tue, 11 Aug 2026 11:37:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786473421; x=1787078221; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=g6IN6WNOpG4UWSFoaCxgmbPHMP989spnYBSI85Zg3/s=;
        b=MjsM43MQZ0wv6dQXmmKBoSvgt7Up0nutdu5EN0hxcMMPY/avITXwkX0joHh7gYZlXA
         erZtVdlBh4uZUCjezWmoIv+wnZXtdjxog3GheE90lIga8JTdzumuV9R/178qqVpO8zqp
         9Sb6KyAWoW7fXYOMxhmofADM575pgcN6Yi682Cq9jdYIwBH817J8gsGW4XBDgDFWftdQ
         VJUyeIxDty21Itkt6/GY+rm8U3H6+RftqciTq01LpkAt6hR7sGmZnEKs/POo4U696O0l
         OiqQYw8S7fIc0685ObI0EPPtE7ibhk0UKlpA72/qf0lqtMc93OCoqJUyCLfqW2X8J+X7
         B8qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786473421; x=1787078221;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=g6IN6WNOpG4UWSFoaCxgmbPHMP989spnYBSI85Zg3/s=;
        b=TQoQ3MMH5YGZ6ZNLWizdniwgd3gQtnV8sFphJFL7c81/8dTp1nFxrW4B27XH7ShRZh
         y6DqQK+4ABgOxyiyRlGBcX5PmzuWy6XWsEhod2DMftbl+WSVNIReo2PlynEtQ0w8xfoU
         6r5hIQ5n0UHxpWQb7hI573lqAENh/vm9Mm1ZzuXJy0PshtyCVt6Sv5tzwmAzfNV25JV8
         PH2pZ1EbhZ6Ijbqp5mmhabe/Z1ceu8r2Rbj5/fIXhfg7omrDO67lqYrmXammOgYPuKNf
         iNDPjcgQwwyvMjXF+QIO+j693vXHfnV7zCpfWjc0kc9g1C6ChQZKQJwOJ/QOUhJcm0fp
         pg1A==
X-Forwarded-Encrypted: i=1; AHgh+RorEnQRbPElLbvcs5axzYk2gTkVZArD/VISaR49XJVAHUuRpLk42M++005LekEPO3EcEvZgxfLTUXSmGbuPrQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywwyx9tTdyqCL6Gqq849nS/43Z4zw7FAA40ydI4ZlIXX9kg/tqZ
	ack8wB2jMuJMUD6uaU7t9h/7NlKYGUYpPDvRU4aGVXZctcCYG3AYu2+z
X-Gm-Gg: AR+sD10TVj4KRBBjLmOq0musWEVLZCchMrvW7qZCfwYBRs3LviALUHXDulfJK5sjhwe
	DFaVJhm2kjpHPT4MpFQP/5ssE3/5F+nCwiCQ+IYdsH+PahnjHfYG960juY/HfLWWCiwGOfP//ZZ
	sxoAU4v5oGhUoMQG+4pOzYR7X7S8KfArUlLu9BhkHLoy9gstazagmtQ3MUy6oCyoLJekHmSyU1F
	9uVF3PWSGzAA1BrlKiJP8DexTNphXqH5FG9Go3gDSvc615M7gXc5JZ6pwD6YXNHLRZ/es+RU/Ac
	BH1AtRNPmXWtc/vrxYFgZ7Gb8uZYL/1N73YgSWeZ2/bW30ZnHaTisybEF6biAcuVXnN32BvFnha
	ReWSLpuIG03I4y+vYxKNFhj/K9zJEGhTqdJtsYcXl2nDCxx1H0yIG0wWrzVzqI/pyx1fsqxY7yH
	rcVm+42M7DMezhMBbFV3ywIFWLYrFrRtZWzPkK5lGoLvWSWwVPGOc5WtIePhRg9LzWiXtJYu27k
	tjgcV8iWb3knFffToW7gBn1DdMTaujpaHA=
X-Received: by 2002:a05:6a21:4a97:b0:3c3:859b:9178 with SMTP id adf61e73a8af0-3cc2bb0a29amr7579414637.34.1786473420857;
        Tue, 11 Aug 2026 11:37:00 -0700 (PDT)
Received: from [10.100.120.121] ([152.193.78.90])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cbed8ea1ecesm1380728a12.31.2026.08.11.11.36.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Aug 2026 11:37:00 -0700 (PDT)
Message-ID: <09fdf1b1-8025-48a7-b479-8edfd625a561@gmail.com>
Date: Tue, 11 Aug 2026 11:36:56 -0700
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] wifi: mac80211: defer AP-side FT key upload until
 association
To: Andrea Covelli <andcov23@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
 linux-wireless@vger.kernel.org,
 Kavita Kavita <kavita.kavita@oss.qualcomm.com>,
 Sai Pratyusha Magam <sai.magam@oss.qualcomm.com>
References: <20260730161531.3535100-1-andcov23@gmail.com>
 <219ac494-deb2-41f7-a762-7b5e666499e3@gmail.com>
 <20260811173509.179926-1-andcov23@gmail.com>
 <30d659c8-f568-4903-9dc0-1a78e16229ce@gmail.com>
 <20260811182545.256241-1-andcov23@gmail.com>
Content-Language: en-US
From: James Prestwood <prestwoj@gmail.com>
In-Reply-To: <20260811182545.256241-1-andcov23@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Andrea,

On 8/11/26 11:25 AM, Andrea Covelli wrote:
> Hi James,
>
>> Another case I forgot to mention is the client will FT roam and
>> immediately start dropping _ALL_ IP traffic (despite the 802.11 layer
>> remaining connected/stable). We've seen this with several vendors and
>> actually had to create a watchdog to monitor for this situation and force
>> a deauth on the client side. I wonder if this is closer to the issue here.
> Yes, that is much closer to the failure mode I would expect here. The FT
> reassociation can complete because the initial set_key() failure is not
> propagated as an association failure. After calling the void
> wpa_ft_install_ptk() helper on WPA_ASSOC_FT, the caller unconditionally sets
> sm->ft_completed = 1; there is no success value to check. If that retry also
> fails, the AP and station can remain associated at the 802.11 state-machine
> level while the AP has no usable PTK, leaving the protected data path
> inoperable until a disconnect and reassociation.
>
> That does not establish that the vendor APs you observed hit this exact
> mac80211 ASSOC gate; a different key/peer ordering bug, or another data-path
> problem, could produce the same symptom. For this specific race, the strongest
> signature would be a successful FT reassociation followed by no working
> protected data, together with a failed pre-association key installation and a
> failed or absent post-association retry on the AP.
>
> Even without useful AP logs, a station-side monitor capture covering the FT
> exchange through the watchdog-triggered deauthentication could help narrow
> this down. In particular, protected data continuing to be transmitted and
> acknowledged at the 802.11 layer without any higher-layer response would be
> consistent with a key/data-path failure on the AP.

This is great to hear. Getting a monitor capture is tricky since its not 
a consistent problem, but I will try and get this either way.

I really appreciate the context here, we've been struggling with this 
issue for years with no help from vendors. This is the biggest break 
I've gotten.

Thanks,

James

>
> Thanks,
> Andrea
