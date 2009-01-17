Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:45713 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757954AbZAQVCy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Jan 2009 16:02:54 -0500
Received: from c83-249-24-87.bredband.comhem.se ([83.249.24.87]:3748 helo=amin)
	by ch-smtp01.sth.basefarm.net with esmtps (TLSv1:AES256-SHA:256)
	(Exim 4.68)
	(envelope-from <hans@sociologi.cjb.net>)
	id 1LOI4y-0004lN-3M
	for linux-wireless@vger.kernel.org; Sat, 17 Jan 2009 21:47:47 +0100
Received: from hans by amin with local (Exim 4.63)
	(envelope-from <hans@sociologi.cjb.net>)
	id 1LOI4H-0002QL-Sz
	for linux-wireless@vger.kernel.org; Sat, 17 Jan 2009 21:46:58 +0100
Date: Sat, 17 Jan 2009 21:46:57 +0100
From: Hans Ekbrand <hans@sociologi.cjb.net>
To: linux-wireless@vger.kernel.org
Subject: USB 1.1, usb-dongle, NETGEAR WG111v2, timing problems in association
Message-ID: <20090117204654.GB9079@amin> (sfid-20090117_220300_619636_AB9C3EFE)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pf9I7BMVVzbSWLtt"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--pf9I7BMVVzbSWLtt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi list!

On an old system with only USB 1.1, I tried to use a USB-dongle:
NETGEAR WG111v2. The device works perfectly with same kernel (2.6.26-1
=66rom debian lenny) on a new system with USB 2.0, using the "rtl8187"
driver.

However, on USB 1.1 I get:

Jan 17 17:25:17 jonspc kernel: [13991.380234] wlan1: Initial auth_alg=3D0
Jan 17 17:25:17 jonspc kernel: [13991.380234] wlan1: authenticate with AP 0=
0:1b:2f:0c:2f:28
Jan 17 17:25:17 jonspc kernel: [13991.380267] wlan1: RX authentication from=
 00:1b:2f:0c:2f:28 (alg=3D0 transaction=3D2 status=3D0)5:17 jonspc kernel: =
[13991.380267] wlan1: authenticated
Jan 17 17:25:17 jonspc kernel: [13991.380267] wlan1: associate with AP 00:1=
b:2f:0c:2f:28
Jan 17 17:25:17 jonspc kernel: [13991.604259] wlan1: associate with AP 00:1=
b:2f:0c:2f:28
Jan 17 17:25:18 jonspc kernel: [13992.136025] wlan1: Initial auth_alg=3D0
Jan 17 17:25:18 jonspc kernel: [13992.136025] wlan1: authenticate with AP 0=
0:1b:2f:0c:2f:28
Jan 17 17:25:18 jonspc kernel: [13992.136073] wlan1: association frame rece=
ived from 00:1b:2f:0c:2f:28, but not in associate state - ignoredel: [13992=
=2E340113] wlan1: authenticate with AP 00:1b:2f:0c:2f:28

[Longer part of syslog follows later in this post]

I tried to use the device on two USB 1.1 systems, both failed with the
"association frame received ... but not in associate state - ignore",
message.

Is USB 2.0 required, or is there a workaround for this problem?

Here is the output of lsusb:

Bus 001 Device 066: ID 0846:6a00 NetGear, Inc. WG111v2 54 Mbps Wireless [Re=
alTek RTL8187L]=20
Bus 001 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub

Below is a longer exerpt from syslog:

 no key needed. jonspc NetworkManager: <info>  SUP: sending command 'INTERF=
ACE_ADD wlan1#011#011wext#011/var/run/wpa_supplicant#011'spc NetworkManager=
: <info>  SUP: response was 'OK'
Jan 17 17:25:01 jonspc NetworkManager: <info>  SUP: sending command 'AP_SCA=
N 1'
Jan 17 17:25:01 jonspc NetworkManager: <info>  SUP: response was 'OK'
Jan 17 17:25:01 jonspc NetworkManager: <info>  SUP: sending command 'ADD_NE=
TWORK'
Jan 17 17:25:01 jonspc NetworkManager: <info>  SUP: response was '0'
Jan 17 17:25:01 jonspc NetworkManager: <info>  SUP: sending command 'SET_NE=
TWORK 0 ssid 48656c676573'
Jan 17 17:25:01 jonspc NetworkManager: <info>  SUP: response was 'OK'
Jan 17 17:25:01 jonspc NetworkManager: <info>  SUP: sending command 'SET_NE=
TWORK 0 key_mgmt NONE'
Jan 17 17:25:01 jonspc NetworkManager: <info>  SUP: response was 'OK'
Jan 17 17:25:01 jonspc NetworkManager: <info>  SUP: sending command 'ENABLE=
_NETWORK 0'
Jan 17 17:25:01 jonspc NetworkManager: <info>  SUP: response was 'OK'
Jan 17 17:25:01 jonspc kernel: [13975.564161] wlan1: authenticate with AP 0=
0:1b:2f:0c:2f:28
Jan 17 17:25:01 jonspc kernel: [13975.564194] wlan1: RX authentication from=
 00:1b:2f:0c:2f:28 (alg=3D0 transaction=3D2 status=3D0)5:01 jonspc kernel: =
