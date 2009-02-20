Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:56776 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752791AbZBTUK0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Feb 2009 15:10:26 -0500
Message-ID: <499F0E25.6030405@lwfinger.net> (sfid-20090220_211030_419407_061AE161)
Date: Fri, 20 Feb 2009 14:10:13 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: John W Linville <linville@tuxdriver.com>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 0/6] b43: Use spatch to convert register accesses
References: <200902201854.22114.mb@bu3sch.de>
In-Reply-To: <200902201854.22114.mb@bu3sch.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
> Some time ago I rejected a bunch of patches that converted the
> PHY/radio register accesses to the new API. That was due to the patch=
es
> being created manually. This introduces a huge potential to add new b=
ugs.
>=20
> However, this is an excellent task for coccinelle/spatch.
> So here's a series of patches, to convert the API usage, that were ge=
nerated
> with spatch. This should keep the chances of breaking something as lo=
w as possible.
>=20
> This reduces the .ko size by about 6 kiB.
>=20
> The used semantic patches will be included in the patch headers.
>=20
> John, please queue these patches for the next feature release.

Michael,

With those patches applied on an x86_64 system, I get the following war=
nings:


=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
  CC [M]  drivers/net/wireless/b43/phy_a.o
drivers/net/wireless/b43/phy_g.c: In function
=E2=80=98b43_radio_interference_mitigation_enable=E2=80=99:
drivers/net/wireless/b43/phy_g.c:974: warning: large integer implicitly
truncated to unsigned type
  CC [M]  drivers/net/wireless/b43/wa.o
drivers/net/wireless/b43/wa.c: In function =E2=80=98b43_wa_altagc=E2=80=
=99:
drivers/net/wireless/b43/wa.c:391: warning: large integer implicitly tr=
uncated
to unsigned type
drivers/net/wireless/b43/wa.c:409: warning: large integer implicitly tr=
uncated
to unsigned type
drivers/net/wireless/b43/wa.c:411: warning: large integer implicitly tr=
uncated
to unsigned type
drivers/net/wireless/b43/wa.c:421: warning: large integer implicitly tr=
uncated
to unsigned type
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D

All of these occur where there is a constant of the form ~0xYXXX with Y=
 in the
range 8-F. To get rid of the warning, either use a u16 cast, or manuall=
y
complement the constant.

Larry
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
