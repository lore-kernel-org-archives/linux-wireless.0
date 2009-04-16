Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42400 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752043AbZDPUS5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Apr 2009 16:18:57 -0400
Subject: Re: p54 problem with PS
From: Johannes Berg <johannes@sipsolutions.net>
To: Christian Lamparter <chunkeey@web.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Kalle Valo <kalle.valo@iki.fi>
In-Reply-To: <200904162157.20576.chunkeey@web.de>
References: <1239823495.20927.1.camel@johannes.local>
	 <200904162157.20576.chunkeey@web.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-3lQlyvwcrHGy9TBF6272"
Date: Thu, 16 Apr 2009 22:18:24 +0200
Message-Id: <1239913104.26575.25.camel@johannes.local> (sfid-20090416_221902_904679_D03DD1D2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-3lQlyvwcrHGy9TBF6272
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> Well, I guess I figured out what's wrong: the hw spec.
> So this patch might work on PCI & USB, but could break SPI devices.

Heh.

> Johannes, can you please test the attached patch?
>=20
> BTW: there might be two problems:
> 1. if the timeout is too low the device might be fast enough to go into p=
s:
>   -  either before sending a probe request
>    (firmware reports tx_status TX_PSM, so the frame wasn't sent at all)
>   - or the AP got the request and responded...=20
>     But the frame was lost, because probe responds are not buffered...

?

> 2. there was something wrong in ieee80211_rx_mgmt_beacon
>     Sometimes the TIM was parsed, but thanks to
>     local->hw.conf.dynamic_ps_timeout =3D=3D 0
>     mac80211 didn't issue a wakeup =3D> so no data =3D> disconnect
>=20
>     But this bug maybe comes from the old RFCs from yesterday,
>     as I didn't tried the final version yet...

I didn't change that -- Kalle did that, see the comment there. I guess
we need to change that then.

> Oh and one question:
> Some time ago, I found some useful function that converted beacon_int TUs=
 <-> msec,
> do we still have them somewhere around and I'm just (temp) blind ?

I just added TU -> msec in one of my patches to include/linux/ieee8021.h

johannes

--=-3lQlyvwcrHGy9TBF6272
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ55KNAAoJEKVg1VMiehFYMgcQAJmQWDlhMmikVQz3H5YDSuwr
+n50/piCbUuD80rtnG+MA/K3kYcF/Ye8bAW/aJS4vj3WwZ6SFlLof2c3xoRtLzsS
S1JXfaSF/HKnD0wgr7X5UCDtc9gjudruv6WgQi4hBjoaIva3uaflXJG/38DT3nNR
9WTdQsepm8LhWMa3bKl0nXjI/eT6ouyBLMJSFsyYjGrNi480zXcv+CpK5v7I203M
FD/GQvZDJEpsxG7tbcQ2OGszDtO71UT0eQokvV09o1Kdp7f8ZDjQGaEztfeCxY/o
5Dzz0LWyUqVXS3LAMiqy2SDZOqnZSzxAaTZZ2kkb0Uv84vGhOhTLao+K/3eA+C8O
Zl/BfgbQZzRRehGx1aqoHBVoHfuOX6GMlr+1kae5wAK6fhQq5fVDuibK2Clvbhwk
bvPMU4M7tPCOFlaBM/FudaE4JdG4IE0OfmrGTQHxLhhmXChOlm+TBI6FVQuFQE/Y
me7cAbTlhNqj8xZegKUR7Vvl+YuGSzO+AM0r5pwO4yezBgQsN2mqb9UX0IrMVrjB
mw5u6HTI7D4EM1DvYRJ6iq7C/M0VTlVzCULuMx6fwrkGItCGQTW2X1KhLnrj+Fng
Ly/3xjqzmyXQmg9q1V4dYX5Qb7lKuoQU3vkzXos0NIB947ET0YeTA2uO7Af0fNpP
P8LeLtZpS8dgQ1Pn4UvW
=rMif
-----END PGP SIGNATURE-----

--=-3lQlyvwcrHGy9TBF6272--