[13975.564194] wlan1: authenticated
Jan 17 17:25:01 jonspc kernel: [13975.564194] wlan1: associate with AP 00:1=
b:2f:0c:2f:28
Jan 17 17:25:02 jonspc kernel: [13975.788114] wlan1: associate with AP 00:1=
b:2f:0c:2f:28
Jan 17 17:25:02 jonspc kernel: [13975.988110] wlan1: associate with AP 00:1=
b:2f:0c:2f:28
Jan 17 17:25:02 jonspc kernel: [13976.188137] wlan1: association with AP 00=
:1b:2f:0c:2f:28 timed out
Jan 17 17:25:17 jonspc kernel: [13991.380234] wlan1: Initial auth_alg=3D0
Jan 17 17:25:17 jonspc kernel: [13991.380234] wlan1: authenticate with AP 0=
0:1b:2f:0c:2f:28
Jan 17 17:25:17 jonspc kernel: [13991.380267] wlan1: RX authentication from=
 00:1b:2f:0c:2f:28 (alg=3D0 transaction=3D2 status=3D0)5:17 jonspc kernel: =
[13991.380267] wlan1: authenticated
Jan 17 17:25:17 jonspc kernel: [13991.380267] wlan1: associate with AP 00:1=
b:2f:0c:2f:28
Jan 17 17:25:17 jonspc kernel: [13991.604259] wlan1: associate with AP 00:1=
b:2f:0c:2f:28
Jan 17 17:25:18 jonspc kernel: [13992.136025] wlan1: Initial auth_alg=3D0
Jan 17 17:25:18 jonspc kernel: [13992.136025] wlan1: authenticate with AP 0=
0:1b:2f:0c:2f:28
Jan 17 17:25:18 jonspc kernel: [13992.136073] wlan1: association frame rece=
ived from 00:1b:2f:0c:2f:28, but not in associate state - ignoredel: [13992=
=2E340113] wlan1: authenticate with AP 00:1b:2f:0c:2f:28
Jan 17 17:25:18 jonspc kernel: [13992.343090] wlan1: RX authentication from=
 00:1b:2f:0c:2f:28 (alg=3D0 transaction=3D2 status=3D0)5:18 jonspc kernel: =
[13992.343116] wlan1: authenticated
Jan 17 17:25:18 jonspc kernel: [13992.343126] wlan1: associate with AP 00:1=
b:2f:0c:2f:28
Jan 17 17:25:18 jonspc kernel: [13992.343116] wlan1: authenticated
Jan 17 17:25:18 jonspc kernel: [13992.343126] wlan1: associate with AP 00:1=
b:2f:0c:2f:28
Jan 17 17:25:18 jonspc kernel: [13992.540122] wlan1: associate with AP 00:1=
b:2f:0c:2f:28
Jan 17 17:25:19 jonspc kernel: [13992.740140] wlan1: associate with AP 00:1=
b:2f:0c:2f:28
Jan 17 17:25:19 jonspc kernel: [13992.940143] wlan1: association with AP 00=
:1b:2f:0c:2f:28 timed out

--=20
Hans Ekbrand (http://sociologi.cjb.net) <hans@sociologi.cjb.net>
Q. What is that strange attachment in this mail?
A. My digital signature, see www.gnupg.org for info on how you could
   use it to ensure that this mail is from me and has not been
   altered on the way to you.

--pf9I7BMVVzbSWLtt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFJckO9fCyHKnBQYU4RAhhxAKCcPBPN5xurdAKdLl//CRnB7hcxRQCfeqGl
SEo6hlKnSPly2esxpZNnNLM=
=JLGK
-----END PGP SIGNATURE-----

--pf9I7BMVVzbSWLtt--
