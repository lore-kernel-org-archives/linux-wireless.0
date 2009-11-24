Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:50423 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933331AbZKXRPB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Nov 2009 12:15:01 -0500
Subject: Re: [PATCH v2 2/2] mac80211: minstrel try all rates
From: Johannes Berg <johannes@sipsolutions.net>
To: Adam Wozniak <awozniak@irobot.com>
Cc: Derek Smithies <derek@indranet.co.nz>,
	Christian Lamparter <chunkeey@googlemail.com>,
	linux-wireless@vger.kernel.org, Felix Fietkau <nbd@openwrt.org>
In-Reply-To: <1259082331.2573.19.camel@awozniak-laptop>
References: <4AF0D54D.4090303@irobot.com>
	 <alpine.DEB.2.00.0911111508391.6214@kauri.acheron.indranet.co.nz>
	 <4AFC655A.5020706@irobot.com> <200911122103.27455.chunkeey@googlemail.com>
	 <4AFC8E4F.5090307@irobot.com>  <4AFC8F0D.5020700@irobot.com>
	 <1258097352.3899.75.camel@johannes.local>  <4AFDDF19.8060202@irobot.com>
	 <1258191039.6167.40.camel@johannes.local>  <4B018B26.2070008@irobot.com>
	 <1258392453.32159.28.camel@johannes.local> <4B0192A6.9050808@irobot.com>
	 <alpine.DEB.2.00.0911170938380.3829@kauri.acheron.indranet.co.nz>
	 <4B01D4A5.7060204@irobot.com>
	 <alpine.DEB.2.00.0911171156210.3829@kauri.acheron.indranet.co.nz>
	 <4B01E298.3030602@irobot.com>
	 <alpine.DEB.2.00.0911171314470.3829@kauri.acheron.indranet.co.nz>
	 <1258443484.1375.8.camel@johannes.local> <4B02DFE3.9040602@irobot.com>
	 <4B0AEEE3.2050808@irobot.com> <1259018866.7094.189.camel@johannes.local>
	 <4B0B2F6E.7050907@irobot.com>  <1259082331.2573.19.camel@awozniak-laptop>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-KVnHawgzG7isWMSlDARS"
Date: Tue, 24 Nov 2009 18:14:11 +0100
Message-ID: <1259082851.3491.18.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-KVnHawgzG7isWMSlDARS
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-11-24 at 09:05 -0800, Adam Wozniak wrote:
> In Ad-Hoc mode, it is possible for minstrel to be initialized without com=
plete rate information.
> In these cases, throughput suffers because not all rates are tried.  This=
 patch tells minstrel to try all rates. =20
> This won't cause problems, because unsupported rates will simply fail, ca=
using minstrel to set their probability to 0%.
> (Hopefully not whitespace damaged this time)

I still stand by this being the wrong thing to do

johannes

> Signed-off-by: Adam Wozniak <awozniak@irobot.com>
> ---
> diff --git a/net/mac80211/rc80211_minstrel.c
> b/net/mac80211/rc80211_minstrel.c
> index 6e5d68b..3a8fe30 100644
> --- a/net/mac80211/rc80211_minstrel.c
> +++ b/net/mac80211/rc80211_minstrel.c
> @@ -395,8 +395,6 @@ minstrel_rate_init(void *priv, struct
> ieee80211_supported_band *sband,
>  		unsigned int tx_time_single;
>  		unsigned int cw =3D mp->cw_min;
> =20
> -		if (!rate_supported(sta, sband->band, i))
> -			continue;
>  		n++;
>  		memset(mr, 0, sizeof(*mr));
> =20
>=20
>=20


--=-KVnHawgzG7isWMSlDARS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLDBRgAAoJEODzc/N7+QmaZFAP/2Nu0plfJkERKPKgsLXHHA68
eufegrs1RQxjjNVogHftwFHlA8ZgUGzHcSJ1RCyN3yGjwMqKiRncbpgvJ/1d+DkP
TycumCU65hgVXSmvhPYnPxgf+/jhjkZ8WrRpV7Kdqx9W0LP47QjD3qEZnllYJ3qk
szRKlyd/3gJOSwe2j93Ku+pldccAm+RECMDCCeSJpPZX5q+PpCJBCekJ/jHcnyu9
By+4cojD57wiaH5zKWhU0weK7GOl/iFKih3DCoWiq8z6AgSmJXM+y1A6fGfFMJJ5
fgxjKyVIBUDg3rUDUrbeqneIviPBKVzr16nrhXRP0wVOMqgFXTxWUzFwl2JdO3qh
i6EpngUK+JnPMEfqq+rY6t76+dnBkaX2jsJcx3UZWoetwIUvn0hBWeAEsAs7KOt3
knPQoQI7yqq2u6AEyqD77mwFXebwXxJu+n95Osp2KC1kzYrpc+IzX8WOSn79b9+i
llIyKCQdlztTQokAEwd0Wm59K+PQ6qaYJ4edDzfnTDlZhz0KCc65j8uvQKJX/K6w
umwnJ/q6hju9D948tc9bfDFNuJqFnXved63jtRa0Jn0PS24oKdVpwIJkv6KBpSHo
Qzocpsz7nISfJleKRQs9IafOrtMcm5f/UWKX2jO7LWUhJkVTo0cujHnhPrf0xKJy
a/lAbAMfVE1DnFWSHuch
=YNlL
-----END PGP SIGNATURE-----

--=-KVnHawgzG7isWMSlDARS--

