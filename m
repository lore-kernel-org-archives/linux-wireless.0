Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:50544 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752545AbXCDXwu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Mar 2007 18:52:50 -0500
Subject: Re: [patch] at76_usb wireless driver
From: Johannes Berg <johannes@sipsolutions.net>
To: Pavel Roskin <proski@gnu.org>
Cc: Guido Guenther <agx@sigxcpu.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20070304020920.b5lej3sw0oogwg4w@webmail.spamcop.net>
References: <20070110145724.GA4171@bogon.ms20.nix>
	 <20070223221230.GA9965@bogon.ms20.nix>
	 <20070303150029.GA19940@bogon.ms20.nix>
	 <1172934588.4966.46.camel@johannes.berg>
	 <1172939037.4966.97.camel@johannes.berg>
	 <20070304020920.b5lej3sw0oogwg4w@webmail.spamcop.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-3CwCtEHlzazTaAqGsRyY"
Date: Mon, 05 Mar 2007 00:52:23 +0100
Message-Id: <1173052343.6131.24.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-3CwCtEHlzazTaAqGsRyY
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2007-03-04 at 02:09 -0500, Pavel Roskin wrote:

> > PRIV_IOCTL_SET_MONITOR_MODE is wrong as far as I can tell, there's
> > "iwconfig ... mode monitor" which you should use instead. (Btw, why are
> > the priv ioctls spaced so strangely??)
>=20
> The code is quite old and may predate monitor mode.  Reference to Kismet =
means
> that the driver was meant to emulate an old unofficial patch to orinoco d=
river.
>=20
> On the other hand, the same setting selects whether to enable prism heade=
r, so
> that part should probably stay.

Wouldn't you just always have prism headers in monitor mode? All cards I
know do that iirc. Or well, radiotap seems to be the format of fashion
these days. I don't particularly like either :)

> > static u8 snapsig/rfc1042sig/bc_addr/off_addr/hw_rates/channel_frequenc=
y
> > etc etc etc don't belong into a header file.
>=20
> Absolutely!  But since it's mixed with definitions, perhaps the whole cod=
e could
> be merged into at76_usb.c.  It's not like any other driver will ever incl=
ude
> that header.  And adding 30k to 200k won't change much.

Yeah, still, it's pretty weird to find that in a header file. It should
be pretty easy to move it too ;)

> > Some other (mostly style) issues:
> >  * kernel code prefers a space before the brace in
> >    "struct at76c503_command{" et al.
> >  * both your header and code files contain lots of trailing whitespace
> >  * kernel code prefers no space between function names and the opening
> >    parenthesis
>=20
> I think Lindent (from scripts directory in Linux sources) should be run o=
n the
> driver.  Better yet, "Linudent --ignore-newlines).

Not sure. I find that it messes up some things too. Maybe run Lindent,
diff the original vs. the result and take the hunks you like.

> >  * don't use typedefs for structs
>=20
> All that code is prism header implementation from linux-wlan-ng, but I
> understand that it's a bad excuse.  Besides, one of the typedefs is not u=
sed.

Heh, I didn't really check if they were used.

> >  * the various frame definitions like struct ieee802_11_beacon_data are
> >    useless, the same stuff is in struct ieee80211_mgmt (at least on
> >    wireless dev kernel, that might not be true on other kernels?)
>=20
> Yes, this needs to be done, but it requires some work.  The names are dif=
ferent.

Yeah, it shouldn't take long either, just remove the definitions that
are there and fix the compile errors :P

> * istate should be accessed using atomic_set/atomic_read; locking is over=
kill

atomic operations can be quite expensive too, but you probably know
better if you need it or not.

johannes

--=-3CwCtEHlzazTaAqGsRyY
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBF61u2/ETPhpq3jKURAl/mAJ96M/qaA1mlXW5XIv15jZo3ynk+bACfSAS2
sznCIPzqcY4zeLi22i/g1zg=
=/5XT
-----END PGP SIGNATURE-----

--=-3CwCtEHlzazTaAqGsRyY--

