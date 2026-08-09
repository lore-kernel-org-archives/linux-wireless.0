Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD7B2306741
	for <linux-wireless@vger.kernel.org>; Sun,  9 Aug 2026 04:22:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786249345; cv=pass; b=LKc322VxW5QabhVKEMnKAsN8FaYqk8YZoirnKRb7GXZOb3QCfyFvbS5QWJFSNZIpdoIth0UjrEVpN08VDrTGmoe161N/aqeX0Gz9iwCL8wP4oJUjW7oJwhBxdvnLAaQIlajCTuHgR3fgWwPimbS1tqkOBKdp/YtBcOYP5bS9a04=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786249345; c=relaxed/simple;
	bh=qvruJbn4oU0Zn3xYlwL0kiQV3mB6QkY/2kDskhbPhiY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fkhLn6Hw/GbpgqOHY6HZZkaeGfWw3rC1HPuYhH1zowMjC9Xthx7rp/HywsaZaLiFuV3EsJDNecKLeIsyHDBVBcsKwGf5jPwWx3tnPMHQ5NBoJAe+OR79NHwNt5Yzil7JBPOaFKmzgJMRENwyCsZnCDpmSj75cQQhdqS0o3REYCw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=h31OvmVq; arc=pass smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="h31OvmVq"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-6a18af264f9so161961a12.0
        for <linux-wireless@vger.kernel.org>; Sat, 08 Aug 2026 21:22:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786249342; cv=none;
        d=google.com; s=arc-20260327;
        b=PAwUkGYpdltrcwqEwVLcE71lDqEZwHF4RLxlpMB354keF9LEb9V/JiS8UcwcAdI4lv
         SPow+yeP9fR4efLLjAd6q/XeRp01qKqjKpx8Qqb5iBETxqnUcK4u2TrnPh55b0RBSZON
         bl6pSDoigsRdXFO7ivDwNrJclWO3fD39KDBAGTAzPMEUaBl1fLcTICNxU5Lb769q5NW3
         4Rea6Xpg3Mx4p5kv+5JxgnbZEnTwUf7RXqWYonRwm4tncCDattGKJWr+C7GEtiizHjg8
         FKnafBVZrE7I4LLevnm2kmsymdQEjQBMqw0N/HgG33LJ4yzJEdsLWZF8mLl32+Mvzy//
         Qybg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=qvruJbn4oU0Zn3xYlwL0kiQV3mB6QkY/2kDskhbPhiY=;
        fh=ZS1PzuDaSBRrfUbFIp52DxpIM6r9UAGY66vTeJXmclM=;
        b=U7kQaB2NZi8MFA0ZLR9rikDZ6dTJ5Av63VqxNXTjS1oHIF8iNaExRQjuNwFp1gbHHu
         UlH9ptlg5QU/VPOkV52QQMB6vZOfN1Wifumvwogf9Tn7jVA7k+iaGzWdUJU1qNaH91Bu
         aFTlVrrZqJ8SEpebZrffaeT2aGrxDOF9GDUvvcIK3Qkvx0JhtMgppDCxfSGZZHnnwII0
         EHVkZ5U/apX81Uqh0zQfJud40b/cwfItYtzfUpKIphpQuYWbAdxPslxJVOY4OIWxrdeR
         mS5uR5OzLX1xcmYSkOwRahyyI3w2K45SqAyrUnYaoRfRQmobgjP7fgXesvzIwUC4DgZf
         le0A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786249342; x=1786854142; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=qvruJbn4oU0Zn3xYlwL0kiQV3mB6QkY/2kDskhbPhiY=;
        b=h31OvmVqIKlqpaTwS8wCMws5GNRCHd2uNFGVG6Dblhg2ZVFoe/dNrmghhunIrGn4s3
         OSYat5SFdyzt8woyGTL0PChZg5nLYXw/IuVXzOqWCrxdjKOtE2VydRuc8L7i39oTJJPB
         j45prO4bTUTGzjg+1v6hGPyZIpd4ceAUb4R/GHRV/HJSTywzkQpSwdiW42tlodE7YACB
         lqfUOPkq8w4+1ZSoHQS+dMb0aSIrt11kXc3WHaUcHelfb7WIW4pxfYSd57ejriHt+Q1i
         G3FKAwWsh84v9vzzQly5HamILlEsUiXXXl5GyoDYatFC+uieD38nqEkj4Gdaolu+ulhr
         U6oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786249342; x=1786854142;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qvruJbn4oU0Zn3xYlwL0kiQV3mB6QkY/2kDskhbPhiY=;
        b=evVaKFQMf0+gUxPzxashmbsbmspOEaLy8Tqu3oUcBhwiP7y109sWMRYdFGI3FlIIAi
         NUo0ruxdOQq9bxGXg3uZT0ws9XrNI0u76eyY4NvQ9j8PTpfMqLaTj4pam3GWX+rvv5dj
         OfegttdN0RpebVGzbcv7YzOO3p3piCDzCHJlC40kKZt/URDMJD36l3mKQnEVWR7ImaiE
         6HsBDIM0nzp5HOkrJPUgN7lgCJ+LLfDwD2UGKK2dq7HDuux+rZEJlxUio+wFd3p8IYyW
         ghcyZFDYJ9cCdkQxAa7ZWnz89/hZnRW6T7DFCxP2msZbU/9/llsYmJ+PHrbdHc6HLdO8
         HFtQ==
