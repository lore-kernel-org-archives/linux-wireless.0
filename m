Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:51551 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751021AbXIMHKg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Sep 2007 03:10:36 -0400
Subject: Re: iwlist and network-manager bug report
From: Johannes Berg <johannes@sipsolutions.net>
To: jt@hpl.hp.com
Cc: Dan Williams <dcbw@redhat.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20070912170153.GA25785@bougret.hpl.hp.com>
References: <1189526874.6161.30.camel@johannes.berg>
	 <1189610572.5644.28.camel@xo-3E-67-34.localdomain>
	 <20070912170153.GA25785@bougret.hpl.hp.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-6aiyTQWDtXMvBMuEfNRE"
Date: Thu, 13 Sep 2007 09:11:36 +0200
Message-Id: <1189667496.6161.77.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-6aiyTQWDtXMvBMuEfNRE
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Let me reply to both of your mails at once.

> > [Dan]
> > NM 0.6.x and earlier (quite wrongly) treat the SSID as a string.  That
> > has been fixed in 0.7 trunk, though we do need to make sure that NM
> > 0.6.x and earlier don't puke with it.

Ok. I'll have to do some more extensive tests but in my last test with
zd1211 it wouldn't display anything. Might be a different issue, but
scanning manually showed things.

> > SSID conversion is really, really tricky, and NM tries a few things to
> > coerce the SSID to UTF-8, including trying your LANG encoding if it
> > exists.  None of these methods work reliably though.

Especially since I have UTF-8 LANG and this is some windows foo.

> [Jean]
> 	I personally can't see how we could figure out the encoding,
> because we are talking of other's people network. It would have been
> nice for IEEE 802.11 to specify something, but it's now probably too
> late, as each vendor did his own stuff.

Yeah, I don't think they cared for non-ascii at the time.

> 	Where it's get even weirder is that special characters don't
> seem to be forbidden either, such as NUL, and all the control
> character. There is no way we are going to print them properly.

True.

> 	Up to now, it never had been an issue. I made sure it would be
> possible to implement a more clever ESSID display routine, but never
> did it. It's not terribly complex to implement, but we need to decide
> how we do it.

Yeah.

> 	Note that ideally, we should also do the same with regards to
> setting an ESSID. And all the /proc files of the various drivers may
> want to be sanitized (yuck).

I thought it all went through some common code?

> > > [Johannes]
> > > and nothing more (the SSID is B\xFC...). wpa_supplicant converts it t=
o
> > > an underscore in its output (B_...),
>=20
> 	That would not be my prefered solution.

No, especially since it's ambiguous if you want to use the SSID later.

> 	One way would be to check if the ESSID is Ascii, and if it's
> not, display it entirely in hex with a leading 0x. Then, iwconfig
> would recognise the leading 0x and do the right stuff.
> 	The problem with escaping is that you always have to escape
> the escape sequence, otherwise you get ambiguity.

Yeah, that's the thing. I don't like displaying it entirely in hex just
because a single character is not ascii though. I think we should
display as much in ascii as possible. Maybe a regular \xAA conversion
would be appropriate as having a backslash in an SSID is probably less
common than using Umlauts or even Chinese.

johannes

--=-6aiyTQWDtXMvBMuEfNRE
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG6OKo/ETPhpq3jKURApNyAJ4gj1Ns7TaWRleOMZwtBP77U0+EXwCdER0G
TlHg1hdWueeG2p0w0ltBNq0=
=i+15
-----END PGP SIGNATURE-----

--=-6aiyTQWDtXMvBMuEfNRE--

