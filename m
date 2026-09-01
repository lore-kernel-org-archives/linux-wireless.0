Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0E5F364028
	for <linux-wireless@vger.kernel.org>; Tue,  1 Sep 2026 09:47:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788256023; cv=none; b=WYpnK5106CaKmQE5SkyP9uqbc89t4Wo2MEQYb8xT/qMMo46RApaGkZJpNi0flluuqKAevEF6YGQHFiZ0Diev6sIfFb6k1QrwXYf9aCqM+XFoTHx7TqPjHxbf9VjL5gp5lRtOIRM+1ZfnYyS08yaFdfXgCL9w1WvhjrRZ94FETP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788256023; c=relaxed/simple;
	bh=zAwu0BgjPVr8EYNGigk9JjCO7Zo0selIIJiNy8F/two=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PAdRZZwhdB5fsLWmOfqgc3mlyewRdtpF+kORm+NqKQF8v5Bo7sSufaeyB/roQOoorZJ0fhmx3vsWsbKwzab71OatUQEv1icDfNuC1+O4NQeQZ8WHjwBCZdftsMzXZm6buHjjf0hxpefklpYGWXBfN8LwYs1EO90sRF4DBU4ioGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fCaz+4Vy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fCaz+4Vy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAA5B1F00A3D;
	Tue,  1 Sep 2026 09:46:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788256020;
	bh=xKseX4RpC48InZDS9ozDbdm9aphhnA3wlRBhWG1g0Bc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fCaz+4Vy0JmnrS5T93y09vIOrOOgYv7TUpokFOpP7LzpQdJoW17RxERjEBfPQTGIz
	 Kw5IbZtbNiwIOAxgApNTJqpW0ILjFUXMbzWuKC3N8uyQaxRLTyQbddebXNFiERq0LX
	 PP2Zjm2Fg2hfNOzsu4KbcCq/haitkspyqW5u3Z0uy23sXNfR6oREICukZ0/DeDVKdN
	 E9PRGnKeocsxo75xabEhAfAc0+ZPhIpA3nBbT7Esmzm2CrAG5eNJM2w6ihdbcwhbYQ
	 w6D3ceBY7a4jYFjaspA4qe83vrRG4ndMoy3Zavn3GDGeXgRJJN0vq9mX/ZmVKJvXU9
	 COAo7V0R7Uxmw==
Date: Tue, 1 Sep 2026 11:46:58 +0200
From: Lorenzo Bianconi <lorenzo@kernel.org>
To: Felix Fietkau <nbd@nbd.name>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH mt76-fixes] wifi: mt76: use ALTX queue for packets to
 disassociated stations
Message-ID: <apafEgYSs3TYG55d@lore-desk>
References: <20260901092232.461379-1-nbd@nbd.name>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="IU4ozPbJsOhAhZWH"
Content-Disposition: inline
In-Reply-To: <20260901092232.461379-1-nbd@nbd.name>

--IU4ozPbJsOhAhZWH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> Running these packets through regular buffering queues could cause them
> to hang, especially when the packets were for stations that in disassoc
> state.
>=20
> Fixes: dedf2ec30fe4 ("wifi: mt76: fix queue assignment for deauth packets=
")
> Signed-off-by: Felix Fietkau <nbd@nbd.name>

Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>

> ---
>  drivers/net/wireless/mediatek/mt76/mt7915/main.c | 2 ++
>  drivers/net/wireless/mediatek/mt76/mt7996/main.c | 1 +
>  drivers/net/wireless/mediatek/mt76/tx.c          | 3 ++-
>  3 files changed, 5 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/main.c b/drivers/n=
et/wireless/mediatek/mt76/mt7915/main.c
> index a8286f8becf9..a03d89aabe80 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt7915/main.c
> +++ b/drivers/net/wireless/mediatek/mt76/mt7915/main.c
> @@ -805,6 +805,7 @@ __mt7915_drop_sta(void *ptr, u8 *mac, struct ieee8021=
1_vif *vif)
> =20
>  	msta =3D (struct mt7915_sta *)sta->drv_priv;
>  	mt7915_mcu_add_sta(data->dev, vif, sta, CONN_STATE_DISCONNECT, false);
> +	msta->wcid.tx_info &=3D ~MT_WCID_TX_INFO_SET;
>  	msta->wcid.sta_disabled =3D 1;
>  	msta->wcid.sta =3D 0;
>  }
> @@ -871,6 +872,7 @@ int mt7915_mac_sta_event(struct mt76_dev *mdev, struc=
t ieee80211_vif *vif,
>  		mutex_unlock(&dev->mt76.mutex);
> =20
>  		mt7915_mcu_add_sta(dev, vif, sta, CONN_STATE_DISCONNECT, false);
> +		msta->wcid.tx_info &=3D ~MT_WCID_TX_INFO_SET;
>  		msta->wcid.sta_disabled =3D 1;
>  		msta->wcid.sta =3D 0;
>  		return 0;
> diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/n=
et/wireless/mediatek/mt76/mt7996/main.c
> index d17d1dbb2038..dd7a01c02a7c 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
> +++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
> @@ -1433,6 +1433,7 @@ mt7996_mac_sta_event(struct mt7996_dev *dev, struct=
 ieee80211_vif *vif,
>  			else if (sta->mlo && links =3D=3D BIT(link_id)) /* last link */
>  				mt7996_mcu_teardown_mld_sta(dev, link,
>  							    msta_link);
> +			msta_link->wcid.tx_info &=3D ~MT_WCID_TX_INFO_SET;
>  			msta_link->wcid.sta_disabled =3D 1;
>  			msta_link->wcid.sta =3D 0;
>  			links =3D links & ~BIT(link_id);
> diff --git a/drivers/net/wireless/mediatek/mt76/tx.c b/drivers/net/wirele=
ss/mediatek/mt76/tx.c
> index b1e894b19cbd..3c623df2e741 100644
> --- a/drivers/net/wireless/mediatek/mt76/tx.c
> +++ b/drivers/net/wireless/mediatek/mt76/tx.c
> @@ -680,7 +680,8 @@ mt76_txq_schedule_pending_wcid(struct mt76_phy *phy, =
struct mt76_wcid *wcid,
>  		if ((dev->drv->drv_flags & MT_DRV_HW_MGMT_TXQ) &&
>  		    !(info->flags & IEEE80211_TX_CTL_HW_80211_ENCAP) &&
>  		    !ieee80211_is_data_present(hdr->frame_control) &&
> -		    (!ieee80211_is_bufferable_mmpdu(skb) ||
> +		    (!(wcid->tx_info & MT_WCID_TX_INFO_SET) ||
> +		     !ieee80211_is_bufferable_mmpdu(skb) ||
>  		     ieee80211_is_deauth(hdr->frame_control) ||
>  		     ieee80211_is_disassoc(hdr->frame_control) ||
>  		     head =3D=3D &wcid->tx_offchannel))
> --=20
> 2.47.3
>=20
>=20

--IU4ozPbJsOhAhZWH
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCapafEgAKCRA6cBh0uS2t
rKKlAQDd78I9fnGTxIwJZQFRFGqPLB0Ae0aisWHVbgDo91WiQAD+P6jBfAOz6MMi
hnCUurv0x5OiNtKy2y0DypHY2qwXXgQ=
=ssOH
-----END PGP SIGNATURE-----

--IU4ozPbJsOhAhZWH--
