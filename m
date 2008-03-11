Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:60734 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143AbYCKQML (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Mar 2008 12:12:11 -0400
Subject: Re: [PATCH 1/5] mac80211: use kernel-provided bit
	rotation/byteordering
From: Johannes Berg <johannes@sipsolutions.net>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Jiri Benc <jbenc@suse.cz>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1204968174.23455.36.camel@brick> (sfid-20080308_092337_530827_4C02EB9D)
References: <1204968174.23455.36.camel@brick>
	 (sfid-20080308_092337_530827_4C02EB9D)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-H7MMho036sxHloie3X4b"
Date: Tue, 11 Mar 2008 17:11:43 +0100
Message-Id: <1205251904.6387.50.camel@johannes.berg> (sfid-20080311_161236_770105_CE245F8B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-H7MMho036sxHloie3X4b
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


>  include/linux/bitops.h |   40 ++++++++++++++++++++++++++++++++++++++++

> +++ b/include/linux/bitops.h
> @@ -65,6 +65,46 @@ static inline __u32 ror32(__u32 word, unsigned int shi=
ft)
>  	return (word >> shift) | (word << (32 - shift));
>  }
> =20
> +/**
> + * rol16 - rotate a 16-bit value left
> + * @word: value to rotate
> + * @shift: bits to roll
> + */
> +static inline __u16 rol16(__u16 word, unsigned int shift)

I don't think we can take that via wireless, and I think architectures
should be able to override this if they can optimise it (though the
compiler might be good enough...)

johannes

--=-H7MMho036sxHloie3X4b
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR9avPqVg1VMiehFYAQIp7hAAsbC2kVXh8yo/PbMhAbOn1uI/5wwseKX+
mCOXl0s/IJ07EzwWy3aOclWy21w7ZlVWLZDkQN7pKtoXhh2LuoiBmxh4Ji2UVL4/
0OMnEi+utceLDb4HtkZDpri0/IDbW4OMNjxOWFnpgYjvf3dEIKs/jbepotoTrIVc
NS5BR03S0IG68H+Y8DBe/yOeebByZ6LOTqbgHLK0m1oIpWPhiS+xBHE53DjD/L9Y
rr37ogJTywIWFVYDB3YOceA7sFFj+bAfjXoa2DpN0mMz192m5gVpedDG+2mci0wO
DHw6n/oFIVeTN/SKcUuD2W1+MD7jGCEJfLW/PZXhuCtcdvEikYoHqXgNPSKVKpnC
ZC1B9j3qlAqp5Fq0KlT6z/96NTFkx9YsGAuyP79ZR3yxFStyB2vXKfQbBpRFiK2c
bY/4dSymt16WnLJcyV+DKP+cKvDZl8fLyTovRr5cB9LLvig0R3+JiuGm4mZx9bbH
LA/xHfpkdi1UJ6PA7xrmbJI/ngoSUfjJsc07InI1m9svqzq58DTN/3pLjW5K7QFK
Wtm9foW+WPWXEyR3Wc/Lnb76ENt6mElvroYULXotoTYmP8IN+do4aSy4DZvXPfF0
yOPSLapRZSEx14X0w8e1BkVWj9OvRL44FqCL7BXfVXZPBOdqnnTNXvqO5r7CA1X7
n16KkISBgss=
=MCVZ
-----END PGP SIGNATURE-----

--=-H7MMho036sxHloie3X4b--

