Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:38224 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753951AbZCQWgU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Mar 2009 18:36:20 -0400
Subject: Re: rt2x00 mesh support
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: Antonio Marques <froz@icix.org>,
	Andrey Yurovsky <andrey@cozybit.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200903172304.12595.IvDoorn@gmail.com> (sfid-20090317_230414_995833_F4343AC8)
References: <E8FC0565-5438-4AB5-A004-CD31DD9C1AA3@icix.org>
	 <200903172250.02427.IvDoorn@gmail.com>
	 <1237326824.10264.3.camel@johannes.local>
	 <200903172304.12595.IvDoorn@gmail.com>
	 (sfid-20090317_230414_995833_F4343AC8)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-jRP2Pm53J6F01SA/2G61"
Date: Tue, 17 Mar 2009 23:35:48 +0100
Message-Id: <1237329348.5100.8.camel@johannes.local> (sfid-20090317_233623_836838_A6E26409)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-jRP2Pm53J6F01SA/2G61
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-03-17 at 23:04 +0100, Ivo van Doorn wrote:

> I think I found something interesting in the log from Antonio which does
> suggest a mac80211 bug:
>=20
>=20
> > [108565.280398] phy3 -> rt73usb_config_intf: Error - TXRX_CSR9 WRITE:  =
0x000d0000, READ: 0x000d0000
> > [108565.385291] phy3 -> rt73usb_write_beacon: Error - TXRX_CSR9 WRITE: =
0x00040000, READ: 0x00040000
> > [108565.492687] phy3 -> rt73usb_kick_tx_queue: Error - TXRX_CSR9  WRITE=
: 0x001d0000, READ: 0x001d0000
>=20
> These 3 commands mean that mac80211 has send the beacon data.
>=20
> > [108565.603206] phy3 -> rt73usb_init_registers: Error - TXRX_CSR9  WRIT=
E: 0x00000000, READ: 0x00000000
>=20
> This command means that mac80211 uses the start() callback function. This=
 triggers rt2x00 to initialize
> the registers which resets the beacon generation.

Strange, that doesn't seem right. If you look at net/mac80211/iface.c,
you'll see it call ->start(), then ->add_interface(), and later
ieee80211_start_mesh(), which calls _if_config() and sets
beacon/beacon_enabled.

johannes

--=-jRP2Pm53J6F01SA/2G61
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJwCXBAAoJEKVg1VMiehFYTkkQAKDLtqQXNIR2zIdXtYXBgc6M
O7LP1AuU/dxLzyNNqaGoaAC0GnGlMAZgvh353Zl4O+Gk8sOjU0BeJk1NE7aabEbB
1ic0K7J3mJ/RiDG2kaqLh2KSsiaik6bYJhInP2fN8jVYhOJEqlFgbZqIdi2VwzT7
lL7kiRaFmbSr9F0P/d+VikZrRtr3orRX0J5KCnz4izY2pjDt1/hV/GhSTX3T2d9Y
73FcYg3CJXWzgU/x8+PXaJzui104zuhP/EzB3hoxPZ5ASDbPR6tMZ3sUhq84V1lG
GG65Pr1u7SL0QFQ7CJ6yyO0Yh9JeaqPvrsNu6GUUmZry1/qa/7Cqs0KzxPqWq5sl
EHQd0wHIiFGb+WZgeNXky3kC7gTCPlHapB69MErcR1mVtW/qX4IhqzZOmS/Qo1tb
ZRZBZ2ExhdGAcweUb2ByrsP/OSkS9D8NSxDJuCKLO2XKoApCVWnJprbQZT57ievE
ATC9Le7Rmld1ya+TsueVRVY3zAccU7X5bThDDrtrQTMQvx+Iffp+/hPezoJwjyiM
eu9xTji5KL3gTMr7+0yOc3KYnsmBIT0lYxuPNbXlNfOMjrqLVEA4TQH1meUK77/S
UoLalixRwEUPDKNLTYRE3rGBMNJxbjUJAI0+r1kNNcPoZWnC0ulZGRIGZG7dxCdn
74Yidwcm7AksvKpBwXtR
=hlH4
-----END PGP SIGNATURE-----

--=-jRP2Pm53J6F01SA/2G61--

