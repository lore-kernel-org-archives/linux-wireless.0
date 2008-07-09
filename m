Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:49612 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930AbYGINPl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jul 2008 09:15:41 -0400
Subject: Re: [PATCH 1/3] mac80211: Include sequence number in IBSS and Mesh
	beacons
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
In-Reply-To: <200807091511.45779.IvDoorn@gmail.com> (sfid-20080709_150408_274977_B8FEC980)
References: <200807091511.14288.IvDoorn@gmail.com>
	 <200807091511.45779.IvDoorn@gmail.com>
	 (sfid-20080709_150408_274977_B8FEC980)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-NkKlfSJnCMUUmgQqLUMQ"
Date: Wed, 09 Jul 2008 15:14:55 +0200
Message-Id: <1215609295.3246.0.camel@johannes.berg> (sfid-20080709_151545_256290_A6C813E6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-NkKlfSJnCMUUmgQqLUMQ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-07-09 at 15:11 +0200, Ivo van Doorn wrote:
> Currently only beacons generated in AP mode have the software
> sequence number inserted. This means IBSS and Mesh mode are broken
> for all hardware that require software sequence numbers.
>=20
> Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>

Acked-by: Johannes Berg <johannes@sipsolutions.net>


> ---
>  net/mac80211/tx.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
>=20
> diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
> index 359cb36..0e7e1f3 100644
> --- a/net/mac80211/tx.c
> +++ b/net/mac80211/tx.c
> @@ -1876,6 +1876,8 @@ struct sk_buff *ieee80211_beacon_get(struct ieee802=
11_hw *hw,
>  		hdr->frame_control =3D IEEE80211_FC(IEEE80211_FTYPE_MGMT,
>  						  IEEE80211_STYPE_BEACON);
> =20
> +		ieee80211_include_sequence(sdata, hdr);
> +
>  		num_beacons =3D &ifsta->num_beacons;
>  	} else if (ieee80211_vif_is_mesh(&sdata->vif)) {
>  		/* headroom, head length, tail length and maximum TIM length */
> @@ -1896,6 +1898,9 @@ struct sk_buff *ieee80211_beacon_get(struct ieee802=
11_hw *hw,
>  			cpu_to_le16(local->hw.conf.beacon_int);
>  		mgmt->u.beacon.capab_info =3D 0x0; /* 0x0 for MPs */
> =20
> +		ieee80211_include_sequence(sdata,
> +					   (struct ieee80211_hdr *)skb->data);
> +
>  		pos =3D skb_put(skb, 2);
>  		*pos++ =3D WLAN_EID_SSID;
>  		*pos++ =3D 0x0;

--=-NkKlfSJnCMUUmgQqLUMQ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIdLnLAAoJEKVg1VMiehFYG6UQAJHUC7IoJIe6/MKfcJe3c3C+
QArv+u9Zk8ALyin0uWB06shgEs/bptgYLIefAT00amFBsyIl4DaW3HeqVkHEGE4B
3+k9KvM/NYjljJXcyVOlafMZggkAguHUzqlwdkpchk7nLzit7vtc5nNo8uACzvH/
bwXvKQG9e+opW6viWTwntwU4fVrKirVgRIi0U7KmlROE5yXrjnrjCmmWlCy4Erb5
PrLQW2owFIQlOQW3bIGNDalTUB1WOeCRyVEjE/7UX7J2bef5M+PeZVlgf7OR4BcP
p1HwdSw3tPMdfSjlZZH/oC+ePYfeYkBIbUqG9lx7rjj8rhJku8BAgFNtBc4RUQ9/
VH6dl7bIZm0JSB/wrOAq5PB/EyY3vtV4sBmKAGK2oVZgN0R/0hIEUA1VMUkiwPnJ
TqtgwxtPms2+PRuDz7isbF60cua+ni2aO4d92WCJ5uu+DmWe6d5pRUtndWBBC8fk
zM82iMBUO5LbBcTpM98nu3Oezleaajbpi8iGcYE2QVx3MDr0kr2q96HItceIpM3T
2AnKsWAxPtVJIMQHlmoenaINmXAUsYWsPA6swtRzYxIm1OMB5Ik9eaj4wjdKnQJH
0D4V+O2tCeq1s5XQ0DTIfXN/t0TomjOHNSh1qOA3ZHcU+MEkRmpAw60j4fsIIMpZ
XHvXDEPh3L9pY+ed+wr6
=D+vl
-----END PGP SIGNATURE-----

--=-NkKlfSJnCMUUmgQqLUMQ--

