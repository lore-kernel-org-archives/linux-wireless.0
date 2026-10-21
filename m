Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.41
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792579485;
	b=EZ2hXIybIteLfxf+v/GQwVKP1Z00T6C4kd2frruKOsvVPa+nnBkhuxKVLpUb5fATRO37
	 LS6rE0gre4T+8u8ts3lW+VC121mlcFw2TqtgO6ql5BgXC5HkRzVZa4Nt62dC9KxIbINTT
	 /IYqFKNa0H2oOQ58fSelFxaAV1bdIr8rR8/XOdvySyQnY0elhXp0tyl72gBuJDpOasxN5
	 mU8OTuhYShmQN/6oqvUK+hq1QoW8djSEyeZYeZwuHnCnwHpxYIsTt0xpQTJEvJ/Tp7T70
	 3pLW0qiDDdMYOufuB0JfF805rEwa9ExqA7mgWaliKpkvm+dtqEKGenWD91fV1k/Fznw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792579485;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=3+Zu9D+KgKA9DXJq7rrfhDe7h3krW5LnH7aKJrVEA3Y=;
	b=LAwwDKzoSSZ8+YwgyvwjBlLTPb4Qd/jeQ49JmlKBfS/yjAqX9z79dDAPP3YKmHNx8d2W
	 6Br6kHaWpnSOybYZOHFcOLe+yEA1LUKS3UUBcIeCpAE51DM4FXxbKo70fZRezaGL6Pi7D
	 Ky/I16eS6vkshAaFSD/wMpfJR9ydjxE1mS5rGzUUOt9JUW8d76my3rQS2C8fI6eAwH6WA
	 1SHztcXVQcBeTlz6YX87SJYnudTLhrfvhNSKFMHwgp5Qv+04FN0uo62LzWjCygV4umHyv
	 /dlhcCj0PQ9hI1OYqCyMWmxc32RvydpHp01SKGsNYm6pBQtvMefYbJSu7zLkwy0+bwA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=EMJ2b1Mf;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.41
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87AA2606A31B
	for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 10:44:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 87AA2606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=EMJ2b1Mf
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-5bc18f54abbso449441e87.1
        for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 03:44:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792579484; cv=none;
        d=google.com; s=arc-20260327;
        b=pci7V2C0C8G43B1a7DtCR5tFU0uf+dr42IGorlbeT51qBxPsWHpYOtycNJkKNE5PuY
         nPwPGaEhbo9+rnWq0SGBK4RFWNc7DVN7gzidV/KUVAjSgo+qdrQZOvqQZqpYT7KrS94P
         1kFiWaiphoA3IFjxWXs+FCbL5xz7psqNDaV8lLopI4L8jpQVfSwF6AJWNSTkhAGrVrbK
         4g0Ec93BR5fD6/Wtg82ddKTBl5nFofXeackXVbT4N79K4xwC7l6GxFNk7MGriWr+g3bm
         T62p7qlUgzLKWJMRPl1661ohJXzscVceRC3aP/pEMEYO9RMz9lvnF3K0MEKJTi4JFD3k
         mphA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=3+Zu9D+KgKA9DXJq7rrfhDe7h3krW5LnH7aKJrVEA3Y=;
        fh=+l3qsnemBX+Gp1YeWzlNvKh4WVxUdCWZcyL0weULDkE=;
        b=gqhsjkzM3RAlK5+DwCorUZVyjJxBoK0XnKEunH4pTPgzsHAraAiE5C00uSa9MysjW9
         wsR9vEUEmqzWTOq26JmLiq1c2kokrOAOSx1gIkP/D0LWp9+WEDBZ9L++1Mt54wa7s1eh
         HyuVVsfPe04UErQ+3w9wh/7wf474KC5XL1Wvn6dBPV6wGOhILNwKjs6LUVxOareh9BFc
         YvNhwhf0IdyP5WMV9zWJtQL/IqiO51Wn8ACT9hxLEXJ8i4AbCOUwOnWctkCcelqTqZFq
         6EbeURQK5WexRFMtMZhxVGPrlx+vwnkPbIdpsHFwS70FrdZOPNpolzDGAaU8mFmu8+eH
         7f/Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792579484; x=1793184284; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3+Zu9D+KgKA9DXJq7rrfhDe7h3krW5LnH7aKJrVEA3Y=;
        b=EMJ2b1Mfsr3z531uo4PbTQcnTiI1V6QP2j5RPccaDPxAHktd9HynIpimNpp3Seb44d
         dsnZSu24RsiD1Ks8D84LeNAS6pJL8bWtjZerKwun5BXvUwNGyxGGXot1ISBjBaelgNWb
         +LsiBG3i+1rd2dbFbheMbr8XhypCxbMgaV6YqM7xJmr0A6EhAAIIaRAWbMN/NPY/BODc
         BCFbyAj3A1UEcGi6L+CouAWi/U+85lD9TRk45mfBdIk4o2Hk6O3GAD0V/DT6h5+fMwhB
         HDu/WXCbJOx9fw8q3qCmbhmO4OLj0UJdhHDMNfw0tSpNpbOvILJCArJ7ODv+AMQ9ddWI
         UNSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792579484; x=1793184284;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=3+Zu9D+KgKA9DXJq7rrfhDe7h3krW5LnH7aKJrVEA3Y=;
        b=WpvMLrgdRo98yhfc9FTCloxBb2xc8nfdrm1LExvf2jfG+RUnt9xez2129IkZKIry/0
         8oVurntfYha22cYj9nceERg7tnc+LWqV35lcCKN2/NApFUzXw7uASElYbn2xZdsGAY0P
         LIhWF1ypO4hcMvNYfeg/404oP2odvolYIChNimI5+g3bPowXQswJHKO4/5ZGTEyDuC6K
         4XH/NERxaFVRrJZk9f5/ehXGbCq6RQ4jIIehtvQn0p8pP9/wfFfe15EiPG45ogQqLtv4
         QDEtwK7uyuw0G76xv0QmG+MNJathRU9Ef/xwwPSCewknYPfdHBgJJGA5i3U6PLn3fyeW
         WtSg==
