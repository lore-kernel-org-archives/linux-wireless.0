Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:59839 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934112AbXCFNMG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Mar 2007 08:12:06 -0500
Subject: bcm43xx master mode works for me
From: Johannes Berg <johannes@sipsolutions.net>
To: bcm43xx-dev@berlios.de
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-xK6eIEZaJurr/mE7FvOD"
Date: Tue, 06 Mar 2007 02:08:12 +0100
Message-Id: <1173143292.15891.79.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-xK6eIEZaJurr/mE7FvOD
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

I just gave this another try, after porting the fix for the
beacon_control kfree bug which I'd found and debugged with Michael on
IRC earlier (changeset 8ce88367b520c0fb303832026d5604a414e1259c in his
tree) to the latest wireless-dev [1] and making hostapd compile, I have
master mode working with bcm43xx.

That means I can now start working on creating a driver_nl82011.c for
hostapd and killing off the prism2 ioctls one by one :) Help is always
welcome though.

johannes

[1]
actually, that's not strictly true. my tree also contains these patches:

fix-mac80211-Kconfig [was sent to akpm for the s390 problems]
tasklet-free-debug.patch [kills scheduled tasklets in memory that is being =
freed]
fix-scanf.patch [fixes scanf, unfortunately nobody replied to that...]
export-device-rename.patch [gregkh has that]
wiphy-rename.patch [posted earlier]
delete-netlink-wext.patch [posted earlier]
rework-kconfig [posted earlier]
bluetape1.patch
bluetape2.patch
bluetape3.patch
bluetape4.patch
bluetape5.patch [Michael Wu's patch series]
sysfs-to-debugfs.patch [debugfs #1]
more-sysfs-to-debugfs.patch [debugfs #2]
wiphy-private-id.patch [posted earlier]
mac80211-netdev-stuff-to-debugfs.patch [debugfs #3]
fix-header-bogosities.patch [posted recently]
nl80211-new-commands.patch [work in progress]
wpa.h.patch [posted recently]
bcm43xx-fix.patch [the ported fix]
hostapd-compile.patch [posted FYI]


--=-xK6eIEZaJurr/mE7FvOD
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBF7L77/ETPhpq3jKURAt1sAJ4zBpeO53xVJh2ZkqlpeKdKyaYrMgCgsZRh
cJZKkZMQHfCaLF7o7TuwQpI=
=LS5F
-----END PGP SIGNATURE-----

--=-xK6eIEZaJurr/mE7FvOD--

