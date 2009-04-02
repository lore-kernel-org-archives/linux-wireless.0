Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:46196 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753324AbZDBBwb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Apr 2009 21:52:31 -0400
Subject: Re: How to implement power save mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Charles Gordon <digigordo@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <86201b3f0904011350o5b3fb48g811b57b3c4a1e602@mail.gmail.com> (sfid-20090401_225051_265370_58404EAB)
References: <86201b3f0904011350o5b3fb48g811b57b3c4a1e602@mail.gmail.com>
	 (sfid-20090401_225051_265370_58404EAB)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-xfwt+VM5e7iEOTLg+6wT"
Date: Thu, 02 Apr 2009 03:51:57 +0200
Message-Id: <1238637117.4141.3.camel@johannes.local> (sfid-20090402_035235_334633_5852DBA9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-xfwt+VM5e7iEOTLg+6wT
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Charles,

> How is the IEEE80211_CONF_PS flag in the ieee80211_conf structure
> used?  Does it indicate when the low level driver should be turning
> the transceiver on and off, or is it just an indication of whether or
> not the driver should be running in power save mode?
>=20
> If the low level driver is suppose to implement the bulk of power save
> mode, then how is it suppose to get information like how long the
> sleep periods are suppose to be?  Does mac80211 provide utility
> functions for parsing beacons to check for TIM and DTIM elements?
>=20
> Any help you can provide would be appreciated.

You really need to read 802.11-2007, and understand how powersave mode
works. If you need software to check the beacons for (D)TIM, then you
can't really do powersave mode. You could hack around that if your
hardware provides an interrupt before the TBTT -- but that is very
fragile and I wouldn't recommend it. If your hardware design cannot
support powersave mode you'll just have to live without it.

johannes

--=-xfwt+VM5e7iEOTLg+6wT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ1Bo7AAoJEKVg1VMiehFYMWEP/jEgzzQVPEqxHS8IzdWciiuT
US6OK8q5iEjOG+6TPoYrH9ConA3RxVt775Hz0T9VBWTo5362nVsmdd32inF6X7Ze
3xd4BRayr9ZJgoRSrnl2vIu422g2rU5hwC/ILrVNyV2UFkxV5rHjfAtSd/CbSe1F
UFWtGjRX6DJRrs4+p5nY2rXeT1xfu4jQ5j3Cgk1micEebFO9S8e0aTgNSr2k0xwA
G8jUJ/y6uCnc6v6G3GZCOmo/PE+esSA8lwtFal7XGPGoOoUgH8NzxkfsHUqM74tS
/O9cqBVX2Ah92OEQVLigM6kwxcmclTPDh0yslSzE0wRWUDL08Pf5Srr7vwex8Num
EJ129HGAHVpBIZooljwERRLUggN7ysXxvQH7xP33V8JKBQ7yOxXdTflicE4OM5Ep
zuV7AtdtYzsuWszEwAnI1dGxaXfBdFNqIe2lY4mrqZ5PrfDdKgh6wTdYTF2Wf+YH
zaYBv/tPg0xpaNax23mQwo+Tc3h3zKY+I9vSJtpTKmnfZc+sg4QOFxyvvJEt0qpU
vDOlvtFNyf/7uMIx0DFPIWh6pOXFUpLIsfbECDrlafNxQdfg5bM6vcu1QkdJZuX1
2AUa4QIXuARApyHu9R0vkA617JPlw9mdxLam1JnsMjTiJnziqInu/Bz0olrH02lU
U1T1IvlXTag98BTC4JRT
=WJr2
-----END PGP SIGNATURE-----

--=-xfwt+VM5e7iEOTLg+6wT--

