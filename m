Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com [209.85.208.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCB1146E010
	for <linux-wireless@vger.kernel.org>; Thu, 27 Aug 2026 13:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.180
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787836154; cv=pass; b=m1SObN+KJfwwXcmE2/BXMbfjj/rpg00cARn6jSqx2b991LHjyn2KZePB027p5BkEVjshwWNEazK9IdgHpQDCKVcToB1VRZGaIGFgQbAaO+oCqJpAxF0UnpJRdLS5UXlLNL7IBeWaF7s0MZX8MtGVyVstuth6EFt0lNRnjD5Az7U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787836154; c=relaxed/simple;
	bh=yVbl3Z9HVr6Uibx2P5f7A2CJaisyDJjFLYgGyEoH47M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GTpCbTGXkGojb7P0vCkJ9PL+k1+AFQI/tJTzfhQcW/dx2C/Rm0Vn/47ur3TCgHAi6N4mOl0P0sCytulQtjZHa8gKRrvwhdkB5mSSyJuGDazmD9CWwdqdYPMKuuymYCc9gP8YfmSlm0swR/tyEE2frLHcN1aXLK5KNgts530unDk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lRcTrciv; arc=pass smtp.client-ip=209.85.208.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lRcTrciv"
Received: by mail-lj1-f180.google.com with SMTP id 38308e7fff4ca-3a20f56876eso7742541fa.2
        for <linux-wireless@vger.kernel.org>; Thu, 27 Aug 2026 06:09:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787836145; cv=none;
        d=google.com; s=arc-20260327;
        b=h5zmuleaEHcwHiJ528zvHDcVMj8DKdCwpXJ9YdO8ydyOnXxCHUN2vj9ZpL5Go1lE+M
         KrZxZ/4BVMlnaXa8wWKIxRAkat4fk8z/AAb0NhKbLdMNNrKPWFQPtsE1QnaSXV2d1HwO
         vjyeTXyXkuPmNyCrHOHgyoAhk0i0zNkfueuGmfz/G1ndGwwYu3e6lfljbhedfV3Q5o0g
         g54W6R0PfPddiDUwP8sCvCUiL9wBm2ayceVz38TB54WeRdEgky7MSvp/DJOkPojx86Z9
         veXEoubcrfcbkcHFmBmx1dkmHNZ9rOEElZLAkV34FFnLLivQJJM4H8+Rbomz6rPQ6fMk
         3sDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=yVbl3Z9HVr6Uibx2P5f7A2CJaisyDJjFLYgGyEoH47M=;
        fh=UDrUtONT9rFGCAMw1Rg6jdRZ7seKf9zF5wvdlMcnbCM=;
        b=NzJgC9Ne0pN15MJOpQktbTB0hYEYUnk/hout/dZirL9pYzA7Qk5MY9xXcLAygOEVK0
         xap9YlsqQgZhkaYauUmEMKoAfDSB6Q5+MtGvBDAcft9l6Qjf0jb3KVtppInLcE94Fk9w
         S0t5eUTMk5WEXqrCfx4L2Q68IjiGU/DvNhxddBOzEqcMFESg37/WxbD3SGV3coMk2leo
         VqUnDSTqKmsWDRmNVQGmxFYxI7slhuAVl33Lx6Dv+Q9pZ/1BdnrNySIwYiENecylJe8d
         Ve/oln/YpNGvtURxG+Wvq1oTiS/Bfk0Hcw3ftQ1ghAKagyXMYu89EZU6pW16/qWCmTeY
         rDSw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787836145; x=1788440945; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yVbl3Z9HVr6Uibx2P5f7A2CJaisyDJjFLYgGyEoH47M=;
        b=lRcTrciv1tpI+038IVPgCI2tC2Pcj6vTAlv+YwTWScJuGM4KIs5fvLPs3iLlRepcd8
         AdoyoJLWwxxvYyFHX1e8Vrly9rpYjMkUYmPfyLUB3ebqKwIBSdiB7pXJwi8iA9WaMSxB
         IBhFCqTLUDfJ+VQjvOtZ8RDl5NdtzoxL1rUDrKwfTkkgAOA8khrsn12UMfyXWZmOne/l
         AcMVSb5VCFypAc8pyurjApvpr2NtCKy7Z/KKJsMWspF8VIFzfY6Sd4qGkDwseP32tF54
         mxNQtguRbY57Gfq7Ease6C27QqN7v8YjofkIHg1zkG0uKKk69kos5EZ+laUGa7rZA1c4
         mOVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787836145; x=1788440945;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=yVbl3Z9HVr6Uibx2P5f7A2CJaisyDJjFLYgGyEoH47M=;
        b=KtHAMjOeNkwEizyScgihAqG2F98EWLR4MlIi0uc3yyAvXvwdmSMOpnoHDUqHT1fN8n
         MFXbIysQ+Yoq5H8Msp2r0Hyp2+Y6Hx3ID4m1Tu82v3qP9INcGPWONmyIUYacW9YUx5Pj
         0PuN1UIDe46qa58zipU4koCrqzfewn86Oh0Ab0pUjJGRTqwZTlPVWfjyKzTamFdc8WgY
         qwjUuH5PbzA89bACgo6nfKXCnmxW17k9FnN008RKsQLPs0H74wDSVvPMMRF+AMtk0+kv
         Nnwe0JX07NvFeBPYVHG/3zH5IElwVWti6PM4Ull7DvKgnIowGGB6dRxAT4yAe5rk5I+4
         NeeA==
X-Forwarded-Encrypted: i=1; AHgh+RqHjD8QUW5Pct5KP3ovnhBM2TmTGhkVPZiK+nyZ4ph0YMZVQJa3LkTGbu5E4I0PFo/3giZoMw3haUuvLAG8Dw==@vger.kernel.org
X-Gm-Message-State: AFuF++nALc1ML45E8iNmE4N5duyRozY8orXmrj5/q2if37sW4uDJSgV9
	rTk3+P5nXqYk/oLgAveWEqNnkz3Nv5A9WRoHSBLseDKZ8X8C12D5huv670fpS4hNerzSDlldvBa
	yuJnDnVRxHNomHP5klZIZ/LQ4odujaho=
X-Gm-Gg: AR+sD10QbzHg98TjkF+2EdKCHmzpVZRa4eEzshFOzb/QvLxaR4i4GByUGlJuwYzHOtE
	mN/Lh5KPv4tYAmknA7S5YNHPDcCo5c8bMJLlte5CUZ0+VT2rosAfOXnHZwjIcobc3QG95X+cTXS
	v0H8nzfO04ZIlsA1oCQiqBgDMRsllGt4/JmmkgBheXOKBUh28FfFWljnfLowWvrWDQ+E543jMW6
	cq9ofCkkz22nC2gRB+Wgufa+6VtABJsI1iAK/wcMuRwJuhoz32CsQlyp/ZnEXY+Dtj1LBhEIbMg
	b/z0tO5rdBD2VZr7PpLxerQt35vCE6xv+Q9muvQ3b+XJDZ/VpWIOtleUEjTHkQILyEDGn9xNkzF
	eZvqqQkeYBSB3UyZEBWWoyuyHH65D+YruWrWCtYIOp6cXzBT9al/zMQUu6g==
X-Received: by 2002:a2e:be27:0:b0:3a1:d468:f988 with SMTP id
 38308e7fff4ca-3a1fd453e09mr37025921fa.1.1787836144417; Thu, 27 Aug 2026
 06:09:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260821010728.45065-1-gvalkov@gmail.com> <20260827-helpful-icy-donkey-9bfdaf@quoll>
In-Reply-To: <20260827-helpful-icy-donkey-9bfdaf@quoll>
From: George Valkov <gvalkov@gmail.com>
Date: Thu, 27 Aug 2026 16:08:52 +0300
X-Gm-Features: AcwNN1UImZDtg3-upEabUa_XGggulmtbmlnjP2_UXhZYxbNMdjonIxEdG5ok4DI
Message-ID: <CADOrJmaF0UpRefk1+BDyn5iU5La4ke1gFWwzyRr5-9wp7Zr2+A@mail.gmail.com>
Subject: Re: [PATCH v6 1/3] dt-bindings: net: wireless: add flag marvell,invalid-reg-hint-in-rom
To: Krzysztof Kozlowski <krzk@kernel.org>
Cc: briannorris@chromium.org, johannes@sipsolutions.net, andrew@lunn.ch, 
	krzk+dt@kernel.org, francesco@dolcini.it, johannes.berg@intel.com, 
	kees@kernel.org, miriam.rachel.korenblit@intel.com, wenst@chromium.org, 
	rafael.beims@toradex.com, avraham.stern@intel.com, error27@gmail.com, 
	s.kerkmann@pengutronix.de, gregory.clement@bootlin.com, 
	sebastian.hesselbarth@gmail.com, robh@kernel.org, conor+dt@kernel.org, 
	Frank.Li@nxp.com, chunfan.chen@gmail.com, arend.vanspriel@broadcom.com, 
	peddolla.reddy@oss.qualcomm.com, linux-arm-kernel@lists.infradead.org, 
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, 
	devicetree@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 27 Aug 2026 at 13:34, Krzysztof Kozlowski <krzk@kernel.org> wrote:
>
> On Fri, Aug 21, 2026 at 04:07:26AM +0300, Georgi Valkov wrote:
> > WRT3200ACM and WRT32x routers always report a fixed US regulatory domain
> > from the mwifiex ROM, which conflicts with the platform regulatory
> > configuration on units sold outside the US market. For example:
> > - phy0 mwlwifi 5 GHz, hard-coded region 98 EU mapped to FR
> > - phy1 mwlwifi 2.4 GHz, hard-coded region 98 EU mapped to FR
> > - phy2 mwifiex 2.4 and 5 GHz, hard-coded region US
> >
> > When the system boots, it detects a conflict between the user selected
> > region and the radios, e.g. BG FR US, and applies extreme restrictions,
> > preventing phy0 from starting on any DFS channel. phy2 works.
> >
> > Add a device-tree flag, which allows affected devices, where the radio
> > conflicts with the platform to ignore the incorrect regulatory hint in
> > the ROM of the radio, so the platform regulatory domain can be used.
> > This does not allow the user to change the regulatory configuration of
> > any radio. It only allows phy0 to start and operate according to its
> > certified configuration.
> >
> > [1] https://github.com/kaloz/mwlwifi/issues/173#issuecomment-307879699
> > [2] https://github.com/openwrt/openwrt/issues/9956
> >
> > Cc: stable@vger.kernel.org
>
> I don't think there is any bug to be fixed here. Support was incomplete,
> so you add a missing quirk, but there was no bug in the binding.
> Binding was correct.
>
> With stable dropped:
>
> Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>

I added Reviewed-by to the first patch and sent v7 with these changes:
1. drop Cc: stable, the first patch only documents a binding
2. restore colon after Tested-on as requested by openwrt-ai
3. mention the added wifi@1 node
https://lore.kernel.org/linux-wireless/20260827130335.6606-1-gvalkov@gmail.com/T/#t

Thank you for your help and patience!
Georgi Valkov
