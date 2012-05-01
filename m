Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from latitanza.investici.org ([82.94.249.234]:39449 "EHLO
	latitanza.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756801Ab2EATBf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 May 2012 15:01:35 -0400
Date: Tue, 1 May 2012 20:34:15 +0200
From: Antonio Quartulli <ordex@autistici.org>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: "Venkataraman, Meenakshi" <meenakshi.venkataraman@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: iwlwifi warn_slowpath with 3.*
Message-ID: <20120501183415.GG4316@ritirata.org> (sfid-20120501_210140_004028_369A0A43)
References: <20120422182928.GA2854@ritirata.org>
 <20120430145803.GE2630@ritirata.org>
 <20120430170337.GA2560@tuxdriver.com>
 <4595B4D22AB93C4FABBA84AAD5AA37FD143115@ORSMSX103.amr.corp.intel.com>
 <CANUX_P1Nx4jYbRwehi+qW-2RVy=ntb_cCzBzpYXkJysuPvrCPA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2xeD/fx0+7k8I/QN"
In-Reply-To: <CANUX_P1Nx4jYbRwehi+qW-2RVy=ntb_cCzBzpYXkJysuPvrCPA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--2xeD/fx0+7k8I/QN
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 01, 2012 at 08:13:46PM +0300, Emmanuel Grumbach wrote:
> Hi,
>=20
> I am not sure the patch will help because the race is _very_ unlikely.
> But I would be glad to know if you can reproduce on latest
> compat-wireless.
> How reproducible is that on 3.3.3 ? Is that 100% ?

it seems so. It happens at least once at boot time.
I will try wireless-testing and see what happens. Then I will apply your pa=
tch.

Thanks a lot!

>=20
> I guess my machine doesn't have IOMMU, but honestly, I am not sure I
> know how to check.
>=20
> On Tue, May 1, 2012 at 19:52, Venkataraman, Meenakshi
> <meenakshi.venkataraman@intel.com> wrote:
> >
> > Hi John, Antonio,
> >
> > Emmanuel found a race condition in rx buffer allocation/deallocation, a=
nd
> > attached is a patch that fixes it.
> >
> > >> > since linux-3.0 (I don't remember if it was the case even before),
> > >> > I'm getting this output in dmesg:
> > >> >
> > >> > [ =C2=A0 53.662990] ------------[ cut here ]------------
> > >> > [ =C2=A0 53.663016] WARNING: at drivers/iommu/intel-iommu.c:2911
> > >> > intel_unmap_page+0x14b/0x180()
> > >> > [ =C2=A0 53.663047] Hardware name: Latitude E5420
> > >> > [ =C2=A0 53.663066] Driver unmaps unmatched page at PFN ffd1a000
> > >>
> > >>
> > >> I see that I always get the same addr passed to the unmap function:
> > >>
> > >> [ =C2=A0 23.950535] Driver unmaps unmatched page at PFN ffd1a000
> > >>
> > >> is it a coincidence?
> > >> I'm running linux-3.3.3 right now. I can try wireless-testing if it
> > >> would help.
> >
> > [MV] Antonio -- can you try out the patch attached and let us know if y=
ou
> > continue to see the problem?
> >
> > >Just for the record, we are seeing a similar problem on RHEL 6.3 (which
> > > has an
> > >iwlwifi driver derived from linux-3.2).
> > >
> > > =C2=A0 =C2=A0 =C2=A0 https://bugzilla.redhat.com/show_bug.cgi?id=3D81=
5998
> >
> > [MV] John -- I'll update the redhat bugzilla as well.
> >
> > Thanks
> > Meenakshi

--=20
Antonio Quartulli

=2E.each of us alone is worth nothing..
Ernesto "Che" Guevara

--2xeD/fx0+7k8I/QN
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQEcBAEBAgAGBQJPoCynAAoJEFMQTLzJFOZFIDYH/iXYdRxp4ituUgxP2vgusYU8
GYIT2x29ahCExNgmMvrBcPqygpNYPeco5dUWxZx2b9eFX87DtELe83u2ZMHjqAM1
Q+WRjL0Q0a/kb2ZPRjfYKQj6beZIzFSQ+Zd3gTcs4s0LlRoSCSwWhzd+MvWq3wRx
HqPpPa9FR5qyEgKVyy1TJcpV3e0eo9nLhPaWyPpaYeK9DkNzU4H5H1C/RgFZjSdS
459vWX+RLHuKm7mqtZ3hcqt7MLDe0KfKfGnOAgIr+wHwiWUgYOFya9TDwdgwCpBD
aeQ7Ecie7glmTQEO8F8H4s5yj/3QWulnIyLhU4JMz7/E27TpkPG5SwVi+6Hlg5k=
=Wj2+
-----END PGP SIGNATURE-----

--2xeD/fx0+7k8I/QN--
