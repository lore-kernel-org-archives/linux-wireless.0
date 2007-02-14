Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:50883 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932455AbXBNTEZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Feb 2007 14:04:25 -0500
Received: from [131.234.76.11] (helo=dhcp-76-11.uni-paderborn.de)
	by sipsolutions.net with esmtpsa (TLS-1.0:RSA_ARCFOUR_MD5:16)
	(Exim 4.63)
	(envelope-from <johannes@sipsolutions.net>)
	id 1HHPMy-0000Ha-Jp
	for linux-wireless@vger.kernel.org; Wed, 14 Feb 2007 19:00:45 +0000
Subject: nl80211 userspace
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-QKyzp3Z0RtA+Q9/NEHE4"
Date: Wed, 14 Feb 2007 20:04:06 +0100
Message-Id: <1171479846.3709.3.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-QKyzp3Z0RtA+Q9/NEHE4
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

I've been playing a bit with parsing a modified nl80211 header file to
get a tool and

 http://git.sipsolutions.net/pynl80211.git/

is what I currently have. It doesn't
actually send netlink messages yet but that ought to be trivial to add,
I'm too lazy right now to look up all the exact binary stuff. Python
does have a "struct" module that can be used to pack things into binary
so it's really easy :)

Anyway. The repository contains a modified nl80211.h and the tool relies on
a lot of things to be correct in it, see parse.py.

Examples:
$ ./wificonf.py help configure=20
./wificonf.py configure ifindex [ssid=3D...] [transmit_power=3D...] [frag_t=
hreshold=3D...] [channel=3D...] [rx_sensitivity=3D...]
        ifindex: interface name or index
        ssid: string (1-32 bytes)
        transmit_power: u32
        frag_threshold: u32
        channel: u32
        rx_sensitivity: u32
$ ./wificonf.py help set_roaming_control
./wificonf.py set_roaming_control ifindex roaming_control
        ifindex: interface name or index
        roaming_control: kernel, userspace=20
$ ./wificonf.py configure eth1 ssid=3D"my ssid" channel=3D7 frag_threshold=
=3D580
TODO: construct a netlink message with command number 9
and the following attributes
        1: 4
        18: 'my ssid'
        20: 580
        12: 7
$ ./wificonf.py set_fixed_bssid eth1 0:1:2:3:4:ff
TODO: construct a netlink message with command number 17
and the following attributes
        1: 4
        15: '\x00\x01\x02\x03\x04\xff'

(ifindex is looked up via sysfs: /sys/class/net/<name>/ifindex)

Obviously parsing the response netlink message is missing too :)

Included also is a check shell script that will use wificonf's parser to
make sure the header file was parsed correctly wrt the numbers of the
constants (since I don't have a C parser built into it.)

johannes

--=-QKyzp3Z0RtA+Q9/NEHE4
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBF010m/ETPhpq3jKURAqc/AJ9NYW18RIkW2zQMGqrmwlyHMsnmKgCgjewl
p/KV87chLYgviK0h6npA5CQ=
=ikGp
-----END PGP SIGNATURE-----

--=-QKyzp3Z0RtA+Q9/NEHE4--

