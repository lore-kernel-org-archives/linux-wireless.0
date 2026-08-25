Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D58A1A704B
	for <linux-wireless@vger.kernel.org>; Tue, 25 Aug 2026 02:02:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787623376; cv=pass; b=oyKJnu78fr9Oq6Sp52dRkAxZ9+6Hm5HNeGJWdDfISTaSHievPKmqUUhci4I72jt/9CDQVkoIi4azphcSHGAn7D5G089KuYUCcpPMI1pAll516DV0AoeIirDFgmXGZR8urkBz/MlWDR+DOTH8YV0z2SD6xNDbxBPUv5W3RC5tV8o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787623376; c=relaxed/simple;
	bh=UgHoeOjpKMJA7mUZSy6kBez7uuRxoNHSIzfVFhE5H6w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aTVelzQRJM7ntu0m0P/R8drB+y35HChPt+roZAKAkSz7EVKMBieucDqyNy+DBpPgMZ7eqtrHb/01Jeq3yZ7ksg+wxFOCZLGlGXx1G/btZvZVpNhPFwrbzEox2NrIUNcWYtNOzNOWk+OjxgOziaqj6XWLiXFBo7y5S8S6OmHvhJo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lWiI3HRL; arc=pass smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lWiI3HRL"
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-6a1542cdb53so5112078a12.2
        for <linux-wireless@vger.kernel.org>; Mon, 24 Aug 2026 19:02:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787623373; cv=none;
        d=google.com; s=arc-20260327;
        b=J7sWYhFbpu8XWV93xB+Pd7G27bZTtZpxdU4yaDqZW0jPDMRey/FrlB0v85dd+lg79+
         S/aAYGEJOTtkP8A1qo4PhTM5uVX1lSBL5CJ82Bt7TK4Z3vrORAFJb9C/SRvofW92XDwc
         4b8qTl99Ypg+0Bxg9OaU1Lcf1fb4gQedt9+7h587XrjKCt4E/tBbMLQXIXiu2d+IczR0
         kBIZb6g54CQl0QdiU63os9MyIZMd44usm4ssV7EZPI3AxQ5GuHqoOAgFy6zEaSGc7LjJ
         JYt8Uzz7i25fYsLomKLFTgF/YP2VMuzqUa5NhEg2XtMQ8FpKI4X/2lriiXR3C10S3i+Q
         DzuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=UgHoeOjpKMJA7mUZSy6kBez7uuRxoNHSIzfVFhE5H6w=;
        fh=Yabq5cGb3tKtZsDl9qYRBEojaakeItLILH8JMK5v604=;
        b=soXCp08FrenvXFL1eCd2tNToHnL1DcT9rvmuaZ63ouP14mWnAg+hJJm5ZhClJYn94j
         1oTsvI04vVV1iEENr8GU8GF3czsTGuxqOfUsWwf88qF9v7Eh5/6B6OqFar+5d/N2Ahwm
         LuIdewuyN/7EBGKzY+5VIR6Q35WpoX6DrA02iEh3iNM5Jcwgcnxt1LC7qxG9pEAoDcpE
         gLKMFblUX0AhfNwQUXuJm6OyDBLW59ITJ1LWyYyRfgf+SCaD/oridZyK9v5bEhrzjjRJ
         XRaf60Y31R9i4igYXaZhLNAcKxcRm0+daZ1+1u/IFR7UoOSOHGETczMPq3sYz46p76OU
         rTyg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787623373; x=1788228173; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=UgHoeOjpKMJA7mUZSy6kBez7uuRxoNHSIzfVFhE5H6w=;
        b=lWiI3HRLI/zmVJvyc2iBXFY6Uwr1FQz2nASparcOo67HuZs82hTHIDA1WkbptZyuu+
         pykvmHyBcoH8wHZfRHeTgnZB63nsEj2HGugNjZjgHn78aUbaa187/UfcJFYNVV5unQ5P
         A8hlf3KU+TKlnlSfNkJgCxlEZIl4BD8N1K8PC9NyN2gSA9yH0krhtjYJrm/S9tT6IBEQ
         BxFL11K3pPu2co/xBwFWtcx40A0R5KFqXPro00LXSuhgFoI+9L2wLMrL3fR4qUDCWtG4
         ilZTgQF1QGcB7TgkUXx8zMTtZjyEfCeEbzK3pQ6RNl0zq1L0BBrFND86JyCQfSsXjD3Y
         UgrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787623373; x=1788228173;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UgHoeOjpKMJA7mUZSy6kBez7uuRxoNHSIzfVFhE5H6w=;
        b=N8Mx+MMVt6ySNedGVCCLiOaLKw9C+HHV5ybSAmcMzQJHGqCZJVczcmHBdqaX12DnMo
         WpvqgvDIxVyEV+S5dhK06TFjxVZ30AWpvxkZTdhu1MO/ljJKzLL9Ta92GbGubcdBIKYr
         QMPDU/Br/bBg51uJdNwjJcgzJwxmUy0zrjqnvJEJCbV3aO609oFwxLc1eyS4KK5ThMwO
         c+hOQJlzfbUsD5PVKZ2XaozAmcIey9HPeRsFcVC1e6k5dFZCpXD+Op/KToS1qB8tNBvJ
         ycZCmutqQwMwooh4mMC8pwv3w45dZ4YoKjS7tdFhJJlnyg7LqSwfvOgXz/HlFye5NDsw
         yfLg==
