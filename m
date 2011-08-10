Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:35458 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753512Ab1HJLc6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Aug 2011 07:32:58 -0400
Received: by fxd18 with SMTP id 18so817741fxd.25
        for <linux-wireless@vger.kernel.org>; Wed, 10 Aug 2011 04:32:56 -0700 (PDT)
Subject: Re: [PATCH 09/40] wl12xx: enable/disable role on interface
 add/remove
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1312881233-9366-10-git-send-email-eliad@wizery.com>
References: <1312881233-9366-1-git-send-email-eliad@wizery.com>
	 <1312881233-9366-10-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 10 Aug 2011 14:32:53 +0300
Message-ID: <1312975973.2407.545.camel@cumari> (sfid-20110810_133302_142207_2CE44FB4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-08-09 at 12:13 +0300, Eliad Peller wrote: 
> +static u8 wl1271_get_role_type(struct wl1271 *wl)
> +{
> +	switch (wl->bss_type) {
> +	case BSS_TYPE_AP_BSS:
> +		return WL1271_ROLE_AP;
> +
> +	case BSS_TYPE_STA_BSS:
> +		return WL1271_ROLE_STA;
> +
> +	default:
> +		wl1271_info("invalid bss_type: %d", wl->bss_type);
> +	}
> +	return 0xff;
> +}
> +
>  static int wl1271_op_add_interface(struct ieee80211_hw *hw,
>  				   struct ieee80211_vif *vif)
>  {
>  	struct wl1271 *wl = hw->priv;
>  	struct wiphy *wiphy = hw->wiphy;
>  	int retries = WL1271_BOOT_RETRIES;
> @@ -1836,12 +1851,17 @@ static int wl1271_op_add_interface(struct ieee80211_hw *hw,
>  			goto power_off;
>  
>  		ret = wl1271_boot(wl);
>  		if (ret < 0)
>  			goto power_off;
>  
> +		ret = wl1271_cmd_role_enable(wl, wl1271_get_role_type(wl),
> +					     &wl->role_id);
> +		if (ret < 0)
> +			goto irq_disable;
> +

This doesn't look right, because if the type is invalid, you will return
0xff and it will still be sent anyway to the firmware via
CMD_ROLE_ENABLE.  It will _probably_ still work as expected, because the
firmware will hopefully return an error to that command and we will fail
the op_add_interface.  But this will be ugly, because we'll print
"firmware boot failed", which is not true and so on.

Maybe you should add a role_type to wl (we will most likely need it in
the vif struct later anyway) or somehow merge this with the existing
bss_type.  At least you could check the role type in the same "switch
(vif->type)".


> static void __wl1271_op_remove_interface(struct wl1271 *wl,
>  					 bool reset_tx_queues)
>  {
> +	int ret;
>  
>  	wl1271_debug(DEBUG_MAC80211, "mac80211 remove interface");
>  
>  	/* because of hardware recovery, we may get here twice */
>  	if (wl->state != WL1271_STATE_ON)
>  		return;
> @@ -1924,12 +1945,29 @@ static void __wl1271_op_remove_interface(struct wl1271 *wl,
>  		wl->scan.state = WL1271_SCAN_STATE_IDLE;
>  		memset(wl->scan.scanned_ch, 0, sizeof(wl->scan.scanned_ch));
>  		wl->scan.req = NULL;
>  		ieee80211_scan_completed(wl->hw, true);
>  	}
>  
> +	if (!test_bit(WL1271_FLAG_RECOVERY_IN_PROGRESS, &wl->flags)) {
> +		/* disable active roles */
> +		ret = wl1271_ps_elp_wakeup(wl);
> +		if (ret < 0) {
> +			/*
> +			 * do nothing. we are going to power off the chip
> +			 * anyway. handle this case when we'll really
> +			 * support multi-role...
> +			 */
> +		}
> +		wl1271_cmd_role_disable(wl, &wl->role_id);

Okay, we can do nothing for now, but should we then at least skip the
wl1271_cmd_role_disable() call? I guess that will also fail if we could
not wake up...

-- 
Cheers,
Luca.

