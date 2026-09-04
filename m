Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC246314B73
	for <linux-wireless@vger.kernel.org>; Fri,  4 Sep 2026 00:35:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788482132; cv=pass; b=KgK6krAEakCIorwQKazoFblaavrPbkcYhGuxUwDEy/5gyR3xHPjogo1Kigu6iZFt4s4gXShSmV5wmeXHs6sNvUo1JwQkiU4AJ1zoSC4/8PnfDTRX4pf0kyX3VV2cgLYw9iXJ3fvqHbRewlUFxZmjGyzBtPwrgMFNGmsloTS6DdQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788482132; c=relaxed/simple;
	bh=6mc+ysZ4PjKe5tpOOyTXrXxi9SHfqCj+f7PO2DH/4mk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jsBjEuzdvrLqvk5D2faPI3hPoNRuBOK+2BDm1ZbZjDXBwAcSSM/BpXu7k6syn6v5smwxoA5r34AFnmsz+H41hFw+n+dVXvLmWUD8gu835Y44yweQxlI2GSr1KJ5DAe1EKtLNp8RdUS/M8/i5MxHKHPv36fcFDCTxBt/d2nNpYOg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UlB8TNX8; arc=pass smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UlB8TNX8"
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-5300bdf61d9so6315541cf.3
        for <linux-wireless@vger.kernel.org>; Thu, 03 Sep 2026 17:35:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788482130; cv=none;
        d=google.com; s=arc-20260327;
        b=G5jD0zNizxj3J1O9HPi06V0Fi0LyOb58Kx8XCUJLuQzq+thP+BrQ++w2XqDp1tBNJh
         JbNuGftZ1LplJdHStf8TrZ5MmbUmj1qDlOJh47+Fk7540T40rH2Y1WEDa+jcZBM9kYQ8
         XnGFupWE3WLTNBfeQeNi5CJdPkgGKo5zJHInWkUbD04wCCDBlYQzF23Gr+f2iQTZQPbX
         ukhDPaTGUC2m+0msGNozfd90Z08RAYKHqOsoAiJfnLSgnOrxUixUHMKeM1PsyVz7sR3V
         mdW7GMXaYgn3/bc+ysRjoKl9jhLYoAuBQKIGC5GU9zSLvHobR7H9YANn6VeSfFMO66TR
         gBDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=frzNhQSteSDys2/ZOWWgAmq0ecP55hQGym3yBI7s6zs=;
        fh=lS6wKgH47kqxQk7F9sRiTmUcBViLmTOxjd93azs962s=;
        b=Q6HCYrwMaovZGw8FeD7koNvirKSZ52eq+dbeQacpvHQheo1tx/ea83I5YkdzgQ2VOy
         ZT7Uw7zxNa2cwbtOCnUkrwQ48tyb2Z0d34J/M0UnAfwJENxdfIlIB7qFL8afUIFNwwsb
         WLw5NCf5oGHUCC2sxrwDF/0O1VL3yEhFrcz1xEFEdTxe9dMzPOwnbUyUmYhgLaE1cPeY
         h3v32R/k0TN4PFcux3robNFab0ye+CgroFdQaeyyE5JFjQ4o6rZ48wvfstgaZ+HlrtoE
         5pX7e0uzspQL2LKxHNPDdRRYwjMCZ/m9oinw1adFbXjSGLtWDpdxQ43N97CGwM5QAwRZ
         zSiA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788482130; x=1789086930; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=frzNhQSteSDys2/ZOWWgAmq0ecP55hQGym3yBI7s6zs=;
        b=UlB8TNX8useah/0RCFqkgFZIV1Qir7qAm7MYNuyLColl4lHsLkJsIq9/zfuHS6zJoh
         sswmu+DyF4Bk+w+pxwK1yrGBXvUuj2ZgqamzxYJQWCuKqmp4eyasDG6cjPxB2a/JOfCQ
         OnvDSfeVB+czFqmpCPDXpNJvT5DBC8Dbah5KEdI5ATTMSUAWnWYuPPhZLHK4VV916mbN
         oefWwus63EHI9gIST2KdHqYo7nPyW5TI/AGNKe3n3pgXt9bHE9REVbiDKN4EpgeKnSi4
         HYkn+HFsJWTLGWtkHZPoz2fErSC3eCQVJ0u7+by/odEOzTq+geM9yPf2pzd7o9qbqrPd
         OcBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788482130; x=1789086930;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=frzNhQSteSDys2/ZOWWgAmq0ecP55hQGym3yBI7s6zs=;
        b=sF0yloa0zyibVKE/3rSOz7QGmaVTesNgnoSxP3eCJnMwIMGWQN9ek7SMjifqc4dCI4
         Pwp219KKB9W1OcXtVyuCqe409Db53TGrdWLbynjL0QC1Iw/t43Fwnlk/RRqmgmLl3zqZ
         xtDgVFXI/SEMeomHWf9OObENnCN4kTSRGxmJ9TpCH9XqoPaEo0tvzeO56jQ2ckdUgF16
         ePzZGFxzMjOoZQXG6jMwY8auz2UpWAZypRfUXODXTiT7qtLnwGG79IFOL+hnHwI6+cXp
         v0UdRwAhI98LM2VNpu3/aP4Kd9AZlUUfmBozuSXYiaW4fpcxfTKv1HcgZKzU5cpfPQxZ
         Kg+g==
