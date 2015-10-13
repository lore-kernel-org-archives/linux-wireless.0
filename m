Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from narfation.org ([79.140.41.39]:41434 "EHLO v3-1039.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752876AbbJMOqw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Oct 2015 10:46:52 -0400
From: Sven Eckelmann <sven@narfation.org>
To: linux-wireless@vger.kernel.org
Cc: Simon Wunderlich <sw@simonwunderlich.de>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFC] mac80211: Parse legacy and HT rate in injected frames
Date: Tue, 13 Oct 2015 16:40:56 +0200
Message-ID: <1485555.ENrnL3by3J@bentobox> (sfid-20151013_164655_929082_8A0A5CE3)
In-Reply-To: <1444746990-17526-1-git-send-email-sven@narfation.org>
References: <1444746990-17526-1-git-send-email-sven@narfation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1714027.9rfIHlgs7h"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1714027.9rfIHlgs7h
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Tuesday 13 October 2015 16:36:30 Sven Eckelmann wrote:
> Drivers/devices without their own rate control algorithm can get the
> information what rates they should use from either the radiotap header of
> injected frames or from the rate control algorithm. But the parsing of the
> legacy rate information from the radiotap header was removed in commit
> e6a9854b05c1 ("mac80211/drivers: rewrite the rate control API").
> 
> The removal of this feature heavily reduced the usefulness of frame
> injection when wanting to simulate specific transmission behavior. Having
> rate parsing together with MCS rates and retry support allows a fine
> grained selection of the tx behavior of injected frames for these kind of
> tests.
> 
> Signed-off-by: Sven Eckelmann <sven@narfation.org>
> Cc: Simon Wunderlich <sw@simonwunderlich.de>
> Cc: Johannes Berg <johannes@sipsolutions.net>
> ---
> 
> We have required the support for rate parsing (legacy + HT) for some tests.
> It is already known that this may not be the best place to set this flag
> (IEEE80211_TX_CTRL_RATE_INJECT) but the main flags field is already full.
> There is also the problem that powersave could overwrite the rate control
> fields - so either we disable powersave queueing or find a different
> solution.
> 
> But maybe this feature is also not wanted anymore in the mac80211 driver.
> 
> Thanks,
> 	Sven

Sorry, this was meant as RFC but accidentally dropped the [RFC] when I
regenerated the patch after fixing a part of the message.

Kind regards,
	Sven
--nextPart1714027.9rfIHlgs7h
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCgAGBQJWHRf4AAoJEF2HCgfBJntGGf0P/3hv/L3BvCddxn1aJKMNRUN4
x5kfa9i1MNjnttVHCoVjShav16c4vFamcXknS1tP7zUwjK5Q9TFVNdxyQjToQFEE
jPksBfNOjpqQhtVt52lPgYIKUSDHW+U+C48oelTMUBu36peruadu+xKlUzIHlW6H
BGSzR4kHdCTouMfB70T70QShsqiDHf9zQG6YqjrsMSx9LTsSG33ZTHX0EuTVVY2F
f7dmlG1R7JHKMlQWh1NXffffCKLe97NqbFV900H9kP/noI40QqVdw0C5EzFp5h9T
x0lFGdZYbY1o/Yb9ozCWNSi+sUIRx6FD8aST/x3q8chSk/wtol6g83z+jPJH47JP
kklO5LXWR0Yi8K9cRiaaD/fuqgHXpqW5q39Tv4sE09S3g70f80YYLVeXYDDGaduO
N7455N8nNxbiUMnfyZGNOmxKVNhj+tYPapW9k5lTlrwxx3aKGfj9c+bfZOfcOyFa
ox4yUtFwDIG6rOyeCae1eL4Yx++hcK8BL/O1erRnETg4ol7r8WuXgFtNEC898aZl
OD2KBKjs4gx64Xd8eE/JHjK+uCyZmMzadXGln21LxrjEGgmHN8eGNdswr5q4sXwV
J3eqT15CtJpzpshYPDqOmp7SwiHcj77NpPwYZFIZATxUl6gmVHrJUofupcY16OV0
04pyb8xZa9yPPwFaRuL6
=BiVE
-----END PGP SIGNATURE-----

--nextPart1714027.9rfIHlgs7h--

