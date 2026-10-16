Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F3211EB1AA
	for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2026 11:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792151280; cv=none; b=tDy0JUfYFj9RDMm+TkyUggFaYpIZrn2eIU+7guiHE5clIfVNZhcv4LN4gKKc+g2VKJqEpey7JHB2+nTC7go+j/XRI9EuYx/zJCWVyI07+t2RNi/LMWs7Tx5UKbroT9L7kq/giiUOVtX2pWXL+C3D/ShaewSk9MisU1tuyYuurvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792151280; c=relaxed/simple;
	bh=JUDXYjE+085vb/qXA5RYsfGWqhq2Vv8zIRaknoSRtqk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=s86NBcnEbMeDX2wsLoctPm//naFnAANQkCErwYJi1wESiw7tXgG2K5+puV4Lp+bGO7rtxwBmxHBz4r6WqGZb/qt28gnHO2wd/aPUOOAZsq9m2T+d3Txh5Prs3PrXiGRGZTy8jwiRLm4uGtCR3/Wa5JkHZzHDAtE6qIOienizbuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TUcTAwrp; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TUcTAwrp"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-6b1aa377c61so7749032a12.3
        for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2026 04:47:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1792151276; x=1792756076; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=sN9AXA6EqMmnIUQ8CwnmZZw/CdisNxm/jULatVAixaA=;
        b=TUcTAwrp8CosftUxh8RirJuBq3RYlLWem5/17h60yxHsyLw5bSwYIvXv/J+Rt4+BPX
         y5ot6EoupSPvmyDPy/kO1MqTVSRCnGA0mLZ6+BjOGgT0OFJ/3ADcQOKdcVrmWfUZxR5u
         Od1lPhSHuM+BT0DSVd9TLOLKa9ZnJezFkPKVI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792151276; x=1792756076;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sN9AXA6EqMmnIUQ8CwnmZZw/CdisNxm/jULatVAixaA=;
        b=lZJdbOk8QA6fLA/69a+B+O8KmzIwWdhgpqFTWT5SIjdenjQ/p9AaXGz2qCysyNM9AP
         mcOPKleLiI7E26FxrYMbZPeEihjXAkxIh7PsT8b8TusaVbe5DrlpcF5F3Fsp96kFt97x
         xkew2puAeHvEfpz23djgAwGoNSxQPHPnMR+luQrE4z/sK/hauBzM5wsxiQy7jf1bIC36
         W2WbrubF8omN/3aTSChkK7UN6iNIf8JYnkm152j+O1qC0niJ+33CLkW9g0mRs1FwLcgn
         E+k29+ehCXo/aGXGYho/2YLb/5afcWtJ+aWTUsKT7PPgzRLnZwEZ4Gkeo+TM6oomy4qp
         bgwg==
X-Gm-Message-State: AFq9FYKTG8kN2Szl0U8NUAsSJEVixSnIsCLDW7PJwnSF75TF893zjWAj
	4fA6b6FHorCTgdhjy6UMpgl4KfOsYOoNPv4Pi0EfS+MGhIMN+aIKnaJqDvLok1VNEHRMRwssHC2
	PLXXQOSY=
X-Gm-Gg: AYBFou2LyUEHr0roKb/XpsyFoxtMJWQaE6fe1HYKgFCdR1huLXhc0sJe0qyD6+tvviT
	/q5QBsLNfPSeyQ6MIUQQ8U4RVJeEOMWXXtBlS8CJv7wA+EczA1K6Bevyd5KjD6oXIQN6fVfjj98
	M2p3GuZf0lRDqEC2onJlBvO01S5YzMfszTlTU4zNrAkXMpbHUMIqDzyup2eKritgsKQpEEDBglM
	mnTftwcp3b301T/QP1H7iFBiMYH1H2ykcsDlh+8+LogJBkp2YSV14501ALX92AkgRwA/9h+S51u
	YFhYpw74CJH3r827wC4mQtUucnpYQg3TCuqyunblCN3222LtxObk1mGKv2paNLKSY7MqRs5L+h9
	X0TOkwK3iZwhTUjUi62MBkXnUUD9aMEsW6WajAra7Yvn6FFfKTGmJT92L7Ad17a4ay/GWFnieD1
	ixLBJtd1WRyWdpEExqJQfj08dtP3lZt1t9uMU2Hxer8W0PdY6c+jG6fabVQKDYNxXlwvUwg8Z+O
	RMgjJ4CD/wwcxNt7rLbncEj89mlZyqVD8IH1fc73kYOdY6x
X-Received: by 2002:a05:6402:a515:20b0:6b3:9b66:2bbc with SMTP id 4fb4d7f45d1cf-6b39b663f4dmr389640a12.32.1792151276361;
        Fri, 16 Oct 2026 04:47:56 -0700 (PDT)
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com. [209.85.218.49])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b38a1b19f8sm767733a12.7.2026.10.16.04.47.55
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Oct 2026 04:47:55 -0700 (PDT)
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-c4086e892a4so86927466b.2
        for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2026 04:47:55 -0700 (PDT)
X-Received: by 2002:a17:907:6d16:b0:c26:1649:47ab with SMTP id
 a640c23a62f3a-c31a9f8d2c1mr1950016066b.33.1792151275531; Fri, 16 Oct 2026
 04:47:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261016085013.136825-1-toke@toke.dk>
In-Reply-To: <20261016085013.136825-1-toke@toke.dk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 16 Oct 2026 04:47:39 -0700
X-Gmail-Original-Message-ID: <CAHk-=whqmfF3SL=r51KZ72TZJVzEgbMkp5Vhxf_c1fGCyeTS9g@mail.gmail.com>
X-Gm-Features: AclHuK-pNrkTLT4US-FhTlvtT0CJPZm2Y6CTKe4y46HYYxBap8FQNPYdpsrF2Zk
Message-ID: <CAHk-=whqmfF3SL=r51KZ72TZJVzEgbMkp5Vhxf_c1fGCyeTS9g@mail.gmail.com>
Subject: Re: [PATCH] wifi: atk9k: Revert "wifi: ath9k: reject short WMI
 command responses"
To: =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@toke.dk>
Cc: linux-wireless@vger.kernel.org, stable@vger.kernel.org, 
	Mehmet Fide <mehmet.fide@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 16 Oct 2026 at 01:50, Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.d=
k> wrote:
>
> Linus, this regression was introduced in the 7.3 cycle, could you please
> pick up the revert directly? Thanks!

Done. Thanks,

                Linus
