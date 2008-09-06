Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:45138 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150AbYIFS3B (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Sep 2008 14:29:01 -0400
Subject: Re: [PATCH] mac80211: make conf_tx non-atomic
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <200809061950.36213.IvDoorn@gmail.com> (sfid-20080906_195042_809464_85A467D1)
References: <1220717588.5376.0.camel@johannes.berg>
	 <200809061950.36213.IvDoorn@gmail.com>
	 (sfid-20080906_195042_809464_85A467D1)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-QL+Dv6V2t0RBz3XvKML8"
Date: Sat, 06 Sep 2008 20:28:54 +0200
Message-Id: <1220725734.10102.7.camel@johannes.berg> (sfid-20080906_202906_478792_DF7EA091)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-QL+Dv6V2t0RBz3XvKML8
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2008-09-06 at 19:50 +0200, Ivo van Doorn wrote:
> On Saturday 06 September 2008, Johannes Berg wrote:
> > The conf_tx callback currently needs to be atomic, this requirement
> > is just because it can be called from scanning. This rearranges it
> > slightly to only update while not scanning (which is fine, we'll be
> > getting beacons when associated) and thus removes the atomic
> > requirement.
>=20
> Oops. Ehm how many oopses were reported since I submitted patch:
> 	47909b24a7e6c67ad635f36f5312839e04c7617c
> 	rt2x00: Initialize txop during conf_tx() callback
>=20
> Because apparently that patch broke rt73usb (I completely overlooked
> the conf_tx() atomic requirements). :S

Heh, I don't know.

> Fortunately this patch would fix it again. :)

:)

> >  	/* Do not send changes to driver if we are scanning. This removes
> > -	 * requirement that driver's bss_info_changed function needs to be
> > -	 * atomic. */
> > +	 * requirement that a driver's bss_info_changed/conf_tx functions
> > +	 * need to be atomic.
> > +	 * This is really ugly code, we should rewrite scanning and make
> > +	 * all this more understandable for humans.
> > +	 */
>=20
> So bss_info_changed() is now non-atomic as well? Because that would be
> very useful for rt2x00. :)

Yeah, it's been for a while, in fact.

johannes

--=-QL+Dv6V2t0RBz3XvKML8
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIwsvjAAoJEKVg1VMiehFYTtUP/jHrL+kOnASVkgTy+aRXxnzD
Mn+u+1WeCIRV0agTzzU8DwvjYz6actKJaGbVhhB32z9Ngmz7Js5wm+cZ8xu6bUNg
xFmjUrrL/M5DcpAbeHi/cQ45QJQmGpOACVFvzQIoQsrBEbmro5/YHE6i5UaaTYHK
Hz4KlGn9t6SFsOg58jzd/azbRREQ3mbrLLCaUcJHZSM2NK8iJNEFg+3X86C1zibD
z5lO8QmynjdRHvZ3C6GsrwbcRI0wyt0IW4q5ttmjRJy252vLRTKiUQH17mLKNVEc
A5HrVDti07jr1PZetkcAazae7Qq5EmGmvqihX9q2FUMQ+AsrWwufiDd+llh8nz7s
KYrFXrIwX8mlXT/+WwOJ7tM6hlEdEFL+WRuup4e/CE8pLIu+QppRnTd4izTzRcxN
Wy9Q0N+qIG/nZ/MOQTtQ3WVazvgqx9CaJUh/j/r7HOQwpKyki7j+N7CcMExpGWh/
/of1d7d24Exu5rbWZ4r7AEceawG0HEgWSR9vY0QKL17rvuDCarWBVt7NHQs9949M
buntVoi5GI7v85iUkmuQ1raaaYjmPZz/+SWv/0n9KuMmBd76bWM32vxn2lQE8gdL
XQoTrW1ELf6jq1g8/tRfe0Ba2PxtKMesjI2bQ5Rt+2TAfkpvS5ZxxadceBRWarwb
Gz1eqvAefd2yusgjp6pX
=frAN
-----END PGP SIGNATURE-----

--=-QL+Dv6V2t0RBz3XvKML8--

