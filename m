Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DBE92EBBB7
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 03:06:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785380816; cv=pass; b=dV64S1K/bxyYmU7LmGupLupiA4qweFkROBAkwBpjOTyNVgfc4ZxL4t1ds5yJM9igTGBAfLPznE6G7mLaglGV49C6cS/olBZIB5+ntogfkegDLsNWti5Hcomd6DeSzwuL0onl1jZg635GMXDNuP9s/rd0A+bm5ZXwyfrYQdn2MpI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785380816; c=relaxed/simple;
	bh=8j0nxrm1wXhCpLhXah6oFcNu4BvWHurBVnmFCHvzVYo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HGNVpRKn/DkH13atSrJwb7gRyn6hvg3QEUSenOzsgnN3DfGtrhK8M3eQPhaOBiog+2FqWDCYg22Woypam/h1TG+j/JDYoTurWibC5Qs1TRxyNwtAZf49nOUGNPgVv0quGpszxpAzFW8x1HO3R0v8i0x69awn7JXxBUtZzNWmkaQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=j3KpGUTY; arc=pass smtp.client-ip=209.85.167.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="j3KpGUTY"
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-5b2a4359d16so1625956e87.3
        for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 20:06:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785380813; cv=none;
        d=google.com; s=arc-20260327;
        b=eHQ6ekjvN73Dhr7HhzFSIHx8AjYPbgKvdo+9iVIYMdZjlL89BhqBGb4cUg7rLjDFVL
         Nl5Ruy7gqeHVYvWUfU1GBVj4P3ZOQpcG1+vNk+cdyKpvGsaNW9PoRRoR4bFlc6speoWC
         jrFteWz2KcBvnNwQ0qbPOZQjvyTjxbbfRB080lbNgnm8D+u49MRoRieROFZqydfyt/tU
         nQWzVOrzSMxNC7GE1ht7npGpPllNFbQ29xlIbWu7MIZOPgg6EZDCfopOdokg43luzFBv
         4eO6h7AHqFTDGP1E3gbqzmfT3KNWUU2ARmVrIu8JBwCvGGkLirB5V0LL289Ad/I0ApXx
         TOlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=2y2fjND+qKE5aS0sv8qbFsMkpL4CRd054tvNPonoy6g=;
        fh=DT+/+bj147IEKBGzzrFksw5nj5Y86RyYEhobBSu0gpo=;
        b=Vkx7QlbpzsPbKrdNFhxOPJVv1RIB9PpXdjyz+OvnfRzVreutiSwUNyB7OPdHjZbVdM
         kIqfektHw9G425P1l57E76RxOx+tbWjsbtODAI8pYMTtmeibNuv77rosBtLCCgB5dkb3
         Be+dwOAcDEn03/MXV+tY+WJGzVeqfGeJzC0md3XPLXkE0GWT7T3xiVhv39pSAPeHDlHE
         ZCo0DpaWDm3FUpLk4RET/6C8NX9nyaCaAsAOQN/OknUskMvmLfJqtSrsvfeg/wj9vKg7
         8KjcrMPRbG1enCpgbiRhwZWj/RiDRAmxj5MNQJCbHKwWWUYTjwb7izmZ6CExR5OjpN+v
         dpcQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785380813; x=1785985613; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2y2fjND+qKE5aS0sv8qbFsMkpL4CRd054tvNPonoy6g=;
        b=j3KpGUTYL82Rc0ZS1P893qBdK0W5a3pI9iTImJFegdQYDHDNrf2VKtuyaHKgcs0wzG
         I/A6PZeLTLOFYsbbn0vzjxRckEYSsVKf/PZo8I8UyvAfQARxKjAo8eaWoMzILiHU/Y73
         g6bhXldKUInlNUoG7eDU6P/1bTdW9h9wDHyRQPC4ap5/L04XGTlaJCky6OayAqdq8bYI
         oyKa7E0mqvRaQyb38VROXTEaZ6AYU+/K0XJQB2u7waiZepPX8dLEkcGe7u+LcDAOTIYB
         AyRefQ/cixyOOZaDwsFmBSzlX4s5hBtUCQbbSEHof5WVJ95xkiv1/Pj8u+0KGqwE9RyX
         ILWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785380813; x=1785985613;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=2y2fjND+qKE5aS0sv8qbFsMkpL4CRd054tvNPonoy6g=;
        b=U13BmEQpcgjN3VNtIQRyLOGYsnyMRaA9KQsRN0+x9cBO2ImAZCL4bQGwrljqpny65e
         ZrnEJX4lsTAq3MyCIENjAT+v/eoohdF/wtRnVwOyN5XGoyGM0dxltT6AtUAk/g4M8Bkz
         d61WVvUClDVUpFxa5oEM5Nf/Jw6gib5BUCB8x4dgHVlDgrIIYdNq3QkoXsh0YPrjC7gE
         zMW3eePzFoFVYGsa/aWY6K8tksjGVCphl6IlpudOFto3GbhaNLJ163ujq4VdPgunSGgU
         q8MtU7PWar5q1ttKfef0G8fEmLMeScGjmf8VpiwI+NYg4ntp+gDAu3UjsM6UKY1D3oQB
         g+2A==
