Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:45744 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754887AbZEMJxk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 May 2009 05:53:40 -0400
Subject: Re: [RFC v2 2/5] mac80211: inform devices when we are suspending
 on the stop callback
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1242206461-30793-3-git-send-email-lrodriguez@atheros.com>
References: <1242206461-30793-1-git-send-email-lrodriguez@atheros.com>
	 <1242206461-30793-3-git-send-email-lrodriguez@atheros.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-wD126mYjPn/IIZvlKCI/"
Date: Wed, 13 May 2009 11:53:08 +0200
Message-Id: <1242208388.14227.46.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-wD126mYjPn/IIZvlKCI/
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-05-13 at 05:20 -0400, Luis R. Rodriguez wrote:
> We inform the drivers so they can take appropriate actions during
> suspend for WoW support.

> -static void ar9170_op_stop(struct ieee80211_hw *hw)
> +static void ar9170_op_stop(struct ieee80211_hw *hw, bool suspend)

Why just a 'suspend' bool? Why not pass the WoW information in here,
instead of adding a new config and stuff for it? WoW information is only
relevant during suspend.

The way you have it, a driver needs to
 * keep track of the wow config
 * check whether a stop is due to suspend
 * apply wow config during stop

If you passed the wow config in some struct to _stop() [and NULL if not
for wow] then the driver would only need to

 * check if for wow and apply config during stop

johannes

--=-wD126mYjPn/IIZvlKCI/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKCph/AAoJEODzc/N7+QmarP8P/2gKsQSPrEtiHWy38znePVL4
hHILcGayVYnesnRtHq4FHRPNKGK/iPD44b/hP4F1ENbeVG/y/JZmCTqRE13aaeS3
BXCYaZjgCDFl/zovxzdsYMAqEpuZqf3JJ4hsHxhTnALkk/d97KD3mjzNABsShh6A
MBcIc4UpXYwJ25+QcnH4ylnwOrIbpTTq0NgRoe8t0oZez66+gDjFQrVxJJZB4AZW
lvCTvKXpCY26/QKtbHUD/GtLuBKs4nhROk3xvFvTVPhzTNNZnqXHWdh7Au5+Pv9d
IoTgwFET2hyqXwmY/hK59W9tSTI+EW6kssR+bgX70oLDt7+8c7NlQbwZUgWKSmo6
wxSfGaMOE6vka+q4u2LUyXdtPjomux8LanFwRMB8q+2schfU+++WpMF0xiJsDQv5
J1wmB/z6M/jrgUugFmcCHojuBuu+14CjtggTw+HSPRrElTp7TlUYpZjqXOlbW2v6
KQQir2LSyCCMrhqMAWtnCNw/CVJXZME7mTEAZySs1ZDp8soRkwjKVwurCr2geXVQ
/KDTxNoQFUWXITGHkW3WPoGKQLkr4Av0rIS60I/lDOzuvtzvka+j8myXdb87KKdI
C7BenIcuCxg/A0d7ClE+kSD48WRV5GExdjMsNol8futy60qh7LxQM+5Z+sc+0buv
pXCEQIOp2pSfN7Y86GYL
=db2q
-----END PGP SIGNATURE-----

--=-wD126mYjPn/IIZvlKCI/--

