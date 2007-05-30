Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:9445 "EHLO annwn14.rutgers.edu"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750888AbXE3GsF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 May 2007 02:48:05 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] mac80211: Implementation of SIOCSIWRATE
Date: Tue, 29 May 2007 23:45:45 -0700
Cc: Jiri Benc <jbenc@suse.cz>, linux-wireless@vger.kernel.org,
	mabbas@linux.intel.com
References: <465c68e1.+11Pl6vbVkaPA39A%Larry.Finger@lwfinger.net>
In-Reply-To: <465c68e1.+11Pl6vbVkaPA39A%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1422044.HAtE6KP1hp";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200705292345.50212.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1422044.HAtE6KP1hp
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Tuesday 29 May 2007 10:54, Larry Finger wrote:
> From: Mohamed Abbas <mabbas@linux.intel.com>
>
So.. how much of this is still from mabbas now?

> +	/* value =3D -1, rate->fixed =3D 0 means auto only, so use all rates
> +	 * value =3D X, rate->fixed =3D 1 means only rate X
> +	 * value =3D X, rate->fixed =3D 0 means all rates <=3D X */
Only the second case actually works with this code.

When a frame is being transmitted, the rate control runs this little bit of=
=20
code (rc80211_simple.c, line 255):

        if (sdata->bss && sdata->bss->force_unicast_rateidx > -1)
                sta->txrate =3D sdata->bss->force_unicast_rateidx;

This means:
1. If force_unicast_rateidx is set to 0 or higher, the tx rate will be fixe=
d=20
to just that one rate, and..
2. sta->txrate is automatically set from force_unicast_rateidx as necessary.

=2DMichael Wu

--nextPart1422044.HAtE6KP1hp
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGXR2eT3Oqt9AH4aERAuseAJ4r27DgzE9mHHrIzTtCb4Ok2NY0OACg2qbo
cPDA10UnEhZWOx7qR16K/G8=
=WlTz
-----END PGP SIGNATURE-----

--nextPart1422044.HAtE6KP1hp--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