X-Gm-Message-State: AFuF++khX+2zBBI3Q0I5Rhu3n2HGM4myi+TxNWD4BdCGDNHPUUpfkC4U
	pbZJUFd+mNeIhAPiutNbh/TRBjtiTB9eTLIMJw/Gal+K79ArEDP9ForPHSVuE4lZDi9aTi2LOnh
	xMQvhoTexZuxKCXF0vtE5oijKex4E2BGzrQ==
X-Gm-Gg: AR+sD10DaaouTu1sSzpDZBtXItgv+IDhIVbPpQL0CUt0RKoFEVSDj392P8qvcT2ogLE
	2V4vAzNN1coahs6EYVxpZz5DX2SS1uKAqDVgWxRcIHLRsueRnfWSE0X7dL+GgqEcZY3yVoI1L4B
	/V5zKjahRh0v/1Bp7dmNXX9cGlPo+X5Ux7YakfQPWsqPJsdiL4yjKq/Y0eKyoEpFshoDz6QUsH8
	84VR309tThx+iF8SMKR7uPq0v9l4+9CmdzNeWlT3eCRz5HV0LygfChootEAfoFL0GCS43vGy1lj
	egevmlm2AJJsgl0gvCmH7BmAjlPSueaiRpQ5kqLzkbpRLw==
X-Received: by 2002:a05:6402:3224:b0:6a1:fd14:8832 with SMTP id
 4fb4d7f45d1cf-6a582b75aeamr28112975a12.12.1787623373188; Mon, 24 Aug 2026
 19:02:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260824070730.2089862-1-wens@kernel.org>
In-Reply-To: <20260824070730.2089862-1-wens@kernel.org>
From: Ping-Ke Shih <pkshih@gmail.com>
Date: Tue, 25 Aug 2026 10:02:40 +0800
X-Gm-Features: AcwNN1WCqIAYuLFHfMK8FerJDJO31a9qqA0CLcZEfBDzqQFP_HA8mVYap7UD_0g
Message-ID: <CAHrRpukiMAvgozT0bVidjrHZKxuXX7hc2qYy3fR-TA8W+ihFoA@mail.gmail.com>
Subject: Re: [PATCH] wireless-regdb: allow 320MHz channel width for Hong Kong (HK)
To: Chen-Yu Tsai <wens@kernel.org>
Cc: linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org, 
	Ping-Ke Shih <pkshih@realtek.com>, Morgan Wong <pbodq2@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Chen-Yu Tsai <wens@kernel.org> wrote=EF=BC=9A

>
> There are no restrictions on channel width. Allow 320 MHz channels on
> the 6 GHz band for WiFi 7.
>
> Reported-by: Morgan Wong <pbodq2@gmail.com>
> Link: https://lore.kernel.org/wireless-regdb/CABzKGg0YEm5PfW9YtEM0G1SYY6R=
D80DmFpu_Jpb9hoioK+tH-w@mail.gmail.com/
> Signed-off-by: Chen-Yu Tsai <wens@kernel.org>

Reviewed-by: Ping-Ke Shih <pkshih@realtek.com>
