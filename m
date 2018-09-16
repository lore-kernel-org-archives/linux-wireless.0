Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:36170 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727391AbeIPPEE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 16 Sep 2018 11:04:04 -0400
Date: Sun, 16 Sep 2018 11:41:42 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Randy Dunlap <rdunlap@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        linuxwifi@intel.com
Subject: Re: 4.19-rc[23] iwlwifi: BUG in swiotlb
Message-ID: <20180916094142.GB4299@amd> (sfid-20180916_114152_478312_DBBBCB2B)
References: <0c5e53e5-2afa-8d38-0b48-272c670c4bc5@infradead.org>
 <1536651177.3224.106.camel@sipsolutions.net>
 <20180916093414.GA4299@amd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="H1spWtNR+x+ondvy"
In-Reply-To: <20180916093414.GA4299@amd>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--H1spWtNR+x+ondvy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun 2018-09-16 11:34:14, Pavel Machek wrote:
> Hi!
>=20
> > > Any ideas?
> >=20
> > Hmm. Is this new?
> >=20
> > > 2018-09-10T18:47:54.532837-07:00 dragon kernel: [   31.472371] kernel=
 BUG at ../kernel/dma/swiotlb.c:521!
> >=20
> >         nslots =3D ALIGN(size, 1 << IO_TLB_SHIFT) >> IO_TLB_SHIFT;
> > 	[...]
> > 	BUG_ON(!nslots)
> >=20
> > > 2018-09-10T18:47:54.613655-07:00 dragon kernel: [   31.490325]  swiot=
lb_alloc+0x88/0x170
> > > 2018-09-10T18:47:54.613656-07:00 dragon kernel: [   31.490329]  ? __k=
malloc+0x1cc/0x200
> > > 2018-09-10T18:47:54.613657-07:00 dragon kernel: [   31.491652]  iwl_p=
cie_txq_alloc+0x1d4/0x3b0 [iwlwifi]
> >=20
> > There are two calls to dma_alloc_coherent() here, should those even hit
> > swiotlb? The sizes of those should be
> >  * 256 x 128 (32k)
> >  * 32 x 256 (8k) [TFH, unlikely to be the case here]
> >  * 256 x 256 (65k) [TFH]
> >  * 32 x 64 (2k)
> >  * 256 x 64 (16k)
> >=20
> >=20
> > IO_TLB_SHIFT is 11, so we get 2k alignment, so even the smallest size
> > (32*64) should result in nslots being 1?
> >=20
> > In fact, unless the driver passed *ZERO* as the size, this should never
> > happen (hence the BUG_ON), since ALIGN() would take care of rounding up
> > any smaller allocation here.
> >=20
> > Presumably you can reproduce this pretty easily (and I don't know what
> > specific model of NIC you have etc.), so perhaps you can do something
> > like this?
> >=20
> > https://p.sipsolutions.net/aa0dccd7a60fe176.txt
>=20
> That results in: ... if I'm not mistaken. Tested on top of today's
> mainline. (-rc3.95 :-)

Hold on. I was confused by my build system. Let me retry.

Are you sure you are not mistaking WARN and WARN_ON?



--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--H1spWtNR+x+ondvy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlueJVYACgkQMOfwapXb+vJVsQCgwkX5xKw+p1c++bK6RDCLBg5K
evsAoKw//SBMgpIVK2Qr5kGb1GhktA92
=wdVk
-----END PGP SIGNATURE-----

--H1spWtNR+x+ondvy--
