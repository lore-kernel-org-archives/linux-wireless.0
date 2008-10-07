Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36910 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753764AbYJGRjp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Oct 2008 13:39:45 -0400
Subject: Re: mac80211 driver API
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Tomas Winkler <tomasw@gmail.com>,
	Michael Buesch <mb@bu3sch.de>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Chr <chunkeey@web.de>, Ivo van Doorn <ivdoorn@gmail.com>,
	Pavel Roskin <proski@gnu.org>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Nick Kossifidis <mickflemm@gmail.com>,
	Kalle Valo <kalle.valo@nokia.com>,
	Luis Carlos Cobo <luisca@cozybit.com>,
	Javier Cardona <javier@cozybit.com>,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
In-Reply-To: <20081007172149.GA3287@tuxdriver.com>
References: <1223398885.7328.47.camel@johannes.berg>
	 <20081007172149.GA3287@tuxdriver.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-D8bBbMk5FTSwUpMHyOKy"
Date: Tue, 07 Oct 2008 19:39:41 +0200
Message-Id: <1223401181.7328.59.camel@johannes.berg> (sfid-20081007_193949_188922_862B8862)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-D8bBbMk5FTSwUpMHyOKy
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-10-07 at 13:21 -0400, John W. Linville wrote:
> On Tue, Oct 07, 2008 at 07:01:25PM +0200, Johannes Berg wrote:
>=20
> > Another thing I noticed when looking at the short slot stuff is that a
> > number of drivers do not use the use_short_preamble flag but also do no=
t
> > set IEEE80211_HW_2GHZ_SHORT_PREAMBLE_INCAPABLE; this seems like a bug
> > affecting at least b43legacy, ath5k, at76_usb, rtl8180, rtl8187.
> >=20
> > You should review the mac80211 driver API for things you aren't using
> > but should be using, this affects a number of drivers, for example
> > adm8211, p54, stlc45xx, ath5k, ath9k, libertas_tf, rtl8180, rtl8187
> > don't use radio_enabled; a number of drivers don't use power_level.
> >=20
> > There are also still drivers (ath5k, adm8211, rtl8180, iwlwifi,
> > libertas_tf, zd1211rw, mac80211_hwsim, ...?) not using the
> > IEEE80211_TX_CTL_ASSIGN_SEQ flag, I can fix those since I broke them,
> > but help from the authors would be appreciated since I don't know the h=
w
> > in all cases, I know that stlc45xx for example can use a corresponding
> > firmware flag for it.
>=20
> Should we recruit janitor's (or gregkh's army) to help with stuff
> like the above?

Not sure that's possible, they'd have to ask a lot about how the hw
works.

> > Do we need a document that indicates which parts of the API must be
> > implemented? Or should we mark such things in mac80211.h? Would
> > something like this help? I've thrown this together quickly so it
> > probably isn't complete yet...
>=20
> <snip>
>=20
> Looks like a good start, and I would definitely value such a list.
> Please continue to improve it, and we'll figure-out where it needs
> to live in the long run.

I've put it up on
http://wireless.kernel.org/en/developers/Documentation/mac80211/API for
now, can those folks who did the HT/mesh/spectrum mgmt/etc. stuff help
completing it?

johannes

--=-D8bBbMk5FTSwUpMHyOKy
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI657ZAAoJEKVg1VMiehFY2QQP/R9rny7fHDLuI5GmrpyH0SVb
MZDZrVh2T6gdBPuF3WFw+N75ccIDW3C4l2NqYYrRPfkEn7eEbnqkWty6peg71EcG
J9XuZY2vCYwF5vdWfIFB7xiHNVY9FW8TWYtJWzTYdUHNzYP5SGRQorEYOictkmL8
e2vqWMHdBQV4PbHW74iCiO5xLa5In90rEJ53DZCw4T0zAWbC6pYmAGjzG0FXqn6A
lx4HOTEPT7GI8gHvtCk/tXivZZIGMQ4l/JuXWZ24MdnJz5OUKHDCUvPbOHRZoJRt
bvxLzeKtm/Q8lWFBIS1M2yi0nbOrG9JpQOiKyTnP/ceiIha9tTxz/UQLkV6JTdWI
gRxZn9MCgOb9f+Ga5Zf8uoUGzGILDvd+59iFcdWmlKnNVzKbneiumyzwp/f3eBF9
bekvqkXBk17811LJnJGgckHPfmosrd3FSBZRczTmTZdMH4g6RWGk2xd9ZtMw1n/P
kfvy2LWozT2Sx9FpPGMIwB5h1A+e59pvlVPZ76iP+GbhHeXA3B+megCreUCxWc0p
3xrjPGexI5z5TvuXr+7OWIJJJ1ZZaCjqI38xdemWAPHtw0iLjvfd32B4v4efS2Cd
SbnIOAtv8uVy0Xg7bkpDhcpJBuxqt0BC0BBCjLOURErcjstgfsiXMmxRXl6WJ28n
MJAklFtMoet8CsXuuflT
=6mhK
-----END PGP SIGNATURE-----

--=-D8bBbMk5FTSwUpMHyOKy--