X-Forwarded-Encrypted: i=1; AKwUvBw5C4rm806QqhArHbZTKtg/qr8WLDHKOa90FfM54+97d8e2mSX4AM65xKKUmergLL2PCu0CMMl4pPSeiv3G8Q==@vger.kernel.org
X-Gm-Message-State: AFq9FYLzkMXLLbdQ/LUnQhZo1YfMWlnRZ6ejEFL3KYIQpVEY/xMbH1EX
	gzVb48cBANd8TBf8G83hENYcWOgwOUmwN381ULb6IC5ohwfSTlXd4V0i7sJGT1f4OefDFAkgQvg
	uwmRy2GpbDh+vcK5xuHYSLJrIfS0g5bA=
X-Gm-Gg: AYBFou1+HBtJP2x1ZCrEMXgsna1T7t/Pe/VvLcWqw0pIuxb47topuIytLpMEW54XeXg
	M8Od+DbHK2mzHUbnKqxgN5Hs4Bi/ME0W0XL8iI/Hf0KUKLku2t06tuAfuQWxti0A5VKAM/cuvAO
	IauJVzXt4izb7Yll8q/qvnT3BOOHYX+IpWYwgvT21sAV6YTiEnuZ/v1rzvUgwxhqfswqqruXbwK
	FyUcJfpJgSaH4fm45UhL77aOAnK2pQ+CHDmQDMN1vQFZSK6Kf+uPsbGigPTA+fIavd6nRg4NgXB
	YhbtNUekrE3SgJLLtLeEVteT837LEJQkK4x4rvpMskOxndo80XxPtBUtFyejexYDo+4N8jtmYWY
	vZvCJkTnVC7dnU5/NuNKHNjv2BEVAjUx0svApmW34SspUOSEc5P6zTY8jU6pTRS4mRYGe
X-Received: by 2002:a05:6512:158b:b0:5be:50d6:af8a with SMTP id
 2adb3069b0e04-5bfa1ceb37cmr564734e87.33.1792579483402; Wed, 21 Oct 2026
 03:44:43 -0700 (PDT)
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261012011707.3378-4-sigefriedhyy@gmail.com> <179185709988.434549.15422498299449004512@kernel.org>
 <CA+7S2v+LHUWXQMD-cYPEzT5-f3Qhw_vz+LEssQH_A_oqDKtnnA@mail.gmail.com>
 <8dcd9564-e9a3-4b00-93b8-3cb023d68047@redhat.com> <CA+7S2v+rWYvz9xKPEeM6=3HPz3o7TbX2uRfRKk95f9Y60HnEiA@mail.gmail.com>
 <976d815d-a9ec-4fa0-9b16-8e55695706c2@redhat.com> <CA+7S2vLWvQd7GrnwB+B+DiqAgST8EjfWwBKzJXtjGRBPVgmOBg@mail.gmail.com>
 <d3a1b219-84da-4ed8-9d87-5619e74bd1f5@redhat.com>
In-Reply-To: <d3a1b219-84da-4ed8-9d87-5619e74bd1f5@redhat.com>
From: Yuyang Huang <sigefriedhyy@gmail.com>
Date: Wed, 21 Oct 2026 19:44:35 +0900
X-Gm-Features: AclHuK-rJH5v9EVEYVeh2aYcnbIBH6iiXDeQCmZP7VNDudjBotFAAvZQy4bP1zQ
Message-ID: <CA+7S2vKt_n5MyyiG0wf01wyzTW-SUzyyRSw+eui3CL5rx0Zavw@mail.gmail.com>
Subject: Re: [PATCH net-next v11 3/6] net: add a generation counter for
 dev->mc changes
To: Paolo Abeni <pabeni@redhat.com>
Cc: netdev-bot+sashiko@kernel.org, ajay.kathat@microchip.com, 
	aleksandr.loktionov@intel.com, andrew+netdev@lunn.ch, 
	claudiu.beznea@tuxon.dev, davem@davemloft.net, dsahern@kernel.org, 
	donald.hunter@gmail.com, edumazet@google.com, idosch@nvidia.com, 
	jacob.e.keller@intel.com, kuba@kernel.org, johannes@sipsolutions.net, 
	kees@kernel.org, kory.maincent@bootlin.com, kuniyu@google.com, 
	nicolas.dichtel@6wind.com, nickgarlis@gmail.com, sd@queasysnail.net, 
	shuah@kernel.org, horms@kernel.org, sdf.kernel@gmail.com, 
	vadim.fedorenko@linux.dev, willemb@google.com, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-wireless@vger.kernel.org, 
	netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

> TL;DR: please include the relevant information in later revisions, at
> least as a reference link.

Understood, thanks for mentioning the background, next time I will
make sure to include all relevant information in the cover-letter.

Thanks,
Yuyang
