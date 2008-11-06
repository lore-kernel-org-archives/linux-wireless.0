Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:50779 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753467AbYKFLBA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Nov 2008 06:01:00 -0500
Subject: Re: Thoughts about mac80211 client PS implementation
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kalle.valo@nokia.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <877i7hkgpn.fsf@nokia.com>
References: <87k5bhkjf1.fsf@nokia.com>
	 <1225917235.3619.180.camel@johannes.berg> <87fxm5ki6s.fsf@nokia.com>
	 <1225919146.3619.190.camel@johannes.berg>  <877i7hkgpn.fsf@nokia.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-+Qo8BS7JDgp1tDCixg3B"
Date: Thu, 06 Nov 2008 12:00:59 +0100
Message-Id: <1225969259.3619.202.camel@johannes.berg> (sfid-20081106_120106_811231_EB10DE82)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-+Qo8BS7JDgp1tDCixg3B
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-11-05 at 23:25 +0200, Kalle Valo wrote:


> > Well if you add a monitor interface you may want to turn off PS,
>=20
> Ok, now I got it. I think your proposal makes sense.
>=20
> > but I suppose you can just do that on the wlan0 interface you're
> > associated on.
>=20
> Yeah, but that's an extra hassle. In my opinion better to do it in
> mac80211.

Yeah but you don't _always_ want it, I'd like to keep a monitor mode
that doesn't influence the operation at all and just shows what mac80211
is getting from the driver. Hence thinking a monitor flag would be
appropriate.

> > Hmm. I suppose then we'd have to defer the actual disable PS mode to
> > a work struct.
>=20
> Yes, that's what I was thinking. But now that I have thought about
> this more, I think queueing of the frames is not necessary. The first
> frames can be sent while in Power Save mode (ie. PSM bit set in Frame
> Control) and PS disable can happen later when the work struct is
> scheduled. I don't think this being a problem, we just have to be
> careful with race conditions.

We may need to send a nullfunc frame then.

> > Maybe we don't want to disable PS for a single frame though
>=20
> Actually I think we do. The reason why I'm interested in dynamic PS is
> the receive latency (transmit latency minimal is in practise). For
> example, let's think about DNS request. In the best scenario only one
> frame is transmitted, and if we don't come out receiving the reply to
> the dns request will take a long time. If DTIM is 3 and beacon
> interval 100 ms, the RTT for the DNS request/reply would be 300 ms.
> That's a long delay to a case where user has pressed a link in the
> browser and the browser starts to load a web page.

Good point. So set my M to 1 and N to 0 ;) Well, in that case you don't
need a timer at all but can just schedule the work right away.

johannes

--=-+Qo8BS7JDgp1tDCixg3B
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJEs5nAAoJEKVg1VMiehFYRsAP/i6Mzw9O2WvVsNwrYBISvhaF
BIUcYZpwg8zvsbvlo3KlCVemTXbsx/vs2omEYcbUh5aatpq98P8wKEIdgrEA63ay
fM+LMLTW0pUSwPPA4h7WLXOv3LVvhqVO49BqAUzzdoKMx2FG/aBrgJjzVGsTW2hY
INq+G/WoiUKX642oWF1S+8WXhK36nnodxm0OrEjzfuHE6+E1Ruq8kRTrVjRxQcmh
UxEavszKYVRQ8V6I0g+TZEGeU+q01CoNoGNOl+8ZskvYmcaWLqzVn7VjsRZPaVz1
1JwlD2xcUmDJJtNniJPd37Ixw6m0oYvPQbxgj2AxK9ARTLW0NcJozATXinExj5Ru
vn6FY4iPu0hst+bCIbKat3v1xOh7NPhMafnQ282fqZoxGAcSL6mdYBl3oTIhsBuR
gaRLCJ+AbmzEcLtuOKKeCOLiibj6ODS6r2pMN2LdlfEMYgnTbXCW2F8znjI/wV4p
mst2PPWSAnA/RmulyAKosaj6qlXeWwwN8Qb9WrBjt2e6jgGZjE/bt9XO1yT0SGAQ
sZJhFl95ZXFh9h+3nlzH4/oVnWI33vmxkHtWv9OYHpebYYcQJmcE1jzl9HCrhhwU
F8FCnIRYSMqbnkFqWclFt9UhSDbOtawBNtIKZWgC49W6MNYIbFhTwyVQDLyKsJYw
2SxiFvIBzddrHeVQzrFF
=mmOz
-----END PGP SIGNATURE-----

--=-+Qo8BS7JDgp1tDCixg3B--

