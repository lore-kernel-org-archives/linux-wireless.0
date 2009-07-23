Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:57261 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751897AbZGWKh6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jul 2009 06:37:58 -0400
Subject: Re: [PATCH 3/7] mac80211: introduce a new scan state "decision"
From: Johannes Berg <johannes@sipsolutions.net>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <20090723101355.5147.26099.stgit@localhost.localdomain>
References: <20090723100732.5147.73989.stgit@localhost.localdomain>
	 <20090723101355.5147.26099.stgit@localhost.localdomain>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-rFdswkcdcK3QbJmOVn0M"
Date: Thu, 23 Jul 2009 12:37:25 +0200
Message-Id: <1248345445.19121.21.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-rFdswkcdcK3QbJmOVn0M
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-07-23 at 12:13 +0200, Helmut Schaa wrote:
> Introduce a new scan state "decision" which is entered after
> every completed scan operation and decides about the next steps.
> At first the decision is in any case to scan the next channel.
> This shouldn't introduce any functional changes.
>    =20
> Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> ---
>=20
>  net/mac80211/ieee80211_i.h |    2 +-
>  net/mac80211/scan.c        |   40 ++++++++++++++++++++++++++------------=
--
>  2 files changed, 27 insertions(+), 15 deletions(-)
>=20
> diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
> index 6a01771..4166418 100644
> --- a/net/mac80211/ieee80211_i.h
> +++ b/net/mac80211/ieee80211_i.h
> @@ -678,7 +678,7 @@ struct ieee80211_local {
>  	int scan_channel_idx;
>  	int scan_ies_len;
> =20
> -	enum { SCAN_SET_CHANNEL, SCAN_SEND_PROBE } scan_state;
> +	enum { SCAN_DECISION, SCAN_SET_CHANNEL, SCAN_SEND_PROBE } scan_state;
>  	struct delayed_work scan_work;
>  	struct ieee80211_sub_if_data *scan_sdata;
>  	enum nl80211_channel_type oper_channel_type;
> diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
> index db122e4..48f910a 100644
> --- a/net/mac80211/scan.c
> +++ b/net/mac80211/scan.c
> @@ -376,7 +376,7 @@ static int ieee80211_start_sw_scan(struct ieee80211_l=
ocal *local)
>  	}
>  	mutex_unlock(&local->iflist_mtx);
> =20
> -	local->scan_state =3D SCAN_SET_CHANNEL;
> +	local->scan_state =3D SCAN_DECISION;
>  	local->scan_channel_idx =3D 0;
> =20
>  	spin_lock_bh(&local->filter_lock);
> @@ -474,18 +474,27 @@ static int __ieee80211_start_scan(struct ieee80211_=
sub_if_data *sdata,
>  	return rc;
>  }
> =20
> -static int ieee80211_scan_state_set_channel(struct ieee80211_local *loca=
l,
> -					    unsigned long *next_delay)
> +static int ieee80211_scan_state_decision(struct ieee80211_local *local,
> +					 unsigned long *next_delay)
>  {
> -	int skip;
> -	struct ieee80211_channel *chan;
> -	struct ieee80211_sub_if_data *sdata =3D local->scan_sdata;
> -
>  	/* if no more bands/channels left, complete scan */
>  	if (local->scan_channel_idx >=3D local->scan_req->n_channels) {
>  		ieee80211_scan_completed(&local->hw, false);
>  		return 1;
>  	}
> +
> +	*next_delay =3D 0;
> +	local->scan_state =3D SCAN_SET_CHANNEL;
> +	return 0;
> +}
> +
> +static void ieee80211_scan_state_set_channel(struct ieee80211_local *loc=
al,
> +					     unsigned long *next_delay)
> +{
> +	int skip;
> +	struct ieee80211_channel *chan;
> +	struct ieee80211_sub_if_data *sdata =3D local->scan_sdata;
> +
>  	skip =3D 0;
>  	chan =3D local->scan_req->channels[local->scan_channel_idx];
> =20
> @@ -505,7 +514,7 @@ static int ieee80211_scan_state_set_channel(struct ie=
ee80211_local *local,
>  	local->scan_channel_idx++;
> =20
>  	if (skip)
> -		return 0;
> +		return;
> =20
>  	/*
>  	 * Probe delay is used to update the NAV, cf. 11.1.3.2.2
> @@ -520,13 +529,13 @@ static int ieee80211_scan_state_set_channel(struct =
ieee80211_local *local,
>  	if (chan->flags & IEEE80211_CHAN_PASSIVE_SCAN ||
>  	    !local->scan_req->n_ssids) {
>  		*next_delay =3D IEEE80211_PASSIVE_CHANNEL_TIME;
> -		return 0;
> +		local->scan_state =3D SCAN_DECISION;
> +		return;
>  	}
> =20
> +	/* active scan, send probes */
>  	*next_delay =3D IEEE80211_PROBE_DELAY;
>  	local->scan_state =3D SCAN_SEND_PROBE;
> -
> -	return 0;
>  }
> =20
>  static void ieee80211_scan_state_send_probe(struct ieee80211_local *loca=
l,
> @@ -547,7 +556,7 @@ static void ieee80211_scan_state_send_probe(struct ie=
ee80211_local *local,
>  	 * on the channel.
>  	 */
>  	*next_delay =3D IEEE80211_CHANNEL_TIME;
> -	local->scan_state =3D SCAN_SET_CHANNEL;
> +	local->scan_state =3D SCAN_DECISION;
>  }
> =20
>  void ieee80211_scan_work(struct work_struct *work)
> @@ -593,10 +602,13 @@ void ieee80211_scan_work(struct work_struct *work)
>  	 */
>  	do {
>  		switch (local->scan_state) {
> -		case SCAN_SET_CHANNEL:
> -			if (ieee80211_scan_state_set_channel(local, &next_delay))
> +		case SCAN_DECISION:
> +			if (ieee80211_scan_state_decision(local, &next_delay))
>  				return;
>  			break;
> +		case SCAN_SET_CHANNEL:
> +			ieee80211_scan_state_set_channel(local, &next_delay);
> +			break;
>  		case SCAN_SEND_PROBE:
>  			ieee80211_scan_state_send_probe(local, &next_delay);
>  			break;
>=20
>=20

--=-rFdswkcdcK3QbJmOVn0M
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKaD1gAAoJEODzc/N7+QmaKPgP/jVwSRQn6Y5kT4yHq7Gv/RAU
AClswSwaxSmtGk1AR7be27dYgw7XsjHz0w3ogQh3U9hTvYnSkC2LdYu1cukrpJjS
aBpFpFaOXMewkyA0B6pW2bPDHqpNKTQfCPC/6HiiYnZ4LcYCUl7asF9sWI/B+hiG
xXVr9MT52jj4I+yNXWRVq0pSNvlopiTxicYmDG4Zh9JDWOSacECBMJj/dLT2DXQV
+Dv7tAh6w6mNPEWA636l1L6D4aHKDgXzDpWWjRtUmYOaSESuJ6+3LUwMOeOwU+q3
6DrUUAIY64I9gZfPdoCNF36BUicqwQqtav/1G9jQT6NEm6StWUG/XtN9J9QuQlB+
u5izzW7OiBJ6WoEU+7TkrrybIWU2SS3ve5bfrdvQ94aqVT5O0mAbvKlCnLFKvGXC
9ocC7ER8gbvTufTbruWXSfcEiK4wKddTc2SPumSWOvoTFjuhqlOfzNXs8WOLAamb
p1hkMjMMQGOl+/0fXSfVjxbFFd6jfMQsIn1p2jgxzVOVd63UlDj2gZGfqigq6OJR
aWGw1Yp/y+n1C2ypXfGXyWO0niy1UAmIuJIgPSeAGE8hYLWyLIBFkWeKraxob85O
5UVSzXtnNQDkNCf1vT/A/IMPposPGgm6FeA05yKB0/aOnZHZMNyYXFZ92MJOn5ji
ZGziz0XTK+LwbmUJroLO
=n/Lu
-----END PGP SIGNATURE-----

--=-rFdswkcdcK3QbJmOVn0M--

