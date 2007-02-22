Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:58571 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616AbXBVNgR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Feb 2007 08:36:17 -0500
Received: from [131.234.73.165] (helo=dhcp-73-165.uni-paderborn.de)
	by sipsolutions.net with esmtpsa (TLS-1.0:RSA_ARCFOUR_MD5:16)
	(Exim 4.63)
	(envelope-from <johannes@sipsolutions.net>)
	id 1HKE3R-0001tr-BD
	for linux-wireless@vger.kernel.org; Thu, 22 Feb 2007 13:32:13 +0000
Subject: pynl80211 works
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-cHZ40jmhCY1+rKY4YggA"
Date: Thu, 22 Feb 2007 13:43:00 +0100
Message-Id: <1172148180.5080.13.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-cHZ40jmhCY1+rKY4YggA
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

you obviously need the nl80211 hookup patch and pynl80211 at after or at
commit e99894da4ba56e0a493cc9e76d20bab8e3b0a96f but then watch:

# ip link
[indizes 1, 2, 3, 6, 17 snipped]

# ./wificonf.py add_virtual_interface 0 moni0 monitor
Success

# ip link
[indizes 1, 2, 3, 6, 17 snipped]
40: moni0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop
    link/[802] 00:11:24:xx:xx:xx brd ff:ff:ff:ff:ff:ff

# ./wificonf.py del_virtual_interface 0 moni0
Success

# ip link
[indizes 1, 2, 3, 6, 17 snipped]

# echo "Yes, it works! :D"
Yes, it works! :D


Oh and if you do get errors:
$ ./wificonf.py add_virtual_interface 0 abc monitor
Traceback (most recent call last):
  File "./wificonf.py", line 210, in ?
    exit(exec_cmd(items['CMD'][argv[1]], argv[2:]))
  File "./wificonf.py", line 186, in exec_cmd
    m =3D conn.recv()
  File "/home/johannes/Projects/cfg80211/tool/netlink.py", line 145, in
recv
    raise OSError("Netlink error: %s (%d)"%(os.strerror(errno),errno))
OSError: Netlink error: Operation not permitted (1)


Not the nicest error reporting but hey.

johannes

--=-cHZ40jmhCY1+rKY4YggA
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBF3Y/U/ETPhpq3jKURAn99AJkB4DHIHrSHLFwu4X7h/3fW91gQMQCgmdvW
Bv4U4xONdlmxG2ARpbNTVo8=
=3uuk
-----END PGP SIGNATURE-----

--=-cHZ40jmhCY1+rKY4YggA--

