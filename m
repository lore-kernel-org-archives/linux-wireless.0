Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7785C38D006
	for <linux-wireless@vger.kernel.org>; Thu, 12 Mar 2026 10:42:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773312142; cv=none; b=oTLKVjbyKhp9aWMPkiqCztWrSpztq8BHon3pjKsBNF1gqiurTcrgsVKXFT+rMwia8X13ps4QHjABIh4kVwCWjkCbqm20CxSGJp+iXwcQENtcntVcVKuAD8iiq2SfDbKxQHN4vYLVDPz1aRaAgnGdYbKtSnhSl1TVLlXVe5wapBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773312142; c=relaxed/simple;
	bh=x+Z87COydW0vfSd3sCt8LrQRlMS5+NrVWrjuiYAwD3k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JbLy245TixyG39uzKWBcZTp0aSZqM3HHNsN7bhbdi8LMYDrzkI1M5vpDXiuYSw/xVH0gq4Ef6X9naOr+55Is10B7b5yIDYfs4fCFawBSPAfHYevbtN14aEq6qmUu3SaoHuKRtOlf3GItzEgFR27BmVwCZuSk6BOLnXDp3Hqrp9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ag7yXeVE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ag7yXeVE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81190C4CEF7;
	Thu, 12 Mar 2026 10:42:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773312142;
	bh=x+Z87COydW0vfSd3sCt8LrQRlMS5+NrVWrjuiYAwD3k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ag7yXeVEPkPXY/yDQjyY5arpTeTGF+4qF8GyzKQ7jN2eGxmEloGeg9Ch668jA1vkY
	 Jmyn6RVVeZT4cxwxgpyi6Z+Jq1bOMCg+pQi89Qc99Wiv8/jFg4dD5rOkDwFkcFLwmX
	 11t2liuE/TzycprCV5GOoIZIKO1MdboMgc9+DnOTo/JLfpkK6egpXD+tz8I6qjQp07
	 Dtn/9MOxVkSKsvyoFq6cyuUKcnG/FEkUsDdkNe4aKnS8aOU1RzzqlSyZH9i5KzJt6b
	 aTSnK1JsrAZzZEAS0j3rXgcaUeoUUtie5BDOugmnTMqSgigJfRLlY8PHXnicbvbZCZ
	 cAHJ1hUQaLZRg==
Date: Thu, 12 Mar 2026 11:42:19 +0100
From: Lorenzo Bianconi <lorenzo@kernel.org>
To: Shayne Chen <shayne.chen@mediatek.com>
Cc: Felix Fietkau <nbd@nbd.name>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Evelyn Tsai <evelyn.tsai@mediatek.com>,
	Money Wang <money.wang@mediatek.com>,
	linux-mediatek <linux-mediatek@lists.infradead.org>,
	Howard Hsu <howard-yh.hsu@mediatek.com>
Subject: Re: [PATCH mt76 2/6] wifi: mt76: mt7996: support critical packet
 mode for MT7990 chipsets
Message-ID: <abKYixEiPYe3ot_e@lore-desk>
References: <20260312095724.2117448-1-shayne.chen@mediatek.com>
 <20260312095724.2117448-2-shayne.chen@mediatek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="Rrv6gaOSBsh/EhZm"
Content-Disposition: inline
In-Reply-To: <20260312095724.2117448-2-shayne.chen@mediatek.com>


--Rrv6gaOSBsh/EhZm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> From: Howard Hsu <howard-yh.hsu@mediatek.com>
>=20
> For MT7990 chipsets, critical packet mode must be enabled. Without this,
> some higher priority packets may be placed in the wrong AC queue.
>=20
> Signed-off-by: Howard Hsu <howard-yh.hsu@mediatek.com>
> Signed-off-by: Shayne Chen <shayne.chen@mediatek.com>

I guess we are missing a Fixes tag here.

Regards,
Lorenzo

> ---
>  drivers/net/wireless/mediatek/mt76/mt7996/main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/n=
et/wireless/mediatek/mt76/mt7996/main.c
> index e1e51c9a0767..d286dedddd9b 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
> +++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
> @@ -56,7 +56,7 @@ static int mt7996_start(struct ieee80211_hw *hw)
> =20
>  	mutex_lock(&dev->mt76.mutex);
>  	ret =3D mt7996_mcu_set_hdr_trans(dev, true);
> -	if (!ret && is_mt7992(&dev->mt76)) {
> +	if (!ret && !is_mt7996(&dev->mt76)) {
>  		u8 queue =3D mt76_connac_lmac_mapping(IEEE80211_AC_VI);
> =20
>  		ret =3D mt7996_mcu_cp_support(dev, queue);
> --=20
> 2.51.0
>=20

--Rrv6gaOSBsh/EhZm
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCabKYiwAKCRA6cBh0uS2t
rOfgAPwPIPo6e4qxhCA2xPzKtm2uTWNVR39oqd4w0vU7DMfMbwEA26unZoPslPmO
IfxtYo7z/T50bc138ukVlD5S9TgH3gg=
=6pIp
-----END PGP SIGNATURE-----

--Rrv6gaOSBsh/EhZm--
