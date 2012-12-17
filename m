Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:46539 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752125Ab2LQNWo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Dec 2012 08:22:44 -0500
Date: Mon, 17 Dec 2012 14:22:32 +0100
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Adrian Chadd <adrian@freebsd.org>
Cc: Felix Fietkau <nbd@openwrt.org>,
	Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	johannes@sipsolutions.net, ath9k-devel@lists.ath9k.org,
	rodrigue@qca.qualcomm.com, zefir.kurtisi@neratec.com,
	jonbither@gmail.com, jouni@qca.qualcomm.com,
	kgiori@qca.qualcomm.com, mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: Re: [RFCv2] Add spectral scan support for Atheros AR92xx/AR93xx
Message-ID: <20121217132232.GA447@pandem0nium> (sfid-20121217_142247_944934_46E27AF6)
References: <1354811768-4414-1-git-send-email-siwu@hrz.tu-chemnitz.de>
 <20121213140753.GA26868@pandem0nium>
 <50CA0F8B.3060905@openwrt.org>
 <20121213220651.GA30855@pandem0nium>
 <50CA5EE9.30606@openwrt.org>
 <CAJ-VmokcJUBZeOAyjaNefqgtEkdjGFhH3NQEXA38Xe_i2M+wYA@mail.gmail.com>
 <CAJ-Vmo=qWihSMZ3Jwb9NGU_uXSGYd-Nxya+oT0MQdoT6r0JZFw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DocE+STaALJfprDB"
In-Reply-To: <CAJ-Vmo=qWihSMZ3Jwb9NGU_uXSGYd-Nxya+oT0MQdoT6r0JZFw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--DocE+STaALJfprDB
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Adrian,

thank you for posting this and the explanation!

On Sat, Dec 15, 2012 at 08:06:47PM -0800, Adrian Chadd wrote:
> The formats are as follows. Please note that if a pulse terminates
> during an FFT, the final entry may be truncated. So yes, you may not
> always get an integer multiple of the relevant frame length.

OK - my data is mostly in the range of 55-58 bytes (see below), sometimes
I got some longer packets, but I'm currently dropping them.=20
The variation still puzzles me though.

>=20
> Note that you shift each of the readings by max_exp to get a total
> reading. max_index and max_magnitude I think are just derived from the
> existing dataset; they're just a shortcut for software so it doesn't
> have to parse the whole frame looking for the peak.

Ah ok, that makes sense. Thanks for the clarification. :)
>=20
> Static 20 mode:
>=20
> 0  bin -28 magnitude[7:0] =3D (|i| + |q|) >> max_exp
> 1  bin -27 magnitude[7:0] =3D (|i| + |q|) >> max_exp
> 2 - 53  =E2=80=A6
> 54  bin  26 magnitude[7:0] =3D (|i| + |q|) >> max_exp
> 55  bin  27 magnitude[7:0] =3D (|i| + |q|) >> max_exp

I've checked my data again: On my AR9280 in 2.4GHz, I get 55 or 57 bytes pl=
us
7 "special bytes" (4 bytes meta info plus 3 bytes "radar trailer?"). In 5 G=
Hz
and on my AR9380 in both bands, it is always either 56 or 58 bytes. The num=
ber
of bytes comes from rs_datalen from the rx_status struct as found in the pa=
tch
sent earlier.

So to summarise, what I currently get:
 * 55-58 bytes of "data"
 * 4 bytes of meta-information (as you provided)
 * 3 bytes of "radar trailer" (bwinfo and such)

The variation in the data puzzles me, I've already checked bit 4 in bwinfo
as Felix suggested. Is there any other "header" to the DFS data? Or should I
just skip the first few bytes and always use the last 55 bytes? At least fr=
om the
distribution, all of these numbers look like normal data and not a bitfield.
Ideas welcome. :)

I've also noticed that the middle of the data (like data[28]) is usually hi=
gher
than the rest - this might be the carrier, or something alike?

> 56  [7:0]: all bins {max_magnitude[1:0], bitmap_weight[5:0]}
> 57  [7:0]: all bins  max_magnitude[9:2]
> 58  [7:0]: all bins {max_index[5:0], max_magnitude[11:10]}
> 59  [3:0]: max_exp (shift amount to size max bin to 8-bit unsigned)
>=20
> Dynamic 20/40 mode:
>=20
> 0  bin -64 magnitude[7:0] =3D (|i| + |q|) >> max_exp  or  power (in dBm)
> 1  bin -63 magnitude[7:0] =3D (|i| + |q|) >> max_exp  or  power (in dBm)
> 2 - 125  =E2=80=A6
> 126  bin  62 magnitude[7:0] =3D (|i| + |q|) >> max_exp  or  power (in dBm)
> 127  bin  63 magnitude[7:0] =3D (|i| + |q|) >> max_exp  or  power (in dBm)
> 128  [7:0]: lower bins {max_magnitude[1:0], bitmap_weight[5:0]}
> Baseband DFS 2 (Radar) Micro-Architecture
> 129  [7:0]: lower bins  max_magnitude[9:2]
> 130  [7:0]: lower bins {max_index[5:0], max_magnitude[11:10]}
> 131  [7:0]: upper bins {max_magnitude[1:0], bitmap_weight[5:0]}
> 132  [7:0]: upper bins  max_magnitude[9:2]
> 133  [7:0]: upper bins {max_index[5:0], max_magnitude[11:10]}
> 134  [3:0]: max_exp (shift amount to size max bin to 8-bit unsigned)

Thanks again, also for posting the radar packet format! I'll play a little =
bit more
with spectral for now ...

Cheers,
	Simon

--DocE+STaALJfprDB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlDPHJgACgkQrzg/fFk7axYhoQCgzBT/lTIObkmz7MoishNsDo5l
yZ0AoIdp5kUjCglz32/HkyfeBmD49729
=PXP+
-----END PGP SIGNATURE-----

--DocE+STaALJfprDB--
