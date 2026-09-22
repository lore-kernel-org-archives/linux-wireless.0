Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7896341D647
	for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2026 09:29:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790069399; cv=none; b=nQD3JxEgkcccSLhbEhBJWucWSp9Rvjvt4U66rkMVF3VsFH7HVLc2CB/nz7kM/l2HtEloNQed1AhemAEjXVWKFbrje+Bd/uuR8RWnHjrIBosM0StiFGPY5C5JquKBP9qIWichpXnG1Arwtj6QWLO79TFiGRmSGy+BDjgV0gdAH8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790069399; c=relaxed/simple;
	bh=kCs7pv5QqIjoR61lLvcvhkr9df2eaE8KCWdj5A/isNE=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=H5ZhfuY6tfItsiq40ab3l3qHtYTA3Np7eYKnghX4IXvCvQp5HNkYRTlL15x0EV09g7BJS/Mf3x5Y9llL4TeWQ82MJ88e+QsTaDp97bJXMDqMhwMxhtGPWfSXMl0eQXw9g0q1lb/SC3HPSIPbbKozdkI9DzU16Jnu573kJLKVDao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=btWQfsfk; arc=none smtp.client-ip=74.125.225.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="btWQfsfk"
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-48439feca17so3012243f8f.1
        for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2026 02:29:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790069396; x=1790674196; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=kCs7pv5QqIjoR61lLvcvhkr9df2eaE8KCWdj5A/isNE=;
        b=btWQfsfkiyK6HuYgjswrViFrTSBcAwzGXvem3YK3We8DqkOdTLYufYDpyQIRvZW+jl
         DVT2lwHNEQ7JVT6geLrKxh1BhoBw4c7mZ0yOstXvf+IYNkUzqtrkGfBuUGCVQHRbCrjo
         GnilrI/dluC+EycIQqlDTJuhVWa8KDKT154FbBV1q1cdui4dFrcBtwqqsTcv6wQdQLZA
         d8dio4k1v04q4jlHmXmgkROoPWJYAOyXOrA7LhIBRGNsws/frsalff1zvDEj+8RlnUpS
         3Jp/SC/1JUafMwBMxUQ2HBWmEVQoVRCEq0eZUBGLL/Wh/gcL24o3YWjAq5ATkIOSCbQy
         4dng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790069396; x=1790674196;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kCs7pv5QqIjoR61lLvcvhkr9df2eaE8KCWdj5A/isNE=;
        b=Uu8wngYbN+fcrLfR1Cw4RzvZdC6EVqfZD4yEKGWRFSoA/p4VakeuN2128TysdqEmO4
         +oD84xma2ldeELX8g2OKns5gN1tHb/QLscyyXEuJlyZZ1+kD2gnDo0SuUuJYELh+/l07
         XkZ2eWseCmcovvTca1pmujGWJ7+XYOt/Ob0GvMUXzrnQEPWmj4kqVTOqtzCnLcT64h5r
         dLl/YAPeywpX0aGf3WJUDfng6/HLJvY+Wdm5lum2pQhOdKBg2a/xKCgEK8wq4BPeLfiF
         DjZppyQTuSFfx2QUU9BQLY8rG2to1N3OCkeIyiJTK9ytXyIqk+RmAY5maBybvQ/xudYQ
         ToBw==
X-Forwarded-Encrypted: i=1; AKwUvBwkAeiUv+RD3jV08lEV4wZF+/jYdn2QLfLdFcsMeSpL7toivtD2SGlZI5YrIt8akfXGt2jG49Ql+gHx/7lzIg==@vger.kernel.org
X-Gm-Message-State: AFuF++kD5SCpyTCfTpvhzYPoKsN59skS4WXsVUoRWIcsOPHOwR5ntXl7
	pqErN+GISCi0Al/JZyLgc6ZDwHa/LvICDku33UjCA9Q7PiEXgONxM1Ft
X-Gm-Gg: AYBFou3t+tNxOdO898I3hl0WGgxV9ullo2s2+QHoZLNbgzqgoP+MUeoRsS9MC/P62g9
	X0wrqqNSSDIaXLJmTBxSv+D6FA0KjoDv83ZC0TtnLQFPJCSlWsK5eH579gX8ELfeh8XOuIaXxoN
	0OAMMSrvcVlLpZY4XIvLyNNlEMCIPRqaxaftyMzrxUow3Y3aBXtsv24FKGgUI2PcX/O5pGQO/v5
	5vyXSH+ZKPOGA2gtprzAk24XmUqH4nl4vwvu/B4EwugsnilEAr2oPX+G5YGQJO/mFB4PBXQEpE5
	bawnl9eIpRmZ7hxZ8yTOtruDiKjNAE4pvjgGk/+3FRsFPVA0MV8lnPXbI0vA0aoqF0dwSbGqlK+
	O8CSLpLvpvvBYF2FmPBixHNe/iv0Nr+UusdbplQCvwxyQc21z8hjc3HBtqTHbJ+v63C7fAtge9l
	phL+lLedIDFPJU2fM+WN6Zkvi6K+NAvAfUVFr/8V8pc3hnlSOK0FFA+E1MMAorAfA/A7x2d5OJ+
	LpHq6OYByQenQjY98V+DWI6KQ0yo4K6vf718zzXfW3uDy3q7Ek=
