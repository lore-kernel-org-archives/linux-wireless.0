Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:44377 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755260AbXK0NMb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2007 08:12:31 -0500
Subject: Re: mac80211: unencrypted packet vulnerability
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Michael Wu <flamingice@sourmilk.net>,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <20071127040536.GF5698@jm.kir.nu>
References: <1195686097.6323.22.camel@johannes.berg>
	 <20071127040536.GF5698@jm.kir.nu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-CwReZXcOA0qX0uaXn0cf"
Date: Tue, 27 Nov 2007 14:12:17 +0100
Message-Id: <1196169138.6058.7.camel@johannes.berg> (sfid-20071127_131234_611228_8C93C833)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-CwReZXcOA0qX0uaXn0cf
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > The reason is that ieee80211_rx_h_drop_unencrypted() drops unencrypted
> > frames, but only if "sdata->drop_unencrypted" is set which never
> > happens!
>=20
> Hmm.. What happened to the original code that had (rx->key ||
> rx->sdata->drop_unencrypted)?

Hmm. Yes, that'd help. Seems that got lost at some point. I'll take a
look and fix it up.

> I thought it did.. By the use of rx->key here, not by use of
> drop_unencrypted. Anyway, like I said, drop_unencrypted is an extra
> layer of security, so having possibility of using it may be nice safety
> net should something else go wrong in the RX logic.
>=20
> > Considering the AP case, on the other hand, hostapd will need to be abl=
e
> > to set the setting since we don't actually look into the beacon it tell=
s
> > us to transmit. But hostapd on the other hand doesn't even invoke the
> > iwauth ioctl! I have to admit to being rather confused.
>=20
> The Devicescape version of hostapd did.. I do not remember why this was
> not merged, but I would assume it was just something that I never got to
> and since it was using a private ioctl for setting the parameter that
> option already disappeared. Sure, it would be reasonable to add support
> for it now that the parameter is available with WE-18.

I think I did a patch already. I need to review all my patches and post
those that are appropriate.

johannes

--=-CwReZXcOA0qX0uaXn0cf
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR0wXsKVg1VMiehFYAQJmDA/9G/W7LHrfJiFOEkkuznxL1LqWQufr8FRf
RPF+GN4bBFLoxRkRGFrOnusbZMetR1HtkupuqeR8WIB1XMbrSkJ+I37Ok7kCAUVn
OimNSx7sloS9FSHn8fk2Q+Naj6/6R7N+lmHDY4W+UO3c8uogqAhwEX27W723ia55
HDQ4nN5Op3L1gPitgQ8DNlV/tzGpe3nxFIZlszhVG3Z7MPeonmj/CzgBKAg/Xyr+
ngAnvsj8q1KqpCAAhGrgL35jLk/r40WvLfdsUlLadprYb0TTF/b13jfsGBbwHgzm
x/leHE0mjHzR+W4aVNSl/1boV8zIsmiN6srHPVjQsMuutWDp6bBhJG1ztsvVuzar
5lBLbHIm1vQgTaTwGbgNNfpyqL0Q2ZLF6Q1MdAZTAv7N7Xwz1vrJsyfdYwudV5KF
ZFe5nSmQUUVke9GTeUC5D+XCaRO+9nnnBsb9nEId0gSk2sJ1ePJ0CNwuVzlGjc41
+xcyNVK1uuFU4rs6r5W9q70mPk0zG4JAGgjtFo9dAecfys8jFYTBvdhLpuJTedvN
IioU/OupuraKlsq7Rao3sqUfR+khunV/fp2YBgTFA9GKVulo0CL+SRDvEGl7K/uv
keWs7mnRhqZF1WJalF7HxjNZn3Tz+2cWrxR1nZOzbKz1c/NpoSdVkT5J2Gvsko7W
VPKS94zcHPc=
=eI/Z
-----END PGP SIGNATURE-----

--=-CwReZXcOA0qX0uaXn0cf--

