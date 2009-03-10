Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41719 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753096AbZCJHPf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Mar 2009 03:15:35 -0400
Subject: Re: [PATCH 3/4] mac80211: disallow HT40 if max channel bandwidth
	is less than 40 MHz
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1236650699-30538-4-git-send-email-lrodriguez@atheros.com>
References: <1236650699-30538-1-git-send-email-lrodriguez@atheros.com>
	 <1236650699-30538-4-git-send-email-lrodriguez@atheros.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-dIbBKTd7ABrcVPk8mpTh"
Date: Tue, 10 Mar 2009 08:15:29 +0100
Message-Id: <1236669329.9658.30.camel@johannes.local> (sfid-20090310_081557_056920_FEDA374C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-dIbBKTd7ABrcVPk8mpTh
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-03-09 at 22:04 -0400, Luis R. Rodriguez wrote:
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> ---
>  net/mac80211/util.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
>=20
> diff --git a/net/mac80211/util.c b/net/mac80211/util.c
> index 32610a0..a891d7e 100644
> --- a/net/mac80211/util.c
> +++ b/net/mac80211/util.c
> @@ -796,6 +796,9 @@ int ieee80211_set_freq(struct ieee80211_sub_if_data *=
sdata, int freqMHz)
>  	if (!chan || (chan->flags & IEEE80211_CHAN_DISABLED))
>  		return ret;
> =20
> +	if (conf_is_ht40(&local->hw.conf) && chan->max_bandwidth < 40)
> +		return ret;
> +

You just made nl80211 check this, why bother adding it here too?

johannes

--=-dIbBKTd7ABrcVPk8mpTh
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJthOOAAoJEKVg1VMiehFY3/MQAKyHOrJ1ow1DZbHBKQMPJvTP
sClCDfkKaPahZNoo3gA6iccfSIO74wm5wv6nxdntM+rtFJ/rMY6px1/MqUH7e1z1
xxiwvpEDOdQtWdp/wgKwdKbrdtZ1OXU3eugyZJwe6Xtc5CekGLZ1xiyQuO9BkyUV
2aTOMKxD5QxEyGMdOctbT3tldDaOZ2dRxST8+7afm041JqvspwUJBpKAGgoCpA+l
FwrqB7QdLhH24QIxx6e6fvZmIcZcCViKYeCPepTx8wF/kLNAMiEzSBRs2PPMEoBf
17kla1XTeHtftBVXmkmoYfy4NXYJA3OC5Cw32zxOJZuG2WptUhNo8z1lz74VlNsq
MMvN2lGT416QX09f0plZO/HRonjwc8COTMRDtGAx9Gd5wEzwERfoeTvJsoLHQZsj
cAwwkZADJ2tB2TWSwkotnINxxVZPFt9ibRuxWgoU5pFdLZOUKkYLb4EjAglVWRa/
zPza+o2a+syUfxE31qsQMDG4u/acyrmkb1i9wBbfO7F3lQw/kBVP4cLJ6HfhCxvW
TQWr85JbX6kU6U0wGEHLbPgBwo5MKm+wuSZHLudbLCrsYIq0Qakg9JEM3rsLKlr2
BzrmxgkNKbH8tWQ9538onYvQZmE692gOj76xhhKvUJ6b/seZgCgMNoGqvRwA9ekg
tVDFNAzDiL7fksBUARsq
=TJHp
-----END PGP SIGNATURE-----

--=-dIbBKTd7ABrcVPk8mpTh--

