Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:58717 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946187Ab3BHJIe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2013 04:08:34 -0500
Message-ID: <1360314503.29851.6.camel@jlt4.sipsolutions.net> (sfid-20130208_100844_659564_70F5684E)
Subject: Re: [PATCHv9 1/3] mac80211: lock AP_VLAN list with iflist_mtx
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org, victorg@ti.com,
	linville@tuxdriver.com, kgiori@qca.qualcomm.com,
	zefir.kurtisi@neratec.com, adrian@freebsd.org, j@w1.fi,
	coelho@ti.com, igalc@ti.com, nbd@nbd.name,
	mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Date: Fri, 08 Feb 2013 10:08:23 +0100
In-Reply-To: <1360262304-28362-2-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1360262304-28362-1-git-send-email-siwu@hrz.tu-chemnitz.de>
	 <1360262304-28362-2-git-send-email-siwu@hrz.tu-chemnitz.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-02-07 at 19:38 +0100, Simon Wunderlich wrote:
> To remove the dependency to rtnl_lock() for
> ieee80211_vif_use/release_channel in AP mode, protect the AP_VLAN
> list with local->iflist_mtx instead.
> 
> RTNL can not be used from within mac80211 workers, but the
> DFS AP interface requires to release channels (after DFS channel
> availability checks).

I have to say ... I don't like this churn.

> @@ -934,12 +936,14 @@ static int ieee80211_start_ap(struct wiphy *wiphy, struct net_device *dev,
>  	 */
>  	sdata->control_port_protocol = params->crypto.control_port_ethertype;
>  	sdata->control_port_no_encrypt = params->crypto.control_port_no_encrypt;
> +	mutex_lock(&sdata->local->iflist_mtx);
>  	list_for_each_entry(vlan, &sdata->u.ap.vlans, u.vlan.list) {
>  		vlan->control_port_protocol =
>  			params->crypto.control_port_ethertype;
>  		vlan->control_port_no_encrypt =
>  			params->crypto.control_port_no_encrypt;
>  	}
> +	mutex_unlock(&sdata->local->iflist_mtx);
>  
>  	sdata->vif.bss_conf.beacon_int = params->beacon_interval;
>  	sdata->vif.bss_conf.dtim_period = params->dtim_period;
> @@ -972,8 +976,10 @@ static int ieee80211_start_ap(struct wiphy *wiphy, struct net_device *dev,
>  	ieee80211_bss_info_change_notify(sdata, changed);
>  
>  	netif_carrier_on(dev);
> +	mutex_lock(&sdata->local->iflist_mtx);
>  	list_for_each_entry(vlan, &sdata->u.ap.vlans, u.vlan.list)
>  		netif_carrier_on(vlan->dev);
> +	mutex_unlock(&sdata->local->iflist_mtx);

Things like this are also questionable -- it still only works because
the RTNL is there.

I'm not sure what the solution would be though -- maybe allowing/using
both locks.

johannes

