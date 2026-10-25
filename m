Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.245
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792916773;
	b=h5qoi3vIXn1ivD/9vacwJgYj4aXLBR8+qxtp2Rlf+gIo0sDzfZVhOFTOtpTYnJmyeFfU
	 fPfLJ8OgfreWGe+UNqWOXIsIJQ7dBhdjGVdJD0CC1Qe95pzxcgR3RoXYRpYpvYB2i+ZRs
	 4AtYY/e0UpSGer2WY4XR6EQOYSRsgvzdAgSIHUD7oNGuehGan4nFW8UyIBWUCiUUIaHLH
	 V3VFZyOqZsF/SbkYdZXAeGKVzh/4qyupjrX13FgEqF02QjaAoYbej/MoVopk0UQNfUi4e
	 PhGYrjQGOTwhGhJm1ZshY2f8jhuY3n4DdcTzNW+yIGI+/J81HyxBsS+35dzZDoAWkVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792916773;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:MIME-Version:Date:Content-Type:
	 Content-Transfer-Encoding:From:Message-ID:TLS-Required:Subject:To:Cc:
	 In-Reply-To:References;
	bh=2FhkM4JmDjJPWo3Ils4p6MMLkQZfHVKxx6dQ+UyfFJ8=;
	b=gXjpoxI3I2iHyMCM7vQ4C3LYzQ/yXM4L6XxMSJWwrVw4JjC7eIdp33VGzv+PjFTEDy91
	 XwN2ClPV7N+KTNOT/CuGj5QWxXJk7SwAmgUmeli1tvzAt3esbFHgKt6c5fZ+Gu91qheA2
	 T6Ur6B+x8oX0itK+nGkTwH4QUijmz+QUBZYWyghB8m22XfFHSKIaoSy4FVHAER0dzkoZp
	 fSFkcZ81rUn+N4Zd5cUKOeqFQA9s+DVQBZjKv1RgNj8VJYJbwtlPzDg9Kn6uV2ZarfCqI
	 P5JX5oFUbd57CONapmpYVe0Yne4oXFKsS+bWuld4okAvLDs6M8jqSrhq6heGcGCn2dA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=owNtjZhc;
	arc=none smtp.remote-ip=95.215.58.245
Received: from mta1.migadu.com (out-245.mta1.migadu.com [95.215.58.245])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED16F606A31A
	for <linux-wireless@vger.kernel.org>; Sun, 25 Oct 2026 08:26:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ED16F606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=owNtjZhc
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=eB3FnL+2PL+0vJwGt+ksBrgqNIvF60UZwK/C2jmoAp0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792916768; v=1; x=1793521568;
 b=owNtjZhcVnYCmoAU2t7HDdq74lE/kklpH9F0XkdINftW3jwOnHsQQot1Rzxkfj0UBYwvfoX6
 nb26y7vcorUbPvAANxoauO7cPfTCZgvEL2QVfgcYdXfRZLBBIpWd7b8XBLf/0D4jaZK0NJxQazX
 Tgmi64HuYI5SUKdsn1K18neo=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 9fc4d7d8f8748095;
	Sun, 25 Oct 2026 08:26:06 +0000
X-Mizu-Trace-ID: 9fc4d7d8f8748095
X-Migadu-Flow: FLOW_OUT
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Date: Sun, 25 Oct 2026 08:26:04 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From: "Luka Gejak" <luka.gejak@linux.dev>
Message-ID: <eaaa18cd9f23a3731bd1f8f17eb0885d1a17049f@linux.dev>
TLS-Required: No
Subject: Re: [PATCH rtw-next v2 1/2] wifi: rtw88: move the bmc high queue
 decision to tx.c
To: "Ping-Ke Shih" <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <ec4065a1cf2c4d0ea357694a1a73ede8@realtek.com>
References: <20261021124318.15993-1-luka.gejak@linux.dev>
 <ac6d8824bdeb45148ffd6b5dee7da313@realtek.com>
 <5235fd68b703f756cc2ee1e7471339a512db59b8@linux.dev>
 <875b4e96891a2bf256ca1805140b57aeccee4aed@linux.dev>
 <ec4065a1cf2c4d0ea357694a1a73ede8@realtek.com>

October 25, 2026 at 3:49 AM, "Ping-Ke Shih" <pkshih@realtek.com> wrote:


>=20
>=20Luka Gejak <luka.gejak@linux.dev> wrote:
>=20
>=20>=20
>=20> I was thinking, as staging got removed, for 10-ish weeks(until 7.5)
> >  users of RTL8723BS won't have AP mode. So I was wondering if these t=
wo
> >  patches could pass as fixes into rc2 release(or whatever is the firs=
t
> >  rc into which rtw tree is merged), as this would be DHCP stall fix. =
To
> >  elaborate: when this driver was merged it, was exposingAP mode to
> >  userspace, due to RTW88 doing it globally. Therefore AP mode existed=
,
> >  but wasn't working properly. So maybe it's a bit of a stretch, but I
> >  think it's a valid proposal to send it as a fix into next rc release=
.
> >=20
>=20Did you think people use staging driver with AP mode?=20

It=20appears so. I saw on forums and articles about the new driver that
some people were complaining because only station mode is working
because they exclusively or mostly use it as an AP point.

>=20
>=20Personally, I want this goes to rtw-next, but if you have strong opin=
ion
> that people need this. I can pick them and let it goes to -rc.

I think it would be better to pick these into rc, especially since
the feature exists right now but is broken.

Best regards,
Luka Gejak
