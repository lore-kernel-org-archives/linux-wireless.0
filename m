Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35982 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757909AbZFVT10 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Jun 2009 15:27:26 -0400
Subject: Re: [PATCH 1/2 RFC] cfg80211: connect/disconnect API
From: Johannes Berg <johannes@sipsolutions.net>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Zhu, Yi" <yi.zhu@intel.com>
In-Reply-To: <20090622170409.GB30147@sortiz.org>
References: <20090622170409.GB30147@sortiz.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-ukEV2QUptp9AcSSgqvL1"
Date: Mon, 22 Jun 2009 21:27:22 +0200
Message-Id: <1245698843.4184.14.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ukEV2QUptp9AcSSgqvL1
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-06-22 at 19:04 +0200, Samuel Ortiz wrote:

> +/**
> + * cfg80211_connected - notify cfg80211 that connection was dropped
> + *
> + * @dev: network device
> + * @gfp: allocation flags
> + * @reason: reason code for the disconnection, set it to 0 when invalid.
> + *
> + */
> +void cfg80211_disconnected(struct net_device *dev, gfp_t gfp, u16 reason=
);

Shouldn't this also be called, with reason =3D=3D 0, when a ->disconnect()
call has succeeded? Not sure why it can ever fail, but we have to give
userspace an event somehow.

> +		/*
> +		 * Here we cache the assoc request. It will be used
> +		 * when the cfg80211 user will call cfg80211_authenticated()
> +		 * letting us know that we can move forward and call the
> +		 * assoc hook.
> +		 */
> +		memset(&wdev->assoc_req, 0, sizeof(wdev->assoc_req));
> +		if (connect->channel)
> +			wdev->assoc_req.chan =3D kmemdup(connect->channel,
> +					       sizeof(struct ieee80211_channel),
> +						       GFP_ATOMIC);

??
->channel always points into the registered channels, that can't go
stale until the wiphy is killed.

> +		if (connect->bssid)
> +			wdev->assoc_req.peer_addr =3D kmemdup(connect->bssid,
> +							    ETH_ALEN,
> +							    GFP_ATOMIC);

just point it to wdev->bssid?

> +		wdev->assoc_req.ssid =3D kmemdup(connect->ssid,
> +					       connect->ssid_len,
> +					       GFP_ATOMIC);
> +		wdev->assoc_req.ssid_len =3D connect->ssid_len;

wdev->ssid?

> +		if (connect->ie)
> +			wdev->assoc_req.ie =3D kmemdup(connect->ie,
> +						     connect->ie_len,
> +						     GFP_ATOMIC);

Yes, this needs to be kmemdup'ed :) I don't think it needs GFP_ATOMIC
though? This should only be called from nl80211 or wext, i.e. in process
context.

> +	wdev->current_bss =3D NULL;
> +	wdev->ssid_len =3D 0;
> +	memset(wdev->bssid, 0, ETH_ALEN);
> +	kfree(wdev->assoc_req.chan);
> +	kfree(wdev->assoc_req.peer_addr);
> +	kfree(wdev->assoc_req.ssid);
> +	kfree(wdev->assoc_req.ie);

Better set =3D NULL too, since you don't set =3D NULL in _connect() if the
parameter isn't present.

