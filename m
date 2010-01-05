Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:51550 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821Ab0AEJ0K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jan 2010 04:26:10 -0500
Subject: Re: [RFC] cfg80211: add regulatory hint disconnect support
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1262622502-27698-1-git-send-email-lrodriguez@atheros.com>
References: <1262622502-27698-1-git-send-email-lrodriguez@atheros.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-v0xtDePwll6hHIqbntU3"
Date: Tue, 05 Jan 2010 10:25:54 +0100
Message-ID: <1262683554.20098.10.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-v0xtDePwll6hHIqbntU3
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2010-01-04 at 11:28 -0500, Luis R. Rodriguez wrote:

> +/**
> + * regulatory_hint_disconnect - informs all devices have been
> disconneted

disconnected

> + *
> + * Regulotory rules can be enhanced further upon scanning and upon

Regulatory

> + * connection to an AP. These rules become stale if we disconnect
> + * and go to another country, whether or not we suspend and resume.
> + * If we suspend, go to another country and resume we'll
> automatically
> + * get disconnected shortly after resuming and things will be reset
> as well.
> + * This routine is a helper to restore regulatory settings to how
> they were
> + * prior to our first connect attempt. This includes ignoring country
> IE and
> + * beacon regulatory hints. The ieee80211_regdom module parameter
> will always
> + * be respected but if a user had set the regulatory domain that will
> take
> + * precedence.
> + *
> + * Must be called from process context and hold the cfg80211_mutex.
> + */

However, I don't quite understand why we need this function. We already
tell cfg80211 about disconnect events or requests, can't it call some
regulatory update when either of those two happen?

johannes

--=-v0xtDePwll6hHIqbntU3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLQwWfAAoJEODzc/N7+QmaAa4P/jTtErzaY/clrgWRLOZBri/B
VKe4B6gWUOmoqFoNYnsORyBYh7IWOLlsr9ZQdz+fGQcCesiDv2FgDhzZhaaZ4WtD
eUaWX+9US+q5Y2+ijxHWNnh+DMXcNVPqEFwUUscZkSsgUfv3rmLd5pYjTQFb4LLV
fjForaTTayShQIrFmr3JkRxvQmi3cR78UX84AJdtuJsFOJiTKxJSBqzc64D/Zrkt
eyN5yctLCUtmHFMgizCtM9yOwElNy6x56bMxJevzFqhrshIAnkFqJ4DQUI60LQTa
xbyu6Rz9xc1rMjMylyIfK0kdE9oAy9BsyORyMAcQM69yHI/FjiE1cz+f4T0gclIQ
eVDTgCKZ+tPxih9LTPMLL5tJ0S98IObP27nXCdNr/V3UurcZkzEGkwK31GrP2P+l
la8Zx8PF8mNHEArRGJN24pjO96fvyFGx9gE/FXIzLkUb3Enp2em1n699t+d2Td8e
pOzR8HTyxKd8xnCw45TuRRKFvup+MaMdjrAB13djlZEIg1hogapXYbfgzO+BRDpV
QpALYH1ijRFk6El21Mkd8rD/EYiEOPDeck+iIP9KDM5cLa4tnCXT/GJ77DdWfo+4
pmrK3o4tN2mAxMEKpufN7XI4/btuuIwAZU7qoToENJU0rx4zgfHtb1LXbS88JXUW
4YSqOwQS5JdV8c5K2gAz
=IpKU
-----END PGP SIGNATURE-----

--=-v0xtDePwll6hHIqbntU3--

