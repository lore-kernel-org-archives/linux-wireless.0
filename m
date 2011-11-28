Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.allnet.de ([212.18.29.59]:20036 "EHLO mail.allnet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752004Ab1K1QRy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Nov 2011 11:17:54 -0500
Date: Mon, 28 Nov 2011 17:12:25 +0100
From: Daniel Golle <dgolle@allnet.de>
To: <linux-wireless@vger.kernel.org>
CC: Daniel Golle <dgolle@allnet.de>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Felix Fietkau <nbd@openwrt.org>
Subject: [PATCH v1 0/3] support for antenna configuration profiles
Message-ID: <20111128161225.GA25430@localhost> (sfid-20111128_171757_078893_7ACF616B)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0OAP2g/MAC+5xKAE"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--0OAP2g/MAC+5xKAE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

It took me a while to get this into a nice shape and make the code less hac=
kish.
Thank you for all the helpful feedback on PATCH v0 and the RFC!
I'm looking forward to your comments and highly appreciate any further advi=
se.

Changes since my previous patch:
 * restructured nl80211 stuff, putting the whole thing into a NLA_NESTED ma=
kes
   the parser happy.
 * store selection state in the driver instead of overwriting the value in =
the
   AntCtrlCommon field.
 * expose selected switch_com_value in eeprom_4k.
 * moved stuff in ath9k to where it belongs (afaik)
 * lots of cosmetics

I got my patched-up version of iw and works like a charm with the ALL0258N =
now:

root@OpenWrt:/# iw list
Wiphy phy0:
        Band 1:
        ...
        Device supports antenna configuration profiles.
                 (*) 0  horiz   (horizontal TX, vertical RX)
                 ( ) 1  vert    (vertical TX, horizontal RX)
        ...

root@OpenWrt:/# grep 9964 /sys/kernel/debug/ieee80211/phy0/ath9k/regdump=20
0x009964 0x00000000
root@OpenWrt:/# iw phy phy0 interface add wlan0 type station
root@OpenWrt:/# ifconfig wlan0 up
root@OpenWrt:/# grep 9964 /sys/kernel/debug/ieee80211/phy0/ath9k/regdump=20
0x009964 0x09a00210
root@OpenWrt:/# ifconfig wlan0 down
root@OpenWrt:/# iw set extant 1
root@OpenWrt:/# iw list
Wiphy phy0
        Band 1:
        ...
        Device supports antenna configuration profiles.
                 ( ) 0  horiz   (horizontal TX, vertical RX)
                 (*) 1  vert    (vertical TX, horizontal RX)
        ...

root@OpenWrt:/# ifconfig wlan0 up
root@OpenWrt:/# grep 9964 /sys/kernel/debug/ieee80211/phy0/ath9k/regdump=20
0x009964 0x0a900120

Here the patch for iw. I'm planing to partially reimplement that in libiwin=
fo
for OpenWrt's LuCI.


--0OAP2g/MAC+5xKAE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJO07LoAAoJEDy9cKN/1Et0wjoP/iuyWf2OnGwfSXnhH1ZSdgAF
r2rV1udrWoSwaDBnkXHNy/h238UJLWWdrsnuBpazm5ENgVGzDcb1o40fXWOiqRx+
on8KubFOXD9rZaisEpjrHC1kZb2KA9DbmGlrRoJjemAV+zj/+0aVy9rjvxMKMNJ4
eNRl0YdW/8CDG0kYYIActgLTkdEd7ioI/KPI+6y2HbKQofJ+7SZBAMadyWfFz0WJ
DMAa6djshytNEJLWHn9o+7uwZjqMt0RtaoD01t+zBwPhDfF3RWdGGKShP6HEnHIr
dOIX3/je13mzfcIWBK7IhtHj41/NXHspCqc7+0R3ZQ1TWHGQfXiC71jr4PQBjqLA
9gk3jJvDQALz6PCm9d4gRzA4C/V/y9Bv+pjLAJ007H6sixftVj27BokKszR1gzUF
MlD4dJk4+db8LWO7qHIsxckRUBycJIAF6M4xAb1sQUvv4s5dDn0ZphXI4Z32bWdU
ltnn9EV09//w1BkrtwTsY9LdU1VhiFyCzq3ZsDn2/OJmCyYhhXtNpB2kV5MXsFL9
J9watBcGet7cVILXSlAoMfcEsDQAzWXU7ZpIT4bIEblyXDDryvsyyjdphHtoHO3R
GCyWBo7FnYC+Ksbr/WTOvE3wcyAZRbxiB42rlyDK524EOCifFj+iyjilm1rQ6mTV
LphXPadFWyHjQ5UCKbKa
=2GKQ
-----END PGP SIGNATURE-----

--0OAP2g/MAC+5xKAE--
