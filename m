Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from durandal.kismetwireless.net ([199.201.145.179]:44216 "EHLO
	durandal.nerv-un.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752212AbYFRPkx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jun 2008 11:40:53 -0400
Date: Wed, 18 Jun 2008 11:41:10 -0400
From: Mike Kershaw <dragorn@kismetwireless.net>
To: Zhu Yi <yi.zhu@intel.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: More 4965 woes
Message-ID: <20080618154109.GB15170@drd1813.lan> (sfid-20080618_174056_427540_F792B1E4)
Reply-To: Mike Kershaw <dragorn@kismetwireless.net>
References: <20080617132401.GA8328@drd1813.lan> <1213781294.2625.52.camel@debian.sh.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xgyAXRrhYN0wYx8y"
In-Reply-To: <1213781294.2625.52.camel@debian.sh.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--xgyAXRrhYN0wYx8y
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 18, 2008 at 05:28:14PM +0800, Zhu Yi wrote:
> On Tue, 2008-06-17 at 09:24 -0400, Mike Kershaw wrote:
> > 1 - Inability to associate to a network on 5ghz.  Same AP on 2.4ghz
> >   works fine, scanning shows the AP fine.  Sniffing with an additional
> >   card shows no frames at all being sent by the 4965. AP is on a
> > channel
> >   the 4965 should be able to talk to according to iwlist channel (logs
> > attached)
>=20
> >From the log, you are trying to use channel 56 which is under radar
> detection. The card must hear from the AP first in order to send. Can
> you try 36?=20

Must hear from the AP?  Like, beacons?  If beacons aren't enough, how is
something ever supposed to associate?

The AP is detected normally via scanning (wpa_supplicant 'scan' and
iwlist scan) so the card is seeing beacons fine.

I'll reboot into the git kernel later today and redo the test on another
channel.

> > 3 - Making a monitor mode vap causes a deadlock.  No logs, because the
> >   system locks hard, no caps lock LED, no sysreq.  Monitoring with
> >   tcpdump works for about 3 seconds, then boom.
>=20
> Did you create the monitor interface via 'iw' or 'iwconfig mode
> monitor'?

In this test, 'iw'.  I got about 3 seconds of packets from different
channels while trying to associate on 56 (I assume because the card was
doing a scan) and then the system locked.

-m

--=20
Mike Kershaw/Dragorn <dragorn@kismetwireless.net>
GPG Fingerprint: 3546 89DF 3C9D ED80 3381  A661 D7B2 8822 738B BDB1

Bus Error at 008BE426 while reading byte from DEADBEEF in User data space


--xgyAXRrhYN0wYx8y
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkhZLJUACgkQ17KIInOLvbEyAgCfcGyf06dWpbSR0poUCboWj2Di
O+gAniys2He3bwMYOnV7FA09+9PHiVO1
=PAMK
-----END PGP SIGNATURE-----

--xgyAXRrhYN0wYx8y--
