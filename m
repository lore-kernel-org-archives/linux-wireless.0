Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:45098 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751587AbYDUITr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Apr 2008 04:19:47 -0400
Subject: Re: [PATCH] mac80211: simplify code in util.c
From: Johannes Berg <johannes@sipsolutions.net>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1208745396.7941.14.camel@brick> (sfid-20080421_033628_732417_67302C89)
References: <1208745396.7941.14.camel@brick>
	 (sfid-20080421_033628_732417_67302C89)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-FaA7eo+e3+UckDQ0wGL9"
Date: Mon, 21 Apr 2008 10:19:09 +0200
Message-Id: <1208765949.26186.28.camel@johannes.berg> (sfid-20080421_091951_822115_AEBC455B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-FaA7eo+e3+UckDQ0wGL9
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2008-04-20 at 19:36 -0700, Harvey Harrison wrote:
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>

>  		if ((fc & IEEE80211_FCTL_FROMDS) && (fc & IEEE80211_FCTL_TODS))
> -			hdrlen =3D 30; /* Addr4 */
> +			hdrlen +=3D ETH_ALEN; /* Addr4 */
>  		/*
>  		 * The QoS Control field is two bytes and its presence is
> -		 * indicated by the IEEE80211_STYPE_QOS_DATA bit. Add 2 to
> -		 * hdrlen if that bit is set.
> -		 * This works by masking out the bit and shifting it to
> -		 * bit position 1 so the result has the value 0 or 2.
> +		 * indicated by the IEEE80211_STYPE_QOS_DATA bit.
>  		 */
> -		hdrlen +=3D (fc & IEEE80211_STYPE_QOS_DATA)
> -				>> (ilog2(IEEE80211_STYPE_QOS_DATA)-1);
> +		if (fc & IEEE80211_STYPE_QOS_DATA)
> +			hdrlen +=3D 2;

Have you checked the generated code? Last time I checked it was better
with what we had there.

johannes

--=-FaA7eo+e3+UckDQ0wGL9
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASAxN+6Vg1VMiehFYAQL9PRAAoWVT+nxq//DtBuiPJ5xJ49/QQKs9MPQu
Rh/HMaTXQk/d24WS3ph6h8v/DjWT6j1cjAV9pW2jidwisYUh2WXTmxYK3iFhsHIx
odp9JhAX0cEFd6BFwPnPqPI+Jv7hBJyznIFl8n/+V08r+BULsfhLSuvkEZtEen/n
Db5C1ETqnSOovscukyDLUA23NqLBkn8+GRkpb+a48suybqhXfmrF9ud9azjeSw4S
ymOcGj4kM3bY3pV65iDAESKuO13eV+Ne6cDF/A+27y3DIpqoSVdCUrRQRbwgMill
2yQ4yNkv/ohtLjKJY092gWGNmdmgg3ueIdogC4NZSz0Q5gZK8+vqFMGbCdqiF4PY
5gZlRc9ZKDFSIUSMT+EarYxr3LmAoR2MhvY1+St0HCbaYEx+oMh+HAbJ1OvmqVKx
rPaHijhDLxlJBKc4eoy1zPadrNsNNJRK+kmFThlyWZgV5s7sJRlvwkcZidaUiCpY
+gsEME4jp/Xgc14c9FUnyJzcxXL+CEPfZiYh4RoIuMFYQdWTyLjINT/sla5JGV67
1yqhhkLWJi/k6pwzeLb4jKCMpY6bORDh/AypUhM2QpULeA0w3nphZrr8/bRH2vdi
+dgX7uQ0ByrtqMpRaAT22nqtZOfMquEbMbKYRBo0EespaqSM0N5maOHOhGOfcjKD
mMSK9MR61yI=
=9wtW
-----END PGP SIGNATURE-----

--=-FaA7eo+e3+UckDQ0wGL9--

