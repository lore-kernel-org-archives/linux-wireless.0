Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:36960 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757953AbXD1Aac (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Apr 2007 20:30:32 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Jiri Benc <jbenc@suse.cz>
Subject: Re: Oops in ieee80211_register_hw
Date: Fri, 27 Apr 2007 20:26:06 -0400
Cc: Linux Wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Michael Buesch <mbuesch@freenet.de>
References: <20070427233738.5842decf@griffin.suse.cz>
In-Reply-To: <20070427233738.5842decf@griffin.suse.cz>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2104109.Z3VJ4vaTrE";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200704272026.11196.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart2104109.Z3VJ4vaTrE
Content-Type: multipart/mixed;
  boundary="Boundary-01=_fSpMGo+MUBuZUrr"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--Boundary-01=_fSpMGo+MUBuZUrr
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Friday 27 April 2007 17:37, Jiri Benc wrote:
> has anyone an idea what's going on here?
>
> How to reproduce:
> 1. modprobe bcm43xx_mac80211
> 2. plug in my cardbus bcm4318 card
> (note that if I swap these two steps, the oops doesn't occur)
>
> By adding debug printks, I located the place where the null dereference
> happens. Please note that I have Michael Wu's latest patches applied.
> It's in
> 	name =3D wiphy_dev(local->hw.wiphy)->driver->name;
> and wiphy_dev(local->hw.wiphy) is NULL.
>
I've attached a patch. I don't have the hardware so I don't know if it'll=20
work, but it seems right to me.

Thanks,
=2DMichael Wu

--Boundary-01=_fSpMGo+MUBuZUrr
Content-Type: text/x-diff;
  charset="iso-8859-1";
  name="17-fix-bcm43xx-crash.diff"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="17-fix-bcm43xx-crash.diff"

ssb: ensure ssb_device has dev set before registering

=46rom: Michael Wu <flamingice@sourmilk.net>

ssb_devices_register sets sdev->dev after the device is registered. This
moves it before device_register so it can be used during probe if an
appropriate driver is found during device_register.

Signed-off-by: Michael Wu <flamingice@sourmilk.net>
=2D--

 drivers/ssb/main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/ssb/main.c b/drivers/ssb/main.c
index 682aa5c..c8afd1b 100644
=2D-- a/drivers/ssb/main.c
+++ b/drivers/ssb/main.c
@@ -364,6 +364,7 @@ static int ssb_devices_register(struct ssb_bus *bus)
=20
 		dev->release =3D ssb_release_dev;
 		dev->bus =3D &ssb_bustype;
+		sdev->dev =3D dev;
 		snprintf(dev->bus_id, sizeof(dev->bus_id),
 			 "ssb%d:%d", bus->busnumber, dev_idx);
=20
@@ -391,7 +392,6 @@ static int ssb_devices_register(struct ssb_bus *bus)
 			kfree(devwrap);
 			goto error;
 		}
=2D		sdev->dev =3D dev;
 		dev_idx++;
 	}
=20

--Boundary-01=_fSpMGo+MUBuZUrr--

--nextPart2104109.Z3VJ4vaTrE
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGMpSjT3Oqt9AH4aERAlrUAKC/RC2j9ANCXooDCV5NcQgpkYxHtQCfTfcy
d0FhLoYYcYaP1fDQfv53YgY=
=of3V
-----END PGP SIGNATURE-----

--nextPart2104109.Z3VJ4vaTrE--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
