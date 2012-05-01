Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from latitanza.investici.org ([82.94.249.234]:39469 "EHLO
	latitanza.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757293Ab2EATBg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 May 2012 15:01:36 -0400
Date: Tue, 1 May 2012 20:33:22 +0200
From: Antonio Quartulli <ordex@autistici.org>
To: "Venkataraman, Meenakshi" <meenakshi.venkataraman@intel.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Emmanuel Grumbach (egrumbach@gmail.com)" <egrumbach@gmail.com>
Subject: Re: iwlwifi warn_slowpath with 3.*
Message-ID: <20120501183322.GF4316@ritirata.org> (sfid-20120501_210140_556266_DC937CCD)
References: <20120422182928.GA2854@ritirata.org>
 <20120430145803.GE2630@ritirata.org>
 <20120430170337.GA2560@tuxdriver.com>
 <4595B4D22AB93C4FABBA84AAD5AA37FD143115@ORSMSX103.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LZFKeWUZP29EKQNE"
In-Reply-To: <4595B4D22AB93C4FABBA84AAD5AA37FD143115@ORSMSX103.amr.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--LZFKeWUZP29EKQNE
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 01, 2012 at 04:52:23PM +0000, Venkataraman, Meenakshi wrote:
> Hi John, Antonio,
>=20
> Emmanuel found a race condition in rx buffer allocation/deallocation, and=
 attached is a patch that fixes it.
>=20
> >> > since linux-3.0 (I don't remember if it was the case even before),
> >> > I'm getting this output in dmesg:
> >> >
> >> > [   53.662990] ------------[ cut here ]------------
> >> > [   53.663016] WARNING: at drivers/iommu/intel-iommu.c:2911
> >> > intel_unmap_page+0x14b/0x180()
> >> > [   53.663047] Hardware name: Latitude E5420
> >> > [   53.663066] Driver unmaps unmatched page at PFN ffd1a000
> >>
> >>
> >> I see that I always get the same addr passed to the unmap function:
> >>
> >> [   23.950535] Driver unmaps unmatched page at PFN ffd1a000
> >>
> >> is it a coincidence?
> >> I'm running linux-3.3.3 right now. I can try wireless-testing if it wo=
uld help.
>=20
> [MV] Antonio -- can you try out the patch attached and let us know if you=
 continue to see the problem?

Ok, I will first try with a plain wireless-testing kernel and then I will a=
pply
the patch.

Thanks!



--=20
Antonio Quartulli

=2E.each of us alone is worth nothing..
Ernesto "Che" Guevara

--LZFKeWUZP29EKQNE
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQEcBAEBAgAGBQJPoCxyAAoJEFMQTLzJFOZFmlEH/RQ74pb5eZSuVJrMG6I5lAJ8
9JnDcxBALMVUzi3ucUDX/4nvYmuXF5PkLNEU+3jbVT6Hei3K26W6MOf1C00YuCmc
5OaBsEFyfyrw4GZ4hNmzz5pbIr0B0Ei47lMRPFFOTnvuZMixV172AgwKpM9Vmh53
2OxieXm30XGbIIiJO9wf29rciEIoF/JalUzMa6UDhoBjmRFfaGJYaaweLatrfbqt
qYI5+zmGEKT4isvZQQzOyQNV3aizYK6hKHr5cm+A9fPoJJehiwaLhFQ9ntc+pP+9
N7vfFm0qmQApHsYjt9DIC3SBp4RvnTeI0/9PKJZ6Z90X472E20EFXSD8VSwDdxA=
=NovH
-----END PGP SIGNATURE-----

--LZFKeWUZP29EKQNE--
