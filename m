Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:7852 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756023Ab1ELKhz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 May 2011 06:37:55 -0400
Date: Thu, 12 May 2011 12:37:03 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: wey-yi.w.guy@intel.com, ilw@linux.intel.com,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	jirislaby@gmail.com, Reinette Chatre <reinette.chatre@intel.com>
Subject: Re: [PATCH] iwlwifi: fix TX power configuration on 3945 and 4965
 devices
Message-ID: <20110512103702.GA3292@redhat.com> (sfid-20110512_123802_768510_8906BBB2)
References: <1305194124-46828-1-git-send-email-jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1305194124-46828-1-git-send-email-jslaby@suse.cz>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 12, 2011 at 11:55:24AM +0200, Jiri Slaby wrote:
> From: Reinette Chatre <reinette.chatre@intel.com>
> 
> When receiving a TX power change request from mac80211 the functions
> servicing these requests for 3945 and 4965 uses information in the
> active RXON. In iwl_mac_config the staging RXON is prepared based on
> various directions from mac80211 and only at the end is the staging
> RXON committed to the device and the active RXON updated.
> 
> By servicing the TX power change request while servicing the other
> requests that modify the staging RXON we loose the new information
> provided by mac80211.
> 
> Fix this by servicing the TX power change request after the RXON has
> been committed to the device and active RXON thus contains accurate
> information.
> 
> References: https://bugzilla.novell.com/show_bug.cgi?id=610421

That problem is already fixed in 2.6.38 by:

commit 21db55a9dc4e52d8d2cac30f47efcec3afccb0c5
Author:     Stanislaw Gruszka <sgruszka@redhat.com>
AuthorDate: Fri Jan 28 16:47:44 2011 +0100
Commit:     Greg Kroah-Hartman <gregkh@suse.de>
CommitDate: Mon May 2 09:19:48 2011 -0700

    iwlwifi: do not set tx power when channel is changing

> --- a/drivers/net/wireless/iwlegacy/iwl-core.c
> +++ b/drivers/net/wireless/iwlegacy/iwl-core.c
> @@ -2220,13 +2220,6 @@ int iwl_legacy_mac_config(struct ieee802
>  			IWL_DEBUG_MAC80211(priv, "Error setting sleep level\n");
>  	}
>  
> -	if (changed & IEEE80211_CONF_CHANGE_POWER) {
> -		IWL_DEBUG_MAC80211(priv, "TX Power old=%d new=%d\n",
> -			priv->tx_power_user_lmt, conf->power_level);
> -
> -		iwl_legacy_set_tx_power(priv, conf->power_level, false);
> -	}
> -
>  	if (!iwl_legacy_is_ready(priv)) {
>  		IWL_DEBUG_MAC80211(priv, "leave - not ready\n");
>  		goto out;
> @@ -2245,6 +2238,14 @@ int iwl_legacy_mac_config(struct ieee802
>  			iwl_legacy_update_qos(priv, ctx);
>  	}
>  
> +	if (changed & IEEE80211_CONF_CHANGE_POWER) {
> +		IWL_DEBUG_MAC80211(priv, "TX Power old=%d new=%d\n",
> +			priv->tx_power_user_lmt, conf->power_level);
> +
> +		iwl_legacy_set_tx_power(priv, conf->power_level, false);
> +	}

This disallow to set tx power during scan process, NACK.

Stanislaw