X-Gm-Message-State: AOJu0YzxcSK8wrKcpihCytNi2wUQihVhKs0KquYp6kuzzTEg8dxdcKDS
	hdlhvrwpcBOt5fFOIha1guB5annS01tdxxc6RfGWJQPwCF219G+Zw5UBBFGFo2YQdktv2SPcCBE
	eowA5ugYfAxBRGQtYY1nO/LFdx5P6pBA=
X-Gm-Gg: AR+sD10l/IZehfPWzjP4ZUVJLXDFkvkLSvIcBXuk6G7+s/6/uv8M+mM0D+HllWXfWFA
	JFS8aFYoyKMPxqTLqnqt8MNoq0fkfEo1D+k36KokvF9FXPO6cGoyeEJgcoObxgE6Q8TgYctCICj
	UfGTT8HQp2fqm+lWFuiNOV4apuiwUnIYP6o/DuQX8rXjIBTUUqlvhy6eOOIrW3Z0kN+rbWeJfOT
	OTvah0COuCsomPcMtI9zQHgZKpMN7h6BWE/r4peb3lGZ7xfKXOuVL3WDgB2zqQRGKMm8k/QUCd3
	6YvnBs+HPZ/5h+1u/ELMiRXO5mxH6yeZaB5TrWHb9Fzvk1qqHp16pQ4AUHGZmA7ogyV6GhL1VN6
	nfvBQPAnJ7ShlPXz9y9nqefY3J8s0WLGR5TW/qj/iunU=
X-Received: by 2002:a05:6402:1cc4:b0:6a0:d411:930d with SMTP id
 4fb4d7f45d1cf-6a14f25ab6cmr9290589a12.2.1786249341897; Sat, 08 Aug 2026
 21:22:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260729053408.13715-1-bogdan.nicolae@gmail.com>
 <20260802083905.3819981-8-arend.vanspriel@broadcom.com> <CA+ORkNSS1dOdUK51B0Q1r2Htc5NpP-=EmE4FO6=4rX5CUU_FpA@mail.gmail.com>
 <19fdfd09e38.2873.9b12b7fc0a3841636cfb5e919b41b954@broadcom.com>
In-Reply-To: <19fdfd09e38.2873.9b12b7fc0a3841636cfb5e919b41b954@broadcom.com>
From: Bogdan Nicolae <bogdan.nicolae@gmail.com>
Date: Sat, 8 Aug 2026 23:18:26 -0500
X-Gm-Features: AUfX_mxZwkkOwQUmElQobA1zbDI4ckmvogv5u3DPXO_DUibGSTN7XT2bldDzmCQ
Message-ID: <CA+ORkNQXRKVzi1NN9+YmsQ26dQNNMMu=uBZQ7msQTDG_CtUP3w@mail.gmail.com>
Subject: Re: [PATCH] wifi: brcmfmac: configure SAE PWE method for external SAE AP
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless@vger.kernel.org, brcm80211@lists.linux.dev, 
	brcm80211-dev-list.pdl@broadcom.com, linux-kernel@vger.kernel.org, 
	Gokul Sivakumar <gokulkumar.sivakumar@infineon.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Aug 8, 2026 at 12:20=E2=80=AFAM Arend van Spriel
<arend.vanspriel@broadcom.com> wrote:
>
> Op 8 augustus 2026 02:00:22 schreef Bogdan Nicolae <bogdan.nicolae@gmail.=
com>:
>
> > Gokul (representing Infineon) promised he would send a patch a while ba=
ck.
> > This would be a preferred solution as it comes directly from the vendor=
.
> > But it also takes time. I can send a revised patch next week.
>
> Yeah. With Johannes being on vacation I say we can give Infineon bit more
> time to provide their patch.

Sounds good, Arend. Gokul, I'm available to test/collaborate, just let me k=
now.

Best,
Bogdan
