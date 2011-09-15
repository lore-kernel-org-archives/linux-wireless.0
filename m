Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47108 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932575Ab1IOK7X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Sep 2011 06:59:23 -0400
Subject: Re: [RFC] mac80211: Do not allow disabled channel during scan
From: Johannes Berg <johannes@sipsolutions.net>
To: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1316084096-12565-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1316084096-12565-1-git-send-email-rmanohar@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 15 Sep 2011 12:59:19 +0200
Message-ID: <1316084359.3992.7.camel@jlt3.sipsolutions.net> (sfid-20110915_125926_158312_C70801BB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-09-15 at 16:24 +0530, Rajkumar Manoharan wrote:
> The scan decision allows disabled channel to be set. So the
> probe request was seen over the disabled channel. This patch
> skips the disabled channel while scanning.

Nack. We want to scan those passively.

> Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
> ---
>  net/mac80211/scan.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
> index 6f09eca..9c3d309 100644
> --- a/net/mac80211/scan.c
> +++ b/net/mac80211/scan.c
> @@ -616,6 +616,10 @@ static void ieee80211_scan_state_set_channel(struct ieee80211_local *local,
>  		if (ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL))
>  			skip = 1;
>  
> +	/* Skip disabled channels */
> +	if (chan->flags & IEEE80211_CHAN_DISABLED)
> +		skip = 1;
> +
>  	/* advance state machine to next channel/band */
>  	local->scan_channel_idx++;
>  


