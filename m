Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:38142 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755197AbZKNJaj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Nov 2009 04:30:39 -0500
Subject: Re: compat-wireless and minstrel
From: Johannes Berg <johannes@sipsolutions.net>
To: Adam Wozniak <awozniak@irobot.com>
Cc: Christian Lamparter <chunkeey@googlemail.com>,
	Derek Smithies <derek@indranet.co.nz>,
	linux-wireless@vger.kernel.org, nbd@openwrt.org
In-Reply-To: <4AFDDF19.8060202@irobot.com>
References: <4AF0D54D.4090303@irobot.com>
	 <alpine.DEB.2.00.0911111508391.6214@kauri.acheron.indranet.co.nz>
	 <4AFC655A.5020706@irobot.com> <200911122103.27455.chunkeey@googlemail.com>
	 <4AFC8E4F.5090307@irobot.com>  <4AFC8F0D.5020700@irobot.com>
	 <1258097352.3899.75.camel@johannes.local>  <4AFDDF19.8060202@irobot.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-W03l4hrplFLpG/fwjoIN"
Date: Sat, 14 Nov 2009 10:30:39 +0100
Message-ID: <1258191039.6167.40.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-W03l4hrplFLpG/fwjoIN
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-11-13 at 14:35 -0800, Adam Wozniak wrote:

> I've traced it down to this bit in rx.c in prepare_for_handlers():
>=20
>         case NL80211_IFTYPE_ADHOC:
>                 [ stuff deleted ]
>                 } else if (!rx->sta) {
>                         int rate_idx;
>                         if (rx->status->flag & RX_FLAG_HT)
>                                 rate_idx =3D 0; /* TODO: HT rates */
>                         else
>                                 rate_idx =3D rx->status->rate_idx;
>=20
>                         rx->sta =3D ieee80211_ibss_add_sta(sdata, bssid,=20
> hdr->addr2,
>                                 BIT(rate_idx));
>                 }
>                 break;
>=20
> I don't think this is right.  I know the issue is here, because if I=20
> change to "BIT(rate_idx) | 0xfff" the problem corrects.  Either we need=20
> to (a) set it properly here or (b) make sure something else happens=20
> before or after.  I'm not sure we have enough context here to do (a).

Hmm. This BIT(..) was basically here to ensure we have at least a single
good rate absent other information. If we do not receive a probe or
beacon frame from that peer at least once, but add it to our IBSS only
due to a single received data frame, we add the bitrate that this frame
was transmitted at so we have one rate that we know it can transmit (and
presumably also receive).

What should happen is that once it starts beaconing we pick up a beacon
and extend our set of known good rates.

johannes

--=-W03l4hrplFLpG/fwjoIN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK/ni7AAoJEODzc/N7+QmaH/UQAJtWz2T3iEMe8tYaRXiESoW1
aDxQJsY/hiyh9SxV6mOIJS051W7A3/kixmhALrQEu0w6rsw8kY8Vll5mExMJMPt4
MuNJ3bkl1i2pZ43LQQKjj/U3O60z5TdCfsblhXhTUhaGa43rCelGNpoYkidsYoRS
2Up5D6pfWSY5w0chAdlkp8rbL5UqLxjDJWBKMFcCRbDwvWfpFl8qD6/WfyIZgu0T
Mi/mRI/ogAlK4xSDxHf3+ht3liJuqZ4sj8vKAP4tr+k14CkH97NdcVhs7s1Ghx2b
MdExNTcjC4kU3WSwbctvHeErzc8uYblxEj9d9DbKQ3aX0+HMAdK7bPx5tDD0PZi0
yZ2GuGZghyvxddMQiR6rN9++le5CGj/7smBtuUztP49gdv2VHfGf/ya6IKR1pBOd
2eAtNohXUA+wK9O9o1u7d4EQH++4YUwNsnQF0pAgNkuji76+rvjHlpqP0S1YD6eB
g3clwHHE3n+f8w0AsbEAhtmNxTEtg5fSrNzFt/AYNVwWTJPIdBkfsgEkXHSQGDqU
1dVWrU5KSVwOZq9SgoZCCbUD7CicRk3qn649rqMRCCxukKIQIsBZFuDU/bnPODeX
yKtpJQDAduodQuTqwGsRmMO7Jx+7DMPvIUghtW7YkcodQMvgY+ba2QEVRrYE0nFq
BIebNZB3UJXH8HINQ4Mu
=rIV7
-----END PGP SIGNATURE-----

--=-W03l4hrplFLpG/fwjoIN--

