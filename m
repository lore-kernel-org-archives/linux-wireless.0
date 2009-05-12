Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:51462 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752656AbZELGjx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 May 2009 02:39:53 -0400
Subject: Re: [PATCH 6/6] ar9170: stop data queues on channel switch
From: Johannes Berg <johannes@sipsolutions.net>
To: Christian Lamparter <chunkeey@web.de>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <200905120109.09906.chunkeey@web.de>
References: <200905120109.09906.chunkeey@web.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-sa8Al2Utzzqnol5FdKI3"
Date: Tue, 12 May 2009 08:39:49 +0200
Message-Id: <1242110389.3873.53.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-sa8Al2Utzzqnol5FdKI3
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-05-12 at 01:09 +0200, Christian Lamparter wrote:

> +		if ((ar->tx_stats[i].len < ar->tx_stats[i].limit) &&
> +		    (ieee80211_queue_stopped(ar->hw, i)))
> +			ieee80211_wake_queue(ar->hw, i);

There's no reason to test _stopped first, and doing so is racy.

>  	if (changed & IEEE80211_CONF_CHANGE_CHANNEL) {
> +		err =3D ar9170_stop_and_flush_queues(ar);
> +		if (err)
> +			goto out;

Why don't you do that in the pre-scan method?

johannes

--=-sa8Al2Utzzqnol5FdKI3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKCRmxAAoJEODzc/N7+QmadXUP/jHEZXMwoj9PC/X6dAyUmRC+
FtJYTJZcFqaKsaBJbq3AaDfZr4UB75EfHpmevdCd4V9P8KcuqPyF2aimI+Tlpd/J
T751Shk1+YaoxRMyy1ipyPMAEPocKk8J+8szgjeoesEU0kVi9PxqrjJIjkeDXbV4
IYEtuyXg1ffU5FmBXgwTta7N9ylUlB9zTdbfwb7YFouct8G2LaXYQO08Iu0IiBEo
BC8KRBIOqDR9ZSDTcrROAuyrv+CoSWc0w/68LGsmkZOHbjuE4E1En19qZfIawuPt
b83IEUjhWrH53zpho6/KND1cDpftmsIpcjgtU1KrCgmo+0UlWX3OjdbtYvRVb6ig
NZgEOuHjdJfcEcT2sHofM7o2tRjuvBWUJ9fR3T90Wu70G/3AZY58EIQUPgHckn0X
rm+lK2p6CQob81ggYRWKU5mUIyg9TlL9Y1i6g64FM8B+bfjdQQyJG1Va8X9pXsKc
gbj1AmWGFUZj+Fx+Khoirw+ot1fRddb9/WyzWtGa6A5RDCbi++HFSb/KnfGIUWem
9/Y78LRSw3GBvTm30/vzSVYRlYUYR5V2+ajpVftGIUBwJj+keicuDleCDHCsK/NI
yffVuvZ4mt8SttNwCgFRplk2C5rBAHy4+W1xHW8Q8Aul2zRnOnQ7Km10RZMpOFVG
8jhxfZQyyj0sa4fmtMk+
=XuWa
-----END PGP SIGNATURE-----

--=-sa8Al2Utzzqnol5FdKI3--

