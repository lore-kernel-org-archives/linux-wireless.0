Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:37498 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752101AbXKTNuX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2007 08:50:23 -0500
Subject: Re: [PATCH] mac80211: hardware scan rework (V2)
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhu Yi <yi.zhu@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Mohamed Abbas <mohamed.abbas@intel.com>,
	Ben Cahill <ben.m.cahill@intel.com>
In-Reply-To: <119553601948-git-send-email-yi.zhu@intel.com>
References: <119553601948-git-send-email-yi.zhu@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-lDRcAI+ITq3OYD3k1uB4"
Date: Tue, 20 Nov 2007 14:50:32 +0100
Message-Id: <1195566632.10920.39.camel@johannes.berg> (sfid-20071120_135154_607877_A67CED0C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-lDRcAI+ITq3OYD3k1uB4
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

Thanks!

> 1. fix a hw scan bug in ieee80211_rx_bss_info() for setting beacon
>    supported rates
> 2. let control frames pass in ieee80211_sta_rx_scan() during hw scan
> 3. set local->sta_{hw|sw}_scanning type to bool
> 4. avoid channel setting during hw scan

Why this? I was confused at first and I'm sorry if I confused you, but
since we're now fully unaware of hardware scan thanks to your item 5, I
think we need to allow setting channel during hardware scan so the
firmware will change to the right channel once it finished scanning.

> 5. rework ieee80211_scan_completed() to make it symmetric for hw scan


> diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
> index 015b3f8..26f404a 100644
> --- a/net/mac80211/ieee80211_sta.c
> +++ b/net/mac80211/ieee80211_sta.c
> @@ -1487,8 +1487,18 @@ static void ieee80211_rx_bss_info(struct net_devic=
e *dev,
>  		u32 supp_rates, prev_rates;
>  		int i, j;
> =20
> -		mode =3D local->sta_scanning ?
> +		mode =3D local->sta_sw_scanning ?
>  		       local->scan_hw_mode : local->oper_hw_mode;
> +
> +		if (local->sta_hw_scanning) {
> +			/* search for the correct mode matches the beacon */
> +			list_for_each_entry(mode, &local->modes_list, list)
> +				if (mode->mode =3D=3D rx_status->phymode)
> +					break;
> +
> +			if (mode =3D=3D NULL)
> +				mode =3D local->oper_hw_mode;
> +		}

Good catch.

> @@ -1985,7 +2003,7 @@ void ieee80211_sta_work(struct work_struct *work)
>  	if (!netif_running(dev))
>  		return;
> =20
> -	if (local->sta_scanning)
> +	if (local->sta_sw_scanning || local->sta_hw_scanning)
>  		return;

Shouldn't the sta work be able to run normally while hw scan is in
progress?
=20
> -	if (unlikely(local->sta_scanning !=3D 0)) {
> -		ieee80211_sta_rx_scan(rx->dev, skb, rx->u.rx.status);
> +	if (unlikely(local->sta_hw_scanning))
> +		return ieee80211_sta_rx_scan(rx->dev, skb, rx->u.rx.status);
> +
> +	if (unlikely(local->sta_sw_scanning)) {
> +		/* drop all the other packets during a software scan anyway */
> +		if (ieee80211_sta_rx_scan(rx->dev, skb, rx->u.rx.status)
> +		    !=3D TXRX_QUEUED)
> +			dev_kfree_skb(skb);

Not entirely sure why we do this, but nothing we should change with this
patch.

Other than the ioctl thing it looks good to me.

johannes

--=-lDRcAI+ITq3OYD3k1uB4
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR0LmJ6Vg1VMiehFYAQL1nhAAujaYMK9IWHsub5FHZsEh55DAFwJIpm0B
46w5yTVjAvU7ebTdX3myc2kmHkdhmK0SYkVmoXe7pzvi3Hu5I8Y7+itThawDldRE
3+W1PqUerrjFUqYVZrmRGBrtUjpCkWoUlMkV47jsWmgv4XiM9Q2+Nhl1In8RmdHE
p2mhMS/jCW5Vi058hrarFQLGqUKOcfeoboW/9Opc2Z7sQsDStOyeslYi29/1ZLPR
EdG3PRVynhcHX2+GAmbIPDtTCUd2ljZ8SpwVjqzNnias1LAGyaDuiggjesamXMjC
7+3ciZLwiC1V0Q8K72ZdXopAWDNKBrRYNN4sxL1agp20741S0Fm490tDUfZ+HJ5j
E9VyS2UBrTU9BiVmfMN4Z3JBaKa8y8nVrIkhlL0HjagvTlpbZZ0wSBXwFgUqhjJN
Vt5qh/IeTXnpscDmWAkMFYT22pLYije5Ko+HTTQqvOf35f1K1yA3QUB/b3LANb0d
Bm89F5XzEpleGY3I9v60zxpTBb0go1YjL/WhZoMw2T9Gzj/7sGdCfTtJsazwPpm1
0BXxL6tZ8uxcAuqTHegPI5tVwZpLobgql9k7dYkuWOSixGwCBcH7MLwiCO6a0E6y
9Rdqle295BtOVJAU7gkDq3oSjfqmX8BCRwVp1oWjsZ/6vQ8cvtwYp0UsjaJVkgZc
891+QD56l58=
=HEZw
-----END PGP SIGNATURE-----

--=-lDRcAI+ITq3OYD3k1uB4--

