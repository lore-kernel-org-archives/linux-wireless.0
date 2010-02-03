Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50700 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754458Ab0BCIoI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Feb 2010 03:44:08 -0500
Subject: Re: [PATCH v2 1/1] mac80211: tear down all agg queues when
 restart/reconfig hw
From: Johannes Berg <johannes@sipsolutions.net>
To: wey-yi.w.guy@intel.com
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1265159851-20682-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1265159851-20682-1-git-send-email-wey-yi.w.guy@intel.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-fWly0BcJ+pXQcHKvzY3H"
Date: Wed, 03 Feb 2010 09:44:00 +0100
Message-ID: <1265186640.29119.83.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-fWly0BcJ+pXQcHKvzY3H
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2010-02-02 at 17:17 -0800, wey-yi.w.guy@intel.com wrote:
> From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
>=20
> When there is a need to restart/reconfig hw, tear down all the
> aggregation queues and let the mac80211 and driver get in-sync and have
> the opportunity to re-establish the aggregation queues.
>=20
> Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> ---
> v2: add rcu_read_lock()
> ---
>  net/mac80211/util.c |   10 ++++++++++
>  1 files changed, 10 insertions(+), 0 deletions(-)
>=20
> diff --git a/net/mac80211/util.c b/net/mac80211/util.c
> index ca170b4..27e8833 100644
> --- a/net/mac80211/util.c
> +++ b/net/mac80211/util.c
> @@ -1188,6 +1188,16 @@ int ieee80211_reconfig(struct ieee80211_local *loc=
al)
>  	ieee80211_wake_queues_by_reason(hw,
>  			IEEE80211_QUEUE_STOP_REASON_SUSPEND);
> =20
> +	rcu_read_lock();
> +
> +	if (hw->flags & IEEE80211_HW_AMPDU_AGGREGATION) {
> +		list_for_each_entry_rcu(sta, &local->sta_list, list) {
> +			ieee80211_sta_tear_down_BA_sessions(sta);
> +		}
> +	}
> +
> +	rcu_read_unlock();
> +

I wonder if that shouldn't be _before_ waking up the queues again, since
otherwise we'd enqueue all the frames that might have come in while
reconfiguring as aggregation frames still?

johannes

--=-fWly0BcJ+pXQcHKvzY3H
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLaTdLAAoJEODzc/N7+Qma/x0QALKficBwr5n2/MpBoPFglX0v
sCpq14T/bnl/ZLYsDMqJprECRtQFbtzNtMO4RNnIhosCcSYPS+pHrFtOEroMvhsF
sN5tyTFAUK9fBfS9Ws+wjo/pVmibx2tZoHPnGsVYkWzjjgcmFj50g58agtJAkeIA
2lSdiGgNrfoJ5KcHvqWbzNyH4sDa0pkgKE3DOXx30WcPsaoxatteTpQNipo51ABm
0GYFpFdDfrGmN3Abj5fBAU3Wzs68R4e6qQG24wa28safpne48oZilLrIv8S8RQE8
DJuNJGGlJzTR2zLl3Xr4Gm7v7NsR+iz9+yQlaocVNcBHKVbOs5HGll74+CHRGuqW
8h9QW8pyA4qjQRWeWFQjIKI8Xj+jmTUbPH1HEFe5tR4tihPf4GwAnH2SY73YhzTL
VJtCLnEhViVwhD40E9UCm3ymUHZVDzSru6IOPeu6Ly9kEeVMb/kHkVKom41I6Fgr
d4cmk3FdoG5Txud1h9hSJTRwmX1tLe3CiS5c69x2qBcTQ7zI3sMjCXi+YH1q5kMn
NglagTNa2X03tPLHxWYFc+swQD5wzddQUlNwaauEW22xNnaJ5YKCnivXMSOUabuU
jKlUnAPmqXgJU9nNdCwdPVyv+eIITJVIM5lUJeZuIJ41kZpfjrMe1/r2f5aWaBoA
xt0iLYgwoF+HMea4JWu1
=471/
-----END PGP SIGNATURE-----

--=-fWly0BcJ+pXQcHKvzY3H--

