Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793292679;
	b=kzKbY7aOwTv8K1WmmVTRWNrJLF8L2y9PB1ATkc8KnuKNFj9F1YDhhGtw0e8yaX1lzhvG
	 Cuehn6pC99PAim612YE+iHwq1riWZyT2nG07SYTYAatsy30D5FHLQBjM/fb31yjFXkGZD
	 U92SblkTOH2lSUSO+OLo5w4X4lvtZPAJD3hP2MFgigLnIOtCjGOC9KSsjnAqdTU57Nzz/
	 XF+KGwYydmW2r2try9mAoq/NV6/2508ghAw2Sf4LJoPmnV6OEJf6jj7hoEL0gEjvmTVDC
	 2r7XS3K+FmtKtf7k1AA2GWP9z2lWVSmijB+eGrzhQToaxRjTcs3eVvBM4DDQPqIczIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793292679;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=q7E9UfoWQWnqho2nQB011oITjH0OZoiCPBc9CYnDpQE=;
	b=TnQBnC9F7KAha2K53VHhTsuQkkuiE4PZMdL+oY1Tu19nY/yqavLHM/af39B7XfD+QIys
	 AlHXurgDiN3RMSpUCzRY9CB+qE5MbBtJnihX6u880DPGubRZfI8tIJ2uq7mlqpBoGe7X+
	 Kxy/j1YnsY4bOiNUF+fh82W/cL14IQOz056vxu5/tyr7m3Oi8sWxeNAv6nDslHWzzZFPQ
	 3jDzepIHi9FGXeQMWMjjs2v2cHfdgtnQAv8BhlIKPgXp7JPIO6BB8nMCV0aPQoPXHZyMn
	 WnCGdnH4FyTfxztspeW+L2zlAUGSg4g/Ryum07taZr9+LQ8WBu7aUN7k4YemLIEN6VA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=04ij2npp;
	arc=none smtp.remote-ip=209.85.221.48
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDE2A606A31A
	for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2026 16:51:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BDE2A606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=04ij2npp
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-48df54150dfso1337241f8f.0
        for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2026 09:51:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793292677; x=1793897477; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=q7E9UfoWQWnqho2nQB011oITjH0OZoiCPBc9CYnDpQE=;
        b=04ij2npprqIZ82VNK3B3XQmyxEBEXwdkPaRjeEAF24TeCEoZNxvx/sxHojK0ryEJrK
         p7UuiNlxSNCw+SSDrvWPK94UX4TKAIFRfiSATQJ2t8PcEVy1dtDmTebPob5Wnb323xID
         GQhY0nlmXonKdV8eoEUJkFFed4W2885V+w7gJyRSo0cAVWnc1NZ6YeWCDCOV3J41RFaN
         Na6A4UKqNk7DPSI7gYEfTZhPYhM2zf/s2Q5KfUsfbvSDumpcieoI4lvgKmnAcz728p6u
         qF1hbN4BtNTFP9MF1ewuax2DyfJWEyPuAdK6reXKQvkHsbZAbd0Fh89EbY9Pi+IuADJt
         PfUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793292677; x=1793897477;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=q7E9UfoWQWnqho2nQB011oITjH0OZoiCPBc9CYnDpQE=;
        b=oGVs7iIpQw2BzdrEEUf1XtIFj8pUdOtRM4PunwD+WwzjWYNNKauZ23y2Ug+/2oCSnN
         XvnQAiNq4PlPc3G+8iKv9nY8dFkAZsLyePUxyH0V0rjbBKLwkXZfbOSxIFQR81pe66ED
         6TH4tqxkrG9v+eb1gI0oEymJxwJcFMJWq4pM+tuoZhZH4OzbZM51rXRVQWe0hbkIbpe7
         rg9ym9c6igX+ieHEwe6S0SUrloRdowhwtD3F2XF4CmdAw/2LrLuKWw02BXuKddBFccNu
         dVktAktlVEV11pAEhSJ4qz3XqUaxpnakZEm+YGjOmbWA80Nb9eqEvKOAUNeVde5RoTfq
         E3RA==
X-Forwarded-Encrypted: i=1; AKwUvBwNBp98I+d1qqv3H7SWcql9Qscsi/JUL7eiwF0wI/sJfDXHEO2+VNrcu/JqttyGFLrC6FEyuufFS1IstW4p9Q==@vger.kernel.org
X-Gm-Message-State: AFq9FYLfA6G3cpI3tFBhbK2rRWdpBzq1pTJb2mMQdRr+EYZV705JSgzM
	PRdDNLBSn/2fzGCCBQ/ZrEVag0whqr4afhujkYc5bsqIra9BwkCJj8s7
