Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:46821 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015AbYJaWL0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Oct 2008 18:11:26 -0400
Subject: Re: crash with rt61pci when resuming with card ejected
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <200810312301.39373.IvDoorn@gmail.com> (sfid-20081031_230144_974979_F1DE2616)
References: <1225361553.3690.3.camel@johannes.berg>
	 <200810312031.03314.IvDoorn@gmail.com>
	 <1225489644.3550.0.camel@johannes.berg>
	 <200810312301.39373.IvDoorn@gmail.com>
	 (sfid-20081031_230144_974979_F1DE2616)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-TY2ZJY+VhJ9TRXVFZe8a"
Date: Fri, 31 Oct 2008 23:11:25 +0100
Message-Id: <1225491085.3550.5.camel@johannes.berg> (sfid-20081031_231130_336085_F719DB19)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-TY2ZJY+VhJ9TRXVFZe8a
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-10-31 at 23:01 +0100, Ivo van Doorn wrote:

> > Now it crashes in config_pairwise_key or something like that, I can sen=
d
> > you the image if you want.
>=20
> No need. :)
> I assume mac80211 calls set_key() to disable all hardware keys when
> ieee80211_unregister_hw() is being called. I'll cook up a patch to catch
> that as well.

Yep, that's it, it does it by way of turning off all interfaces,
removing all stations etc. Of course, if it would implement
suspend/resume properly then it would have removed the keys already
before suspend and be putting them back at resume...

johannes

--=-TY2ZJY+VhJ9TRXVFZe8a
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJC4KKAAoJEKVg1VMiehFYiVYP/j2cUZeX5/IyF8VbCZezahUg
JCQ+TN2g2p4htv0HNjLALexfHRks/z+SbOTdj8ZFb+7jDJk11UT38gTBl4fJpFE8
yDOl2SlqY6iezXpQ9uiVJELlN2QwfxT0g/SUU7lW1MJKw91+Md9iOHKU+UXpNMd3
SIRMI3QH3CcLPZrf64w6AUcBkOcVqga6hXREu5Acl+yCYsLGuHQ8RAYwkf8kVKbG
xRHdiOwCrrz34cx3q6/gh3357xQa0Fb2vMm0QvlMmEBlUHWoyDTwSexSowOuRRX5
UuMcvemleTpyM6mbRpvwto9PnAN2OKvJs+jYluyOQ2zNahaE3oi2rUYFwms5x7TO
nhaGIUA7CzQcljzg6CUlU+UwPrBB6H/brlq1p1HRHEsO5hiAg5a7KBYBp7QXaMiO
geXV9r5QIpGd7UB48pLl8VHJZIhiJbS53EY+7nVJ3IYwKaJa5GI0KBQu7Z3ZzP52
flxA0PKzIGEwhwuNqRzyj1GKT2V7V3zHZ/QLAkgt7XTE/bt1/LV6SYwE+pcjFodm
Lxmz9L3iOcYNw5tdgCoryOyiFIPiJsPsTLWumaOfkyJh/K4R/wXX0MDaLZHTJSnH
P6XKLSUEAKvRiHlClt0GTlgwDNsr4AWQIiG6TAAVbp461CjOHyDXbRUdLrVhjNzt
QTs0Jz4meEwgexMtYxCy
=5dSI
-----END PGP SIGNATURE-----

--=-TY2ZJY+VhJ9TRXVFZe8a--

