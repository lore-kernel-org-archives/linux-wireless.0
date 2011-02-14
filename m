Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38189 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753976Ab1BNOii (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Feb 2011 09:38:38 -0500
Subject: Re: [RFC v2 1/2] mac80211: add a function for setting the TIM bit
 for a specific station
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, j@w1.fi, lrodriguez@atheros.com,
	m.sujith@gmail.com
In-Reply-To: <1297207937-88528-1-git-send-email-nbd@openwrt.org>
References: <1297207937-88528-1-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Feb 2011 15:38:35 +0100
Message-ID: <1297694315.3953.2.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-02-09 at 00:32 +0100, Felix Fietkau wrote:
> When a driver wants to buffer some frames internally without feeding them
> back to mac80211, this allows it to still wake up the station
> 
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> ---
>  include/net/mac80211.h  |   14 ++++++++++++++
>  net/mac80211/sta_info.c |    8 ++++++++
>  2 files changed, 22 insertions(+), 0 deletions(-)
> 
> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
> index 8fcd169..9a0babe 100644
> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h
> @@ -2194,6 +2194,20 @@ static inline int ieee80211_sta_ps_transition_ni(struct ieee80211_sta *sta,
>  #define IEEE80211_TX_STATUS_HEADROOM	13
>  
>  /**
> + * ieee80211_sta_set_tim - set the TIM bit for a sleeping station
> + *
> + * If a driver buffers frames for a powersave station instead of passing
> + * them back to mac80211 for retransmission, the station needs to be told
> + * to wake up using the TIM bitmap in the beacon.
> + *
> + * This function sets the station's TIM bit - it will be cleared automatically
> + * either when the station wakes up (and mac80211 has flushed out its
> + * buffered frames), or if all remaining buffered frames in mac80211 have
> + * timed out.

I'm wondering ... this doesn't seem right. Even if the frames in
mac80211 time out, there might be more in the driver still, no? It seems
that this should be more of a "I have frames / I no longer have frames"
type API?

johannes

