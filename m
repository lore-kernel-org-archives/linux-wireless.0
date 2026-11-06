Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.248.207
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793948884;
	b=rrteD9Qwx5kSt+NrgygvyF/6dtLF3MTj3fzCrvibULYl/J0yX1a9TOe3OvxH4MClKdMt
	 VT/+D7f2ODpfdiZmblJs7/+j3rqjnTxijGmZdfmv0kmnNUYGsiBDP4BqHZRF4NLmSsxgD
	 lM9Zg000Bffb0o2ZeUh/cv6XlGP4pyMTnEIuD28KZdMP0Ig/DiFhkkBD0nRR4YaNZcOlv
	 80IeBhYUYzP7Dtx1M52MNQpFY1GPppgBrvIVQ4ZEYAxd/IDaT0PjoFdHk0QN2UMsGajTp
	 kKjmMaAySi0rIO/18ZyYDZdyKqaXXQaUWFpOdUAq97LlmuFne70+EvFt4b4CsxK4KTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793948884;
	h=DMARC-Filter:Date:X-Lima-ML-UUID:DKIM-Signature:From:To:Cc:Subject:
	 Message-ID:In-Reply-To:References:Organization:X-Mailer:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=3XpOGU15gV2kkiX+x42/xqlgDds6kH/y/8TzU6FkmFA=;
	b=Xe8lUyogV7wIB5i3XdL8vhCXj+J5jsrIDPsBToVnbhb+wykT/Cg1AdICNsf9Fod7mgxK
	 /wzkm7JWBMcpQUOu0rRC5u3LOgRIN65imMROQ1vY0Y8jU3sgkjd+1kzgqhF7YlmjkC3lO
	 2J8EIJsBd9sJHEUYdvZ9Eiwx6FdbZ0Mc3hHTmidCr/7L22JT1Da2HbRmrbKTBzNsHVgo7
	 vmEJLror9Wep6dzj8OlyPtQZ+stPATtCR/WuqXjRU2OT1o5I8UNrDHjfU7uFuLL4eklV2
	 wguYtHZsJ2KsOXWQTzk8zCYGJgiEgwMilvGxAeEFgowip5Js3jJ9y5KEBRIYyw1r6Cg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=deq.rocks;
	spf=none smtp.mailfrom=deq.rocks;
	dkim=pass header.d=deq.rocks header.i=@deq.rocks header.a=rsa-sha256 header.s=securedbylima-20251205 header.b=Pe7Mincx;
	arc=none smtp.remote-ip=91.216.248.207
Received: from mx5.mail-out.lima-city.de (mx5.mail-out.lima-city.de [91.216.248.207])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6CA1606A328;
	Fri,  6 Nov 2026 07:08:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E6CA1606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=deq.rocks
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=deq.rocks
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=deq.rocks header.i=@deq.rocks header.a=rsa-sha256 header.s=securedbylima-20251205 header.b=Pe7Mincx
Date: Fri, 6 Nov 2026 08:07:51 +0100
X-Lima-ML-UUID: cfddbb30-81b9-4b82-812e-7f150fa52ac4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=deq.rocks;
	s=securedbylima-20251205; t=1793948874;
	bh=3XpOGU15gV2kkiX+x42/xqlgDds6kH/y/8TzU6FkmFA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Pe7MincxXYE/sg2TCk1Q28j/egaMNPo2yzX85iwCThOMdgAvqpu82OK2e+aPI8+9s
	 Jp3JIKtUGSJIVCuXvswD929IUz3Lk+ub97Qaw54gcFAJP6X3RjHRGtW6xx95LdOXGp
	 60LGzg9o4KwXBQxSFx6CzGDblbF6wIY4FB8LR5T2OabzXlVPFwM6yFdPGUPo14ySzC
	 lv3/WXJUWTZbuFhebfeuQATFMLjj4OX5Rvw61cX5YBFJ8hNXKRONV+gagZNTNhYsbF
	 PgmyAGUSBAZilkGfJxUTi/UHRjWRzf6PxUFf6pB68IyPzNPsqaO4+wAcXcZmOyA0T+
	 QdQWNtiEdLy8g==
From: =?UTF-8?B?QW5kcsOp?= Eikmeyer <dev@deq.rocks>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: <linux-wireless@vger.kernel.org>, <brcm80211@lists.linux.dev>,
 <brcm80211-dev-list.pdl@broadcom.com>, <linux-kernel@vger.kernel.org>,
 Aditya Garg <aditya.garg@linux.dev>, Yossef Osman <Yossef.Osman@proton.me>
Subject: Re: [PATCH 1/7] wifi: brcmfmac: match firmware capabilities as
 whole words
Message-ID: <20261106080751.4c37b14e@kait2en-mbp15-1>
In-Reply-To: <1a1acc5e9b0.2873.9b12b7fc0a3841636cfb5e919b41b954@broadcom.com>
References: <20261104151547.70333-1-dev@deq.rocks>
	<20261104151547.70333-2-dev@deq.rocks>
	<1a1acc5e9b0.2873.9b12b7fc0a3841636cfb5e919b41b954@broadcom.com>
Organization: KaiT2en
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-redhat-linux-gnu)
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu, 05 Nov 2026 18:33:34 +0100
Arend van Spriel <arend.vanspriel@broadcom.com> wrote:

> Nearly identical patch was already accepted in the 4388 support
> series. Dropping this one.

Thanks, will rebase 2-7 for v2 as per mail earlier.

Andr=C3=A9
