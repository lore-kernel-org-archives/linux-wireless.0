Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ht2.myhostedexchange.com ([69.50.2.38]:62380 "EHLO
	ht1.hostedexchange.local" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757195Ab3BVQhr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Feb 2013 11:37:47 -0500
Date: Fri, 22 Feb 2013 17:36:44 +0100
From: Antonio Quartulli <antonio@open-mesh.com>
To: Felix Fietkau <nbd@openwrt.org>
CC: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Thomas Pedersen <thomas@cozybit.com>,
	"johannes@sipsolutions.net" <johannes@sipsolutions.net>,
	Marek Lindner <marek@open-mesh.com>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
Subject: Re: [RFC] design discussion: Collecting information for (non-peer)
 stations
Message-ID: <20130222163643.GB3757@open-mesh.com> (sfid-20130222_173750_344579_0C6D0BC3)
References: <20130215171938.GA4140@pandem0nium>
 <51279AFA.3000608@openwrt.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="xHFwDpU9dbj6ez1V"
In-Reply-To: <51279AFA.3000608@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--xHFwDpU9dbj6ez1V
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 22, 2013 at 08:21:14AM -0800, Felix Fietkau wrote:
> Hi,
>=20
> Since this is a rare special case, I think it really does not belong
> into the mac80211 data path. How about creating a monitor mode device
> and claiming it from within the kernel in your own module via rx_handler
> (the same mechanism that the bridge code uses to hook into the data path
> of a normal net_device). You can extract relevant information from the
> radiotap headers.

I think this would increase the complexity given the fact that each and eve=
ry
packet needs to be encapsulated into the radiotap header..
Then, most of the information that people wants to grab does not appear in
such header.

Other than that, by hooking into the mac80211 rx_path, in an early point, p=
ackets can
then be dropped as usual (all those packets not going to this device), while
with this monitor-like solution all of them have to be carried up to the vi=
rtual
interface.

Imho this introduces a not negligible complexity that it is better to avoid.

And what about 802.11s? I don't think this is a good solution for them..

Cheers,

--=20
Antonio Quartulli

=2E.each of us alone is worth nothing..
Ernesto "Che" Guevara

--xHFwDpU9dbj6ez1V
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBCAAGBQJRJ56bAAoJEADl0hg6qKeOGAwP/2/Kv0YU6GrfjSymvQUE5STt
6NUs80lYuDKFCLndZTZZVoX8shb/11FQM88+DIFOS/1w3vbegz9jXmfUtXN5oNlO
RNogoK22ohWCdPsrJy6Fpn4VP8rsp0ocGu5mMhUjaxYc25vkuEP36bHv3lrm2mLj
UJgXbVE+j3wCaeBwPXwjQWMZIynvvXTIE8qajAczuZhcUUVLBoR0BJe2d9+oALmW
cOfVg70mvV/8W1TdmUQNxLQrVAmyHKdhMWp4SYUexRB06Sz71XmHmkSLwg/lPBpw
qK0G3St1IjcpISM3wpvotfK3dRYDHkRyTJrlLzE4dbDeQEwoZyy6oydI5Fr42Kbd
UFYwC3ol+KSg+Rq3c90cIP4SjTt4CAWAepg6NanYNrfpIF8bN1fW410JwXn6cE+k
rojakWQsnUWdtwSbG9xzm+6oBUrpGnW/48Fvs4opy30MKsduNrBSEiesekRNmHv+
dYsTMjiy9povnFnn/TzZ5M4PuwA1CFRiFQejMHxmMFpVZMrAjufCMCNS0PY9za6C
53PNvJreQbeJl/pGQOyUx4RdfEI4mF1x/klC4yCD94Op1STLUe5toFFch0Iqp1eX
9C0Z+8i/pmemM2BAqVlmXBLtCpEUIHikuyNLQ8cvKMfKa/kEDRgRUO7CNVASdR3O
LmBlZYlz2/yxSwVac82n
=PQMA
-----END PGP SIGNATURE-----

--xHFwDpU9dbj6ez1V--
