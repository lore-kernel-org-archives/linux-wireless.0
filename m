Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:32771 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965738AbXFHBUe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jun 2007 21:20:34 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH V2] mac80211: Implementation of SIOCSIWRATE
Date: Thu, 7 Jun 2007 18:19:41 -0700
Cc: Jiri Benc <jbenc@suse.cz>, linux-wireless@vger.kernel.org
References: <4668a64b.VmU9f2GpA2itSuFx%Larry.Finger@lwfinger.net>
In-Reply-To: <4668a64b.VmU9f2GpA2itSuFx%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart4062484.aObavMgCNI";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200706071819.45603.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart4062484.aObavMgCNI
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Thursday 07 June 2007 17:43, Larry Finger wrote:
> +	sdata->u.sta.supp_rates_bits =3D supp;
Can't do this unless you verify sdata->type is IEEE80211_IF_TYPE_STA or=20
IEEE80211_IF_TYPE_IBSS.

Also, what rate(s) we choose to TX at doesn't have much to do with what rat=
es=20
we actually support. I don't think this should be set.

> +	if (sdata->type =3D=3D IEEE80211_IF_TYPE_STA) {
> +		sta =3D sta_info_get(local, sdata->u.sta.bssid);
> +		if (sta) {
> +			sta->txrate =3D sdata->u.ap.max_ratectrl_rateidx;
This is automatically set as soon as the next frame is TXed, as said before=
 in=20
the previous review.

> +			sta->supp_rates =3D supp;
This is definitely wrong. What rates we support has nothing to do with what=
=20
rates the AP supports.

One last thing - max_ratectrl_rateidx should be set to -1 to indicate no=20
maximum. Not doing this will cause problems when switching from one hw mode=
=20
to another with a different number of rates.

=2DMichael Wu

--nextPart4062484.aObavMgCNI
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGaK6xT3Oqt9AH4aERAh8VAKDRjm61/jI02/Pyu41/mGFNBom1qgCfcvqY
u9AEu7nEFN+uyJiXRGnsjWo=
=oa9I
-----END PGP SIGNATURE-----

--nextPart4062484.aObavMgCNI--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
