Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:50495 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934015AbXC1JMW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Mar 2007 05:12:22 -0400
Subject: debugging network manager association failure?
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Williams <dcbw@redhat.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-BqBzMUIWnoBS5g3J/pzj"
Date: Tue, 27 Mar 2007 21:26:11 +0200
Message-Id: <1175023571.5151.3.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-BqBzMUIWnoBS5g3J/pzj
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

Usually I simply use wpa_supplicant itself when testing but for some
reason I decided to use nm today... and it failed.

My nm is 0.6.4 and wpa_supplicant 0.6.0. When I use wpa_supplicant with
a config file like this:
--- %< ---
ctrl_interface=3D/var/run/wpa_supplicant
eapol_version=3D1
ap_scan=3D1
fast_reauth=3D1
network=3D{
        ssid=3D"berg"
        priority=3D1
        key_mgmt=3DWPA-PSK
        psk=3D"stuffhere"
        pairwise=3DCCMP
        group=3DCCMP TKIP
}
--- >% ---

it works perfectly. But with nm it doesn't do anything at all, stracing
it yields that it thinks it's getting authentication timeouts with
00:...:00. Any idea what could be causing this? Is this a bug in
mac80211?

johannes

--=-BqBzMUIWnoBS5g3J/pzj
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGCW/S/ETPhpq3jKURAvYJAKCT3Aj0y6NGOzb5yiApzxIi759oagCbBePG
Pivuhe/dwOguUqJiVjrsLUo=
=NlB+
-----END PGP SIGNATURE-----

--=-BqBzMUIWnoBS5g3J/pzj--

