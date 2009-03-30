Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:43092 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752969AbZC3Uww (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2009 16:52:52 -0400
Subject: Re: [RFC] rfkill: rewrite
From: Johannes Berg <johannes@sipsolutions.net>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Inaky Perez-Gonzalez <inaky@linux.intel.com>,
	Dirk Opfer <Dirk@Opfer-Online.de>,
	Matthew Garrett <mjg@redhat.com>
In-Reply-To: <20090330204800.GC23749@khazad-dum.debian.net>
References: <1238349195.24972.5.camel@johannes.local>
	 <1238406057.24972.23.camel@johannes.local>
	 <20090330132911.GC11934@khazad-dum.debian.net>
	 <1238422114.5970.6.camel@johannes.local>
	 <20090330173421.GB23749@khazad-dum.debian.net>
	 <1238434878.5970.17.camel@johannes.local>
	 <20090330204800.GC23749@khazad-dum.debian.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-3Fw+PFoSGF3Vej3E62w/"
Date: Mon, 30 Mar 2009 22:52:18 +0200
Message-Id: <1238446338.5970.41.camel@johannes.local> (sfid-20090330_225253_897881_7A2ECAB5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-3Fw+PFoSGF3Vej3E62w/
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-03-30 at 17:48 -0300, Henrique de Moraes Holschuh wrote:

> Yes, thinkpad-acpi wants it.  It uses that to make sure the bluethooth
> and wwan rfkill _global_ state is kept across machine shutdown and
> reboots (I can't do that for UWB because Lenovo didn't add persistence
> for UWB for some reason).

Yeah, I've added it back already :)

> 1.  thinkpad-acpi loads
>     1a. reads radio states from firmware, and stores to rfkill core
>         default state for the specific radio type
>     1b. registers the rfkill switch.  The core will cause the just
>         registered rfkill switch state to be changed to match the
>         current global state for that switch type... which probably
>         is what thinkpad-acpi tried to set in 1a.

Yeah -- I need to add back 1b; I removed it for now because it goes like
this:

	driver - rfkill_register
	  rfkill - rfkill_register
	    rfkill - set radio
	      driver - set radio      <--- deadlock if this needs lock

This I need to schedule that away.

> > state should be set for the devices it applies to, but it seems that if
> > the master rfkill switch is set to "transmitter off" then one needs to
> > set the default state (for all USB transmitters etc) to off, correct?
>=20
> Well, the default is applied to a _type_, so it is valid for all
> switches of that type.

Right.

> It is probably a good idea to have the rfkill core sanitize the
> attempt to set the default state, and force it to "block" if EPO is
> active (I don't recall if I checked for this failure mode in the old
> code).

No, but it rejects any calls to set the default state when any rfkill
struct has been registered already. So this isn't a concern.

johannes

--=-3Fw+PFoSGF3Vej3E62w/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ0TEAAAoJEKVg1VMiehFYEG8P/jrskeOAnf++GY/VWiygv6sq
qtUn9wSwZaRs6nNL2nAPRdzExwO15K2ihdZKfHD06bj30746RikBFmH2IhGBMT3y
i5MRNukiT7xxEhYwKMn1do1A0sWK5HGOAYvM+2t5h6pRvxJ7UNAj/ni6GQWsex9z
PBskB5kUChEkxGr5X0ZSeJ3BQ3zQHroanGet7b5ji9Cnjx24x7s4hLHoe555eVSa
/nzFx45CnVJOYbtHHdhllOz2MIlJu5K7grBb02EGVNppjatJ837h9l2j1RW91haL
iW/R7jFMFComwDG0z05pYH3v1c9cPzKUM1+Euqfrl/NEJ5MbDINR8Nl2cf+KR1hj
5PPxXU5TQ3zZyAFqiykIcxMCL/bh4nTxzs9gXcwJYLW6SIG/yjZFGD2RGieqio46
yohJX9vQD+fOGmHd4tITZCRvt+lTfKuDWeRF+fuIz/PY2DrZVF95cmSxZCQgjv2t
TnHmfR2nxrgUZtknyDxiJ0fb8JKuR85NRHGpZxXiS1mi5DPCmJ15MpD73cvBfTTp
t8vbrxcPYu6EflzmW7//IXI4KyemySuleyFQXYmP0NtKaWaleB4houqJcYpkavQn
kiJrkKA8HtleE4FoYHlsN5ftBZDI6248TXUcwEEwr2H3oS1o8uCrUyNJOC7UxmQ7
z3zr3qC19hLoNsvNY0n3
=JbAq
-----END PGP SIGNATURE-----

--=-3Fw+PFoSGF3Vej3E62w/--

