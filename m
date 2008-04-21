Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36018 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754681AbYDUR4w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Apr 2008 13:56:52 -0400
Subject: Re: [PATCH 4/9] rt2x00: Use rt2x00 queue numbering
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	rt2400-devel@lists.sourceforge.net
In-Reply-To: <200804211958.31363.IvDoorn@gmail.com> (sfid-20080421_195225_482896_A8063A41)
References: <200804211858.46659.IvDoorn@gmail.com>
	 <1208798232.26186.121.camel@johannes.berg>
	 <200804211930.31340.IvDoorn@gmail.com>
	 <200804211958.31363.IvDoorn@gmail.com>
	 (sfid-20080421_195225_482896_A8063A41)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-CYO1AcmuqYmdFU9NRSzQ"
Date: Mon, 21 Apr 2008 19:56:17 +0200
Message-Id: <1208800577.26186.125.camel@johannes.berg> (sfid-20080421_195742_516698_3A8B7C58)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-CYO1AcmuqYmdFU9NRSzQ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > This function only exists to move the translation in a single location.
> > When the translation isn't needed anymore because skb_get_queue_mapping=
(skb)
> > or something else is used, then this function can be removed completely=
. :)
>=20
> Ps. Can I assume that skb_get_queue_mapping(skb) or whatever replacement
> for control->queue will make sure the given queue will not exceed the max
> number of supported queues as configured by the driver (through hw->queue=
s)?
>=20
> Or should the driver drop such packets or resolve it to the highest queue=
 available?

Well there are two cases.

(1) MQ is not configured -> it always returns 0
(2) MQ is configured, mac80211 will create a device with hw->queues
queues, so it'll be in the range [0 .. hw->queues-1]

johannes

--=-CYO1AcmuqYmdFU9NRSzQ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASAzVP6Vg1VMiehFYAQLFthAAqmmxBpTvJSoWWxgZ4kCsNf4R3mNXAFjI
apbRUuDteOIOAD2DMl+16JC+mflsG1CpxhQE3Eip0wQFfFVLfPp/E0WJgaDw7TRJ
VSWQCuBdmDp58rHZ4XiQYIVJ5e9b1QySyNT24iPUrEe000e8ct4Ea+g7Nm7V5JEi
xdgd5wJAUWyfj2ZXexUlYR4YS7HP8GgJOQeu4M6KlqKbqH80A2/aFHRXpu8ViHNk
QRKg+7vkjjnuLV/4B9JUCaoq0AYaRbcZGEq7XYmoGRSRD5A4IWws9ue/h7uZRWpI
tjnJ3HLCFLUQPBvDc2amfPTOk41x0/ax//GnL7YE4vg/BNVk1rdAdEehzsrUYe23
3AT+vw/t4B7d63d2qFFAXOozuF/aqtvzq6cc38rHAsXT0ZAWU8kpFV6fapUI1d3F
SHW5uH89aKfRc81wICkotHw/wQbQw7v3ke1EGugXuidKNZTcLpWTzPW3qK4mU7fM
tKcZnz+w2Irw7vsN5edxK/XStfRyptlIacAAQ7WuybZpebFQH+5MSA2LoRRTSnvr
70phLYlMizyghkYPCKbyOPCDlxLUMnQc4YLhJfKK70Ltd6haL2dovS5CQs99vu/L
SQmnxu6ExDIha14km0z7MzcnLa9sIkTS1vltsj53gLdybCaWoifIIISnxn5LTJPn
Jo7haFjEkNY=
=O77k
-----END PGP SIGNATURE-----

--=-CYO1AcmuqYmdFU9NRSzQ--

