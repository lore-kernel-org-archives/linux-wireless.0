Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:36522 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753856AbXHFIGx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Aug 2007 04:06:53 -0400
Subject: Re: further plan wrt. monitor interfaces
From: Johannes Berg <johannes@sipsolutions.net>
To: Daniel Drake <dsd@gentoo.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <46B3B2AD.1040509@gentoo.org>
References: <1186178959.13315.30.camel@johannes.berg>
	 <46B3B2AD.1040509@gentoo.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-aLe8HXnvWdsjU7zaDGb2"
Date: Sat, 04 Aug 2007 09:59:16 +0200
Message-Id: <1186214356.21957.13.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-aLe8HXnvWdsjU7zaDGb2
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-08-03 at 18:56 -0400, Daniel Drake wrote:

> As for the other problems mentioned in followup mails, how about=20
> something like the following:
>=20
> A new configure_device callback with these parameters:
>   - ieee80211_hw *hw
>   - int state: possible values NOCHANGE, ON, OFF
>   - int filter_flags: FIF_ flags from above
>   - u8 *mac_addr
>=20
> This would combine the ideas of add_interface, remove_interface and=20
> open/stop into one.

That isn't going to work as soon as you have multiple MAC addresses
which I'm told zd1211 supports. Didn't you or Uli just complain that
struct wiphy has only one address?

> state: this would become ON when the first interface is brought up, and=20
> would become OFF when the last interface is brought down. For all other=20
> calls into this function, state is NOCHANGE

Why NOCHANGE? The driver surely knows whether it's on or off so just
on/off should be enough.


> Also I was wanting to add communication from mac80211 to the driver=20
> about supported rates in the ESS (softmac does this, zd1211rw uses this=20
> info). This would also fall in the same category. And maybe we should=20
> add the multicast list above too.

Overload IMHO. Let's have a few calls. add/remove_interface are still
required because you still need the if_id to ask the stack for beacons
(IIRC); open/close (can we rename those to start/stop?) can be
well-defined with this instead of having ON/OFF/NOCHANGE flags (NOCHANGE
would just mean no start/stop callback).

Then we can have one call for filtering setup which includes multicast
and filter flags.

> I feel the above would make life fairly easy for drivers, or am I=20
> over-designing this? Perhaps I am also missing some considerations for=20
> IBSS/AP mode...

Yeah, for beacons you need to know about the interfaces that were added
to get the beacons.

johannes

--=-aLe8HXnvWdsjU7zaDGb2
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGtDHU/ETPhpq3jKURAkHtAJ9a49dWid+f2IHxQexHPsHPuQ0QLgCeLKn2
SDLD3qQFAoDYBzpeaYe+UGY=
=0Pwb
-----END PGP SIGNATURE-----

--=-aLe8HXnvWdsjU7zaDGb2--

