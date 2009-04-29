Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:48748 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754129AbZD2QLw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Apr 2009 12:11:52 -0400
Subject: Re: [PATCH] mac80211: tell driver when idle
From: Johannes Berg <johannes@sipsolutions.net>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1241018085.4104.4.camel@localhost.localdomain>
References: <1240997537.593.35.camel@johannes.local>
	 <1241015587.997.76.camel@localhost.localdomain>
	 <1241015999.593.62.camel@johannes.local>
	 <1241018085.4104.4.camel@localhost.localdomain>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-zYqR1SFfC8y3h/T7JLyB"
Date: Wed, 29 Apr 2009 18:11:19 +0200
Message-Id: <1241021479.22715.6.camel@johannes.local> (sfid-20090429_181158_321843_D17BD743)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-zYqR1SFfC8y3h/T7JLyB
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

> there can be always a situation where this ends up badly. You tell the
> hardware that it can sleep now, but then you change your mind because
> userspace finally got its act together. Bad luck.

Right.

> My point here is only that if the hardware needs a certain amount of
> time before it makes sense to sleep, it should just tell mac80211 this
> and it should be honored.

I don't really see how that makes sense though. Why would the hardware
"need[] a certain amount of time before it makes sense to sleep"? How
would it not make sense to go to sleep whenever possible, right away,
however long the hardware needs to actually go to sleep then?

Yes, it's possible that the hardware takes a little while to wake up
again, but we can only account for that if we can predict when we need
to wake up again in the future, but we definitely can't. So yes, while
it doesn't make sense to tell the hw we're idle when we will only be
idle for 50ms and the hw needs 30 to go into idle and 30 to get out of
it, I'm not sure how telling it that it needs 30ms will help mac80211.
Going to idle and coming out of it is meant to be synchronous, so
mac80211 will always wait for the driver to finish that operation.

> The default should be that we try how good the hardware can handle
> mac80211 being aggressive with switching to idle. Maybe auth/assoc is a
> special case anyway and we should have a sensible timeout value. We
> could ask userspace to tell use that value when doing auth, but that
> feels kinda ugly to me.

Being idle between auth and assoc probably is a special case, yeah. So
far iwlwifi has handled it just fine for me though, so I'm inclined to
not worry about it too much. Well, with the race fix...

johannes

--=-zYqR1SFfC8y3h/T7JLyB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ+HwkAAoJEKVg1VMiehFYkKcP/1VlVx9w14OV2/q+3zypA0qZ
8ejsxoNdrsIO8LCNI4mjMBuJLj3HDC+pNJKzcxo47CYkJ7ajjS8soyVzZlvAtJ1P
Ob3HuU0VmRRriRSydL9cxgXZCI892Im2eb4bzyw7gTnPXjXw7EHa5r4g68nAult0
kM3KApfr4kzQ8wyfI5NwuSvJJsFlisw/kh1yqPaHqcxI9c415Hgxc27si+8vRtxw
0ilhKPoDqhoaPFu4AKzCk7yvNjMLB/TbdMIu+V9R98RtiEERhInsIFFU1Wj/n5Fv
symGtR4PKiCzvA86ux2CDSgkDADH65kS4lm1JUPdBeR3Dwkb641siK4IyvT+++Tr
fyqjjlZzAJAgX+SO6/v4B/VW2CUGmOJIIvImM324vcPwPjb3+DTxSaAPNLnBYQA9
ab2O1cTlXfOM4qjms/11DWPyY0fPxcGy23cJ5/BMkdjX+fxsNPA9S3Gle6pRkcuY
/Ns4U8cIoPPbnrET1ALTXUIr7efpHxKXMjDHwQdrgHvwQ7LZN79CmtBl6Xlv4JUM
2qq2l30LixgoG7txD9vb37FcNgaVYBgMed+S27ruvRU4JGE67CNHtmFHek3WXoWV
TP3yPZAZDZVs1woEbImvs7hPL5YrxPQA+ZKaTnDmQbuKxPtkJzlX+XbIhJB6JA8B
w2WKddYz/hxE+6wiqBas
=49gZ
-----END PGP SIGNATURE-----

--=-zYqR1SFfC8y3h/T7JLyB--

