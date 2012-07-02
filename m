Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33673 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878Ab2GBMTG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jul 2012 08:19:06 -0400
Message-ID: <1341231541.19642.3.camel@jlt3.sipsolutions.net> (sfid-20120702_141911_503567_8991C51C)
Subject: Re: [PATCH] mac80211: always set in_reconfig=false on wakeup
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>,
	John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 02 Jul 2012 14:19:01 +0200
In-Reply-To: <1341230905-8929-1-git-send-email-eliad@wizery.com> (sfid-20120702_140817_322121_7AEACF56)
References: <1341230905-8929-1-git-send-email-eliad@wizery.com>
	 (sfid-20120702_140817_322121_7AEACF56)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-07-02 at 15:08 +0300, Eliad Peller wrote:
> If the interfaces were removed just before a restart
> work was started, open_count will be 0, and most of
> the reconfig work will be skipped, including the
> resetting of local->in_reconfig to false.
> 
> Leaving local->inconfig = true will result in
> dropping any incoming packet.
> 
> Fix it by always setting local->in_reconfig = false
> (even if there are no active interfaces).
> 
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---
> this should go to 3.5

Also looks good, thanks

Reviewed-by: Johannes Berg <johannes@sipsolutions.net>

John, could you also pick this up?

johannes


>  net/mac80211/util.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/net/mac80211/util.c b/net/mac80211/util.c
> index 242ecde..e1b7c63 100644
> --- a/net/mac80211/util.c
> +++ b/net/mac80211/util.c
> @@ -1411,10 +1411,10 @@ int ieee80211_reconfig(struct ieee80211_local *local)
>  		if (ieee80211_sdata_running(sdata))
>  			ieee80211_enable_keys(sdata);
>  
> + wake_up:
>  	local->in_reconfig = false;
>  	barrier();
>  
> - wake_up:
>  	/*
>  	 * Clear the WLAN_STA_BLOCK_BA flag so new aggregation
>  	 * sessions can be established after a resume.


