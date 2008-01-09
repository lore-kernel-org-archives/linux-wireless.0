Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:45261 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754042AbYAIMuM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jan 2008 07:50:12 -0500
Subject: Re: Warning emited by 2.6.24-rc6-git5
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Ivo van Doorn <ivdoorn@gmail.com>, chris2553@googlemail.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <1ba2fa240801081143y52e92c62o8ee2c3e701df7919@mail.gmail.com> (sfid-20080108_194357_125232_32C2E168)
References: <200712290942.37396.chris2553@googlemail.com>
	 <200712291614.55732.IvDoorn@gmail.com>
	 <1199261473.4172.58.camel@johannes.berg>
	 <200801022012.52287.IvDoorn@gmail.com>
	 <1ba2fa240801080744u5a076202n91f11b0de87384f8@mail.gmail.com>
	 <1199812167.6762.1.camel@johannes.berg>
	 <1199812976.6762.7.camel@johannes.berg>
	 <1ba2fa240801081143y52e92c62o8ee2c3e701df7919@mail.gmail.com>
	 (sfid-20080108_194357_125232_32C2E168)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-6/LCFKB/sU/KnhNbx2vs"
Date: Wed, 09 Jan 2008 13:49:53 +0100
Message-Id: <1199882994.6762.23.camel@johannes.berg> (sfid-20080109_125019_713506_8DE6C77F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-6/LCFKB/sU/KnhNbx2vs
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> I don't think it is really broken.  The packet it self is aligned. I'm
> not sure who has to be responsible for payload alignment you may have
> 10 other protocols packed into it,  each with variable length
> unaligned header.

That doesn't actually happen though, or it becomes the responsibility of
the unwrapper to handle it. The only thing 802.11 really wraps into the
payload is the protocol, with possibly an 8-byte rfc1042 header (that
doesn't break 4-byte alignment). If there's something like VPN
encapsulated it obviously becomes the responsibility of the VPN code to
align the packet properly before passing it off to the IP stack. But
where we do have IP right in our packet we need to make sure we give it
properly aligned packets.

> I understand that  I'll see what can be done, yet I don't like it

Not sure what there is to like about. I know Intel and powerpc hardware
handles unaligned loads (though at a price), but I also know that there
will be somebody sticking cards into a sparc64 or arm machine where it
fails. Aligning the packets in firmware, before they're DMA'ed into
memory, is simply the cheapest option.

johannes

--=-6/LCFKB/sU/KnhNbx2vs
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR4TC8KVg1VMiehFYAQInxRAAm9jeDq+USsWTZZR2p7EKvZkSIk5dBgCX
xjYCpjq4M7xMbUJzVJ2rhwWUZoPBBsB4x4E0PCGle3jZLMNo16V/hylMoo9DlxcX
eIHn4fjRkI9tx/YIEGeWhQZmLeiLEWG2kh0mlD+UmHtlyiS6s19JCkC1L97XR1TQ
TlBu0ihExCYraw82eB96gFNqoyYXl0gssElGaSY0Bn5uMx1/HckA/Tk7c5eS/8O0
lEF72cPIJADhzgIQo7DCw/z8C11/I449u/f7pcguDbZq/oOiWVP9D936v4UQbsqj
wKhmxxtf4AJOcH/n0VVPdFT95uL6pItS6HYi3YDb8jIeLDBfHlF926u56U4K5kmA
6LKdO6FuxGP3cKFY9NteP9NGN4fwZzbUV02b2CWS8X4I9kCy2cN5Ux2ygPMWrvST
dOsjfidCbjplgqf8RTG+0rE5aoC1GhiUfjS61GSVHLltZhfSGm5rtUlnpD40hBeX
vkE6GqeCyNMiHh93L6JDk+ZsPgpvUbkEjuwoxaIGyImio9+m5IZNRvPnpY0XVdXU
WEt43tclO/D/U2+gr59nJBMFQwP/2MdWestv5e5Tuz0YK+Qetsgalo2t+/eAkOIm
GStaXIkcMzJ8N2a5LTmLMyaQuywjlzNgHpC6e22sPOaIvsfPQnrkjjrukL5whyp8
Z83febhCrxI=
=/qcA
-----END PGP SIGNATURE-----

--=-6/LCFKB/sU/KnhNbx2vs--

