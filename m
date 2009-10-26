Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35489 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751955AbZJZNwK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Oct 2009 09:52:10 -0400
Subject: Re: RECAP: indication of channel noise
From: Johannes Berg <johannes@sipsolutions.net>
To: Holger Schurig <h.schurig@mn-solutions.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>
In-Reply-To: <200910261442.44774.h.schurig@mn-solutions.de>
References: <200910261442.44774.h.schurig@mn-solutions.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-hY6M07fNmzLqxcreWsjn"
Date: Mon, 26 Oct 2009 14:52:12 +0100
Message-ID: <1256565132.12462.9.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-hY6M07fNmzLqxcreWsjn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-10-26 at 14:42 +0100, Holger Schurig wrote:

> [snip descriptions]

sounds about right

> We did not yet come up with a clear API definition for this. My=20
> idea for an initial "retrieve site survey" response is:
>=20
> NL80211_CMD_NEW_SURVEY_RESULTS
>   NL80211_ATTR_GENERATION
>   NL80211_ATTR_IFINDEX
>   NL80211_BSS_FREQUENCY
>   NL80211_BSS_NOISE_MBM
>=20
> Of course this will extend over time, but that is easy due to=20
> nl80211.

I'm not really happy with having "BSS" in there. And the ifindex is
kinda not necessary either I think, you really want the wiphy index.
Also it's not necessary in the response since the request will contain
the wiphy index (or interface index).

I'd introduce a new
NL80211_CMD_GET_SURVEY_RESULT

which you use together with a dumpit call, for channels, which lists
channels one by one similar to nl80211_dump_scan()/nl80211_send_bss()
but with nl80211_dump_survey()/nl80211_send_survey_channel().

In this case I think a "last updated" value would be rather important
too.

johannes

--=-hY6M07fNmzLqxcreWsjn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK5amJAAoJEODzc/N7+QmabzcP/jLmM2DvxPPdzdwVCK0YHcPd
ZcJh4Yl/yEEWqrr26M6zJaPuruBSDljMdxfrokvH3TbfwKrMP54Bdh5mrJV5aVEz
HYB+L1UbLkbn5U2+ZzNCMYrK7K+C7dnA79tviM2YPuCaSLRIoweErYRzlJWJgJI8
mjkzZKBbrrW4kHK7arqi5+xgqPy/41Q+2c+VmRgL6eY758P2PaHHNIT9CWSaE2ni
80Xi9kS4EA6kxbAfqda6VVE1sEbdSkYDfrrXqcpm809JQ4Cw9t0dJh8jUAW7AKfl
ZNmeGs7H0ZbuUHrOrPa/9TjkWoRjfYV0ep+FwAHpLnWjw8Sjp96DddSVTNIdFht/
QaS9Eg1MyPzBQy47EZGwy0Cr8dAIqnjzmElO1xhRYLmDeys5oHxNIXS0Twdn+ddz
6zXkLvJaH2KdQcDJJzCmgG6bacAWKiIx2/kWT3mtUrHW8N9xq4sf9lDjpYHHDT1G
127Y/9WmD3qqkhl+wv8u2CAXbc+7A2GtWdwyaJa05I8AaKv0oDbYuf7nlEfQEXry
+MXqUsO+apLvKWwoy6D3JRtFmjpmUohBvZt78k0ccrTSWXkrntMFg/mhYtB9l093
s4WwY/ko9jRhPxju1kkE0f0eiuGpae0oJIjYJOcskjffFBESQVXbLfYwf6pM6uYi
PWPSI6lZOQmodvHLh6yQ
=uE50
-----END PGP SIGNATURE-----

--=-hY6M07fNmzLqxcreWsjn--

