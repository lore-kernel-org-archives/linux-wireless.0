Received: from mail-qv2-f39.google.com (mail-qv2-f39.google.com [74.125.230.167])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0C043C5522
	for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 07:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.230.167
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789545278; cv=pass; b=P+MGRuo0d5N2qpsEOYJN1vJ/7FuGbpvCOLaO5RSU2ldVCeCVCDUQBOTjYETHI/zYPSx/Wp8Y5jTD4aaexCt8OZJKbODOU/LcsI3UpU1xgLB2qL+YMlAR4mMC7XcPSA8Z4PYGK4ZfGrVr2nFYwlsUxcPDOLv9S2vYXQp5EagETOY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789545278; c=relaxed/simple;
	bh=HSQtSh/WBX64Az3Kdhpb9LI5nsWLBxof4MszIZvqUt8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ICgosAIgku2k/jbya21oqK9Rx/hZcDgtyhTEGcZaJxrdhz0pVnIsAyGPCUwQC6d6BBSt+itWWCBkVGj6AadMBiwmkx4VKbyKnChXxefZeNO2qbi/i9JUYb9TnXWMfPFj0fPRGz+7IRBfvtrQLxSw8FCcXm1Rcy4Vl623paAd7gE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eKzCRijK; arc=pass smtp.client-ip=74.125.230.167
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eKzCRijK"
Received: by mail-qv2-f39.google.com with SMTP id 6a1803df08f44-90cdfe60d5fso6340926d6.1
        for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 00:54:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789545258; cv=none;
        d=google.com; s=arc-20260327;
        b=lDO26URh7A7uNAIGjf6y78GeFygf87Ba1Hc408Qh5JiQAi82J48HfZ79VWhud4wn7c
         2Y8X8d9L79LmLnRENXDqyMBbjg1+8wqsYm4VM7WXD1ou9MivYIJFzdAFrJ9SeNf1M3ql
         Wi+xF+ujlkokaQP/I06xEcKLbe5Rd1z78WcaEiluSQQScfWanI7un1+Nxq2tx306mQU7
         O6/qqQOwpsoZfcp88k1j/4rvhHkQLQbYDo3c1XUtBCnLF1zuEzS0fGl6ijrokgn4xJk+
         s1l5opm+WxmaPNHc/OIpxgWv70orCWn7fyLPyPVvq7UvYhqdupeI1gLOLY4TfP20+Rxr
         VdwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=HSQtSh/WBX64Az3Kdhpb9LI5nsWLBxof4MszIZvqUt8=;
        fh=/0dHmH0KYqgsVG2UjuFLr52hI86agp8To9pRuvKenaM=;
        b=EbS2S4/HqgkRHEZRqP8aPMuSFeIGI+DNi9kTNOpFClT63ziQj6IBwkYDmwNzGH8ILw
         gAjQBaiQZ07ZKYoda3cXXy6Ll//uQfq8/Pv38B6d0NMcdrlYPSNfxYZ6jKNeWm6X30xv
         jJ0Ss1zplx4Y3HogE2pot1IwMCf9e9KTsvCMs3d7Z2O/NQhqMqo0/cGOO2HR5UJSBHhz
         f/6W1M1kxv/2dA8fauRKxm76EJ04kw8jamtCl3nDGu6JNN7YW2F3XnRL+0uVA7twTsA6
         TPwAPXHNxsdHO7167+gdCDESTiHSoUyu7CdD4oCXiBJzAxve+mzkebbwyjRjokCVfPHL
         k++g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789545258; x=1790150058; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HSQtSh/WBX64Az3Kdhpb9LI5nsWLBxof4MszIZvqUt8=;
        b=eKzCRijKfmCHHZiKgh/sX/8aL3JWce9ZwEhI1ahFWN74uSpobeK3CHkb//mMQsWBMx
         zONX8u0DzKP3QMyJYXTV+ILQQW3WJFSLa6YbCShbeyowLKjQQ8vdbObij+zS9frIqiCr
         Z+XW/PXrhhV1MDXTiJQcrHcWgG6K3VkGXWvOq5pr2DcRus3nC4gUE2mMD1JRxNe4Mxm4
         DpeYaiyMyOclQaD9+BXd6QYkEIa95hjzUQwLaqXsIQZP06pGqBlreuUBpl1vkfVZ9wbh
         buf2q7MQLT9AwL+vk/X5SSQsXbQrQw1NZQaANtwn959MBQgfhoApAV+kV0q5Bgx3ELZP
         eliQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789545258; x=1790150058;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=HSQtSh/WBX64Az3Kdhpb9LI5nsWLBxof4MszIZvqUt8=;
        b=prJgIswbOyemvxixTZJJLLG/tJdSLIMo18YcStabJW23G2RQ/ATElXNwBx8SVLLGVo
         eEIZ4lJ4iGk+zrYFvA2AVa/XHRblobWVPS3bs+uGCzLU100C4liKhURLmtscXS4FCSQm
         FpTL48vOvnbhieANh0VmOS0mmzKJYaGRis1qEbjiLx/FsLgUD5oGpXEfvXLS+Z/7KR0Q
         ilRJkG+oJV6DdQ7l3LVarb+8z4vfu/YWHcogNxrlHnrhgNTEwq5p1Hcy15wC8jCJT3jB
         Xjer/63byFsoe1zPzekrq9saoe1MwuNnC7ui+fMID2rhO5cJR68/MxGrMIL5EO38Pjpw
         RUrA==
