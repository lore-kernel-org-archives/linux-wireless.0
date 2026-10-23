Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=116.203.120.240
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792788145;
	b=qE/w44oSxkKkQZAv3TrwM2KXsHpi+D14Fa/JvwMALxZpEEK1PFH6OMulSNHvT24k2pwO
	 GQVXjNRHWmVHqTfmMehYwozYUHvqOIBlNaWUekdTLKtFgPqHGlGCoVynripyjmmSfru1q
	 2WSGkpsCFl+X/k6MAKpJB/Gn76r28vUcnwE4AgW0DAYb9sbLCsgOulC3Dk+O3X3RBqJhw
	 EzSUU9JyFHwEJL1dM4Bp7x1ROTdgFdey7y7IpVl97rhaDxEGgEb7VNhGgUsA3+dTcMLJx
	 GyMgt3iI0hOjguIeJSaUuDDztiAFNaJAeVlgQ1n7WnYU6a7l4APfHxE710HjpUc8u2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792788145;
	h=DMARC-Filter:Date:DKIM-Signature:From:To:Cc:Subject:Message-ID:
	 In-Reply-To:References:X-Mailer:MIME-Version:Content-Type;
	bh=COpiAirfJW1xxVg1u9cfsoxdrpIGBM2kVJHRlSGDvkg=;
	b=2T6hfwnJGurW+YYweXbWGrfVIOLbE1HJPigJjd49bJUcnPJPtWyzMHjnTWfP/1xDU0Zb
	 kmhHsmi8BpMMTFGQdhGII2oD2KMJJwCd4Gmp69KlbtbADu2DpTsG8C9bwq5kSi1wLSVoh
	 Xw/AQTLwkJnRS8+giuOHk2fvsS18Bk54w9u8mZXKGOLacPoG3HftWOojruDCtmxNBoxs0
	 fsX38AR6cmSQa5VtnWsiyQIOuEYAubeLLV/v/WMjVXrplKk6KZ48PqPTn+mx02u9pvEvS
	 AFUQpY+1sxbN4sOkLx19FdWEPwAAbUjo4goHB+pcZOLj4noPCQVMUacJMTHwJTokgEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=bues.ch;
	spf=pass smtp.mailfrom=bues.ch;
	dkim=pass header.d=bues.ch header.i=@bues.ch header.a=rsa-sha256 header.s=main header.b=C5WH1fbR;
	arc=none smtp.remote-ip=116.203.120.240
Received: from mail.bues.ch (bues.ch [116.203.120.240])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 746F4606A31A;
	Fri, 23 Oct 2026 20:42:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 746F4606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bues.ch
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bues.ch
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bues.ch header.i=@bues.ch header.a=rsa-sha256 header.s=main header.b=C5WH1fbR
Date: Fri, 23 Oct 2026 22:41:40 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bues.ch; s=main;
	t=1792788142;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=COpiAirfJW1xxVg1u9cfsoxdrpIGBM2kVJHRlSGDvkg=;
	b=C5WH1fbROxWG8k5bo3Oorcq018DJ/1QAQ3sH98NBUe/W+mNyvOlP5NwTiah9H4yO7deKiA
	AptTBgxGQSVlkqHOVt73MOmNXftzsJaOCLE945+Ep+1HPYUsQ9iDCfSWB5Q9NnFSYtkKXx
	sHpgvAWSelL39NEH46bEUfkgiHKIymYS5gEAQ9E+aJLIUGs89qTx0p/q1l5PmFCiApLFRm
	kFLnr5+ynYqYpxRlZDj0jvQx000ULbJemAND1d97N2v5a+j/HGXMgbJTiW9DYfAlaMB9YE
	isqW1TMtT7JKWkhRrXY+kh/M8f3SuO1VbvlTzx5F0pwQNxm83Vh1g2Mq+IJSvQ==
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Rosen Penev <rosenp@gmail.com>
Cc: linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org (open
 list:B43 WIRELESS DRIVER), linux-kernel@vger.kernel.org (open list)
Subject: Re: [PATCH wireless] wifi: b43: map the RX buffers
 DMA_BIDIRECTIONAL
Message-ID: <20261023224140.465903eb@barney>
In-Reply-To: <20261023221424.2722795e@barney>
References: <20261023190653.70741-1-rosenp@gmail.com>
 <20261023221424.2722795e@barney>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-pc-linux-gnu)
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/A+dZC/cF/CkDIhpzPpycaYS";
 protocol="application/pgp-signature"; micalg=pgp-sha512

--Sig_/A+dZC/cF/CkDIhpzPpycaYS
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

To explain this further:

- I might be wrong, but this patch looks completely bogus to me.
  Why would this be bi-directional?
  If this is accessed bi-directionally, there must be a bug somewhere else.
- Please provide a HUMAN WRITTEN patch description.
  This is really important.

I am all for using AI for development.
Especially for such old and legacy code.
HOWEVER, there must be a human present and understanding what is being done.

Please slow down your submissions.
Think about your patches before submission.
TEST your code before submission and send evidence of your tests.
Untested code is to be rejected.

--=20
Michael B=C3=BCsch
https://bues.ch/


On Fri, 23 Oct 2026 22:14:24 +0200
Michael B=C3=BCsch <m@bues.ch> wrote:

> Quite honestly, to me this looks like a lot of AI slop is sent to b43 the=
se days.
> Can you please slow down your submissions so that actual people get a cha=
nce to review the stuff?
> Thanks!
>=20

--Sig_/A+dZC/cF/CkDIhpzPpycaYS
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEihRzkKVZOnT2ipsS9TK+HZCNiw4FAmrbxoQACgkQ9TK+HZCN
iw4QPhAAi17mINLOEeqDnVvjz/BSwRowOsI4dK9+hEjvuleukzqvk0T2kSNFrU/9
ROF7PHAiOJeT3ywsRBiR9LI2ik5WvBaRWlJXnBZ42Z7Fl133A+YA/Ixh4qwro/1h
S3x7xFtqOhy/2v8ZppvW1FPc+w4GCevTfYwj+9bvfy0WHbu5VozQwUdIjY5B6vLm
hGaHlTIeL5Bs4K2+Rvp4i1r4nGZ5uSD8Gkd+PZoj0m/4fpaDsOJLJVXd25HdrPi5
XZQUlN3I2AJJL0t7EXqX60CopYEDVKMjQVrjRj4QJr51BLDMZVMOmaqpY7aNCaJ/
zGhp+94+EltJr39uhyjhZoDlE7MKb/XK3hyqUdJyLp2FvosrCYjiyt3oCdp0Q6l0
PqrBOmErIttstglW2IA7kDDdSH84lB6mig7z/0E4W8v/iAbbQBxNXAEqJaeV4cv+
fWzguyokIrn7tqlSpHCqqn8mNYKxnunjRPODmmXeTA02YWJhf0gH5vxKtu4dAKpc
7PDfg7gSx6N60S+mXtmaZOmLUrMmrmV09jGB9VKqO2kjDj5pOtAUqnVlIQdYFVx2
4DpN7yORaE+IvMVADn9dhvqzJ/nhDJFXwgAgTynNAzvCJAyDBTZX/AddsYhVCL+0
GmmpshB/urhaR5e1siORgsGMIzY8xzaVJ0/IWdcKvpbvCK59pKI=
=Xmwj
-----END PGP SIGNATURE-----

--Sig_/A+dZC/cF/CkDIhpzPpycaYS--
