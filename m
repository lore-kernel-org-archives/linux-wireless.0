Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:51656 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754098AbYGHKnI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Jul 2008 06:43:08 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <johannes@sipsolutions.net>)
	id 1KGAf5-0007eL-6D
	for linux-wireless@vger.kernel.org; Tue, 08 Jul 2008 12:43:07 +0200
Subject: Re: [RFT 1/4] mac80211: make master netdev handling sane
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
In-Reply-To: <20080705235012.501072000@sipsolutions.net> (sfid-20080706_015140_641922_45522129)
References: <20080705234735.210585000@sipsolutions.net>
	 <20080705235012.501072000@sipsolutions.net>
	 (sfid-20080706_015140_641922_45522129)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-x81DTO9bGJOYGQr0HnyS"
Date: Tue, 08 Jul 2008 12:42:24 +0200
Message-Id: <1215513745.9610.22.camel@johannes.berg> (sfid-20080708_124314_090646_9B77ED9C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-x81DTO9bGJOYGQr0HnyS
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2008-07-06 at 01:47 +0200, Johannes Berg wrote:
> plain text document attachment (004-mac80211-master-not-ap.patch)
> Currently, almost every interface type has a 'bss' pointer
> pointing to BSS information. This BSS information, however,
> is for a _local_ BSS, not for the BSS we joined, so having
> it on a STA mode interface makes little sense, but now they
> have it pointing to the master device, which is an AP mode
> virtual interface. However, except for some bitrate control
> data, this pointer is only used in AP/VLAN modes (for power
> saving stations.)
>=20
> Overall, it is not necessary to even have the master netdev
> be a valid virtual interface, and it doesn't have to be on
> the list of interfaces either.
>=20
> This patch changes the master netdev to be special, it now
>  - no longer is on the list of virtual interfaces, which
>    lets me remove a lot of tests for that
>  - no longer has sub_if_data attached, since that isn't used
>=20
> Additionally, this patch changes some vlan/ap mode handling
> that is related to these 'bss' pointers described above (but
> in the VLAN case they actually make sense because there they
> point to the AP they belong to); it also adds some debugging
> code to IEEE80211_DEV_TO_SUB_IF to validate it is not called
> on the master netdev any more.

>  	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
> -
> -		/* No need to wake the master device. */
> -		if (sdata->dev =3D=3D local->mdev)
> -			continue;
> -

Just noticed that the patch was missing two hunks like that, I'll post
with them when I post this for good.

johannes

--=-x81DTO9bGJOYGQr0HnyS
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIc0SNAAoJEKVg1VMiehFYhrEP/3mbJKmrCCBg7Y5gg7ib1XVo
Q7rJs3PYc8m19hBUmVWWk+XRiAk/NH9VvbBWYFJ/3T//kJKRC9xGjW+56LgqlWjC
oR2DnJ2pL0LiSbkbwkndR2rqTLSL+o4vu+bXBik5lbxaLKwRFCvUT6iAoTPxp8zx
7oiIKsdBdym5EykvAvmsw/M8IlT9m3c6vAPrDaZhpzuOCpyDh5MA2AyzJ6b2sNri
NapRM9OUVfoVPB5JUV+94+a0ifmQqWVnSyWn5lnr1R7jlq1ygcEUIhH+hZmEVW2B
yNWP95gTN0pn57CroYmpVgqUEwVXPib48qdL4KoYSyeGn+JpM6PTqAh81GtJTBYH
j6cH5511ryErdulA7G9kwsaa5eM3ODW8e22MsC6YNJv5jxP1WnKmwz4rRDOObd0Y
DJKfK6vCu6gGle4/Bd18VXHlkDjA/jO7D9gtKhjDYGLVMa7INLk0bkdcYMxpDdmU
HdrVI2EzxDIxVpbTp05YE2xFT1ci8/vpx4CSck78pIfHOkDP8ZKGnN4GZkYU9fNa
Qk4Kh9q4lTLqhvn+r5cKUCsOManVHhuDSqRI+vTCP4WQKczQYIYR6IbekbGYqfJ+
ecH5nvl/i14hbtyrBCWTj6YlwGTNVZZjj7Cdjv1MtnV8alfK5HL0pijEhW6S7sws
Yej3dD5Nk1XcICaEhRg1
=iCWv
-----END PGP SIGNATURE-----

--=-x81DTO9bGJOYGQr0HnyS--

