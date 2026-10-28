Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.70.43.101
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793187666;
	b=DMnEPWGoceqId8n+X0S0rWZLM1cLlGkeZFn27fSEUTw0UJ2CRxUlOrBDVxd42SRKkOfn
	 Vpek8qRjZiptkCXMi9WGF2PIhWbAm+3iOaV8/IqPORDym9RJC1cw3ncul5vOJe7lFD4ti
	 EFaJEg7lb+LMlOR7wVi/krL5CPOilWEstj270hGs3B19xdSzYEamBZ63gZwi/Bqwyv5Bc
	 qX5etp/qyD6YE6PaTgtml5cYCylzdBxZjcuxWVsQni8zSu/Xp0eoI/DWQAWJMslm0h53t
	 wUiyaF1MHrhANAFOtlF0zlfthj6TZR/GBtHuiS9V+UgrNkWySBXnXD6dKb1nZcm6eoA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793187666;
	h=DMARC-Filter:DKIM-Signature:Date:To:From:Cc:Subject:Message-ID:
	 In-Reply-To:References:Feedback-ID:X-Pm-Message-ID:MIME-Version:
	 Content-Type;
	bh=kjcppBvneVUnosD6YCMOCH1CcIfDUQwbnxYvHz1mwTk=;
	b=WzX/CdsQj3+rsSyYEAx3/DIogndccCCTHjMGFv0KufDseClAkJYEnRHswrkIKqyHZNXV
	 3tmLhgNzG4gvdEA3gg1inM79yuGP+5ME8liJze153uB5KGMe1q8hUve2qR1+0GKGt5OLe
	 kTol3smhUPe3kVx0DHT5suiGa0bWEfakyLNyZNkmL3mMrc+iN2vV71X5t8S51h0n60Hn/
	 I34eTn2G3O13vWzjGbFmYLKygXCgzHGIUaWSffnFCRQog7hCV2WLYC1YyOT8HMkcMP7+t
	 aBK/Qqn7NX+wx5Ukp9jPkSFzlf/JQU/WDuZCKxxEOnw4/wJc0KiLM9mTF+OReMAprfA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=protonmail.com;
	spf=pass smtp.mailfrom=protonmail.com;
	dkim=pass header.d=protonmail.com header.i=@protonmail.com header.a=rsa-sha256 header.s=protonmail3 header.b=yhQODFCH;
	arc=none smtp.remote-ip=185.70.43.101
Received: from mail-43101.protonmail.ch (mail-43101.protonmail.ch [185.70.43.101])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E776606A31F
	for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 11:41:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8E776606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=protonmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=protonmail.com header.i=@protonmail.com header.a=rsa-sha256 header.s=protonmail3 header.b=yhQODFCH
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1793187663; x=1793446863;
	bh=kjcppBvneVUnosD6YCMOCH1CcIfDUQwbnxYvHz1mwTk=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=yhQODFCHoG/Zs+xTob40nVOQztXZEZQkDQc4Ilkm0Lau1HLwJAkWp1NQS6rK+Ovte
	 cAkx8H3m6yGS0088HimK1MT37IVm5vQzUumd0E3Eu/lWbAU6q+5fvtPVP9EF6HEigt
	 dzcNUmhBM8M+9KwbAidb2b7egEJamDWe6WMMB+Mlybn/gkzhiOa/UTdzIuduIRjMKS
	 loxaHMbjpJVqI01XtaSTPdI5ZF51TmuQi+YZARh5qXh7tOawE6Bbc2HeiRC92FzFAb
	 5R9IGbeDURH/eOEiiCk+Tz5A+OwBY5+Zj5pU/OQwe3gEp9Dxzvf4nZ/0sGj8DX5VGV
	 mqnibZPNuuvZQ==
Date: Wed, 28 Oct 2026 11:40:57 +0000
To: Alessio Ferri <alessio.ferri@mythread.it>
From: vit9696 <vit9696@protonmail.com>
Cc: =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>, Michael Buesch <m@bues.ch>, linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org
Subject: Re: [PATCH wireless-next v2 3/8] bcma: pcie2: request HT on BCM4352/BCM4360
Message-ID: <26B3AF24-FF4C-41A8-8546-8B79FC9C30F2@protonmail.com>
In-Reply-To: <20261027-bcma-ac-rev1-v2-3-b69b61c31920@mythread.it>
References: <20261027-bcma-ac-rev1-v2-0-b69b61c31920@mythread.it> <20261027-bcma-ac-rev1-v2-3-b69b61c31920@mythread.it>
Feedback-ID: 739018:user:proton
X-Pm-Message-ID: 973b6d359f0330cff6e88fcc469cb72ab6e04dff
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=pgp-sha256; boundary="------209afb9dac3de2b60d6fa79bd37326ece29f70325493df9df586b7d21c049eb5"; charset=utf-8

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------209afb9dac3de2b60d6fa79bd37326ece29f70325493df9df586b7d21c049eb5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.700.51.1.4\))
Subject: Re: [PATCH wireless-next v2 3/8] bcma: pcie2: request HT on
 BCM4352/BCM4360
