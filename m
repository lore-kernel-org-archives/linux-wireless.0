Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:52672 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222Ab3APNSa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jan 2013 08:18:30 -0500
Date: Wed, 16 Jan 2013 14:18:18 +0100
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Zefir Kurtisi <zefir.kurtisi@neratec.com>
Cc: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	Sven Eckelmann <sven@open-mesh.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
	tobias.steinicke@net.t-labs.tu-berlin.de,
	mathias.kretschmer@fokus.fraunhofer.de,
	"Chadd, Adrian" <achadd@qca.qualcomm.com>
Subject: Re: [PATCH] ath9k: Save spectral scan data in network byteorder
Message-ID: <20130116131818.GA14403@pandem0nium> (sfid-20130116_141834_587167_22BA1D81)
References: <1358251363-14385-1-git-send-email-sven@open-mesh.com>
 <20130116085931.GA13648@pandem0nium>
 <50F6788B.9050409@neratec.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pf9I7BMVVzbSWLtt"
In-Reply-To: <50F6788B.9050409@neratec.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--pf9I7BMVVzbSWLtt
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hey Zefir,

On Wed, Jan 16, 2013 at 10:53:15AM +0100, Zefir Kurtisi wrote:
> On 01/16/2013 09:59 AM, Simon Wunderlich wrote:
> > On Tue, Jan 15, 2013 at 01:02:43PM +0100, Sven Eckelmann wrote:
> >> The sample data received through the spectral scan can be either in bi=
g or
> >> little endian byteorder. This information isn't stored in the output f=
ile.
> >> Therefore it is not possible for the analyzer software to find the cor=
rect byte
> >> order.
> >>
> >> It is relative common to get the data from a low end AP in big endian =
mode and
> >> transfer it to another computer in little endian mode to analyze it. T=
herefore,
> >> it would be better to store it in network (big endian) byte order.
> >=20
> > I'd agree that changing the byteorder to the "general" network order fo=
rmat is
> > a good idea, although we will break compatibility again - which should =
hopefully
> > be no problem as the original patch is pretty new anyway.
> >=20
> > I was pondering about performance loss when we run spectral on the same=
 machine
> > (i.e. maybe adding two useless byteswaps per value). OTOH the byteswaps=
 are pretty
> > cheap and we do some computations anyway, so the performance difference=
 should be quite
> > small.
> >=20
> > Therefore,
> >=20
> > Acked-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
> >=20
> > (I've CCd some more people in the reply so they can scream if they don'=
t like it. ;])
> >=20
> > Thanks,
> > 	Simon
> >=20
> Hi Simon,
>=20
> at this point, I'd like to advocate the approach I am currently using tha=
t does
> the conversion fully in user space. There, each sample provided consists =
of the
> fft data as bytes plus the values required to scale the magnitude values =
back to
> absolute power numbers (i.e. the 'bug-fixed' raw data).
>=20
> Since for the scaling an user space component is mandatory (FP calculatio=
ns), I
> miss to see the benefit of splitting post-processing in the kernel (shift=
ing bins)
> and user space. This step doubles fft data size and introduces endianess =
issues
> for no (at least to me) evident reason.

Well, that's right. The idea was to not send so "obscure" data, but I guess=
 providing
sample code which shifts the bins etc should be easy enough for people inte=
grating this
in userspace.

>=20
> Maybe you have a host application in mind where it does not really matter=
 where
> the processing is done. Whereas, if you operate an AP as continuous spect=
ral
> scanner, shifting the post-processing to the point where it is evaluated /
> displayed (usually your fat PC) significantly impacts your AP's load and =
its
> capability to provide higher sampling rates.

I didn't see any performance limits yet. Shifting the data is probably not =
so expensive
(what we do right now in the kernel), but doubled sample size and other asp=
ects
will certainly have an impact for this kind of "streaming" application for =
(low-end) APs.

>=20
> I'd assume Adrian's proposal to just push out the raw spectral data to us=
er-space
> is also targeting at that, which I fully support. The only thing I would =
keep in
> the driver is fixing the fft data corruption caused by known chip bugs.

As far as I understood, Adrian returns the whole packet with all flags and =
bugs, but I might
be wrong. I'd agree to at least fix the length bug in the kernel (newer chi=
ps should not
have this flaw anymore).

In any case, I don't want to change the format multiple times again, so let=
's discuss and
fix it once and for all[tm] now. There are some parties already experimenti=
ng with and integrating
this feature now. And if I'm not mistaken we have ~3 weeks left to add chan=
ges for
the next kernel version.

My suggestions for the new format:
 * fix length bugs (as you said)
 * use a TLV format to hand out samples (as done now) - we can use a new ty=
pe
 * each "sample packet" holds one sample, i.e. aggregated sample packets fr=
om the chip (we are not processing
   them in the current version, but in later versions maybe) are split into=
 multiple "sample packets"
 * the bins are not shifted (8 bit per bin)
 * auxiliary information which is larger than 8 bit (tsf, frequency, etc) i=
s converted into network byte order

Anything else?

Cheers,
	Simon

--pf9I7BMVVzbSWLtt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlD2qJoACgkQrzg/fFk7axY6vACgiVnEDU30g9DsLVOCBOASzIxA
5XAAn2alBUyBlJhtd1mf3btSrIFIGtg/
=5Hf/
-----END PGP SIGNATURE-----

--pf9I7BMVVzbSWLtt--
