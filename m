Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:57177 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287AbZBXCzq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Feb 2009 21:55:46 -0500
Subject: Re: [RFC PATCH v1 1/3] mac80211: decrease execution of the
	associated timer
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kalle.valo@nokia.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20090223163724.20939.22893.stgit@tikku>
References: <20090223163626.20939.4879.stgit@tikku>
	 <20090223163724.20939.22893.stgit@tikku>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-lmkVTuVAncuORJ/osOtq"
Date: Mon, 23 Feb 2009 18:13:53 -0800
Message-Id: <1235441633.4455.61.camel@johannes.local> (sfid-20090224_035548_915093_C8490ECE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-lmkVTuVAncuORJ/osOtq
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-02-23 at 18:37 +0200, Kalle Valo wrote:
> Currently the timer is triggering every two seconds
> (IEEE80211_MONITORING_INTERVAL). Decrease the timer to only trigger when
> nothing is received to avoid waking up CPU.
>=20
> Now there's a functional change that probe requests are sent only when th=
e
> data path is idle, earlier they were sent also while there was activity
> on the data path.
>=20
> This is also preparation for beacon filtering support. Thanks to Johannes
> Berg for the idea.
>=20
> Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
> ---
>=20
>  net/mac80211/ieee80211_i.h |    1 +
>  net/mac80211/mlme.c        |    7 +++++++
>  net/mac80211/rx.c          |    3 +++
>  3 files changed, 11 insertions(+), 0 deletions(-)
>=20
> diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
> index d06c757..7851135 100644
> --- a/net/mac80211/ieee80211_i.h
> +++ b/net/mac80211/ieee80211_i.h
> @@ -1078,6 +1078,7 @@ void ieee80211_dynamic_ps_timer(unsigned long data)=
;
>  void ieee80211_send_nullfunc(struct ieee80211_local *local,
>  			     struct ieee80211_sub_if_data *sdata,
>  			     int powersave);
> +void ieee80211_rx_trigger(struct ieee80211_sub_if_data *sdata);

I think that could have a better name maybe? _sta_rx_notify?

>  void ieee80211_wake_queues_by_reason(struct ieee80211_hw *hw,
>  				     enum queue_stop_reason reason);
> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> index 5a49779..b3caac0 100644
> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -911,6 +911,13 @@ static void ieee80211_associate(struct ieee80211_sub=
_if_data *sdata)
>  	mod_timer(&ifmgd->timer, jiffies + IEEE80211_ASSOC_TIMEOUT);
>  }
> =20
> +void ieee80211_rx_trigger(struct ieee80211_sub_if_data *sdata)
> +{
> +	if (sdata->vif.type =3D=3D NL80211_IFTYPE_STATION) {
> +		mod_timer(&sdata->u.mgd.timer,
> +			  jiffies + IEEE80211_MONITORING_INTERVAL);
> +	}

Should we have the sta check outside the function? Seems a little odd to
have a check in a file that only contains STATION mode code.

Other than that, looks good to me. I'd have thought this would be more
complicated :)

johannes

--=-lmkVTuVAncuORJ/osOtq
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJo1ffAAoJEKVg1VMiehFYuwoP/2UUoxVwkP8xb59rpNi7fbrQ
k5EiMcn6n/7U9kjNcT4sHNtmuosJ1JWX276KuHpRuAefdfBVJL7ptIisW0fzwVED
VQ6Xb+dOqq+9XeDUYbITpsjYokeFXvyWZXkt22SmwOpgST0L4/8k6zKg+ZQvye7V
wmBOLvAly0EUyhz/djIstLHceoiwoA6DQDvpgCQ+fL2suQwlY7dDMNP6HTbyPtyi
65WeLQd0jDkW/nvKIbasw7M+64yVi+M8KaK//25Q9CM7VksNSxaXyFUOQ+gjwP0b
ld0299bTM3p60viCcoMmn4XhoCNRvgiIrYYr4yohG6321lC59ePoPAfiQXtOiBXL
thZxN5YXztBMV/FtdBkO3lOH2w8yyuF/tVC1oEbsSHhfh4AuOdb9YqV3KrruOpYC
zyRbe8UwtZIunHf0tgY0lK6rWLuOPN3kNjGGFUXlzz2JfZPY7atdxs7MnZcYgSQh
vHE/c1/23ZHr3NoZ5MsGO1SB5AD1tuc12JrhPDeyANErxMFr05mrYL5rHxmWXdmS
r/cLiqAbNWsJYRjx17mAQZpQGJDLBE4IR/HZazqlREPaSzwne1MMxfapohZD1JxH
05n37h/qWENEsAAfRWgwfyks/cou4WV3njEulfNwl31BvUlsooVnC8Lk9UDCPw3g
bMzSGtSf0Se61LRXVi5Y
=vjq5
-----END PGP SIGNATURE-----

--=-lmkVTuVAncuORJ/osOtq--

