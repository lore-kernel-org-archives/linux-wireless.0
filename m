Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60469 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752779AbYETO2S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 May 2008 10:28:18 -0400
Subject: Re: iwlwifi injection bug
From: Johannes Berg <johannes@sipsolutions.net>
To: Stefanik =?ISO-8859-1?Q?G=E1bor?= <netrolller.3d@gmail.com>
Cc: Tomas Winkler <tomasw@gmail.com>, Zhu Yi <yi.zhu@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Andy Green <andy@warmcat.com>
In-Reply-To: <69e28c910805200716i3fd16c33x274983ab8e7591e6@mail.gmail.com> (sfid-20080520_161641_997749_579DFD8F)
References: <1210945631.6381.11.camel@johannes.berg>
	 <1211249729.2532.59.camel@debian.sh.intel.com>
	 <69e28c910805200432lbd3790vb925dacaea3aca83@mail.gmail.com>
	 <1211287111.6252.84.camel@johannes.berg>
	 <69e28c910805200614q2232b21ame8ff03fe4156fb3b@mail.gmail.com>
	 <1ba2fa240805200641j4ccc1de4r5572e1321394a526@mail.gmail.com>
	 <69e28c910805200716i3fd16c33x274983ab8e7591e6@mail.gmail.com>
	 (sfid-20080520_161641_997749_579DFD8F)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-LXvMry7Hedv09G51CDAK"
Date: Tue, 20 May 2008 16:27:11 +0200
Message-Id: <1211293631.6252.98.camel@johannes.berg> (sfid-20080520_162822_096632_CFA4437B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-LXvMry7Hedv09G51CDAK
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> -	/* drop all data frame if we are not associated */
> -	if ((!iwl3945_is_associated(priv) ||
> +	/* drop all data frame if we are not associated and not monitoring */
> +	if (((!iwl3945_is_associated(priv) && priv->iw_mode !=3D
> IEEE80211_IF_TYPE_MNTR) ||
>  	     ((priv->iw_mode =3D=3D IEEE80211_IF_TYPE_STA) && !priv->assoc_id))=
 &&
>  	    ((fc & IEEE80211_FCTL_FTYPE) =3D=3D IEEE80211_FTYPE_DATA)) {
> -		IWL_DEBUG_DROP("Dropping - !iwl3945_is_associated\n");
> +		IWL_DEBUG_DROP("Dropping - !iwl3945_is_associated outside monitor mode=
\n");
>  		goto drop_unlock;
>  	}

This makes injection not work when you're not exclusively in monitor
mode. Yes, it may break the spec to be sending frames to an arbitrary
station, but it's useful for all kinds of things including testing to
have a monitor and a regular interface working at the same time.

johannes

--=-LXvMry7Hedv09G51CDAK
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASDLfvqVg1VMiehFYAQKMJRAAonQvRiV3Zlz4PdNsRcFtWuF/i/PgPtE/
dROs4b6yK8mreAUuA7EmrF+Fg010umhC4joLUWqd+yvKgQ1sDQ8AFNdEskHbeIMe
mM0Hb95cXkFg6YzyNdBWXPciCDzlz1GE2hybBoDn0mZAFcQE2kBUR4V4wYrQYobP
pabNsJqbmhW8IF/Dn7EXw57iBtxK+QvBLdSBS0lC5JfUJrYZ4SKsTjoYrG9wgqRb
QbXW8qhqaaVVtpzn98g7kAOr8y/su1O2jQE2C5rer1V9fKWZrTH9A+2A0ouwZGWP
sKRGVDi3jMu0MxYNq2Ibb9okRaB3jzij7bnmKtWBsQjZ2rPniD37OYOVg4Ll6l9P
Cyw5qefjkDn/iHoDJxW0KW94ZogSPaaxDX/JgGYmMTcGOrx1GqXnZ8+eZ7Ndloy3
gpjU/7o0Z+e0w+GXUOKxJZXs4wFIfsEx6jQUzXI9O8B1+CSGJSMNjTL6jHAapjOa
XB0Ib6mnMOQFc4rQSGBUsoSS7n2f4bsRm/cvOM+bN1Q4Ee8i0muN7dB/qNKrqHvy
fqdRyRnW6bviA+zgrs95FtVYFP7uTGhLGHveNa6Rmyzg4ozqaaRlwjtrnN4RTMIU
Xy6tZHVMmWsI0iO+GPESEER5Ek6ndIhEbYhuMMxZFDzj36Yf9vrx9OMm1Q17+ali
r0dv1plIKgM=
=r9yQ
-----END PGP SIGNATURE-----

--=-LXvMry7Hedv09G51CDAK--

