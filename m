Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56775 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756246AbZBTRHC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Feb 2009 12:07:02 -0500
Subject: Re: [PATCH 3/5] cfg80211: Add AP beacon regulatory hints
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, marcel@holtmann.org, kalle.valo@nokia.com,
	kyle@mcmartin.ca, linux-wireless@vger.kernel.org
In-Reply-To: <1235109874-3966-4-git-send-email-lrodriguez@atheros.com>
References: <1235109874-3966-1-git-send-email-lrodriguez@atheros.com>
	 <1235109874-3966-4-git-send-email-lrodriguez@atheros.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-XAk4E2P273AkIjAp8UTu"
Date: Fri, 20 Feb 2009 18:06:50 +0100
Message-Id: <1235149610.4023.76.camel@johannes.local> (sfid-20090220_180708_625380_7AA2638B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-XAk4E2P273AkIjAp8UTu
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-02-20 at 01:04 -0500, Luis R. Rodriguez wrote:

> +/**
> + * regulatory_hint_found_beacon - hints a beacon was found on a channel
> + * @wiphy: the wireless device where the beacon was found on
> + * @beacon_chan: the channel on which the beacon was found on
> + * @gfp: context flags
> + *
> + * This informs the wireless core that a beacon from an AP was found on
> + * the channel provided. This allows the wireless core to make educated
> + * guesses on regulatory to help with world roaming. This is only used f=
or
> + * world roaming -- when we do not know our current location. This is
> + * only useful on channels 12, 13 and 14 on the 2 GHz band as all other
> + * channels are already enabled by the world regulatory domain (channels
> + * 1-11); and on non-radar 5 GHz channels.
> + */
> +extern int regulatory_hint_found_beacon(struct wiphy *wiphy,
> +					struct ieee80211_channel *beacon_chan,
> +					gfp_t gfp);

Remove the extern please; also, you don't need to export this function
in a public header file, reg.h should be fine.

johannes


--=-XAk4E2P273AkIjAp8UTu
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJnuMnAAoJEKVg1VMiehFY3k0P/jTfijw8JlUUtjJYR3UUcKJf
sVjwvXmL7Id06OJWwUEBUdj/+PA0z7FTnAJkHZohNvXS3jZZDz9hDv0Pjkgs1SIT
nj1tdkncbcvQPzQLv1VRxZDDyjX/qqw0PGiqKeBWtc8DGbzNVj9uD2swQSTlk3uV
UfBdEFxXA+ViB7MPeWnvG2FBVqh4QKSQCnM4XVkDFhyNw1SccBp24qjsEW8NT9hp
kgw20ghgwzvnAP1wSHhjAvwbpJZnOqyil3LRkf0gIM2/GOf9PoP16LXLmECfRrHt
UzxoFNAzAT+SoMgqEuJizUVhMuzL2IbbJI7kWIo6jFHOvG9imRhYC0WX9uwWvruL
oSIANHCoPbcIWQuW1uu8t3BJ8oltlwfKXvRI+FSn+eSPbtDc2IODT5z7G3/nc/tk
cVznx3wy6wIX/xdqn+XbVtTTxJqiKzbiKfHf8ZNPUB8kV0gbyAwGm7YLDbe8csod
qKKePQ7pATFYW7Ir0BjsmxGRB3BEzC053iJA5jm/6muhQQbtHILv6gYriExVqs6V
/h4q8ToN+m2hT14oPUuwWZWaZFH67wMR5vEHUMp1qEZCxiuvrZajegB1FtrgOTKw
cjDVMkX3CEv/ZKQu4YREWMScCVmLZSNQZ+DEEWkSEv5zBYr3OBeAXZvSNURIZz3y
IYhbPylwwJYq221IAR5N
=4GZO
-----END PGP SIGNATURE-----

--=-XAk4E2P273AkIjAp8UTu--