X-Gm-Gg: AYBFou3T24aGzVqWF1vgpoCsu0YTxqH4/YbGYxfA4smpKzr47fE+8jZeVOd9RCAWwNf
	mu2Q9OxZThUCQgzZk2q73Y/HvA7alLOA6hFNPsgwZta7CRBimpDANAHxOeUvQl12kwg6/Y2KrXJ
	apwGDypjUpkodufJZreb0glW2NEOqYMZk2INQs2ed4jEPfCRoSL++q6f9dRRqu0mZqD/VbHtsB2
	wTrQHS2JKaIOYP1Ogtrr4Es7DbTuGzioOUeg31hkrhDYjYlBvoS+gVW7vn578XTihOXpufNT7U9
	fQOdUp1MVohj2tmoOk+KNxQdxtvpsdnJJz76AJeY5D4dqFtRUCcX+4pUNTVgUDeypP+nNJldLhX
	lHGV6MNxbYMqKlPl221L4yORZSeV6LfFW2DPPVXk9kEoUsneBOjmFuOPRVmIapE+6byEQip26yQ
	nUhgB9l4oiYIdHPW5RHc9NfQpA70w5mKFdKv8PiiH1Wm2EWztN2Ry5UPDPY37lXunqMzfxomqSe
	bFcG8MssV6otSjyH6RQGXaATlVl/9WI9nWopVHf61T62hPC5epZUp8UJWRpUnl7q9SCAjiXVFS1
	ExtV0p++j7Qh8qYE5fn0e0svlKrHnHYe8w3iwt0P3a/K2mYCTXppnO33Rs5ggnZgVwSt0/g=
X-Received: by 2002:a05:6000:716:b0:48b:a21:87f7 with SMTP id ffacd0b85a97d-48e5d5c9c95mr13396446f8f.44.1793292676786;
        Thu, 29 Oct 2026 09:51:16 -0700 (PDT)
Received: from ?IPv6:2001:8a0:c4c6:f00:e9da:bea7:ee57:4c6d? ([2001:8a0:c4c6:f00:e9da:bea7:ee57:4c6d])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e6dfa0605sm264471f8f.32.2026.10.29.09.51.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 09:51:16 -0700 (PDT)
Message-ID: <03564cc2f89c64f9dd06624dae01d6575a202bad.camel@gmail.com>
Subject: Re: ath12k: recommended regulatory country source for embedded AP
 products?
From: vitor <ivitro@gmail.com>
To: Jeff Johnson <jjohnson@kernel.org>, Wen Gong <quic_wgong@quicinc.com>
Cc: ath12k@lists.infradead.org, linux-wireless@vger.kernel.org, Kalle Valo
	 <kvalo@kernel.org>, francesco.dolcini@toradex.com, lxluxo23@gmail.com
Date: Thu, 29 Oct 2026 16:51:14 +0000
In-Reply-To: <3ac168e7dfe22133daf09adc3f6587098ec85619.camel@gmail.com>
References: <3ac168e7dfe22133daf09adc3f6587098ec85619.camel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2-9 
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0


Hi,


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
ator of
> our SoM or at deployment time by the end user.
>=20
> My current understanding is that ath12k registers the wiphy as self-manag=
ed, but
> userspace regulatory hints, e.g. "iw reg", are ignored in ath12k_reg_noti=
fier()
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
> starting hostapd, with the regulatory responsibility on the product/integ=
rator?
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
> device be treated the same as dynamic user regulatory hints for non-self-=
managed
> devices, or is this dependency inherited from the common ath regulatory m=
odel?
>=20
> Without a country, the ath12k falls back to world "00", where 5 GHz AP op=
eration
> is blocked by NO_IR.
>=20
> Thanks,
> Vitor Soares


A follow-up with some new information, as this now blocks 5/6 GHz AP
support for our customers.

I checked the Qualcomm Linux kernel (linux-qcom), used by meta-qcom:
it enables both CONFIG_CFG80211_CERTIFICATION_ONUS and
CONFIG_ATH_REG_DYNAMIC_USER_REG_HINTS by default for all arm64
machines, in arch/arm64/configs/qcom.config.

General-purpose distributions, on the other hand, keep
CFG80211_CERTIFICATION_ONUS disabled. Some of our customers run Debian
on our modules: with the Debian kernel, the WCN7850 stays in the world
domain whatever country is configured in hostapd, so it cannot start
an AP on 5 GHz or 6 GHz.

I understand that ATH_REG_DYNAMIC_USER_REG_HINTS was added in commit
94e7876daa43 ("ath: add support for proper dynamic regulatory hints")
to keep user regulatory changes behind CFG80211_CERTIFICATION_ONUS.

Would it be acceptable to update the Kconfig dependency or help text,
or to add an ath12k specific option, so that distributions can enable
it?

Alternatively, Luis sent a patch for the same problem that allows user
hints only while the firmware reports the world domain:
https://lore.kernel.org/all/20260228201023.116947-1-lxluxo23@gmail.com/

Either approach would unblock us. Any guidance on how to proceed
would be much appreciated, and I'm happy to help with the patch.

Thanks,
Vitor
