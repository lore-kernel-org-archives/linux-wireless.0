Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35813 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752345AbZBXByo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Feb 2009 20:54:44 -0500
Subject: Re: [PATCH] mac80211: Don't merge with the same BSSID
From: Johannes Berg <johannes@sipsolutions.net>
To: Alina Friedrichsen <x-alina@gmx.net>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <20090221230728.227290@gmx.net> (sfid-20090222_000800_225989_16C2EFFD)
References: <20090221230728.227290@gmx.net>
	 (sfid-20090222_000800_225989_16C2EFFD)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-BCWURPr+kpDEaGb0liJP"
Date: Mon, 23 Feb 2009 17:38:26 -0800
Message-Id: <1235439506.4455.30.camel@johannes.local> (sfid-20090224_025447_856095_B345768F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-BCWURPr+kpDEaGb0liJP
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2009-02-22 at 00:07 +0100, Alina Friedrichsen wrote:
> It was not a good idea to do a TSF reset on strange IBSS merges to the sa=
me BSSID. For example it will break the TSF sync of ath9k completely and it=
 is unnecessary as all hardware I have tested do a TSF sync to a higher val=
ue automatically and IBSS merges are only done to higher TSF values. It onl=
y need a TSF reset to accept a lower value, when the IBSS network is change=
d manually.
>=20
> Signed-off-by: Alina Friedrichsen <x-alina@gmx.net>

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> ---
> diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
> index 1bbfc70..cf20575 100644
> --- a/net/mac80211/ibss.c
> +++ b/net/mac80211/ibss.c
> @@ -291,6 +291,10 @@ static void ieee80211_rx_bss_info(struct ieee80211_s=
ub_if_data *sdata,
>  				sdata->u.ibss.ssid_len))
>  		goto put_bss;
> =20
> +	/* same BSSID */
> +	if (memcmp(bss->cbss.bssid, sdata->u.ibss.bssid, ETH_ALEN) =3D=3D 0)
> +		goto put_bss;
> +
>  	if (rx_status->flag & RX_FLAG_TSFT) {
>  		/*
>  		 * For correct IBSS merging we need mactime; since mactime is
>=20

--=-BCWURPr+kpDEaGb0liJP
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJo0+QAAoJEKVg1VMiehFYaxYP/36AQwFUiH/3SKZBK5VrnEfN
WQOU7wi0ho1zwQ0cOTWwly6Ntxx4Yc5dhF2bjK8m/ebT9EA71ecKbVfpI1TTglZ8
51pmlc/UrIsftfl+qkZTEwIQ4K1CHHUmzZLJaFlLkJr4PuwEXSEG7zkf9/dxt6JT
8QK+bHCCGdJ++i/Ekak/wMOZRfoXvmpeqDypxSUAL1QS9H3CQEGh9DimyfZ6m248
K+azpkuKGMd00NlOld5ttJ8GohfZTt2Sv0n7Sm2UKqiB5BjA9X4q9ZBcOcKd4VTM
QZpk5k2j4fDvckOk8D5mWYVMH/ZKGxEoo+oScn6a/J1LFUyoTRzJDtbUhCG9Ab+C
sp+iPM6kIJr0hkYcHM4yzEcK1nelf4Eb4sJsoEP0jDneH2gsgtAjlA+XXX3fjLUB
eontVLQqi04ayRHrmHwqak0fbKSjskzvhzQUWoPS21Lwsd3SDDUOhLfhVQySLcIf
rE7mhn3EhvzCmLyTSsHhrdsuqLiTqkxDwN9d1NnPaDT2BxpLYf+Inm29HV+JbcSN
17DJqZRLGgUWEDqR07hnRVQSINz89oK948SaCuiRu21fMe+/TEILGRAVedn5p51d
aaSWluRi2ARpVQGPEGjG6/Sfw1lFANN3JMTDBpjUqjGpDntJwGKEq+T3MYxmowQZ
5C6Ci3TnIonTrnPsNCdq
=ENL3
-----END PGP SIGNATURE-----

--=-BCWURPr+kpDEaGb0liJP--

