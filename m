Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:33317 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932176AbbIUQUS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Sep 2015 12:20:18 -0400
Date: Mon, 21 Sep 2015 18:20:00 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <larry.finger@lwfinger.net>,
	Hauke Mehrtens <hauke@hauke-m.de>, b43-dev@lists.infradead.org
Subject: Re: [PATCH][RFC][RFT] ssb: pick PCMCIA host code support from b43
 driver
Message-ID: <20150921182000.6d89445d@wiggum> (sfid-20150921_182022_052980_18E878C4)
In-Reply-To: <1442826259-6270-1-git-send-email-zajec5@gmail.com>
References: <1442826259-6270-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/VnGe_fw.kjQfd4KQMQMar7k"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Sig_/VnGe_fw.kjQfd4KQMQMar7k
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, 21 Sep 2015 11:04:19 +0200
Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com> wrote:

> ssb bus can be found on various "host" devices like PCI/PCMCIA/SDIO.
> Every ssb bus contains cores AKA devices.
> The main idea is to have ssb driver scan/initialize bus and register
> ready-to-use cores. This way ssb drivers can operate on a single core
> mostly ignoring underlaying details.
>=20
> For some reason PCMCIA support was split between ssb and b43. We got
> PCMCIA host device probing in b43, then bus scanning in ssb and then
> wireless core probing back in b43. The truth is it's very unlikely we
> will ever see PCMCIA ssb device with no 802.11 core but I still don't
> see any advantage of the current architecture.

The idea basically was that b43 is the only user of that code. So the
code was put there.

> With proposed change we get the same functionality with a simpler
> architecture, less Kconfig symbols, one killed EXPORT and hopefully
> cleaner b43. Since b43 supports both: ssb & bcma I prefer to keep ssb
> specific code in ssb driver.

I agree that this makes the architecture a bit cleaner. So this
basically looks good. I currently can't test it, because I don't have
that device here right now. In two weeks or so I'll probably be able to
test it, though.


> @@ -1464,6 +1463,12 @@ static int __init ssb_modinit(void)
>  		/* don't fail SSB init because of this */
>  		err =3D 0;
>  	}
> +	err =3D ssb_host_pcmcia_init();
> +	if (err) {
> +		ssb_err("PCMCIA host initialization failed\n");
> +		/* don't fail SSB init because of this */

Why not? What's the point of not failing here?

> +		err =3D 0;
> +	}


> +static const struct pcmcia_device_id ssb_host_pcmcia_tbl[] =3D {
> +	PCMCIA_DEVICE_MANF_CARD(0x2D0, 0x448),
> +	PCMCIA_DEVICE_MANF_CARD(0x2D0, 0x476),
> +	PCMCIA_DEVICE_NULL,
> +};

This doesn't belong into ssb'c pcmcia.c, IMO.
It should be in a new file called b43_pcmcia_bridge.c, just like we have
b43_pci_bridge.c.
The bridge code technically (also for pci) doesn't belong into ssb. But
it makes kconfig simpler.

--=20
Michael

--Sig_/VnGe_fw.kjQfd4KQMQMar7k
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWAC4wAAoJEPUyvh2QjYsOdy0P/1yX2XbfjK5PcFP6f+IELMUf
uJvuSguiNdrKBuuUW1GJMmEOw3hfq3R6iFeBAIlwW5r4DOHfMP/qoRa0URZXlfbe
D0bPJoS6vIXUzP3u+JtEQxAyBT5sNnUOO0akU+8b3c0O6/oFxwjD3dH9s04fKhPy
Pma+HqbiC5NwZxzn1LvGSaWDXNRBrFwCOWGY41TFENFPPeH5VXHT4QVOwsJo5rBD
nDDepTp86K8V5dMnANxy41vfR/VHdDCb44SrjZKu2x55F4lKuz4mTvErZub3z+G3
sGDatWYicXypiL4WgAz66P2qkMX1q4M2wMeh+d9IxRdz6M+Cxcva9ixdc6CdfRgs
0PVczr1UH3C6JOXntjFRubHIj9bttpjv13LVf7ZJOl5MSy6ZifsC/EZ8G+H+78nq
BZtUsnGKWCl9CgvrdWW6KuZITdgiEz7H5qSHat+rcXdaXLf8LlVsjnNdDIuw8ku+
uDIZBxFeNxYnhrxmOWXB4cgvvlMzXe34dPL+Uvc7+zs0vUvx5cVdrBkPDotSuZuJ
JY5rAyJMH+ic2syZ4/ozfPIDBzmbcONGtFR96m65NizMTseezz7klS6ss6ZWqsp+
rx1z2FLduZe0uSqYHywPTJ3i8/3CzOC/Gwi3i3dtJ5WL9b+UnOWkEV05uHnj9NiA
xZxwck9/L+oPw+/uR49t
=WJbl
-----END PGP SIGNATURE-----

--Sig_/VnGe_fw.kjQfd4KQMQMar7k--
