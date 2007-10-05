Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:43875 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753603AbXJEVoF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Oct 2007 17:44:05 -0400
From: Stefan Lippers-Hollmann <s.L-H@gmx.de>
To: j@w1.fi
Subject: [PATCH] hostap_cs: Add device ID for Telekom T-Sinus 111card
Date: Fri, 5 Oct 2007 23:42:51 +0200
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2538148.H6HIiU1gSi";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200710052342.51670.s.L-H@gmx.de> (sfid-20071005_224411_220366_30D0DBE1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart2538148.H6HIiU1gSi
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

This adds the PCMCIA device ID for the Deutsche Telekom T-Sinus 111card to=
=20
hostap_cs.

$ /sbin/lspcmcia -v
[...]
Socket 0 Device 0:      [hostap_cs]             (bus ID: 0.0)
        Configuration:  state: on
        Product Name:   T-Sinus 111card 2.0.0
        Identification: manf_id: 0x01bf card_id: 0x3301
                        function: 6 (network)
                        prod_id(1): "T-Sinus" (0x8c389dc1)
                        prod_id(2): "111card" (0x6a23ac17)
                        prod_id(3): --- (---)
                        prod_id(4): "2.0.0" (0x92b9effb)


Downloading primary firmware /lib/firmware/pm010102.hex
srec summary for pm010102.hex
Included file name: PM010102.HEX
Component: 0x0015 1.1.2 (primary firmware)


Verifying update compatibility and combining data:
Plugging PDR 0400 (NIC configuration): ram16=3D1 pci=3D0 (03 00)
OK.

Downloading to volatile memory (RAM).
OK.
srec summary for pm010102.hex
Included file name: PM010102.HEX
Component: 0x0015 1.1.2 (primary firmware)

ioctl[PRISM2_IOCTL_HOSTAPD]: No data available
STAID not available (maybe running PRI-only)
ioctl[PRISM2_IOCTL_HOSTAPD]: No data available
ioctl[PRISM2_IOCTL_HOSTAPD]: No data available

Verifying update compatibility and combining data:
Plug record length mismatch (PDR=3D0x0001): 12 !=3D 16
=3D=3D> extend from default
OK.

Downloading to volatile memory (RAM).
OK.
Downloading secondary (station) firmware /lib/firmware/rf010800.hex
srec summary for rf010800.hex
Included file name: RF010800.hex
Component: 0x001f 1.8.0 (station firmware)

ioctl[PRISM2_IOCTL_HOSTAPD]: No data available
STAID not available (maybe running PRI-only)
ioctl[PRISM2_IOCTL_HOSTAPD]: No data available
ioctl[PRISM2_IOCTL_HOSTAPD]: No data available

Verifying update compatibility and combining data:
Could not find data position for plugging PDR 0x0413 at 0x0000118e (len=3D2)
PDR 0x0413 is not in wlan card PDA and there is no default data. Ignoring p=
lug record.
OK.

Downloading to volatile memory (RAM).
OK.
Components after download:
  NICID: 0x801d v1.0.0
  PRIID: 0x0015 v1.1.2
  STAID: 0x001f v1.8.0
Card wlan1 is ready with both PRI and STA firmware images


This patch has been diff'ed against net-2.6.24 commit=20
147fd2f057af893f63df5bad497bb60ac3abbaab - but applies and works reliably=20
down to kernel 2.6.16.

Signed-off-by: Stefan Lippers-Hollmann <s.l-h@gmx.de>
=2D--

 drivers/net/wireless/hostap/hostap_cs.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/hostap/hostap_cs.c b/drivers/net/wireless=
/hostap/hostap_cs.c
index f9cf22b..2f8ea07 100644
=2D-- a/drivers/net/wireless/hostap/hostap_cs.c
+++ b/drivers/net/wireless/hostap/hostap_cs.c
@@ -822,6 +822,7 @@ static struct pcmcia_device_id hostap_cs_ids[] =3D {
 	PCMCIA_DEVICE_MANF_CARD(0x0101, 0x0777),
 	PCMCIA_DEVICE_MANF_CARD(0x0126, 0x8000),
 	PCMCIA_DEVICE_MANF_CARD(0x0138, 0x0002),
+	PCMCIA_DEVICE_MANF_CARD(0x01bf, 0x3301),
 	PCMCIA_DEVICE_MANF_CARD(0x0250, 0x0002),
 	PCMCIA_DEVICE_MANF_CARD(0x026f, 0x030b),
 	PCMCIA_DEVICE_MANF_CARD(0x0274, 0x1612),

=2D-=20
Regards
	Stefan Lippers-Hollmann

--nextPart2538148.H6HIiU1gSi
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBHBq/bORbEMfgJlPYRAmwsAJ9ku39v9xMn0vS0c0+CURgVhongAwCgrqYH
nbluAaqAxcIniOgAKGFRDpM=
=CfFA
-----END PGP SIGNATURE-----

--nextPart2538148.H6HIiU1gSi--
