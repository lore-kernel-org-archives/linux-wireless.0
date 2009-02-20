Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:42525 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751281AbZBTUOR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Feb 2009 15:14:17 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH 0/6] b43: Use spatch to convert register accesses
Date: Fri, 20 Feb 2009 21:12:44 +0100
Cc: John W Linville <linville@tuxdriver.com>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <200902201854.22114.mb@bu3sch.de> <499F0E25.6030405@lwfinger.net>
In-Reply-To: <499F0E25.6030405@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-Id: <200902202112.44885.mb@bu3sch.de> (sfid-20090220_211421_026232_A3D0D966)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 20 February 2009 21:10:13 Larry Finger wrote:
> Michael Buesch wrote:
> > Some time ago I rejected a bunch of patches that converted the
> > PHY/radio register accesses to the new API. That was due to the pat=
ches
> > being created manually. This introduces a huge potential to add new=
 bugs.
> >=20
> > However, this is an excellent task for coccinelle/spatch.
> > So here's a series of patches, to convert the API usage, that were =
generated
> > with spatch. This should keep the chances of breaking something as =
low as possible.
> >=20
> > This reduces the .ko size by about 6 kiB.
> >=20
> > The used semantic patches will be included in the patch headers.
> >=20
> > John, please queue these patches for the next feature release.
>=20
> Michael,
>=20
> With those patches applied on an x86_64 system, I get the following w=
arnings:
>=20
>=20
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
>   CC [M]  drivers/net/wireless/b43/phy_a.o
> drivers/net/wireless/b43/phy_g.c: In function
> =E2=80=98b43_radio_interference_mitigation_enable=E2=80=99:
> drivers/net/wireless/b43/phy_g.c:974: warning: large integer implicit=
ly
> truncated to unsigned type
>   CC [M]  drivers/net/wireless/b43/wa.o
> drivers/net/wireless/b43/wa.c: In function =E2=80=98b43_wa_altagc=E2=80=
=99:
> drivers/net/wireless/b43/wa.c:391: warning: large integer implicitly =
truncated
> to unsigned type
> drivers/net/wireless/b43/wa.c:409: warning: large integer implicitly =
truncated
> to unsigned type
> drivers/net/wireless/b43/wa.c:411: warning: large integer implicitly =
truncated
> to unsigned type
> drivers/net/wireless/b43/wa.c:421: warning: large integer implicitly =
truncated
> to unsigned type
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
>=20
> All of these occur where there is a constant of the form ~0xYXXX with=
 Y in the
> range 8-F. To get rid of the warning, either use a u16 cast, or manua=
lly
> complement the constant.

Yes I know this. These warnings are harmless and I'll fix it in a separ=
ate patch.
These patches were supposed to be computer-generated to reduce the poss=
ibility of random breakage.


--=20
Greetings, Michael.
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