X-Forwarded-Encrypted: i=1; AKwUvBzb8ffBeueOHYr3U4kf6K9cFS+QVVGXMMKjo8KuxeFb/u9lYEne8fsK35OQlMCVIy/vLgusGsqIg+Bd8QfNOg==@vger.kernel.org
X-Gm-Message-State: AFuF++mPK2UbwmpR7nGXPxsy1msTJFmZBPzEvia2BTMoypjh6bsn0xIR
	1A06EgRK/V9kzRhh9t/2c+ahW4+D6DmlRsvMAAzfNdFRMK5WnrBC1cEhfSI3JZUcXe1T2ySPJpP
	7Glk5Bm0PodJcIKYZNe7+qHqb+D51ZpekfBpGfANT
X-Gm-Gg: AYBFou1Jihn9gzyMGnuDQnRcb1qcdNBzZlSxlE3IBPgFB5RBznONeQOB5EgVEkr92Ud
	IARSne8Ff4+jNo3PGWPB+KYLdCpWh3MsT/qb7qB7LuowwdiN7/2tTzsDxWDnvXFae7545l152yh
	Pjfg1/eUwzNnrAQrAJ7Z8hX/UKEQRJ1Rqb+Na3eGOS1BCyt7i4cLvLcs0TYKq38Up4xkfy8wFev
	ylPnCqBwrzolpnCwqA3aoDTtA4yDgdkNh7KzyM0QLfMW4jsdjTy8LiEWGSZCxp30BqmepIQczKs
	U8cJUIWbD6vjDBn3t8PTk3ngYGOFXIjkPw1XrMbwBLlNuSAg+4hgVdfAKr/y1D1o+JoIOv4I9Ll
	qZOhEMJ/ZA2dY9ea2tj5/jPMJFlswH6/JQ/55cKcQYHphYLRiKwrOFSWwXB4tOx+8N4Kx
X-Received: by 2002:a05:622a:13d1:b0:519:89b6:78b4 with SMTP id
 d75a77b69052e-530549f8dacmr25714951cf.40.1788482128968; Thu, 03 Sep 2026
 17:35:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <QDISC-1L5H.v1.20260903184552@mojatatu.com>
In-Reply-To: <QDISC-1L5H.v1.20260903184552@mojatatu.com>
From: Eric Dumazet <edumazet@google.com>
Date: Fri, 4 Sep 2026 02:35:17 +0200
X-Gm-Features: AcwNN1WZ6JtfBewsjSnHeZkprjED3AmjHmsOyjvG7B-1OWmURvRIgA8rmFLdJJA
Message-ID: <CANn89iKFVvFaNcZyGOxmyPbpc6ax49ZqwMWDeBAsH5dav-y-SA@mail.gmail.com>
Subject: Re: [PATCH net 1/2] net/sched: codel: bound the dropping loop per
 dequeue call
To: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: netdev@vger.kernel.org, stable@vger.kernel.org, 
	Jiri Pirko <jiri@resnulli.us>, "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Victor Nogueira <victor@mojatatu.com>, Johannes Berg <johannes@sipsolutions.net>, 
	linux-wireless@vger.kernel.org, Vega <vega@nebusec.ai>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 3, 2026 at 10:56=E2=80=AFPM Jamal Hadi Salim <jhs@mojatatu.com>=
 wrote:
>
> The CoDel control law schedules the next drop one interval/sqrt(count)
> after the previous drop, using the configured interval
> (codel_params.interval). For very small intervals the scheduled step
> rounds down to zero, so the dropping loop in codel_dequeue() never
> advances and drains the entire backlog under the qdisc lock in one
> call - an unprivileged user can trigger a soft lockup this way.
>

...

>  static bool codel_should_drop(const struct sk_buff *skb,
> @@ -156,6 +161,7 @@ static struct sk_buff *codel_dequeue(void *ctx,
>         struct sk_buff *skb =3D dequeue_func(vars, ctx);
>         codel_time_t now;
>         bool drop;
> +       unsigned int drops =3D 0;

SGTM, note that this line breaks RCT.

Reviewed-by: Eric Dumazet <edumazet@google.com>

Thanks.
