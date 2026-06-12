Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 302D8339844;
	Fri, 12 Jun 2026 13:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781272201; cv=none; b=EEVjYk0cXa9nCFPY0WK7s/vAp6s1/8zT+fmSo4xsse5AJMQZYRLVZxOz+YmlHpbOqaUdj1ScBN/ikmsQIPVeS9canT5sHFgJtQwsTXxPwPNypKOkl+OTEbR6SrtpNQQZiz1tdBUX5mP/qsBMzbDE2bhOkDZWJ3DfBEOtmCwB9xk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781272201; c=relaxed/simple;
	bh=TrQOsuwZT9Ibqqc5cHjbDXmIHFEcRABc6X6Pdob6X/Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p/M6QcomQd+UpLb7qEdXjEv/Dnlmd0Uy0mu5vFfXyy9s5ixpBtktvxtsYftxALEB/aGIQuRZlgwadGuVQdPMeShfaSWh8kRG7dsp1nsVfcObcI44JzdSohVDVKpBuLcIcFbgy/rwcrDy/M4/SRDn+6aduSA3mrWsNG0hR33hJ38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ogEk2fdb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ogEk2fdb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43D331F000E9;
	Fri, 12 Jun 2026 13:49:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781272196;
	bh=9DbMPyfGQptbnn4NS0NgGBkAEXlR+GQ+W97O4Gk+1bE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ogEk2fdb51OCj+6rD0T12zRE8mTqTrPsoUKBtWJpxqCiNbLPrByO32mujD+njvIz5
	 Lbn6maIM9jQuTD1QBWXM/upHjt7lL+SVecWgYD92AjGfSLSPhrvNmpG6aADTAko/Gq
	 WEMm/iUKl8NYLEZuAROmB+DOYUOf/m5+5PltvwVOENvomkg9r3Q32xZ/85lC5zcMuJ
	 wcbs+hm9tat4Hd3r9ZI9F+ZzYL0NMlpCqeqta55o21Z39Awj1jUn9LEcXRR30M3nwk
	 RQ/tACXzIeqivFFEa07NBPZ5tim/lLRB7bcwPdc2vDybyLg41eyZvbaH/RCadMv5cO
	 JPkVZxORFVJKg==
Date: Fri, 12 Jun 2026 15:49:54 +0200
From: Lorenzo Bianconi <lorenzo@kernel.org>
To: Arnd Bergmann <arnd@kernel.org>
Cc: Felix Fietkau <nbd@nbd.name>, Ryder Lee <ryder.lee@mediatek.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>, Rex Lu <rex.lu@mediatek.com>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: Re: [PATCH] wifi: mt76: fix airoha_npu dependency tracking
Message-ID: <aiwOgoB6JeU7J3Ze@lore-desk>
References: <20260611125912.3387021-1-arnd@kernel.org>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="sS2E1xGPDq87P0hY"
Content-Disposition: inline
In-Reply-To: <20260611125912.3387021-1-arnd@kernel.org>


--sS2E1xGPDq87P0hY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> From: Arnd Bergmann <arnd@arndb.de>
>=20
> There is a new build failure with MT7996E=3Dm MT76_CORE=3Dy and NET_AIROH=
A_NPU=3Dm:
>=20
> ld.lld: error: undefined symbol: airoha_npu_get
> ld.lld: error: undefined symbol: airoha_npu_put
> >>> referenced by npu.c
> >>>               drivers/net/wireless/mediatek/mt76/npu.o:(mt76_npu_init=
) in archive vmlinux.a
>=20
> Fix this by reworking the dependency for the MT7996_NPU to only
> allow enabling that when mt76_core can link against the npu driver.
>=20
> To make sure this gets caught more easily in the future when additional
> mt76 variants need the same dependency, also turn CONFIG_MT76_NPU into
> a tristate symbol that has the same dependency.
>=20
> Fixes: 7fb554b1b623 ("wifi: mt76: Introduce the NPU generic layer")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>

