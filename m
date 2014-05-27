Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from top.free-electrons.com ([176.31.233.9]:41400 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752527AbaE0IKF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 May 2014 04:10:05 -0400
Date: Tue, 27 May 2014 10:09:52 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
	Chris Ball <chris@printf.net>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Arend van Spriel <arend@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Chen-Yu Tsai <wens@csie.org>,
	linux-arm-kernel@lists.infradead.org, linux-mmc@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	devicetree <devicetree@vger.kernel.org>,
	linux-sunxi@googlegroups.com
Subject: Re: [PATCH 03/11] pinctrl: sunxi: Move setting of mux to irq type
 from unmask to set_type
Message-ID: <20140527080952.GC4730@lukather> (sfid-20140527_101016_003315_F2DAE22F)
References: <1401090486-4414-1-git-send-email-hdegoede@redhat.com>
 <1401090486-4414-4-git-send-email-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="S1BNGpv0yoYahz37"
In-Reply-To: <1401090486-4414-4-git-send-email-hdegoede@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--S1BNGpv0yoYahz37
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 26, 2014 at 09:47:58AM +0200, Hans de Goede wrote:
> With level triggered interrupt mask / unmask will get called for each
> interrupt, doing the somewhat expensive mux setting on each unmask thus is
> not a good idea. Instead move it to the set_type callback, which is typic=
ally
> done only once for each irq.

*This* is the bad idea. Nothing prevents you from calling
gpio_get_value whenever you just got your interrupt, that will change
the muxing, and never change it back, effectively breaking the
interrupts.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--S1BNGpv0yoYahz37
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJThEhQAAoJEBx+YmzsjxAgQTsQAKrsWJdiXydTdHjUYOcljtO2
otV3vs/0qU2h/ZBUqUMcdlIIZAgLqR9VOeUhfmAuGOQQiJmHWludoHUm/a5Zjm4e
sMPoBkVTm/UWoE704HxVfs+sOY9VXRtArfCwFWYpLLhMC8LG3Q5buD3hFlRhKK5k
5gFSVuH+TJJoWbGQ4U94FjsBVOLUDTY71evz0q3NsehgDvi0KROJ/blG54ENlyK+
n43EBnihRwNXqZCQjykxJbFKa3iFBOThdC4SDo49pwzfxdUafReB18JzkCeBtRCL
2zBmpnv1f7rIihjn7R28KpbYPegdQlrOB5KICPKemtuvoZmachdFMnNIAgWsBW+K
36NtOahj88t8/iXd+PmP5Z48ubnQSAm7U0BOQemn/jpYrl49xbK19mb/YBG6WM0O
u+CN2ASpdObvVcUIfP5etPmie4+bjHQ1QWYTLd7XFIEYMFf0JtS7XLQCokVG4B29
GhKvOLq9hhbd6NIi0DW5SQJMwPCFqgYKjUlmQR21XSOPh/ckzdi6cmaJ8gOEOkoM
vzJtUyDq1iS900KsGzqS97/k1iOLmO9qjSpLxv8VOBfltaIx1bXBS+fWk24ViV1p
T7zJ/6vaITBDNxQm13+QmScQT7QMXZCPYP8ywllV0iimUQtFW6Y0D3YBuVbHJR44
OP5NihJyxyDI8pP1uxb2
=Bho2
-----END PGP SIGNATURE-----

--S1BNGpv0yoYahz37--
