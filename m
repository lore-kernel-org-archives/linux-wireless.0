Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F154442390
	for <linux-wireless@vger.kernel.org>; Mon, 17 Aug 2026 15:17:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979840; cv=none; b=rLVRj8wReuEX5gjnJrfHS6ZnHw1h8FfgimQ8sHJyWCsRQjUaqmWCVzcXH/AnCoWwhg9DgPanLskwf3Ji8jzaKgE2UEvtluQOdUwf39RGmgoWMjmDb8U4uR3UX3B3hASz6d2h7ZWFjV/jXywqMGRjHFMydz6U8fuydv+T6YkM0iQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979840; c=relaxed/simple;
	bh=95yA+WdRlTqFGt2+SNkdJin9HBogSOyIOfFjUaohKa8=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=eeYUFHKcWz/HDfhWX8Hfzo/ViTJrzL0NwcNGz7w44I8F1YMAx8sQ1lK/ZYyPq5za7rgB5D5PrSVFmWZ9usfiIbHXhA587UdPzGU+5bfL27BwCX9ErANpimeI0+C88zbZBYk8J73oJTg8WG9WoeHBiATdUfF/O+qTFYhC3eIdJFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gPC7OSHT; arc=none smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gPC7OSHT"
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-52d7ef16f91so17905411cf.3
        for <linux-wireless@vger.kernel.org>; Mon, 17 Aug 2026 08:17:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786979836; x=1787584636; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=95yA+WdRlTqFGt2+SNkdJin9HBogSOyIOfFjUaohKa8=;
        b=gPC7OSHT7NaV+NeBYDDFZegZ9JtTNSPjXBJ0vDzQ5KMfNmTUsA/ff2U5TRiMlof5hz
         YtpFONWtNU2xO8FDtnBjgTrJrjMqK/cCtc/rbu52SFIf/IRt64uvvPczEnhveWaZxRPC
         /yoK+wWJ4tF1qv5taX25GGcP+DbdXAwUR211F3PnVWuNXyFUNF3DXxNBiLaIpXH8fqyJ
         fYTNGODYOAwbLtREJ6x/rjlkInC7YAs7nKaC4Vo/nBWLSTYvdvCLIkkoogg5YfUnjSQ5
         vvkzvJkt+9jLsdlysdIYgQU0otVb2TPSjPQwtHFX/YlWqdNQ3sEagEL6Uaabf/vHj0UJ
         p80g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786979836; x=1787584636;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=95yA+WdRlTqFGt2+SNkdJin9HBogSOyIOfFjUaohKa8=;
        b=U8HPCNr53yG85JfiFo6UXoWhChHksO4G6f3GBAeCR53fWtti9BnsyVoDuL1eX32ChT
         B4rc1FwlvJpfarqEvS+C+zssoQ0wHPuh3Ohy2L796WpwxqTidtZeEjvY1ypvgJOb3uf/
         ajEryENNlNVqggPhaH3WxBVEXSP95slvQQW4AzGY88u6yAlRhJDmQH4TOtWHPTocAs4E
         LRg/lmN7ueHNuoHoNnvw+elLy00Cemio7DVPGqN/D7CZYZUgoVpbA1LOG6Jn2tZB4h/x
         iOiMA8YHj0i3scW2S/yFDxerMM7GDPABBy7izNz8sFGYqh79A9KKiv7WN2zhb8LPN73V
         lPvw==
X-Forwarded-Encrypted: i=1; AHgh+Rr04dIXNaGvNZTE6Gax9Tn0S0yX7iMFF/g7lJvrgy+tFLbuM+scEoXHlG3oo3gYsjhaUlklBdjoXNqoGALwlw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwUcfYQ/M78aPFe/oaorONrxX8zO257e+aeM2ebCIbHr9usSGkL
	I3cu2WHLHsQ28y5AkI9qrTroUHYb+rFSO/JuFPrX2SraxHsVNyYSTMGdbaqN5w==
X-Gm-Gg: AR+sD11B3wmEniqH+IQh4pzjO7sH0FNyKCsGCd0EKD4w4XqaHan3obcdOJU4rXlEOpN
	cd0gWX9EaN8kaGpk0swYz28BnaK+R/FChiXQjXWy8l6EQLb1zYhzTaQfV7quGnOufjCHuiS2j5+
	3tyjmaXsrdz2YwzepJPuCPFjqIEuR56WaPoL7DKqjgjIeJpbB0QKI4teCVezCe4OSTrdCxdJCG/
	o+drroT+lOw6dsG0FKAKkV81qJ1WK/LTW9hVPlkJ6wYBtM8zupjpdi5HT4aFmIrGAKQOHhws1Iq
	ly6d6+fl1SvSNRNRXd2rr+P/uyIU94fNEhdIrBgao4G6ZUhcPcQ86sALnK53fEXBOet/JabWohF
	26VWnpwa5eiywKojboSz1kqHF7T4kzLiSJnt4QOFu1c4hrRD08lQNB7v5T3kPotu51/YxQGunaN
	wwq1Zv2flUIYIAr7ac+CPcFhUSrBbMwXrEu4KE7rxpL809Nfny4jVU78pI4A/8UDY6VFhTtSipl
	DPfGoRkKDqB5zj3rxxjF2NGAdDttphHmwitLHY=
