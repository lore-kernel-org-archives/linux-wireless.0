Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:37840 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753493AbZDRUtd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Apr 2009 16:49:33 -0400
Subject: Re: [PATCH] mac80211: fix beacon loss detection after scan
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: "John W.Linville" <linville@tuxdriver.com>,
	Jaswinder Singh Rajput <jaswinder@kernel.org>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20090418204614.32075.19851.stgit@tikku>
References: <20090418204614.32075.19851.stgit@tikku>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Mx4CzAE3BL5DivYO/GEN"
Date: Sat, 18 Apr 2009 22:49:25 +0200
Message-Id: <1240087765.25100.4.camel@johannes.local> (sfid-20090418_224936_152558_030372DD)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Mx4CzAE3BL5DivYO/GEN
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-04-18 at 23:46 +0300, Kalle Valo wrote:

> @@ -297,6 +297,13 @@ void ieee80211_scan_completed(struct ieee80211_hw *h=
w, bool aborted)
> =20
>  	local->last_scan_completed =3D jiffies;
> =20
> +	if (local->scan_sdata->vif.type =3D=3D NL80211_IFTYPE_STATION)
> +		/*
> +		 * Need to update last_beacon to avoid beacon loss
> +		 * test to trigger.
> +		 */
> +		local->scan_sdata->u.mgd.last_beacon =3D jiffies;
> +

A little lower is a hook function for the MLME -- it would be good to
put this in there, see ieee80211_mlme_notify_scan_completed()

johannes

--=-Mx4CzAE3BL5DivYO/GEN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ6jzSAAoJEKVg1VMiehFYqRkP/AqGKdLa+tv4yqQjHlo2M5JU
Cuqkzmzmt6T3hzhPjbvZCp2rTJ7+eIwKoYFJpdxB6BdAlyNY9Xv7RfiuoaiyBxcY
SpaeynofbmvNj7rMv+XJ/Tf52O15b0p34Hw9qj3P1Gii+VytK1nUq/5gRzHk77dc
HFg+kOPtfo9/CmOX63WG73G5YgF5xLFcO7TFi1DMBPRqlQjusVzw9NvHFOWFPiUi
AzCZPki/PQtlCKr8lvi5+KCIFABkR4dYqcudVoXSs4zWnjnIEp6e5SKRO8J/OVYb
UPfN9mZ4tu6eO9rqNuMg3nuJw7LO7mi7cTg0S4v7h3z/wMaJ6Bag7qZ4b7B+o3sD
CeyflmRRtbizbcqWeysnmz49vMfpbM0ybAah7/hP8zfKIYA0Id7S7keVTFpfPnLJ
46ymyrGa8O0Q5ZhA1Jn2cMbsN9RbO7XqhFfjO+osxDt2wxNmTjSeGu3ofwnyI+8t
X9Q8LczROZQiUP9VEHfYXEjG8fq8l08uhhtDjGSfK4kBGA/DiOT3vL+qqn4dSrrO
8qrIda+SpEPBzLoy16F4Mn3OjpkQicespmx4BcagF6gIVVr6IvIm4vuADsHXuURj
4qMrVxrhN3Hhx2geQF11//cXpXQHJxlZeWZPnXpZ1oFOAduyo6NYIxdqrW7jSMAt
Bx3YlXH2RrA2nvPFhs1N
=GXta
-----END PGP SIGNATURE-----

--=-Mx4CzAE3BL5DivYO/GEN--

