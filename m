Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:57684 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842AbZIKAu5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Sep 2009 20:50:57 -0400
Subject: Re: [PATCH] cfg80211: allow scanning on specified frequencies when
 using wext-compatibility
From: Johannes Berg <johannes@sipsolutions.net>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: John W Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200909091309.55068.hs4233@mail.mn-solutions.de>
References: <200909091309.55068.hs4233@mail.mn-solutions.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-sOzIre+X/SoqP02Dl8D9"
Date: Fri, 11 Sep 2009 02:41:04 +0200
Message-Id: <1252629664.23427.4.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-sOzIre+X/SoqP02Dl8D9
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-09-09 at 13:09 +0200, Holger Schurig wrote:
> Handles the case when SIOCSIWSCAN specified iw_scan_req.num_channels and
> iw_scan_req.channels[].

> +
> +			/* If we have a wireless request structure and the
> +			 * wireless request specifies frequencies, then search
> +			 * for the matching hardware channel.
> +			 */
> +			if (wreq && wreq->num_channels) {
> +				int k;
> +				int wiphy_freq =3D wiphy->bands[band]->channels[j].center_freq;
> +				for (k =3D 0; k < wreq->num_channels; k++) {
> +					int wext_freq =3D wreq->channel_list[k].m / 100000;
> +					if (wext_freq =3D=3D wiphy_freq)
> +						goto wext_freq_found;
> +				}
> +				goto wext_freq_not_found;

This is a bit weird -- this way you don't report errors if the user
specified frequencies that don't exist. Also, are you sure that it has
to be a frequency as opposed to a channel number?

johannes

--=-sOzIre+X/SoqP02Dl8D9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKqZybAAoJEODzc/N7+QmapPsQAMbeHSnu4+cOwhd+tp8qOcmu
+u7SwVUvFIazDfsZUdudh+/FblP72of71BUjtJv28HRwifU+YxxTQVjFiLrsp6WQ
kj1VQeX1f6WsHqqmZ4gy39wNYGsdRObha8JnuMBc1VzrCiOsM72KwCFtF/SEyZ/w
CxP3TL4LogPCaHI8Cj60z9xx38vd9Kr5m5Ug1JK4fAxS+DeF++7ALmTmYwtvgP2F
uKH8NHboJ6Isdz5xTBgUPHQIuu9utRYJ3nPRli1fYBjgwua/fIs5SaBrojLSvbic
ZKV5+sImuz5DWN3GZS81qyWk5+MUQ3s3vsR18XT8HXbiSlZmIICc6LDzatpBjNnM
kg8vOnXwEsc0sLB7ErbH3dKcYHVJtcV6Cp8Ri4olTCvNVpWCI8AHz5oj1hD0gVr7
mVQAN9m1w+Q8TD0wI6jMjxo17C2KuIVuia4ZGRAwy/h99bpxdJQJvk9lGpT9E0cs
yQNBA2x4e4afDrXhktdZ04MOhNdcYQrACelq6kYFM53DAQPH0ieG7Gya4uJbW0ne
miTiVLU8aofsCN586IgdQnxnFT0Uejg1JDGCnxk12gW4cYlJan+LOtqLVV3NrCWF
A3knnZQKhq3WLgO7BkJ9HPUZY/v20xvXAAfAlonRiY8Yf9cGJwnaZyI4E+k06NQR
+jvJI2m2CHlqm0ydhvaH
=iAYw
-----END PGP SIGNATURE-----

--=-sOzIre+X/SoqP02Dl8D9--

