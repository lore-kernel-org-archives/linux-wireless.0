Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 546CA175A9D
	for <linux-wireless@vger.kernel.org>; Fri,  4 Sep 2026 08:31:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.169
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788510699; cv=pass; b=XG+Jx9lb7B4icVsyCuwm5XQOFVN+QCuSojGJePr75MFd48wpz7bLkp5QFKZ6/4q0/V5pGwjLUQCqP0Tiyks66zvybedAJoPmbpT8dl3TqBozIak7R8yPJwyY669LWpWdN+fFFxJf2MiCihbr0LxN7veWiv64TfKOZmDfVqgSRW0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788510699; c=relaxed/simple;
	bh=Zct3tA1vd0s2hqzChN6hFnwvudPWbiHeihh3PxhVjYw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CtvR+p5rjMmr/9FNOEcMxkFMLsISQYuxCGl/yr8TU+o+JKlrxygVH9Z4XmKLVVflkBKrWdUNB/zfbbxfUi4Ve1OVal2GINNbA9VxSY6RoFQsNKsDcmGcvi0CRCloSTuEmqs7zy9z0X5PQK2HS9LHuSAZPv+5rVvxnLcIJ3Xw8MA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mojatatu.com; spf=none smtp.mailfrom=mojatatu.com; dkim=pass (1024-bit key) header.d=mojatatu.com header.i=@mojatatu.com header.b=G/mQasY0; arc=pass smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mojatatu.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=mojatatu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mojatatu.com header.i=@mojatatu.com header.b="G/mQasY0"
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-8487214ad2bso1039662b3a.1
        for <linux-wireless@vger.kernel.org>; Fri, 04 Sep 2026 01:31:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788510697; cv=none;
        d=google.com; s=arc-20260327;
        b=VR8nXevSFvFZu2joR8nLON/zJrYcJHL4ta8rnqmM3vaA1BgffKhGWTr0XxysBkYDYz
         V+hTN4ZQgBaGuIpRi97WG0j5Hz8Pxam7ZY4Xv7PkVs3cLtLdLiZiLh3GTPT4d+EQYUuS
         Le1rjcbSb4tP+6iAMcnxf9CJ4D0H0bDX5YL3xKKS9/SnIQedbl596lJLawe+oW/JyNkB
         H3BIInCOWCFgQiTjTDtjgpSs8JmbuPMlmViXuSZHsH4P2UlzV/QZJ2w8rsqP0GZJt4Sn
         Y8LqTnxQcINjJLCh6ZN8xryIE6pB4VTWBQ17f67cUq7JL9tJAWz6F+06+F8Ury1x5Q57
         qItg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=707kDHdR/FNIPTJBC69xcl2naZm5MV0ZXXSBtfd5zfg=;
        fh=WbzvsWk5GHyAjMbXpkB9tkjSrXLbjA/7RmawAPULsME=;
        b=oZ0rMTjmqXnXAloJ25qON+uq3E4hFzoWxXjJjv2ZdtSyu097Vi3NDQQpLZKbG5LXOt
         Ujkz8MAQypFkUFHXLngnTFVTB+Y3YLpM0tLBnMBagzSt1x7EdpVzi1G9kyRnLIrWdoZW
         PA5BPjlI5UCAwIHqOiIuXmRCu17QH2F6R0myvTDH4w12ckwdL14C1Iuf5cnBqmCs8nvZ
         lF8OdwiGYnGHV+0Pi3CvMRjHsm3/UR6tRpCVx8dFe8vvj/vQDvgkwNqxH+922G3sREWm
         gT5NBPiHRgfezwHqcf/LDJj+DKp/CqmDnGhC7a5VBYVW0ai4ZRotuQbZIc4JiASYjoRq
         ILTg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu.com; s=google; t=1788510697; x=1789115497; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=707kDHdR/FNIPTJBC69xcl2naZm5MV0ZXXSBtfd5zfg=;
        b=G/mQasY0lkxTaqkd/jFbKxrubAv1G0XGsGNvlMCmBi+0qacc/qrMIsQ6VEi7jZuh1w
         4kWfb1df+/30bthZDhJ2o1ADVPTXE0Le/enfrV24hlCXRqI7rsGLJKGEPMdnDuSffuz7
         qZ9O/Hc/9HvRACOoCOgLAZaAZo+tLxwbJaBpQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788510697; x=1789115497;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=707kDHdR/FNIPTJBC69xcl2naZm5MV0ZXXSBtfd5zfg=;
        b=GSjSH/taeYOJ44+flruqGu7CbSQDxWj/fqwEkgRPFim7oLes1j//KQAv32izBJekZq
         fADrupEwQk0yAFIfjgGv9KT4Rv/JkjeWt6SjhWezS/ifeQ67S3gftbhiW3bxv7AN4dTK
         DUndbz4J4agvDuaybpPelUnOGNyM7sxlPb7yF4sqlF91oSOusjcxIRhkDMs/nvKNIxrJ
         LHxRpx/LZqwS/s+/2EmCVKSVqDU+xrMCXTtsn4Fja5CkF2Rawd043/sMxp4RIEuWeHqj
         TOOnGnS3qfiJ1JQATsEGjLtnEqV53GvS4us6gowmfwWqK9XSEK0k0HUl86t1c+vHAU6k
         FvMw==
