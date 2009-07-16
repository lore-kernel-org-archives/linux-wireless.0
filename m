Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:40739 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754471AbZGPJZw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jul 2009 05:25:52 -0400
Subject: Re: [RFC/RFT 5/5] mac80211: implement basic background scanning
From: Johannes Berg <johannes@sipsolutions.net>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <200907161109.40471.helmut.schaa@gmail.com>
References: <200907161104.41975.helmut.schaa@gmail.com>
	 <200907161109.40471.helmut.schaa@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-2uJ0NQ38YnfDX1//dCzM"
Date: Thu, 16 Jul 2009 11:25:18 +0200
Message-Id: <1247736318.24433.10.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-2uJ0NQ38YnfDX1//dCzM
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-07-16 at 11:09 +0200, Helmut Schaa wrote:

Looks nice! Some nitpicks ;)

> Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.>

Missing "com" :)

> +/**
> + * enum mac80211_scan_flag - currently active scan mode
> + *
> + * @SCAN_SW_SCANNING: We're off our operating channel for scanning
> + * @SCAN_HW_SCANNING: The hardware is scanning for us, we have no way to
> + *	determine if we are on the operating channel or not
> + * @SCAN_BG_SCANNING: We're currently in the process of scanning but may
> + *	as well be on the operating channel
> + */
>  enum mac80211_scan_flag {
>  	SCAN_SW_SCANNING =3D 1,"SCAN_ENTER_OPER_CHANNEL"
>  	SCAN_HW_SCANNING =3D 2,
> +	SCAN_BG_SCANNING =3D 4,

There's some random stuff in there that doesn't belong. Also I would
prefer you used BIT(0) etc. or maybe __test_bit().

> --- a/net/mac80211/iface.c
> +++ b/net/mac80211/iface.c
> @@ -513,7 +513,7 @@ static int ieee80211_stop(struct net_device *dev)
>  			 * the scan_sdata is NULL already don't send out a
>  			 * scan event to userspace -- the scan is incomplete.
>  			 */
> -			if (local->scanning & SCAN_SW_SCANNING)
> +			if (local->scanning & SCAN_BG_SCANNING)
>  				ieee80211_scan_completed(&local->hw, true);
>  		}

That doesn't seem correct -- it should be kept I think.

