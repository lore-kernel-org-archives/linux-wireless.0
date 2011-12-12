Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35587 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753285Ab1LLNMc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Dec 2011 08:12:32 -0500
Subject: Re: [PATCH] mac80211: don't check sdata_running in vif notifier
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1323695084-28109-1-git-send-email-eliad@wizery.com> (sfid-20111212_140440_745020_54E638D6)
References: <1323695084-28109-1-git-send-email-eliad@wizery.com>
	 (sfid-20111212_140440_745020_54E638D6)
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 12 Dec 2011 14:12:29 +0100
Message-ID: <1323695549.3442.38.camel@jlt3.sipsolutions.net> (sfid-20111212_141250_106321_F0760BC4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-12-12 at 15:04 +0200, Eliad Peller wrote:
> The ip address of the vif can be set even before the
> vif is up. requiring the vif to be up in the vif
> notifier makes the notifer ignore this event, which
> causes wrong arp filter configuration later on.
> 
> Reported-by: Eyal Shapira <eyal@wizery.com>
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---
>  net/mac80211/main.c |    3 ---
>  1 files changed, 0 insertions(+), 3 deletions(-)
> 
> diff --git a/net/mac80211/main.c b/net/mac80211/main.c
> index 8022c62..ad8f712 100644
> --- a/net/mac80211/main.c
> +++ b/net/mac80211/main.c
> @@ -436,9 +436,6 @@ static int ieee80211_ifa_changed(struct notifier_block *nb,
>  	sdata = IEEE80211_DEV_TO_SUB_IF(ndev);
>  	bss_conf = &sdata->vif.bss_conf;
>  
> -	if (!ieee80211_sdata_running(sdata))
> -		return NOTIFY_DONE;
> -

Ok ... maybe a comment would be good when we check associated that if
associated the interface has to be up? Otherwise casual readers might
wonder if this can call into the driver while it's down? Dunno...

johannes

