Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:46028 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753714Ab3BTRtj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Feb 2013 12:49:39 -0500
Date: Wed, 20 Feb 2013 18:49:32 +0100
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Thomas =?utf-8?B?SMO8aG4=?= <thomas@net.t-labs.tu-berlin.de>
Cc: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	linux-wireless@vger.kernel.org,
	Thomas Pedersen <thomas@cozybit.com>,
	johannes@sipsolutions.net, antonio@open-mesh.com,
	marek@open-mesh.com,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
Subject: Re: [RFC] design discussion: Collecting information for (non-peer)
 stations
Message-ID: <20130220174932.GB1556@pandem0nium> (sfid-20130220_184942_588701_75007408)
References: <20130215171938.GA4140@pandem0nium>
 <6A268FEF-5C88-4376-A701-09ECEAC1EF2A@net.t-labs.tu-berlin.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KFztAG8eRSV9hGtP"
In-Reply-To: <6A268FEF-5C88-4376-A701-09ECEAC1EF2A@net.t-labs.tu-berlin.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--KFztAG8eRSV9hGtP
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hey Thomas,

On Tue, Feb 19, 2013 at 10:32:29AM +0100, Thomas H=C3=BChn wrote:
> Hi all,
>=20
> You motivate your proposal of collecting several statistics from non-peer=
ing stations in IBBS networks with:
> (1) "The statistics are then used to evaluate link quality and make some =
higher level decisions"=20
> &=20
> (2)"reading every packet from this monitor interface has a huge thoughput=
 limitation"
>=20
> Could you go into more details about what "higher level" decisions you ha=
ve in mind ?
> Until now you just listed a bunch of values you like to monitor on a per =
packet level without any concrete usage idea or algorithms that could make =
use of it.
> I could guess that a common goal would be to increase performance in wire=
less networks, but lets get concrete about the approach you have in mind.
> A lot of recent theoretical research in wireless goes towards interferenc=
e management, multi-user and so the gains of using channel state informatio=
n as feedback that is worth its overhead. But this direction would question=
 the packet level granularity you described=E2=80=A6 so what about aggregat=
ed statistics ?=20

thanks for your questions, we did not explain this in detail and I think Ma=
thias can
give some more background on this, but I'll try to explain:

We are currently evaluating some statistics in userspace by collecting pack=
ets via the monitor
interface. We evaluate sequence number jumps (which indicate packet loss du=
e to interference),
signal levels and such to throw this in a model to assess the channel quali=
ty. This is used
to make routing decisions according to channel qualities within a network (=
assume a multihop
mesh-like network). One problem we see here is that reading and evaluating =
these packets in
userspace is performance, reading every packet just uses a lot of CPU cycle=
s (because of
the transfer kernel->userspace and such). Therefore we would like to move t=
his statistics
collection into kernelspace, and only retrieve aggregated statistics.

So the goal for us to improve performance of the channel assessment we are =
already doing, and
use it for this custom routing software. Maybe other users can use a simila=
r approach on
other kinds of routing software, or even completely different tasks I'm cur=
rently not aware
of (e.g. these 802.11s use cases).

Cheers,
	Simon

--KFztAG8eRSV9hGtP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlElDKwACgkQrzg/fFk7axaCxgCg1HTBl4pWMEjdHcfKEhch/Cw7
jyYAoI8IsiTJxn2PLzcsHcv6P5TPUAcE
=dRgk
-----END PGP SIGNATURE-----

--KFztAG8eRSV9hGtP--
