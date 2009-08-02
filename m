Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58373 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149AbZHBHza (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Aug 2009 03:55:30 -0400
Subject: Re: [PATCH 1/2] input: Add KEY_RFKILL_ALL
From: Johannes Berg <johannes@sipsolutions.net>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Marcel Holtmann <marcel@holtmann.org>, linux-input@vger.kernel.org,
	linux-wireless@vger.kernel.org, dmitry.torokhov@gmail.com
In-Reply-To: <20090801222537.GA24262@srcf.ucam.org>
References: <1249152859-14769-1-git-send-email-mjg@redhat.com>
	 <1249159133.3491.13.camel@localhost.localdomain>
	 <20090801204534.GA23642@srcf.ucam.org>
	 <1249159942.3491.21.camel@localhost.localdomain>
	 <20090801205445.GA23751@srcf.ucam.org>
	 <1249163327.3491.24.camel@localhost.localdomain>
	 <20090801215130.GA24201@srcf.ucam.org>
	 <1249164685.3491.28.camel@localhost.localdomain>
	 <20090801222537.GA24262@srcf.ucam.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-alDXr3y+oR/B3u2AOlO+"
Date: Sun, 02 Aug 2009 09:55:26 +0200
Message-Id: <1249199726.2007.12.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-alDXr3y+oR/B3u2AOlO+
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-08-01 at 23:25 +0100, Matthew Garrett wrote:
> On Sat, Aug 01, 2009 at 03:11:25PM -0700, Marcel Holtmann wrote:
>=20
> > and that is what it should NOT imply. The policy if it applies to all
> > internal devices, all devices in general or just WiFi or Bluetooth for
> > example is up to the user.
> >=20
> > We are NOT going to have any kind of RFKILL policy in the kernel in the
> > future. We will remove rfkill-input once we have a proper userspace
> > solution (aka rfkilld or similar).
>=20
> We seem to be talking at cross purposes here. My objection to the name=20
> KEY_RFKILL is that it gives no indication what it's meant to be or why=20
> it's different to KEY_WLAN. KEY_RFKILL implies that it's the only input=20
> component that an rfkill policy agent needs to listen to, which isn't=20
> the case.

Heh, yeah, I can kinda agree with both of you.

We really should've named KEY_WLAN KEY_RFKILL_WLAN instead, etc, and
then both versions would be less ambiguous.

AFAIU, Marcel's argument is that policy might not be "ALL", but cycling
through technology combinations, and your (Matthew's) argument is that
just naming it without the _ALL would imply that KEY_WLAN could be
related to something other than rfkill.

Can we name it KEY_RFKILL, and add a comment to the header file about
what it is? I.e. a "technology-independent RF toggle button" or so?

johannes

--=-alDXr3y+oR/B3u2AOlO+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKdUZrAAoJEODzc/N7+Qma+D0QAMHsVG+1tkHfWLquoyPoae+1
rnSJR7J3qm7AuS/Ur6DiIKKcrJctUKONUzuwMEYirPow3pGteMj2naY8z+FICcY5
ji0EbHZ6ZArjuF8NATFf+36ntWq7ARJ1Qe/e2BTJie69VXm9RM1eKJ9s33I1MTbp
pCjjcUGfKdZPo3KTThDZm2mJni7fvWLVXS7QcUp2W4pnShC7cToVhqZ6mhYVQQ64
kKHtGnNnb5x0x+tRgbJ873CWfse/ZjxUD6053QtPwvTsvdiXXIfddVCf15onCKFW
6wXMEsP3SeFyfKAvAigjSDLqVjddXANvlkJTu6x/Lks9oSW7etRkBpXX3Mz4kybH
EQ/YPsvWZ5djgTNXtgjJ8zlmn9IrDTyhcrcaE5Vw4j4Gv4QJvW1NrsReQOmV72UX
pj1j+5V/UC6If54CnK04nEFI7jeBwj751quYnLQztryZxl+uG861CUpc1dt7sT8N
X+mv6TmqgVN9RgMQmRll7lv9qEQE+ntMCD69K96d7Y7L16NBRKxkEc8SCguAAvvs
sjlox+BbOpx6/pjHZnIIGbBDsAOdWdeLwb/ZYpMbchxY65m+oY00ilOuR7uncQj5
zwpuAsi1iuc8WLQAP9M33mcgwHlHB1nV4PZn6bWC75oC3e+zCyer0jeebJG6pjSV
QuCMt6Y54xs8I0M86RpR
=iU6E
-----END PGP SIGNATURE-----

--=-alDXr3y+oR/B3u2AOlO+--

