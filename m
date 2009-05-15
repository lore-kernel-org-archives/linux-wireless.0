Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:47226 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760905AbZEOIWf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 May 2009 04:22:35 -0400
Subject: Re: [PATCH] mac80211: fix some unforgotten items on suspend
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1242362919-9788-1-git-send-email-lrodriguez@atheros.com>
References: <1242362919-9788-1-git-send-email-lrodriguez@atheros.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-qV53CVOytIQxIy4mt7V0"
Date: Fri, 15 May 2009 10:22:05 +0200
Message-Id: <1242375725.5799.39.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-qV53CVOytIQxIy4mt7V0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-05-15 at 00:48 -0400, Luis R. Rodriguez wrote:

[...]

Looks pretty good, some comments.

>  static inline int __ieee80211_resume(struct ieee80211_hw *hw)
>  {
> +	hw_to_local(hw)->suspended =3D false;
>  	return ieee80211_reconfig(hw_to_local(hw));

Shouldn't we do that only somewhere in the middle of reconfig? i.e.
after we actually reconfig the hw, but before we restart our timers?

> @@ -2196,6 +2207,18 @@ static void ieee80211_restart_sta_timer(struct iee=
e80211_sub_if_data *sdata)
>  	}
>  }
> =20
> +void ieee80211_sta_setup_sdata_timers(struct ieee80211_sub_if_data *sdat=
a)
> +{
> +	struct ieee80211_if_managed *ifmgd;
> +
> +	ifmgd =3D &sdata->u.mgd;
> +
> +	setup_timer(&ifmgd->timer, ieee80211_sta_timer,
> +		    (unsigned long) sdata);
> +	setup_timer(&ifmgd->chswitch_timer, ieee80211_chswitch_timer,
> +		    (unsigned long) sdata);
> +}

That doesn't seem necessary? The timers should still be set up after you
delete them.

> +++ b/net/mac80211/pm.c
> @@ -18,6 +18,10 @@ int __ieee80211_suspend(struct ieee80211_hw *hw)
> =20
>  	flush_workqueue(local->hw.workqueue);
> =20
> +	/* Don't stuff our workqueue during suspend->resume cycle */
> +	del_timer_sync(&local->dynamic_ps_timer);
> +	cancel_work_sync(&local->dynamic_ps_enable_work);
> +

ack, but you forgot to add a comment why dynamic_ps_disable_work doesn't
need to be handled (actually it does need to handled with the current
code but shouldn't be necessary... up for a challenge? -- why? and how
to fix that better than handling it here?)

If you ever suspend in AP mode there's also an issue with each station's
cleanup timer, and for mesh each station's plink timer.

> @@ -52,6 +56,18 @@ int __ieee80211_suspend(struct ieee80211_hw *hw)
> =20
>  	/* remove all interfaces */
>  	list_for_each_entry(sdata, &local->interfaces, list) {
> +		/*
> +		 * This prevents us from stuffing our workqueue during
> +		 * during the suspend->resume cycle.
> +		 */
> +		if (sdata->vif.type =3D=3D NL80211_IFTYPE_STATION) {
> +			struct ieee80211_if_managed *ifmgd;
> +			ifmgd =3D &sdata->u.mgd;
> +
> +			del_timer_sync(&ifmgd->timer);
> +			del_timer_sync(&ifmgd->chswitch_timer);
> +		}

Might make sense to use a switch statement, put the break; from
netif_running after it and for the two types the driver doesn't care
into it, like this
		if (!netif_running())
			continue;

		switch (type) {
		case station:
			del_timer_sync etc
			break;
		case ap_vlan:
		case monitor:
			continue;
		case ...
		}

		conf stuff

because you forgot IBSS and mesh.

> --- a/net/mac80211/util.c
> +++ b/net/mac80211/util.c
> @@ -1121,12 +1121,21 @@ int ieee80211_reconfig(struct ieee80211_local *lo=
cal)
>  	}
> =20
>  	/* add back keys */
> -	list_for_each_entry(sdata, &local->interfaces, list)
> +	list_for_each_entry(sdata, &local->interfaces, list) {
>  		if (netif_running(sdata->dev))
>  			ieee80211_enable_keys(sdata);
> +		if (local->suspended &&
> +		    sdata->vif.type =3D=3D NL80211_IFTYPE_STATION)
> +			ieee80211_sta_setup_sdata_timers(sdata);
> +	}

I don't think that helps, like I said the timers are still set up, you
need to actually queue the work now. However that kinda sucks for small
suspend times. Not really sure what to do.

What we should do is probably add new functions in mlme.c, ibss.c,
mesh.c for suspend() and resume() that contain all this logic instead of
putting it here -- that way mesh is easier to handle without ifdefs in
the code too.
=20
> +	if (local->suspended) {
> +		setup_timer(&local->dynamic_ps_timer,
> +			    ieee80211_dynamic_ps_timer, (unsigned long) local);
> +	}
> +

I think that one is completely unnecessary since now traffic is flowing
which will call mod_timer anyway.

johannes

--=-qV53CVOytIQxIy4mt7V0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKDSYqAAoJEODzc/N7+Qma/jIP/34tt/BXs0CqXNtdlXVdGe7r
rBkhgAnRHgL2nftALa19XI4vBYscc7SYclyHJafGSC6pmHG7+ShLjvzhieknkuAT
s0H37cBPz3HLEuVzf2+K1UBf1T6QXEJ/hDaUgZipn/3WKkINY3UBLHxaivIjH7Um
yj7eAtdmFOV6DWsjibzqTjhai2AuKwHYqBn7bApVaqq0n0cMdGVf95Tbx3ggWxLm
Bpsd3jgX3zkMARmBcN+YdRjRy5JicNVVLcWZ8+KK4RZNptyoM6kmRwVO+f3OZnl7
NbmTyofWuWnVtVxSZNTSp6bx4/jT+EZCvxFllJCb+DimPYBcqDe11m3FxgifFt2U
6M2VgRpJ0n0AeqVyAE8Dgjmt6McLRSKbauBjzYoMyJb5Dl/kTAi8wl7w8/e9EJkk
swz6LdFwd8BLPgRoy2jNgt5AscgiBEhXdaJJmukFLmIjqRr/yX9pIMVVb7Ju9pT+
dhTaEqpR90DKPIidCfgmd/4oT64n/rHxI5dvf5nB4mxpY3JZOtmkE/qTVrty307f
PhsqhKCeiWm01UxUBCW/DMktKt9FfwIl/i7MehoV4ENd+R2OHsqsALVWQ5VjTYV1
N5yt+da0mLKMmapHeQ4aShMK/3Gkv3TKthQZJ9LwzzlXTiyVDpPPki6qTwCQttkt
caJ+srEP7oYDzTlv0P7O
=cBwp
-----END PGP SIGNATURE-----

--=-qV53CVOytIQxIy4mt7V0--

