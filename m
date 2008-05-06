Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35829 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077AbYEFVvs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 May 2008 17:51:48 -0400
Subject: Re: [PATCH v2] mac80211: Add RTNL version of
	ieee80211_iterate_active_interfaces
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <200805062350.00648.IvDoorn@gmail.com> (sfid-20080506_234141_711154_B8944707)
References: <200805061943.31902.IvDoorn@gmail.com>
	 <200805062350.00648.IvDoorn@gmail.com>
	 (sfid-20080506_234141_711154_B8944707)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-WRckH4eLiAYMYy8LK2Fv"
Date: Tue, 06 May 2008 23:50:53 +0200
Message-Id: <1210110653.9305.16.camel@johannes.berg> (sfid-20080506_235059_240264_2576083D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-WRckH4eLiAYMYy8LK2Fv
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-05-06 at 23:50 +0200, Ivo van Doorn wrote:
> Since commit e38bad4766a110b61fa6038f10be16ced8c6cc38
>         mac80211: make ieee80211_iterate_active_interfaces not need rtnl
> rt2500usb and rt73usb broke down due to attempting register access
> in atomic context (which is not possible for USB hardware).
>=20
> This patch restores ieee80211_iterate_active_interfaces() to use RTNL loc=
k,
> and provides the non-RTNL version under a new name:
> 	ieee80211_iterate_active_interfaces_atomic()
>=20
> So far only rt2x00 uses ieee80211_iterate_active_interfaces(), and those
> drivers require the RTNL version of ieee80211_iterate_active_interfaces()=
.
> Since they already call that function directly, this patch will automatic=
ally
> fix the USB rt2x00 drivers.
>=20
> v2: Rename ieee80211_iterate_active_interfaces_rtnl
>=20
> Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>

Acked-by: Johannes Berg <johannes@sipsolutions.net>

Thanks for doing this.


> John, this is still 2.6.26 material. ;)
>=20
> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
> index 7e75516..7d6de23 100644
> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h
> @@ -1586,13 +1586,16 @@ void ieee80211_wake_queues(struct ieee80211_hw *h=
w);
>  void ieee80211_scan_completed(struct ieee80211_hw *hw);
> =20
>  /**
> - * ieee80211_iterate_active_interfaces - iterate active interfaces
> + * ieee80211_iterate_active_interfaces- iterate active interfaces
>   *
>   * This function iterates over the interfaces associated with a given
>   * hardware that are currently active and calls the callback for them.
> + * This function allows the iterator function to sleep, when the iterato=
r
> + * function is atomic @ieee80211_iterate_active_interfaces_atomic can
> + * be used.
>   *
>   * @hw: the hardware struct of which the interfaces should be iterated o=
ver
> - * @iterator: the iterator function to call, cannot sleep
> + * @iterator: the iterator function to call
>   * @data: first argument of the iterator function
>   */
>  void ieee80211_iterate_active_interfaces(struct ieee80211_hw *hw,
> @@ -1601,6 +1604,24 @@ void ieee80211_iterate_active_interfaces(struct ie=
ee80211_hw *hw,
>  					 void *data);
> =20
>  /**
> + * ieee80211_iterate_active_interfaces_atomic - iterate active interface=
s
> + *
> + * This function iterates over the interfaces associated with a given
> + * hardware that are currently active and calls the callback for them.
> + * This function requires the iterator callback function to be atomic,
> + * if that is not desired, use @ieee80211_iterate_active_interfaces inst=
ead.
> + *
> + * @hw: the hardware struct of which the interfaces should be iterated o=
ver
> + * @iterator: the iterator function to call, cannot sleep
> + * @data: first argument of the iterator function
> + */
> +void ieee80211_iterate_active_interfaces_atomic(struct ieee80211_hw *hw,
> +						void (*iterator)(void *data,
> +						    u8 *mac,
> +						    struct ieee80211_vif *vif),
> +						void *data);
> +
> +/**
>   * ieee80211_start_tx_ba_session - Start a tx Block Ack session.
>   * @hw: pointer as obtained from ieee80211_alloc_hw().
>   * @ra: receiver address of the BA session recipient
> diff --git a/net/mac80211/util.c b/net/mac80211/util.c
> index 74c48ef..2a8c0c5 100644
> --- a/net/mac80211/util.c
> +++ b/net/mac80211/util.c
> @@ -401,6 +401,41 @@ void ieee80211_iterate_active_interfaces(
>  	struct ieee80211_local *local =3D hw_to_local(hw);
>  	struct ieee80211_sub_if_data *sdata;
> =20
> +	rtnl_lock();
> +
> +	list_for_each_entry(sdata, &local->interfaces, list) {
> +		switch (sdata->vif.type) {
> +		case IEEE80211_IF_TYPE_INVALID:
> +		case IEEE80211_IF_TYPE_MNTR:
> +		case IEEE80211_IF_TYPE_VLAN:
> +			continue;
> +		case IEEE80211_IF_TYPE_AP:
> +		case IEEE80211_IF_TYPE_STA:
> +		case IEEE80211_IF_TYPE_IBSS:
> +		case IEEE80211_IF_TYPE_WDS:
> +		case IEEE80211_IF_TYPE_MESH_POINT:
> +			break;
> +		}
> +		if (sdata->dev =3D=3D local->mdev)
> +			continue;
> +		if (netif_running(sdata->dev))
> +			iterator(data, sdata->dev->dev_addr,
> +				 &sdata->vif);
> +	}
> +
> +	rtnl_unlock();
> +}
> +EXPORT_SYMBOL_GPL(ieee80211_iterate_active_interfaces);
> +
> +void ieee80211_iterate_active_interfaces_atomic(
> +	struct ieee80211_hw *hw,
> +	void (*iterator)(void *data, u8 *mac,
> +			 struct ieee80211_vif *vif),
> +	void *data)
> +{
> +	struct ieee80211_local *local =3D hw_to_local(hw);
> +	struct ieee80211_sub_if_data *sdata;
> +
>  	rcu_read_lock();
> =20
>  	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
> @@ -425,4 +460,4 @@ void ieee80211_iterate_active_interfaces(
> =20
>  	rcu_read_unlock();
>  }
> -EXPORT_SYMBOL_GPL(ieee80211_iterate_active_interfaces);
> +EXPORT_SYMBOL_GPL(ieee80211_iterate_active_interfaces_atomic);
>=20

--=-WRckH4eLiAYMYy8LK2Fv
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASCDSvKVg1VMiehFYAQKoYRAAmCcG73NNkrLOLwQx4bWOKVnUU+l03UJl
sXH8ipphnn72X9NtuP5To6a+A8FiQ5hzxz2GJd/n+O2mn+LGUrOyrJQRK+9cMdYl
SMFIk8D75ScusCdHltQ1CfO4kdCBPUacIkkz+qRyqJVPmyQVyA/9i5ZQj7MBQqL1
l/5qDRha8h2wJvMaYYdtkTAcmfAzyoIvmn9r4+Wx2iOQWI4nAF+7p81o2WcWhm3I
cqTiXpnjMcF/VxlJl2HfxQmsw6/5/SlIP9lyfDFn+APKUsfeCP3udC6HM2vrksoZ
jqVSm0YurpZdItfa6tHzZ4HMFxElK9QswvSBtD1eXvl57VrDuTMe29pF97FbidwQ
jhz27cCDhVVmh/mMnTUj2PvCkIrTn7H6aqSojNkhpWWY3hHUjvCHcbpLD0IqQYiA
o5H2pg8W6Md7+8ObfRNq9hqiReGKCG1YncJRWBesHmb92x9cXGJtadvT20WM1q1O
tPSPyO0TKaZAhawCas90skxWQ4xIzesZJWToiH7xof3n1pTKIEQuZJv3S0JMkNc4
AkK6Yd52WGlFq6MlXixXFltk1nN92JpClw9jBj3n46hJ6C366vmoTeBABFDGNb3S
+UYNY7R7Ieg9NIzpFAX2NuWVz66H0v/NkzFxpeesD6WdriBAav5n8GgqZBVZyJ2x
p25P/BU6iXI=
=fMjQ
-----END PGP SIGNATURE-----

--=-WRckH4eLiAYMYy8LK2Fv--

