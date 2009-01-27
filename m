Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:57304 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752989AbZA0KiZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jan 2009 05:38:25 -0500
Subject: Re: [RFC/RFT 7/7] mac80211: fix aggregation timer lockups
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: mcgrof@gmail.com, Sujith.Manoharan@atheros.com, tomasw@gmail.com
In-Reply-To: <20090126184925.913285565@sipsolutions.net> (sfid-20090126_195210_632069_4B727768)
References: <20090126184740.036240879@sipsolutions.net>
	 <20090126184925.913285565@sipsolutions.net>
	 (sfid-20090126_195210_632069_4B727768)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-T6aNF9b1PzXnlA1kMEys"
Date: Tue, 27 Jan 2009 11:38:16 +0100
Message-Id: <1233052696.4012.27.camel@johannes.local> (sfid-20090127_113830_055395_2D3856FD)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-T6aNF9b1PzXnlA1kMEys
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-01-26 at 19:47 +0100, Johannes Berg wrote:
> plain text document attachment (019-mac80211-fix-agg-timer.patch)
> As far as I can tell, there are possible lockups because both the RX
> session_timer and TX addba_resp_timer are del_timer_sync'ed under
> the sta spinlock which both timer functions take. Additionally, the
> TX agg code seems to leak memory when TX aggregation is not disabled
> before the sta_info is freed.

Ok, so... this cannot _currently_ happen because the timer code looks up
the STA again, and that lookup will return NULL when the STA is being
destroyed. But that's entirely bogus, so I'll fix it up differently.

johannes

--=-T6aNF9b1PzXnlA1kMEys
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJfuQWAAoJEKVg1VMiehFYFjMP/1nTZrJXbtBBbWAP3+efTIlA
ZHBvo4kIGbzzOlsWrm5w4k4JbIcq91oWoW5Mz22Rj4dkQTHVnQdaDo7DmY0QBOmh
gm6jHOJXnJT9iPcV/kImUjk8peFSo4MSOFSkq6QVWlP4LgUu6/8kP3ApmFK6VATW
3t6mwUsoi8ohqXdsNTdhRZgepBOpWBMUmjmwNbxGHtpDcAWe6+euaVWBfCMK8Ews
rGyz7TO6CbOauwveOdwfzuUDdNqSkpcWtGZsz6lPExypOniDS+XUSdzoixTb5oV2
S2yXEMMFWs3mHGTC6o0qizR0yZOOa2/KDIc/Sc1yabfZymsTE5MgkLaefRonQUsW
EOhkXr6QWsbjvv42znzHyvslgWF3Agd0LuAHoXvBb6rwXEgn2darXqedCzn5f8cp
3GvoZvs5ObL14FeAAstRiomoy8u7QOM+S5Q5yvIO7IZQ6RiEzZpMTAtdcn86dZkd
vAO91MkHQWH+RwRnO19yl8lq8QEFR2rjsnA1RAA4ue4tbL/d4a4I/s4w2ti6LQmi
A4kAEyaFfHPui6mErImfcjGaKerF8MN6YRSZlLSmue4VbMPlT6ZeHEfS3dnOfx/u
p8hG4s8lfviqsrS2v53OPedmbvU0EiiF9KEjki1WU/8Qj4nh0syozCDyHixbTRNi
D4Pocren3S2n/cRjHl0x
=hIZd
-----END PGP SIGNATURE-----

--=-T6aNF9b1PzXnlA1kMEys--

