Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:50716 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416AbZBXCoZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Feb 2009 21:44:25 -0500
Subject: Re: [RFC PATCH v1 2/3] mac80211: track beacons separately from the
	rx path activity
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kalle.valo@nokia.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20090223163731.20939.62567.stgit@tikku>
References: <20090223163626.20939.4879.stgit@tikku>
	 <20090223163731.20939.62567.stgit@tikku>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-kFwfKlx8MnWRyA8bwxQM"
Date: Mon, 23 Feb 2009 18:15:58 -0800
Message-Id: <1235441758.4455.64.camel@johannes.local> (sfid-20090224_034427_431147_EB493CF3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-kFwfKlx8MnWRyA8bwxQM
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-02-23 at 18:37 +0200, Kalle Valo wrote:

> @@ -1356,6 +1359,8 @@ static void ieee80211_rx_mgmt_assoc_resp(struct iee=
e80211_sub_if_data *sdata,
>  	bss_conf->assoc_capability =3D capab_info;
>  	ieee80211_set_associated(sdata, changed);
> =20
> +	ifmgd->last_beacon =3D jiffies;
> +

That looks a little misplaced; I think it's actually intended anyway?
Maybe add a comment?

> -		sta->last_rx =3D jiffies;
> +		if (rx->sdata->vif.type =3D=3D NL80211_IFTYPE_STATION &&
> +		    ieee80211_is_beacon(hdr->frame_control)) {
> +			rx->sdata->u.mgd.last_beacon =3D jiffies;
> +		} else
> +			sta->last_rx =3D jiffies;

would it be more appropriate to do that in the function that processes
the beacon in mlme.c? Or does that not work because of the workqueue and
timing?

johannes

--=-kFwfKlx8MnWRyA8bwxQM
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJo1hcAAoJEKVg1VMiehFYk7cP/RqEmrSqH+SKbBGBymmjHSST
N6cyhLqGTWJdsdUGhLqHc7AJWkVGeZMGds2RPaeWGK4JlwdM2AX9rhyrDRgsg3na
+zE8KSCjfVkf+Rmt1KTsaIQsdJUgqhm3VKOODStIhXH2Lka1K3yeMKa3C80MKWQU
4VUo86tER5HSd7nELZhIie6kzW2e/f+90KzM8SwcliCxBeZM07DJEdKVUGpcCGVd
ZEfkAnPuXopALtnWryfoSf94PyUzkW2y+g3myERVNMccYSSWef0zTywKszHqWcjS
gTYWnRNVZfYGWR8TDkmJGTfWC4F6nB1dX4WzpdeQeGtRSTxUmzjJNb1eN+I/z9Cc
75PDmTGYXcZRJ8IKcZllBBFvz7eK8b0n1C+LVyUFFlLI0qHlGFv0IGvhkyyBF3U6
ar2LEpPhoRl6Nun72dv1tdAJXOfMde2rxY4x/LA+ACcAxb7Puinm3fUjiWHVcgKd
NU2myU86SnAm0/1YY77ksaVu5t/y3mPatKI2bnKZTHCGKQp+8vhv4U2f151ktDzq
ujq5Hlm6SSTg5AcUB/m+766cLfaW9ogVSYup7cTfvnZ+rskNrPEBvEJH45RicKQf
Bj4yekUyCzUDFVZZ+rHpDu3oUOo3+XTCyIoPL6Y10QcwU6nPI25cDLZNoxPylGeE
C4cAZWJGK7fr0krB84sx
=pVGl
-----END PGP SIGNATURE-----

--=-kFwfKlx8MnWRyA8bwxQM--

