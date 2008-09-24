Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:37813 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136AbYIXOrF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Sep 2008 10:47:05 -0400
Subject: Re: [RFC v2] basic background scan
From: Johannes Berg <johannes@sipsolutions.net>
To: Helmut Schaa <hschaa@suse.de>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200809241636.38762.hschaa@suse.de>
References: <200809241636.38762.hschaa@suse.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-5CKKLxDKthikaVPpXFoy"
Date: Wed, 24 Sep 2008 16:46:18 +0200
Message-Id: <1222267578.4257.33.camel@johannes.berg> (sfid-20080924_164709_452312_38E28E8F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-5CKKLxDKthikaVPpXFoy
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-09-24 at 16:36 +0200, Helmut Schaa wrote:

> Could somebody please have a look at the TODO comments (I have no idea ho=
w
> to wait until all null-func frames are ACKed)? Thanks.

It's not really possible.


> +		if (local->bg_scanning) {
> +			/*
> +			 * background scan is in progress, notify all associated=20
> +			 * access points about us leaving the channel and
> +			 * update the filter flags
> +			 */
> +			local->sw_scanning =3D 1;

use true/false please

> +			rcu_read_lock();
> +			list_for_each_entry_rcu(sdata, &local->interfaces, list) {
> +				if (sdata->vif.type =3D=3D NL80211_IFTYPE_STATION &&
> +				    (sdata->u.sta.flags & IEEE80211_STA_ASSOCIATED)) {
> +					ieee80211_send_nullfunc(local, sdata, 1);
> +					/* TODO: wait until all nullfunc frames are ACKed */
> +					msleep(1);

I don't think you can msleep here?

> +		break;
> +
> +	case SCAN_OPERATION:=09
> +		rcu_read_lock();
> +		list_for_each_entry_rcu(sdata, &local->interfaces, list) {
> +			/* Tell AP we're back */
> +			if (sdata->vif.type =3D=3D NL80211_IFTYPE_STATION &&
> +			    sdata->u.sta.flags & IEEE80211_STA_ASSOCIATED) {
> +				ieee80211_send_nullfunc(local, sdata, 0);
> +				/* TODO: wait until all nullfunc frames are ACKed */
> +				msleep(1);
> +				netif_tx_wake_all_queues(sdata->dev);

This is worsening a problem we already have -- you can enable queues
that the driver asked to be disabled. Until we fix that, I don't think
we should tempt our luck even more.


> -	if (local->sw_scanning || local->hw_scanning)
> +	if (local->sw_scanning || local->hw_scanning || local->bg_scanning)

I don't really like that. I think these three bools should become an
enum now. And why is sw_scanning false if bg_scanning is true anyway?

johannes

--=-5CKKLxDKthikaVPpXFoy
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI2lK0AAoJEKVg1VMiehFYKwwP/3qxmi/9xqeu4Y8ObsB+e3Yx
SzEGJPVTZ69w/z26TWM+xV3/T4EqYxvqLD8iwGhNSN+gX1p6NXw9qOdUCd7Ozxne
GXaKKpsl/tgFjPS3Pi7ZTplPzplPjzt9kqU5STyUlNul14azvZcSivXzXzMans8b
vDu78ITBH2+4liJfLYdl4BVrleylPsE758/hkTKnMNpuFEuffbSA4UrhwDYUsPLW
Y4o1oZ0wou1oZl+vko4wLa8hXN9VSVrtYjgVclKtbKw8+l8G7XR/EbTWhYqBwKmA
SyqlSIqn3gpEJVQfYSwMV3Qe4pAAyhzl5HcyQnnEnxRDMoajKpm8CMbTLSeXKX+8
RZlgHicFUtFlwBn679Z0KlwqdEemnRDkxoIhSeh5inDYAAFwmu6ilnxYNC18tAvE
nt/lEs0t6MCiTCGkgbJ12ek2IiVagqy3DIHW0PWBMUHsbsc3l+DdqWVF2EWdyDjL
IMd1V+jbgW7A43t6HkbG3qANwS2//9OKVuAq7EHQFElPkDoRlszQSin5qwVf0aF9
mgIUVMYnmiWX1J5Dnolj2pAaxBmaefQP3320RoOQxwkqsK6P2BnYuT8ENrMQfwZ9
JV0RdEq1B4qhH+ZaHyK/epZVNf7SKQ3x7GT4nHtVLPjB6gwPUtpXTAJCxcX7lgaY
XdjO8Zd4opnaFB0QMnYX
=YwSh
-----END PGP SIGNATURE-----

--=-5CKKLxDKthikaVPpXFoy--

