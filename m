Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=209.85.221.174
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1792538363;
	b=nf7/G+dIc/2oxPqyW456HoLWLt2/UVJTqTg12zzJIzZD9FRjgbZFx9HUr73aikp1q4gG
	 /Es2Ibl5pr7hB0U/YIG00OsDF+ZMyRK0KYg5kRrRyyP7czS/PxbYKdGF7VrM+yGok9Qgn
	 JuHrR1jr8RIM6jgEV8remnRwCMSMRxqKfrSpmoWSdO4m170c93cam1MdJZN8cdrPGt1g6
	 CRCfc9bDTMYUJFfIXtiOXXnp9D/VWBS9w1lOHdsiufgZKoahlGhQd7bO3SX82k2dxgErH
	 Nox0jkO94Ah6jY7trhc1uG8yJ+92Tf43ECAK6udMjRPUisUvwcXk+tyeYwIGx/idYHA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792538363;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=3uU5xVP514mUbrG42KDIZyHj9BphlxVL4c20+8k4/iw=;
	b=DmuS9Gbt9TgUX3f/Bn5D6reJhRNKuaNMAeb7tnrv1dEbhZusGloJwtsyyiWUinMruLKB
	 90f8bVgnrEktWfERYFTqXYYJvE+rBOczOrOgn9elrtXKC1DntYyZYczPxrT4v1q+QrEu9
	 KKPGdaMhyV2Idn3XfqFhSGB9TZacop5wio1VN4tB8meznOkRVx++uh7MajGSp3cfbiVq6
	 MSUuxYNaSHqsmV4+WNFeOgsbDAjqAGr07p+V+N2WReY9YyTUIyvHxgko4ADfYLxUfHiLv
	 SMOh/3+b+s5mfGwfXhsPDcgEg7ZxiZS/o9gKa5+tbM77VDAMaK64dqaoIcfh0tVD6kQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b="o/mCkYbj";
	arc=fail smtp.remote-ip=209.85.221.174
Received: from mail-vk1-f174.google.com (mail-vk1-f174.google.com [209.85.221.174])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31074606A319
	for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2026 23:19:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 31074606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=o/mCkYbj
Received: by mail-vk1-f174.google.com with SMTP id 71dfb90a1353d-5eac4855401so37092e0c.1
        for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2026 16:19:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792538362; cv=none;
        d=google.com; s=arc-20260327;
        b=EZ6yN/31CPABApj/myZVv5u9r6JFtY67nnlecxTEZwEOqf1NPWTAQWzsIChGGo5V2W
         Zkijy2JJKPRugfvo+KiJi5z15jMnCDeyamlos2KIj5z2HjNGQSN3jAMGSqqmzaorZCDH
         DrXWG5I/VbsnGpa2BAxc6lHj5/7ISS9SQqr3HtOzGDgf7pYzgax0oT5Vcz5ppWu3anWt
         y1rTZzujPbm5g5PXlaH1CwTQorbXIY6F/xX1wpchhnM+xvrXDe0D1gdzWyBpxOX9FqWm
         lLU3typhhoe5RP8oBnwDJwbSK8yxNeK0u/Ii38hNOtZA48tB33POXEbbOHsghMvFUd7l
         lUvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=3uU5xVP514mUbrG42KDIZyHj9BphlxVL4c20+8k4/iw=;
        fh=Qni4N+/vtu3pzJ4JuHMGP55MzwTbHmsS8X2SgCEIxEk=;
        b=TTkSKjkNwgSGMYOpMv1dvBerU0F3kXUzxj3YGXIFYeQBi9NLAunmfj7fVqWUsvwpl7
         YXr/GPPX29cYJmwQvoNA3A08a4WUmW9F0oDOcpE6X/7sPzmqCw5YsDkwL3S8rhgKd9/m
         5R+HxdH/YQHIbkqMejATyREesKzMtjJkqFYFVEYS8yc3Xq22yza0piqFmOopK3cnl6E3
         pM9YoYD+6N7++q5B1JYSHhrC99GkDtlcDyhL7CJWSKtRaccXhI2JVxErn8JGlnlu1sSl
         600SAXX7cL/t49BqlxqWm+Q/L3sdfFWlKMenkeQCQA/QoBjnCnjyuKghlft/gcZWgVh+
         1RpQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792538362; x=1793143162; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3uU5xVP514mUbrG42KDIZyHj9BphlxVL4c20+8k4/iw=;
        b=o/mCkYbjeY34X13UKJqUfc1LQSsmKds7DQlCX8Xv/aDnCKR/rijpjytefciSov8WXn
         7I+TplU1+FTIj5BY2L9SuUgrdP8zwvkNoFJNGWBrMe5zk6FUKTSktKtX6S7P5pt2HEDh
         4ZLwCsSC7622r/kwX7/0yND+BKIr2xwjAbHg67PhzeOfpjYONYl2bHJSSsG8j0moGUO9
         SJsuO2K6/Ll34vjm5vG0xf0OmefKbCCTurKvnAT5UXHR6vChEPnxIhXl+FQof/gIWxie
         kD7hx8Z0e6/EZEwo6QhOfRG3nR9A5PT2bXfFa0vK2NN7IPjhBr9DMuTH7q8Vo4pQFFge
         8LCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792538362; x=1793143162;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=3uU5xVP514mUbrG42KDIZyHj9BphlxVL4c20+8k4/iw=;
        b=eqIxYgmg+vApYfOpiBkSQ1c1hU4nTDDUjzj6HttJ4PuJFmN4C3/39xAi/h2t4EcSuk
         xbrJO2BqdxBuGD0FTLDnrZsLFHcsJkNL2OK9XnWQJ0GHOGDB1E4h2qpRM2jFz/lbX96O
         69zqIpm9mF4htZUl3E+vMgwA2jHGswyOnuy8vg294g7oweebC+TBEgnn9SNmT0jkKtqx
         3M/x0vQYRoG4sbNi8SpjdkKD6P0aHA7eNgH9ebCs/GtiA/TszNxwgmsE9T/zn8OB8o0v
         h6j2K4bgjVXWZouMfIwvYjDRgwQxmZrOAXUhL90ukvZ8rQtew9Rwyf5iKzPoD/EA7Rs+
         bkpQ==
