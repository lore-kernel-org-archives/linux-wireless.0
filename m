Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:35118 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753469AbYLIRk7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Dec 2008 12:40:59 -0500
Subject: Re: [RFC] mac80211: Disable requests for new scans in AP mode
From: Dan Williams <dcbw@redhat.com>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20081209145722.GA2285@jm.kir.nu>
References: <20081209145722.GA2285@jm.kir.nu>
Content-Type: text/plain
Date: Tue, 09 Dec 2008 12:40:10 -0500
Message-Id: <1228844410.17539.1.camel@localhost.localdomain> (sfid-20081209_184103_020977_6E9DCF3E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-12-09 at 16:57 +0200, Jouni Malinen wrote:
> AP mode operations are seriously affected if mac80211 runs through a
> multi-second scan while the AP is trying to send Beacon frames on the
> operation channel. While this could be implemented in a way that does
> not cause too many problems, it is not very simple and will require
> synchronization with Beacon frame scheduling in the drivers (scan one
> channel at a time between Beacon frames). Furthermore, such scanning
> takes quite a bit longer time and existing userspace applications
> would be likely to timeout while waiting for the results.
> 
> For now, just refuse requests for new scans (SIOCSIWSCAN) when in AP
> mode. In practice, this moves the rejection from iwl* drivers into
> mac80211 to make it apply to every mac80211-based driver.
> 
> This issue shows up in associated stations getting disconnected when
> something (e.g., Network Manager) requests a scan while the interface
> is in AP mode. When doing this continuously (e.g., NM does it every 60
> seconds), the network gets close to useless.

Every 120 seconds usually (it uses a simple backoff algorithm), but
yeah, this is a good thing to do.  You probably want to make NM ignore
the device if you're configuring it as an AP though, since obviously NM
shouldn't be driving an AP mode interface.

Dan

> Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>
> 
> 
> Index: wireless-testing/drivers/net/wireless/iwlwifi/iwl-agn.c
> ===================================================================
> --- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl-agn.c	2008-12-09 16:27:49.000000000 +0200
> +++ wireless-testing/drivers/net/wireless/iwlwifi/iwl-agn.c	2008-12-09 16:31:25.000000000 +0200
> @@ -2972,12 +2972,6 @@ static int iwl_mac_hw_scan(struct ieee80
>  		goto out_unlock;
>  	}
>  
> -	if (priv->iw_mode == NL80211_IFTYPE_AP) {	/* APs don't scan */
> -		ret = -EIO;
> -		IWL_ERROR("ERROR: APs don't scan\n");
> -		goto out_unlock;
> -	}
> -
>  	/* We don't schedule scan within next_scan_jiffies period.
>  	 * Avoid scanning during possible EAPOL exchange, return
>  	 * success immediately.
> Index: wireless-testing/drivers/net/wireless/iwlwifi/iwl3945-base.c
> ===================================================================
> --- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl3945-base.c	2008-12-09 16:34:51.000000000 +0200
> +++ wireless-testing/drivers/net/wireless/iwlwifi/iwl3945-base.c	2008-12-09 16:35:14.000000000 +0200
> @@ -2105,11 +2105,6 @@ static void iwl3945_setup_rxon_timing(st
>  
>  static int iwl3945_scan_initiate(struct iwl3945_priv *priv)
>  {
> -	if (priv->iw_mode == NL80211_IFTYPE_AP) {
> -		IWL_ERROR("APs don't scan.\n");
> -		return 0;
> -	}
> -
>  	if (!iwl3945_is_ready_rf(priv)) {
>  		IWL_DEBUG_SCAN("Aborting scan due to not ready.\n");
>  		return -EIO;
> @@ -6991,12 +6986,6 @@ static int iwl3945_mac_hw_scan(struct ie
>  		goto out_unlock;
>  	}
>  
> -	if (priv->iw_mode == NL80211_IFTYPE_AP) {	/* APs don't scan */
> -		rc = -EIO;
> -		IWL_ERROR("ERROR: APs don't scan\n");
> -		goto out_unlock;
> -	}
> -
>  	/* we don't schedule scan within next_scan_jiffies period */
>  	if (priv->next_scan_jiffies &&
>  			time_after(priv->next_scan_jiffies, jiffies)) {
> Index: wireless-testing/net/mac80211/wext.c
> ===================================================================
> --- wireless-testing.orig/net/mac80211/wext.c	2008-12-09 16:31:01.000000000 +0200
> +++ wireless-testing/net/mac80211/wext.c	2008-12-09 16:31:13.000000000 +0200
> @@ -418,8 +418,7 @@ static int ieee80211_ioctl_siwscan(struc
>  
>  	if (sdata->vif.type != NL80211_IFTYPE_STATION &&
>  	    sdata->vif.type != NL80211_IFTYPE_ADHOC &&
> -	    sdata->vif.type != NL80211_IFTYPE_MESH_POINT &&
> -	    sdata->vif.type != NL80211_IFTYPE_AP)
> +	    sdata->vif.type != NL80211_IFTYPE_MESH_POINT)
>  		return -EOPNOTSUPP;
>  
>  	/* if SSID was specified explicitly then use that */
> 

