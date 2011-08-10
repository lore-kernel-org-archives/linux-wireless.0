Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:55913 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750780Ab1HJObp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Aug 2011 10:31:45 -0400
Received: by fxh2 with SMTP id 2so1188070fxh.23
        for <linux-wireless@vger.kernel.org>; Wed, 10 Aug 2011 07:31:42 -0700 (PDT)
Subject: Re: [PATCH 18/40] wl12xx: replace dummy_join with ROC/CROC commands
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1312881233-9366-19-git-send-email-eliad@wizery.com>
References: <1312881233-9366-1-git-send-email-eliad@wizery.com>
	 <1312881233-9366-19-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 10 Aug 2011 17:31:38 +0300
Message-ID: <1312986698.2407.668.camel@cumari> (sfid-20110810_163148_702865_61EA9DD9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-08-09 at 12:13 +0300, Eliad Peller wrote: 
> The ROC command asks the fw stay on the channel of the given
> hlid. it currently has 2 primary functions:
> 
> 1. Allow tx/rx from the device role.
> 
> In order to tx/rx packets while the stations is not associated
> (e.g. auth req/resp), the device role has to be used, along
> with ROC on its link.
> 
> Keep the logic similiar to the one used in dummy_join. However,
> since we can't scan while we ROC, we add CROC before starting
> a scan, and ROC again (if needed) on scan complete.
> 
> 2. Keeping the antenna for a specific link.
> 
> We ROC until the connection was completed (after EAPOLs exchange)
> in order to prevent BT coex operations from taking the antenna
> and failing the connection (after this stage, psm can be used).
> 
> During association, we ROC on the station role, and then CROC
> the device role, thus assuring being ROC during all the connection
> process.

Nice explanations.  I was wondering if we should have this somewhere in
the code too, so that it's easier to figure out what is going on without
digging into git logs...


> Replace the WL1271_FLAG_JOINED with a new WL1271_FLAG_ROC,
> indicating the fw was configured to ROC. Add a roc bitmap
> to indicate what roles are currently ROCed.

Is it really possible to be ROCed in more than one role? They could be
running on different channels, so how could we physically ROC more than
once at the same time?


> Add wl1271_roc/croc functions in order to wrap the roc/croc
> commands while taking care of the roc bitmap.
> 
> The current ROC/CROC state-machine is a bit complicated. In
> the future we'll probably want to use wpa_supplicant to control
> the ROC during connection.

But when we have multirole, we may have several instances of
wpa_supplicant/hostap running, so there may be some conflicts of
interest there.  I think it's better to keep ROCing in a centralized
place (ie. the driver).


> diff --git a/drivers/net/wireless/wl12xx/cmd.c b/drivers/net/wireless/wl12xx/cmd.c
> index 3091351..918c46b 100644
> --- a/drivers/net/wireless/wl12xx/cmd.c
> +++ b/drivers/net/wireless/wl12xx/cmd.c
> @@ -1484,13 +1484,13 @@ out:
>  
>  static int wl1271_cmd_roc(struct wl1271 *wl, u8 role_id)
>  {
>  	struct wl1271_cmd_roc *cmd;
>  	int ret = 0;
>  
> -	wl1271_debug(DEBUG_CMD, "cmd roc %d (%d)", wl->channel, wl->band);
> +	wl1271_debug(DEBUG_CMD, "cmd roc %d (%d)", wl->channel, role_id);
>  
>  	if (WARN_ON(role_id == WL1271_INVALID_ROLE_ID))
>  		return -EINVAL;
>  
>  	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
>  	if (!cmd) {
> @@ -1526,22 +1526,23 @@ out_free:
>  out:
>  	return ret;
>  }
>  
>  static int wl1271_cmd_croc(struct wl1271 *wl, u8 role_id)
>  {
> -	struct wl1271_cmd_header *cmd;
> +	struct wl1271_cmd_croc *cmd;
>  	int ret = 0;
>  
> -	wl1271_debug(DEBUG_CMD, "cmd croc");
> +	wl1271_debug(DEBUG_CMD, "cmd croc (%d)", role_id);
>  
>  	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
>  	if (!cmd) {
>  		ret = -ENOMEM;
>  		goto out;
>  	}
> +	cmd->role_id = role_id;
>  
>  	ret = wl1271_cmd_send(wl, CMD_CANCEL_REMAIN_ON_CHANNEL, cmd,
>  			      sizeof(*cmd), 0);
>  	if (ret < 0) {
>  		wl1271_error("failed to send ROC command");
>  		goto out_free;

Could you squash the changes to these two commands into the previous
patch?


> +int wl1271_roc(struct wl1271 *wl, u8 role_id)
> +{
> +	int ret = 0;
> +
> +	if (WARN_ON(test_bit(role_id, wl->roc_map)))
> +		return 0;
> +
> +	ret = wl1271_cmd_roc(wl, role_id);
> +	if (ret < 0)
> +		goto out;
> +
> +	ret = wl1271_cmd_wait_for_event(wl,
> +					REMAIN_ON_CHANNEL_COMPLETE_EVENT_ID);
> +	if (ret < 0) {
> +		wl1271_error("cmd roc event completion error");
> +		goto out;
> +	}
> +
> +	__set_bit(role_id, wl->roc_map);
> +	set_bit(WL1271_FLAG_ROC, &wl->flags);

As I asked before, can we really be ROCed in more than one role at the
same time?

In any case, I don't think we need the WL1271_FLAG_ROC.  Can't you just
check whether any of the roc_map bits is set instead?


> @@ -579,12 +581,19 @@ struct wl1271_cmd_roc {
>  	u8 role_id;
>  	u8 channel;
>  	u8 band;
>  	u8 padding;
>  };
>  
> +struct wl1271_cmd_croc {
> +	struct wl1271_cmd_header header;
> +
> +	u8 role_id;
> +	u8 padding[3];
> +};
> +

Squash this one into patch 17 too, please.


> @@ -2211,24 +2196,23 @@ static int wl1271_sta_handle_idle(struct wl1271 *wl, bool idle)
>  			wl, CMD_TEMPL_KLV_IDX_NULL_DATA,
>  			ACX_KEEP_ALIVE_TPL_INVALID);
>  		if (ret < 0)
>  			goto out;
>  		set_bit(WL1271_FLAG_IDLE, &wl->flags);
>  	} else {
> -		/* increment the session counter */
> -		wl->session_counter++;
> -		if (wl->session_counter >= SESSION_COUNTER_MAX)
> -			wl->session_counter = 0;
> -

Shouldn't this be session_counter change be squashed into patch 21?


> @@ -2762,16 +2769,26 @@ static int wl1271_op_hw_scan(struct ieee80211_hw *hw,
>  	}
>  
>  	ret = wl1271_ps_elp_wakeup(wl);
>  	if (ret < 0)
>  		goto out;
>  
> -	ret = wl1271_scan(hw->priv, ssid, len, req);
> +	/* cancel ROC before scanning */
> +	if (test_bit(WL1271_FLAG_ROC, &wl->flags)) {
> +		if (test_bit(WL1271_FLAG_STA_ASSOCIATED, &wl->flags)) {
> +			/* don't allow scanning right now (?) */
> +			ret = -EBUSY;
> +			goto out_sleep;
> +		}

This would happen in the case of roaming, right? Please add a TODO or
FIXME instead of the (?) so that it's easier to grep later. ;)

> @@ -3378,13 +3421,35 @@ static void wl1271_bss_info_changed_sta(struct wl1271 *wl,
>  	if (do_join) {
>  		ret = wl1271_join(wl, set_assoc);
>  		if (ret < 0) {
>  			wl1271_warning("cmd join failed %d", ret);
>  			goto out;
>  		}
> -		wl1271_check_operstate(wl, ieee80211_get_operstate(vif));
> +
> +		/* ROC until interface is up (after EAPOL exchange) */

Do you mean, "ROC until connected"?


> +		if (!is_ibss) {
> +			ret = wl1271_roc(wl, wl->role_id);
> +			if (ret < 0)
> +				goto out;
> +
> +			wl1271_check_operstate(wl,
> +					       ieee80211_get_operstate(vif));
> +		}


-- 
Cheers,
Luca.

