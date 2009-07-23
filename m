Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:57246 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188AbZGWKgu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jul 2009 06:36:50 -0400
Subject: Re: [PATCH 1/7] mac80211: refactor the scan code
From: Johannes Berg <johannes@sipsolutions.net>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <20090723101340.5147.17700.stgit@localhost.localdomain>
References: <20090723100732.5147.73989.stgit@localhost.localdomain>
	 <20090723101340.5147.17700.stgit@localhost.localdomain>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Agmb81BelwMXC2grLM/V"
Date: Thu, 23 Jul 2009 12:36:07 +0200
Message-Id: <1248345367.19121.19.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Agmb81BelwMXC2grLM/V
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-07-23 at 12:13 +0200, Helmut Schaa wrote:
> Move the processing of each scan state into its own functions for better
> readability. This patch does not introduce functional changes.
>=20
> Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> ---
>=20
>  net/mac80211/scan.c |  136 +++++++++++++++++++++++++++++----------------=
------
>  1 files changed, 78 insertions(+), 58 deletions(-)
>=20
> diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
> index 7482065..71500f1 100644
> --- a/net/mac80211/scan.c
> +++ b/net/mac80211/scan.c
> @@ -474,13 +474,87 @@ static int __ieee80211_start_scan(struct ieee80211_=
sub_if_data *sdata,
>  	return rc;
>  }
> =20
> +static int ieee80211_scan_state_set_channel(struct ieee80211_local *loca=
l,
> +					    unsigned long *next_delay)
> +{
> +	int skip;
> +	struct ieee80211_channel *chan;
> +	struct ieee80211_sub_if_data *sdata =3D local->scan_sdata;
> +
> +	/* if no more bands/channels left, complete scan */
> +	if (local->scan_channel_idx >=3D local->scan_req->n_channels) {
> +		ieee80211_scan_completed(&local->hw, false);
> +		return 1;
> +	}
> +	skip =3D 0;
> +	chan =3D local->scan_req->channels[local->scan_channel_idx];
> +
> +	if (chan->flags & IEEE80211_CHAN_DISABLED ||
> +	    (sdata->vif.type =3D=3D NL80211_IFTYPE_ADHOC &&
> +	     chan->flags & IEEE80211_CHAN_NO_IBSS))
> +		skip =3D 1;
> +
> +	if (!skip) {
> +		local->scan_channel =3D chan;
> +		if (ieee80211_hw_config(local,
> +					IEEE80211_CONF_CHANGE_CHANNEL))
> +			skip =3D 1;
> +	}
> +
> +	/* advance state machine to next channel/band */
> +	local->scan_channel_idx++;
> +
> +	if (skip)
> +		return 0;
> +
> +	/*
> +	 * Probe delay is used to update the NAV, cf. 11.1.3.2.2
> +	 * (which unfortunately doesn't say _why_ step a) is done,
> +	 * but it waits for the probe delay or until a frame is
> +	 * received - and the received frame would update the NAV).
> +	 * For now, we do not support waiting until a frame is
> +	 * received.
> +	 *
> +	 * In any case, it is not necessary for a passive scan.
> +	 */
> +	if (chan->flags & IEEE80211_CHAN_PASSIVE_SCAN ||
> +	    !local->scan_req->n_ssids) {
> +		*next_delay =3D IEEE80211_PASSIVE_CHANNEL_TIME;
> +		return 0;
> +	}
> +
> +	*next_delay =3D IEEE80211_PROBE_DELAY;
> +	local->scan_state =3D SCAN_SEND_PROBE;
> +
> +	return 0;
> +}
> +
> +static void ieee80211_scan_state_send_probe(struct ieee80211_local *loca=
l,
> +					    unsigned long *next_delay)
> +{
> +	int i;
> +	struct ieee80211_sub_if_data *sdata =3D local->scan_sdata;
> +
> +	for (i =3D 0; i < local->scan_req->n_ssids; i++)
> +		ieee80211_send_probe_req(
> +			sdata, NULL,
> +			local->scan_req->ssids[i].ssid,
> +			local->scan_req->ssids[i].ssid_len,
> +			local->scan_req->ie, local->scan_req->ie_len);
> +
> +	/*
> +	 * After sending probe requests, wait for probe responses
> +	 * on the channel.
> +	 */
> +	*next_delay =3D IEEE80211_CHANNEL_TIME;
> +	local->scan_state =3D SCAN_SET_CHANNEL;
> +}
> +
>  void ieee80211_scan_work(struct work_struct *work)
>  {
>  	struct ieee80211_local *local =3D
>  		container_of(work, struct ieee80211_local, scan_work.work);
>  	struct ieee80211_sub_if_data *sdata =3D local->scan_sdata;
> -	struct ieee80211_channel *chan;
> -	int skip, i;
>  	unsigned long next_delay =3D 0;
> =20
>  	mutex_lock(&local->scan_mtx);
> @@ -515,65 +589,11 @@ void ieee80211_scan_work(struct work_struct *work)
> =20
>  	switch (local->scan_state) {
>  	case SCAN_SET_CHANNEL:
> -		/* if no more bands/channels left, complete scan */
> -		if (local->scan_channel_idx >=3D local->scan_req->n_channels) {
> -			ieee80211_scan_completed(&local->hw, false);
> +		if (ieee80211_scan_state_set_channel(local, &next_delay))
>  			return;
> -		}
> -		skip =3D 0;
> -		chan =3D local->scan_req->channels[local->scan_channel_idx];
> -
> -		if (chan->flags & IEEE80211_CHAN_DISABLED ||
> -		    (sdata->vif.type =3D=3D NL80211_IFTYPE_ADHOC &&
> -		     chan->flags & IEEE80211_CHAN_NO_IBSS))
> -			skip =3D 1;
> -
> -		if (!skip) {
> -			local->scan_channel =3D chan;
> -			if (ieee80211_hw_config(local,
> -						IEEE80211_CONF_CHANGE_CHANNEL))
> -				skip =3D 1;
> -		}
> -
> -		/* advance state machine to next channel/band */
> -		local->scan_channel_idx++;
> -
> -		if (skip)
> -			break;
> -
> -		/*
> -		 * Probe delay is used to update the NAV, cf. 11.1.3.2.2
> -		 * (which unfortunately doesn't say _why_ step a) is done,
> -		 * but it waits for the probe delay or until a frame is
> -		 * received - and the received frame would update the NAV).
> -		 * For now, we do not support waiting until a frame is
> -		 * received.
> -		 *
> -		 * In any case, it is not necessary for a passive scan.
> -		 */
> -		if (chan->flags & IEEE80211_CHAN_PASSIVE_SCAN ||
> -		    !local->scan_req->n_ssids) {
> -			next_delay =3D IEEE80211_PASSIVE_CHANNEL_TIME;
> -			break;
> -		}
> -
> -		next_delay =3D IEEE80211_PROBE_DELAY;
> -		local->scan_state =3D SCAN_SEND_PROBE;
>  		break;
>  	case SCAN_SEND_PROBE:
> -		for (i =3D 0; i < local->scan_req->n_ssids; i++)
> -			ieee80211_send_probe_req(
> -				sdata, NULL,
> -				local->scan_req->ssids[i].ssid,
> -				local->scan_req->ssids[i].ssid_len,
> -				local->scan_req->ie, local->scan_req->ie_len);
> -
> -		/*
> -		 * After sending probe requests, wait for probe responses
> -		 * on the channel.
> -		 */
> -		next_delay =3D IEEE80211_CHANNEL_TIME;
> -		local->scan_state =3D SCAN_SET_CHANNEL;
> +		ieee80211_scan_state_send_probe(local, &next_delay);
>  		break;
>  	}
> =20
>=20
>=20

--=-Agmb81BelwMXC2grLM/V
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKaD0UAAoJEODzc/N7+Qma5UUQAJybliFloaPoTtXEHn4xUaYv
XDRqphd8vv51JbEkwbwzhPf7z01B20QadR8+96U5AxAooN1Gco2lD1jMI8+Pc09i
3ZbAavJVae53JOaT0Mxcut18RzWrPAndxPgomhG1XG3FOWrO1LVNlElAiB45P/8Z
9FQ8ql9U5+Cv17G75F9vvCXMYtjAMBDXtG9BQfy0SyHVCGa4Ue5jlOcAda+zim/C
99KWLsOapPi5Tw4Ype5Pkxb+cMHZj9FsWGwc6Yp/qymo6f3jXhi2Ea+Xg+LAnIiH
RytCxcCRvMvsbh+EY9/5vWJySNSv0WKemzjXdtD4navqFaSk6/vqKzHbAfrCEk7o
HA3uRnB7+Vzoq/pdLwCkfS8OCo9VxOYYaJOtdXv4kxOR+tgHvdaq8nOoMag1k81o
DsxfDJTJ1d0Y2awDswnO/WelJHu8De4eEyuCikTahqoEHHraGMPAU7H+vwwOrino
dZuZ93gyAPcWZmXtohwZ1a83wA+qt3QggGsgYdEkEmuezLRrZuFCp3wHEOFJXWc+
ZjHpZceHHPnvAKK7/30d3Nwj0Wflcynp/eGtxEE8PeeQ/DuYcLc1S3yLkUx/jgc4
LRpe2ygJb58V/D1qbtei21PjgbvEroAuya6Pi1uxpng0H6F3TjIRCdvydxhlpTOC
h4Dg47LLMEJKPpf/gLB5
=hS70
-----END PGP SIGNATURE-----

--=-Agmb81BelwMXC2grLM/V--

