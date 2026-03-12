Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3839238D006
	for <linux-wireless@vger.kernel.org>; Thu, 12 Mar 2026 10:43:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773312199; cv=none; b=nuAoFZfLM5h7lCa8f1PgFDNYkOd9WNTS/iReREDLgDbf5p9YCzXzx+xDuKBNo+W1COrFfpcKm268MyUFyQKNzfXSfl1JKEgThVgxPZVCmgXtUOF0SIdBW1HiUcvnjVYY15ZEgVi+QaDIOlocz+T9Y8ENCUEC1//drPqtgEf2Y70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773312199; c=relaxed/simple;
	bh=eNNwljuKwZpQJe7RmPn+/KLEEdwoQq78oBULF+I5elc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V+nzRMG7bviwMh93Gm/gdQmDXfxT/S4mWBKF3L8VGXMwmtaV4PePaz1nZiR3O70tkHfyQONVWE+2nEl2/bf8w0Rx3EEAWX48HsBuPnXHzh+2gNkArSPd+VQjO2SeZOV/dnvHKCCyJE5K58vG1LK9UUbzylf7CoaBZ+odmh7qhQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Wy+3RA64; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Wy+3RA64"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77D22C4CEF7;
	Thu, 12 Mar 2026 10:43:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773312198;
	bh=eNNwljuKwZpQJe7RmPn+/KLEEdwoQq78oBULF+I5elc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Wy+3RA64Z/zlQx9gOyRPs2OlYPKVDtgOmVzRs+mLaTOF/kzqQWqeZmB2ftMQeyz7Z
	 wK3SB2CjJVx9JtOi4Prp2UHScPmtJw356ycocviIMBqxPdr6wE8QwOHIRuhSzeVWTp
	 9udzzDwFEAqeKOPrr/sN1zyfVj2v3wSMv5lr6HB6jguxH8jk4gIDkbD3eekta9a04h
	 3Lmp7WKLmh3R4MoL0mstFnAEYowjEi67dTJcyG+Ce9Gthg0DhGkem3cbnMVus0XkJf
	 iTpYrv4JMZMaCyb822wjgW4gIb6rNVwdzb6fVSIYld8+mSYvc9NLSvtbc+Wnupykf4
	 TiRe6BapeYSrg==
Date: Thu, 12 Mar 2026 11:43:16 +0100
From: Lorenzo Bianconi <lorenzo@kernel.org>
To: Shayne Chen <shayne.chen@mediatek.com>
Cc: Felix Fietkau <nbd@nbd.name>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Evelyn Tsai <evelyn.tsai@mediatek.com>,
	Money Wang <money.wang@mediatek.com>,
	linux-mediatek <linux-mediatek@lists.infradead.org>,
	Rex Lu <rex.lu@mediatek.com>
Subject: Re: [PATCH mt76 4/6] wifi: mt76: mt7996: adjust timeout value for
 boot-up calibration commands
Message-ID: <abKYxPItJrrIcODc@lore-desk>
References: <20260312095724.2117448-1-shayne.chen@mediatek.com>
 <20260312095724.2117448-4-shayne.chen@mediatek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="6oGIyq5Z/UamuDZT"
Content-Disposition: inline
In-Reply-To: <20260312095724.2117448-4-shayne.chen@mediatek.com>


--6oGIyq5Z/UamuDZT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> From: Rex Lu <rex.lu@mediatek.com>
>=20
> Align the vendor driver by adjusting the timeout values for the
> MCU_UNI_CMD_EFUSE_CTRL and MCU_UNI_CMD_EXT_EEPROM_CTRL commands.
> Without this adjustment, false positive command timeout errors may occur,
> especially on some iPA variants.

I guess we are missing a Fixes tag here.

Regards,
Lorenzo

>=20
> Signed-off-by: Rex Lu <rex.lu@mediatek.com>
> Signed-off-by: Shayne Chen <shayne.chen@mediatek.com>
> ---
>  drivers/net/wireless/mediatek/mt76/mt7996/mcu.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c b/drivers/ne=
t/wireless/mediatek/mt76/mt7996/mcu.c
> index bdb9e30c54c1..2a9c59d15894 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
> +++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
> @@ -271,7 +271,8 @@ mt7996_mcu_set_timeout(struct mt76_dev *mdev, int cmd)
>  		mdev->mcu.timeout =3D 2 * HZ;
>  		return;
>  	case MCU_UNI_CMD_EFUSE_CTRL:
> -		mdev->mcu.timeout =3D 20 * HZ;
> +	case MCU_UNI_CMD_EXT_EEPROM_CTRL:
> +		mdev->mcu.timeout =3D 30 * HZ;
>  		return;
>  	default:
>  		break;
> --=20
> 2.51.0
>=20

--6oGIyq5Z/UamuDZT
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCabKYxAAKCRA6cBh0uS2t
rA5kAP4ikpFq4v65K0ZsizSUVwd8SujJiyt4RVOKLQnwhL/BjQD9HKI5rl/7BhfE
5QE3cHI/T5Q3OcGbaHTDjTw9r4s2hgg=
=iSs9
-----END PGP SIGNATURE-----

--6oGIyq5Z/UamuDZT--
