Received: from mail-lf2-f13.google.com (mail-lf2-f13.google.com [74.125.229.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8279D2BEC2B
	for <linux-wireless@vger.kernel.org>; Tue,  6 Oct 2026 01:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.229.205
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791248954; cv=pass; b=RjQ7J3s/1BFl3R4bjP0BalEhkL/g8k2G/M7eqpOEmYLbZf7Wl2b05SD/MoLCQ1jsoEQoabTJmn3V0oZsySf6ZirSCpwHEsfdVP5oZNY5buBfEQfM3a7hNy1vuT8raHlMkoVoBOAx6OideX6Yuu79kq3g481u8q1bazTkbhmxEKs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791248954; c=relaxed/simple;
	bh=FQPZMOJ4kPISPNG5soX6XJknF05kL4vWkbTpQ6PZ6YE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qp3tpysTtXTEelrAUPQeyRzsnkrLW8xviLYdupZKppA2QTNjQm96auS3vG04VHchHZU2dn0F1OF19ZmrubRsPF78LlT/fewCey8e4uEKGZE+T3RWv76U+wtdlRNk04ED3ETroFJk2uMV+068c8RnCXQh+LbYZrwttqN2g3F52fE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gD1zBwY6; arc=pass smtp.client-ip=74.125.229.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gD1zBwY6"
Received: by mail-lf2-f13.google.com with SMTP id 2adb3069b0e04-5ba437ee7f7so1830012e87.2
        for <linux-wireless@vger.kernel.org>; Mon, 05 Oct 2026 18:09:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791248950; cv=none;
        d=google.com; s=arc-20260327;
        b=ESZv6V8VqtUuwvcicZjR8filLV73Gpi2N0Uvg0nxvad/cZq3xdRsnY9xLvauFwHdPh
         J7TYDQSmCJ0uZyRSs4WORPGN2jHa/9UGYiByBVJWBHfw60suP++Tl1/mbyQtSiG0uGF5
         kicJ7JO/YibYSD88KzH4ZL73U/oc2PojgxUpXdHxZzUdLa1vDW+J/4nTeDyV+sTc6HkB
         Iu60cuwTxD58DVxUFWeQmHt2GM5pB/mvVyVnvPyN1zpgwz4gSmN84sBdyNc8EKEZAxnz
         w6rH0AJ6oTD3GxtRLcd07hLR0VAscpqO7w9/T4VPpBnACnOQTBB+JsHojqbuTEddjMCz
         jsvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=kkoJa2a5Pb+V2YqC92sylMEECtxCIMpFTVrO4IIataM=;
        fh=t06aOLRQQTt9G8otXhsyqN6qKu+zZhZRSvP+vj45HNo=;
        b=oZ3q0RULvuLseQF1j58v97HRQuEqt78Phj7JwQcIGS0TlK33aRCIrZoaxdFa7EVF5n
         BJi+L29rVcYNfXpAl1bnfiEO+yVaMpzOX792m0vWL8QMQsLaH/TcAE0RP2a8tfWdhb32
         k5Yd2UK6z8h3i3qRPr2v9lmWrPh8MCd0vOOTnuqAlGMkrZPhfveU3jHNg/0Az48P+zko
         JovNb1p1evfasG+4Xubx/2FFJsrWiTA33EzuJ9QLl691he7U8f4j7TZI5k9nBk8hN2+Z
         YOITJK84+piuwwFKc9zpmoqN+F7xSwn4qLy8nTJasWwQm+aEDeoCm7tc/w4zbSwJO9Zg
         IMeA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791248950; x=1791853750; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kkoJa2a5Pb+V2YqC92sylMEECtxCIMpFTVrO4IIataM=;
        b=gD1zBwY63aneQEdRWI9O2+XhnWcnhenMpHkzDzfmr+2Q0LFpCQWs1J5ADzGW0KIPCt
         TOVS/UekxLDmL8+mKDkGKcZoayDRSgPcaYe3huif6OIc4UFMTbeo/s7sE6I0e5mM7VJP
         MLbb856XtAlNuVJ37tpT385z3EfGY9bqI7JBkRjVo2EQYN2brSintBa7xGik1bXmKiMV
         Hj4jG50TAT6qRMV/bAcLy5cDg15aUa8iM0fI3YSrYZKXwKa/2D5HUZuiACWPFyS+n20W
         QrSiwLGMTbXOqMLQ8na9nYcMRMPtLKzWDcZg15qjiZLozv4DR73uHJZy62lPzFmgxDja
         3w2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791248950; x=1791853750;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=kkoJa2a5Pb+V2YqC92sylMEECtxCIMpFTVrO4IIataM=;
        b=Vbc48THkcSdx08bffF4TRony7caQ/R4Y8wqmaZ86BNVhL0Lyg23zJQ5EO1E2Nm53Ox
         orhMKxg3GJYUgxmOhTr7FbvI4UIYSNQTOihtZYtm0sHZIlULMCP9dNXecvKmTHFP4SAd
         TD2JQOQtmLUEq8BYUaB09A8V6wtaBJ1L804No2m0bClvjjSqh4pqMBfBkT/pLVMhX00B
         0mVUf2Tknfc7rKFPSuRWnNWhJ+g1rcUBsX+Qhbpp6IgZy0yFanBdHO5jPzfxOe+3xk5I
         6yQwfmGUGQFAUCtautY6LaZLvtiEmAWwaABJnW8r/scHV6iTa/XZ0U6okukiMFJt4BGy
         FSmg==
X-Forwarded-Encrypted: i=1; AKwUvByBhQUitrTdqkGX4UCRX+KGApyJI7TiwyGOBkvNhVMayQgfCCsneK4Fh39v8LcDrnfAbQ9MDdxAyp8j4pSxSA==@vger.kernel.org
X-Gm-Message-State: AFq9FYJqCmy3YnB03dubQD5woHCDdUpRFoWbyumGuV/nda+CsSsVknwy
	7E5Yc4z7IKFocsh2HsOZRkbshXUpZqrjzoL4EO7UsVQomS7UcP9Ke59ZCShrdmUdFfPnB5h75m3
	MugXU0ZES2TzS3PDcE8+weLCxKQFv/rA=
X-Gm-Gg: AYBFou0LpieunpNX12Mq3CxqIFgSdG2MwQZ9aT+Tpy46TrWoxi9X6iEJ79lk5SXQ3Ar
	IsTPs7Hm1I2qZ77QjGxvX8vYAeHr7E0XwKM48yKjNLBXTlBKer7F1MeD0PvqD2hQCNZm/cFVmIr
	QW6RFS5cGKAeIJy0gKqtPEuA2KzsIFEfvN/3hFu+7Q8eRe+1jfQS/9cNaDPDUYmV6qR20mkDLw4
	oYC6ZH09ggc+JgEpRi29Z0tlRaqsRq5uQekCrMyPaUrmifLuLlln58EqxODi+3X3d/ONNHQLtg1
	nzPfT6s6P38vmhWuViNU+gmI1W4AMQSec+25f/i/x5WbjcxXwOVUSC5VxN1voXjItQuyPFFhbxe
	8elguTAj32dE=
X-Received: by 2002:a05:6512:2523:b0:5bc:b091:e78d with SMTP id
 2adb3069b0e04-5bcb091e7e6mr4148625e87.37.1791248950470; Mon, 05 Oct 2026
 18:09:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260930112842.21323-1-sigefriedhyy@gmail.com>
 <20260930112842.21323-5-sigefriedhyy@gmail.com> <20261005164946.25da19c2@kernel.org>
In-Reply-To: <20261005164946.25da19c2@kernel.org>
From: Yuyang Huang <sigefriedhyy@gmail.com>
Date: Tue, 6 Oct 2026 10:09:00 +0900
X-Gm-Features: AclHuK-bztab4w1lM2DovGlyn5DZ8ZhMm-bLH4zjSTjG2-Wv3eC_T9ovpy0ACZk
Message-ID: <CA+7S2v+XZjnzxpucTBAaKqLp8FtF92cyHBbrQF8G5D3uT3r8Hg@mail.gmail.com>
Subject: Re: [PATCH net-next v9 4/6] net: add AF_PACKET multicast dumps
To: Jakub Kicinski <kuba@kernel.org>
Cc: Ajay Singh <ajay.kathat@microchip.com>, 
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>, Andrew Lunn <andrew+netdev@lunn.ch>, 
	Claudiu Beznea <claudiu.beznea@tuxon.dev>, "David S. Miller" <davem@davemloft.net>, 
	David Ahern <dsahern@kernel.org>, Donald Hunter <donald.hunter@gmail.com>, 
	Eric Dumazet <edumazet@google.com>, Ido Schimmel <idosch@nvidia.com>, 
	Jacob Keller <jacob.e.keller@intel.com>, Johannes Berg <johannes@sipsolutions.net>, 
	Kees Cook <kees@kernel.org>, Kory Maincent <kory.maincent@bootlin.com>, 
	Kuniyuki Iwashima <kuniyu@google.com>, Nicolas Dichtel <nicolas.dichtel@6wind.com>, 
	Nikolaos Gkarlis <nickgarlis@gmail.com>, Paolo Abeni <pabeni@redhat.com>, 
	Sabrina Dubroca <sd@queasysnail.net>, Shuah Khan <shuah@kernel.org>, Simon Horman <horms@kernel.org>, 
	Stanislav Fomichev <sdf.kernel@gmail.com>, Vadim Fedorenko <vadim.fedorenko@linux.dev>, 
	Willem de Bruijn <willemb@google.com>, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-wireless@vger.kernel.org, 
	netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

> > + err = dev_mc_fill_addr(skb, dev, ha, NETLINK_CB(cb->skb).portid,
> > +       cb->nlh->nlmsg_seq, flags, netnsid);
> > + if (err < 0)
> > + break;
> > + nl_dump_check_consistent(cb, nlmsg_hdr(skb));
>
> Why are you checking this on every iteration?

Right, we don't need to check it on every iteration, I will fix it in v10.

> The changes still lack polish IMO.

I will go over the series again for v10. If you have something
specific in mind, a pointer would help.
