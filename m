Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:57286 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753173Ab3GIT4b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Jul 2013 15:56:31 -0400
Date: Tue, 9 Jul 2013 21:56:26 +0200
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	linux-wireless@vger.kernel.org,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: Re: [PATCH] mac80211: fix 5/10 MHz tx_status regression
Message-ID: <20130709195626.GA23899@pandem0nium> (sfid-20130709_215642_746550_B23A6858)
References: <1373397200-23686-1-git-send-email-siwu@hrz.tu-chemnitz.de>
 <1373397346.8241.9.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="huq684BweRXVnRxX"
In-Reply-To: <1373397346.8241.9.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--huq684BweRXVnRxX
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 09, 2013 at 09:15:46PM +0200, Johannes Berg wrote:
> On Tue, 2013-07-09 at 21:13 +0200, Simon Wunderlich wrote:
> > sdata may be used uninitialized in ieee80211_tx_status() when adding the
> > radiotap header. It was added as parameter in "mac80211: select and
> > adjust bitrates according to channel mode" to find the current control
> > channel width (5/10/20+ MHz) and is used to report the bitrate
> > correctly. Fix this by identifing the required shift when cycling
> > through the interfaces.
> >=20
> > Reported-by: kbuild test robot <fengguang.wu@intel.com>
> > Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
> > Cc: Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
> > ---
> > You might want to squash this into the offending patch before sending it
> > further upstream.
>=20
> I was about to drop most of your patches again, but OK :)

Yeah I can imagine, and I would like to avoid that. :P

Thanks,
	Simon

--huq684BweRXVnRxX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlHcauoACgkQrzg/fFk7axa21ACgs1r1hwUE8MDpP8yUI095lBU0
610An26GBvDjJuKhNVVs3PNdxs2U3x2k
=7oEm
-----END PGP SIGNATURE-----

--huq684BweRXVnRxX--
