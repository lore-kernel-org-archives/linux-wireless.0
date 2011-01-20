Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43831 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753002Ab1ATRjD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Jan 2011 12:39:03 -0500
Subject: Re: [RFC 2/3] mac80211: Support scanning only current active
 channel.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1295544750-6704-2-git-send-email-greearb@candelatech.com>
References: <1295544750-6704-1-git-send-email-greearb@candelatech.com>
	 <1295544750-6704-2-git-send-email-greearb@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 20 Jan 2011 18:39:03 +0100
Message-ID: <1295545143.3693.44.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-01-20 at 09:32 -0800, greearb@candelatech.com wrote:

> -	ieee80211_offchannel_stop_beaconing(local);
> +	if (local->ops->sw_scan_start_cur &&
> +	    local->scan_req->n_channels == 1 &&
> +	    local->scan_req->channels[0] == local->hw.conf.channel) {
> +		__set_bit(SCAN_ON_CUR_CHANNEL, &local->scanning);
> +		drv_sw_scan_start_cur(local, true);
> +	} else
> +		drv_sw_scan_start(local);

This doesn't seem to make much sense either -- even if we do a scan over
multiple channels we should be able to optimise the part on the current
channel (maybe put it at the beginning or end too).

johannes

