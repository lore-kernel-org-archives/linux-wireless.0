Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45125 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261Ab1AWJSQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Jan 2011 04:18:16 -0500
Subject: Re: [PATCH v2] mac80211:  Optimize scans on current operating
 channel.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1295633142-7437-1-git-send-email-greearb@candelatech.com>
References: <1295633142-7437-1-git-send-email-greearb@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 23 Jan 2011 10:18:13 +0100
Message-ID: <1295774293.3639.15.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-01-21 at 10:05 -0800, greearb@candelatech.com wrote:

> + * @SCAN_LEFT_OPER_CHANNEL:  Set this flag if the scan process leaves the
> + *      operating channel at any time.  If scanning ONLY the current operating
> + *      channel this flag should not be set, and this will allow fewer
> + *      offchannel changes.

Why does this make sense? In the code below, you do


> -	ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL);
> +	if ((local->oper_channel != local->hw.conf.channel) || was_hw_scan)
> +		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL);
> +
>  	if (!was_hw_scan) {
>  		ieee80211_configure_filter(local);
>  		drv_sw_scan_complete(local);
> -		ieee80211_offchannel_return(local, true);
> +		if (test_bit(SCAN_LEFT_OPER_CHANNEL, &local->scanning))
> +			ieee80211_offchannel_return(local, true);

so you could just as well use a local variable (the first if you add is
exactly this test).

>  static void ieee80211_scan_state_leave_oper_channel(struct ieee80211_local *local,
>  						    unsigned long *next_delay)
>  {
> +	ieee80211_offchannel_stop_beaconing(local);
> +

Won't that confuse drivers that expect not to be beaconing between
sw_scan_start and sw_scan_end?


Also, are you sure the filter configuration works correctly this way? If
you can, I'd like to look at a binary trace of the commands going to the
device with this change: "trace-cmd record -e mac80211".


johannes

