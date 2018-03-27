Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:60418 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751347AbeC0MyQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Mar 2018 08:54:16 -0400
Message-ID: <1522155253.3050.8.camel@sipsolutions.net> (sfid-20180327_145419_642121_AADA8112)
Subject: Re: [RFC 3/4] mac80211: Apply per-peer NoAck tid bitmap
 configuration
From: Johannes Berg <johannes@sipsolutions.net>
To: Vasanthakumar Thiagarajan <vthiagar@codeaurora.org>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 27 Mar 2018 14:54:13 +0200
In-Reply-To: <1522140171-10926-4-git-send-email-vthiagar@codeaurora.org>
References: <1522140171-10926-1-git-send-email-vthiagar@codeaurora.org>
         <1522140171-10926-4-git-send-email-vthiagar@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2018-03-27 at 14:12 +0530, Vasanthakumar Thiagarajan wrote:
> 
> +u16 ieee80211_get_noack_map(struct ieee80211_sub_if_data *sdata, const u8 *mac)
> +{
> +	struct sta_info *sta;
> +	u16 noack_map = 0;
> +
> +	/* Retrieve per-station noack_map config for the receiver, if any */
> +
> +	rcu_read_lock();
> +
> +	sta = sta_info_get(sdata, mac);
> +	if (!sta) {
> +		rcu_read_unlock();
> +		return noack_map;
> +	}
> +
> +	noack_map = sta->noack_map;
> +
> +	rcu_read_unlock();
> +
> +	if (!noack_map)
> +		noack_map = sdata->noack_map;

So this has an interesting corner case - should it be possible to have a
default noack_map that's non-zero, but override it with 0 for a specific
peer? It seems that it should be, which makes this code wrong.

johannes
