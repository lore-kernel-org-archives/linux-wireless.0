Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from relais.videotron.ca ([24.201.245.36]:33416 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751769Ab1GQFWh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Jul 2011 01:22:37 -0400
MIME-version: 1.0
Received: from TesterServ.TesterNet ([70.81.104.103])
 by VL-MR-MRZ20.ip.videotron.ca
 (Sun Java(tm) System Messaging Server 6.3-8.01 (built Dec 16 2008; 32bit))
 with ESMTP id <0LOG00H4CPKXUZ90@VL-MR-MRZ20.ip.videotron.ca> for
 linux-wireless@vger.kernel.org; Sun, 17 Jul 2011 01:22:09 -0400 (EDT)
Subject: Re: Sometimes rtl8187 stops sending/receiving packets under load
From: Olivier =?ISO-8859-1?Q?Cr=EAte?= <olivier.crete@ocrete.ca>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
In-reply-to: <4E221A18.2070504@lwfinger.net>
References: <1310851053.5700.14.camel@TesterBox.tester.ca>
 <4E221A18.2070504@lwfinger.net>
Content-type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary="=-5YLXQj3UnXdQfVVRAxbm"
Date: Sat, 16 Jul 2011 21:06:25 -0400
Message-id: <1310864785.3540.5.camel@TesterBox.tester.ca> (sfid-20110717_072250_959356_FF5DF7A4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-5YLXQj3UnXdQfVVRAxbm
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable

On Sat, 2011-07-16 at 18:09 -0500, Larry Finger wrote:
> On 07/16/2011 04:17 PM, Olivier Cr=EAte wrote:
> > I get this on my dmesg:
> > ieee80211 phy0: wlan0: No probe response from AP 00:0f:66:e2:5f:dd afte=
r 500ms, disconnecting.
> > cfg80211: Calling CRDA to update world regulatory domain
> > wlan0: authenticate with 00:0f:66:e2:5f:dd (try 1)
> > wlan0: authenticate with 00:0f:66:e2:5f:dd (try 2)
> > wlan0: authenticate with 00:0f:66:e2:5f:dd (try 3)
> > wlan0: authentication with 00:0f:66:e2:5f:dd timed out
> >
> > The wireless card is the one built-in a Asus P5K-E/wifi-ap motherboard.
> > And the router is a WRT54G v2 running the latest OpenWRT.
> >
> > This bit of dmesg output may also be useful:
> > usb 1-3: reset high speed USB device using ehci_hcd and address 2
> > cfg80211: Calling CRDA to update world regulatory domain
> > ieee80211 phy0: Selected rate control algorithm 'minstrel_ht'
> > ieee80211 phy0: hwaddr 00:15:af:37:19:b3, RTL8187vB (default) V1 + rtl8=
225z2, rfkill mask 2
>=20
> I have the same device as you as shown in the following:
>=20
> ieee80211 phy1: hwaddr 00:1b:2f:a2:07:ca, RTL8187vB (default) V1 + rtl822=
5z2,=20
> rfkill mask 2
>=20
> I have run this card extensively in the past several months and have not =
seen=20
> any problems. One of my APs is a WRT54GL running a fairly recent openWRT.
>=20
> Does this only happen when running torrents, or does it happen with a dif=
ferent=20
> heavy load?

I can only reproduce it with torrents, downloading something with a
single TCP connection doesn't crash. So my guess it has something to do
with the upload side maybe or maybe with loading both directions at the
same time.

> Please try to repeat with a 2.6.39 or 3.0 kernel.

Alright, upgraded to 3.0-rc7 and I could still reproduce it in less than
10 minutes.=20

--=20
Olivier Cr=EAte
olivier.crete@ocrete.ca

--=-5YLXQj3UnXdQfVVRAxbm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEYEABECAAYFAk4iNZEACgkQHTiOWk7ZorvjDgCfft4uJBRy5TzIh0xGL37HJak4
fJkAmwcMGhwAQwX7ZmSeWauITmI5ZBT5
=is9B
-----END PGP SIGNATURE-----

--=-5YLXQj3UnXdQfVVRAxbm--