X-Forwarded-Encrypted: i=1; AKwUvBwZ07/4e4yRHRkbV0FvYJje7XClsr5obGMLLTVB7FyrhVfYZ2Yf6eH6wYQCr7yuOC0slSileaSxB3ICDlHePw==@vger.kernel.org
X-Gm-Message-State: AFuF++kr5URkn5OdC3TfDYzBqab+LexUZZ06K2RZpAhJXQ9Tl37akhrB
	k8aY+ZOH8ZlOOPI6rTo0s9eaF6NSeOuDf5vHo/xWMdBybsv6r0REFi8py1QWtJnBP4juitF8OS0
	2kbzZRP0NQRntEoFVMGkDIoycwGJGi5bfTRLLB7Ii
X-Gm-Gg: AYBFou2TObGWbSfC2FEkFdweZ+d2fLNlpCyRFFQl6UeCD40HQiTkR/L86NxleKwZNcP
	O0qBp9tYiXD0TZvNUlj04/sotmAQj39xP61tikhxMdAIxQlVx0/Ipp/P2JWw6AVGp83rOmsAwFf
	v1tIcO5AMyUr33Q933QQXzyLjfdN9XmmEArdtsPuygeCdf/5fsc99fXzUi4eu3fEpmLWXq7oqfX
	sFJI77Q0uk7+tAAGHHT6Zq5NGecVnBcBxiU82qHcC+rS92JPrlRGN85/43QAK8L1+8PXDkvnRzf
	5hWsHEFAOTkDcyiVORC/epmcNhtjmXtZ6FNU6Zhl8V9o67GTASxZdspeZa/XVUGgo6CrhITzQk8
	cDO/J0hCGVrpIFBoBLU2QcchJVeYS1y/qpQ==
X-Received: by 2002:a05:6a00:178f:b0:847:8b11:5966 with SMTP id
 d2e1a72fcca58-8616967ccfdmr5757402b3a.1.1788510696674; Fri, 04 Sep 2026
 01:31:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <QDISC-1L5H.v1.20260903184552@mojatatu.com> <CANn89iKFVvFaNcZyGOxmyPbpc6ax49ZqwMWDeBAsH5dav-y-SA@mail.gmail.com>
In-Reply-To: <CANn89iKFVvFaNcZyGOxmyPbpc6ax49ZqwMWDeBAsH5dav-y-SA@mail.gmail.com>
From: Jamal Hadi Salim <jhs@mojatatu.com>
Date: Fri, 4 Sep 2026 04:31:24 -0400
X-Gm-Features: AcwNN1UO-DsxSwJBEw1u402haO7sGBSEBLy3v4Unf6zC228XqPGtU0z0wn8jRpg
Message-ID: <CAM0EoMn5M__WHkniZLw8GNtHpTresTC2dQuL6brmAzUXH1YUKw@mail.gmail.com>
Subject: Re: [PATCH net 1/2] net/sched: codel: bound the dropping loop per
 dequeue call
To: Eric Dumazet <edumazet@google.com>
Cc: netdev@vger.kernel.org, stable@vger.kernel.org, 
	Jiri Pirko <jiri@resnulli.us>, "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Victor Nogueira <victor@mojatatu.com>, Johannes Berg <johannes@sipsolutions.net>, 
	linux-wireless@vger.kernel.org, Vega <vega@nebusec.ai>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 3, 2026 at 8:35=E2=80=AFPM Eric Dumazet <edumazet@google.com> w=
rote:
>
> On Thu, Sep 3, 2026 at 10:56=E2=80=AFPM Jamal Hadi Salim <jhs@mojatatu.co=
m> wrote:
> >
> > The CoDel control law schedules the next drop one interval/sqrt(count)
> > after the previous drop, using the configured interval
> > (codel_params.interval). For very small intervals the scheduled step
> > rounds down to zero, so the dropping loop in codel_dequeue() never
> > advances and drains the entire backlog under the qdisc lock in one
> > call - an unprivileged user can trigger a soft lockup this way.
> >
>
> ...
>
> >  static bool codel_should_drop(const struct sk_buff *skb,
> > @@ -156,6 +161,7 @@ static struct sk_buff *codel_dequeue(void *ctx,
> >         struct sk_buff *skb =3D dequeue_func(vars, ctx);
> >         codel_time_t now;
> >         bool drop;
> > +       unsigned int drops =3D 0;
>
> SGTM, note that this line breaks RCT.
>

Grrr.. it was in my brain to fix it, but my fingers didnt get the command ;=
->
If needed, I will send a v2.

> Reviewed-by: Eric Dumazet <edumazet@google.com>

Thanks for the review - struggled a bit with this one and wasnt 100%
sure it was the right approach.

cheers,
jamal
