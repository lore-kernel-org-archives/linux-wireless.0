Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45891 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738Ab3DVNyr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Apr 2013 09:54:47 -0400
Message-ID: <1366638881.8637.17.camel@jlt4.sipsolutions.net> (sfid-20130422_155451_313514_F43951A9)
Subject: Re: [PATCH] mac80211: Fix driver crash when STA_NOTIFY_AWAKE occures
From: Johannes Berg <johannes@sipsolutions.net>
To: cedric voncken <cedric.voncken@acksys.fr>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 22 Apr 2013 15:54:41 +0200
In-Reply-To: <1366363242-29481-1-git-send-email-cedric.voncken@acksys.fr> (sfid-20130419_112051_358756_8C409DEB)
References: <1366363242-29481-1-git-send-email-cedric.voncken@acksys.fr>
	 (sfid-20130419_112051_358756_8C409DEB)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-04-19 at 11:20 +0200, cedric voncken wrote:
> If the device uses the HT mode and receives a frame from a sta whith state < IEEE80211_STA_ASSOC
> then the null pointer exception crashes the Linnux kernel.
> 
> In the case of ath9k, the function ath_tx_node_init is indirectly called by drv_sta_state (in net/mac80211/driver-ops.h) only when the sta_state goes to IEEE80211_STA_ASSOC from IEEE80211_STA_AUTH.
> 
> Signed-off-by: cedric VONCKEN <cedric.voncken@acksys.fr>
> ---
>  net/mac80211/sta_info.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
> index 11216bc..bcfd7b0 100644
> --- a/net/mac80211/sta_info.c
> +++ b/net/mac80211/sta_info.c
> @@ -1040,7 +1040,8 @@ void ieee80211_sta_ps_deliver_wakeup(struct sta_info *sta)
>  	BUILD_BUG_ON(BITS_TO_LONGS(IEEE80211_NUM_TIDS) > 1);
>  	sta->driver_buffered_tids = 0;
>  
> -	if (!(local->hw.flags & IEEE80211_HW_AP_LINK_PS))
> +	if (!(local->hw.flags & IEEE80211_HW_AP_LINK_PS &&
> +			sta->sta_state >= IEEE80211_STA_ASSOC))

This seems like a bad workaround -- how are you getting to this point
w/o being associated?

johannes

