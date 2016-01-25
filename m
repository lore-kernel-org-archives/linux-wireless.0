Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from narfation.org ([79.140.41.39]:45281 "EHLO v3-1039.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756089AbcAYNHP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jan 2016 08:07:15 -0500
From: Sven Eckelmann <sven@narfation.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Simon Wunderlich <sw@simonwunderlich.de>
Subject: Re: [PATCH] mac80211: Parse legacy and HT rate in injected frames
Date: Mon, 25 Jan 2016 13:59:02 +0100
Message-ID: <1844534.ZYplpSov4f@bentobox> (sfid-20160125_140719_350170_9AE69829)
In-Reply-To: <1448558726.2167.34.camel@sipsolutions.net>
References: <1444746990-17526-1-git-send-email-sven@narfation.org> <1448558726.2167.34.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1935189.q6cxHdMrBz"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1935189.q6cxHdMrBz
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="us-ascii"

On Thursday 26 November 2015 18:25:26 Johannes Berg wrote:
> > We have required the support for rate parsing (legacy + HT) for som=
e
> > tests.
> > It is already known that this may not be the best place to set this=

> > flag
> > (IEEE80211_TX_CTRL_RATE_INJECT) but the main flags field is already=

> > full.
>=20
> It seems you could perhaps put that into struct
> ieee80211_tx_data::flags? Or is it required somewhere outside the
> mac80211 processing?

The flag itself has to be set when the radiotap information is
available+parsed and when the actual rate information calculation shoul=
d
happen.=20

Afaik the ieee80211_tx_data is always a local variable on the stack. Ei=
ther
from=20ieee80211_tx_prepare_skb, ieee80211_tx, ieee80211_xmit_fast or
ieee80211_get_buffered_bc. But the parsing of the radiotap header happe=
ns
before that in ieee80211_monitor_start_xmit. And after that it calls
ieee80211_xmit -> ieee80211_tx. So tx_data is definitely not available =
when
the radiotap header is parsed.

> Otherwise I think the place is fine? What issue do you have with it?
>=20
> > There is also the problem that powersave could overwrite the rate
> > control
> > fields - so either we disable powersave queueing or find a differen=
t
> > solution.
>=20
> I have no idea what you mean? The flag - as you have it now - should =
be
> preserved, no? Perhaps if you moved the flag into tx_data then it
> wouldn't be, and that's a good argument for not moving it?

I was under the impression that the PS could write in part of the
ieee80211_tx_info union which would be in conflict with the control par=
t. But
I've just rechecked the source and could not find anything like that.

> > But maybe this feature is also not wanted anymore in the mac80211
> > driver.
>=20
> Well, I'm open to adding the code if you need it. Could consider VHT =
as
> well, I guess.

I personally don't have VHT hardware which would support injected frame=
s with
self chosen rates. So I cannot test VHT rate injection.

> Adding the check to the fast-xmit path seems neither right nor
> necessary though, since that shouldn't get invoked for injection to
> start with?

Ok, will be removed and I resent it as v2.

Kind regards,
=09Sven
--nextPart1935189.q6cxHdMrBz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCgAGBQJWphwWAAoJEF2HCgfBJntGOIMP/jdcifferEHTlh5kDhl6Q2Go
AL/vTt8vy1NFRRiiXkqUskcZA01GEMotLQaBxe2Xf4LQ5hhdwqTYUHBe5z63CbNm
2EsQdaQ11duYQBP/Y9jYS3BL9JiL7zdYuBmcGUgy8q0yTe3242wYBfcptP9ZSymk
f/3dLD3D9U+78i9Ye33mcRIAXy/YkTj9rCdgY2GvSJnY1pb+Ab3fCW/qy9pEtEVg
OowWiquiOXVCMx0jyJrAGhyeJKMkWBXbqICwUPlRaOeVJOdbpP/7dRCAdC7lVq6P
2+3cN82mY/vgzCXCOoky292D+HC4OlTKpU8qlsWkLjWDRf20CNtexDGj3tzWLeAr
kCvR8CfXd7DD2EH76nhn847CtjpvCukrsumLYBnHN5+pypxJ+ux7ACxUKI/syhMj
UJw9h5TnWLmu/KnpX0gby5LMmins02uaNmCAh/nmr3fCYpIkYrQQz5RoHA/wpFfI
KQ3SbXVUYvUjbS60fTKO93f6t7wqr+mwht4rUKApNGWdjDkEV1c/c0b7+Hxx0dYE
g+LFXMk7reR+X0oosPwV5uFhTmzN4AEbbw4XcsuQJcefOp/UPApKOKriw4WmBuj1
kglF+GMnhhmz+nlZNvbSD4nuArFiOie78tSWI/4lUyPy+PI1yajj4r9qm1sxVRq7
KHAYXFr5gkNOd26EXy24
=XVyB
-----END PGP SIGNATURE-----

--nextPart1935189.q6cxHdMrBz--

