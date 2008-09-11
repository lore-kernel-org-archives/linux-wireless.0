Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42759 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754669AbYIKX1k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Sep 2008 19:27:40 -0400
Subject: Re: [PATCH] mac80211: add pre- and post-scan hooks
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: Dan Williams <dcbw@redhat.com>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <48C9811A.7070206@w1.fi>
References: <1214149401.8585.2.camel@localhost.localdomain>
	 (sfid-20080622_174624_286344_54D543FD)  <1221033061.12266.10.camel@johannes.berg>
	 (sfid-20080910_095115_515502_30A213FC) <1221159194.6986.57.camel@johannes.berg>
	 <48C9811A.7070206@w1.fi>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-jGTRwZqMJ9s3QIWWLW/q"
Date: Fri, 12 Sep 2008 01:26:35 +0200
Message-Id: <1221175595.5956.17.camel@johannes.berg> (sfid-20080912_012744_704729_E22DE93F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-jGTRwZqMJ9s3QIWWLW/q
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-09-11 at 23:35 +0300, Jouni Malinen wrote:
> Johannes Berg wrote:
> > The beaconing API in total is a bit strange, we tell the driver when th=
e
> > beacon changes and it can then request one, but we never tell it when t=
o
> > start/stop beaconing, which means that currently your driver has to
> > figure to start out beaconing on the first beacon change, and then
> > cannot possibly stop again... We can return NULL from the beacon get
> > function but that could be an error condition too...
>=20
> The original design was for AP mode only and the assumption was that
> Beacon transmission is enabled pretty much all the time. Returning NULL
> was used if ever needed to stop Beacon transmission for some period of
> time.

That can only work with some hardware though, if the hardware doesn't
beacon from a template.

> > I think we just need to add start/stop beacon bits, and then we can use
> > them around a scan too, thoughts?
>=20
> That sounds reasonable.

I'll take a look sometime.

johannes

--=-jGTRwZqMJ9s3QIWWLW/q
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIyakmAAoJEKVg1VMiehFY/b4QAKVme/2wSmqe0IP2+duQ/c3t
9z5R3JDTTirCcN5MqPngNntrP8n5i6ZUhRio5orJhkdtSo+/ocf70JXXiVoPiU/U
yQMeNDVhWhWkHVWwtQurB19neX6o/k6iYygjpKHhsmDQx+SbG9mAKMBP+M1wDI2Z
bgS5d3bmr7h8avBN5SPr59qjIh5YusLQSZfcf1UmLfUDFZr47MhCWNFNDcmi3wGw
GTjhhzSDFpD3gl17OP+PErRXL6sCEOq0lJ/BVb7xk53BUC35V8ee+BFbBzXJT72B
tG1xNjeIZPxmKHFXL6TbO3hV7SLD06x+ZUKLRLZLRx6n6aCmVf1td8xpoRS7qzoT
UWwsRJArhSyTNs6nSkK1JMMSL6b7J1qDbirQHMuGSXEQ/UTtXyB2ImApGOoheCIC
8wu4u5kQlpPkkdNLkVZlH9jcoh9mMwQ4qhJI5BOnBgSo2J7yt5dmPHV8v5p4yFR9
OPFDMOC6irYau27VwMSy6f/f8jVRvG/RD1PAK+btSu6GfgfP1Hak+jmsUeC+UGuq
zrseZnzBypK5cek+32L2kY3c88UbySIf72Yb+jvVSJQP/W1jQql6SOtmXKgYOufL
NuJc3mEj0NMzO8wDVcwdfrYyV/W7Xk9SvsuITfEINsY59Mut5ppZdYhq9sEr/1dk
iCuu9aaaUhwWOZKu7YCD
=wxbO
-----END PGP SIGNATURE-----

--=-jGTRwZqMJ9s3QIWWLW/q--

