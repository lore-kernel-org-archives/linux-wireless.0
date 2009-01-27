Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:57777 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752786AbZA0TYw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jan 2009 14:24:52 -0500
Message-ID: <497F5F70.50304@hauke-m.de> (sfid-20090127_202457_014830_E2790EFB)
Date: Tue, 27 Jan 2009 20:24:32 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	barreyromartin@gmail.com, linux-wireless@vger.kernel.org
Subject: Re: [RFT V2] rtl8187: Fix OFDM power settings for RTL8187L
References: <49790961.JdcKIZyYlMNFSiuO%Larry.Finger@lwfinger.net> <4979DD39.9000601@hauke-m.de> <20090123153144.GA13658@tuxdriver.com> <497B05AF.5050701@hauke-m.de> <497D2BB3.9000002@lwfinger.net>
In-Reply-To: <497D2BB3.9000002@lwfinger.net>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig5B9AB305C30208CA585DC06C"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig5B9AB305C30208CA585DC06C
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Larry Finger wrote:
> Hauke,
>=20
> Please apply this patch on top of current wireless-testing, or
> compat-wireless.
>=20
> V1 only did one of the two kinds of radios.
>=20
> Larry

Hi Larry,

With this patch included and pid the rate goes up to 24Mb/s, but the
connection is stable. Without this patch is is only up to 11Mb/s. The
connection is still unusable with minstrel, it goes up too fare. It
starts with 24Mb/s and the connection drops. After some time it goes up
to 54Mb/s, but then it goes down again and the connection is working
again for a minute till the procedure begins again.

What do you mean with rc_stats ?

Complete iwconfig output with minstrel (No connection):
wlan0     IEEE 802.11bg  ESSID:"mehrtenswlan"
          Mode:Managed  Frequency:2.412 GHz  Access Point:
00:1A:92:EA:73:12
          Bit Rate=3D48 Mb/s   Tx-Power=3D27 dBm
          Retry min limit:7   RTS thr:off   Fragment thr=3D2352 B
          Power Management:off
          Link Quality=3D57/100  Signal level:-52 dBm
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0


dmesg |fgrep rtl shows the following:
phy0: hwaddr ffff8801399ac080, RTL8187vB (default) V1 + rtl8225z2
usbcore: registered new interface driver rtl8187


--------------enig5B9AB305C30208CA585DC06C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iQIcBAEBAgAGBQJJf192AAoJEIZ0px9YPRMy4D0P/2vG3utlzUR9VMiHUXC1KNpk
e5qFUBSaQG7gczsWJqnA9pvrxeb22BTluu+KYqdZ7APBYaqyjvrfw9dVn2qAlMsU
OUrpIFZMpjTdBBy/ys0Pdv9KGKqXOKLwzz+4ScilUSVsjvc1nNNI5/RjG6pgCqBx
NufCJL2Qv4qaOrtWVbAZyznKB1gKacozNZv5PrvVAKY2vL3/Xy5F83cQtmSmIuzC
67dVrBLh0BI5QIi5yLCFJGJXZOUUWdseWcaRxIa4Uf9cNukhohJjpW4KGhhBESyi
ntDQfulu1YVPrTDB9g5FecmTxF3+b1MCU3SHHZopG/KXF6glqRBtnsBQbZesUuGd
i1Fyg3bvgDiBiuIuDnkRmKSrE2qlyJ0+urUq3OH3nx2iKcVlaS6371BeBFj/Bf5G
lnyXsQOq9EJvBtZuumGRKosTXoBRxrMGbD04N6o8f1/GkvwH2TCysUQjM8tyBNfo
T4gP7ML/vpNFNrrzWXTN30ErEyBXBLrQRzbFkDLtXuRZmmbPxpPBjozBPphVwRl7
l478eR8QED1q/y2wG+3d9xRDCW0QX4rxmou74rj39AFA4bT+Q68PCuI9Yg4E1Kc3
yXJB/qsJHvrvdTZ+tsZI1iFeQgr4ZixzZ0VOFnb3FS9qTGP02zAl8X2gmES8J0aL
2mzNF85T1uYxMFNl5zSZ
=XvcP
-----END PGP SIGNATURE-----

--------------enig5B9AB305C30208CA585DC06C--
