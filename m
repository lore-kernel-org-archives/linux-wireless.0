Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38560 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869Ab1A1J2k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Jan 2011 04:28:40 -0500
Subject: Re: [PATCH] mac80211:  Be more careful when changing channels.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1296194947-12017-1-git-send-email-greearb@candelatech.com>
References: <1296194947-12017-1-git-send-email-greearb@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 28 Jan 2011 10:28:37 +0100
Message-ID: <1296206917.4550.1.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-01-27 at 22:09 -0800, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> If we cannot set the channel type, set the channel back to the
> original.
> 
> Don't update the driver hardware if nothing actually changed.

Good catch.


> +	old_oper = local->oper_channel;
>  	local->oper_channel = chan;
>  
> -	if (!ieee80211_set_channel_type(local, sdata, channel_type))
> +	old_oper_type = local->_oper_channel_type;
> +	if (!ieee80211_set_channel_type(local, sdata, channel_type)) {
> +		local->oper_channel = old_oper;
>  		return -EBUSY;
> +	}
> +
> +	if ((old_oper != local->oper_channel) ||
> +	    (old_oper_type != local->_oper_channel_type))
> +		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL);
>  
> -	ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL);
> -	if (sdata && sdata->vif.type != NL80211_IFTYPE_MONITOR)
> +	if ((sdata && sdata->vif.type != NL80211_IFTYPE_MONITOR) &&
> +	    old_vif_oper_type != sdata->vif.bss_conf.channel_type)
>  		ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_HT);

But why the complicated code? Couldn't you just swap the
set_channel_type() and oper_channel = chan around? set_channel_type()
doesn't need oper_channel set.

johannes

