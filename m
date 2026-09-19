Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEBC9381AE0;
	Sat, 19 Sep 2026 17:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789837331; cv=none; b=ON9mwR0prm6Mqwijq/nHylASAb/nTui+Tp/R8xOV2t25UH86Me1zrG8vzjsuOgIhydy+LLw7Pch9SRq/TudZDWb2czvm8ySVmDKhr1VGUgjKKlymAFcyOjAJ42PzBYU7d1NNmXJKf/H0GL7IZNS+zq+tyFxgNkF4D9Eem/mQZcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789837331; c=relaxed/simple;
	bh=afP4gTU5xI0E58jmLDFRTLfTfjMo5KJKS4cb837Xtmk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I5N0BtjvDkBx05Jx3FffH/ZIUv/L1+K3w3mLnUC9bXBeUTt+pVvlhUffO2JnY1DsCEYJhQtwx3hpcXPOEqW/9Td3xellN2psBS2bM/twRVJs+JhaNvwRE11DIEH30KFF2vZoUNuRa9pSHKyzsEIjvWFlmViOdHOZ9qbLNOypXdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RSw3lr30; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RSw3lr30"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B890B1F00898;
	Sat, 19 Sep 2026 17:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789837323;
	bh=JAxJOmjws1Qd70Sf6yWA07SufTcfaYIA2DOCmbnup84=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=RSw3lr30CzEnnV88q5XDdSOHw2VKNzHeHs6LF7WOng8Pocq3FK2o8MLCLeM+dMueC
	 A0O+DdCuL7hpeEsxBycjKvbegb8mOEGBjTbiPBwbF4DtNRq3l2RrJrtngi40rnC+PS
	 Y0KRewUDqsegeQoxzQLrgy8xxD182mdMnex0XqptYZBrodtHrLaSftVQlWomk2TEVc
	 lViwVZUJnrabSvq7Dn0QnPnGJnVY9V7+0I2uKymxgaT7PPUufCksndGHcE/6ysgChN
	 KMuaUp9Al46csyWqpeUVyUC0ct0+e8EYoxszYN/Fw8m7IFo4KuLmy/jcOCg6Jk13I8
	 Das9zpB3utCgQ==
Date: Sat, 19 Sep 2026 19:02:00 +0200
From: Lorenzo Bianconi <lorenzo@kernel.org>
To: Gilly1970 <gilroyscott1970@gmail.com>
Cc: linux-wireless@vger.kernel.org, nbd@nbd.name, ryder.lee@mediatek.com,
	shayne.chen@mediatek.com, sean.wang@mediatek.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wifi: mt76: mt7996: refresh the tx BA session timer on
 NPU devices
Message-ID: <aq7ACJM-X7kDx10y@lore-qca>
References: <20260918091659.1176350-1-gilroyscott@hotmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="8IqyEkYxeK8Sj2tQ"
Content-Disposition: inline
In-Reply-To: <20260918091659.1176350-1-gilroyscott@hotmail.com>

--8IqyEkYxeK8Sj2tQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> From: Chris Scott <gilroyscott1970@gmail.com>
>=20
> mt7996_mac_add_txs_skb() refreshes mac80211's tx BlockAck session timer
> only when a WED device is active. Airoha boards offload through the NPU
> instead, so on those the condition is never true and nothing keeps the
> timer alive.
>=20
> NPU-forwarded frames do not traverse mac80211, and the only other places
> that stamp tid_tx->last_tx are in the software tx path. When the peer
> negotiates a non-zero BlockAck timeout in the ADDBA response (Intel
> stations commonly do, most others answer 0) mac80211 arms
> tid_tx->session_timer, which then expires in the middle of an offloaded
> transfer and tears the session down with a DELBA.
>=20
> The session does not come back on its own either: mt7996 restarts one
> from mt7996_tx_check_aggr(), reached via mt7996_txwi_free(), and
> offloaded frames carry no driver token so they never get there.
> mac80211's ieee80211_aggr_check() fallback needs
> RATE_CTRL_CAPA_AMPDU_TRIGGER, which mt7996 does not set. The reported
> symptom is a file transfer to an Intel client dropping from line rate to
> a few MB/s and staying there, with a single ping from the router - one
> frame on the software path - restoring it instantly.
>=20
> Extend the check with mt76_npu_device_active(). TXS reports do arrive
> for NPU-forwarded frames, measured at roughly 24 per second on a busy
> radio, which is far more than a seconds-scale session timer needs.
>=20
> A second user who independently saw the same collapse, held off only by
> a once-a-second ping from the AP, ran a patched image for 100 hours
> (~175 TB of offloaded iperf3 traffic, ~4 Gbit/s) without it recurring.
>=20
> Link: https://forum.openwrt.org/t/quantum-fiber-w1700k-support/222776/3900
> Link: https://forum.openwrt.org/t/quantum-fiber-w1700k-support/222776/3901
> Link: https://forum.openwrt.org/t/gemtek-w1700k-community-builds/249319/4=
58
> Fixes: 377aa17d2aed ("wifi: mt76: mt7996: Add NPU offload support to MT79=
96 driver")
> Signed-off-by: Chris Scott <gilroyscott1970@gmail.com>

Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>

> ---
>  drivers/net/wireless/mediatek/mt76/mt7996/mac.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c b/drivers/ne=
t/wireless/mediatek/mt76/mt7996/mac.c
> index dc1a3e9..e50db1f 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
> +++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
> @@ -1540,7 +1540,8 @@ mt7996_mac_add_txs_skb(struct mt7996_dev *dev, stru=
ct mt76_wcid *wcid,
>  		}
>  	}
> =20
> -	if (mtk_wed_device_active(&dev->mt76.mmio.wed) && wcid->sta) {
> +	if ((mtk_wed_device_active(&dev->mt76.mmio.wed) ||
> +	     mt76_npu_device_active(&dev->mt76)) && wcid->sta) {
>  		struct ieee80211_sta *sta;
>  		u8 tid;
> =20
> --=20
> 2.43.0
>=20

--8IqyEkYxeK8Sj2tQ
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCaq7ACAAKCRA6cBh0uS2t
rNoVAQD6bB7NlHHs5G3ImSFpHKq5IJLDv4AoasPDST0ZeRF5XQEAwzxd6cIlfktp
AtrNnLy4JRCvCmGH9AoaXSsULZ5QtQ4=
=Uq5Y
-----END PGP SIGNATURE-----

--8IqyEkYxeK8Sj2tQ--
