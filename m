Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59741 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751611AbZG3UOX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jul 2009 16:14:23 -0400
Subject: Re: rt2x00: rt73usb doesn't receive PS Poll frames in the AP mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Igor Perminov <igor.perminov@inbox.ru>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1248984581.29068.265.camel@sunlight>
References: <1248784603.29068.44.camel@sunlight>
	 <1248787142.8113.10.camel@johannes.local>
	 <1248790678.29068.94.camel@sunlight>
	 <1248794724.8113.12.camel@johannes.local>
	 <1248984581.29068.265.camel@sunlight>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Q15CHqvxtJgcJ6YODGDc"
Date: Thu, 30 Jul 2009 22:13:51 +0200
Message-Id: <1248984831.10971.11.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Q15CHqvxtJgcJ6YODGDc
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-07-31 at 00:09 +0400, Igor Perminov wrote:

> How will a driver behave in case a device has no a separate hardware
> filter for PS Poll frames? I.e. what value should the driver return from
> configure_filter in total_flags?
>=20
> In case there is one common filter for all control frames, it's an easy
> thing. If FIF_CONTROL or FIF_PSPOLL are passed to driver's
> configure_filter in total_flags, both of them should be set there and
> the filter should be configured to pass through all control frames.
>=20
> And suppose a device has two filters: one for ACK frames and one for all
> other control frames.
> Suppose FIF_CONTROL is passed in total_flags only. In that case the
> driver sets FIF_PSPOLL there and configures both filters to pass through
> frames. Right?
> And what if FIF_PSPOLL is passed in total_flags only? In that case the
> ACK filter should be configured to filter out ACK frames (otherwise it
> would have performance overhead at least). And the second filter is
> configured to pass through frames only (i.e. all control frames except
> for ACK). So, the driver will receive not only PS Poll control frames,
> but some others.
> The question here is: should the driver set FIF_CONTROL in total_flags
> or not in that case?

Huh this is getting complicated.

I think that driver behave as follows:

 * PSPOLL:             configure control, no-ack, set PSPOLL
 * CONTROL:            configure control, ack, set CONTROL
 * PSPOLL | CONTROL:   configure control, ack, set PSPOLL | CONTROL

Although I guess it could also set PSPOLL to indicate that is being
passed. OTOH, I don't think CONTROL by itself makes any sense to pass
in, so the second case won't really happen anyway.

johannes


--=-Q15CHqvxtJgcJ6YODGDc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKcf78AAoJEODzc/N7+QmaWRUP/3TYfEEAnOluSrz8tuuPx+sW
O7C1BfAQnHfR5SXtbnEr+DaR1rqnHCE9IKCUrJsFKYwkf8z7AoiWL78M7UkFkRip
33Xd7AOd9PK/v/WWyX4YX/q/b2VJTaLz/EN61+lhrkrp/LvLiikLx+zk4fHs1LFr
/NAkCYykhfple//WfP5F7ul27U6xcuo9USQluEwPqLLs6IaL4i5EzbFT5CMLSugn
EtmLaSutGDFqMep2rjY9+B0Zn/1wA5qE5MGXOpBjkKtdxVwc1RF/X+9wfIpPO+Id
ts/vkyxj4FrkPerjsNFZ8Miw5GuIt/6rtazjtX4+lRfTmQhXGmzFppIrCcoI9rlT
geBCZNSgZ/Zw75o1P1Ur7EfZW8LbMkTJ0d4bnua25CRbQvNz/8U8aRZ0Q5aqpsoG
o4sFHKpgxdb2aaM4V42T3Hu3YiS5pf1qww1wP+imu3slEt3kAhHxx1txjExsUW/e
jstTAJ6YwWMOOENssPZab2nVyjwfwkjhOJKvbmpsWsVkkdDLGBpgezyn6FTyXYGN
MAiE1vY0o2E1BgRNDz2dGg5PQFq51P97dN1zQA6VMJt/ZEwhUVlo0hl0/SZnHCMn
l6pwxAN9KJy/s063Wtb9NSc0k1+jXdeQSHhuzyTTySVOz4+RC+/caPnkC+OgZ39V
sNdsvnSwMyM0jN9z2ZVt
=l0cq
-----END PGP SIGNATURE-----

--=-Q15CHqvxtJgcJ6YODGDc--

