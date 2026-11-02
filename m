Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.230.202
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793602604;
	b=S/fNCa+jCodpHILJRd8hocqR0zWUlmEdd0IGkbVXIuM0Ny7igP+CK4jEZrZijteCmpeA
	 FCCy2ZwtiNLK8EW12vQBZn1IJ233ui2N5lxOivnVDfS6SKBH5dbqRDvNjybuNGVt39b/V
	 RgsW9FwE/K8SZxqM1ejENX7pF4NfyaVIbzItcl+QQ30XyhAp9GhVwPF45CSHLxPkLTlvQ
	 eqb2gt7bTuev6NUSHnFbdx+NWhl0NA79Frs59knrVBDk/4h2MIMG1C08jILg3nJhqinE1
	 Kri37MHZjMJq0QyurCOFV2V/WybTZJP/cjFw3RDXuIi6gwz5ZvYTDv8ZqStv+LIQLWQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793602604;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:From:Date:
	 X-Gm-Features:Message-ID:Subject:To:Cc:Content-Type;
	bh=7/kmaXTA+b0BspwBrbDFJ6sroDVJi4Y69NetlFPloD0=;
	b=ZOxw5wzxyghpfRppSXhHgikDnqBzGCnQS5YVhevecMP9rmldHrcF776syb1FCgjCDG1m
	 G5pjrCs6+wu838JqkHSJtPh+eD/10SFxfR/dNkqj+hpCI2fvBwhTdK7mgxTgCE9BM7ab1
	 eb8ffOJ1Upkzi7FyjxakCtx54oSN2GrxbMtIGHlV3IUlB2BWC+yHWeCy5fe1ie8rYyXyj
	 3bk2XETbRfDjwKJR/b4V3P6LNCAW6+D2uhFMbspUqqePFT9ae4UnzUbmMjNYrOmkBjDrj
	 fUDUcKmXtWkdjmTvY1yMrR1ft6tFHI5h1RwJBCGE5UkCkNGBDfC6nflh630PYQNcgZg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=K0udj9I6;
	arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.230.202
Received: from mail-qk2-f10.google.com (mail-qk2-f10.google.com [74.125.230.202])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA202606A324
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 06:56:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AA202606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=K0udj9I6
Received: by mail-qk2-f10.google.com with SMTP id af79cd13be357-930f59d1dc6so224692985a.1
        for <linux-wireless@vger.kernel.org>; Sun, 01 Nov 2026 22:56:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793602603; cv=none;
        d=google.com; s=arc-20260327;
        b=bt+OVmXcJUgASpMkRAm1VUl576F8i4OSJCn8bMucqt0zI+2n3/1LFbqjrAt1VQVNN7
         1ekOhe5Fy5kIbbq+jeEFWfvN5qdbi6OyWa+rO7jFhyHHE99iXgtVN3FFuVZ0RCWA7kRS
         SU9Vi413vJ0iEhoM4r8ia1Kqnvqxpy2AbIbM1UHD/MI4f0UCFFSZHh8gcVVsSBgER+X+
         pYiC2Zxjj1EQTKfSURvzQNkL/B18M/YEJsr24MRv1CbstZj4tUnO3xuCf7jdN9RZ287Z
         D5Rs2/ZzDyikdcjqe3Sab28zZoziiZQaujSKamCDWRWafAxMpNA026LWhs7JIU1ihcxh
         bccw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=7/kmaXTA+b0BspwBrbDFJ6sroDVJi4Y69NetlFPloD0=;
        fh=g4qIvl6/31HtnerxyVK37f4FNVcorEF6JuBH5wiMpis=;
        b=nnbfGqSvVK3cain5ECaWJ1ggyfXYLKpF6IlO0a/JEA24tDoJTwqo9jXnSaBJ7bokZI
         h29OmEn18XNvgiCFoNQEsXmOwFPEPtnGQurvcvLSHsVu1MPgADbwXbZoQ/iPY98OJnQ7
         8LgQPE8ADdokk/VWfIBa1Sge8IeUAYvJov5fzCGlRabsT+TPoJLDeuYzgC8IoPJR/Fgy
         9BSuoyL6NN9hqTiZSg5H+tJAvDOdDHAwPjDBMtIecmX5X1UbHO1liMAqh3OeAV0ru0W7
         a+4mPaMZibJq3wYdslhC91UFzQUzUv4l+JXRG3zNbislCVaRQcfRqTULUXm5GNnCiJIe
         XjFA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793602603; x=1794207403; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=7/kmaXTA+b0BspwBrbDFJ6sroDVJi4Y69NetlFPloD0=;
        b=K0udj9I6mLYv7FcJadLBzThOhSd0Wbzk/u9syJJE1e9CxyvDn1uoweRivih6WbfXPh
         E7rDvA8aCpI3WCmdjbotmkqzTp5iVS9HDwVqT4B3gJPJmaTKxNdLwV8bGye/X78NWVdl
         bCLPz14XI1d1JjamUpAPL8/djSnzQnpVk7CWNhobUNU9eyr7aKtwaPVDBuvP/9dmllPS
         b5GFZsdV7/OreGa8ho1sPvIkuTepmnMEogZfzZ9HULfagfoyaTcS0Fc3kaN2sbu6toY6
         k0BzLwFsjeFMH/R6Rdbx0KoZtsELlFIXlbP5mxkIK2/e31Zf55OQM/Ja9WGKTeerdUye
         t9Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793602603; x=1794207403;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=7/kmaXTA+b0BspwBrbDFJ6sroDVJi4Y69NetlFPloD0=;
        b=fpBNpa9HenHoRpUK/E3F0cC8wT11YhCVWpCy6OyfwWfgDydhOyB9l9ECbRlDeL1r0E
         EgXmzUN85m1kPWWBgHJD8Om5g5pt3sTjPkGA4sdhc82rmC9trdt4Rb7tSpFG23MWk+ET
         Gm+QI+XnaFeUnZLpHpVWvGgZH83LuqSMypxhl1diH7v8AP99TZt/Jl+e/s2IxBXMz5Au
         0MGWbE+fU1E56LVHGnZSXeAIxm88hxGfCG2m2cEGQxVwN4+9VSPUh1GEIJSKq7A9o0OW
         UXlnv3KSzm7sfG5rYVHWiPBHALSCXt9C0lM4PDBoqaZIMmgdsh2qTJPQOi6eH4Cw8mGu
         SZiQ==
