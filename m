Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:34534 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767889AbXEDK5c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 May 2007 06:57:32 -0400
Subject: Re: [PATCH V3] mac80211: Add support for SIOCGIWRATE ioctl to  provide rate information
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Jiri Benc <jbenc@suse.cz>, Bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org,
	Michael Wu <flamingice@sourmilk.net>
In-Reply-To: <463a8a92.jFmmjY4cDnfJeisJ%Larry.Finger@lwfinger.net>
References: <463a8a92.jFmmjY4cDnfJeisJ%Larry.Finger@lwfinger.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-WnYXOyp1cADWqGlpXriJ"
Date: Fri, 04 May 2007 12:58:32 +0200
Message-Id: <1178276312.7408.9.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-WnYXOyp1cADWqGlpXriJ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-05-03 at 20:21 -0500, Larry Finger wrote:

> +	sdata =3D IEEE80211_DEV_TO_SUB_IF(dev);
> +	if (sdata->type =3D=3D IEEE80211_IF_TYPE_STA ||
> +	    sdata->type =3D=3D IEEE80211_IF_TYPE_IBSS)
> +		sta =3D sta_info_get(local, sdata->u.sta.bssid);
> +	else
> +		return -EOPNOTSUPP;

Is this racy if somebody changes the type of the interface at the same
time? Would a fix be to sta_info_get() beforehand? I really don't know
without digging the code, Jiri, Michael?

johannes

--=-WnYXOyp1cADWqGlpXriJ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGOxHY/ETPhpq3jKURAqKyAJwJcIeri9ssnVdLg2A/ZtbXrlGbUQCggqKQ
zYHb35JKWi1CnWBDN2nJ/u4=
=Mcnp
-----END PGP SIGNATURE-----

--=-WnYXOyp1cADWqGlpXriJ--

