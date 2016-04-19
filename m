Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.187]:53008 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754235AbcDSSD6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Apr 2016 14:03:58 -0400
From: Maximilian Engelhardt <engelhardt@perisens.de>
To: seth.forshee@canonical.com
Cc: wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org,
	maxi@daemonizer.de
Subject: wireless-regdb: Update regulatory rules for Germany (DE) on 5GHz
Date: Tue, 19 Apr 2016 20:03:16 +0200
Message-ID: <1958820.LBuzOElZFT@perisens15> (sfid-20160419_200402_055254_92BB523B)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1540866.hqEZiY0n9z"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--nextPart1540866.hqEZiY0n9z
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"

Hi,

In Europe ETSI standardized the used for short range devices (SRD) [1] =
in ETSI=20
EN 300 440-1 [2].
According to this standard generic use equipment is allowed to transmit=
 in the=20
frequency range form 5725 MHz to 5875 MHz with a maximum output power o=
f=20
25 mW e.i.r.p. This generic allocation also allows transmission of 802.=
11=20
devices.

[3] has a list of countries and their status about the implementation o=
f the=20
SRD frequency bands. For the 5 GHz band this can be seen on page 38 in =
the=20
paragraph ANNEX 1 and the entry Annex j.

Attached is a patch that adds the 5 GHz SRD band to db.txt for Germany.=


If it is acceptable I can provide a patch adding the 5 GHz SRD band for=
 the=20
other countries listed in [3].

Thanks,
Maxi


[1] http://www.etsi.org/technologies-clusters/technologies/radio/short-=
range-devices
[2] http://www.etsi.org/deliver/etsi_en/300400_300499/30044001/01.06.01=
_60/en_30044001v010601p.pdf
[3] http://www.erodocdb.dk/Docs/doc98/official/pdf/REC7003e.pdf


diff --git a/db.txt b/db.txt
index e9ba21a..38a9340 100644
=2D-- a/db.txt
+++ b/db.txt
@@ -319,6 +319,9 @@ country CZ: DFS-ETSI
 # limit is used here as the non-interference with radar and satellite
 # apps relies on the attenuation by the building walls only in the
 # absence of DFS; the neighbour countries have 100mW limit here as wel=
l.
+# The ETSI EN 300 440-1 standard for short range devices in the 5 GHz =
band has
+# been implemented in Germany:
+# https://www.bundesnetzagentur.de/SharedDocs/Downloads/DE/Sachgebiete=
/Telekommunikation/Unternehmen_Institutionen/Frequenzen/Allgemeinzuteil=
ungen/2014_69_SRD_pdf.pdf
=20
 country DE: DFS-ETSI
        # entries 279004 and 280006
@@ -329,6 +332,8 @@ country DE: DFS-ETSI
        (5250 - 5350 @ 80), (100 mW), NO-OUTDOOR, DFS, AUTO-BW
        # entries 308002, 309001 and 310003
        (5470 - 5725 @ 160), (500 mW), DFS
+       # short range devices (ETSI EN 300 440-1)
+       (5725 - 5875 @ 80), (25 mW)
        # 60 GHz band channels 1-4, ref: Etsi En 302 567
        (57000 - 66000 @ 2160), (40)



=2D-=20
Maximilian Engelhardt
Dipl.-Ing. (Univ.)
=20
perisens GmbH
Lichtenbergstra=DFe 8
85748 Garching bei M=FCnchen

tel:    +49 89 2155203-10
fax:    +49 89 2155203-19
web:    http://www.perisens.de/
_____________

perisens GmbH
Gesch=E4ftsf=FChrer: Dr. Florian Pfeiffer=20
Sitz und Registergericht: M=FCnchen HRB 181857
USt-ID: DE-267481419

--nextPart1540866.hqEZiY0n9z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCgAGBQJXFnLoAAoJECiijTBlkGWF4PoP/3cGHg6wr4vnEvvF5C2cOJIn
yzbekDRWD2moHg4JnhdNgds6Su8vmtwzafgXN3PneK+BqgDHRSf6mH3Z2hWTUY3l
NZ0ZH6RB2Z7vIhWoY/JqZ7A7hScOgpAUJYBiTt6s8+KIUkWMjJCLFQIhYeOL4lFp
wJP1KblZHJfywTPIELXPKs0NCP6WOOMUdmEGxxDhlEdArulvCn6qoRHQQORztCf1
e90IRu7csduRgRxw8gQj6czXAuM2fmjN90Az+1YKQ1LthrKrDfdxl9idJl77DA91
G6ssdLYo+8qbap81bd1H0i1gyfJVCuyTQBTOHw65vs7gaQBeA+oHIFHRTi9OKiw6
xXkAnvIMAAGw8EDm0IJP6VDD75dNvRSZgP81UDkoxmOLbCYf0pjXwI3TqPfPG3yY
DP9QegKeEJD8iFVEIwv33p7lmIp2lYckZhfw2W5P4/sdeXsRXIrUq/eHHVRzgqwn
Jm7lby2YDVXcnvWDdZ3bWO0VRHSwUk7hDguDQOGqEBQGEep7MfH1tMwtkpHOTS67
dgwhrfG/o/Z6GfQESwm1aV+L1Ftmjt+xHloOFvKwCXmfEh2J6opOMTCXrs3+um/x
Tm/rvC9fTH8Kuawi/rU3v9AxGL7wfzZoVVTkQUKY3mYHuauChwpJ63R3FonUi5nI
icDYVCQlTNQ5jxL46y1E
=kKJ4
-----END PGP SIGNATURE-----

--nextPart1540866.hqEZiY0n9z--

