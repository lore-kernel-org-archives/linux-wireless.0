Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:55995 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752858AbXKLQqy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Nov 2007 11:46:54 -0500
Subject: RE: [PATCH 05/14] mac80211: adding 802.11n essential A-MPDU
	addBAcapability
From: Johannes Berg <johannes@sipsolutions.net>
To: "Rindjunsky, Ron" <ron.rindjunsky@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	"Winkler, Tomas" <tomas.winkler@intel.com>, flamingice@sourmilk.net
In-Reply-To: <1879838866982C46A9CB3D56BA49ADEB04008797@hasmsx411.ger.corp.intel.com>
References: <1879838866982C46A9CB3D56BA49ADEB04008797@hasmsx411.ger.corp.intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-HpSfS9hdLy4lVAk0nKEa"
Date: Mon, 12 Nov 2007 17:48:11 +0100
Message-Id: <1194886091.5229.66.camel@johannes.berg> (sfid-20071112_164657_354631_9AA9FCBF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-HpSfS9hdLy4lVAk0nKEa
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> Well, aggregation handling is the next step if these patches are
> acceptable... :)

:)

> You are right, A-MPDU is really in the bottom of the data plane
> architecture, so in most cases _creating_ it will be an HW feature,
> while A-MSDU should be implemented in a much higher level place in the
> flow.
> Two reasons why I placed A-MPDU handling in the mac80211:
> - A-MPDU demands a "session" level management (add BACK, del BACK, BAR),
> which looks to me more mac80211 oriented
> - A-MPDU extends the "Access Category" of 11e into "Traffic Identifier"
> (TID) to give finer granularity of frames priority. As mac80211 already
> handles prioritization in wme.c, it looked like a good starting point.

Ok, thanks for the clarification. That means that when you implement
a-mpdu aggregation handling you'll have some way to tell the hardware to
aggregate the next N frames?

> >> +	/* TODO - add here aggregation support */
>=20
> > I think that comment is misleading. We don't add aggregation support
> > here but rather when adding it we must change this code, but anyway.
> > Don't bother.
>=20
> I can remove that, just a reference for development convenience.=20

Nah, it's fine. Or maybe rephrase it a bit if you care.

> > Btw. I'd like to remove code from ieee80211_sta.c rather than add this
> > much. Do you see any way to partition your code differently? The
> > ieee80211_sta.c file is a huge file and barely understandable when you
> > just read it... I was at one time working on extracting the scan code
> > out from it and keep only MLME stuff in there. My goal was to be able
> to
>=20
> As mentioned above - one can treat A-MPDU session as a kind of MLME, so
> this is a rather interesting point. Currently I'll keep the code there,
> and if you see it burdens ieee80211_sta.c just tell me.

Ok, it's fine, I'll look at it a bit more in depth at some other time.

johannes

--=-HpSfS9hdLy4lVAk0nKEa
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARziDyqVg1VMiehFYAQJcLg/9GXjVCue/e9lprEagN+s2smnpqceEEbcg
SVbpHrb1WZxpwuqrWlMIGEGqhio4jdzRb3h3uqDAwF9YP5WmGrAPghj/dH1MR2+K
OT3fg6IPutACSkkn1mEUTbq/ebgZAhVLggH8KoiJWVyQGE9tD9bQGQizZfMghIk/
Rf6Vev9irB2gWcMMGK3qB80b2j8Y9YflWbAYKBfUy1qmg1Pdvj+swpqB24UWxLlN
SD0wSavZyXo+kAPo9LiAqgUqVtRPCFHOe+RtmEo0aq4Z/v8ON9d2oe7IUeeZun0j
wIpeEs1sVYJbb/vPvBP64Ze6H2TsaKHyU/kO+jWUJZBCxqLV/mSQvYn18vMXfjOR
Y8G+VFT3j4jbfBYPFI8CJG7S62J9vTX/QEno25uZrysRDVjlQh3g+JmUQrBLYcja
bkpvTUdRvperBAiYEsBoTRCpJnLwTaMh5UY/VlzHpczDTEoddskDKvYa6dCoWDPb
3cxa+BALpoy1yLHlkxEsAGGZMvXja6wuBpqep6etesrCxWA29lK2txp1VMsXtwu1
Pnh72QRonYbSgA3CGydavYok7C35Z+qxOgFCXJbjDoH1xPAwe/XhO0FwV+9zICwj
fbpDB49hIlL4FbuWQdv2+PoRCeTgpUKHdEWR3t8TKLUwjS6mBJ/WSf9AvQbc5SVo
SvewrDDa6hc=
=ux4j
-----END PGP SIGNATURE-----

--=-HpSfS9hdLy4lVAk0nKEa--

