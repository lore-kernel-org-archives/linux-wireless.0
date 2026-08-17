Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9805A2EC54A
	for <linux-wireless@vger.kernel.org>; Mon, 17 Aug 2026 15:04:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979081; cv=none; b=g8l6f+Q99HScSpaSQeFdIfptqDcfMcqqBuWLKDAY0hYoV8KY4k5dziSmz9hSRtXKLaP4Gw7gw5/SCCK4mgaMDVOPf9VMStqWd/qchljjp/H6NZelVxXSCZgh7CVRuFSSkq80GNxYIGwRvEwrWR9vjBki1FPgjcDjd0bIIKVWd4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979081; c=relaxed/simple;
	bh=goe6aOcHRvgSEXBfM1lwHOaQCDFBo3a8JMtjcthvdTE=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=GQpCEgQwTMm9gzTPCOrODluP/dBhA9fUGjnhC+BiNYzMMsCWRy6x8qRnpbxSuVFBdL3kw2uR6umgJMdrCRmixwcJBrxEqcWhVjycytYk/L6hOCNj9aAeSRUp6Y9/KZraTS4Dk2iGUPOMphH6lc3jlli+wlU5mHs/WgBuk5UsuHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=I8I1ZuL6; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="I8I1ZuL6"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4954dff6536so26017155e9.0
        for <linux-wireless@vger.kernel.org>; Mon, 17 Aug 2026 08:04:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786979078; x=1787583878; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=goe6aOcHRvgSEXBfM1lwHOaQCDFBo3a8JMtjcthvdTE=;
        b=I8I1ZuL6AzYjmMaKaZ0PR7kpGstEc73g005GjQFIZ2NKL6zYk8O9cqbWmh9MPMgWr/
         IVoxOVCYqqPJ7vLmspQDyMqbTmpwQvuiLh5Fe/ymB5DrkPlJN/370xvlIkz+9u00YnCV
         RCS2W97sXNXFDAvzEL6uAy/q9JLMuiCnxERqEjxGUAU/25HEDxTdaV1/5kIT8CyeAnSP
         hlfgftxGLFul4Gth0MTKAdZkRfvhZtGw0pzo5lpJHufuoiJ0HK8IX53o+S48SvdAXlbU
         EB53dVXNZv41UDvMtdfboNAwhzgwgduGfFioNx6zTyyWoA6idcfvGVCgvLUdYcMR9P9G
         TkMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786979078; x=1787583878;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=goe6aOcHRvgSEXBfM1lwHOaQCDFBo3a8JMtjcthvdTE=;
        b=LYBRwBFlIs5Y/ME5GDGy9teOqJjPNzSES15O4iJj69NIw92uTr/b6513O4tsSp0X2I
         /TNfIy4p1gLWkvHsKHlzdXm7xcNei2HzQaHm5cSiaL4lsdbd5gRn4sat0MiKD/f3hAor
         cSN4KUJ6LkClsAG24rKYGA1zaxttF6L6kJfKdvUQ4TR5nWCPyB2qXG7jtXrED8hvTLVi
         eFVGtX8+6UwblZokfYY72CRUXrSyoVrgOY/UvCiBmkbbs0g3NVVymaoR7TZJ2meE7fGf
         hAWinPGZUT8SdpqFrzHN1Zk96RuqJghGemAdHWZbiaSueJDu4c1v1XbxyOTYFQGJXLET
         +ZpQ==
X-Forwarded-Encrypted: i=1; AHgh+RpM5caR62EfBRo215fTFomxbwoGBxfw+A0qfWjeR9KQ1GnKqMbIXZF9pQ36Pi66Uu3rNjyZym605UfyyjqPeg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyihXuEZ9Nd5ZqvKTz8wf43yC4ujeWEsBRlZJxl2XQ7fHuZfKSk
	kFDaqX09leLXz5I95W/krRrhzKuLrOpvVMpXRHfOlpu2FCiCMdXJRTKa
X-Gm-Gg: AR+sD11VPAL6t2x7sGJVGRHwBkk9vbBkwFkmEHBeU42mZJg4KgLdQluc/J3EXDnri/U
	aQclkuIjjHk8gAy1fih3n5BMp1fhOQGXf/XMnSsxXU4lpsGrUYNAdqnLMOnUDFV92mnxlMhYhZv
	aabC8MPa4/TXtD4+/E7kEzDJERug2fdFU6jiuDg/lTRbBMzVZ3jLwF+Nut/LeGM7ce6nZyuhDyR
	T4KN29+2GFSu/m3HAIwFmoKkVTrfKg8KAA6aqWrNIC+cOHgz56EeKE5LgIfGmDc8tu1TMzlee7P
	K0A/VrX/vnShJ+JBXEW2NJwwGbx733TYmLHIVwTGKNMCTpm0OAsrkEctzBGtzHGRSOx4xxcWu52
	gVsyV22npQ1uzld779hTUpXv8zMab/XP88Q6t93piHU5LYxHTzXvkMzZ5KvSoK5vbH6OEkqTfV3
	bmvtXFYdELcPtEt6GLZ7WqCRryCp0Mz9ZDePY+8pWpYBxlwmMf++tyW/1DM2uPZ4h/T7z4Y3Lq+
	M0kKWAjjax3+gI6mkFiVYwLMEzy
