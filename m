Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lennier.cc.vt.edu ([198.82.162.213]:37018 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755839Ab0CHWWU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Mar 2010 17:22:20 -0500
To: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Weird wireless/wpa_supplicant screw-up.
From: Valdis.Kletnieks@vt.edu
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1268086939_3979P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Date: Mon, 08 Mar 2010 17:22:19 -0500
Message-ID: <7197.1268086939@localhost>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--==_Exmh_1268086939_3979P
Content-Type: text/plain; charset=us-ascii

(This could be user error/userspace bug, feel free to point me in the right
direction if you think so.  Hopefully somebody knows what I've broken this
time...)

Fedora Rawhide as of this morning, 2.6.33-mmotm0304 kernel, wpa_supplicant-0.6.8-8.fc13.x86_64
wireless-tools-29-5.1.fc12.x86_64.  Dell Latitude E6500, Intel 5100AGN card.

So I finally get a few spare cycles, and re-try getting WPA2 working on our
enterprise wireless network, and wpa_supplicant reports it completed
successfully and set the keys, but 'iwconfig' reports back:

wlan0     IEEE 802.11abgn  ESSID:"VT-Wireless"  
          Mode:Managed  Frequency:2.412 GHz  Access Point: 00:0F:F7:14:2A:91   
          Bit Rate=1 Mb/s   Tx-Power=15 dBm   
          Retry  long limit:7   RTS thr:off   Fragment thr:off
          Encryption key:off
          Power Management:off
          Link Quality=42/70  Signal level=-68 dBm  
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0

No encryption key. Yee. Hah.

But wait... 'iwlist keys' reports:

wlan0     2 key sizes : 40, 104bits
          4 keys available :
                [1]: off
                [2]: 6A7D-5232-BDE6-E40A-71C5-EC21-6399-00F3-5CAD-D394-D1E5-1261-BD99-0115-F4A8-63B2 (256 bits)
                [3]: off
                [4]: off
          Current Transmit Key: [1]

So we got a perfectly good key, but we're not using it.

Anybody got any ideas/hints?



--==_Exmh_1268086939_3979P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFLlXibcC3lWbTT17ARAoRRAJ9cnA9eNaACHwt/XrT7mGVQsDy+jgCfQZUW
7CeL6/hsCptoeZcdxeqye54=
=03dn
-----END PGP SIGNATURE-----

--==_Exmh_1268086939_3979P--

