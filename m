Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42852 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753144AbYJFQsZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Oct 2008 12:48:25 -0400
Subject: Re: [PATCH v2] iwlwifi: fix DMA code and bugs
From: Johannes Berg <johannes@sipsolutions.net>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Tomas Winkler <tomasw@gmail.com>
In-Reply-To: <1223311359.11272.212.camel@violet.holtmann.net>
References: <1223308831.15196.28.camel@johannes.berg>
	 (sfid-20081006_180110_939098_1A64839A)  <1223309405.15196.32.camel@johannes.berg>
	 <1223311359.11272.212.camel@violet.holtmann.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-bAHkuy9F5p2NRKFkViIn"
Date: Mon, 06 Oct 2008 18:47:54 +0200
Message-Id: <1223311674.15196.34.camel@johannes.berg> (sfid-20081006_184828_650590_B23D7805)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-bAHkuy9F5p2NRKFkViIn
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-10-06 at 18:42 +0200, Marcel Holtmann wrote:
> Hi John,
>=20
> > This patch cleans up the DMA code to be understandable and not
> > completely wrong. In particular:
> >  * there is no need to have a weird iwl_tfd_frame_data struct that is
> >    used 10 times, just use an address struct 20 times
> >  * therefore, all the is_odd junk goes away
> >  * fix a bug in iwl_hcmd_queue_reclaim where it would reclaim all the
> >    fragments of a descriptor rather than all descriptors (this may be
> >    the cause of the dma unmapping problem I reported)
> >  * some more cleanups
> >=20
> > Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> > ---
> > Tested on 5000 hw, please apply.
> >=20
> > v2: fixes small issue with getting rid of iwl_get_dma_hi_address.
>=20
> if this fixes the crashes with my 4965 card in my X61, then this is a
> candidate for 2.6.27-rc8. I will built a new kernel for my X61 as soon
> as possible.

I doubt it will, but who knows. Let me know. Right now I'm trying to
massage  the code into something readable.

johannes

--=-bAHkuy9F5p2NRKFkViIn
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI6kE2AAoJEKVg1VMiehFYsOYP/1utQxmf0CqaK9r/qeqwp3/h
vTYNGl+nqJtSkbG1+e9E77GBtu07CESWp4C8YGxNUl3Pn6UJCZiuyMoU7FQL6WPh
hrALfhx0ixKQmzQLreGckbqeB2Pa55n7H8qD1vMBYZX8Gu/fmJruFtz8+IjMwqEf
psx91vVfE5OdUhladyXsUpllfjbanHOV8Y83kFy7VvhJDb6IcnBm/NCwUDa4oHZ3
UETFHVQZi9W3a8XY7urafoZY+LLPYebZioHS4xXczMSMW/vv91dlTaSNBH5s/U7I
NLuNSc0585+oSLP6ENHTBw7AHypFQt4giVBX71yDp8SmA25KXHDAo/+nDtIg+HCQ
6DFXUOq8fvfS0WY6P0l0Xsfzft/1YlMHJKKhruBshU0kuOX3yjSSWPMDZqeOw5Fh
hN4tMqWbgAe9nlNrXbqPKCiRW88TIgGFBqA2LA7TJHXHVk17vgRCBcZ1rK6liJHj
O2WJYR3ExWvC3wqP9/boZVnvQpZMZEUFjM0tfMn1mhX9ruZvx5SBMm8FMTGHr+cR
K7pUfn18g9tEoQi7JMtQd5szXEDEFD3Fwihd4BhJdr+aQ3/upVD9UNJHdOdeMJ2l
kOys3hviXUFdRSKnwkXmAPM83YvicJMQqEaTw9LJE4fymCokia0y6qE0jfkApTxt
h1YpezY6yLQRW8KISbr0
=LUkj
-----END PGP SIGNATURE-----

--=-bAHkuy9F5p2NRKFkViIn--

