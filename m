Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D31CA37FF53
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 03:24:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785381871; cv=pass; b=TK6GfnT9sdRFNxCD2WyVmgFJOU61JMi2Gntbw29G0eAD9wc318TSBll9i0GXbPTTRze11+DQ2OG4oQnTEm5q+nhWY9mNOmIMwJkSwztxYdxXqOIw7T0fQZpFcDrUrDmBzrlIzZhA9STxYYiJwT49EtuFkU2EafH4wfaICuOy2Es=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785381871; c=relaxed/simple;
	bh=XHg40f1gJ/YIvj9Si9YNU/RPMmZ5XfcIDvaNQCDpNwg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aO2wA7YJ87PwAPyEzQXqiqRx4Jm3B6WIFR8iyP2ZinesfeyZaNt0s9nh+4B8vO1Mj84DYwdeKn//f1SJTbdSSbMjonbxmI/FoWufRRlGmCYh15Vde6PIJUHIteuWD7M580BaTAYjHFDLStZFrIoqzvuhhQOc8rfkDcStvbiO47E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=r+CyZTg9; arc=pass smtp.client-ip=209.85.167.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="r+CyZTg9"
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-5aec201b582so1814987e87.1
        for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 20:24:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785381868; cv=none;
        d=google.com; s=arc-20260327;
        b=nEoE+ap5cHRrWnM90dLx+VVOMkv1DxEjFk5gLCzN26TL4qc/vGZAQsaP3qz5o3gzoy
         Now8Z0KD0Rf3/0xio0LsL+zoeygz7Hnn+xzbl3chza0gC8+VyPnR+MxEfnolekmSXDbU
         Nj7sQqjN64cPiLD9KbT880zdRHaKZG26UHMUiUur6ic36HY4rRHKsuRHg1cfIxJ3t1+O
         30eDCJKV9kGZMfbrXuytTMflHBsq7pZVuRnP9L0EwJZ2LBjDsuTIOzMqZ9QewD3Rv5Bn
         Qe9PsFhVNmcLbddT7+s5C0tBFhBfADt/Jzr23ZT+UTWEI0u26w1RichKXXmRpJTcu8ge
         Vh5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=czSucy7zlmDRprNUvvGm2utHsJougpvDn6kozLJOcKQ=;
        fh=nze6cRpUwNAiRNJfUQhrzVaaQr6F9bHUNi5HC7yv+a4=;
        b=iF0RqfZJT2SBbMrsZAT56ejWIgNUf160rhgqsU+ikHKQEyG+lkBMV6m4QwzpQv4ZEA
         eCOVEvWmycIoa+Lt5WN4mYmS9R5c8+GUiWrxJ6djFT4Yr8D7ym+RUIrALMeIEriqkq/c
         c1qPXCp9DKwmn/YYHgzQprSFm1NlIEschKQfLUepvo+9Xya3bG7+hmycE5LYrE7L/e5e
         0F2GXmzW3Oo0lgyZ06z4a7fCKqx8xVEn+QI9jc31h5HNCz94HRfhAO1B9niybFhJGNVK
         RudT5wgeioBnjWnOcY0jIJVdZp3om7SUOd2uUixIG5CqatA1m4IIYIfP6WY4BPbecfYq
         9O7Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785381868; x=1785986668; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=czSucy7zlmDRprNUvvGm2utHsJougpvDn6kozLJOcKQ=;
        b=r+CyZTg9WAngGfsteFMObpjdYuxuRw82C6kWsRZcr1xE8x1nFjXuPmjaE3J3XjLb5u
         A0UG7EA7K0NMKuOsJhysgbA5BJF1TE7XiAOEb44Pfx6GGMucH1cMwlgBfUfJbIAQL42H
         FU3c3Dp5NqL48LUT50PzT6MYqg2KdnfK21qJ0gJczQWCIUQQb/TYU9hKKS2LHHLN00Aw
         P/0653GznNt1uYgPV6kYrQajw6prHGj6F3AVdRSX2BXcB7EDscFBbZZZO22f85lcN0qC
         5wiKoMf15o3hPTp3HR/LjdeHx1hR5SBPHNVvljbOPEWKfk2c0KM+DyThIWA2Xs908Vmo
         BsbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785381868; x=1785986668;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=czSucy7zlmDRprNUvvGm2utHsJougpvDn6kozLJOcKQ=;
        b=NhtQdKeukg7WseEKm7z4rveuQgcVW+0OZVGjqC7gURb1e6avPGMP4/jal+QoWgR+zL
         /kqZ4DHSA013nriLbG56TF7HnHmFG0pPGJt9x8EXYG1AgGlbskyceCv5fbO6cD944r0z
         G4rdCQRHMMf1zCiS53cB7W2L35OdT56KISkxSYue8qK7Ye+YSbiytlfMvHbzBCGVR3vT
         RubE88nikEo7OC2Oq7ZvYlF744/m87dm6G9bwrB4wYG65KnlOHkQBDPYhsY2cxtzL5D+
         rzpuUQrImz9Bgwi4l62oBsv+xowaE3UythLsqmgtuZU5r8RmQ1ShhU1Xnvaw7sjr7qBn
         aPcA==
