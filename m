Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:52197 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032Ab2LaIkg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Dec 2012 03:40:36 -0500
Date: Mon, 31 Dec 2012 09:40:27 +0100
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Adrian Chadd <adrian@freebsd.org>
Cc: Zefir Kurtisi <zefir.kurtisi@neratec.com>,
	Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	ath9k-devel@lists.ath9k.org, rodrigue@qca.qualcomm.com,
	nbd@openwrt.org, jonbither@gmail.com, kgiori@qca.qualcomm.com,
	mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: Re: [RFCv2] Add spectral scan support for Atheros AR92xx/AR93xx
Message-ID: <20121231084027.GA23038@pandem0nium> (sfid-20121231_094044_607298_132E431B)
References: <1354811768-4414-1-git-send-email-siwu@hrz.tu-chemnitz.de>
 <20121213140753.GA26868@pandem0nium>
 <50D04EC9.2040805@neratec.com>
 <CAJ-Vmom8FRrHB0ts1infzgWuXFJjkpvqkB2LyxdZFsP_Vq=4WA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UugvWAfsgieZRqgk"
In-Reply-To: <CAJ-Vmom8FRrHB0ts1infzgWuXFJjkpvqkB2LyxdZFsP_Vq=4WA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--UugvWAfsgieZRqgk
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Adrian,

On Sun, Dec 30, 2012 at 11:48:36PM -0800, Adrian Chadd wrote:
> Hi all,
>=20
> Simon - I've reviewed your code a bit.

Cool, thanks a lot! Since you are replying to v2, I hope you are
aware that I posted a v3 version[1] already?

[1] http://thread.gmane.org/gmane.linux.kernel.wireless.general/101735
>=20
> You're not (yet) shifting the magnitude values over as needed before
> trying to extract the channel power out of it all.
>=20
> Specifically:
>=20
> * each bin has a 7 bit value;
> * the bin value is scaled by max_exp;
> * there's a max magnitude value which I don't think you need for
> spectral FFT reports; only radar FFT reports (since in radar FFT
> reports, the reported FFT bins are between 0..7/8ths of the maximum
> magnitude value)
>=20
> You're not scaling the data by max_exp in your FFT dump program, so
> the values aren't entirely correct.
> Are you doing it in the kernel code?

In the latest patchset I'm doing scaling already in the kernel driver.
I haven't done this in the v2 patchset yet, something for scaling
was included in the then-corresponding FFT dump program. As I'm using
the new format now with the pre-processed and scaled dumps from the
kernel, this code has been removed in my FFT dump program. :)

>=20
> I've just finished my first pass at this and plotting whatever values
> I get from the spectral data frames. I'll post more updates as I
> find/fix more bugs.

Cool! What kind of tool do you use for plotting? Maybe we can use
something (my simple program, yours, whatever) for both Linux and
FreeBSD?=20

Thanks as always for the feedback!

Cheers,
	Simon

--UugvWAfsgieZRqgk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlDhT3sACgkQrzg/fFk7axalQwCfe+r0eWK+oMgirrOaPlj+8BVW
iDkAnRWXHJxrYmsiFE04MatYrj8ZXiyw
=ie49
-----END PGP SIGNATURE-----

--UugvWAfsgieZRqgk--
