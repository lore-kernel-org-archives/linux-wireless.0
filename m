Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:59078 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755296AbYCYPbH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Mar 2008 11:31:07 -0400
Subject: Re: mac80211: stale BSS info in sta_bss_list
From: Johannes Berg <johannes@sipsolutions.net>
To: Vladimir Koutny <vlado@work.ksp.sk>
Cc: linux-wireless@vger.kernel.org, Vladimir Koutny <vlado@ksp.sk>,
	Dan Williams <dcbw@redhat.com>
In-Reply-To: <47E25BBB.50304@work.ksp.sk> (sfid-20080320_124338_240100_71A87504)
References: <47E25BBB.50304@work.ksp.sk>
	 (sfid-20080320_124338_240100_71A87504)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-6LZt2gIt2gcNZLiN1gYX"
Date: Tue, 25 Mar 2008 15:30:13 +0100
Message-Id: <1206455413.16475.277.camel@johannes.berg> (sfid-20080325_153111_709437_8FA03AD6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-6LZt2gIt2gcNZLiN1gYX
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> My HW I'm working on doesn't really behave, and it can't tx anything
> unless it is associated to an AP. So, it can't send probe requests, just
> listen to beacons initially. Except for worse scan results, not really
> an issue.
>=20
> Now, since sta_bss_list is never cleaned up, once I do a proper active sc=
an,
> entries for BSSes found will get bss->probe_resp flag set. If I bring the
> interface down and back up (ie, can't send out probe request once again),
> I'm not able to scan (or join) any of those networks, since we prefer
> stored probe response info to that of beacons (ieee80211_rx_bss_info;
> bss->last_update won't be updated on beacon either). And finally,
> ieee80211_sta_scan_result will skip expired BSSes, so even it can receive
> beacons for such networks, they won't be reported back to the user.

Bit odd, it seems that at least the probe_resp flags should all be
cleared as soon as we disassociate or so. Not really sure though.

> So, my question is whether this is being worked on (didn't find any note
> on this), and if not, what would be the best place to put this to? (I'm n=
ot
> that familiar with mac80211 internals, so any input on this is kindly
> welcome).

I'm not aware of anybody working on this. It seems that some expiry
code, if added, should live in ieee80211_sta.c.

> In my case, clearing the list on ifdown/up would help, but periodic
> cleanup would be better, so I'd better go that way (or maybe both).

It seems things should at least be expired from that list since we don't
export the info to userspace after IEEE80211_SCAN_RESULT_EXPIRE jiffies,
and imho then shouldn't use it any more either. Dan?

> Then, having bss->last_update being updated also by beacons might be a
> good idea, otherwise we would expire probed networks, right?

I think the issue with proberesp vs. beacons is about more than this,
but it seems that indeed we should keep an entry alive if we get beacons
for it.

johannes

--=-6LZt2gIt2gcNZLiN1gYX
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR+kMdKVg1VMiehFYAQJDehAAtT+Un+CujQlRwxbJFP7sMyYwiiiXDBzW
3gD9z6/3UzSQaUOq/XFl0uoniY+2Jmnp0w5174urYZx3H+XlhE7TMKvL05CYa/01
rhR8UwvERKlTB5QVnRNI18aAP/FJoyF7aqo2zvRiCEc0jw5sdV1yiylAucsj68ET
v+PHZHb9ajIQ3+NNWu5OTB+Ju/G2dTp9vGFfVk6enfJZcjQ/bzzjJ/K8w+GfmtXX
rLxQwCe00C9ENfHV8vgBZj1KtP0VAHBw1awKEDUdlQl2jpEoJwFQW4g6ok6ElkLG
/3uUNfQTw2hJsxvU5y7KwdGjT4xE9fR9IE0wW3aA4B3iIPmfp8ggFKaYM46MIXUY
uSWz2MS/KDf8lTHeNh05UIm2xdOobL+e3siicuyaIKkrK5YOrEQnrBvc2zapFem7
hE2yG50ITc/kgjl8H70tQgCGwucc8b7D1fPTm9ShnvXE3Wf3M+JCwx+vTZb2jmmq
hBVVhuEUtv+5jTc67naKbKCZfbpsxpD0i6wo9AG0T0sxnR3LhiOWvhH9g4/l3eWu
X7avjjPbQjsvJR78+OMe6flM0nf12phTzOnl0Emy18hSaHbUNKUDrvN2VYP8JKq9
Q7+2Um8PqpzEu5Dbg/8Ph8iWy7a9pTB2PHd9ESM4eolGMrR4g39HFgQU4QMUKM+A
X7XqK21C/C8=
=52+d
-----END PGP SIGNATURE-----

--=-6LZt2gIt2gcNZLiN1gYX--