X-Gm-Message-State: AFq9FYL+tLz2xp0cRFqrmxmzzrbF17NQrG7Sms16TwQG0d4uJyCfpuui
	1IZkmYpVYZxEFssoSJE9c9lHRXO3xiJlkXcK7LwUkVeaZOVsuoKMfEroy382Xkmw2YX88xTJDqp
	R43ffGk8dwsoeDfnX1hq7gieWGN1gUje2bDVhYtI5mQ==
X-Gm-Gg: AYBFou2BOyn/N4kWEo1bXu15WupaTuoueG5tK1XPfkOr1wFILf/TSf/kOTKFQz4pwtb
	FyavxVH94sWReh8uqCMBJXW++qWEhhX64f95mDVA9vBFOKHbRv72lbWg7LyOcieXj3LyIU5hrvS
	8QV9N2BbnIXV9ooOwqRhRXf8cojd/8FSJ+ARImbfQAXYOFW3wtbD0xCkqLQ1LovR2IKssxBcHJO
	f6bIORD3YGKxsrspIR+KpNGp/Ma1cd/FPUvmheXYiL7fyJdIJKeNtt0ru1F2TEGnG/dq3Porhj+
	CR8Gaq2HvNBei0HXVXG1/pNY+2iXo6T5nuJZIwVcQ0ak4Oc++4nSRuDRDXEpk80dH9SmDO63xCx
	kCl5ZWLzQJtvEP0BgA7mZj2bwUxtOVIdVbXEg
X-Received: by 2002:a05:620a:8393:b0:93e:c12c:4416 with SMTP id
 af79cd13be357-94421805919mr1249913985a.82.1793602602797; Sun, 01 Nov 2026
 22:56:42 -0800 (PST)
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
From: Hyeon Woo Bae <yoursanstv@gmail.com>
Date: Mon, 2 Nov 2026 15:56:31 +0900
X-Gm-Features: AclHuK-7m2bypolPdUDzTWdqJPxgAJmZBe6hyjRH28nUrDnAv-PD6OYuB_lgUKQ
Message-ID: <CAAATUifZVZjjNm_sLqshpc8uwAawnDNivysacCYuVgVfF2x7Eg@mail.gmail.com>
Subject: rtw88: question about RTL8812F (8812FR) support
To: pkshih@realtek.com
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Ping-Ke,

I am working on an OpenWrt port for a router based on the RTL8197F SoC.
Its 5 GHz radio is an RTL8812FR (11ac 2x2, PCIe).

As far as I can tell, rtw88 and rtw89 do not support RTL8812F, and I
could not find any public source for it. The vendor firmware on the
router only contains a built-in binary driver.

I would like to ask:

1. Are there any plans to support RTL8812F in rtw88?
2. If not, would Realtek be open to a community contribution? In that
   case, could the firmware be made redistributable via linux-firmware,
   and is there a reference (vendor driver source or a similar chip such
   as 8822C) that I should base the work on?

A short "no plans" answer is also very helpful, so I know where to
focus.

Thanks,
Hyeon Woo Bae
