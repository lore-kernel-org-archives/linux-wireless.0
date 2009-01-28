Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:33286 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761423AbZA1Uwm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Jan 2009 15:52:42 -0500
Subject: Re: [PATCH v3] mac80211: do not TX injected frames when not allowed
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Jouni.Malinen@atheros.com, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <1233111019-7827-1-git-send-email-lrodriguez@atheros.com>
References: <1233111019-7827-1-git-send-email-lrodriguez@atheros.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-KZrQ7e4CMNY3t3IXNffA"
Date: Wed, 28 Jan 2009 21:51:58 +0100
Message-Id: <1233175918.16048.41.camel@johannes.local> (sfid-20090128_215306_709506_0AC27B63)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-KZrQ7e4CMNY3t3IXNffA
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-01-27 at 18:50 -0800, Luis R. Rodriguez wrote:
> Monitor mode is able to TX by using injected frames. We should
> not allow injected frames to be sent unless allowed by regulatory
> rules. Since AP mode uses a monitor interfaces to transmit
> management frames we have to take care to not break AP mode as
> well while resolving this. We deal with this by allowing compliant
> APs solutions to inform mac80211 if their monitor interface is
> intended to be used for an AP by setting a cfg80211 flag for the
> monitor interface. hostapd, for example, currently does its own
> checks to ensure AP mode is not used on channels which require radar
> detection. Once such solutions are available it can can enable this
> flag.

> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>

Acked-by: Johannes Berg <johannes@sipsolutions.net>

if you fix the indentation here:

> +	 * Since AP mode uses monitor interfaces to inject/TX management
> +	 * frames we make AP mode the exception to this rule as its
> +	 * implementation can deal with radar detection by itself.
> +	 */
> +	if (!(sdata->u.mntr_flags & MONITOR_FLAG_AP_MGT) &&
> +	   (chan->flags & (IEEE80211_CHAN_NO_IBSS |
> +	   IEEE80211_CHAN_RADAR |
> +	   IEEE80211_CHAN_PASSIVE_SCAN)))
> +		goto fail;

to indent like this:

if (...
    (chan->flags & (.. |
                    .. |
                    ..)))

johannes

--=-KZrQ7e4CMNY3t3IXNffA
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJgMVqAAoJEKVg1VMiehFYVHQP/0Q76m4/nkNjxONZ4NFnmpbK
mHNlsQtJvRd0fj4NmN+CRKLeYwIXvYeLXF9Re49hnCDSr7igyQoaoTIV895aXHI5
s9Y1il3i9k0UDHvzI7m6rPc88MwDtZmlDJ4kXvf9zTMfEfJVReSsLtJoZQiNX1YA
r1nilbwzDhar57QKro8Q5ktTy6kv+9YsHEREP27vWRsDF7ZoVIHCHLN+R/8GmCiH
3/Qhn1ulmrX9ihL33u5VgLlDrFduyBIw15JUC9ZP8Dqr5gELZiSLVGB5kKjjGWkK
w8ki5JcVHMVBT7WUeYSLRSYVkm/CQjhY+6NMb3zcL61yXwVKKi0dYxVbeVu+j8zp
PODWgW8hbn59ZwdRJvlv+c5fcrBNB5B0u8uJU6loUOrgF5rDQTX882r1EhlMQ6RQ
FyEThu470MIe6dGTRKB1hw5J6FAWdM3P29BMLRlrcP6C+J/5CbLH1NH5A71ANjXJ
QXpWgIWnF0ayR8x8NW/cRc+wMPNL8RwaiYc9G4wVLp/Xm84XHqyunBHzIO+hqY89
wx+eNtSX1SHz5fHaQoc9VhRCANsmkIkJnhJkadAPqHhtupiAoY1GKghP52yqYSt+
TbZ+GO5YQzBb/7rHvam2i4E7cXFJy8+aAg32HFiwxFazVLf9K/PKOPu/ARxrbk4m
vumQ3bUcKRFq2dKR1lbQ
=sQFA
-----END PGP SIGNATURE-----

--=-KZrQ7e4CMNY3t3IXNffA--

