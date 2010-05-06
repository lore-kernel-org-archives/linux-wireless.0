Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55426 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752181Ab0EFHol (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 May 2010 03:44:41 -0400
Subject: Re: [PATCH 1/2] mac80211: add offload channel switch support
From: Johannes Berg <johannes@sipsolutions.net>
To: wey-yi.w.guy@intel.com
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1273116842-27189-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1273116842-27189-1-git-send-email-wey-yi.w.guy@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 06 May 2010 09:44:36 +0200
Message-ID: <1273131876.3573.28.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sorry, just thought of something.

On Wed, 2010-05-05 at 20:34 -0700, wey-yi.w.guy@intel.com wrote:

> + * @timestamp: value in microseconds of the 64-bit Time Synchronization
> + *	Function (TSF) timer when the channel switch ie received.

This is not accurate now but see below.

> +		if (beacon)
> +			timestamp = le64_to_cpu(mgmt->u.beacon.timestamp);
> +		else
> +			timestamp = le64_to_cpu(mgmt->u.probe_resp.timestamp);
> +		ieee80211_sta_process_chanswitch(sdata, sw_elem,
> +						 bss, timestamp);
>  	}
>  }
>  
> @@ -1647,7 +1691,8 @@ static void ieee80211_sta_rx_queued_mgmt(struct ieee80211_sub_if_data *sdata,
>  
>  			ieee80211_sta_process_chanswitch(sdata,
>  					&mgmt->u.action.u.chan_switch.sw_elem,
> -					(void *)ifmgd->associated->priv);
> +					(void *)ifmgd->associated->priv,
> +					rx_status->mactime);

For some reason I didn't notice the action frame handling before. Maybe
it would be more consistent to keep using rx_status->mactime even for
beacons? I apologise, this is totally my fault since I suggested using
the beacon time before, but that has a slightly different value relative
to the frame... Hmm. Maybe it would be better after all to require
drivers to provide mactime at least for mgmt frames (beacons + actions)
when they want to implement this callback.

Anyone else have ideas?

johannes

