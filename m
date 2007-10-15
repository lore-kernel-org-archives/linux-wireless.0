Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:55364 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752076AbXJOIbc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Oct 2007 04:31:32 -0400
Subject: Re: [PATCH] Re: atheros hardware needs padding for QoS data
From: Johannes Berg <johannes@sipsolutions.net>
To: bruno randolf <bruno@thinktube.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200710151634.33480.bruno@thinktube.com>
References: <200710121946.30024.bruno@thinktube.com>
	 <1192194578.4770.55.camel@johannes.berg>
	 <200710151241.17651.bruno@thinktube.com>
	 <200710151634.33480.bruno@thinktube.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-aTzus5Smxl0YHvEZoT/Y"
Date: Mon, 15 Oct 2007 10:31:56 +0200
Message-Id: <1192437116.3349.5.camel@johannes.berg> (sfid-20071015_093135_146317_BC58472A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-aTzus5Smxl0YHvEZoT/Y
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-10-15 at 16:34 +0900, bruno randolf wrote:
> what do you think about the following solution?

I don't like it. If we wanted to implement this in mac80211 we should do
a zero-copy solution with pointers to header/data portion which is very
hard right now because mac80211 has much assumptions that it's all
contiguous. Secondly, this adds overhead for all hardware to mac80211
for something that can be *trivially* solved in the driver, and only a
single driver so far requires it. I think the driver is a *much* better
place to do this.

> Atheros hardware requires the header to be padded to 4 byte (32 bit)
> boundaries. It expects the payload data to start at multiples of 4 byte f=
or TX
> frames and will add the padding for received frames. For most headers the=
re is
> no need for padding, since they are multiples of 4 already - except QoS a=
nd 4
> address headers.
>=20
> This adds a new hw flag IEEE80211_HW_HEADER_PADDING to tell mac80211 that=
 such
> a padding is needed.

[patch snipped]

johannes

--=-aTzus5Smxl0YHvEZoT/Y
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARxMle6Vg1VMiehFYAQLDzxAAt0znl1QhhekhewitpJ5pEP2ZqmWbtBQM
7gfAOkRTa5Fur3POME3mxOj2mO3WHNyx7j4HHFoSvy+jqTQx4rL1yUpslafYIzH3
ONNMofBzI8t3femSWcwJsWxKNkGk5DFQUhYgRle0kUYXH13/whEDdN7OMG+Yid5G
iHD3/M2bQrsbjllHOsyR9bZmLgODxy2n7pk4hVVlrJm4bUhNX9JZeMcA5YuErUnb
djYe72vQdE5Ob4SSD7hLYvRMaH42v5r31mxLwhn1QAsyWM57JHseBeaJAe/cL3Xd
LHWGAj1Fj4emGsK/as9SLseC7uWcpSm7v29iYiDvRMwNRzy0JVfZjZ0OBUfe2Wh9
UoBdtAuEaX5viphKR5FUZu/mtCLK7naXuz1ddyvdIYPhxLu4d8oDTwCbDj90n9wJ
7mB2a3DgQL/ZkYJRLpkt9AcjAvrtbrkMjLFgJifdNmVuKsb4naZNF0SMnOL/yaX+
P+FDRJN/K13TP5WpX2M5ltoro5sprYc0+JOx9/MUrfPAnwydVE+X9+u5yV6m6Y2M
VFBfcCIZKwc+YDqvt6X368tTUDDtS8uSL4lg4rP3sd9KUneWWyqWQZ4uGT3BySpo
rhopfVh596SRjQVHmioawxqdQH2mEiXNvJ9ZiX1ZGurGNVVDVLkH2unwo8m0HBsf
pliqBCJ/jxY=
=/j97
-----END PGP SIGNATURE-----

--=-aTzus5Smxl0YHvEZoT/Y--