>  void cfg80211_send_rx_assoc(struct net_device *dev, const u8 *buf, size_=
t len)
>  {
> -	struct wiphy *wiphy =3D dev->ieee80211_ptr->wiphy;
> +	u16 status_code;
> +	struct ieee80211_mgmt *mgmt;
> +	struct wireless_dev *wdev =3D dev->ieee80211_ptr;
> +	struct wiphy *wiphy =3D wdev->wiphy;
>  	struct cfg80211_registered_device *rdev =3D wiphy_to_dev(wiphy);
> +
> +	mgmt =3D (struct ieee80211_mgmt *)buf;
> +	status_code =3D le16_to_cpu(mgmt->u.assoc_resp.status_code);
> +
>  	nl80211_send_rx_assoc(rdev, dev, buf, len);
> +
> +	if (status_code !=3D WLAN_STATUS_SUCCESS)
> +		wdev->sme_state =3D CFG80211_SME_AUTH;
> +	else {
> +		u8 *ie =3D mgmt->u.assoc_resp.variable;

I wonder if we should give up, if non-successful auth? Wouldn't this
retry again and again? Well I guess you don't queue the work, but if
another interface causes it to be queued... so I guess we need to retry,
or something, but only a limited number of times? Not sure really.

>  void cfg80211_send_deauth(struct net_device *dev, const u8 *buf, size_t =
len)
>  {
> -	struct wiphy *wiphy =3D dev->ieee80211_ptr->wiphy;
> +	struct wireless_dev *wdev =3D dev->ieee80211_ptr;
> +	struct wiphy *wiphy =3D wdev->wiphy;
>  	struct cfg80211_registered_device *rdev =3D wiphy_to_dev(wiphy);
> +
>  	nl80211_send_deauth(rdev, dev, buf, len);
> +
> +	if (wdev->sme_state =3D=3D CFG80211_SME_CONNECTED ||
> +	    wdev->sme_state =3D=3D CFG80211_SME_ASSOC) {
> +		u16 reason_code;
> +		struct ieee80211_mgmt *mgmt;
> +
> +		mgmt =3D (struct ieee80211_mgmt *)buf;
> +		reason_code =3D le16_to_cpu(mgmt->u.deauth.reason_code);
> +
> +		cfg80211_disconnected(dev, GFP_ATOMIC, reason_code);
> +	}

This might be interesting -- you could get a disconnected event without
ever asking for connected. But that indicates we need yet another event:
"I've given up on connect"?

>  EXPORT_SYMBOL(cfg80211_send_deauth);
> =20
>  void cfg80211_send_disassoc(struct net_device *dev, const u8 *buf, size_=
t len)
>  {
> -	struct wiphy *wiphy =3D dev->ieee80211_ptr->wiphy;
> +	struct wireless_dev *wdev =3D dev->ieee80211_ptr;
> +	struct wiphy *wiphy =3D wdev->wiphy;
>  	struct cfg80211_registered_device *rdev =3D wiphy_to_dev(wiphy);
> +
>  	nl80211_send_disassoc(rdev, dev, buf, len);
> +
> +	if (wdev->sme_state =3D=3D CFG80211_SME_CONNECTED) {
> +		u16 reason_code;
> +		struct ieee80211_mgmt *mgmt;
> +
> +		mgmt =3D (struct ieee80211_mgmt *)buf;
> +		reason_code =3D le16_to_cpu(mgmt->u.disassoc.reason_code);
> +
> +		cfg80211_disconnected(dev, GFP_ATOMIC, reason_code);
> +	}

I suspect it needs to be valid to call this without a frame, if you just
get that indication from firmware somehow. However, then there's no
reason code to pass. Maybe we just need a second exported symbol in that
case and not worry about it now. Doesn't need to be perfect, after
all :)

>  EXPORT_SYMBOL(cfg80211_send_disassoc);
> =20
> Index: iwm-2.6/net/wireless/core.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- iwm-2.6.orig/net/wireless/core.c	2009-06-22 18:46:24.000000000 +0200
> +++ iwm-2.6/net/wireless/core.c	2009-06-22 18:46:30.000000000 +0200
> @@ -321,6 +321,7 @@ struct wiphy *wiphy_new(const struct cfg
>  	}
> =20
>  	INIT_WORK(&drv->rfkill_sync, cfg80211_rfkill_sync_work);
> +	INIT_WORK(&drv->sme_sm, cfg80211_sme_work);
> =20
>  	/*
>  	 * Initialize wiphy parameters to IEEE 802.11 MIB default values.
> @@ -481,6 +482,8 @@ void wiphy_unregister(struct wiphy *wiph
>  	/* unlock again before freeing */
>  	mutex_unlock(&drv->mtx);
> =20
> +	cancel_work_sync(&drv->sme_sm);
> +
>  	cfg80211_debugfs_drv_del(drv);
> =20
>  	/* If this device got a regulatory hint tell core its
> @@ -526,54 +529,77 @@ static int cfg80211_netdev_notifier_call
>  					 void *ndev)
>  {
>  	struct net_device *dev =3D ndev;
> +	struct wireless_dev *wdev =3D dev->ieee80211_ptr;
>  	struct cfg80211_registered_device *rdev;
> =20
> -	if (!dev->ieee80211_ptr)
> +	if (!wdev)
>  		return NOTIFY_DONE;
> =20
> -	rdev =3D wiphy_to_dev(dev->ieee80211_ptr->wiphy);
> +	rdev =3D wiphy_to_dev(wdev->wiphy);
> =20
> -	WARN_ON(dev->ieee80211_ptr->iftype =3D=3D NL80211_IFTYPE_UNSPECIFIED);
> +	WARN_ON(wdev->iftype =3D=3D NL80211_IFTYPE_UNSPECIFIED);
> =20
>  	switch (state) {
>  	case NETDEV_REGISTER:
>  		mutex_lock(&rdev->devlist_mtx);
> -		list_add(&dev->ieee80211_ptr->list, &rdev->netdev_list);
> +		list_add(&wdev->list, &rdev->netdev_list);
>  		if (sysfs_create_link(&dev->dev.kobj, &rdev->wiphy.dev.kobj,
>  				      "phy80211")) {
>  			printk(KERN_ERR "wireless: failed to add phy80211 "
>  				"symlink to netdev!\n");
>  		}
> -		dev->ieee80211_ptr->netdev =3D dev;
> +		wdev->netdev =3D dev;
> +		wdev->sme_state =3D CFG80211_SME_IDLE;
> +
>  #ifdef CONFIG_WIRELESS_EXT
> -		dev->ieee80211_ptr->wext.default_key =3D -1;
> -		dev->ieee80211_ptr->wext.default_mgmt_key =3D -1;
> +		wdev->wext.default_key =3D -1;
> +		wdev->wext.default_mgmt_key =3D -1;
>  #endif
>  		mutex_unlock(&rdev->devlist_mtx);
>  		break;
>  	case NETDEV_GOING_DOWN:
> -		if (dev->ieee80211_ptr->iftype !=3D NL80211_IFTYPE_ADHOC)
> +		if (!wdev->ssid_len)
> +			break;
> +
> +		switch (wdev->iftype) {
> +		case NL80211_IFTYPE_ADHOC:
> +			cfg80211_leave_ibss(rdev, dev, true);
> +			break;
> +		case NL80211_IFTYPE_STATION:
> +			cfg80211_disconnect(rdev, dev,
> +					    WLAN_REASON_DEAUTH_LEAVING);
>  			break;
> -		if (!dev->ieee80211_ptr->ssid_len)
> +		default:
>  			break;
> -		cfg80211_leave_ibss(rdev, dev, true);
> +		}
> +
>  		break;
>  	case NETDEV_UP:
>  #ifdef CONFIG_WIRELESS_EXT
> -		if (dev->ieee80211_ptr->iftype !=3D NL80211_IFTYPE_ADHOC)
> +		switch (wdev->iftype) {
> +		case NL80211_IFTYPE_ADHOC:
> +			if (wdev->wext.ibss.ssid_len &&
> +			    cfg80211_join_ibss(rdev, dev, &wdev->wext.ibss))
> +				return NOTIFY_STOP;
>  			break;
> -		if (!dev->ieee80211_ptr->wext.ibss.ssid_len)
> +		case NL80211_IFTYPE_STATION:
> +			if (wdev->wext.connect.ssid_len &&
> +			    cfg80211_connect(rdev, dev, &wdev->wext.connect))
> +				return NOTIFY_STOP;
>  			break;
> -		cfg80211_join_ibss(rdev, dev, &dev->ieee80211_ptr->wext.ibss);
> -		break;
> +		default:
> +			break;
> +		}
>  #endif
> +		break;

Wow, that fixes a bad bug if you don't have wext configured. Good thing
that's currently pretty much impossible.

Thanks!

johannes

--=-ukEV2QUptp9AcSSgqvL1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKP9sXAAoJEODzc/N7+Qma4iUP/0TC+VzbH+lpyWMcvSx0lcJ7
IqVkjukl+Xb+4HuhNE0eStFpCH8HMFJxQG4fmWbNR9znTtfNubYQ5o9MIUaruh+u
zyVy2nYvprApYcGr0f9PML96iqcoBynH5bIkJXtATlh1wcZAu2p2XXb6DTxBuheT
GFiD8vIANDRMNWzQul6ewYHHbPWk9alFJ4yoynd7mCUWdIFoEqbxgvQQ9lw/MkIr
lqfit31bnUvMwAjoe9kQlYMNujXNeW60R/okU0Qik/yp4iGPh+1N6E+yfseTRB8/
KqEeFzd8xPtN2xGvlTC/jNFvRzrmo0oWtkWFjokoio46nbjvKxSU+5yMrTm2CZOr
sQ6u+GbkcgjNWnoI828mkIViyqChApEtzLPHWReUHsdTjG7b1XCGnNyzaOr4HIDH
7b+eLk361mvHQx1z9GN0c/JJOZLQLM6jWLM+QuPloCGHcHwJFfJyHlVcl/XyH+Ag
FQww0A25Hshm4WMM2VFWmG2klts/y2vpLi75mOlnUiKabkaXGUB1luTzUpJEzlxc
ffQGTlCibxZzKE8f/kz5m7fHfuSjy/OrQBXHjFmiwbwsXByokAobkjWLlwibm2dw
OMY04ChezlR/+aPeu7zWxFH8TIbsX9DSuelU+rTJiC5wnOcYDycQ0rKY5Sg6lj8X
LIJ/mFLvFS/7n5nXqXL/
=erVB
-----END PGP SIGNATURE-----

--=-ukEV2QUptp9AcSSgqvL1--