X-Received: by 2002:a05:600c:a4d:b0:496:ca1f:a428 with SMTP id 5b1f17b1804b1-49987981e52mr422766515e9.19.1786979077455;
        Mon, 17 Aug 2026 08:04:37 -0700 (PDT)
Received: from ?IPv6:2001:8a0:c4c6:f00:d76f:1095:5248:4cb1? ([2001:8a0:c4c6:f00:d76f:1095:5248:4cb1])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4999d10be27sm60932455e9.14.2026.08.17.08.04.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2026 08:04:36 -0700 (PDT)
Message-ID: <c7609911037798c2026636ddd13208cdf000cc55.camel@gmail.com>
Subject: Re: ath12k: recommended regulatory country source for embedded AP
 products?
From: Vitor Soares <ivitro@gmail.com>
To: Jeff Johnson <jjohnson@kernel.org>, Wen Gong <quic_wgong@quicinc.com>
Cc: ath12k@lists.infradead.org, linux-wireless@vger.kernel.org, Kalle Valo
	 <kvalo@kernel.org>, vdosreis@qti.qualcomm.com, lucia@qti.qualcomm.com, 
	dbenitez@qti.qualcomm.com, jeff.johnson@oss.qualcomm.com, 
	bqiang@qti.qualcomm.com, wgan@qti.qualcomm.com
Date: Mon, 17 Aug 2026 16:04:35 +0100
In-Reply-To: <3ac168e7dfe22133daf09adc3f6587098ec85619.camel@gmail.com>
References: <3ac168e7dfe22133daf09adc3f6587098ec85619.camel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2.1 
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0



Hello,

Adding a few Qualcomm contacts in Cc who may be able to help here, or point=
 me
to the right people.


Thanks,
Vitor Soares

On Wed, 2026-07-29 at 10:29 +0100, Vitor Soares wrote:
> Hello,
>=20
> I'm integrationg the=C2=A0Silex SX-PCEBE module (Qualcomm WCN7850, ath12k=
) on the
> ARM-based Toradex Aquila SoM family, using a recent mainline kernel (7.2-=
rc).
>=20
> Hardware/firmware: wcn7850 hw2.0 (PCI),
> WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3
> (fw_version 0x1103006c).
>=20
> I'm trying to understand the intended way to set the regulatory country f=
or
> ath12k on embedded products where the country is configured by the integr=
ator
> of
> our SoM or at deployment time by the end user.
>=20
> My current understanding is that ath12k registers the wiphy as self-manag=
ed,
> but
> userspace regulatory hints, e.g. "iw reg", are ignored in
> ath12k_reg_notifier()
> unless CONFIG_ATH_REG_DYNAMIC_USER_REG_HINTS=3Dy, which in turn depends o=
n
> CONFIG_CFG80211_CERTIFICATION_ONUS.
>=20
> The SMBIOS coounty-code path, looks intended for fixed regional SKUs, How=
ever,
> it is not available on our ARM platform.
>=20
> So, I have 2 related questions:
>=20
> 1 - Is the expected ath12k model for this type of product to enable=20
> ATH_REG_DYNAMIC_USER_REG_HINTS and use userspace regulatory hints before
> starting hostapd, with the regulatory responsibility on the
> product/integrator?
>=20
>=20
> Or is there another mechanism you would recomment for this use case?
>=20
> 2 - Since ath12k is a self-managed regulatory device and the firmware own=
s and
> enforces the regulatory database, is the CFG80211_CERTIFICATION_ONUS gate
> intended to apply to this case as well?
>=20
> In other words, should a userspace-selected country for a self-managed at=
h12k
> device be treated the same as dynamic user regulatory hints for non-self-
> managed
> devices, or is this dependency inherited from the common ath regulatory m=
odel?
>=20
> Without a country, the ath12k falls back to world "00", where 5 GHz AP
> operation
> is blocked by NO_IR.
>=20
> Thanks,
> Vitor Soares
>=20

