Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36760 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751965AbZKJMIa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Nov 2009 07:08:30 -0500
Subject: Re: [RFC] cfg80211: survey report capability
From: Johannes Berg <johannes@sipsolutions.net>
To: Holger Schurig <holgerschurig@googlemail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <m3skcmhbkg.wl%holgerschurig@gmail.com>
References: <m3tyx2u2we.wl%holgerschurig@gmail.com>
	 <1257848249.7037.30.camel@johannes.local>
	 <m3skcmhbkg.wl%holgerschurig@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-KLhdMTACCSFPVDMOH+P6"
Date: Tue, 10 Nov 2009 13:08:03 +0100
Message-ID: <1257854883.7037.44.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-KLhdMTACCSFPVDMOH+P6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-11-10 at 12:19 +0100, Holger Schurig wrote:

> > > +enum survey_info_flags {
> > > +	SURVEY_INFO_CHANNEL =3D 1<<0,
> > > +	SURVEY_INFO_NOISE =3D 1<<1,
> >=20
> > A response w/o a channel seems entirely useless, shouldn't we just
> > require a channel?
>=20
> Hey, libertas could respond just the noise and no channel. But it
> could then also respond with the channel, it's there anyway.

But for the multi-channel use case, not having a channel will mean
userspace has no idea what the value means ... it's useless without a
channel I think.

> Controlling what should be returned should be done after either
> enhancing scan-trigger or writing a new survey-trigger command. So
> survey-dump would be very similar to scan-dump: return as much data as
> is available (and not stale).

Right.

> > Maybe that's useful functionality in addition to dump when you _can_
> > ask for information on a specific channel, but that'd have to pass
> > in the frequency from userspace.
>=20
> Would this then be useful for the scan-dump command as well?

Not sure .. would you want to get scan results for just a single
channel? But we can always add that later if we wanted to, I don't think
it makes a whole lot of sense for either of them.

> > Retrieving all data like you've implemented (though I guess you forgot
> > the multiple channels case) should be a dump.
>=20
> I did not forgot about the multi-channel case, I forgot about the
> nesting. /me's still learning nl80211 :-)

:)

johannes


--=-KLhdMTACCSFPVDMOH+P6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK+VefAAoJEODzc/N7+Qma064P/i1poZwx93v1Yo1sHq9llPr8
7rNxaYFo2k57MaHOCHtQ+BpI/QUjEfVg6J3p4IMaw96yE1OdByd5ffHcBUeBJkCp
M46MhACCu2s5wDtC5enIMVrgQldl+xRBGtPtMb2wDQpj/GUbC3w2AJFckrHBtTNg
7CkkJZ4sUFZQ8s1a66kgxK50XMQhTHApH4A9U8UxslE6K8sznR8VDXycE/UJAyE0
5kfwhPPHz/mFVxeRAAf0H8zieQ88tOniP7BwmhpBTEk4FfI/9e3mSwP4AgPEUUFp
Vy2gc9MPfJmT1ehyIogLgtU8rTohqrFdPRStsm+T4Ig55K4A4CysGzxDCIF+RmHv
XXYRhMYQCHXxWdq8vB8cOQ7SO4UDLdirkZ0b691uaF13C71LyNgWNPwfrIuPkLi6
Xdus1OK1HCxTlwAapmb2Sp2FqHYBri2JS/I5HCQVbbPfc2oO1y1ZVj4F3seDUrUq
K7w7XGHhLnid+Ke3rIdiLtymcid7oqODx1f8RQue/xoSwEjxnOyYRiRGq+TEqgbg
DwCkaVHPF23sXmI4Ug7rNQP3hUfMjjd8KgndEXf9waeDaG3+wm9fTB3+bNaBZlSI
0UlYKiJUEWbCR/788AKGAN4Iazex8kyUChBYk32fF2E33/eR68OmM0NI5Y+KWxxk
9XEweXBONUjQ0l85oESE
=hXXv
-----END PGP SIGNATURE-----

--=-KLhdMTACCSFPVDMOH+P6--

