Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx34.mail.ru ([194.67.23.200]:14372 "EHLO mx34.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753329AbYKBKfZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Nov 2008 05:35:25 -0500
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: David Kilroy <kilroyd@googlemail.com>
Subject: Re: [RFC PATCH 0/2] orinoco: Don't keep cached firmware around permanently
Date: Sun, 2 Nov 2008 13:35:19 +0300
Cc: linux-wireless@vger.kernel.org,
	orinoco-devel@lists.sourceforge.net,
	linux-pm@lists.linux-foundation.org
References: <1225415743-28209-1-git-send-email-kilroyd@googlemail.com>
In-Reply-To: <1225415743-28209-1-git-send-email-kilroyd@googlemail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3282186.GzpBzu53If";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200811021335.20241.arvidjaar@mail.ru> (sfid-20081102_113552_318513_705EFA8A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart3282186.GzpBzu53If
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Friday 31 October 2008, David Kilroy wrote:
> The recent patch to load orinoco firmware correctly on resume simply
> kept the firmware in RAM for the entire time the module was loaded, and
> only applied to Agere firmware.
>=20
> The first patch uses the new power management notifiers to load and
> release the firmware prior to suspend and after resume (for both Agere
> and Symbol). I'm not an expert on where suspend/resume is headed, so I'd
> appreciate any advice from linux-pm on whether this is the preferred way
> to do things.
>=20

I tested this and it works, and looking how callbacks are invoked I think
it is techically correct. But I have some concerns about general idea of
requesting firmware multiple times that are not related to PM.

Many properties for the currently running device/driver instance depend on
particular firmware type and version. Now we blindly replace firmware; how
can we be sure it is actually the same one as was at the time feature set
was detected?

Even if some sort of checksumming were impemented we still have to be
prepared to completely reinitialize card on FW mismatch.

I checked what the rest of drivers/net does and either they do not cache at
all (does not work in this case) or they cache FW im memory after initial
request.

Comments?

--nextPart3282186.GzpBzu53If
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkkNgmgACgkQR6LMutpd94yAUACfXkLSfy1T+M2y7sBSK9UNFlu9
Z64AoI7rzWoC46HSwZKgIUz/udJzkjHZ
=rHoj
-----END PGP SIGNATURE-----

--nextPart3282186.GzpBzu53If--
