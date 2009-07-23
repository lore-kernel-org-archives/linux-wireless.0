Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35564 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752652AbZGWKkN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jul 2009 06:40:13 -0400
Subject: Re: [PATCH 6/7] mac80211: rename scan_state to next_scan_state
From: Johannes Berg <johannes@sipsolutions.net>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <20090723101420.5147.71489.stgit@localhost.localdomain>
References: <20090723100732.5147.73989.stgit@localhost.localdomain>
	 <20090723101420.5147.71489.stgit@localhost.localdomain>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-nQIarItmzYw/G2uFT/xq"
Date: Thu, 23 Jul 2009 12:39:25 +0200
Message-Id: <1248345565.19121.24.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-nQIarItmzYw/G2uFT/xq
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-07-23 at 12:14 +0200, Helmut Schaa wrote:
> Rename scan_state to next_scan_state to better reflect
> what it is used for.
>    =20
> Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> ---
>=20
>  net/mac80211/ieee80211_i.h |    2 +-
>  net/mac80211/scan.c        |   20 ++++++++++----------
>  2 files changed, 11 insertions(+), 11 deletions(-)
>=20
> diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
> index efda19e..c6b25cb 100644
> --- a/net/mac80211/ieee80211_i.h
> +++ b/net/mac80211/ieee80211_i.h
> @@ -715,7 +715,7 @@ struct ieee80211_local {
>  	int scan_channel_idx;
>  	int scan_ies_len;
> =20
> -	enum mac80211_scan_state scan_state;
> +	enum mac80211_scan_state next_scan_state;
>  	struct delayed_work scan_work;
>  	struct ieee80211_sub_if_data *scan_sdata;
>  	enum nl80211_channel_type oper_channel_type;
> diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
> index d56b9da..b376775 100644
> --- a/net/mac80211/scan.c
> +++ b/net/mac80211/scan.c
> @@ -374,7 +374,7 @@ static int ieee80211_start_sw_scan(struct ieee80211_l=
ocal *local)
>  	}
>  	mutex_unlock(&local->iflist_mtx);
> =20
> -	local->scan_state =3D SCAN_DECISION;
> +	local->next_scan_state =3D SCAN_DECISION;
>  	local->scan_channel_idx =3D 0;
> =20
>  	spin_lock_bh(&local->filter_lock);
> @@ -505,15 +505,15 @@ static int ieee80211_scan_state_decision(struct iee=
e80211_local *local,
>  		 * next channel
>  		 */
>  		if (associated)
> -			local->scan_state =3D SCAN_ENTER_OPER_CHANNEL;
> +			local->next_scan_state =3D SCAN_ENTER_OPER_CHANNEL;
>  		else
> -			local->scan_state =3D SCAN_SET_CHANNEL;
> +			local->next_scan_state =3D SCAN_SET_CHANNEL;
>  	} else {
>  		/*
>  		 * we're on the operating channel currently, let's
>  		 * leave that channel now to scan another one
>  		 */
> -		local->scan_state =3D SCAN_LEAVE_OPER_CHANNEL;
> +		local->next_scan_state =3D SCAN_LEAVE_OPER_CHANNEL;
>  	}
> =20
>  	*next_delay =3D 0;
> @@ -545,7 +545,7 @@ static void ieee80211_scan_state_leave_oper_channel(s=
truct ieee80211_local *loca
> =20
>  	/* advance to the next channel to be scanned */
>  	*next_delay =3D HZ / 10;
> -	local->scan_state =3D SCAN_SET_CHANNEL;
> +	local->next_scan_state =3D SCAN_SET_CHANNEL;
>  }
> =20
>  static void ieee80211_scan_state_enter_oper_channel(struct ieee80211_loc=
al *local,
> @@ -577,7 +577,7 @@ static void ieee80211_scan_state_enter_oper_channel(s=
truct ieee80211_local *loca
>  	__clear_bit(SCAN_OFF_CHANNEL, &local->scanning);
> =20
>  	*next_delay =3D HZ / 5;
> -	local->scan_state =3D SCAN_DECISION;
> +	local->next_scan_state =3D SCAN_DECISION;
>  }
> =20
>  static void ieee80211_scan_state_set_channel(struct ieee80211_local *loc=
al,
> @@ -621,13 +621,13 @@ static void ieee80211_scan_state_set_channel(struct=
 ieee80211_local *local,
>  	if (chan->flags & IEEE80211_CHAN_PASSIVE_SCAN ||
>  	    !local->scan_req->n_ssids) {
>  		*next_delay =3D IEEE80211_PASSIVE_CHANNEL_TIME;
> -		local->scan_state =3D SCAN_DECISION;
> +		local->next_scan_state =3D SCAN_DECISION;
>  		return;
>  	}
> =20
>  	/* active scan, send probes */
>  	*next_delay =3D IEEE80211_PROBE_DELAY;
> -	local->scan_state =3D SCAN_SEND_PROBE;
> +	local->next_scan_state =3D SCAN_SEND_PROBE;
>  }
> =20
>  static void ieee80211_scan_state_send_probe(struct ieee80211_local *loca=
l,
> @@ -648,7 +648,7 @@ static void ieee80211_scan_state_send_probe(struct ie=
ee80211_local *local,
>  	 * on the channel.
>  	 */
>  	*next_delay =3D IEEE80211_CHANNEL_TIME;
> -	local->scan_state =3D SCAN_DECISION;
> +	local->next_scan_state =3D SCAN_DECISION;
>  }
> =20
>  void ieee80211_scan_work(struct work_struct *work)
> @@ -693,7 +693,7 @@ void ieee80211_scan_work(struct work_struct *work)
>  	 * without scheduling a new work
>  	 */
>  	do {
> -		switch (local->scan_state) {
> +		switch (local->next_scan_state) {
>  		case SCAN_DECISION:
>  			if (ieee80211_scan_state_decision(local, &next_delay))
>  				return;
>=20
>=20

--=-nQIarItmzYw/G2uFT/xq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKaD3aAAoJEODzc/N7+Qmalf4P/3gGtK0hXVVXJ88621A02oYt
mh6E6a5SbfoZSVhk/qdoZkXpgFt4vmQV64PPRkIg86Qe79HQH1Gyf8uNeKP8ICBS
wJVKKit33fh7aEcEv9FWTY1AyPBGD86leXGRcVuWziW7JG+OBqXidFwYgm/ZcWcp
u2p4ETMl916wjzNY6OrMu7JAfk/XRimT2NHiQIn7Np4LD0RGhSN6/LdKIRmJbvau
tJfNhoo2VOEPXyCD/NhrW7Bc+vPUmMb6jK7ZXoihHdnVWhRPBEFzm+Un7fAakMN8
qV95EKIxWtRmGN4wKvg5prtBNFIGi5qNt+QHJLvczTqmW6NTK54aX6QcSjsz2sNM
Lq2WZQeuLSdrIZ2RNThkdPNt5JwJr4RgZns12lsT7uYfYJsIE8IPLLdnBSeoR9OS
mHuBzpVEgE6DYOxxPc4RpcEQ3i6n73YON4OWFQJoju0UzIJMJzb+OdvV3sCIrLUu
974wvjfggqiB417KUpNei5E3jDN2tU/4/WO9BAMrFCrByOjUAZXRF21RzjGmHt3+
LScedCyAOUKVbs6CR2ASw2a4NmCMwkhIlB1b0wvh9w2pT4NegBN0KN+Gs+q6iShJ
OBHMF9Eu7whtPlJBCyx6MXe7e0aPTuy/V0yqIH1Odw/DX+eplzWHQA0eVSExodD5
a5EG57ySdjGsyjd0NjDV
=OSqp
-----END PGP SIGNATURE-----

--=-nQIarItmzYw/G2uFT/xq--

