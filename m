Received: from mail.bues.ch (bues.ch [116.203.120.240])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6AC334EF11;
	Thu, 18 Jun 2026 18:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=116.203.120.240
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781805820; cv=none; b=fdrB1DpDIc7y3Vi/kJqrg7qPk1kZdMfO1xsNazO31kKpsyEDER63voxokGVFv7e3QClzox61p6p1UDwfOqX+7cKJbd5am3GB+PvmvP0mruhWRTQ4fQwQUpvJJRMlzvz2aYxuDK6P2IFileV2iZlWfjvNUt0oeJbWkS6HfgLDsTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781805820; c=relaxed/simple;
	bh=YRsztucoKe4JwjbdvU4Wjbx5zwXQ31uVCUcyCCX8Nm4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GOWxgq3HM6uLP1HTRI+OS1Hs6Nqef32Ej/2fTvUh638WDAxmNRJ1RyyjUDq6l+vsSM18/NcfAUQAwAMkctFhAWkiF7zkL5IXh5ge4SUsWpX4Y43T3NLLnFRfOjJfZURgB1/LPzw4JekQUB9w3mTzK9VfIjrfQWCbUDuOHiUkAVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bues.ch; spf=pass smtp.mailfrom=bues.ch; dkim=pass (2048-bit key) header.d=bues.ch header.i=@bues.ch header.b=AgEqRZKK; arc=none smtp.client-ip=116.203.120.240
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bues.ch
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bues.ch
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bues.ch header.i=@bues.ch header.b="AgEqRZKK"
Date: Thu, 18 Jun 2026 19:57:14 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bues.ch; s=main;
	t=1781805500;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Gf8+j9kDlIC5pkDl3pjv/qiQOKadn5JWHV7389C8mhE=;
	b=AgEqRZKKtpeSq3dFPD57xFhHMdEySYJDW/JT2zVQwjka4YZzn1YdZIa89TuvT0S9zKxACP
	KR2M9HNeHfYPRypfvXxDs+rLMlr7XJf09+X5rzmwX4hkjl95dncw3AspIZHph8a0kstV8E
	Zp6NyIOyfvJiuD1A3wXsVq9IO1EMbE85oWg34b4DcLbch3VVSozypP9cZSTkD1metj0wNE
	wbn/jsNv8OVJCOcIr2U7Ojornbja5Z79BB7kJSxXnf+YRJGG64HOn9QCaROSTw5B9A82zN
	5AEsImgoU/XQcg2gIDvb1U/M4h8lD4H6/xHX40cuuol1iqQh5XtmZH9h3XTIOg==
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Alessio Ferri <alessio.ferri@mythread.it>
Cc: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
 linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
 b43-dev@lists.infradead.org, Alessio Ferri <alessio.ferri.3012@gmail.com>
Subject: Re: [PATCH 1/4] bcma: host_pci: add BCM4352 device ID 0x43b3
Message-ID: <20260618195714.5620e0ec@barney>
In-Reply-To: <20260617-b43-add-4352-wip-v1-1-c81323496720@gmail.com>
References: <20260617-b43-add-4352-wip-v1-0-c81323496720@gmail.com>
	<20260617-b43-add-4352-wip-v1-1-c81323496720@gmail.com>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/jAjpHEYdavIonoaH4M5Uz/v";
 protocol="application/pgp-signature"; micalg=pgp-sha512

--Sig_/jAjpHEYdavIonoaH4M5Uz/v
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, 17 Jun 2026 23:42:08 +0200
Alessio Ferri <alessio.ferri@mythread.it> wrote:

> From: Alessio Ferri <alessio.ferri.3012@gmail.com>
>=20
> The BCM4352 is an AC PHY. It is missing from bcma_pci_bridge_tbl[],
> so bcma-pci-bridge does not bind. Add the ID.
>=20
> The chip identifies as BCM4352 (chip rev 3, PHY type AC); b43 with AC-PHY
> support handles it once bcma reaches the D11 core.
>=20
> Signed-off-by: Alessio Ferri <alessio.ferri@mythread.it>
> ---
>  drivers/bcma/host_pci.c | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/drivers/bcma/host_pci.c b/drivers/bcma/host_pci.c
> index 3dc2985063f1..f6cf722a3798 100644
> --- a/drivers/bcma/host_pci.c
> +++ b/drivers/bcma/host_pci.c
> @@ -298,6 +298,7 @@ static const struct pci_device_id bcma_pci_bridge_tbl=
[] =3D {
>  	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x43a9) },
>  	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x43aa) },
>  	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x43b1) },
> +	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x43b3) },
>  	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4727) },
>  	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 43227) },	/* 0xa8db, BCM43217 (sic=
!) */
>  	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 43228) },	/* 0xa8dc */
>=20

Please submit this patch last, after the driver is expected to actually work
on the device.

--=20
Michael B=C3=BCsch
https://bues.ch/

--Sig_/jAjpHEYdavIonoaH4M5Uz/v
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEihRzkKVZOnT2ipsS9TK+HZCNiw4FAmo0MXoACgkQ9TK+HZCN
iw79/xAApSa8gie6f7YYYepTM2teMOo7lqt5rKHR0iK5rWqhgF8kca4QFukgP0gs
Ijlj5yyGZ/HOVA5l7bE0BIpJ0bPvjQBwOSbo4xpzNLPVN9dnJbqNu+HLsXRYI9Ze
10c5h75tkEpYq5acGzZ8wmq2hKRWWe24u553qfMm+4QhTDdJF8l6dtp6cQqDDfWI
sUeyfThcdd8YwVBnrLVhHLLPlL1qru/6QMIX3yNuKu5aneI6h3GOMhrMJMz+UH61
rhYmA4wABTP2dnwkvwAjy52K/w0M4Ykg7RKiEyvisJhm10d4ms9i+SywApjNaTUh
hGI2dVBBiRSyWkKtfeVwGxu3fbMsU/rW0wwD/SAMkxgtfvYlROilVQRjwk7WCD7i
JDm8HXq0cfBR7qnPAKr8gN2VsPO3XAHtzRebQP+Ew/SHCoEi/SjFzVVltvQcHrcf
NdY9gIVYY+6qDeDiq2fzCT/rEWSLpEe4aTd2HeFqXn5n3CU3SAYkDUOhPmbuHASy
sZb6AsKSYEjtCNQ4wLLgOnG+v1KlSnXqi74Bm6beTrX19ABP/bekM5n3AMBqIN2F
CHT+6mNjr3PBp1erXEB7XUMZU7xxEaRfaUjtBdFAljdKdLADP8HaJytLcUkrYY8g
Nz5ubxeLP7YM5qulAa7+gI0Vs6kDzzl+YLUxp4ShveB8JBZicJQ=
=htaX
-----END PGP SIGNATURE-----

--Sig_/jAjpHEYdavIonoaH4M5Uz/v--