> ---
>  drivers/net/wireless/mediatek/mt76/Kconfig        | 4 ++--
>  drivers/net/wireless/mediatek/mt76/Makefile       | 6 +++++-
>  drivers/net/wireless/mediatek/mt76/mt76.h         | 2 +-
>  drivers/net/wireless/mediatek/mt76/mt7996/Kconfig | 2 +-
>  4 files changed, 9 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/net/wireless/mediatek/mt76/Kconfig b/drivers/net/wir=
eless/mediatek/mt76/Kconfig
> index 502303622a53..d941e67a222d 100644
> --- a/drivers/net/wireless/mediatek/mt76/Kconfig
> +++ b/drivers/net/wireless/mediatek/mt76/Kconfig
> @@ -38,8 +38,8 @@ config MT792x_USB
>  	select MT76_USB
> =20
>  config MT76_NPU
> -	bool
> -	depends on MT76_CORE
> +	tristate
> +	depends on NET_AIROHA_NPU=3Dy || MT76=3DNET_AIROHA_NPU
> =20
>  source "drivers/net/wireless/mediatek/mt76/mt76x0/Kconfig"
>  source "drivers/net/wireless/mediatek/mt76/mt76x2/Kconfig"
> diff --git a/drivers/net/wireless/mediatek/mt76/Makefile b/drivers/net/wi=
reless/mediatek/mt76/Makefile
> index 1d42adfe8030..cacdd2b13d05 100644
> --- a/drivers/net/wireless/mediatek/mt76/Makefile
> +++ b/drivers/net/wireless/mediatek/mt76/Makefile
> @@ -12,7 +12,11 @@ mt76-y :=3D \
>  	mmio.o util.o trace.o dma.o mac80211.o debugfs.o eeprom.o \
>  	tx.o agg-rx.o mcu.o wed.o scan.o channel.o
> =20
> -mt76-$(CONFIG_MT76_NPU) +=3D npu.o
> +ifdef CONFIG_MT76_NPU
> +# CONFIG_MT76_NPU is tristate to simplify dependency tracking,
> +# but it behaves as a bool symbol here.
> +mt76-y +=3D npu.o
> +endif
>  mt76-$(CONFIG_PCI) +=3D pci.o
>  mt76-$(CONFIG_NL80211_TESTMODE) +=3D testmode.o
> =20
> diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wire=
less/mediatek/mt76/mt76.h
> index 07955555f84d..60bd155cc7d5 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt76.h
> +++ b/drivers/net/wireless/mediatek/mt76/mt76.h
> @@ -1647,7 +1647,7 @@ int mt76_testmode_dump(struct ieee80211_hw *hw, str=
uct sk_buff *skb,
>  int mt76_testmode_set_state(struct mt76_phy *phy, enum mt76_testmode_sta=
te state);
>  int mt76_testmode_alloc_skb(struct mt76_phy *phy, u32 len);
> =20
> -#ifdef CONFIG_MT76_NPU
> +#if IS_ENABLED(CONFIG_MT76_NPU)
>  void mt76_npu_check_ppe(struct mt76_dev *dev, struct sk_buff *skb,
>  			u32 info);
>  int mt76_npu_dma_add_buf(struct mt76_phy *phy, struct mt76_queue *q,
> diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/Kconfig b/drivers/=
net/wireless/mediatek/mt76/mt7996/Kconfig
> index 5503d03bf62c..5742bce12fbb 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt7996/Kconfig
> +++ b/drivers/net/wireless/mediatek/mt76/mt7996/Kconfig
> @@ -16,6 +16,6 @@ config MT7996E
>  config MT7996_NPU
>  	bool "MT7996 (PCIe) NPU support"
>  	depends on MT7996E
> -	depends on NET_AIROHA_NPU=3Dy || MT7996E=3DNET_AIROHA_NPU
> +	depends on NET_AIROHA_NPU=3Dy || MT76_CORE=3DNET_AIROHA_NPU
>  	select MT76_NPU
>  	default n
> --=20
> 2.39.5
>=20

--sS2E1xGPDq87P0hY
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCaiwOggAKCRA6cBh0uS2t
rOcGAP4vYhqXmOO6OnGyAZ+VgBxQr869XtZPMQvmGyA2x1t0HAEA0JOUwPG7oIMd
pfgu4dsSeBoe8+sMbvkRs3cQDaHUVAQ=
=dFd3
-----END PGP SIGNATURE-----

--sS2E1xGPDq87P0hY--
