Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:49890 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757284AbZD3OSd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Apr 2009 10:18:33 -0400
Subject: Re: [RFC v6] rfkill: rewrite
From: Johannes Berg <johannes@sipsolutions.net>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Inaky Perez-Gonzalez <inaky@linux.intel.com>,
	Dirk Opfer <Dirk@Opfer-Online.de>,
	Matthew Garrett <mjg@redhat.com>,
	Larry Finger <Larry.Finger@lwfinger.net>
In-Reply-To: <20090430141104.GB28027@khazad-dum.debian.net>
References: <1238349195.24972.5.camel@johannes.local>
	 <1239745712.4205.17.camel@johannes.local>
	 <1239750483.4205.28.camel@johannes.local>
	 <20090430031903.GD18827@khazad-dum.debian.net>
	 <1241081621.27613.14.camel@johannes.local>
	 <20090430141104.GB28027@khazad-dum.debian.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-y6iqFUBfeyngCDtTeixZ"
Date: Thu, 30 Apr 2009 16:18:00 +0200
Message-Id: <1241101080.29878.6.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-y6iqFUBfeyngCDtTeixZ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-04-30 at 11:11 -0300, Henrique de Moraes Holschuh wrote:

> > > Also, due to races, it is _impossible_ to assure the backend driver
> > > that the set_block hook will never be called when the radio is
> > > hard-blocked.  Best to change the description of that hook to make it
> > > clear that it could happen, but that the rfkill core will try to
> > > optimize away such changes.  Here's the race:
> > >=20
> > >            A                                  B
> > > rfkill_set_block
> > >     saves state in "prev"
> > >     ...                            rfkill_set_hw_state(true)
> > >     call set_block hook
> > >       but radio IS hard-blocked
> > >       and the core WAS informed
> > >       of this
> >=20
> > Good point. I wonder what's more important -- it would be almost trivia=
l
> > to change this by using a spinlock instead of atomic bit operations.
>=20
> Yeah, as long as it is a spinlock variant that can be used safely in any
> context, it should work fine, as contention would be quite rare (unless
> there is a pathological case in one driver that makes it always call some
> set_foo just when the core is going to call it back...)

Heh, that would be strange.

> >  * rfkill_set_block can set a flag "I'm in an update"
> >  * a concurrent rfkill_set_sw_state will check that flag, and update th=
e
> >    "prev" variable instead of the real variable
> >  * on errors, rfkill_set_block will then revert to whatever the last
> >    set_sw_state said
>=20
> That could work.  It is still required to make it clear that the set_bloc=
k
> hook can be called with a hardware block active, even if it normally won'=
t
> be, so that backend drivers are aware of the possibility.

Right, it could still happen, if the driver has just called set_hw_state
when something decided to change the sw state. Should be relatively rare
though. The other race can also happen, but the driver needs to take
care of the return value of set_hw_state() so it doesn't matter.

I'll see if I can implement this.

johannes

--=-y6iqFUBfeyngCDtTeixZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ+bMVAAoJEKVg1VMiehFYadUQAJNp9MRQqXeuZ4huyuIPYyfx
RcOA3l0ymTQ+idYKyIaRJuyClLGindpTCfM2WXVNtkKbuSR5ZmHzzimaWJLKsm3P
QnDbsn95CHM2Mrt3NLr2/9F61+1DW8NyQWmkq73ODque16UrDxeBJR9eM4lSZ9PE
4qDnVOctKAaQAEO37xTizelxvTCTfmHP+yKm+eZPl46/ev/j8/z2URliupcWwlf3
MDdbrX49rNYcqAi9SeERPQlQjIwxm8K3sRq+HN8jwTtS0W0AdTFBFwlWE4ya5UMg
/tbVc2gKh5gp9RyvW+uMYCVaJIx40fG1sDe1GQ2lLWE/n9BwKofyDfMlPnKw+q4L
whhlP9hgOC42hz46lzYhMa4i35IRmsB5hMp3oPyeMDEGouG2eL8PnrKTvPts3/VP
kCyf3ryvB17WtLEHi+bwAHzes1xV0jTobS8OtdMCyz082TzAYqoln58JtIBrrCia
GimcISzUl4xlszr/OWZtyCS2riqFqIMpLwqhwqYDlqfhQrT9Al+hdf3nf7lXMn9I
3Yp3xt/fjXtX7G4BD0SEI4CJthKRr1dUfFdENNy4Y/XaGwa8jU2iL7mhGzv+e2KN
+oeIlHpJX8tYzYbTmW8e6jquC/4LEksQOuRzaCZyx/6Y5yW4wPfEqhUSczettH0C
+NdSD0nFeIEl0IvJEZPG
=yicX
-----END PGP SIGNATURE-----

--=-y6iqFUBfeyngCDtTeixZ--