> diff --git a/net/mac80211/main.c b/net/mac80211/main.c
> index a1b4887..a87522f 100644
> --- a/net/mac80211/main.c
> +++ b/net/mac80211/main.c
> @@ -198,7 +198,7 @@ void ieee80211_bss_info_change_notify(struct ieee8021=
1_sub_if_data *sdata,
>  	}
> =20
>  	if (changed & BSS_CHANGED_BEACON_ENABLED) {
> -		if (local->scanning & SCAN_SW_SCANNING) {
> +		if (local->scanning & SCAN_BG_SCANNING) {
>  			sdata->vif.bss_conf.enable_beacon =3D false;

That too.

> diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
> index 3df8a6e..24739ab 100644
> --- a/net/mac80211/rx.c
> +++ b/net/mac80211/rx.c
> @@ -2136,7 +2136,7 @@ static void __ieee80211_rx_handle_packet(struct iee=
e80211_hw *hw,
>  		return;
>  	}
> =20
> -	if (unlikely(local->scanning))
> +	if (unlikely((local->scanning & SCAN_HW_SCANNING) || (local->scanning &=
 SCAN_SW_SCANNING)))

I would prefer
	if (unlikely(local->scanning & (SCAN_HW_SCANNING | SCAN_SW_SCANNING)))

>  		rx.flags |=3D IEEE80211_RX_IN_SCAN;
> =20
>  	ieee80211_parse_qos(&rx);
> diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
> index b4cc556..8f33fb5 100644
> --- a/net/mac80211/scan.c
> +++ b/net/mac80211/scan.c
> @@ -282,7 +282,7 @@ void ieee80211_scan_completed(struct ieee80211_hw *hw=
, bool aborted)
>  		cfg80211_scan_done(local->scan_req, aborted);
>  	local->scan_req =3D NULL;
> =20
> -	was_hw_scan =3D local->scanning & SCAN_HW_SCANNING;
> +	was_hw_scan =3D !!(local->scanning & SCAN_HW_SCANNING);

Should that be in the other patch?

> @@ -435,7 +434,7 @@ static int __ieee80211_start_scan(struct ieee80211_su=
b_if_data *sdata,
>  	if (local->ops->hw_scan)
>  		local->scanning |=3D SCAN_HW_SCANNING;
>  	else
> -		local->scanning |=3D SCAN_SW_SCANNING;
> +		local->scanning |=3D SCAN_BG_SCANNING;

Ok now I'm confused. Did you really intend to replace all these?

Based on your initial description I thought it was going to be
	scanning =3D=3D SW_SCANNING
or
	scanning =3D=3D SW_SCANNING | BG_SCANNING

> +	if (local->scan_channel) {
> +		/*
> +		 * we're currently scanning a different channel, let's
> +		 * switch back to the operating channel now if at least
> +		 * one interface is associated. Otherwise just scan the
> +		 * next channel
> +		 */
> +		if (associated)
> +			local->scan_state =3D SCAN_ENTER_OPER_CHANNEL;
> +		else
> +			local->scan_state =3D SCAN_SET_CHANNEL;

:)
=20
> +	/* advance to the next channel to be scanned */
> +	*next_delay =3D HZ / 10;
> +	local->scan_state =3D SCAN_SET_CHANNEL;

Maybe we should rename scan_state to next_scan_state.

> +	if (ieee80211_hw_config(local,
> +					IEEE80211_CONF_CHANGE_CHANNEL))

That looks weird. I don't think you really need to care about the return
value anyway, now that we have rfkill integrated it shouldn't ever be
nonzero (and if it is, while rfkill is being activated, it doesn't
really matter since we're taking down interfaces)

> +	/*
> +	 * notify the AP about us being back and restart all STA interfaces
> +	 */
> +	mutex_lock(&local->iflist_mtx);
> +	list_for_each_entry(sdata, &local->interfaces, list) {
> +		if (!netif_running(sdata->dev))
> +			continue;
> +
> +		/* Tell AP we're back */
> +		if (sdata->vif.type =3D=3D NL80211_IFTYPE_STATION) {
> +			if (sdata->u.mgd.associated) {
> +				ieee80211_scan_ps_disable(sdata);
> +			}

Could drop a set of {} here.

> @@ -657,7 +760,7 @@ void ieee80211_scan_cancel(struct ieee80211_local *lo=
cal)
>  	 * queued -- mostly at suspend under RTNL.
>  	 */
>  	mutex_lock(&local->scan_mtx);
> -	swscan =3D !!(local->scanning & SCAN_SW_SCANNING);
> +	swscan =3D !!(local->scanning & SCAN_BG_SCANNING);

and another one -- please explain?

Anyway looks pretty good to me! How does it fare during ping -f or
something?

johannes

--=-2uJ0NQ38YnfDX1//dCzM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKXvH7AAoJEODzc/N7+QmapKUQAIyXzA9JXzNvgCNKs8lFH12p
reRHBDlhtZjv1V5BmwuCZuFQ7TeYtlT+B5jsvcY1K5cdyycpi9Drnrq5YrVqJitz
N/yzBr0H6CnZ6Xq9LdhsP5/F8WZDwd0+/cCVpjcdG0S0WwydXcOA1Gaswu7SRDYM
v4BdVGRN3jMt549FLp34IxuuDFhLQEkoO8H37yFYd/r6B5DrLO12tXmrKiUAkhPm
xwefFSNlzVx6zSl04H9ma6wU8/JKrLrmVky1jG037WiZofajEPoNQVkjlxr7FAcU
ATIZEEdbMOwjBrR+pBjyBYbsflMnLoR322RlHr8oLIjnln7/hGzXkqzZByHskHPw
nd71USp2Kgl9ZdC8ZVcVVF7sEFUwqu3rPN3SUdi63nqOPEJZwlJ2SPrujVixn5bj
PU+HOWFBGdGf9ntEh37pg084ab56EmVJt5GnDb+yTMpg+B2OGikMV1btSG5BEs20
8hfdCdxs2u5oktR77/uKTzyOQvUmA98ZtAHVahmb66bh0VhEQ3k3MOAbbWr4Pw3f
4xSvZwNVazKWizsvsAcfDcwyM7UPmnAaLHGjGN0HBlXgvrVoluh3AEi4UiVVQiEj
Ce3QULEebUfGznabIID2Nk1Fch8cPD1LBvJoaxS1D9oNuVeEGbXrQ1Pz4FGLgweD
FTE4NT837QbUpydiXDf8
=FIkT
-----END PGP SIGNATURE-----

--=-2uJ0NQ38YnfDX1//dCzM--

