Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hydra.gt.owl.de ([195.71.99.218]:54996 "EHLO hydra.gt.owl.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751785AbXKMTXc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Nov 2007 14:23:32 -0500
Date: Tue, 13 Nov 2007 20:23:30 +0100
From: Florian Lohoff <flo@rfc822.org>
To: Will Dyson <will.dyson@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: rt2x00/rt2500 PCI unresponsive / sluggish response
Message-ID: <20071113192330.GA19601@paradigm.rfc822.org> (sfid-20071113_192337_893049_190C54B3)
References: <20071111102315.GC10486@paradigm.rfc822.org> <8e6f94720711121459j56f640abid03cb2a1eca319c2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="huq684BweRXVnRxX"
In-Reply-To: <8e6f94720711121459j56f640abid03cb2a1eca319c2@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--huq684BweRXVnRxX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 12, 2007 at 05:59:25PM -0500, Will Dyson wrote:
> That is some pretty nasty latency. You didn't describe the setup for
> your test, so I don't really have any insight into this problem. You
> might want to check the wireless bitrate using the "iwconfig" command.
>=20
> If the bitrate is really low, then the network latency problem is
> explained. When the bitrate is low, it is much easier for a single
> stream to saturate the connection (making for bad latency).
>=20
> The output of "iwconfig" and "dmesg | grep rt2x00" would really help
> in debugging this issue.

You are right - its caused by a VERY low bitrate:

flo@heisenberg:~$ sudo iwconfig ra0
ra0       IEEE 802.11g  ESSID:"home.rfc822.org" =20
          Mode:Managed  Frequency:2.452 GHz  Access Point: 00:0C:41:DE:17:F=
C  =20
          Bit Rate=3D1 Mb/s   Tx-Power=3D27 dBm  =20
          Retry min limit:7   RTS thr:off   Fragment thr=3D2346 B  =20
          Encryption key:off
          Link Quality=3D47/100  Signal level=3D-49 dBm =20
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0

This is kind of "interesting" as the machine is just next table
as the Access Point - Direct line of sight - about 2m.
The point is that i didnt experience the same problem
back with 2.6.16.16 and the out-of-tree ralink driver.

Here is the driver i didnt experience the problem with:

flo@heisenberg:~$ sudo modinfo /lib/modules/2.6.16.16-heisenberg/extra/rt25=
00.ko=20
filename:       /lib/modules/2.6.16.16-heisenberg/extra/rt2500.ko
license:        GPL
description:    Ralink RT2500 802.11g WLAN driver 1.1.0 BETA3 2005/07/31
author:         http://rt2x00.serialmonkey.com
alias:          pci:v00001814d00000201sv*sd*bc*sc*i*
depends:       =20
vermagic:       2.6.16.16-heisenberg preempt PENTIUM4 gcc-4.0
parm:           debug:Enable level: accepted values: 1 to switch debug on, =
0 to switch debug off. (i)
parm:           ifname:Network device name (default ra%d) (s)

With 2.6.24-rc2 current git the rt2x00 driver is compiled fixed into
the kernel - No rt2x00 messages but here is what i found:

flo@heisenberg:~$ dmesg | egrep "rt2x00|ra0|phy0"
phy0: Selected rate control algorithm 'simple'
ADDRCONF(NETDEV_UP): ra0: link is not ready
ra0: Initial auth_alg=3D0
ra0: authenticate with AP 00:0c:41:de:17:fc
ra0: RX authentication from 00:0c:41:de:17:fc (alg=3D0 transaction=3D2 stat=
us=3D0)
ra0: authenticated
ra0: associate with AP 00:0c:41:de:17:fc
ra0: RX AssocResp from 00:0c:41:de:17:fc (capab=3D0x401 status=3D0 aid=3D1)
ra0: associated
ra0: switched to short barker preamble (BSSID=3D00:0c:41:de:17:fc)
ADDRCONF(NETDEV_CHANGE): ra0: link becomes ready
ra0: Initial auth_alg=3D0
ra0: authenticate with AP 00:0c:41:de:17:fc
ra0: RX authentication from 00:0c:41:de:17:fc (alg=3D0 transaction=3D2 stat=
us=3D0)
ra0: authenticated
ra0: associate with AP 00:0c:41:de:17:fc
ra0: authentication frame received from 00:0c:41:de:17:fc, but not in authe=
nticate state - ignored
ra0: authentication frame received from 00:0c:41:de:17:fc, but not in authe=
nticate state - ignored
ra0: authentication frame received from 00:0c:41:de:17:fc, but not in authe=
nticate state - ignored
ra0: authentication frame received from 00:0c:41:de:17:fc, but not in authe=
nticate state - ignored
ra0: authentication frame received from 00:0c:41:de:17:fc, but not in authe=
nticate state - ignored
ra0: authentication frame received from 00:0c:41:de:17:fc, but not in authe=
nticate state - ignored
ra0: authentication frame received from 00:0c:41:de:17:fc, but not in authe=
nticate state - ignored
ra0: RX ReassocResp from 00:0c:41:de:17:fc (capab=3D0x401 status=3D0 aid=3D=
1)
ra0: associated
ra0: association frame received from 00:0c:41:de:17:fc, but not in associat=
e state - ignored
ra0: association frame received from 00:0c:41:de:17:fc, but not in associat=
e state - ignored
ra0: association frame received from 00:0c:41:de:17:fc, but not in associat=
e state - ignored
ra0: association frame received from 00:0c:41:de:17:fc, but not in associat=
e state - ignored
ra0: association frame received from 00:0c:41:de:17:fc, but not in associat=
e state - ignored
ra0: association frame received from 00:0c:41:de:17:fc, but not in associat=
e state - ignored
ra0: association frame received from 00:0c:41:de:17:fc, but not in associat=
e state - ignored
ra0: no IPv6 routers present

Another interesting point is that at the back of the PCI Card the
"TxLink" led is permanently lit - I dont think this was the case
with the older driver - at least i cant remember it beeing lit.

Flo
--=20
Florian Lohoff                  flo@rfc822.org             +49-171-2280134
	Those who would give up a little freedom to get a little=20
          security shall soon have neither - Benjamin Franklin

--huq684BweRXVnRxX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHOfmyUaz2rXW+gJcRAo/fAKCtlKwwjuV826t7tucRbsk1ubDGAQCfZfAE
Cg9725ZaVFSzLuGJBISry7E=
=iF2s
-----END PGP SIGNATURE-----

--huq684BweRXVnRxX--