X-Forwarded-Encrypted: i=1; AHgh+Rr4etJjInCU17YgvgXGQaw3nCtGuQNEW224/mjRiIDenvn058BBeZkr4lbeVHVnCGvH/ZbYx3uGl8hobhG5TQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxQ02R5NfeJY1OpeQ6dKbezwKtPZ5LzArGJ3XXPdjdeRSKRqvpX
	wVthWdZwSv/kpeKrHVPW6Som641XN5Wj8L/YPzCbkbBYcapzBf/8dt65Arlk36hNz5XFb4S7fmm
	iV5AvBKH/AXwz0jSPYPTltq/8VpDB9f8DhFMI+u5I+ALT
X-Gm-Gg: AR+sD13rXFXGkNDTXd8nGDHcJAexoiQkfnWuY4IDGHRMDbR6D3Xu2C8OqTbsPYs35XE
	VxymfpVhIBsoszS/Ktth7ie+9jE8n6T2gZXL7h84zFofEO1Tk1ljweJI2JnL3ZVUfkDgqB8dQhP
	acpD2mz+eW2PX3d8AtTsyhTNDNMy+0wLeKYO7qjTZjsVEoLYtXBXsnvKc1DO5w/3K25NqIkb7jm
	EVQ8zgH8S7OD4RlHjwzlH3lm2x3yMqNbUPuBw5CQ6x/t4SQtowFwQhUs6EAYo3BPaoqE7ae4Vd+
	0kPpE29CNTJ9N12PEGVofFvcNXeOSeCo37UoaF/3I2i9Zshheh94QS7Qmg84GwVm2VCqly8Wsq8
	oVhUKKQqmI6op8hHErOxoEJQaGVM=
X-Received: by 2002:ac2:4e0f:0:b0:5ae:be47:f006 with SMTP id
 2adb3069b0e04-5b2db391e67mr122170e87.43.1785381867775; Wed, 29 Jul 2026
 20:24:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260728103536.25012-1-gvalkov@gmail.com> <amq0EnoZrBA+8W+J@nxpwireless-Inspiron-14-Plus-7440>
 <CADOrJmZKdM0y6jeS7oOK0aKm7BaqcDB=BmXTSBrFTiTqXHhUhA@mail.gmail.com>
