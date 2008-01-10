Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:42063 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757560AbYAKLhn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Jan 2008 06:37:43 -0500
Subject: Re: [PATCH 3/8 v3] mac80211: A-MPDU Rx adding basic functionality
From: Johannes Berg <johannes@sipsolutions.net>
To: Ron Rindjunsky <ron.rindjunsky@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com, yi.zhu@intel.com
In-Reply-To: <11985948451654-git-send-email-ron.rindjunsky@intel.com>
References: <11985948383801-git-send-email-ron.rindjunsky@intel.com>
	 <11985948451654-git-send-email-ron.rindjunsky@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-52r+x5Oqe5LWmNXHIeVN"
Date: Thu, 10 Jan 2008 15:56:20 +0100
Message-Id: <1199976980.3861.87.camel@johannes.berg> (sfid-20080111_113748_615870_6EA59E89)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-52r+x5Oqe5LWmNXHIeVN
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> @@ -292,9 +292,18 @@ static int ieee80211_stop(struct net_dev
>  	struct ieee80211_sub_if_data *sdata;
>  	struct ieee80211_local *local =3D wdev_priv(dev->ieee80211_ptr);
>  	struct ieee80211_if_init_conf conf;
> +	struct sta_info *sta;
> +	int i;
> =20
>  	sdata =3D IEEE80211_DEV_TO_SUB_IF(dev);
> =20
> +	list_for_each_entry(sta, &local->sta_list, list) {
> +		for (i =3D 0; i <  STA_TID_NUM; i++)
> +			ieee80211_sta_stop_rx_ba_session(sta->dev, sta->addr,
> +						i, WLAN_BACK_RECIPIENT,
> +						WLAN_REASON_QSTA_LEAVE_QBSS);
> +	}
> +

Hmm. Didn't think of this earlier, but when setting an interface down I
now always get the messages

[32566.907283] rx BA session requested to stop on inactive tid 0
[32566.907290] rx BA session requested to stop on inactive tid 1
[...]

I suppose the message isn't really necessary except from
ieee80211_sta_process_delba(), or something. Either way, we should get
rid of it in the regular case.

johannes

--=-52r+x5Oqe5LWmNXHIeVN
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR4YyE6Vg1VMiehFYAQLTAQ//cUEld/ALKC2m6ecdCe6r3gWyo+Zm5uFl
v/SDFjQDDLvTqvL7hKGk6rvk7g8K0Qo/cgYkiX4XUWCqr2E+c0paCa2DzWFX1PEe
Yz7I6ZDPcTVcIWgkhDda7H8BKNpS+Se+SAm7wP3bdcSQrxgg5Sm1sIhIJUA/t9rU
mbCUYK2pRjjrw4hhBtPB5BGxpFpmHKk+g7JktZyj2L9x5BoheDs5yJAueZWzTIli
cXo/t7nW7NbaMTX8Z1lMEIfrxPCJHnzAECKvQfnA3QlZF/6j19PfGAnzngtVFjz7
8JW3xAcOOQPPVGOiO5yOWpNkPHtDUUPjjhYrt6gDkbmQvUm2vEz2GqgcQtq1HWuF
EtSP2bzC8X9345SXVvsplyGAqyP4nKO0GkuhvyvywihALnzVOqBxUxD/6M7yKmef
xP7PLl6yE9gNRYDRbY6yGrtMByrsAyLZS8fqjhtRXsnbTfXNCgCq6kzO8ocvm2hd
YJeaMsJbl9iyUUZmWUTXaVpC22huy9KtN2K5Z1m3ptR772QrGhwHaaKtWxOikVfu
KaMBHZf6i2+3i5yLvoOP0Njt1K/MkqO3bE7wRzhnzc33aGjJOSfYeFs2el7CI3yP
1Mtt0HHUZdcCnr2yfVtiB4ISUeXz5GiS9Ri2d53a1eASZ/Sod+mOkmo8AV3q4rcr
00OHIBM0XOE=
=eeaz
-----END PGP SIGNATURE-----

--=-52r+x5Oqe5LWmNXHIeVN--

