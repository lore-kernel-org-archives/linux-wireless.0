Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:48254 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244AbYJFRVb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Oct 2008 13:21:31 -0400
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
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-CyeN2tKF10DcqW8JDTyr"
Date: Mon, 06 Oct 2008 19:20:19 +0200
Message-Id: <1223313619.3778.0.camel@johannes.berg> (sfid-20081006_192134_467285_92EA3D81)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-CyeN2tKF10DcqW8JDTyr
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

I just tried, it certainly doesn't stop the thing from corrupting my
memory all over when I have 64k pages turned on.

johannes

--=-CyeN2tKF10DcqW8JDTyr
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI6kjPAAoJEKVg1VMiehFYtfcQAK4q+/aBbVSCFE3DCkXHRaau
RRDeOyBHXI3ruDJVR7MJgrpiLoPXqeOuQsJ6MYv9g0SyhQ5Lnq18RV/coFKy6DHG
fm4HEueHo/j4V5SKTvEK2MGXfkM9d5eup1RBAdGBq58gDfJnteCAanhseCmzzPez
lAhu2rrw3zU8GWZ1fEpC9vPv+OqCkhDTYmb1RYxR5HhZbWB18u9D/8IUgZkp1hcj
/ca9yDuaiuBkakEfhQoLKNmqL+WkmbGaQDz5x46Tl+W5AelMP5u2CQ3s1g5ntlOY
XnyygDLDB/eMqC61GS5BCnWItneF05lH9eLLfF/7BIXgZM8x60qi7jt3xMqUBHeU
yyOsq/fDTEBHM7ODuxu4gQ9LQhKJtUwziWdp33kZfIy1QxtnIXlWNky1/cLI26bZ
jW28tEvpFtiyKlsgqNu8PfUVL6u1pT/esd10HIsOeJqXT9YbEXERZR4HO5om8cCO
y0Pul06hUsX3GWvarPEb/LhFPDjk5/EaR/5Yb/8d3rmc7vMlio/p7ebB9jz51QsM
QUo9kmEEv1WGfbdJVGbhtnPZL/TjUd6AFEpJ+6d7+B1TiIFoT5X0NADYdh8cuPj6
EVTAxGEfzra24aZ+IOjG/yZlCwkm3hq2SSb1H8jwIPEuto7VLAieee77zZoNWFH2
UZ2myHEKh41GvoRueRrt
=nhBS
-----END PGP SIGNATURE-----

--=-CyeN2tKF10DcqW8JDTyr--

