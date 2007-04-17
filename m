Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:48815 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422654AbXDRJIp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Apr 2007 05:08:45 -0400
Subject: comments on fix-subif-locking.patch
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Wu <flamingice@sourmilk.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-4//P8pGniD6HlF6hCF8F"
Date: Tue, 17 Apr 2007 18:01:22 +0200
Message-Id: <1176825682.3902.41.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-4//P8pGniD6HlF6hCF8F
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

Looks pretty good. There's one catch with rtnl-less wext however: you
cannot call unregister_netdev from a wext handler any more.

The problem is that because we no longer hold rtnl for the ioctl call we
need to hold a reference to the device instead. Hence, calling
unregister_netdev will rtnl_lock(), unlink the device from the list and
then rtnl_unlock() which runs the netdev todo which should free the
device, but this fails and hangs because there's still a taken reference
to the device.

Therefore, the private prism ioctl for removing interfaces needs to go
and hostapd and whatever else uses it just needs to use cfg80211 (i.e.
sysfs or nl80211.)

In cfg80211 we do not have this problem because we pass in an interface
index to the remove call and not a device reference so that the generic
code doesn't need to hold a reference. Since cfg80211 guarantees that at
most one call is in progress at the same time, this is still race free
as long as the driver/stack doesn't provide multiple ways to delete an
interface in which case they have to do synchronisation there.

If we absolutely cannot get rid of the prism ioctl for removing devices
yet, we'll have to return success in all cases, save the name and
schedule something that then calls ieee80211_if_remove with the saved
name and without the netdev reference held.

johannes

--=-4//P8pGniD6HlF6hCF8F
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGJO9S/ETPhpq3jKURAkcLAKCN/ePQGPkvoWsTIAMZzwhTZSXfZgCfRhVR
SgQr39MX3xxOOO3z1gLFmZU=
=DSoy
-----END PGP SIGNATURE-----

--=-4//P8pGniD6HlF6hCF8F--

