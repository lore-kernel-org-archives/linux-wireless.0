Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:41995 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751355AbcDBHat (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Apr 2016 03:30:49 -0400
Date: Sat, 2 Apr 2016 09:30:29 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Lukas Wunner <lukas@wunner.de>
Cc: Chris Bainbridge <chris.bainbridge@gmail.com>,
	linux-pci@vger.kernel.org, linux-wireless@vger.kernel.org,
	b43-dev@lists.infradead.org
Subject: Re: [PATCH] PCI: Add Broadcom 4331 reset quirk to prevent IRQ storm
Message-ID: <20160402093029.3dc29699@wiggum> (sfid-20160402_093052_852662_A9911E01)
In-Reply-To: <20160401224646.GA11281@wunner.de>
References: <E1akxli-00030z-BC@bombadil.infradead.org>
	<20160331231346.GA7469@localhost>
	<20160401224646.GA11281@wunner.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/fzMTu7h3u6MhxX3sAj05oK9"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Sig_/fzMTu7h3u6MhxX3sAj05oK9
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 2 Apr 2016 00:46:46 +0200
Lukas Wunner <lukas@wunner.de> wrote:

> Hi Chris,
>=20
> On Fri, Apr 01, 2016 at 12:13:46AM +0100, Chris Bainbridge wrote:
> > On Tue, Mar 29, 2016 at 07:41:30PM +0200, Lukas Wunner wrote: =20
> > > Broadcom 4331 wireless cards built into Apple Macs unleash an IRQ sto=
rm
> > > on boot until they are reset, causing spurious interrupts if the IRQ =
is
> > > shared. Apparently the EFI bootloader enables the device and does not
> > > disable it before passing control to the OS. The bootloader contains a
> > > driver for the wireless card which allows it to phone home to Cuperti=
no.
> > > This is used for Internet Recovery (download and install OS X images)
> > > and probably also for Back to My Mac (remote access, RFC 6281) and to
> > > discover stolen hardware.
> > >=20
> > > The issue is most pronounced on 2011 and 2012 MacBook Pros where the =
IRQ
> > > is shared with 3 other devices (Light Ridge Thunderbolt controller, S=
DXC
> > > reader, HDA card on discrete GPU). As soon as an interrupt handler is
> > > installed for one of these devices, the ensuing storm of spurious IRQs
> > > causes the kernel to disable the IRQ and switch to polling. This lasts
> > > until the b43 driver loads and resets the device.
> > >=20
> > > Loading the b43 driver first is not always an option, in particular w=
ith
> > > the Light Ridge Thunderbolt controller: The PCI hotplug IRQ handler g=
ets
> > > installed early on because it is built in, unlike b43 which is usually
> > > a module.
> > >=20
> > > Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=3D79301
> > > Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=3D895951
> > > Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=3D1009819
> > > Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=3D1149632 =20
> >=20
> > Should also fix https://bugzilla.kernel.org/show_bug.cgi?id=3D111781 ?
> > Given that this is a serious bug that can corrupt filesystems it would
> > be good to see the fix in stable too. =20
>=20
> I cannot reproduce this particular issue on my MBP9,1 even though it
> is architecturally very similar to your MBP10,2. I tested it with
> "iommu=3Dforce intel_iommu=3Don", blacklisted b43 and stressed the machine
> a bit with kernel compiles. No issues.

I think you will have to stress the wireless, not the kernel.
Enable iommu and let the wireless receive packets that go through the
hw filters. If you have a calm network and nobody sends data to you,
the card won't write anything to DMA. (This all depends on how the
firmware configured the filters).

--=20
Michael

--Sig_/fzMTu7h3u6MhxX3sAj05oK9
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJW/3UVAAoJEPUyvh2QjYsOY0cQALPLtCsi2xMJ5yoqV7mvgAUK
mc/lmD++UoAX57+kFYvH6mgy0C+hsD6sfWw1V5RsdZ4+e2Mv/s0Pe8rY9SAk3Yip
o3J4RM0QUr37d8NTvPGimVtfhvRnYKoWhjJZZ1/pduAIAZw8bg+wN7sfd8uPFfsh
FsEqeCJXKQaVCIInRu1HCMDx0ttQe6pFv9+QM5glYPH4Se6sPCvIqqFz1k41+20f
e743Qtm8NwVlZtp/0CI6uN5G9TGyxk574S5+NVToa9YO21scx3h01CkHSk3wdBc8
ELibvXOuRkFbkOKVjYUdFyQovOAux8rOQWPwuN+7lamamynraEJbSTbAEs61kSpG
U8RqPODgdddINWz2+z2Fi+DmPD7RQmR/2o2akLWStnwZU7DlHRhZZesejZjweNfe
/f1r3MZZpxPks7IUkd6Hq8qDGXICkHCLSsUg+WjNvCAGzY4dHoG+0FghdzUbXVzs
/SdBm8tiyxYgeTSkE6Itc4fjb7D3tHi6FB0L3sG1FCVCPgDMT6+8mi1TMAAscdlh
7JzDobzQgZQg9dua4f517fIcfnYd6pynL6PGC9zk0Es2M3l9aLLPNlO/wp5Nfkwk
r76rO03VVR9hxBeaH2Ot2ZSt/3gE1UMNkoxvd0sorW0VRUEmztiSklp5+NBVq/gg
udlKOLnkgMo8AtxF/hwk
=IlT2
-----END PGP SIGNATURE-----

--Sig_/fzMTu7h3u6MhxX3sAj05oK9--