X-Received: by 2002:a05:622a:c6:b0:51c:167d:b328 with SMTP id d75a77b69052e-52d854fb4bfmr260666571cf.40.1786979835949;
        Mon, 17 Aug 2026 08:17:15 -0700 (PDT)
Received: from ?IPv6:2001:8a0:c4c6:f00:d76f:1095:5248:4cb1? ([2001:8a0:c4c6:f00:d76f:1095:5248:4cb1])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-52db610b491sm16716901cf.8.2026.08.17.08.17.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2026 08:17:14 -0700 (PDT)
Message-ID: <eee05cd38c0d514b174cee132ddc44f6ca880f23.camel@gmail.com>
Subject: Re: ath12k: recommended regulatory country source for embedded AP
 products?
From: Vitor Soares <ivitro@gmail.com>
To: Jeff Johnson <jjohnson@kernel.org>, Wen Gong <quic_wgong@quicinc.com>
Cc: ath12k@lists.infradead.org, linux-wireless@vger.kernel.org, Kalle Valo
 <kvalo@kernel.org>, vdosreis@qti.qualcomm.com, lucia@qti.qualcomm.com, 
 dbenitez@qti.qualcomm.com, jeff.johnson@oss.qualcomm.com, 
 bqiang@qti.qualcomm.com, wgan@qti.qualcomm.com,
 francesco.dolcini@toradex.com
Date: Mon, 17 Aug 2026 16:17:11 +0100
In-Reply-To: <c7609911037798c2026636ddd13208cdf000cc55.camel@gmail.com>
References: <3ac168e7dfe22133daf09adc3f6587098ec85619.camel@gmail.com>
	 <c7609911037798c2026636ddd13208cdf000cc55.camel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2.1 
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

++ Francesco Dolcini

On Mon, 2026-08-17 at 16:04 +0100, Vitor Soares wrote:
>=20
>=20
> Hello,
>=20
> Adding a few Qualcomm contacts in Cc who may be able to help here, or poi=
nt me
> to the right people.
>=20
>=20
> Thanks,
> Vitor Soares
>=20
> On Wed, 2026-07-29 at 10:29 +0100, Vitor Soares wrote:
> > Hello,
> >=20
> > I'm integrationg the=C2=A0Silex SX-PCEBE module (Qualcomm WCN7850, ath1=
2k) on the
> > ARM-based Toradex Aquila SoM family, using a recent mainline kernel (7.=
2-
> > rc).
> >=20
> > Hardware/firmware: wcn7850 hw2.0 (PCI),
> > WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3
> > (fw_version 0x1103006c).
> >=20
> > I'm trying to understand the intended way to set the regulatory country=
 for
> > ath12k on embedded products where the country is configured by the
> > integrator
> > of
> > our SoM or at deployment time by the end user.
> >=20
> > My current understanding is that ath12k registers the wiphy as self-man=
aged,
> > but
> > userspace regulatory hints, e.g. "iw reg", are ignored in
> > ath12k_reg_notifier()
> > unless CONFIG_ATH_REG_DYNAMIC_USER_REG_HINTS=3Dy, which in turn depends=
 on
> > CONFIG_CFG80211_CERTIFICATION_ONUS.
> >=20
> > The SMBIOS coounty-code path, looks intended for fixed regional SKUs,
> > However,
> > it is not available on our ARM platform.
> >=20
> > So, I have 2 related questions:
> >=20
> > 1 - Is the expected ath12k model for this type of product to enable=20
> > ATH_REG_DYNAMIC_USER_REG_HINTS and use userspace regulatory hints befor=
e
> > starting hostapd, with the regulatory responsibility on the
> > product/integrator?
> >=20
> >=20
> > Or is there another mechanism you would recomment for this use case?
> >=20
> > 2 - Since ath12k is a self-managed regulatory device and the firmware o=
wns
> > and
> > enforces the regulatory database, is the CFG80211_CERTIFICATION_ONUS ga=
te
> > intended to apply to this case as well?
> >=20
> > In other words, should a userspace-selected country for a self-managed
> > ath12k
> > device be treated the same as dynamic user regulatory hints for non-sel=
f-
> > managed
> > devices, or is this dependency inherited from the common ath regulatory
> > model?
> >=20
> > Without a country, the ath12k falls back to world "00", where 5 GHz AP
> > operation
> > is blocked by NO_IR.
> >=20
> > Thanks,
> > Vitor Soares
> >=20
>=20

