Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:46623 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753346AbYFRVSP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jun 2008 17:18:15 -0400
Subject: Re: [PATCH 2/2] mac80211: add spectrum capabilities
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <1ba2fa240806181411j15544134ga55607c394ff5db7@mail.gmail.com> (sfid-20080618_231111_448703_F8563F8D)
References: <1213800824-32107-1-git-send-email-tomas.winkler@intel.com>
	 <1213800824-32107-2-git-send-email-tomas.winkler@intel.com>
	 <1213803431.1312.24.camel@johannes.berg>
	 <1ba2fa240806180917i320fac4bxcfd7416349850bff@mail.gmail.com>
	 <1213809824.1312.34.camel@johannes.berg>
	 <1ba2fa240806181411j15544134ga55607c394ff5db7@mail.gmail.com>
	 (sfid-20080618_231111_448703_F8563F8D)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-baJMchI7YcLNqBNdpIIW"
Date: Wed, 18 Jun 2008 23:17:32 +0200
Message-Id: <1213823853.1312.37.camel@johannes.berg> (sfid-20080618_231819_228676_BD7B34FD)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-baJMchI7YcLNqBNdpIIW
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> Yes, this is handled by firmware, What is important is to make switch
> on beacon edge.
> Still our implementation uses also timer in mac rather then some mac
> to driver over complicated synchronization.
> Other thing is that the firmware enforce the switching, traffic on the
> old channel is not allowed after the switch.

Yeah, ok. As for enforcing the traffic, true as well. However, I'd like
mac80211 to help out with this for those drivers that don't do it all in
firmware (all others, I'd assume); it's not overly important that you
switch instantly after receiving the switch beacon, if you take a bit
longer to do that you'll just potentially miss a few packets. No big
deal.

> > Also, does your firmware implement full radar detection? Broadcom and
> > Atheros hardware seem to only pass information about pulse edges up to
> > the driver (in different ways, obviously) and pulse/radar detection
> > needs to be done in software, I'd like that to be somehow shareable.
> >
> iwl drivers were designed for laptop marked mostly unlike like other
> vendors that plays in AP market so the radar awareness is in slave
> mode. I think the hw actually support radar detection but I'm not sure
> it was ever employed in a product.

Oh, right, ok.

johannes

--=-baJMchI7YcLNqBNdpIIW
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIWXtpAAoJEKVg1VMiehFY1c0QAJBc4ylhsfuRVfZfAbafMwvk
4A1WRut1/SgTLCbFJZS8FOVOVWgDGN488caqTj+grcCuTFbpa8TjVnJZBzepTNaV
H9wY3UDuGZsiDIeIiwASRTFA3pTfpYuSc3/zwhC3jaOcp+ynHdxC9hGcDMfPL+lb
xkivtOg5tsx35hrYCJXbEjWYekYxxiMZ0le9ZiOy77phy+XcQfmPSvw2s3r3uvZt
Ol+GKRgknm+OOkeFMuCwmm/hgEPtKj0LmRDuB9f1fI5DhD4hICmZqNlM8uGVLfY2
lk+eptXWlJl2O+wXf0zxIwy5aoN+NcQsg3Vko/oV7WmUirT3Rd3N+e2rlBAZaLqo
Lda+jZWWFpVuE5P2gaK7vznJm2qSNK2qIpi1r0C00vetufWVbZD5P1IOAL8Zjb5J
JD+yj9LGV59tHZq2YmZusbcC6PP/GRmngBMkfMSQwnkxvm3ny1wuisUjCHD36w0n
5+UWzBzWhnZRvi+aNH1OV/T6abOjS2n6EJyiaUcWKRCUQMnnhvYSXVJhSs3k72DY
iFest2Ecig/E7bVxKIdYf+fOdAy3gQlLRAkmN9AwucXWg+vcT3HY3nJGafyrjiFT
yBj8H1Mi1S3oYgFCaSQp1KS2BSd9m79K+Pcj8K6VL/ZqQXFHLxz0ZlZqyunZ+fgy
evUx0x2WJH93WaAyD+1q
=gHxW
-----END PGP SIGNATURE-----

--=-baJMchI7YcLNqBNdpIIW--