In-Reply-To: <CADOrJmZKdM0y6jeS7oOK0aKm7BaqcDB=BmXTSBrFTiTqXHhUhA@mail.gmail.com>
From: George Valkov <gvalkov@gmail.com>
Date: Thu, 30 Jul 2026 06:24:15 +0300
X-Gm-Features: AUfX_my7RmQB3ea64gFTkqlTnLieF4yzIpHcpIeqSKcu98ezcAV1Ujrhvwx5QWc
Message-ID: <CADOrJmb=_uNHnnqswMAN+LTNPHnRARqF=MicFTP6C5QoMxH4Uw@mail.gmail.com>
Subject: Re: [PATCH] wifi: mwifiex: ignore ROM regulatory hint on WRT3200ACM/WRT32x
To: Jeff Chen <chunfan.chen@gmail.com>
Cc: briannorris@chromium.org, francesco@dolcini.it, johannes.berg@intel.com, 
	kees@kernel.org, miriam.rachel.korenblit@intel.com, wenst@chromium.org, 
	rafael.beims@toradex.com, avraham.stern@intel.com, 
	peddolla.reddy@oss.qualcomm.com, error27@gmail.com, s.kerkmann@pengutronix.de, 
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Jeff, I forgot to mention:
The compatibile strings are added by this OpenWrt patch:
https://github.com/openwrt/openwrt/blob/main/target/linux/mvebu/patches-6.18/
311-adjust-compatible-for-linksys.patch

So unless we also upstream this patch, using device names will work
only on OpenWrt, which would make the current patch ineffective.

Georgi

On Thu, 30 Jul 2026 at 06:06, George Valkov <gvalkov@gmail.com> wrote:
>
> Hi Jeff,
> Initially I wanted to keep changes easy to read and as simple as possible,
> hence my current patch is based on device names.
>
> Indeed out openwrt-ai also caught this:
> https://github.com/openwrt/openwrt/pull/24458#pullrequestreview-4803923901
>
> I've been thinking about possible options:
> 1. Use board names "linksys,rango" and "linksys,venom", where
>    rango is WRT3200ACM, and venom is WRT32x. But a venom dts
>    is also not available in Linux. We do have it in OpenWrt:
>    https://github.com/openwrt/openwrt/blob/main/target/linux/mvebu/files
>    /arch/arm/boot/dts/marvell/armada-385-linksys-venom.dts
> 2. We could either ignore this or
> 3. Have another PR with venom board support files, but that will require
>    much more research and work. I don't have WRT32x hardware, and I'm
>    uncomfortable doing this without supervision.
> 4. We can also implement a dts flag, e.g. ignore_reg_hint, which can be
>    set in the board dts. This might be the best and most flexible option.
>    My experience with dts is almost zero and I will need help to implement
>    it.
>
> Georgi
>
> On Thu, 30 Jul 2026 at 05:17, Jeff Chen <chunfan.chen@gmail.com> wrote:
> >
> > On Tue, Jul 28, 2026 at 01:35:36 PM +0300, Georgi Valkov wrote:
> > > WRT3200ACM and WRT32x routers always report a fixed US regulatory domain
> > > from the mwifiex ROM, which conflicts with the platform regulatory
> > > configuration on units sold outside the US market. For example:
> > > - phy0 mwlwifi 5 GHz, hard-coded region 98 EU mapped to FR
> > > - phy1 mwlwifi 2.4 GHz, hard-coded region 98 EU mapped to FR
> > > - phy2 mwifiex 2.4 and 5 GHz, hard-coded region US
> >
> > Hi Georgi,
> >
> > Thanks for the patch. I have a question about these compatible strings:
> >
> > >                               if (country_code &&
> > > +                                 !of_machine_is_compatible("linksys,wrt3200acm") &&
> > > +                                 !of_machine_is_compatible("linksys,wrt32x") &&
> >
> > I checked the mainline kernel source, but these names are not found
> > in the DTS files under arch/arm/boot/dts/marvell/. Instead, mainline uses
> > "linksys,rango" and "linksys,venom".
> >
> > As a result, this machine check will always fail on a pure mainline kernel,
> > making the quirk ineffective.
> >
> > Jeff
