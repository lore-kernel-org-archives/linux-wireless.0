Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:34947 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759476AbYHFL3N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Aug 2008 07:29:13 -0400
Subject: Re: [PATCH 1/1 V2] mac80211: cleanup mlme state namespace
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <1218021721-1369-1-git-send-email-tomas.winkler@intel.com>
References: <1218021721-1369-1-git-send-email-tomas.winkler@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-4YSoOw89VxJ8BGjVPTtp"
Date: Wed, 06 Aug 2008 13:28:24 +0200
Message-Id: <1218022104.23048.0.camel@johannes.berg> (sfid-20080806_132917_739908_8E7EA801)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-4YSoOw89VxJ8BGjVPTtp
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-08-06 at 14:22 +0300, Tomas Winkler wrote:
> This patch move add STA_MLME to station mlme state defines.
>=20
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> ---
>=20
> One rename of IEEE80211_MESH_UP -> IEEE80211_STA_MLME_MESH_UP was missing=
=20
>=20
>  net/mac80211/ieee80211_i.h |   34 +++++++++++++-------
>  net/mac80211/main.c        |    2 +-
>  net/mac80211/mlme.c        |   72 ++++++++++++++++++++++----------------=
------
>  net/mac80211/wext.c        |    4 +-
>  4 files changed, 61 insertions(+), 51 deletions(-)
>=20
> diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
> index ec59345..d19f67e 100644
> --- a/net/mac80211/ieee80211_i.h
> +++ b/net/mac80211/ieee80211_i.h
> @@ -300,17 +300,33 @@ struct mesh_config {
>  #define IEEE80211_STA_AUTO_BSSID_SEL	BIT(11)
>  #define IEEE80211_STA_AUTO_CHANNEL_SEL	BIT(12)
>  #define IEEE80211_STA_PRIVACY_INVOKED	BIT(13)
> +/* flags for  MLME request*/
> +#define IEEE80211_STA_REQ_SCAN 0
> +#define IEEE80211_STA_REQ_AUTH 1
> +#define IEEE80211_STA_REQ_RUN  2
> +
> +/* flags used for setting mlme state */
> +enum ieee80211_sta_mlme_state {
> +	IEEE80211_STA_MLME_DISABLED,
> +	IEEE80211_STA_MLME_AUTHENTICATE,
> +	IEEE80211_STA_MLME_ASSOCIATE,
> +	IEEE80211_STA_MLME_ASSOCIATED,
> +	IEEE80211_STA_MLME_IBSS_SEARCH,
> +	IEEE80211_STA_MLME_IBSS_JOINED,
> +	IEEE80211_STA_MLME_MESH_UP
> +};
> +
> +/* bitfield of allowed auth algs */
> +#define IEEE80211_AUTH_ALG_OPEN BIT(0)
> +#define IEEE80211_AUTH_ALG_SHARED_KEY BIT(1)
> +#define IEEE80211_AUTH_ALG_LEAP BIT(2)
> +
>  struct ieee80211_if_sta {
>  	struct timer_list timer;
>  	struct work_struct work;
>  	u8 bssid[ETH_ALEN], prev_bssid[ETH_ALEN];
>  	u8 ssid[IEEE80211_MAX_SSID_LEN];
> -	enum {
> -		IEEE80211_DISABLED, IEEE80211_AUTHENTICATE,
> -		IEEE80211_ASSOCIATE, IEEE80211_ASSOCIATED,
> -		IEEE80211_IBSS_SEARCH, IEEE80211_IBSS_JOINED,
> -		IEEE80211_MESH_UP
> -	} state;
> +	enum ieee80211_sta_mlme_state state;
>  	size_t ssid_len;
>  	u8 scan_ssid[IEEE80211_MAX_SSID_LEN];
>  	size_t scan_ssid_len;
> @@ -360,13 +376,7 @@ struct ieee80211_if_sta {
>  	unsigned long last_probe;
> =20
>  	unsigned int flags;
> -#define IEEE80211_STA_REQ_SCAN 0
> -#define IEEE80211_STA_REQ_AUTH 1
> -#define IEEE80211_STA_REQ_RUN  2
> =20
> -#define IEEE80211_AUTH_ALG_OPEN BIT(0)
> -#define IEEE80211_AUTH_ALG_SHARED_KEY BIT(1)
> -#define IEEE80211_AUTH_ALG_LEAP BIT(2)
>  	unsigned int auth_algs; /* bitfield of allowed auth algs */
>  	int auth_alg; /* currently used IEEE 802.11 authentication algorithm */
>  	int auth_transaction;
> diff --git a/net/mac80211/main.c b/net/mac80211/main.c
> index 0c02c47..372fcd4 100644
> --- a/net/mac80211/main.c
> +++ b/net/mac80211/main.c
> @@ -497,7 +497,7 @@ static int ieee80211_stop(struct net_device *dev)
>  	case IEEE80211_IF_TYPE_MESH_POINT:
>  	case IEEE80211_IF_TYPE_STA:
>  	case IEEE80211_IF_TYPE_IBSS:
> -		sdata->u.sta.state =3D IEEE80211_DISABLED;
> +		sdata->u.sta.state =3D IEEE80211_STA_MLME_DISABLED;
>  		memset(sdata->u.sta.bssid, 0, ETH_ALEN);
>  		del_timer_sync(&sdata->u.sta.timer);
>  		/*
> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> index e1d11c9..5426df1 100644
> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -669,11 +669,11 @@ static void ieee80211_authenticate(struct net_devic=
e *dev,
>  		printk(KERN_DEBUG "%s: authentication with AP %s"
>  		       " timed out\n",
>  		       dev->name, print_mac(mac, ifsta->bssid));
> -		ifsta->state =3D IEEE80211_DISABLED;
> +		ifsta->state =3D IEEE80211_STA_MLME_DISABLED;
>  		return;
>  	}
> =20
> -	ifsta->state =3D IEEE80211_AUTHENTICATE;
> +	ifsta->state =3D IEEE80211_STA_MLME_AUTHENTICATE;
>  	printk(KERN_DEBUG "%s: authenticate with AP %s\n",
>  	       dev->name, print_mac(mac, ifsta->bssid));
> =20
> @@ -1010,17 +1010,17 @@ static void ieee80211_associate(struct net_device=
 *dev,
>  		printk(KERN_DEBUG "%s: association with AP %s"
>  		       " timed out\n",
>  		       dev->name, print_mac(mac, ifsta->bssid));
> -		ifsta->state =3D IEEE80211_DISABLED;
> +		ifsta->state =3D IEEE80211_STA_MLME_DISABLED;
>  		return;
>  	}
> =20
> -	ifsta->state =3D IEEE80211_ASSOCIATE;
> +	ifsta->state =3D IEEE80211_STA_MLME_ASSOCIATE;
>  	printk(KERN_DEBUG "%s: associate with AP %s\n",
>  	       dev->name, print_mac(mac, ifsta->bssid));
>  	if (ieee80211_privacy_mismatch(dev, ifsta)) {
>  		printk(KERN_DEBUG "%s: mismatch in privacy configuration and "
>  		       "mixed-cell disabled - abort association\n", dev->name);
> -		ifsta->state =3D IEEE80211_DISABLED;
> +		ifsta->state =3D IEEE80211_STA_MLME_DISABLED;
>  		return;
>  	}
> =20
> @@ -1043,7 +1043,7 @@ static void ieee80211_associated(struct net_device =
*dev,
>  	 * for better APs. */
>  	/* TODO: remove expired BSSes */
> =20
> -	ifsta->state =3D IEEE80211_ASSOCIATED;
> +	ifsta->state =3D IEEE80211_STA_MLME_ASSOCIATED;
> =20
>  	rcu_read_lock();
> =20
> @@ -1086,7 +1086,7 @@ static void ieee80211_associated(struct net_device =
*dev,
>  		sta_info_destroy(sta);
> =20
>  	if (disassoc) {
> -		ifsta->state =3D IEEE80211_DISABLED;
> +		ifsta->state =3D IEEE80211_STA_MLME_DISABLED;
>  		ieee80211_set_associated(dev, ifsta, 0);
>  	} else {
>  		mod_timer(&ifsta->timer, jiffies +
> @@ -1851,7 +1851,7 @@ static void ieee80211_rx_mgmt_auth(struct net_devic=
e *dev,
>  	u16 auth_alg, auth_transaction, status_code;
>  	DECLARE_MAC_BUF(mac);
> =20
> -	if (ifsta->state !=3D IEEE80211_AUTHENTICATE &&
> +	if (ifsta->state !=3D IEEE80211_STA_MLME_AUTHENTICATE &&
>  	    sdata->vif.type !=3D IEEE80211_IF_TYPE_IBSS)
>  		return;
> =20
> @@ -1955,10 +1955,10 @@ static void ieee80211_rx_mgmt_deauth(struct net_d=
evice *dev,
>  	if (ifsta->flags & IEEE80211_STA_AUTHENTICATED)
>  		printk(KERN_DEBUG "%s: deauthenticated\n", dev->name);
> =20
> -	if (ifsta->state =3D=3D IEEE80211_AUTHENTICATE ||
> -	    ifsta->state =3D=3D IEEE80211_ASSOCIATE ||
> -	    ifsta->state =3D=3D IEEE80211_ASSOCIATED) {
> -		ifsta->state =3D IEEE80211_AUTHENTICATE;
> +	if (ifsta->state =3D=3D IEEE80211_STA_MLME_AUTHENTICATE ||
> +	    ifsta->state =3D=3D IEEE80211_STA_MLME_ASSOCIATE ||
> +	    ifsta->state =3D=3D IEEE80211_STA_MLME_ASSOCIATED) {
> +		ifsta->state =3D IEEE80211_STA_MLME_AUTHENTICATE;
>  		mod_timer(&ifsta->timer, jiffies +
>  				      IEEE80211_RETRY_AUTH_INTERVAL);
>  	}
> @@ -1987,8 +1987,8 @@ static void ieee80211_rx_mgmt_disassoc(struct net_d=
evice *dev,
>  	if (ifsta->flags & IEEE80211_STA_ASSOCIATED)
>  		printk(KERN_DEBUG "%s: disassociated\n", dev->name);
> =20
> -	if (ifsta->state =3D=3D IEEE80211_ASSOCIATED) {
> -		ifsta->state =3D IEEE80211_ASSOCIATE;
> +	if (ifsta->state =3D=3D IEEE80211_STA_MLME_ASSOCIATED) {
> +		ifsta->state =3D IEEE80211_STA_MLME_ASSOCIATE;
>  		mod_timer(&ifsta->timer, jiffies +
>  				      IEEE80211_RETRY_AUTH_INTERVAL);
>  	}
> @@ -2019,7 +2019,7 @@ static void ieee80211_rx_mgmt_assoc_resp(struct iee=
e80211_sub_if_data *sdata,
>  	/* AssocResp and ReassocResp have identical structure, so process both
>  	 * of them in this function. */
> =20
> -	if (ifsta->state !=3D IEEE80211_ASSOCIATE)
> +	if (ifsta->state !=3D IEEE80211_STA_MLME_ASSOCIATE)
>  		return;
> =20
>  	if (len < 24 + 6)
> @@ -2506,7 +2506,7 @@ static int ieee80211_sta_join_ibss(struct net_devic=
e *dev,
> =20
>  	ieee80211_sta_def_wmm_params(dev, bss, 1);
> =20
> -	ifsta->state =3D IEEE80211_IBSS_JOINED;
> +	ifsta->state =3D IEEE80211_STA_MLME_IBSS_JOINED;
>  	mod_timer(&ifsta->timer, jiffies + IEEE80211_IBSS_MERGE_INTERVAL);
> =20
>  	memset(&wrqu, 0, sizeof(wrqu));
> @@ -2983,7 +2983,7 @@ static void ieee80211_rx_mgmt_probe_req(struct net_=
device *dev,
>  #endif
> =20
>  	if (sdata->vif.type !=3D IEEE80211_IF_TYPE_IBSS ||
> -	    ifsta->state !=3D IEEE80211_IBSS_JOINED ||
> +	    ifsta->state !=3D IEEE80211_STA_MLME_IBSS_JOINED ||
>  	    len < 24 + 2 || !ifsta->probe_resp)
>  		return;
> =20
> @@ -3310,7 +3310,7 @@ void ieee80211_start_mesh(struct net_device *dev)
>  	struct ieee80211_if_sta *ifsta;
>  	struct ieee80211_sub_if_data *sdata =3D IEEE80211_DEV_TO_SUB_IF(dev);
>  	ifsta =3D &sdata->u.sta;
> -	ifsta->state =3D IEEE80211_MESH_UP;
> +	ifsta->state =3D IEEE80211_STA_MLME_MESH_UP;
>  	ieee80211_sta_timer((unsigned long)sdata);
>  	ieee80211_if_config(sdata, IEEE80211_IFCC_BEACON);
>  }
> @@ -3359,8 +3359,8 @@ void ieee80211_sta_work(struct work_struct *work)
>  		mesh_path_start_discovery(dev);
>  #endif
> =20
> -	if (ifsta->state !=3D IEEE80211_AUTHENTICATE &&
> -	    ifsta->state !=3D IEEE80211_ASSOCIATE &&
> +	if (ifsta->state !=3D IEEE80211_STA_MLME_AUTHENTICATE &&
> +	    ifsta->state !=3D IEEE80211_STA_MLME_ASSOCIATE &&
>  	    test_and_clear_bit(IEEE80211_STA_REQ_SCAN, &ifsta->request)) {
>  		if (ifsta->scan_ssid_len)
>  			ieee80211_sta_start_scan(dev, ifsta->scan_ssid, ifsta->scan_ssid_len)=
;
> @@ -3377,25 +3377,25 @@ void ieee80211_sta_work(struct work_struct *work)
>  		return;
> =20
>  	switch (ifsta->state) {
> -	case IEEE80211_DISABLED:
> +	case IEEE80211_STA_MLME_DISABLED:
>  		break;
> -	case IEEE80211_AUTHENTICATE:
> +	case IEEE80211_STA_MLME_AUTHENTICATE:
>  		ieee80211_authenticate(dev, ifsta);
>  		break;
> -	case IEEE80211_ASSOCIATE:
> +	case IEEE80211_STA_MLME_ASSOCIATE:
>  		ieee80211_associate(dev, ifsta);
>  		break;
> -	case IEEE80211_ASSOCIATED:
> +	case IEEE80211_STA_MLME_ASSOCIATED:
>  		ieee80211_associated(dev, ifsta);
>  		break;
> -	case IEEE80211_IBSS_SEARCH:
> +	case IEEE80211_STA_MLME_IBSS_SEARCH:
>  		ieee80211_sta_find_ibss(dev, ifsta);
>  		break;
> -	case IEEE80211_IBSS_JOINED:
> +	case IEEE80211_STA_MLME_IBSS_JOINED:
>  		ieee80211_sta_merge_ibss(dev, ifsta);
>  		break;
>  #ifdef CONFIG_MAC80211_MESH
> -	case IEEE80211_MESH_UP:
> +	case IEEE80211_STA_MLME_MESH_UP:
>  		ieee80211_mesh_housekeeping(dev, ifsta);
>  		break;
>  #endif
> @@ -3540,20 +3540,20 @@ static int ieee80211_sta_config_auth(struct net_d=
evice *dev,
>  		ieee80211_sta_set_bssid(dev, selected->bssid);
>  		ieee80211_sta_def_wmm_params(dev, selected, 0);
>  		ieee80211_rx_bss_put(local, selected);
> -		ifsta->state =3D IEEE80211_AUTHENTICATE;
> +		ifsta->state =3D IEEE80211_STA_MLME_AUTHENTICATE;
>  		ieee80211_sta_reset_auth(dev, ifsta);
>  		return 0;
>  	} else {
> -		if (ifsta->state !=3D IEEE80211_AUTHENTICATE) {
> +		if (ifsta->state !=3D IEEE80211_STA_MLME_AUTHENTICATE) {
>  			if (ifsta->flags & IEEE80211_STA_AUTO_SSID_SEL)
>  				ieee80211_sta_start_scan(dev, NULL, 0);
>  			else
>  				ieee80211_sta_start_scan(dev, ifsta->ssid,
>  							 ifsta->ssid_len);
> -			ifsta->state =3D IEEE80211_AUTHENTICATE;
> +			ifsta->state =3D IEEE80211_STA_MLME_AUTHENTICATE;
>  			set_bit(IEEE80211_STA_REQ_AUTH, &ifsta->request);
>  		} else
> -			ifsta->state =3D IEEE80211_DISABLED;
> +			ifsta->state =3D IEEE80211_STA_MLME_DISABLED;
>  	}
>  	return -1;
>  }
> @@ -3692,7 +3692,7 @@ dont_join:
>  #endif /* CONFIG_MAC80211_IBSS_DEBUG */
> =20
>  	/* Selected IBSS not found in current scan results - try to scan */
> -	if (ifsta->state =3D=3D IEEE80211_IBSS_JOINED &&
> +	if (ifsta->state =3D=3D IEEE80211_STA_MLME_IBSS_JOINED &&
>  	    !ieee80211_sta_active_ibss(dev)) {
>  		mod_timer(&ifsta->timer, jiffies +
>  				      IEEE80211_IBSS_MERGE_INTERVAL);
> @@ -3702,7 +3702,7 @@ dont_join:
>  		       "join\n", dev->name);
>  		return ieee80211_sta_req_scan(dev, ifsta->ssid,
>  					      ifsta->ssid_len);
> -	} else if (ifsta->state !=3D IEEE80211_IBSS_JOINED) {
> +	} else if (ifsta->state !=3D IEEE80211_STA_MLME_IBSS_JOINED) {
>  		int interval =3D IEEE80211_SCAN_INTERVAL;
> =20
>  		if (time_after(jiffies, ifsta->ibss_join_req +
> @@ -3722,7 +3722,7 @@ dont_join:
>  			interval =3D IEEE80211_SCAN_INTERVAL_SLOW;
>  		}
> =20
> -		ifsta->state =3D IEEE80211_IBSS_SEARCH;
> +		ifsta->state =3D IEEE80211_STA_MLME_IBSS_SEARCH;
>  		mod_timer(&ifsta->timer, jiffies + interval);
>  		return 0;
>  	}
> @@ -3770,7 +3770,7 @@ int ieee80211_sta_set_ssid(struct net_device *dev, =
char *ssid, size_t len)
>  	if (sdata->vif.type =3D=3D IEEE80211_IF_TYPE_IBSS &&
>  	    !(ifsta->flags & IEEE80211_STA_BSSID_SET)) {
>  		ifsta->ibss_join_req =3D jiffies;
> -		ifsta->state =3D IEEE80211_IBSS_SEARCH;
> +		ifsta->state =3D IEEE80211_STA_MLME_IBSS_SEARCH;
>  		return ieee80211_sta_find_ibss(dev, ifsta);
>  	}
> =20
> @@ -3920,7 +3920,7 @@ done:
>  	if (sdata->vif.type =3D=3D IEEE80211_IF_TYPE_IBSS) {
>  		struct ieee80211_if_sta *ifsta =3D &sdata->u.sta;
>  		if (!(ifsta->flags & IEEE80211_STA_BSSID_SET) ||
> -		    (!(ifsta->state =3D=3D IEEE80211_IBSS_JOINED) &&
> +		    (!(ifsta->state =3D=3D IEEE80211_STA_MLME_IBSS_JOINED) &&
>  		    !ieee80211_sta_active_ibss(dev)))
>  			ieee80211_sta_find_ibss(dev, ifsta);
>  	}
> diff --git a/net/mac80211/wext.c b/net/mac80211/wext.c
> index 34fa8ed..4de14a5 100644
> --- a/net/mac80211/wext.c
> +++ b/net/mac80211/wext.c
> @@ -539,8 +539,8 @@ static int ieee80211_ioctl_giwap(struct net_device *d=
ev,
>  	sdata =3D IEEE80211_DEV_TO_SUB_IF(dev);
>  	if (sdata->vif.type =3D=3D IEEE80211_IF_TYPE_STA ||
>  	    sdata->vif.type =3D=3D IEEE80211_IF_TYPE_IBSS) {
> -		if (sdata->u.sta.state =3D=3D IEEE80211_ASSOCIATED ||
> -		    sdata->u.sta.state =3D=3D IEEE80211_IBSS_JOINED) {
> +		if (sdata->u.sta.state =3D=3D IEEE80211_STA_MLME_ASSOCIATED ||
> +		    sdata->u.sta.state =3D=3D IEEE80211_STA_MLME_IBSS_JOINED) {
>  			ap_addr->sa_family =3D ARPHRD_ETHER;
>  			memcpy(&ap_addr->sa_data, sdata->u.sta.bssid, ETH_ALEN);
>  			return 0;

--=-4YSoOw89VxJ8BGjVPTtp
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJImYrVAAoJEKVg1VMiehFYYJEP/2Be5j6ul/2raoIMqtT7PTlv
BS+0M53wC+QNNfmqMCgQ/teImS0EWSeqPFA7zFzbzBd/YZUng4UUQ9ak8tf1q1wq
0kZBfi74y2hD5xm85muwzQSspE1jTDNmE0OUEzoo4ZObH98eVeq1x4pHCot160OU
cwBwTJBiCo/JNDTJlsdS/phkCkCGBPDh9X9k8L2gako5MYWTjxIOfFjY38ksCf6O
+r6T4Q8cR4OxybkfxzO3ZCKZjz5Xq4/eKTsukkIDMoNGZnHqWWuN59StAulvWAb8
x3e3QyAT01wsU1X0oDjfZkv4In/ANJA47I1HYbGItm3IJgnMNSwgtyeSdpBMOeAf
xkzx3L3OtKZN6AuiIu9lkHMfHaGMFJDPIDWoXjggdOT3+hN0Xw6PWCQYcZRtrB6u
L0agmOxs6HV6WCiuYDipIZxcN6XuSC7/4OSA7P03eGdq79PFIXLgAsutyaK/yOaJ
Tr5k6lEmxOFpK97HomMnA16Hgd+rb8YZrxx16rl90+OOXwYzdGEOOe5NevMSp4xu
Sr8sf99mKayEBl6iBHudvpmjZhWBfi1CykT+h6VsKaBn+iGxal0E7pnJCrOkNPQF
QsA6fhpMS6dodRbMvngGUc8L6dE3vSi9YL02aMWpvXOjE1RYTaksAQKjpDnTfiiM
nHNa43JbyopX0DGpZnxy
=wITz
-----END PGP SIGNATURE-----

--=-4YSoOw89VxJ8BGjVPTtp--