X-Forwarded-Encrypted: i=1; AKwUvBytAwhbxwo6EaLBTVq71w+df6GXGE+Q0PZLKjLM0zFks6rKG9mU7vTRn+EfAjk4gimOM99b8DvS+zNBVRMbLg==@vger.kernel.org
X-Gm-Message-State: AFuF++lcR6QZdhqhgFj3bqcVg1DGuxPwXRJrGs+DzfV+jbZtAdHemjsA
	IajBI6HMUexTIE8/KJRfvgvYmnIB5QxHQPzCDyAsUghg89T7k1aCQR552cTqHXy6VZnfKoDuhEJ
	ZLQVtO0+OaNwSKBJVUQA0zs5qo5BiHVI=
X-Gm-Gg: AYBFou3rhMb109IOtFn015NVfG7jsA4FFuV7SX02n6GQnbVt70aKP4Pv3ME2+knyFOF
	K+k7cI8W0CLVy2fBDQNxdfaymj2RIO2ki/N2vnJ6iFt4nnjlRNSFSaRe5TWBXZLKiovwQZbQ6CR
	crE3opc9B0p2NaKNtlKs6obouFmKjQS8BoRB1NYGttmrTdL7Z7+p3LFx7Nc7BpHt8XhXWMn6qDz
	2IGYC7Zni+YDQnJ6X5A3CagHBO7Fu6Xq+1D32i/Hjsk2nLMkOfq0CnlC+fWvCu5seKIXznB3naj
	BludbYkMlP1YWZ0QQbkY/q8qvAH5mVWfPGZSF9BeREaf7X8AkuwjbsFHLkIuuQZW+fqD3cU4pEP
	yLJkquo3lHbSnBVudtEDy2bh0tO4nCq5oHVhqyBMvCjzcT1ggyGs8C+WEoLQyzgoDkgpKJyYoDt
	2x4bfelaY1hRERMr8xDJYzZWnECueibnPV5YVWy54/9s2ZoGLhmw==
X-Received: by 2002:a05:6214:590e:b0:910:3f0c:b9e5 with SMTP id
 6a1803df08f44-9123d7078aamr38407266d6.6.1789545258042; Wed, 16 Sep 2026
 00:54:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260909074556.55709-1-luka.gejak@linux.dev> <20260909074556.55709-2-luka.gejak@linux.dev>
 <15af360d-5098-440d-a0a9-3d20ec43dc7f@RTKEXHMBS04.realtek.com.tw>
In-Reply-To: <15af360d-5098-440d-a0a9-3d20ec43dc7f@RTKEXHMBS04.realtek.com.tw>
From: Peter Robinson <pbrobinson@gmail.com>
Date: Wed, 16 Sep 2026 08:54:05 +0100
X-Gm-Features: AcwNN1UgIQjFhrklRnP6j976pqqgi-Ol2d4fYUf19XemVpuj7kl9cWCwgLI2DiU
Message-ID: <CALeDE9MeWQGagFPy3TMA5WNRtw6-tRT5VS_uK8Kq5ZtKNd0xeQ@mail.gmail.com>
Subject: Re: [PATCH v11 1/7] wifi: rtw88: add the RTL8723B chip type and SDIO helper
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: luka.gejak@linux.dev, linux-wireless@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Michael Straube <straube.linux@gmail.com>, 
	Bitterblue Smith <rtl8821cerfe2@gmail.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, 16 Sept 2026 at 05:02, Ping-Ke Shih <pkshih@realtek.com> wrote:
>
> luka.gejak@linux.dev wrote:
>
> > From: Luka Gejak <luka.gejak@linux.dev>
> >
> > The RTL8723B is a 802.11n combo chip whose SDIO variant, RTL8723BS, runs
> > a Realtek vendor firmware that differs from the firmware used by the
> > other rtw88 8723 family devices. Supporting it needs a number of small
> > adjustments spread across the shared core, all of which have to be
> > restricted to this one chip and bus combination.
> >
> > Add the chip type and a helper that tests for it, so the changes that
> > follow can be gated without repeating the chip and bus comparison.
> >
> > Signed-off-by: Luka Gejak <luka.gejak@linux.dev>
> > Acked-by: Ping-Ke Shih <pkshih@realtek.com>

Apologies for the late reply but if it's useful:
Tested-by: Peter Robinson <pbrobinson@gmail.com> # Pine64+ and Pine64-LTS

> 7 patch(es) applied to rtw-next branch of rtw.git, thanks.
>
> 673662a0411e wifi: rtw88: add the RTL8723B chip type and SDIO helper
> 5f92fb993456 wifi: rtw88: rx: mark zero length packets on RTL8723BS
> 4d688f22ebbf wifi: rtw88: tx: extend the TX report purge timeout to RTL8723BS
> b81ead28aeb1 wifi: rtw88: sdio: zero the padding added to a TX transfer
> 5a95bd460175 wifi: rtw88: sdio: track free TX pages and OQT credits for RTL8723BS
> 8c17eb82a0fb wifi: rtw88: sdio: set up RX aggregation and interrupts for RTL8723BS
> 28eaf7971a20 wifi: rtw88: sdio: add TX back-pressure and retry on page starvation
>
> ---
> https://github.com/pkshih/rtw.git
>
