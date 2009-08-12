Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:48333 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753073AbZHLHOR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Aug 2009 03:14:17 -0400
Subject: Re: Roaming behavior
From: Johannes Berg <johannes@sipsolutions.net>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: David Seira <davidseira@gmail.com>, linux-wireless@vger.kernel.org
In-Reply-To: <200908120907.18501.hs4233@mail.mn-solutions.de>
References: <loom.20090811T124332-602@post.gmane.org>
	 <20090811135915.GC2684@tuxdriver.com> <1250003481.4185.7.camel@solid2>
	 <200908120907.18501.hs4233@mail.mn-solutions.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-dDrrI9sC8kLtX8d5m3Mi"
Date: Wed, 12 Aug 2009 09:14:08 +0200
Message-Id: <1250061248.13529.94.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-dDrrI9sC8kLtX8d5m3Mi
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-08-12 at 09:07 +0200, Holger Schurig wrote:

> Some examples: with madwifi, I can tell the driver to only scan=20
> on channels 1,6,11. That's not exactly standards-conforming, but=20
> can speed up roaming considerably, because a full scan is now=20
> way shorter. mac80211 doesn't support such a thing directly. It=20
> just occurs to me that you might be able to do something like=20
> with with a special regulatory daemon.

Or you can just ask wpa_supplicant to do that with -Dnl80211.

> Or with orinoco, you could define a level when to roam (e.g. at=20
> what SNR/RSSI/whatever it is based on). mac80211 doesn't have=20
> this.

The intention is to add signal strength triggers to mac80211/drivers to
notify wpa_supplicant which then implements the algorithm. There are a
ton of algorithms to choose from, so this will be very good for
experimentation, academia and getting the best algorithm eventually :)
Right now you don't have signal strength triggers so you'd have to
monitor the signal strength (like "iw wlan0 link").

johannes

--=-dDrrI9sC8kLtX8d5m3Mi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKgmu8AAoJEODzc/N7+QmafWIQAJ2/BHplrJ1bWmCYgvJIG2oV
HGs+EmgBRlMSq8VJA3XKA3kavxQabLGqxHJYPjPmOtrU3zvTtRKVXBHop4UgXSxz
PPY/yeqpzZl+ZKlDQah+5aC7xf9cfGNk8fWrzupIBKbE3MBrtjkEcrhdR9WujX5i
oHXIcgNjLJXhzw7KJQGPJPd9nTJrC77BNr9AovUzVxx9/VxMQ8lmCiacgooBGvSL
E6DtbZxFAga1hh1wodS8SVr6Q2YG/dWk11smhnyQYQd3610+tr6kCz/J+R9Pzskr
0+KhJvpyHyiTPe55u3sWI3BV1robVQNUWnmBW0/fvKAIsvkMMaDlDLfdgrnFa5e1
ayLG6sHMzKWylTpu1/FqyDyHy5di6+2XtY93zRbIFiUSrrqQ8TG8sReIHAZVhOGE
gTorRwPwliFuwf9zgWVXjiDPJfy657jW6OQkDMlvyP7auaCnoNscH0bhYEb6u0Bo
Fl7ilj0CmdE9wQ+J7OUqDD6Ype0z6vXKnSPz+2TJMd3m3Ks+WQnxn1K3MskNsZvO
o6OC9Y4EqT6YLiCwdlY0YvIwGPRwMuGbrevydFGuI5wB3pzvATZoyhMQUfeqATLR
eW4xeyuDjHwjzsEE1CjqhdBv44CUep8VKfP+FL2FXfDFLFo0OCzUyCrlINbyBubV
imHzwzHJ2TRRp9Dbw9XK
=hEPd
-----END PGP SIGNATURE-----

--=-dDrrI9sC8kLtX8d5m3Mi--

