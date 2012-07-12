Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from elektron.atoom.net ([85.223.71.124]:59932 "EHLO
	elektron.atoom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758645Ab2GLHEU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jul 2012 03:04:20 -0400
Date: Thu, 12 Jul 2012 08:58:06 +0200
From: Miek Gieben <miek@miek.nl>
To: linux-wireless@vger.kernel.org
Subject: Frequent disconnects with ath9k
Message-ID: <20120712065805.GA15967@miek.nl> (sfid-20120712_090424_371737_3AAB08B3)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LZvS9be/3tNcYl/X"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--LZvS9be/3tNcYl/X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

I'm experiencing frequent disconnects with the ath9k driver and the=20
AR9485 wireless adapter. This Ubuntu bug report has more information:
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/773154

I've tried:
* Newer kernels, from stock Ubuntu 12.04, through 3.4.x and staying with 3.=
5-rc6
    now. All kernels show the same problem, although is seems to get better
    (less disconnects). Running 3.5-rc6 atm.

* Switched with wicd, seems to help. The background scanning of network man=
ager
    makes things worse.

* Disabled power management: does not help (at least in the newer kernels it
    has no effect, in some older ones (<3.2.0) is sort of looked like it did
    something.

* Disable the hw encryption: didn't help.

* Disabled 'ani' (don't know what that is, but it didn't help).

* Disabled ipv6: didn't help.

Things that seems related to the disconnects:

* Noisy environment, multiple access points in the neighborhood with the
    same SSID.

* The background scanning from network-manager. With wicd the situation
    is much more tolerable.

* After a sleep/resume cycle is seems worse.

Does someone know what the issue might be? Please CC me on any replies - I'=
m not
subscribed to this list.

Below is a trace from my kernel log, which shows a disconnect:

[ 1453.116807] wlan0: RX AssocResp from 28:10:xx:xx:xx:xx (capab=3D0x431 st=
atus=3D0 aid=3D2)                                                   =20
[ 1453.116818] wlan0: associated                                           =
                                                              =20
[ 2177.242371] cfg80211: All devices are disconnected, going to restore reg=
ulatory settings                                              =20
[ 2177.242387] cfg80211: Restoring regulatory settings                     =
                                                              =20
[ 2177.242396] cfg80211: Calling CRDA to update world regulatory domain    =
                                                              =20
[ 2177.246070] cfg80211: Ignoring regulatory request Set by core since the =
driver uses its own custom regulatory domain                  =20
[ 2177.249079] cfg80211: World regulatory domain updated:                  =
                                                              =20
[ 2177.249084] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenn=
a_gain, max_eirp)                                             =20
[ 2177.249089] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mB=
i, 2000 mBm)                                                  =20
[ 2177.249094] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mB=
i, 2000 mBm)                                                  =20
[ 2177.249098] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mB=
i, 2000 mBm)                                                  =20
[ 2177.249102] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mB=
i, 2000 mBm)                                                  =20
[ 2177.249106] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mB=
i, 2000 mBm)                                                  =20
[ 2177.615761] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready         =
                                                              =20
[ 2180.097436] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready         =
                                                              =20
[ 2182.905090] wlan0: authenticate with 28:10:xx:xx:xx:xx                  =
                                                              =20
[ 2182.913345] wlan0: send auth to 28:10:xx:xx:xx:xx (try 1/3)             =
                                                              =20
[ 2182.915536] wlan0: authenticated                                        =
                                                              =20
[ 2182.924019] wlan0: associate with 28:10:xx:xx:xx:xx (try 1/3)           =
                                                              =20
[ 2182.927029] wlan0: RX AssocResp from 28:10:xx:xx:xx:xx (capab=3D0x431 st=
atus=3D0 aid=3D2)                                                   =20
[ 2182.927040] wlan0: associated                                           =
                                                              =20
[ 2182.927857] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready    =
                                                              =20
[ 2182.928095] cfg80211: Calling CRDA for country: GB                      =
                                                              =20
[ 2182.936422] cfg80211: Updating information on frequency 2412 MHz for a 2=
0 MHz width channel with regulatory rule:                     =20
[ 2182.936431] cfg80211: 2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A mBi, =
2000 mBm)                                                 =20

 Kind Regards,

--=20
    Miek Gieben                                                   http://mi=
ek.nl

--LZvS9be/3tNcYl/X
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk/+dX0ACgkQJYuFzziA0PaONwCfRYPkmDtKipQxZENQ1mGvRyZd
fHkAnAlzYz+O2m25TmoeWPN5BI9UBU65
=4JpN
-----END PGP SIGNATURE-----

--LZvS9be/3tNcYl/X--
