Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45444 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302Ab2EVSkv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 May 2012 14:40:51 -0400
Message-ID: <1337712022.4470.0.camel@jlt3.sipsolutions.net> (sfid-20120522_204055_007815_C3722E65)
Subject: Re: [PATCH] mac80211: add command to get current rssi
From: Johannes Berg <johannes@sipsolutions.net>
To: Victor Goldenshtein <victorg@ti.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 22 May 2012 20:40:22 +0200
In-Reply-To: <1337669130-4229-1-git-send-email-victorg@ti.com>
References: <1337669130-4229-1-git-send-email-victorg@ti.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-05-22 at 09:45 +0300, Victor Goldenshtein wrote:

> @@ -388,7 +389,10 @@ static void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
>  	if ((sta->local->hw.flags & IEEE80211_HW_SIGNAL_DBM) ||
>  	    (sta->local->hw.flags & IEEE80211_HW_SIGNAL_UNSPEC)) {
>  		sinfo->filled |= STATION_INFO_SIGNAL | STATION_INFO_SIGNAL_AVG;
> -		sinfo->signal = (s8)sta->last_signal;
> +		if (local->ops->get_rssi)
> +			drv_get_rssi(local, sdata, &sinfo->signal);
> +		else
> +			sinfo->signal = (s8)sta->last_signal;
>  		sinfo->signal_avg = (s8) -ewma_read(&sta->avg_signal);
>  	}

So .. you're filling a per-station value with a generic per-interface
callback? What were you thinking? ;-)

johannes

