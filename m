Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:41077 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752457Ab1LSVO3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Dec 2011 16:14:29 -0500
Date: Mon, 19 Dec 2011 22:14:23 +0100
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Ben Greear <greearb@candelatech.com>
Cc: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	Johannes Berg <johannes@sipsolutions.net>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
Subject: Re: [PATCH 1/2] nl80211: add support for mcs masks
Message-ID: <20111219211423.GA24764@pandem0nium> (sfid-20111219_221432_797739_90E837F7)
References: <1324304099-18327-1-git-send-email-siwu@hrz.tu-chemnitz.de>
 <1324304099-18327-2-git-send-email-siwu@hrz.tu-chemnitz.de>
 <4EEF5834.8080408@candelatech.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="W/nzBZO5zC0uMSeA"
In-Reply-To: <4EEF5834.8080408@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--W/nzBZO5zC0uMSeA
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Ben,

On Mon, Dec 19, 2011 at 07:28:52AM -0800, Ben Greear wrote:
> On 12/19/2011 06:14 AM, Simon Wunderlich wrote:
> >Allow to set mcs masks through nl80211. We also allow to set MCS
> >rates but no legacy rates (and vice versa).
>=20
> Can you not use the ht-caps logic that went in recently?  I was able
> to successfully set station MCS rates with it.  It only works for
> station devices at this point...but AP support could probably be
> added without too much trouble.

I have not tried that out yet, but one important side effect we are
using here is to force HT mode, also for No Ack packets which are
usually sent with the lowest (legacy) rate. We are building fixed
links and want to set a fixed HT rate there, and only this rate should
be used whenever possible (and no legacy rates).

As far as I understand, the ht caps overrides will only override
HT configurations, but what I want is to also let the rate matcher
consider HT rates too and to disable legacy rates completely.

As the mcs masks support has been prepared a long time ago in iw and
mac80211, it did not seem to be the worst idea to finally fill this
gap and implement it. :)

Cheers,
	Simon

--W/nzBZO5zC0uMSeA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk7vqS8ACgkQrzg/fFk7axYKLACfSr+icsFeviYnF5+hOI8aZ7Vr
6IIAn2BMIVg04eCTM72XSm37ellBJoOk
=kkVb
-----END PGP SIGNATURE-----

--W/nzBZO5zC0uMSeA--
