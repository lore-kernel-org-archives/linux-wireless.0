Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48209 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089Ab0I2QsW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Sep 2010 12:48:22 -0400
Subject: Re: [PATCH v3] mac80211:  Allow scanning single channel if other
 VIF is associated.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <4CA35BAB.8090701@candelatech.com>
References: <1285708650-21858-1-git-send-email-greearb@candelatech.com>
	 <1285743733.3756.3.camel@jlt3.sipsolutions.net>
	 <4CA35BAB.8090701@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 29 Sep 2010 18:48:21 +0200
Message-ID: <1285778901.3756.25.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-09-29 at 08:30 -0700, Ben Greear wrote:

> Does this portion seem useful as a stand-alone patch?  It does not
> depend on the other scan-one logic.

Somewhat, but it seems a bit buggy?

> diff --git a/net/mac80211/work.c b/net/mac80211/work.c
> index ae344d1..1bfc1e0 100644
> --- a/net/mac80211/work.c
> +++ b/net/mac80211/work.c
> @@ -910,12 +910,17 @@ static void ieee80211_work_work(struct work_struct *work)
>   			 *	 happen to be on the same channel as
>   			 *	 the requested channel
>   			 */
> -			ieee80211_offchannel_stop_beaconing(local);
> -			ieee80211_offchannel_stop_station(local);
> -
> -			local->tmp_channel = wk->chan;
> -			local->tmp_channel_type = wk->chan_type;
> -			ieee80211_hw_config(local, 0);
> +			if (!(wk->chan == local->scan_channel ||
> +			      (wk->chan == local->oper_channel &&

I don't think work items will ever run while scanning? And also, this
might need to check the channel type as well, which isn't quite
necessary right now (since no works requires HT channels) but would seem
cleaner.

> +			       !local->scan_channel))) {
> +				/* Only change channels if we need to */
> +				ieee80211_offchannel_stop_beaconing(local);
> +				ieee80211_offchannel_stop_station(local);
> +
> +				local->tmp_channel = wk->chan;
> +				local->tmp_channel_type = wk->chan_type;
> +				ieee80211_hw_config(local, 0);
> +			}
>   			started = true;
>   			wk->timeout = jiffies;

Also, I believe it needs matching code to not do all the return stuff
since we never left the channel, and I think it still needs to set
tmp_channel so that nothing will switch away underneath or so... not
quite sure.

johannes

