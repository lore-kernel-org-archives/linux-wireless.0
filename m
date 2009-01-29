Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54279 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752779AbZA2PTu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Jan 2009 10:19:50 -0500
Subject: Re: [PATCH] ath9k: Fix LED blink pattern
From: Johannes Berg <johannes@sipsolutions.net>
To: Bob Copeland <bcopeland@gmail.com>
Cc: Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Luis.Rodriguez@atheros.com, Jouni.Malinen@atheros.com
In-Reply-To: <b6c5339f0901290717m760c4704x7f9df7502f772a17@mail.gmail.com> (sfid-20090129_161712_787053_46F15C75)
References: <1233231739-4402-1-git-send-email-vasanth@atheros.com>
	 <b6c5339f0901290717m760c4704x7f9df7502f772a17@mail.gmail.com>
	 (sfid-20090129_161712_787053_46F15C75)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-56hyqxs5I5ZfRzYZRBIE"
Date: Thu, 29 Jan 2009 16:19:40 +0100
Message-Id: <1233242380.4035.12.camel@johannes.local> (sfid-20090129_161953_608348_077C68BE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-56hyqxs5I5ZfRzYZRBIE
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-01-29 at 10:17 -0500, Bob Copeland wrote:

> This is something that has come up from time to time from users for
> ath5k as well.  Half of the drivers now have their own timers for
> turning leds on or off.
>=20
> Can we just add a decent blink algorithm to mac80211?  Right now for
> rx it just toggles every other packet.  For tx, it's slightly smarter
> but not overly so.  It seems like this is one of those things everyone
> wants to do and we could easily make it a standard service.

Define "decent blink algorithm"? But anyway, yes, please do, then we
have a central way of disabling all these timers too. Might need to make
some LED framework changes to figure out whether anything is attached to
an LED to avoid blinking it when nothing is attached?

johannes

--=-56hyqxs5I5ZfRzYZRBIE
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJgckJAAoJEKVg1VMiehFY6WEP/RjZZBEPBGl+V8H1N/AHWLLF
1MLDw0h3KyjvZAAtgFO1Vil383gz3g2oLKUyPj0ap4+Rd+AqPEdheL1Az/uJupLg
tRVyj9AtsLW9FZY8N37YSkAO7wv/CllhqVlg7Omz84wqe3yZfkwmHmS45bdzsViK
WQUFa4ZIS1+cJKgX7dIA0a23JYAdSDuj3dwb1j/7B281zuyRglYgEWE1V/VKbjG0
SvQiH2UePuYVGc/oxh8QNoKxAzVTfS/JrtrklY25mrkeBLAZuLLTikos8jZpR74k
/YNBIXMH7D0H4hj5uGfKqRl7ipPKjM4LdKBgwXDQPTRX57BW+D5+o1aQ6BYjlXYs
aqjGEdcp+9dOPkJ8pYrTbkwtU29j8oHQY1kqv7RA5jPxHqo+Wfu10R9txVvvAqdy
fHDgZ3GidpakxgW3RqQFBSeCxPsV7dactGDkFuYxgvDvH0asHZiHHAMnhmwL52gk
5OV4R6tpB2ASswdN5UbwXu5Wr/0H4bMkzxsCTO2myIieCv5906J4RGErup4FVrbe
+lZ+GZL579w808MI3cyBIP1F+8N7U/wRP7Z4XEa6Ks7a4REOcLRlCRKFy43pHv3M
i+F+qXUtD6Ce5fUfihq+kZGXBfcovfV60P06FCCcr/lmQXAkXejcsF/qbCkGUsQT
Y+gN1gJSrPdlhwcVT6et
=+sje
-----END PGP SIGNATURE-----

--=-56hyqxs5I5ZfRzYZRBIE--

