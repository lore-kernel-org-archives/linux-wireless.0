Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39446 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752099AbYF3Ryk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jun 2008 13:54:40 -0400
Subject: Re: IBSS lockdep failure
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Linux Wireless <linux-wireless@vger.kernel.org>,
	bruno randolf <bruno@thinktube.com>
In-Reply-To: <1ba2fa240806300940v35c5f2efq6a7036de096006bc@mail.gmail.com> (sfid-20080630_184029_253158_D448274F)
References: <1ba2fa240806300848v4fd92b72n565fc113e1c122b8@mail.gmail.com>
	 <1214841181.5507.54.camel@johannes.berg>
	 <1ba2fa240806300914n7d28f874i4ee43cb999903135@mail.gmail.com>
	 <1214842913.5507.58.camel@johannes.berg>
	 <1ba2fa240806300940v35c5f2efq6a7036de096006bc@mail.gmail.com>
	 (sfid-20080630_184029_253158_D448274F)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-v/rFl64ckPB2yuPMkS6P"
Date: Mon, 30 Jun 2008 19:53:56 +0200
Message-Id: <1214848436.5507.61.camel@johannes.berg> (sfid-20080630_195443_746736_EA855AE2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-v/rFl64ckPB2yuPMkS6P
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> wlan0: beacon TSF higher than local TSF - IBSS merge with BSSID
> XX:XX:XX:XX:XX:XD
> phy0: Adding new IBSS station XX:XX:XX:XX:XX:X1 (dev=3Dwlan0)
> phy0: Allocated STA XX:XX:XX:XX:XX:X1
> phy0: Inserted STA XX:XX:XX:XX:XX:X1
> wlan0: RX ProbeReq SA=3DXX:XX:XX:XX:XX:X1 DA=3Dff:ff:ff:ff:ff:ff
> BSSID=3Dff:ff:ff:ff:ff:ff (tx_last_beacon=3D1)
> wlan0: Sending ProbeResp to XX:XX:XX:XX:XX:X1
> RX beacon SA=3DXX:XX:XX:XX:XX:XC BSSID=3DXX:XX:XX:XX:XX:XD TSF=3D0x14dc0b=
d5c
> BCN=3D0x14dc0be19 diff=3D-189 @1071562

That value is suspiciously low, you might want to double-check you're
setting the correct RX timestamp in the driver, mac80211 expects the
timestamp to be at the first symbol of the frame.


> phy0: Destroyed STA XX:XX:XX:XX:XX:XB
> phy0: Destroyed STA XX:XX:XX:XX:XX:XC

Ok so at least it's not trying to remove the same STA twice :)

> BUG: unable to handle kernel NULL pointer dereference at 00000004
> IP: [<c043d4eb>] zap_class+0x22/0x64
> *pde =3D 00000000
> Oops: 0002 [#1] SMP
> Modules linked in: mac80211 cfg80211 netconsole i915 drm autofs4 hidp
> rfcomm l2cap sunrpc cpufreq_ondemand acpi_cpufreq dm_multipath sbs

Any chance of getting a stack trace? zap_class seems weird.

johannes

--=-v/rFl64ckPB2yuPMkS6P
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIaR2xAAoJEKVg1VMiehFYrW4QAK8+WUNbbu+nFeGEXfjPYZsM
3t7XgPuD8r31MIDxSfudLyCotnAduYmIPMMBgbU07jUca6jfprpt/d823ByEnm3i
xu+aYfUXW0ECc/wHkFxt+E6lO+81i7o9efyOcIB05DN+O9eRE2PFGgfCqTe5SNu/
1eKx8Jm/NeauEc7j0qtUdtNlebmtKFrpAg/85VCq6zBoSBoAxujm6aP7CLPcSWjn
HWC++GFaUphOCdpTXFK935laVQIViyNr41fUQlOK+UuKAFw9QqFemHAxfc7KSkTy
oLdAjRd04QHkow+Aq9+yBEwzmHXRxrpphUwNUal8TgLfEcVgkEMGiD3lzQpVMn1d
j/EtXUHsggy5CPIP+TD2mYzISdpU0zasrnGiXW8M0vKOvKvmq1HL1jqJRcbkwSF6
lDlB+pqOzMYjBt6OZC10vsd1dgiRLJOeCelsZNXhl1dRo194khbCbQtH7pLhUQvD
HmUHs6dr/Uo5Vfve5IvD+MF0NGvxbMBkcQaiOLyA5Ci3ubOa2b+VvfoqqT9+cP0r
/lHNXcG6TySZT1jqJ0VMt9HJuQHq0ALnTf1aRCvSVdp4BoibsX4htt0F0iBiQxTX
n2TiAiszyMWGv0H2dXtl/lKaVnslNYI5vgTinVVknI6BJfOn2vwEOylLtOkBDr2U
BZAjovG0s8E0r8fU8rzu
=IST1
-----END PGP SIGNATURE-----

--=-v/rFl64ckPB2yuPMkS6P--

