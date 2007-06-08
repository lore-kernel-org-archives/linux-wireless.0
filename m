Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:20041 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S935002AbXFHBhs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jun 2007 21:37:48 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] mac80211: Set low initial rate in rc80211_simple
Date: Thu, 7 Jun 2007 18:37:08 -0700
Cc: Jiri Benc <jbenc@suse.cz>, linux-wireless@vger.kernel.org
References: <4668a726.gQ0fmk5ZDAnWoXla%Larry.Finger@lwfinger.net>
In-Reply-To: <4668a726.gQ0fmk5ZDAnWoXla%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart16878390.3o9VBemi3o";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200706071837.13084.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart16878390.3o9VBemi3o
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Thursday 07 June 2007 17:47, Larry Finger wrote:
> +		    (mode->rates[i].flags & IEEE80211_RATE_SUPPORTED)) {
> +			if (mode->rates[i].rate < min_rate) {
> +				min_rate =3D mode->rates[i].rate;
> +				sta->txrate =3D i;
> +			}
You can just use the first supported rate you find. The rest of the rate=20
control code makes the assumption that lower rate indices are more reliable=
=20
than higher ones.

=2DMichael Wu

--nextPart16878390.3o9VBemi3o
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGaLLJT3Oqt9AH4aERAgLyAKCBL6sjG4ftM0ad8QwwAEgkGP33VwCaAuA5
xMh17PRqm5KTwvaBuZvYZo8=
=tvb7
-----END PGP SIGNATURE-----

--nextPart16878390.3o9VBemi3o--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
