Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:48841 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753709AbZDGM7e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Apr 2009 08:59:34 -0400
Subject: Re: [RFC] rfkill: rewrite
From: Johannes Berg <johannes@sipsolutions.net>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Inaky Perez-Gonzalez <inaky@linux.intel.com>,
	Dirk Opfer <Dirk@Opfer-Online.de>, toshiba_acpi@memebeam.org,
	Matthew Garrett <mjg@redhat.com>
In-Reply-To: <20090405145941.GA24963@khazad-dum.debian.net>
References: <1238349195.24972.5.camel@johannes.local>
	 <20090330211513.GF23749@khazad-dum.debian.net>
	 <20090405145941.GA24963@khazad-dum.debian.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-NTjWSA73u8EWCgg0UQ7A"
Date: Tue, 07 Apr 2009 12:36:19 +0200
Message-Id: <1239100579.22453.38.camel@johannes.local> (sfid-20090407_145938_173268_1B1E244D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-NTjWSA73u8EWCgg0UQ7A
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi!

> > > +struct rfkill_ops {
> > > +#if defined(CONFIG_RFKILL) || defined(CONFIG_RFKILL_MODULE)
> > > +	bool (*poll_hw_block)(void *data);
> > > +	bool (*query_state)(void *data);
> > > +	void (*set_block)(void *data, bool blocked);
> > >  #endif
> >=20
> > Missing error handling on set_block...  could you change that to:
>=20
> And also on the rest of the hooks.  I should have noticed it sooner!
>=20
> As I said, ACPI platform drivers _do_ get errors when calling the ACPI
> functions, or trying to do an EC transaction.  That applies to reads
> just as well as it applies to writes.

And it also doesn't really matter. Yes, the current poll API isn't
prepared to treat errors, but see below for a suggestion.

> I.e. I can get AE_BUSY or something else while querying the thinkpad
> firmware, and then, what should I do to return the data on the
> query_state (and, for that matter, poll_hw_block) hooks?
>=20
> Since there can be a clear error path from userspace to the rfkill
> driver for reads and writes in many situations (e.g. on all sysfs
> accesses to that driver's rfkill struct), this would be a good reason to
> change the hooks to allow for that error path.

Totally bogus argument -- 99.9% of users will be using rfkill's input
handler which has no way of reacting to errors, and neither does
userspace. And it's wrong too -- the sysfs files don't actually call
into rfkill, they just report the current status.

> Without that, I'd have, for example, to return false (unblocked) on any
> errors from thinkpad-acpi, for safety reasons (a blocked radio is never
> a hazard, but an unblocked one can be).  This is the kind of stuff that
> a driver shouldn't need to decide by itself...

Eh? Your first half sentence is correct (up to "on any errors"), the
rest is garbage. Yes, you'd have to return false so that the core
assumes it can do something, but no, it has nothing to do with hazards.

> On a related note, it was not clear to me from looking only at
> rfkill.txt and the linux/rfkill.h headers, how am I supposed to deal
> with the software controlled component of the rfkill controller (the
> hardware rfkill line is quite obvious, though).  I know there is a way,
> but I haven't finished reading the core code to know which one, and the
> docs didn't help, so they need an extra paragraph somewhere...

There's a function for that -- but no poll yet.

> Anyway, I suggest changing the hook protypes to this (which does _NOT_
> change the fact that you now track hw and sw separately in the core, but
> lets the rfkill driver deliver both in a single call if it needs to):
>=20
> int (*poll_block_state)(void *data,
> 			 bool *is_sw_block_active,
> 			 bool *is_hw_block_active);
> int (*query_block_state)(void *data,=20
> 			 bool *is_sw_block_active,
> 			 bool *is_hw_block_active);
> int (*set_block_state)(void *data, bool do_sw_block);

No way.

I can be convinced to change the prototype of poll_hw_block to

	void (*poll_hw_block)(void *data, bool *blocked);

so that drivers can say
	"*shrug*, I dunno right now, keep whatever I told you last".
Returning an error, however, is completely pointless.

> The core should ignore the is_* stuff if an error status is returned,
> as a defensive approach against driver bugs: doing it that way is less
> programmer-error-prone than telling people to not touch is_* in case of
> an error.

Bugs happen, and can be fixed; your defensive programming mantra just
makes for messy code that has multiple ways of working "correctly". I
quite obviously disagree -- if you can't read the status don't touch the
variables.

> BTW: it is probably a good idea to document what the driver should do if
> the core tries this on a radio that is hardware blocked, or if the
> driver discovers the radio is hardware blocked the instant it tries to
> software unblock it...

The first case doesn't happen... And it says so in the header file:

 * @set_block: turn the transmitter on (blocked =3D=3D false) or off
 *      (blocked =3D=3D true) -- this is called only while the transmitter
 *      is not hard-blocked. This must be assigned.

The second case _shouldn't_ happen (but can, due to race conditions);
Then you just call set_hw_state before returning.

The third case, which you forgot, works the same as the second and needs
no extra code either.

> It would be nice to have the core export a way to "force" both sw and hw
> states at once, as well.  This lets the core optimize the issuing of
> events and other internal changes and avoids bad mojo if the driver does
> sw/hw force calls in the wrong order (which might cause a unblock-block
> fast sequence, etc).
>=20
> This would let drivers that have the worst case software blocking (it
> exists, hw blocking also exists and is separate, and both sw and hw
> blocking state could change behind the driver's back) work well, without
> causing any extra complexity to the other drivers.

There may be some value in that, do you need polling for both though?
Otherwise you'd need
	if (hw_blocked)
		set_hw_state(hw_blocked)
		set_sw_state(sw_blocked)
	else
		set_sw_state(sw_blocked)
		set_hw_state(hw_blocked)

in the driver which I agree isn't nice and would be better with a
combined function.

> IF you don't want the hooks to return both sw and hw states, you can
> just change the return type from bool to int, and explicitly document
> tha the return status is:
>=20
> status < 0: error
> status =3D 0: false, implies no error
> status > 0: true, implies no error

Ick.


If you really do need polling for the sw state as well as the hw state,
I can be convinced to change poll_hw_block to

	void (*poll_block)(void *data, bool *hw_blocked, bool *sw_blocked);
=09
You need much better reasons, however, to convince me to add any error
return, I see absolutely no value in that. Neither rfkill's input
handler nor the polling nor userspace has any means to react to errors.

johannes

--=-NTjWSA73u8EWCgg0UQ7A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ2yygAAoJEKVg1VMiehFYKRsP/1YeCa+wiYyiFecppoMGu5W9
8Yba2BiHf1dUrvt4WNcyGvjpzkbqYvwPfKMzRjUAua5RMPMuZ/sdNHldmkiR86Cb
YMlbe7OZ7I3wFpVTjulBn/WNr3NnJK97iTNmh//md3G+/M/OO/oerldoF2p6ybjP
aAFCzJcTZ5TBLJjdnH7c/5QhfNcZ8zfNyIA0FKvdVsjGzHPS9miouNAXdYWZx0y9
86Qi4t2XZIMx0iOWfTwbS+SQKiN0oqUPyMfPrtWp9rZlI2s8/kfA2BimOQL6KjGX
jkWEjMxwyacQcNpzfcuVdHgwL5BOozm3wKTpjSNoZ4tXqUbvSc5DczcWhU8mUEb1
FeMy5Yv/JlWaw0TGR/E9075d3waAx9CIy85b6oQUllS8HP3BpHYTnftB2tGYoWFZ
jqPQpgoYjzdmaUrSl6z7gh/iAYlVz6tRbrTkjHeYhVw9OVmsg6xI9HJrNW049RYH
wDrfIXBALdAUBeS5mt2G2d78B8Yb/MKtvuoSTQeBNJEVqnx8BmlpA2EvxfNt5ALe
8pIxQRinxRMv6gbu2qkKXILXVLlV2sHK07LVBq9xGJglbiy8KNF+jue4vCIuU6d4
8MdJODvBIoy4ObWldUnLFGkdIvoZ3D7LSDzG+bM2h1wh/gwLMgZtCZ5TlSvQzP3S
D8Xi4e15Xp1jkoxqM9BD
=izGj
-----END PGP SIGNATURE-----

--=-NTjWSA73u8EWCgg0UQ7A--

