Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:50368 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752826Ab3EJJct (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 May 2013 05:32:49 -0400
Date: Fri, 10 May 2013 11:32:41 +0200
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Adrian Chadd <adrian@freebsd.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: Re: [PATCH 0/8] Add support for 5 and 10 MHz channels
Message-ID: <20130510093241.GA28714@pandem0nium> (sfid-20130510_113303_500368_96269F62)
References: <1368170776.8390.4.camel@jlt4.sipsolutions.net>
 <CAJ-Vmo=RCVOD1ffraTexETgqYP6LbLAa_g0d2DVd8yTO99Q1AQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PEIAKu/WMn1b1Hv9"
In-Reply-To: <CAJ-Vmo=RCVOD1ffraTexETgqYP6LbLAa_g0d2DVd8yTO99Q1AQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--PEIAKu/WMn1b1Hv9
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hey,

On Fri, May 10, 2013 at 02:12:00AM -0700, Adrian Chadd wrote:
> On 10 May 2013 00:26, Johannes Berg <johannes@sipsolutions.net> wrote:
> > On Thu, 2013-05-09 at 20:10 +0200, a@pandem0nium wrote:
> >
> >> Comments:
> >>  * Is there any special requirement for handling beacons? For example,
> >>    rates are halfed or quartered, but some rates could not be represen=
ted
> >>    in the rate IEs. For example, 2.25 mbit/s can not be represented as
> >>    multiple of 500 kbps.
> >>  * therefore, all rates are handled like the corresponding 20 MHz
> >> rates
> >>    internally, which makes a lot of things easier (no changes required
> >>    for rc-algos, beacon creation, etc...). We might consider adjusting
> >> the
> >>    output of rates for nl80211 or radiotap, though.
> >
> > This seems completely wrong, since Clause 18 says:
> >
> >         The OFDM system also provides a =E2=80=9Chalf-clocked=E2=80=9D =
operation using
> >         10 MHz channel spacings with data communications capabilities of
> >         3, 4.5, 6, 9, 12, 18, 24, and 27 Mb/s. The support of
> >         transmitting and receiving at data rates of 3, 6, and 12 Mb/s is
> >         mandatory when using 10 MHz channel spacing. The half-clocked
> >         operation doubles symbol times and clear channel assessment
> >         (CCA) times when using 10 MHz channel spacing. The regulatory
> >         requirements and information regarding use of this OFDM PHY are
> >         in Annex D and Annex E.
> >
> > IOW, it treats the rates as actually the rate they should be. Besides,
> > what's so hard about rounding up? (8.4.2.4)
> >
> >         and bits 6 to 0 are set to the data rate, if necessary rounded
> >         up to the next 500kb/s, in units of 500 kb/s.
> >
> >
> > I also think you really need to handle this. If you just want a hack for
> > 5/10 MHz, you can put it into drivers' debugfs, if not, then it should
> > be done properly :-)
>=20
> I think net80211 from FreeBSD and madwifi do this. Ie, they advertise
> the half and quarter rate speeds as their real speeds at half/quarter
> rate.

Ah, OK.

>=20
> If anything, interoperability would be nice.

Yes interoperability would be nice of course - I'll re-work the patchset
to use the according half and quarter rates. Meanwhile, what do you guys th=
ink
about enabling HT too?

Cheers,
	Simon
>=20
>=20
>=20
>=20
> Adrian

--PEIAKu/WMn1b1Hv9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlGMvrkACgkQrzg/fFk7axbuQgCcDH5MHrSCcjrBzOBwSMXHW0lg
l20An0KsCQhj5CX2zUODL7VUM33n2Ce0
=5muw
-----END PGP SIGNATURE-----

--PEIAKu/WMn1b1Hv9--
