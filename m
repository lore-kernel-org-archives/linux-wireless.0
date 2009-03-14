Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:45310 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753085AbZCNR2s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Mar 2009 13:28:48 -0400
Subject: Re: [RFC PATCH v2 4/4] mac80211: add beacon filtering support
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kalle.valo@nokia.com>
Cc: linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
In-Reply-To: <20090314171452.11126.11618.stgit@tikku>
References: <20090314171234.11126.21125.stgit@tikku>
	 <20090314171452.11126.11618.stgit@tikku>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-HIAr1HSexknwvGnEtE3z"
Date: Sat, 14 Mar 2009 18:28:45 +0100
Message-Id: <1237051725.5235.104.camel@johannes.local> (sfid-20090314_182850_441107_0D8A9012)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-HIAr1HSexknwvGnEtE3z
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-03-14 at 19:14 +0200, Kalle Valo wrote:

> +/**
> + * ieee80211_beacon_loss - inform that hardware does not receive beacons
> + *
> + * @hw: pointer as obtained from ieee80211_alloc_hw()
> + *
> + * When beacon filtering is enabled with IEEE80211_HW_BEACON_FILTERING a=
nd
> + * IEEE80211_CONF_PS is set, the driver needs to inform whenever the
> + * hardware is not receiving beacons with this function.
> + */
> +void ieee80211_beacon_loss(struct ieee80211_hw *hw);


> +void ieee80211_beacon_loss(struct ieee80211_hw *hw)
> +{
> +	struct ieee80211_local *local =3D hw_to_local(hw);
> +	struct ieee80211_sub_if_data *sdata;
> +
> +	rcu_read_lock();
> +	list_for_each_entry(sdata, &local->interfaces, list) {
> +		if (sdata->vif.type !=3D NL80211_IFTYPE_STATION)
> +			continue;
> +
> +		queue_work(local->hw.workqueue,
> +			   &sdata->u.mgd.beacon_loss_work);
> +	}
> +	rcu_read_unlock();
> +}
> +EXPORT_SYMBOL(ieee80211_beacon_loss);

Shouldn't the driver just pass the relevant vif pointer?

johannes

--=-HIAr1HSexknwvGnEtE3z
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJu+lKAAoJEKVg1VMiehFYR58P/0E1RVWvZng/9O2w6G2e1e9l
Uu2HiJzLYRNjj0dJBKnTpjx2Q6yQl718glVce2A6zRpblfQXJkWdemVM9ih4pXPK
A+MKcgoeWRu47JFfTJ67CdTcjnFXeyMiqrQlI+OXAlrpePDkd7eeTDTcYsWXgTnZ
vh99axltnwZNvEaAAgsl/6vwVj5wFV8pCfaJpMB2mq6Wo+uUjyizHVLPgTOx6WZV
6VPvUdqZ/bUA0jH3aKlx6MFVxgBYNFTFhQsQoA6tkeyOiAbW1jc7tseaucq9WuFX
a+REJl1z9svMg3v8kNPmNrIhYcO8oWP8jTGB2WMHoRvE/Yivy2HByzDo08xHbdcy
s3vBvRbqD57TbOXQV6Pw6/x03/OQUj4omHNP61OBVsGk+/nJqA+ZMFJhi38oBvAc
Uuk5TsqOOYXU5dQaGWNjxBjoFSwDu5jTP+/qb+vwSQkrsz/YGq5s0K3TkPbkF/p9
IswB8FAplWQdaL0oIQqdpU/U/vFvpkoNMHpG4Y+1we/9D/LuzK7oTU9h+O/9x094
VUwsrs5XuFX00Vu2FZ3h7IUWv2Nb0U+GXJs+U1JpQTWfBrNLeGJnlMv/KDOBSgF/
IpiITrX0r7naqOZ6UiBssYYkVqqdOYNyCzi9gcW/zpYOyGgQlXUP0joEb/4++QM7
fTKFca1y7isVv34gSl4Q
=ML4o
-----END PGP SIGNATURE-----

--=-HIAr1HSexknwvGnEtE3z--

