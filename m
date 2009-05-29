Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from jessica.hrz.tu-chemnitz.de ([134.109.132.47]:53191 "EHLO
	jessica.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753086AbZE2WdP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 May 2009 18:33:15 -0400
From: Tobias Doerffel <tobias.doerffel@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] ath5k: added initial RFKILL support
Date: Sat, 30 May 2009 00:33:07 +0200
Cc: Bob Copeland <me@bobcopeland.com>,
	Jiri Slaby <jirislaby@gmail.com>, ath5k-devel@lists.ath5k.org,
	mickflemm@gmail.com, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <1242850139-25438-1-git-send-email-jirislaby@gmail.com> <200905260124.03287.tobias.doerffel@gmail.com> <1243294366.29222.10.camel@johannes.local>
In-Reply-To: <1243294366.29222.10.camel@johannes.local>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1459946.JtoeU42TSx";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200905300033.12204.tobias.doerffel@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1459946.JtoeU42TSx
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

Hi,

Am Dienstag, 26. Mai 2009 01:32:46 schrieb Johannes Berg:
> On Tue, 2009-05-26 at 01:24 +0200, Tobias Doerffel wrote:
> > +       err =3D rfkill_register(sc->rf_kill.rfkill);
> > +       if (err) {
> > +               sc->rf_kill.rfkill =3D NULL;
> > +               return -1;
> > +       }
>
> Missing rfkill_free, and why -EPERM?
Thanks for this remark. I fixed the code and will post an updated patch soo=
n.

Any other comments on the patch? If not, any chance to get it merged into=20
wireless-testing branch?

> Could you try to work against v11
> of my rfkill patch, or better even against the cfg80211 rfkill instead?
I didn't look at both of them yet. However I think we first should try to g=
et=20
current rfkill support into mainline as fast as possible. Improvements and=
=20
adaptations to reworked rfkill framework can follow.

Regards,

Toby

--nextPart1459946.JtoeU42TSx
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkogYqQACgkQHsjdpw2OaadN3gCgmnp8YkuYbmoDpD+o3x73WjkM
jUEAn3ldLHI0oFAtuWuFXFmEKZG61aUX
=plLt
-----END PGP SIGNATURE-----

--nextPart1459946.JtoeU42TSx--
