Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:58998 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965707AbXCPR3V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Mar 2007 13:29:21 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Hong Liu <hong.liu@intel.com>
Subject: Re: [PATCH 3/5] mac80211: fix key restricted/open display
Date: Fri, 16 Mar 2007 13:28:34 -0400
Cc: Jiri Benc <jbenc@suse.cz>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <1174015698.3408.41.camel@devlinux-hong>
In-Reply-To: <1174015698.3408.41.camel@devlinux-hong>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1964297.rPOTp2OQBs";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200703161328.41006.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1964297.rPOTp2OQBs
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Thursday 15 March 2007 23:28, Hong Liu wrote:
> +	if (erq->flags & (IW_ENCODE_OPEN | IW_ENCODE_RESTRICTED))
> +		if (sdata->type =3D=3D IEEE80211_IF_TYPE_STA ||
> +		    sdata->type =3D=3D IEEE80211_IF_TYPE_IBSS)
> +			sdata->u.sta.auth_algs =3D
> +				(erq->flags & IW_ENCODE_RESTRICTED) ?
> +				IEEE80211_AUTH_ALG_SHARED_KEY :
> +				IEEE80211_AUTH_ALG_OPEN;
> +
This is not right because encrypted access points often do not require shar=
ed=20
key authentication to associate. In fact, some cannot or refuse to use shar=
ed=20
key authentication and your patch prevents retrying with a different=20
authentication algorithm.

IW_ENCODE_RESTRICTED simply means that the interface should not make/accept=
=20
unencrypted connections. In client mode without wpa_supplicant, the AP=20
selection code already refuses to select any APs without encryption enabled=
=20
if the default key is set. In adhoc mode, there's no such check, but I'm no=
t=20
sure how much it matters.

=2DMichael Wu

--nextPart1964297.rPOTp2OQBs
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBF+tPIT3Oqt9AH4aERAg9yAJ4npFM6g1WqMqXD5L88F5w0FLf7pQCg03Cr
Pj8df1DQa766jf9QFZkftUY=
=GRK/
-----END PGP SIGNATURE-----

--nextPart1964297.rPOTp2OQBs--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