X-Received: by 2002:a05:6000:40e1:b0:487:6f2:1a45 with SMTP id ffacd0b85a97d-4871e21c762mr19190325f8f.18.1790069395392;
        Tue, 22 Sep 2026 02:29:55 -0700 (PDT)
Received: from ?IPv6:2001:8a0:c4c6:f00:a510:942c:f93d:df89? ([2001:8a0:c4c6:f00:a510:942c:f93d:df89])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4886279298asm3082048f8f.34.2026.09.22.02.29.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 02:29:54 -0700 (PDT)
Message-ID: <c30b21e218bfb00a1eb3c52ea0b7c9f0dc828592.camel@gmail.com>
Subject: Re: [PATCH ath-next v3] wifi: ath12k: advertise interface MAC
 address pool
From: Vitor Soares <ivitro@gmail.com>
To: Kang Yang <kang.yang@oss.qualcomm.com>, Jeff Johnson
 <jjohnson@kernel.org>
Cc: Vitor Soares <vitor.soares@toradex.com>, linux-wireless@vger.kernel.org,
  ath12k@lists.infradead.org, linux-kernel@vger.kernel.org, 
 baochen.qiang@oss.qualcomm.com
Date: Tue, 22 Sep 2026 10:29:53 +0100
In-Reply-To: <974e540d-d6e2-4ebf-8714-98e4056083d9@oss.qualcomm.com>
References: <20260921173033.846332-2-ivitro@gmail.com>
	 <974e540d-d6e2-4ebf-8714-98e4056083d9@oss.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2.1 
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Tue, 2026-09-22 at 14:13 +0800, Kang Yang wrote:
>=20
>=20
> On 9/22/2026 1:30 AM, Vitor Soares wrote:
> > From: Vitor Soares <vitor.soares@toradex.com>
> >=20
> > ath12k supports creating vdevs with addresses provided by mac80211.
> > Userspace can already make concurrent interfaces work by explicitly
> > assigning different locally administered addresses.
> >=20
> > However, ath12k does not advertise an address list, so when a second
> > interface is created without an explicit address, mac80211 has nothing
> > to pick from and falls back to the permanent address. If the first
> > interface is already running with that address, bringing up the second
> > one fails with -ENOTUNIQ.
> >=20
> > As in ath11k, provide a list of usable addresses so
> > ieee80211_assign_perm_addr() can hand each new interface an unused one.
> > Keep the first entry as the wiphy's permanent MAC address. Generate the
> > remaining entries as locally administered variants by changing only the
> > upper nibble of the first octet, which naturally limits the pool to 16
> > unique addresses.
> >=20
> > The cfg80211 definition of wiphy->addresses does not specify where the
> > addresses must come from. Some ath12k platforms use it as an interface
> > MAC address pool, while others use it for firmware-provided per-radio
> > addresses. Gate the generated address pool behind
> > advertise_iface_mac_pool and enable it for WCN7850 and QCC2072.
> >=20
> > Other platforms keep the existing behavior.
> >=20
> > Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c7-00108-
> > QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3
> >=20
>=20
>=20
>=20
> I just did test on QCC2072:
>=20
> root@yk-Mayan:/home/yk# sudo iw dev wlo1 interface add wlo2 type station
> root@yk-Mayan:/home/yk# sudo iw dev wlo1 interface add wlo3 type station
> phy#0
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Interface wlo3
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 ifindex 6
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 wdev 0x3
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 addr 22:03:7f:12:be:cd
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 type managed
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Interface wlo2
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 ifindex 5
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 wdev 0x2
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 addr 12:03:7f:12:be:cd
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 type managed
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Interface wlo1
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 ifindex 4
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 wdev 0x1
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 addr 00:03:7f:12:be:cd
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 type managed
>=20
>=20
>=20
>=20
> Tested-on: QCC2072 hw1.0 PCI=20
> WLAN.COL.1.0.c2-00074-QCACOLSWPL_V1_TO_SILICONZ-1
>=20

Thanks for testing this on QCC2072.

I've added the QCC2072 Tested-on line for v4. Could you reply with your Tes=
ted-
by so I can pick it up?


Best regards,
Vitor
