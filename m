Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:58502 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753714AbXH1IxV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Aug 2007 04:53:21 -0400
Subject: Re: which hostapd version for which wireless driver
From: Johannes Berg <johannes@sipsolutions.net>
To: Jochen Voss <voss@seehuhn.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20070827223833.GA15515@seehuhn.de>
References: <20070827223833.GA15515@seehuhn.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-GRW2G+B7uZ1N1hf6C5qD"
Date: Tue, 28 Aug 2007 10:54:35 +0200
Message-Id: <1188291275.7837.72.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-GRW2G+B7uZ1N1hf6C5qD
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-08-27 at 23:38 +0100, Jochen Voss wrote:
> Hello,
>=20
> I am trying to get hostapd up and running on my Soekris net4521 board,
> until now without much success.  One of the problems might be that I
> am completely at a loss which version of hostapd is supposed to work
> together with which driver.
>=20
> Any help about which combinations of hostapd and device driver have at
> least a chance of working together would be more than welcome.

Both git trees (wireless-dev and hostapd) work fine together :)

> *** LinkSys WRT54GL (broadcom 4318) ***
>=20
> I tried the following drivers:
>=20
> 1) CONFIG_B43 in current wireless-dev

That's the one you want.

> 2) CONFIG_BCM43XX in current wireless-dev
> 3) CONFIG_BCM43XX in 2.6.23-rc3
> 4) CONFIG_BCM43XX in 2.6.22.5

No chance of getting these working.

> I can succesfully use wpa_supplicant with this card, e.g. with driver
> 1) above, but there are some error messages.  On the console:
>=20
>     ioctl[SIOCSIWAUTH]: Operation not supported
>     WEXT auth param 4 value 0x0 - ioctl[SIOCSIWAUTH]: Operation not suppo=
rted
>     WEXT auth param 5 value 0x1 - Internet Systems Consortium DHCP Client=
 V3.0.4
>     Copyright 2004-2006 Internet Systems Consortium.
>     All rights reserved.
>     For info, please visit http://www.isc.org/sw/dhcp/

That's expected, ignore it.

>     pccard: CardBus card inserted into slot 1
>     PCI: Enabling device 0000:05:00.0 (0000 -> 0002)
>     PCI: Setting latency timer of device 0000:05:00.0 to 64
>     b43-phy7: Broadcom 4318 WLAN found
>     wmaster0: Selected rate control algorithm 'simple'
>     ssb: Sonics Silicon Backplane found on PCI device 0000:05:00.0
>     b43-phy7 ERROR: bbatt(11) >=3D size of LO array

Also known and can be ignored.

> *** Netgear WG511 (prism54) ***
>=20
> I tried the following drivers:
>=20
> 5) CONFIG_P54_PCI in the latest wireless-dev

I don't think that supports AP mode.

> 6) PRISM54 in the lates wireless-dev
> 7) PRISM54 in 2.6.23-rc3
> 8) PRISM54 in 2.6.22.5

Nor do those, HOSTAP driver is the one you'd want here, along with the
hostap hostapd driver.

> Example: combination 1c (CONFIG_B43 in wireless-dev, current
> http://w1.fi/hostap.git) gives
>=20
>     root@funk [~] iwconfig wlan1 mode master
>     root@funk [~] iwconfig wlan1 essid "SR20"
>     root@funk [~] iwconfig wlan1 channel 6
>     root@funk [~] iwconfig wlan1 rate 11M
>     root@funk [~] ifconfig wlan1 up

Don't do any of that, hostapd configures everything.

>     root@funk [~] ifconfig wlan1 192.168.2.1

Do that after starting hostapd while the interface was down.

>     root@funk [~] hostapd /etc/hostapd.conf
>     Configuration file: /etc/hostapd.conf
>     Opening raw packet socket for ifindex 15
>     BSS count 1, BSSID mask ff:ff:ff:ff:ff:ff (0 bits)
>     Hardware does not support configured mode
>     wlan1: IEEE 802.11 Hardware does not support configured mode (2)
>     Could not select hw_mode and channel. (-1)
>     rmdir[ctrl_interface]: No such file or directory

You need to start hostapd while the interface is down ("ip link set
wlan1 down").

johannes

--=-GRW2G+B7uZ1N1hf6C5qD
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG0+LL/ETPhpq3jKURAqR2AJ4j69FW67hTz4gXYnp1b28eTUy5hQCdFcl3
kCp4kwxgwssNsKBYuv+5o4U=
=kD8E
-----END PGP SIGNATURE-----

--=-GRW2G+B7uZ1N1hf6C5qD--

