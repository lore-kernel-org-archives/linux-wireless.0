Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:45583 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063AbZL1QzH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Dec 2009 11:55:07 -0500
Subject: Re: [PATCH V2] mac80211: quit addba_resp_timer if Tx BA session is
 torn down
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhu Yi <yi.zhu@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1261990635-29016-1-git-send-email-yi.zhu@intel.com>
References: <1261990635-29016-1-git-send-email-yi.zhu@intel.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-avfJPheNNbDZ9SgkhngN"
Date: Mon, 28 Dec 2009 17:54:57 +0100
Message-ID: <1262019297.22470.6.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-avfJPheNNbDZ9SgkhngN
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-12-28 at 16:57 +0800, Zhu Yi wrote:
> Make addba_resp_timer aware the HT_AGG_STATE_REQ_STOP_BA_MSK mask
> so that when ___ieee80211_stop_tx_ba_session() is issued the timer
> will quit. Otherwise when suspend happens before the timer expired,
> the timer handler will be called immediately after resume and
> messes up driver status.

Want to reference the bug report still?

In any case

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> Cc: Johannes Berg <johannes@sipsolutions.net>
> Signed-off-by: Zhu Yi <yi.zhu@intel.com>
> ---
>  net/mac80211/agg-tx.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
>=20
> diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
> index ceda366..a57bd73 100644
> --- a/net/mac80211/agg-tx.c
> +++ b/net/mac80211/agg-tx.c
> @@ -179,7 +179,8 @@ static void sta_addba_resp_timer_expired(unsigned
> long data)
> =20
>  	/* check if the TID waits for addBA response */
>  	spin_lock_bh(&sta->lock);
> -	if ((*state & (HT_ADDBA_REQUESTED_MSK | HT_ADDBA_RECEIVED_MSK)) !=3D
> +	if ((*state & (HT_ADDBA_REQUESTED_MSK | HT_ADDBA_RECEIVED_MSK |
> +		       HT_AGG_STATE_REQ_STOP_BA_MSK)) !=3D
>  						HT_ADDBA_REQUESTED_MSK) {
>  		spin_unlock_bh(&sta->lock);
>  		*state =3D HT_AGG_STATE_IDLE;


--=-avfJPheNNbDZ9SgkhngN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLOOLTAAoJEODzc/N7+QmauksP/1Q1pS+VhciJ9l1j0/E12TIC
glJNaHIBN8HZ1JX/TUt8o26y3mwBemxzp3+z172zLne31BbRobpI9i6NvMUOA1Qc
JKXJlV5Brgy+tX+SrgAnLMHVXRVgD87jeXkjGkLnV/IIUSAq95HWh1FmRk6h6IqH
zRiKf0nmhF6R2YlMsMB58wxqbemldH6JH/XGIi7/7YfEQ93M74niCcoIhZEEIwP7
dTNekaWXDD2xbSGX2FSNTNG5jyPzPXN5fvYuBRlp+gaNimP2bIviEKlw0I05LX0l
9d64xNMevXiT0sZ2DIvlf6BReo7S4Jl3bsQF32th+12bPLKdatgYpkLMU9kh4bDK
XSh+16/EqaAdZ2WqXx3QSkcPYxF3WcGcB85USQjn6j9oKz0tTNV65/oZP5qALtR9
fpS7kjDCv4AJQenGiS8I2ZjCrWQJWsdtthBKqii4Ty0AQy47pucDkFsrANaMDUen
gXoK7PumnvUg7IL9vZ8f1H76HY8LvHQEv7I6qZnuUnNrFBFNfV4X3cOd7bZH/5tM
T5mkHpzbFTSlb2EU3vhlE6ZiL3w1IURmVBdavK/wHwEFwx/bPbOju/nA2g6R1iIw
pw/sImTpbsWfDX+UQOVvi+ul987ozLea70egKxjy+w6+GrP+seMrl1a16tHDzRyd
9RoRyJZ4EapadWwYlL7W
=QLuC
-----END PGP SIGNATURE-----

--=-avfJPheNNbDZ9SgkhngN--

