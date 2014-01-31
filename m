Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:52199 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932255AbaAaNv7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jan 2014 08:51:59 -0500
Message-ID: <1391176316.4141.16.camel@jlt4.sipsolutions.net> (sfid-20140131_145204_549772_FC09060D)
Subject: Re: [PATCH] cfg80211: consider existing DFS interfaces
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 31 Jan 2014 14:51:56 +0100
In-Reply-To: <1391001747-9442-1-git-send-email-michal.kazior@tieto.com> (sfid-20140129_142811_636394_08EC0483)
References: <1391001747-9442-1-git-send-email-michal.kazior@tieto.com>
	 (sfid-20140129_142811_636394_08EC0483)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-01-29 at 14:22 +0100, Michal Kazior wrote:
> It was possible to break interface combinations in
> the following way:
> 
>  combo 1: iftype = AP, num_ifaces = 2, num_chans = 2,
>  combo 2: iftype = AP, num_ifaces = 1, num_chans = 1, radar = HT20
> 
> With the above interface combinations it was
> possible to:
> 
>  step 1. start AP on DFS channel by matching combo 2
>  step 2. start AP on non-DFS channel by matching combo 1
> 
> This was possible beacuse (step 2) did not consider
> if other interfaces require radar detection.
> 
> The patch changes how cfg80211 tracks channels -
> instead of channel itself now a complete chandef
> is stored.

Applied.

Do you also want to take this a little further and actually check
compatibility when checking for channel availability in
cfg80211_can_use_iftype_chan()? Right now it only checks the channel,
but cfg80211_get_chan_state() should really not have a channel argument
but a chandef instead.

johannes

