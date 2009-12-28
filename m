Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58273 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302AbZL1ISq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Dec 2009 03:18:46 -0500
Subject: Re: [PATCH] mac80211: delete addba_resp_timer when stop Tx BA
 session
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhu Yi <yi.zhu@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1261970308-22926-1-git-send-email-yi.zhu@intel.com>
References: <1261970308-22926-1-git-send-email-yi.zhu@intel.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-NZC4z03glyI969nKtO6Y"
Date: Mon, 28 Dec 2009 09:18:32 +0100
Message-ID: <1261988312.22470.5.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-NZC4z03glyI969nKtO6Y
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-12-28 at 11:18 +0800, Zhu Yi wrote:
> We start an one shot addba_resp_timer in ieee80211_start_tx_ba_session
> but don't delete it in __ieee80211_stop_tx_ba_session. This will cause
> problem in suspend and resume. When suspend happens without the timer
> deleted, the timer handler will be called immediately after resume and
> messes up driver status.
>=20
> See http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=3D2134
> comment #22 for more details.

Hmm. The timer checks

        if ((*state & (HT_ADDBA_REQUESTED_MSK | HT_ADDBA_RECEIVED_MSK)) !=
=3D
                                                HT_ADDBA_REQUESTED_MSK) {

which /should/ make it a no-op in the case you mention because we tear
down sessions, or does that not reset their state properly?

Ok, so ___ieee80211_stop_tx_ba_session() doesn't, in fact, clear the
mask right away, so I think we should add HT_AGG_STATE_REQ_STOP_BA_MSK
to the code I quoted above?

In any case the del_timer_sync isn't right there and we also shouldn't
really use it (per Linus)

johannes

> Cc: Johannes Berg <johannes@sipsolutions.net>
> Signed-off-by: Zhu Yi <yi.zhu@intel.com>
> ---
>  net/mac80211/agg-tx.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>=20
> diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
> index ceda366..d122082 100644
> --- a/net/mac80211/agg-tx.c
> +++ b/net/mac80211/agg-tx.c
> @@ -509,6 +509,8 @@ int __ieee80211_stop_tx_ba_session(struct sta_info
> *sta, u16 tid,
>  	u8 *state;
>  	int ret;
> =20
> +	del_timer_sync(&sta->ampdu_mlme.tid_tx[tid]->addba_resp_timer);
> +
>  	/* check if the TID is in aggregation */
>  	state =3D &sta->ampdu_mlme.tid_state_tx[tid];
>  	spin_lock_bh(&sta->lock);


--=-NZC4z03glyI969nKtO6Y
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLOGnUAAoJEODzc/N7+Qma+tgP/iAybfnUvhQdNRCCm5/eoCqJ
4XboFHCN/Ac2MrSNJ7jsKA1NumbniPa4gVizjqLvKNpZSdEsl6dhFPtOoTloipiX
13Aabtrf3//5PcjmAiLmsVsD/vFze/bBAXNqT38H6ST2ByHtLgIDjJ0NMntZJWk3
/TqIKYtgBBkYJ7A4v7eZpTi+79llXAFmlhlhhB3yEkeI3Oyy2oSAFjlxNyG4fzDW
t+tgVE3sfqpkcHILZDO85hjJ7q1UcXFf+HDnrXHlgH7gIQr480ZTJnatf36M3RSV
cGCO1UE/UGegHa5ajDzM1yThqaheB4ojBkNlE5ssFShr5e9/LxXgvAyTX55kX1/C
5ZjBwkMjvZ/+l7MZfFZvYALiGhR9uuJvaGXudHe8iE3VlP6135nFonvKwswdY0lq
Em/wAjfcmQA8bGJ3VmJ+1T7/Jqe0wLDKh78d93fbRljW/5k54irhol89XiPmpObD
6xWnAtMx0Xwrfyb8XsFU9peybMM3TzMHI7C6Q3c/TIQmwrTVbF1pyYy7V6kTdCEk
xbOgmEnz4wux9fxiR7YBZYmj+NkWqy2+bRrDur08MOI0uJs80xkZ1fFrSEwxJs+e
y+rwFCKhKWt3C65MSMwPlMHulabGFhgDUSJ9wAvZbmtwlFKb32B6PVetpoj9z0QS
Po2SzJC8naovFm6LVyZQ
=1Kcg
-----END PGP SIGNATURE-----

--=-NZC4z03glyI969nKtO6Y--

