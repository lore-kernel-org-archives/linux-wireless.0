Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:15345 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759623AbXFTHK1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2007 03:10:27 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Hong Liu <hong.liu@intel.com>
Subject: Re: [patch]mac80211: add support for iwlist channel
Date: Wed, 20 Jun 2007 00:08:43 -0700
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Jiri Benc <jbenc@suse.cz>, linux-wireless@vger.kernel.org
References: <1182156425.15928.7.camel@napa-sdv1.sh.intel.com> <200706182212.55862.flamingice@sourmilk.net> <1182308588.19178.17.camel@napa-sdv1.sh.intel.com>
In-Reply-To: <1182308588.19178.17.camel@napa-sdv1.sh.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart8960185.j0rO3rWNnC";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200706200008.47770.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart8960185.j0rO3rWNnC
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Tuesday 19 June 2007 20:03, Hong Liu wrote:
> +	struct ieee80211_hw_mode *mode =3D NULL;
> +	int c =3D 0;
> +
Shouldn't add an extra empty line here.

> +			if (chan->flag & IEEE80211_CHAN_W_SCAN) {
> +				range->freq[c].i =3D chan->chan;
> +				range->freq[c].m =3D chan->freq * 100000;
> +				range->freq[c].e =3D 1;
> +			}
> +			++j; ++c;
c shouldn't be incremented if the channel is being skipped.

Also, two minor comments on the style since this patch needs to be revised=
=20
anyway - using ++x instead of x++ looks a bit odd, and using 'int j'=20
when 'int i' is available is also a little strange.

Patch looks good otherwise.

=2DMichael Wu

--nextPart8960185.j0rO3rWNnC
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGeNJ/T3Oqt9AH4aERAg5zAJ4kcVZIPDDNiU/zLnPS727ecnj4QQCePeRm
hu5X24/4qGqX0tNSSeyJQL0=
=Oi1V
-----END PGP SIGNATURE-----

--nextPart8960185.j0rO3rWNnC--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
