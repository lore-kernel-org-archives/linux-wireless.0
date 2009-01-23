Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 27.mail-out.ovh.net ([91.121.30.210]:35746 "HELO
	27.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753120AbZAWMdf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2009 07:33:35 -0500
Date: Fri, 23 Jan 2009 13:29:21 +0100
From: Samuel Ortiz <samuel@sortiz.org>
To: Alina Friedrichsen <x-alina@gmx.net>
Cc: Larry Finger <Larry.Finger@lwfinger.net>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, maximlevitsky@gmail.com,
	kalle.valo@iki.fi
Subject: Re: Regression caused by commit
	e32b1b9a33759e8a83ac566c4c43f23ed5d6343b
Message-ID: <20090123122921.GA2745@sortiz.org> (sfid-20090123_133340_933354_1AB8D283)
Reply-To: Samuel Ortiz <samuel@sortiz.org>
References: <4979269F.1060500@lwfinger.net> <20090123021413.GB3177@tuxdriver.com> <4979567D.2020005@lwfinger.net> <20090123071345.270730@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <20090123071345.270730@gmx.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 23, 2009 at 08:13:45AM +0100, Alina Friedrichsen wrote:
> Hello!
>=20
> > > I reverted this in wireless-testing (and it never went anywhere
> > > upstream).  Of course, now it looks like Samuel has a fix...maybe
> > > I'll combine them...
> >=20
> > Samuel's fix works for me.
>=20
> If this works for the others too, I would propose the following patch=
=2E Without it, e.g. the beacon messages in IBSS mode are broken, if yo=
u set a fixed BSSID.
>=20
> (The iwl4965 low level driver sends back an error code, if you want t=
o set a fixed BSSID, so I think, we should simply ignore it, as it will=
 be tried the next time when the initiated new network join is complete=
=2E)
>
I dont think we should ignore the if_config() return value.
Is the 4965 error code sent when trying to set a fixed BSSID in IBSS ?
I dont see it in STA mode, when associating to my AP.

Cheers,
Samuel.
=20
> Regards
> Alina
>=20
> --=20
> Psssst! Schon vom neuen GMX MultiMessenger geh=F6rt? Der kann`s mit a=
llen: http://www.gmx.net/de/go/multimessenger

> diff -urN compat-wireless-2009-01-23.orig/net/mac80211/mlme.c compat-=
wireless-2009-01-23/net/mac80211/mlme.c
> --- compat-wireless-2009-01-23.orig/net/mac80211/mlme.c	2009-01-23 06=
:12:14.000000000 +0100
> +++ compat-wireless-2009-01-23/net/mac80211/mlme.c	2009-01-23 07:58:3=
1.000000000 +0100
> @@ -1614,6 +1614,7 @@
> =20
>  	ieee80211_sta_def_wmm_params(sdata, bss);
> =20
> +	ifsta->flags |=3D IEEE80211_STA_PREV_BSSID_SET;
>  	ifsta->state =3D IEEE80211_STA_MLME_IBSS_JOINED;
>  	mod_timer(&ifsta->timer, jiffies + IEEE80211_IBSS_MERGE_INTERVAL);
> =20
> @@ -2177,19 +2178,18 @@
>  	int i;
>  	int ret;
> =20
> -#if 0
> -	/* Easier testing, use fixed BSSID. */
> -	memset(bssid, 0xfe, ETH_ALEN);
> -#else
> -	/* Generate random, not broadcast, locally administered BSSID. Mix =
in
> -	 * own MAC address to make sure that devices that do not have prope=
r
> -	 * random number generator get different BSSID. */
> -	get_random_bytes(bssid, ETH_ALEN);
> -	for (i =3D 0; i < ETH_ALEN; i++)
> -		bssid[i] ^=3D sdata->dev->dev_addr[i];
> -	bssid[0] &=3D ~0x01;
> -	bssid[0] |=3D 0x02;
> -#endif
> +	if (sdata->u.sta.flags & IEEE80211_STA_BSSID_SET) {
> +		memcpy(bssid, ifsta->bssid, ETH_ALEN);
> +	} else {
> +		/* Generate random, not broadcast, locally administered BSSID. Mix=
 in
> +		 * own MAC address to make sure that devices that do not have prop=
er
> +		 * random number generator get different BSSID. */
> +		get_random_bytes(bssid, ETH_ALEN);
> +		for (i =3D 0; i < ETH_ALEN; i++)
> +			bssid[i] ^=3D sdata->dev->dev_addr[i];
> +		bssid[0] &=3D ~0x01;
> +		bssid[0] |=3D 0x02;
> +	}
> =20
>  	printk(KERN_DEBUG "%s: Creating new IBSS network, BSSID %pM\n",
>  	       sdata->dev->name, bssid);
> @@ -2250,6 +2250,9 @@
>  		    memcmp(ifsta->ssid, bss->ssid, bss->ssid_len) !=3D 0
>  		    || !(bss->capability & WLAN_CAPABILITY_IBSS))
>  			continue;
> +		if ((ifsta->flags & IEEE80211_STA_BSSID_SET) &&
> +		    memcmp(ifsta->bssid, bss->bssid, ETH_ALEN) !=3D 0)
> +			continue;
>  #ifdef CONFIG_MAC80211_IBSS_DEBUG
>  		printk(KERN_DEBUG "   bssid=3D%pM found\n", bss->bssid);
>  #endif /* CONFIG_MAC80211_IBSS_DEBUG */
> @@ -2266,7 +2269,9 @@
>  		       "%pM\n", bssid, ifsta->bssid);
>  #endif /* CONFIG_MAC80211_IBSS_DEBUG */
> =20
> -	if (found && memcmp(ifsta->bssid, bssid, ETH_ALEN) !=3D 0) {
> +	if (found &&
> +	    ((!(ifsta->flags & IEEE80211_STA_PREV_BSSID_SET)) ||
> +	     memcmp(ifsta->bssid, bssid, ETH_ALEN) !=3D 0)) {
>  		int ret;
>  		int search_freq;
> =20
> @@ -2604,16 +2609,16 @@
>  		memset(ifsta->ssid, 0, sizeof(ifsta->ssid));
>  		memcpy(ifsta->ssid, ssid, len);
>  		ifsta->ssid_len =3D len;
> -		ifsta->flags &=3D ~IEEE80211_STA_PREV_BSSID_SET;
>  	}
> =20
> +	ifsta->flags &=3D ~IEEE80211_STA_PREV_BSSID_SET;
> +
>  	if (len)
>  		ifsta->flags |=3D IEEE80211_STA_SSID_SET;
>  	else
>  		ifsta->flags &=3D ~IEEE80211_STA_SSID_SET;
> =20
> -	if (sdata->vif.type =3D=3D NL80211_IFTYPE_ADHOC &&
> -	    !(ifsta->flags & IEEE80211_STA_BSSID_SET)) {
> +	if (sdata->vif.type =3D=3D NL80211_IFTYPE_ADHOC) {
>  		ifsta->ibss_join_req =3D jiffies;
>  		ifsta->state =3D IEEE80211_STA_MLME_IBSS_SEARCH;
>  		return ieee80211_sta_find_ibss(sdata, ifsta);
> @@ -2633,36 +2638,21 @@
>  int ieee80211_sta_set_bssid(struct ieee80211_sub_if_data *sdata, u8 =
*bssid)
>  {
>  	struct ieee80211_if_sta *ifsta;
> -	int res;
> -	bool valid;
> =20
>  	ifsta =3D &sdata->u.sta;
> -	valid =3D is_valid_ether_addr(bssid);
> =20
> -	if (memcmp(ifsta->bssid, bssid, ETH_ALEN) !=3D 0) {
> -		if(valid)
> -			memcpy(ifsta->bssid, bssid, ETH_ALEN);
> -		else
> -			memset(ifsta->bssid, 0, ETH_ALEN);
> -		res =3D 0;
> -		/*
> -		 * Hack! See also ieee80211_sta_set_ssid.
> -		 */
> -		if (netif_running(sdata->dev))
> -			res =3D ieee80211_if_config(sdata, IEEE80211_IFCC_BSSID);
> -		if (res) {
> -			printk(KERN_DEBUG "%s: Failed to config new BSSID to "
> -			       "the low-level driver\n", sdata->dev->name);
> -			return res;
> -		}
> -	}
> -
> -	if (valid)
> +	if (is_valid_ether_addr(bssid)) {
> +		memcpy(ifsta->bssid, bssid, ETH_ALEN);
>  		ifsta->flags |=3D IEEE80211_STA_BSSID_SET;
> -	else
> +	} else {
> +		memset(ifsta->bssid, 0, ETH_ALEN);
>  		ifsta->flags &=3D ~IEEE80211_STA_BSSID_SET;
> +	}
> =20
> -	return 0;
> +	if (netif_running(sdata->dev))
> +		ieee80211_if_config(sdata, IEEE80211_IFCC_BSSID);
> +
> +	return ieee80211_sta_set_ssid(sdata, ifsta->ssid, ifsta->ssid_len);
>  }
> =20
>  int ieee80211_sta_set_extra_ie(struct ieee80211_sub_if_data *sdata, =
char *ie, size_t len)


--=20
Intel Open Source Technology Centre
http://oss.intel.com/
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
