Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:44551 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757779Ab3CHONf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Mar 2013 09:13:35 -0500
Date: Fri, 8 Mar 2013 15:13:27 +0100
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: Adrian Chadd <adrian@freebsd.org>, Felix Fietkau <nbd@openwrt.org>,
	Antonio Quartulli <antonio@open-mesh.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Thomas Pedersen <thomas@cozybit.com>,
	"johannes@sipsolutions.net" <johannes@sipsolutions.net>,
	Marek Lindner <marek@open-mesh.com>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Zefir Kurtisi <zefir.kurtisi@neratec.com>
Subject: Re: [RFC] design discussion: Collecting information for (non-peer)
 stations
Message-ID: <20130308141327.GA3363@pandem0nium> (sfid-20130308_151340_676729_580647A3)
References: <20130215171938.GA4140@pandem0nium>
 <51279AFA.3000608@openwrt.org>
 <20130222163643.GB3757@open-mesh.com>
 <5127A4E0.8080101@openwrt.org>
 <CAJ-Vmo=zj19mxK7aK28NkGq_KWdQtn2SYPMvdvrsd9i4-H6GPw@mail.gmail.com>
 <20130225102817.GA2069@pandem0nium>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UugvWAfsgieZRqgk"
In-Reply-To: <20130225102817.GA2069@pandem0nium>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--UugvWAfsgieZRqgk
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hey,

On Mon, Feb 25, 2013 at 11:28:17AM +0100, Simon Wunderlich wrote:
> On Fri, Feb 22, 2013 at 09:42:43AM -0800, Adrian Chadd wrote:
> Anyway, I'll look at the rx_handler stuff what Felix suggested and see
> if this could work out. :)
>=20

We've drafted some external module - the general approach seems to work qui=
te
nicely, the only thing which appears needless it to add a radiotap header
and remove it later in the statistics module again ...

Anyway, here is some code to digest for anyone who is interested:

https://github.com/simonwunderlich/wifi_statistics

It hooks in an rx_handler onto mon0 (yes, that's currently static), and
throws out some info via debugfs. It parses the radiotap and wifi header
of every packet on the monitor interface.

@Antonio, Zefir: I'd be interested in your opinions. Would that be useful
for you too? Should we add all the statistics we are interested in, or bett=
er
use some kind of API if we are interested in "special statistics" which no =
one
else is?

If there is general interest, we can propose to include it in upstream Linu=
x.
Otherwise, we can maintain it (together ?) as seperate module. It's not so
big anyway ...

Cheers,
	Simon

--UugvWAfsgieZRqgk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlE58gcACgkQrzg/fFk7axY/2wCg5vQKmWkA7UmIIyNBEVuXCAVn
TAQAnjmvcI3w66ItjUzmCvJ/YnuOW4Qu
=80vh
-----END PGP SIGNATURE-----

--UugvWAfsgieZRqgk--
