Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from element.ksp.sk ([158.195.16.154]:34283 "EHLO element.ksp.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752315AbYC0NW2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Mar 2008 09:22:28 -0400
Received: from 92-60-53-2.rev.bonet.sk ([92.60.53.2] helo=[192.168.1.2])
	by element.ksp.sk with esmtpa (Exim 4.69)
	(envelope-from <vlado@work.ksp.sk>)
	id 1Jes3n-0001qw-9Z
	for linux-wireless@vger.kernel.org; Thu, 27 Mar 2008 14:22:27 +0100
Message-ID: <47EB9F93.3060206@work.ksp.sk> (sfid-20080327_132233_178733_0CF971A8)
Date: Thu, 27 Mar 2008 14:22:27 +0100
From: Vladimir Koutny <vlado@work.ksp.sk>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: mac80211: bad use of bss_conf.use_short_preamble
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigB70F1DA70D1FAB9ECB08A33A"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigB70F1DA70D1FAB9ECB08A33A
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi,
does anyone know what values were intended to be used for
bss_conf.use_short_preamble? The way it is handled now is not
optimal for sure:

/* WLAN_ERP_BARKER_PREAMBLE values */
enum {
        WLAN_ERP_PREAMBLE_SHORT =3D 0,
        WLAN_ERP_PREAMBLE_LONG =3D 1,
};

ieee80211_reset_erp_info():
	sdata->bss_conf.use_short_preamble =3D 0;

ieee80211_frame_duration():
		dur +=3D short_preamble ? (72 + 24) : (144 + 48);

ieee80211_handle_erp_ie():
	printk(KERN_DEBUG "%s: switched to %s barker preamble"
		" (BSSID=3D%s)\n",
		sdata->dev->name,
		(preamble_mode =3D=3D WLAN_ERP_PREAMBLE_SHORT) ?
		"short" : "long",
		print_mac(mac, ifsta->bssid));


In short, the value driver receives in bss_info_changed() callback
uses WLAN_ERP_PREAMBLE_xxx constants, but ie. frame_duration() uses
0=3Dlong, 1=3Dshort semantics (reset_erp_info() probably wants to set
long preambles as well). There are more places like this I suppose.

My reason for looking at this is that if you associate to 11b AP,
the value of use_short_preamble is not set correctly - seems that
it is set only based on ERP IE and not based on capability info.
However I'm not sure yet if this is related to above inconsistency
or not, I have to dig into it.

Regards,
  Vlado




--------------enigB70F1DA70D1FAB9ECB08A33A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iQCVAwUBR+ufk7rYBI/WS7s0AQIXOgP7BQ/mt3EFZFGxUbjLdwVUKD3LhhDH9nVU
w3ucD8vt6HiuNs1ib/veYITVXzzd4U7P9jGHjlhxXlDZI+fLy0PzRVLiy7YU4oJI
vPNnEyIZNKKXfKBRpKW82Mj7aIEIDlY/ohOEHqUvFj0CAGce19AUit4X0GjOntPy
Bf5+xB0htXE=
=nMyF
-----END PGP SIGNATURE-----

--------------enigB70F1DA70D1FAB9ECB08A33A--
