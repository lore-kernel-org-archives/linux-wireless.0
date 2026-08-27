Received: from mail-yx1-f42.google.com (mail-yx1-f42.google.com [74.125.224.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8908C4457A6
	for <linux-wireless@vger.kernel.org>; Thu, 27 Aug 2026 18:09:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787854170; cv=pass; b=c7WjaEa5yKsToErYmfGcGXUgMnm/EGKrwmZ9jvbwjBDPOCPrSPtMuu7LYj/WO4FCtbGUwrN2h+NLAPGLGq3zhcj/CgLW5xhlarNKSqAD5et/heKpXn2LZtRGoAAMQHWQtgAVzoy+QOijVoNXwQwMhLk4pUjOsxM9U6AFj+0fiQA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787854170; c=relaxed/simple;
	bh=gyvcr0bAWy6b+XaWJz4F6/gpXBvu5rK1SECJF9HtAZQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LIi39r7Lx2NxMsuX5nRse5a8L6rEgBHm9c3v9v54wwLnUN9V+l+92S8ocjvswEITPsLcZvLAGbjBltKHrzsMVeU9kXtDqbrbI6gV+SeQB9dl06/VpmoUano8f8nCsAxdTM98vXbyfN59pKkDSYIjVCQ9lz3vZnZCilrOUkCwrT8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GiZevoJA; arc=pass smtp.client-ip=74.125.224.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GiZevoJA"
Received: by mail-yx1-f42.google.com with SMTP id 956f58d0204a3-66c711b7f2aso402807d50.3
        for <linux-wireless@vger.kernel.org>; Thu, 27 Aug 2026 11:09:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787854167; cv=none;
        d=google.com; s=arc-20260327;
        b=QEbhSsvflAb7vDpkHoYvpWeQO8MzMtntv9gWvCQXdu25Bjvxhqk57sW8FNBMjATq8i
         etUsoF9zn9gFf9bfAxjd2JbEv/16pFpJ8I9rrBFEZTDiu7O59NoAvzfAE4Q67HseO/vh
         C5Lxa3aNHFc3O5NlyA0UQv6Yk4qF87SIJlwVFDomv5d20lTlCiTvIO/DYOfiSvXdeyfL
         tmUseF0crFp8+VaBKeLH80KL7mIJ5s4mZUCyleTXPXavprDjty2jwf2G9xSGGT2UzDfG
         ZJrqJUZ9gpIEBgW1hKkrt/yIgDhQRJ7nhgXdu8vpDFxBQiBR5JI6QnwkrA4cJXbpwzQC
         NS4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=gyvcr0bAWy6b+XaWJz4F6/gpXBvu5rK1SECJF9HtAZQ=;
        fh=3zM1kFd3EcoZgKYWwzSatuzILcfEO1fBInanv5UgYmU=;
        b=FrrQ/HkAE3LxioW3bgVj4QGYSFBI2Y36iKbTv4tUMV7fFQRNFy07yUcHz7axw2J0bc
         bNXwj6uhdGTIi+lXkBqZJN8old3w+WpzOxlxhjTkwGxMSOwxEtTwt0hw02POC9lB5iRa
         8OutAbRK+AEXVRAD9638xbwEDh7/YAfXKAyOES/Tctsjpmenbci0ZO6ckoLbxLjGNf9Q
         XLYq8n30B9xSLkLaN6t/6fBCQ4cR5D96Sdw5gV3XkpQAIpbo9Y7ULBAVtYu+g+/tkBrf
         YmAW4rpDIgCqG06VUK8Yu4DDKGv/qrwQKugYDnygpr9gHkq8Wa+4BOCgiEqNk7uYHBAV
         u2Nw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787854167; x=1788458967; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gyvcr0bAWy6b+XaWJz4F6/gpXBvu5rK1SECJF9HtAZQ=;
        b=GiZevoJAMWstBxyG3vW89tA5yzV7K52s+cOLWm2BTHyolHfkXCYHPMBpACCDgZV+5Y
         WHN543CexEyfQug1l7LFgM/HOQK+cahJHJ6kC58Cd6IQffeKiXTNhWtgMNyPgJ6b9U1n
         UEcdLuzjyixYSb3JRMgiNuZRwca3n0GxEg/ESaqaKWq1t6k6k3pmdgZFHXjr4LcN9Aru
         n9ayG7NvDh8vzJVVH+zTETz4CsLd8X04hwHo9Bf0sGQR6N4R178rjmYkBJwrF9VR7Psf
         w9U9b2sRKU2nO/FAANAF+iiwiMh2RViyeQutoZZIPsa/ogc/KZFQKA1hlMkqjE5R8BBq
         BGcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787854167; x=1788458967;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=gyvcr0bAWy6b+XaWJz4F6/gpXBvu5rK1SECJF9HtAZQ=;
        b=s71/fqJPFCiRmZc0nyB4jy+Cyg1cjfLmF9aFh/qKCBb/jYtfjRRhEDNaxooHQ1d8m4
         3jjuWH5ZuFlp9VFWAHl3DfT3WUW2WJadClHTw2/y+vcv/O5EcqWbRva2XVVIYkYP+1l1
         OobVS0KR3TE6bOdENJYlLN550sVA0jFkTZrOxcrRX31s+lXbIZjfRq3QUxTwoNry/Rzr
         Pr3dWrVlIY9dVJIpL8YZgo78VTFFQ4E7dBNMK+/TaXjeNbiUmABkqSO0cjbiEAKBjiaW
         9g7iHQmRyPfzyJOVh5fg70MLiFK+FZVDXEfy8EDEO6++M6WGL9eucF9jstMLJfVyd/E8
         LLgg==
X-Forwarded-Encrypted: i=1; AHgh+RoUI6jPj+XGeHjNBeZduaHdIe9HoknA9hIL+PithM2dLTagSrua41vqCzyTlh0GdJAgID75eetTaK40Z1cajg==@vger.kernel.org
X-Gm-Message-State: AFuF++lfqrkc2IdQEgLqe0YFcgrTreiUtIH+BbkPqvoYCxJOaL40DjJ0
	z9nv3AAMCsTf19R39OgwrT3hyQQM1h5he+EJRTxSyr3JqQEtg6N6am3plChh8uu2OhZhAfQqk+p
	lLO3Tji2I4CyqrIS4rYT7e4wc7YEjKCc=
X-Gm-Gg: AR+sD10C4ChjHIcw5cRVnGhZExtj5WYUXFayNEE470OZLeeOJKOtkKevlUM5rWL7v/F
	L5cB57nrxD7rZ+QZjmyooSbDP7j6HGdmFytK49pFIBO/mZF/wr9G+bAGWPol/dZkylbFWN4ePy3
	s3zUXcNHIXxK6RXkgUBjimwRlmcm+XRS2x/koRAVm+whCa1lWWvxgx7Zy7C3XT7IjbSSJNlHIlX
	GU0K68THUtqTgjopvu85gzKbdnTEuYrEfPdhM0L3uSlD79mtvcMhVr4HGvGcnAv/lY+VanFrHtH
	5uIc/Ae43Wmqx1R8egozuF2AwVKvm5XjzrbXnMEof3Un/GO4k56X9LEUo7jtuC77871l8sQlr34
	3XULtAo0MCBd00W4wavAAzD/qEA==
X-Received: by 2002:a05:690e:2052:b0:66d:1877:121b with SMTP id
 956f58d0204a3-66e4c6d6f17mr41588d50.32.1787854167499; Thu, 27 Aug 2026
 11:09:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260827171937.28878-1-gvalkov@gmail.com> <20260827171937.28878-3-gvalkov@gmail.com>
 <15F55ACD-E206-4B79-9E8D-1ED24427BB19@dolcini.it> <CADOrJmae24XCgxFwtHssdoWc4rv1Q743hfgjG=kUrVPgf6urmw@mail.gmail.com>
 <A7FBAD8C-3AAD-4268-9BBC-3BDE071481E1@dolcini.it>
In-Reply-To: <A7FBAD8C-3AAD-4268-9BBC-3BDE071481E1@dolcini.it>
From: George Valkov <gvalkov@gmail.com>
Date: Thu, 27 Aug 2026 21:09:13 +0300
X-Gm-Features: AcwNN1WeeO0QLErFPaTPUKzS5E98_pxOjOnXU5-Tw2FaecGW6bryCcX8wHHKvEI
Message-ID: <CADOrJmZ8u8Gj0dA=CqzUwxM32uN5ZOJ_GdaXJNi1ttYpp4FvrA@mail.gmail.com>
Subject: Re: [PATCH v8 3/3] ARM: dts: armada: WRT3200ACM: add marvell,invalid-reg-hint-in-rom
To: Francesco Dolcini <francesco@dolcini.it>
Cc: briannorris@chromium.org, johannes@sipsolutions.net, andrew@lunn.ch, 
	krzk+dt@kernel.org, johannes.berg@intel.com, kees@kernel.org, 
	miriam.rachel.korenblit@intel.com, rongqianfeng@vivo.com, wenst@chromium.org, 
	rafael.beims@toradex.com, avraham.stern@intel.com, error27@gmail.com, 
	s.kerkmann@pengutronix.de, gregory.clement@bootlin.com, 
	sebastian.hesselbarth@gmail.com, robh@kernel.org, conor+dt@kernel.org, 
	Frank.Li@nxp.com, chunfan.chen@gmail.com, arend.vanspriel@broadcom.com, 
	peddolla.reddy@oss.qualcomm.com, linux-arm-kernel@lists.infradead.org, 
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, 
	devicetree@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 27 Aug 2026 at 21:05, Francesco Dolcini <francesco@dolcini.it> wrote:
>
>
>
> On 27 August 2026 20:02:27 CEST, George Valkov <gvalkov@gmail.com> wrote:
> >On Thu, 27 Aug 2026 at 20:40, Francesco Dolcini <francesco@dolcini.it> wrote:
> >>
> >>
> >>
> >> On 27 August 2026 19:19:37 CEST, Georgi Valkov <gvalkov@gmail.com> wrote:
> >> >WRT3200ACM and WRT32x routers always report a fixed US regulatory domain
> >> >from the mwifiex ROM, which conflicts with the platform regulatory
> >> >configuration on units sold outside the US market. For example:
> >> >- phy0 mwlwifi 5 GHz, hard-coded region 98 EU mapped to FR
> >> >- phy1 mwlwifi 2.4 GHz, hard-coded region 98 EU mapped to FR
> >> >- phy2 mwifiex 2.4 and 5 GHz, hard-coded region US
> >> >
> >> >When the system boots, it detects a conflict between the user selected
> >> >region and the radios, e.g. BG FR US, and applies extreme restrictions,
> >> >preventing phy0 from starting on any DFS channel. phy2 works.
> >> >
> >> >Add node wifi@1 with a flag marvell,invalid-reg-hint-in-rom to the
> >> >WRT3200ACM device-tree, which signals mwifiex that its regulatory
> >> >hint from ROM conflicts with the platform and should be ignored, so the
> >> >platform regulatory domain can be used. This does not allow the user to
> >> >change the regulatory config of any radio. It only allows phy0 to start
> >> >and operate according to its certified configuration. All radios in
> >> >WRT3200ACM/WRT32x are locked to the hard-coded configuration for which
> >> >they are certified.
> >> >
> >> >On WRT3200ACM, the platform configuration is stored on the devinfo mtd3
> >> >partition, which is read-only: cert_region=EU modelNumber=WRT3200ACM-EU
> >> >
> >> >The Linux kernel sources do not have support for WRT32x. An equivalent
> >> >patch for these routers has to be sent to OpenWrt.
> >> >
> >> >[1] https://github.com/kaloz/mwlwifi/issues/173#issuecomment-307879699
> >> >[2] https://github.com/openwrt/openwrt/issues/9956
> >> >
> >> >Cc: stable@vger.kernel.org
> >>
> >> This whole series is not material for stable. Please drop thia tag from all the patches.
> >
> >Dropped CC: stable from all patches, and sent v9:
> >https://lore.kernel.org/linux-wireless/20260827175850.89395-1-gvalkov@gmail.com/T/#t
>
> Please, you are not supposed to send a new patch series revision every time you get a single comment and you did send the previous version just 2 hours ago.
>
> It does not work like that, you just create additional overhead.
>
> I assume this is all documented, please look into the Documentation directory.

ok, I will make sure to wait for a few days in the future. I apologise!

Georgi Valkov
