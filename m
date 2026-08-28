Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A25083D4114
	for <linux-wireless@vger.kernel.org>; Fri, 28 Aug 2026 06:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787900198; cv=none; b=iOiay3nRDVsrjlfJoO09RpiyUibvgB/hGwoihQWJvTdeROgbeORztW1TOQX5zgT/RUlEx+eTSgdx9crvdUQcKViB/ej5nyEBwuF0bVZnTR1H5y9dd2SEDyzybqcEsSTIA9SMzP0EfiAUlPHjYRPS4wRjFhHB6qlybJXmda1BocA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787900198; c=relaxed/simple;
	bh=LSYlE1+BwlvYjghZCm2S/V3onBc07esLtzO5aFIWXa8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=huuKBIOK2GbVfebKezP9bEN5mzlcAn+NVM5owI6MbpqAI3ZJzSBw1ret2qPEdkJfYKmAG1gNpzvRRDvqaBlty1xMeme1jJe6SvCOEZx7JD6d8ytlkzerkzd/jOzRdQemQzD509mH2bl2hzXw6GlhdmT2MUq17iM9kqroYPI+JZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YOhNPspL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YOhNPspL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5E2D1F000E9;
	Fri, 28 Aug 2026 06:56:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787900197;
	bh=3cueG0W/OQjd9E81Na+vNIEIeU1OxVWf2cAMM0UFtG4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=YOhNPspLldbNmaH8lDMh8MrqS1+Y6YoJchCZgLtTp0vODq0SCMHh2eVnLkcDoee45
	 RW6OFYqBpVaMzIjaJz42AjMERaPDACg/b7kMes+EDpBlfd3ta8bUJ6dmaUSit86fgR
	 nz/s3EzOlT3BhFPQ9onsi16rxj4OvvkMJSlld//zPUIYmc4Ks9iby4Qdxr4XiRh3PS
	 g1/Z0gwcl8dSyDBWfyQc6qfif/dQ3k7Z80H2/3ix+3lsADdgzHxPO/p4IVjAfsw09D
	 kteAt8w4Xsr9DPTy+vFztDpiHLR6giwhXaGFNavr4dDBM6oKHz5wWvyoB8079gol1x
	 Te5swekiFJTbw==
Date: Fri, 28 Aug 2026 08:56:34 +0200
From: Lorenzo Bianconi <lorenzo@kernel.org>
To: Felix Fietkau <nbd@nbd.name>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH mt76-fixes] wifi: mt76: mt7925: restore the reset state
 when fw_pmctrl fails
Message-ID: <apExIpa_MwXdqHB8@lore-desk>
References: <20260827162115.1449757-1-nbd@nbd.name>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="IXn/ziA3sQ4eFvNL"
Content-Disposition: inline
In-Reply-To: <20260827162115.1449757-1-nbd@nbd.name>

--IXn/ziA3sQ4eFvNL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> mt7925e_mac_reset() returns directly when mt792xe_mcu_fw_pmctrl()
> fails, leaving MT76_RESET set and the TX worker parked. Every other
> error path jumps to out, which clears both. mt7925_mac_reset_work()
> clears neither, so once every reset attempt fails there, TX stays
> blocked until another reset succeeds.
>=20
> Jump to out instead.
>=20
> Fixes: c948b5da6bbe ("wifi: mt76: mt7925: add Mediatek Wi-Fi7 driver for =
mt7925 chips")
> Signed-off-by: Felix Fietkau <nbd@nbd.name>

Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>

> ---
>  drivers/net/wireless/mediatek/mt76/mt7925/pci_mac.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/pci_mac.c b/driver=
s/net/wireless/mediatek/mt76/mt7925/pci_mac.c
> index 280797fa0d85..67eb86746779 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt7925/pci_mac.c
> +++ b/drivers/net/wireless/mediatek/mt76/mt7925/pci_mac.c
> @@ -127,7 +127,7 @@ int mt7925e_mac_reset(struct mt792x_dev *dev)
> =20
>  	err =3D mt792xe_mcu_fw_pmctrl(dev);
>  	if (err)
> -		return err;
> +		goto out;
> =20
>  	err =3D __mt792xe_mcu_drv_pmctrl(dev);
>  	if (err)
> --=20
> 2.47.3
>=20
>=20

--IXn/ziA3sQ4eFvNL
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCapExIgAKCRA6cBh0uS2t
rO2RAP0R3HU8+v4KTOdYD0D67Y27gRY5Y5zPlKdvxtYvGSSKDAEAwJoJmfw+Oqj6
lDLax0LiwodJqNYW0XNFvTNOnAhHaQ8=
=SiXL
-----END PGP SIGNATURE-----

--IXn/ziA3sQ4eFvNL--
