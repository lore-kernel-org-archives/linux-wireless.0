Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from relais.videotron.ca ([24.201.245.36]:27627 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084Ab1GPVRe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Jul 2011 17:17:34 -0400
MIME-version: 1.0
Received: from TesterServ.TesterNet ([70.81.104.103])
 by vl-mo-mrz23.ip.videotron.ca
 (Sun Java(tm) System Messaging Server 6.3-8.01 (built Dec 16 2008; 32bit))
 with ESMTP id <0LOG00APQ33UHN00@vl-mo-mrz23.ip.videotron.ca> for
 linux-wireless@vger.kernel.org; Sat, 16 Jul 2011 17:16:42 -0400 (EDT)
Received: from 76-10-170-176.dsl.teksavvy.com
 ([76.10.170.176] helo=[192.168.4.11])	by TesterServ.TesterNet with esmtpsa
 (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)	(Exim 4.72)
	(envelope-from <olivier.crete@ocrete.ca>)
	id 1QiCEv-0004dD-1f	for linux-wireless@vger.kernel.org; Sat,
 16 Jul 2011 17:17:33 -0400
Subject: Sometimes rtl8187 stops sending/receiving packets under load
From: Olivier =?ISO-8859-1?Q?Cr=EAte?= <olivier.crete@ocrete.ca>
To: linux-wireless@vger.kernel.org
Date: Sat, 16 Jul 2011 17:17:29 -0400
Content-type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary="=-bhO5AvNH5LX3mFEn7ylQ"
Message-id: <1310851053.5700.14.camel@TesterBox.tester.ca> (sfid-20110716_231743_467685_D886E22D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-bhO5AvNH5LX3mFEn7ylQ
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable

Hello,

It's a regularly reproducible bug: under some load, like a couple
torrents running, but not enough to saturate the wireless link (and not
even enough to saturate the ADSL link on the other side), the card stops
sending or receiving any packet. Unloading and reloading the rtl8187
driver fixes the problem.

Kernel version is 2.6.38, but it also happened with older versions, and
I haven't bothered testing new ones since there are no changes in that
driver.

I get this on my dmesg:
ieee80211 phy0: wlan0: No probe response from AP 00:0f:66:e2:5f:dd after 50=
0ms, disconnecting.
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with 00:0f:66:e2:5f:dd (try 1)
wlan0: authenticate with 00:0f:66:e2:5f:dd (try 2)
wlan0: authenticate with 00:0f:66:e2:5f:dd (try 3)
wlan0: authentication with 00:0f:66:e2:5f:dd timed out

The wireless card is the one built-in a Asus P5K-E/wifi-ap motherboard.
And the router is a WRT54G v2 running the latest OpenWRT.

This bit of dmesg output may also be useful:
usb 1-3: reset high speed USB device using ehci_hcd and address 2
cfg80211: Calling CRDA to update world regulatory domain
ieee80211 phy0: Selected rate control algorithm 'minstrel_ht'
ieee80211 phy0: hwaddr 00:15:af:37:19:b3, RTL8187vB (default) V1 + rtl8225z=
2, rfkill mask 2


--=20
Olivier Cr=EAte
olivier.crete@ocrete.ca

--=-bhO5AvNH5LX3mFEn7ylQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEYEABECAAYFAk4h/+oACgkQHTiOWk7ZorvE9wCcDCJ8V6kZcYS9lylIBw+wVUke
T6IAn3NGI9wzCaUe/+kvd72qJtLHurrh
=7Scl
-----END PGP SIGNATURE-----

--=-bhO5AvNH5LX3mFEn7ylQ--