From: vit9696 <vit9696@protonmail.com>
In-Reply-To: <20261027-bcma-ac-rev1-v2-3-b69b61c31920@mythread.it>
Date: Wed, 28 Oct 2026 14:40:42 +0300
Cc: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
 Michael Buesch <m@bues.ch>,
 linux-wireless@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 linux-mips@vger.kernel.org
Message-Id: <26B3AF24-FF4C-41A8-8546-8B79FC9C30F2@protonmail.com>
References: <20261027-bcma-ac-rev1-v2-0-b69b61c31920@mythread.it>
 <FT2bVQ2Rzcgu0W0TZd0Sd8RgwhkBuaExs_HgYjV94PesWAEd2s_Vuzn51cocstE9Mv4PuU0tydZIdyIEdBmz_g==@protonmail.internalid>
 <20261027-bcma-ac-rev1-v2-3-b69b61c31920@mythread.it>
To: Alessio Ferri <alessio.ferri@mythread.it>
X-Mailer: Apple Mail (2.3864.700.51.1.4)

This should apply for all revisions below 4, not just 3 as per open-source =
Broadcom driver[1].

Best,
Vitaly

[1] https://github.com/RMerl/asuswrt-merlin.ng/blob/ca72a61f8bc5ef920e29d63=
d53d9864262208f0c/release/src-rt-5.02axhnd.675x/bcmdrivers/broadcom/net/wl/=
impl69/main/src/shared/hndpmu.c#L2059-L2067

> On 27 Oct 2026, at 02:53, Alessio Ferri <alessio.ferri@mythread.it> wrote=
:
>=20
> Set HAVEHTREQ in the PCIe2 core's clock control on chip rev 3, as
> Broadcom's driver does.
>=20
> Signed-off-by: Alessio Ferri <alessio.ferri@mythread.it>
> ---
> drivers/bcma/driver_pcie2.c | 3 +++
> 1 file changed, 3 insertions(+)
>=20
> diff --git a/drivers/bcma/driver_pcie2.c b/drivers/bcma/driver_pcie2.c
> index cf889fc62..fd8fab982 100644
> --- a/drivers/bcma/driver_pcie2.c
> +++ b/drivers/bcma/driver_pcie2.c
> @@ -170,6 +170,9 @@ void bcma_core_pcie2_init(struct bcma_drv_pcie2 *pcie=
2)
> case BCMA_CHIP_ID_BCM4360:
> case BCMA_CHIP_ID_BCM4352:
> pcie2->reqsize =3D 1024;
> + if (ci->rev =3D=3D 3)
> + pcie2_set32(pcie2, BCMA_CLKCTLST,
> +    BCMA_CLKCTLST_HAVEHTREQ);
> break;
> default:
> pcie2->reqsize =3D 128;
>=20
> --
> 2.34.1
>=20


--------209afb9dac3de2b60d6fa79bd37326ece29f70325493df9df586b7d21c049eb5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: ProtonMail

wsCpBAEBCABdBYJq4d9HCRBPsoxt7Hy0xTUUAAAAAAAcABBzYWx0QG5vdGF0
aW9ucy5vcGVucGdwanMub3JnbSggtVt6+6vJGc3SA9EVqxYhBERSlkTqW1Te
3v1Bj0+yjG3sfLTFAADPAwf/e/zi3nOhbhBwicBIwGC5UAnxxaNyKtvivKGT
LJ0Z8qVHkQAdXtb33aIVz81eWN6+13BKdFF+mx0zKtRqWCSLSxRpQEj0tQOU
CulrSR04b8pwu9OxfqNr+3Dmk0OGo+sLpTnNOEpvhZcg8HFFRJ2BeZvE8Ltd
1GC7FWMm3eOLfzP+OPQaM3+X/axcmFpKJ4QAhFwPJmyBorETY2otYAx6CtlU
Agmf2IxS92ygY2jl8QsTpQ38GNgq5j3kQ1NiwZ4p0IM3aUeXz+fgVA4N9zIt
g7JDZ/WGvsTjSHghhzQKc8T7dZg3yT9jo/u+HB9QrFYjNFhN6yuzRbMqek5J
moetCA==
=qiOy
-----END PGP SIGNATURE-----


--------209afb9dac3de2b60d6fa79bd37326ece29f70325493df9df586b7d21c049eb5--