X-Forwarded-Encrypted: i=1; AKwUvBwnMYEqtU9H+w/hxZnfo2aJLSoYwRFBMpEWgDb49TyMKmLYAsQCZluXydfDWgZfE/i5pMzKTTEUb8m0os0TPg==@vger.kernel.org
X-Gm-Message-State: AFq9FYKxtOi0VjZLyuKJNAotzKaX/I5LZ3BHKAIAxnhWhJmUi05mWNQg
	jcjRTCBAiw/JTT0/Vr6LE6Ewnmg1aNpNTh3m8rlYUb65pB20weWLPh2HnTgd11xRaAAV/ippFDz
	opitmGJjOICXqyoLOjM451G/dv+BmVJ1bKB6wl7qXig==
X-Gm-Gg: AYBFou2q3LFkfDGAfJ8Fdlhy+Q4HWx5HNJBJ04wzzeFpmDrZeWLowXKDD38MXYgYIZQ
	NPr/fw7PicTSDXmYxR20drUxRDEBJVGjn4Ox/CwOcL0byxpI+LL7ZtscGgyOyNDhqWil1GWL0bp
	Qj159ITZv8laZx0gaSqmeb4DJ1cf+mStFqTDRf++hLoE7FX7zIY/t/QCnrO38a/1//r7C0RcHoW
	TquoXi8novGfI6YQ+942MOq0sQWuOCdHOMTA302x2llEqgmUL++86qFSYflIMLP0owSFrBn1ZAq
	ww7QCkbLUWhLPvbnA5jEFhBsGhltlUVsmrcf+1PcTtmPHqZj4s5nap0ofsI3z6n0NJtWvXJFRwC
	y6QgxT/MvTyh4WoVDAn95
X-Received: by 2002:a05:6122:3c41:b0:5ea:a173:65f4 with SMTP id
 71dfb90a1353d-5eaebdbde23mr117013e0c.11.1792538362059; Tue, 20 Oct 2026
 16:19:22 -0700 (PDT)
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261020152412.95560-1-mike.michalo@gmail.com> <20261020224644.3858280-1-mehmet.fide@gmail.com>
In-Reply-To: <20261020224644.3858280-1-mehmet.fide@gmail.com>
From: mixalhs <mike.michalo@gmail.com>
Date: Wed, 21 Oct 2026 01:19:09 +0200
X-Gm-Features: AclHuK-7YZ-INOiAiQfigqH4orU9yhv8_40k6xqUsVQsalHOxRswe7LmiUqLmVw
Message-ID: <CAO+rqLgp8ZfogBbOu4rD9N9w9=FdNO+wXca4SR77NV73EGpOmA@mail.gmail.com>
Subject: Re: [PATCH 0/2] wifi: ath9k: fix WMI command response handling
To: Mehmet Fide <mehmet.fide@gmail.com>
Cc: =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@toke.dk>, 
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>, Pengpeng Hou <pengpeng@iscas.ac.cn>, 
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, 
	mehmet.fide@screeningeagle.com
Content-Type: text/plain; charset="UTF-8"

On 2026-10-21, Mehmet Fide wrote:
> Tested on an AR9271 with firmware 1.4 as an AP, on 6.12.113 with the
> revert of 93ce8ea70451.

Thanks a lot for testing this on real hardware so fast, Mehmet, and for
covering the duplicate-response and sequence-wrap cases too. :D

Michalis
