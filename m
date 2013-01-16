Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:59314 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756209Ab3APSWu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jan 2013 13:22:50 -0500
Date: Wed, 16 Jan 2013 19:22:38 +0100
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
Message-ID: <20130116182238.GA15379@pandem0nium> (sfid-20130116_192255_437674_F7B2F709)
References: <1358251363-14385-1-git-send-email-sven@open-mesh.com>
 <20130116085931.GA13648@pandem0nium>
 <50F6788B.9050409@neratec.com>
 <20130116131818.GA14403@pandem0nium>
 <50F6CE89.5060106@neratec.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dDRMvlgZJXvWKvBx"
In-Reply-To: <50F6CE89.5060106@neratec.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--dDRMvlgZJXvWKvBx
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hey Zefir,

On Wed, Jan 16, 2013 at 05:00:09PM +0100, Zefir Kurtisi wrote:
> [...]=20
> >>
> >> Maybe you have a host application in mind where it does not really mat=
ter where
> >> the processing is done. Whereas, if you operate an AP as continuous sp=
ectral
> >> scanner, shifting the post-processing to the point where it is evaluat=
ed /
> >> displayed (usually your fat PC) significantly impacts your AP's load a=
nd its
> >> capability to provide higher sampling rates.
> >=20
> > I didn't see any performance limits yet. Shifting the data is probably =
not so expensive
> > (what we do right now in the kernel), but doubled sample size and other=
 aspects
> > will certainly have an impact for this kind of "streaming" application =
for (low-end) APs.
> >=20
> Right now, with a 500MHz ARM SoC I am limited to ~12k-samples/s with reso=
urces
> fully utilized. That's far from the 250kS/s the chip could theoretically =
provide.
> But I'm still with my netlink based interface and need to check if relay-=
fs is
> more efficient.

Well, give it a try. My application is not requiring maximum output, but I'=
ve changed to
relayfs because it was suggested for performance reasons. Let's hope it can=
 keep
this promise. :)

> [...]=20
> > In any case, I don't want to change the format multiple times again, so=
 let's discuss and
> > fix it once and for all[tm] now. There are some parties already experim=
enting with and integrating
> > this feature now. And if I'm not mistaken we have ~3 weeks left to add =
changes for
> > the next kernel version.
> >=20
> Beside the required modifications being trivial, since the user space
> post-processing is mandatory - could a library for data conversion help to
> decouple driver from test development?
>=20

Might be a good thing, although I don't plan to write this now - The fft_ev=
al
program is good enough for a reference right now. A library could handle bo=
th FreeBSD
and Linux in the future. Feel free to contribute. ;)

> > My suggestions for the new format:
> >  * fix length bugs (as you said)
> >  * use a TLV format to hand out samples (as done now) - we can use a ne=
w type
> >  * each "sample packet" holds one sample, i.e. aggregated sample packet=
s from the chip (we are not processing
> >    them in the current version, but in later versions maybe) are split =
into multiple "sample packets"
> What are your plans for aggregation here, given that you need to convert =
the data
> won't (easily) work in the kernel?

I haven't seen the aggregated spectral reports myself yet, only seen commen=
ts from Adrian.
http://article.gmane.org/gmane.linux.kernel.wireless.general/102030

The plan would be to split them so userspace always gets one sample per TLV=
, and we don't have
to create yet another format. So we would have two types: HT20 report and H=
T40 report that
userspace can support.

But we are not handling them now anyway, just to have the format somewhat f=
uture proof. :)

> >  * the bins are not shifted (8 bit per bin)
> >  * auxiliary information which is larger than 8 bit (tsf, frequency, et=
c) is converted into network byte order
> >=20
> > Anything else?
> >=20
> With the rssi and noise-floor values already included: no, looks complete.

OK, if no one else objects or has further comments I can provide patches fo=
r this one.

Cheers,
	Simon

--dDRMvlgZJXvWKvBx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlD27+4ACgkQrzg/fFk7axbAjgCgwmPyOr70J594nSLQdG78dW2h
2H8AnjxNeJNW+APlW2xTFexOT5dWdqSs
=VhYv
-----END PGP SIGNATURE-----

--dDRMvlgZJXvWKvBx--
