Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:40813 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752434Ab2HMRYZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Aug 2012 13:24:25 -0400
Date: Mon, 13 Aug 2012 18:53:40 +0200
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	openwrt-devel@lists.openwrt.org
Cc: Marek Lindner <lindner_marek@yahoo.de>, sven@narfation.org,
	Gabor Juhos <juhosg@openwrt.org>
Subject: AR9330 hornet board stops beaconing after a few days (0xdeadbeef)
Message-ID: <20120813165340.GA10044@pandem0nium> (sfid-20120813_192429_741687_45B57920)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cNdxnHkX5QqsyA0e"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--cNdxnHkX5QqsyA0e
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hello ath9k fellows,

I'm using a pretty new AR9330 rev1/hornet based AP at home. After some
days (5 days this time), it suddenly stops beaconing. dmesg shows nothing,
hostapd is still running, but what I can see is:

cat /sys/kernel/debug/ieee80211/phy0/ath9k/regdump
0x000000 0xdeadbeef
0x000004 0xdeadbeef
0x000008 0xdeadbeef
0x00000c 0xdeadbeef
0x000010 0xdeadbeef
0x000014 0xdeadbeef
[...]
0x001ff4 0xdeadbeef
0x001ff8 0xdeadbeef
0x001ffc 0xdeadbeef
0x002000 0xbadc0ffe
0x002004 0xbadc0ffe
0x002008 0xbadc0ffe
0x00200c 0xbadc0ffe
0x002010 0xbadc0ffe
[...]
0x003ff0 0xbadc0ffe
0x003ff4 0xbadc0ffe
0x003ff8 0xbadc0ffe
0x003ffc 0xbadc0ffe
0x004000 0x00000000
0x004004 0x0102420b
0x004008 0x00000000
0x00400c 0x00000000
[...] (some more sane looking registers here, and then zeros)
0x004ef8 0x00000000
0x004efc 0x00000000
0x004f00 0xdeadbeef
0x004f04 0xdeadbeef
0x004f08 0xdeadbeef
[...] (and the rest is mostly deadbeef)

Also /sys/kernel/debug/ieee80211/phy0/ath9k/dma shows a lot of deadbeef.

I'm using OpenWRT r31729, a single AP bridged with Ethernet. It is normal
home usage, i.e. a few laptops and android phones doing not so much traffic.
The box stops working out of the blue after a few days without any outside
event (at least none I'm aware of). Sometimes this problem does not occur for
2 weeks, sometimes after 12 hours, I couldn't find an easy way to reproduce it
yet. As said, the box is perfectly reachable via SSH, no errors in syslog or
anywhere else. Also an ifconfig wlan0 down and up seems to fix the problem.

I'll try a new firmware with more debugging turned on, but have any of you
seen this problem? Any input would be very much appreciated. I have a complete
/sys/kernel/debug log from a working and a non-working system, along with
more info (brctl, ip config, etc) which I'd love to share with anyone interested
- it's too much to post on a public ml.

Thank you very much
Cheers,
	Simon

--cNdxnHkX5QqsyA0e
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlApMRQACgkQrzg/fFk7axZiPwCgyRsBFZAKobNnozwBq5yQPxP4
uC4AoNRF/5HyJ5uORe3/S3+8tzuQDF+Q
=R2wg
-----END PGP SIGNATURE-----

--cNdxnHkX5QqsyA0e--
