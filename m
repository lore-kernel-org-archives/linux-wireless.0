Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:54342 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755153AbbIWP6t (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Sep 2015 11:58:49 -0400
Date: Wed, 23 Sep 2015 17:58:01 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Larry Finger <larry.finger@lwfinger.net>,
	Hauke Mehrtens <hauke@hauke-m.de>,
	b43-dev <b43-dev@lists.infradead.org>
Subject: Re: [PATCH][RFC][RFT] ssb: pick PCMCIA host code support from b43
 driver
Message-ID: <20150923175801.69076f31@wiggum> (sfid-20150923_175853_356820_03264BBA)
In-Reply-To: <CACna6rzSqnJF2uBS-DszR+1PFNwqM8S0WecAE+R4QRJjGYuXYQ@mail.gmail.com>
References: <1442826259-6270-1-git-send-email-zajec5@gmail.com>
	<20150921182000.6d89445d@wiggum>
	<CACna6rzSqnJF2uBS-DszR+1PFNwqM8S0WecAE+R4QRJjGYuXYQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/=.5oim8atOaTfV/S2sov9eJ"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Sig_/=.5oim8atOaTfV/S2sov9eJ
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, 23 Sep 2015 12:02:48 +0200
Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com> wrote:

> On 21 September 2015 at 18:20, Michael B=C3=BCsch <m@bues.ch> wrote:
> > On Mon, 21 Sep 2015 11:04:19 +0200
> > Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com> wrote:
> >> @@ -1464,6 +1463,12 @@ static int __init ssb_modinit(void)
> >>               /* don't fail SSB init because of this */
> >>               err =3D 0;
> >>       }
> >> +     err =3D ssb_host_pcmcia_init();
> >> +     if (err) {
> >> +             ssb_err("PCMCIA host initialization failed\n");
> >> +             /* don't fail SSB init because of this */
> >
> > Why not? What's the point of not failing here?
>=20
> I just copied the logic from few lines above where we handle PCI init.
> I guess the point was to support other host devices even is PCI host
> registration fails.


Ah I misread it. This is at modinit time. That might make sense then.


> >> +static const struct pcmcia_device_id ssb_host_pcmcia_tbl[] =3D {
> >> +     PCMCIA_DEVICE_MANF_CARD(0x2D0, 0x448),
> >> +     PCMCIA_DEVICE_MANF_CARD(0x2D0, 0x476),
> >> +     PCMCIA_DEVICE_NULL,
> >> +};
> >
> > This doesn't belong into ssb'c pcmcia.c, IMO.
> > It should be in a new file called b43_pcmcia_bridge.c, just like we have
> > b43_pci_bridge.c.
> > The bridge code technically (also for pci) doesn't belong into ssb. But
> > it makes kconfig simpler.
>=20
> This is something I don't understand. This PCI bridge was also always
> confusing me.
> Why do we want a separated file for that? What's wrong with having 1
> file for host (PCI/PCMCIA) driver (probe and remove functions) *and*
> ssb initialization?


Because that's not ssb code. These are device IDs for b43 devices.
We just keep it in ssb to make module handling easier.
Ssb also runs non-b43 devices.
Think of it like PCI IDs that belong into the driver and not the PCI
subsystem.

--=20
Michael

--Sig_/=.5oim8atOaTfV/S2sov9eJ
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWAswJAAoJEPUyvh2QjYsO9woP/16xaWJDC32S4VMdChyzy/rF
BmYvEA7Xkf9MhrKQQJgSUiDSJJd4PH6ZKBpVF2f60oOlgvcuqLEveeNrQdLUe696
lTx7yaq8WdPU4rDEaURA5q5Oz75rWoweCwa/KFiWbgYbrDp+uJBElYZTaa4M5VJw
BngQlzog8O/uwVNNheI9mrckTtV6hFb/MsOSoNqzPsZcxgL8SOQXLTIDW+mB5dMq
kzklSp0uvbTb8yJbAG/aVFvzaytpQhmxkVIoLUDgQKzX080TibCVTvVAM4aSDtS/
cenKek4ypmm5Xi6tzHkbt2+WhHfk4g9wJFKuvIIWO2vN8lW9VVvcSWj0uc9sOC+n
C/vgLg5JuqdKGdb41oFyC0fRNHgo9uZwzrU64wfNVv4jCFJvSQBoIEUc+GsIz4Yh
iR0mW1JB6BaswQlPbNEPFzVDgl42ktVCGYMWSbKIZoGC93oxyjQac/41igH3NUmB
88p1xDBuw/GBGqDaMyPmNOgOa/Nvv3kJKehmLFhUjH9fTAFQ9n4mr8kAKUImC6Pl
jDdgJapLHfbHOQWZYFHdUhTgs0BenTw6LI307kEON471W7N0qborRrRTzK/jWIwN
Ml19l9QlO7/vI1Z3evg/+OxJdR0OTwb1kbjvPmU9xR2+K5DGGaA0yCsziB/0Jtrh
FeESoLJtKgw8ruh3amFm
=gjyX
-----END PGP SIGNATURE-----

--Sig_/=.5oim8atOaTfV/S2sov9eJ--