X-Forwarded-Encrypted: i=1; AHgh+Rponr/R1d6wOG26hI+dB4302+WOAfE42MEA+UmY/npqwDwBEKQvnNSDis6SkPZbWW6Tmhc/qrVdDQ1KR1fJNA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxXzNFTa3MpgBq7XcE/RMZf75ACruHAqLhSe2OF3/545xiMXGHV
	o4JWpe1S1PIihvzpykjxwJjsI4uNeyJCbW3HN1vlWLRBMVm2pg9pz7iUDUJpZo05IB0poCuPLt/
	janK0dzDSmbC1MRu2GEirilmG+RIdwmk=
X-Gm-Gg: AR+sD13AibfpnAhlWlfuCutwFiOtFrncgSf/F1pis0G5TdLWHfu2MgjvhFtLanZSzyh
	q3No0FRUZAmpk2XuCXSf3XHceHT1nrGt/PLLlOVejMUQUQCUdeV6P6GX0pGppu6DtAoTr0U/MGe
	28NZrQhBi3/+eIGYYNKuzJ63P4JZ5JhDxG3duG2IKMRNJ7OxwzQU3iMTkAFdsAXrDqKIWGFz+bU
	IzM8BdduhxkbkQTsww/RzBrunWqfSSfZkEg4X/B2gFoPDf4XHiHtSD0q8BPMZr+3jYA4OuqCCkE
	eZ/NWjiWjn6VaAeaFM9spISB3h19wF9tJLqZaksw8Efab9U+Oo/IZsrP8VB5Rvbdd1BPU4tDIq4
	gnbsDabM40IS6VNsh2lVkBy8wbA==
X-Received: by 2002:a05:6512:33d1:b0:5b2:a1fa:2525 with SMTP id
 2adb3069b0e04-5b2db387f17mr118957e87.31.1785380812454; Wed, 29 Jul 2026
 20:06:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260728103536.25012-1-gvalkov@gmail.com> <amq0EnoZrBA+8W+J@nxpwireless-Inspiron-14-Plus-7440>
In-Reply-To: <amq0EnoZrBA+8W+J@nxpwireless-Inspiron-14-Plus-7440>
From: George Valkov <gvalkov@gmail.com>
Date: Thu, 30 Jul 2026 06:06:40 +0300
X-Gm-Features: AUfX_mxZC37-kHj-CFlIRf0oRg-uqaKRO8uXYARafF1KZoQhqyfIQJ0T5g7ho60
Message-ID: <CADOrJmZKdM0y6jeS7oOK0aKm7BaqcDB=BmXTSBrFTiTqXHhUhA@mail.gmail.com>
Subject: Re: [PATCH] wifi: mwifiex: ignore ROM regulatory hint on WRT3200ACM/WRT32x
To: Jeff Chen <chunfan.chen@gmail.com>
Cc: briannorris@chromium.org, francesco@dolcini.it, johannes.berg@intel.com, 
	kees@kernel.org, miriam.rachel.korenblit@intel.com, wenst@chromium.org, 
	rafael.beims@toradex.com, avraham.stern@intel.com, 
	peddolla.reddy@oss.qualcomm.com, error27@gmail.com, s.kerkmann@pengutronix.de, 
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Jeff,
Initially I wanted to keep changes easy to read and as simple as possible,
hence my current patch is based on device names.

Indeed out openwrt-ai also caught this:
https://github.com/openwrt/openwrt/pull/24458#pullrequestreview-4803923901

I've been thinking about possible options:
1. Use board names "linksys,rango" and "linksys,venom", where
   rango is WRT3200ACM, and venom is WRT32x. But a venom dts
   is also not available in Linux. We do have it in OpenWrt:
   https://github.com/openwrt/openwrt/blob/main/target/linux/mvebu/files
   /arch/arm/boot/dts/marvell/armada-385-linksys-venom.dts
2. We could either ignore this or
3. Have another PR with venom board support files, but that will require
   much more research and work. I don't have WRT32x hardware, and I'm
   uncomfortable doing this without supervision.
4. We can also implement a dts flag, e.g. ignore_reg_hint, which can be
   set in the board dts. This might be the best and most flexible option.
   My experience with dts is almost zero and I will need help to implement
   it.

Georgi

On Thu, 30 Jul 2026 at 05:17, Jeff Chen <chunfan.chen@gmail.com> wrote:
>
> On Tue, Jul 28, 2026 at 01:35:36 PM +0300, Georgi Valkov wrote:
> > WRT3200ACM and WRT32x routers always report a fixed US regulatory domain
> > from the mwifiex ROM, which conflicts with the platform regulatory
> > configuration on units sold outside the US market. For example:
> > - phy0 mwlwifi 5 GHz, hard-coded region 98 EU mapped to FR
> > - phy1 mwlwifi 2.4 GHz, hard-coded region 98 EU mapped to FR
> > - phy2 mwifiex 2.4 and 5 GHz, hard-coded region US
>
> Hi Georgi,
>
> Thanks for the patch. I have a question about these compatible strings:
>
> >                               if (country_code &&
> > +                                 !of_machine_is_compatible("linksys,wrt3200acm") &&
> > +                                 !of_machine_is_compatible("linksys,wrt32x") &&
>
> I checked the mainline kernel source, but these names are not found
> in the DTS files under arch/arm/boot/dts/marvell/. Instead, mainline uses
> "linksys,rango" and "linksys,venom".
>
> As a result, this machine check will always fail on a pure mainline kernel,
> making the quirk ineffective.
>
> Jeff
