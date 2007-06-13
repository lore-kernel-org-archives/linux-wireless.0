Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:53362 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752665AbXFMFzm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jun 2007 01:55:42 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: andy@warmcat.com
Subject: Re: [PATCH Try#10 4/4] mac80211: Monitor mode radiotap-based packet injection
Date: Tue, 12 Jun 2007 22:54:38 -0700
Cc: linux-wireless@vger.kernel.org
References: <20070612095551.323709697@warmcat.com> <20070612095658.362328798@warmcat.com>
In-Reply-To: <20070612095658.362328798@warmcat.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2670701.fnkYScNCuX";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200706122254.43782.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart2670701.fnkYScNCuX
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Tuesday 12 June 2007 02:55, andy@warmcat.com wrote:
> +		/* see if this argument is something we can use */
> +		switch (iterator.this_arg_index) {
I suggest also handling flags and checking for the FCS bit. (and strip the=
=20
last four bytes of the skb if it is present) That should make it possible t=
o=20
directly inject any captured frames.

> +				/* end on exact match */
> +				if (r->rate =3D=3D target_rate)
> +					i =3D mode->num_rates;
> +
Unnecessary blank line.

These patches should be pretty good now. I suggest CCing John Linville,=20
Johannes Berg, and Jiri Benc on the next series. I'd like to get these=20
patches in soon if there are no other issues. 12 tries should be enough to=
=20
get this right. ;)

Thanks,
=2DMichael Wu

--nextPart2670701.fnkYScNCuX
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGb4ajT3Oqt9AH4aERAmwaAJ9FUJb/nlebkar00UtXOriSI4VpEgCeMRXk
rwwG2R+FV9qyeqIjvtvTUd0=
=L6o+
-----END PGP SIGNATURE-----

--nextPart2670701.fnkYScNCuX--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
