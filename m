Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2523 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757792Ab2EaMSO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 May 2012 08:18:14 -0400
Message-ID: <4FC76176.4030700@broadcom.com> (sfid-20120531_141820_197490_AB46C09E)
Date: Thu, 31 May 2012 14:17:58 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Victor Goldenshtein" <victorg@ti.com>
cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Subject: Re: [PATCH v2] mac80211: add command to get current rssi
References: <1338463991-7741-1-git-send-email-victorg@ti.com>
In-Reply-To: <1338463991-7741-1-git-send-email-victorg@ti.com>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/31/2012 01:33 PM, Victor Goldenshtein wrote:
> Get current rssi (in dBm) from the driver/FW.
> 
> Instead of reporting the signal received in the last
> rx packet, which might be inaccurate if rx traffic is
> low and beacon filtering is enabled, get the singal
> from the driver/FW.
> 
> Signed-off-by: Victor Goldenshtein <victorg@ti.com>
> ---
> 
> v2:
>    updated function documentation.
>    added *sta argument to the drv_get_rssi().
>    added return value to the drv_get_rssi().   
> 
>  include/net/mac80211.h      |    5 +++++
>  net/mac80211/cfg.c          |   21 +++++++++++++--------
>  net/mac80211/driver-ops.h   |   16 ++++++++++++++++
>  net/mac80211/driver-trace.h |    6 ++++++
>  4 files changed, 40 insertions(+), 8 deletions(-)
> 
> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
> index 4d6e6c6..3758612 100644
> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h
> @@ -2231,6 +2231,9 @@ enum ieee80211_rate_control_changed {
>   * @get_et_strings:  Ethtool API to get a set of strings to describe stats
>   *	and perhaps other supported types of ethtool data-sets.
>   *
> + * @get_rssi: Get current signal strength in dBm, the function is optional
> + *	and must be allowed to sleep.
> + *

This documentation is provided for the driver. mac80211 already allows
this callback to sleep. So rephrase 'must be allowed to sleep' to 'is
allowed to sleep' or 'can sleep'.

> @@ -517,7 +520,7 @@ static void ieee80211_get_et_stats(struct wiphy *wiphy,
>  	 * network device.
>  	 */
>  
> -	rcu_read_lock();
> +	mutex_lock(&local->sta_mtx);
>  
>  	if (sdata->vif.type == NL80211_IFTYPE_STATION) {
>  		sta = sta_info_get_bss(sdata, sdata->u.mgd.bssid);
> @@ -546,7 +549,7 @@ static void ieee80211_get_et_stats(struct wiphy *wiphy,
>  			data[i] = (u8)sinfo.signal_avg;
>  		i++;
>  	} else {
> -		list_for_each_entry_rcu(sta, &local->sta_list, list) {
> +		list_for_each_entry(sta, &local->sta_list, list) {
>  			/* Make sure this station belongs to the proper dev */
>  			if (sta->sdata->dev != dev)
>  				continue;

Just for my curiosity/learning: How are these related to the new
callback? Is it because you are now doing the callback in sta_set_sinfo()?

Gr. AvS

