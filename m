Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:52212 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754023AbYAMVoI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Jan 2008 16:44:08 -0500
Subject: Re: [PATCH 2/2] mac80211: A-MPDU Rx remove stop_rx_ba_session
	warning print
From: Johannes Berg <johannes@sipsolutions.net>
To: Ron Rindjunsky <ron.rindjunsky@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com, yi.zhu@intel.com
In-Reply-To: <12002415431203-git-send-email-ron.rindjunsky@intel.com>
References: <12002415431203-git-send-email-ron.rindjunsky@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Uzd2AXGIC9ZNiuCMViZK"
Date: Sun, 13 Jan 2008 22:43:41 +0100
Message-Id: <1200260621.5887.10.camel@johannes.berg> (sfid-20080113_214411_599887_22B817BC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Uzd2AXGIC9ZNiuCMViZK
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Sun, 2008-01-13 at 18:25 +0200, Ron Rindjunsky wrote:
> This patch removes a warning print from ieee80211_sta_stop_rx_ba_session
> in case the tid is inactive when interface goes down.

Thanks.

> Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> ---
>  net/mac80211/ieee80211_sta.c |    3 ---
>  1 files changed, 0 insertions(+), 3 deletions(-)
>=20
> diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
> index 866eb80..bb73aac 100644
> --- a/net/mac80211/ieee80211_sta.c
> +++ b/net/mac80211/ieee80211_sta.c
> @@ -1215,9 +1215,6 @@ void ieee80211_sta_stop_rx_ba_session(struct net_de=
vice *dev, u8 *ra, u16 tid,
>  	if (sta->ampdu_mlme.tid_rx[tid].state
>  				!=3D HT_AGG_STATE_OPERATIONAL) {
>  		spin_unlock_bh(&sta->ampdu_mlme.ampdu_rx);
> -		if (net_ratelimit())
> -			printk(KERN_DEBUG "rx BA session requested to stop on "
> -				"inactive tid %d\n", tid);
>  		sta_info_put(sta);
>  		return;
>  	}

--=-Uzd2AXGIC9ZNiuCMViZK
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR4qGDKVg1VMiehFYAQLInw/+NmxL8dDmzRnSTgnv1FJB7lqkSQzePOue
LgKidHm7g8nQNVeD674As1QhqBXeQ4AJAuJH0cHfosW9LIqEPR+E5Oci4aUF1JzW
DDSp9zjF4aq8hgrpk47Qar2onL9PsvcDGFPLmJjc0wfwO3B73hSnyD/X/lzIxQR/
Ya+4jiXN+sWWpJ6VeP9JCX14MsG9awXCzqgHAnikSsrjI0pjL4adKw8PE4xnD+4J
2dUM7xrOKvUl0L1A8JD8MOsUfErD9MirzACkwHe4Ki1uQezksTHZHsYKgWxIZdhL
jXDW3RO5ynAxwGfVBPuz6nHJn5MKPrhuuDxihY9X+pQzmDtByKjNmCEcz/87zbSQ
dy1Hf0lF43MbJJVV7iaoTS3U4dZjt2+F6+6JiadduKG5HhpN/sfROXpy7RORm2dC
MOXu22wVvPAterx/1UW0CpeGxLUfppH/ruXrx7FCn9kqzpS4MqpIGewPGjsiw9UA
1LFPssCqJjj+PDMwS6bDHifP3ZbZ89qcVlf6BiwIhqo/EXJac3H7o8EOo3eBEgUo
qxTvdJ9i5t0Yrrqa7ae81MvKFx2Ip5F09vvf1KHRZZw+gIUinSA28lNm4Oej/fn0
R+XsrgLS13QV0Soo0VbGMM+j/i204SQ8T3Hc2A/fWbEA0c/xIuRpSfMr4dffrtBW
iKZr+Jg/2qI=
=HwRe
-----END PGP SIGNATURE-----

--=-Uzd2AXGIC9ZNiuCMViZK--

