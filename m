Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52200 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751200Ab1APIub (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Jan 2011 03:50:31 -0500
Subject: Re: [PATCH 06/10] mac80211: add HW flag for disabling auto link-PS
 in AP mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org, Luciano Coelho <coelho@ti.com>
In-Reply-To: <1295156534-4178-7-git-send-email-arik@wizery.com>
References: <1295156534-4178-1-git-send-email-arik@wizery.com>
	 <1295156534-4178-7-git-send-email-arik@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 16 Jan 2011 09:50:29 +0100
Message-ID: <1295167829.3574.10.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2011-01-16 at 07:42 +0200, Arik Nemtsov wrote:
> When operating in AP mode the wl1271 hardware filters our null-data
> packets as well as management packets. This makes it impossible for
> mac80211 to monitor the PS mode by using the PM bit of incoming frames.
> 
> Implement a HW flag to indicate that mac80211 should ignore the PM bit.
> In addition, expose ieee80211_start_ps()/ieee80211_end_ps() to make
> low-level drivers capable of controlling PS-mode.
> 
> Signed-off-by: Arik Nemtsov <arik@wizery.com>
> ---
>  include/net/mac80211.h |   38 ++++++++++++++++++++++++++++++++++++++
>  net/mac80211/rx.c      |   19 ++++++++++++++++++-
>  2 files changed, 56 insertions(+), 1 deletions(-)
> 
> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
> index 62c0ce2..26a8cfb 100644
> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h
> @@ -1069,6 +1069,13 @@ enum ieee80211_tkip_key_type {
>   *	to decrypt group addressed frames, then IBSS RSN support is still
>   *	possible but software crypto will be used. Advertise the wiphy flag
>   *	only in that case.
> + *
> + * @IEEE80211_HW_AP_LINK_PS: When operating in AP mode the device
> + *	autonomously manages the PS status of connected stations. When
> + *	this flag is set mac80211 will not trigger PS mode for connected
> + *	stations based on the PM bit of incoming frames.
> + *	Use ieee80211_start_ps()/ieee8021_end_ps() to manually configure
> + *	the PS mode of connected stations.
>   */
>  enum ieee80211_hw_flags {
>  	IEEE80211_HW_HAS_RATE_CONTROL			= 1<<0,
> @@ -1093,6 +1100,7 @@ enum ieee80211_hw_flags {
>  	IEEE80211_HW_CONNECTION_MONITOR			= 1<<19,
>  	IEEE80211_HW_SUPPORTS_CQM_RSSI			= 1<<20,
>  	IEEE80211_HW_SUPPORTS_PER_STA_GTK		= 1<<21,
> +	IEEE80211_HW_AP_LINK_PS				= 1<<22,
>  };
>  
>  /**
> @@ -2113,6 +2121,36 @@ static inline void ieee80211_rx_ni(struct ieee80211_hw *hw,
>  	local_bh_enable();
>  }
>  
> +/**
> + * ieee80211_start_ps - start PS for connected sta
> + *
> + * When operating in AP mode, use this function to inform mac80211
> + * about a station entering PS mode.
> + * Note that by default mac80211 will automatically call the internal
> + * equivalent of this function according to the PM bit of incoming frames.
> + * Use the IEEE80211_HW_AP_LINK_PS flag to change this.

I think that explanation should be clearer and say that you must call
this only when the flag is set and vice versa. Also, there should be a 

WARN_ON(hw->flags & HW_AP_LINK_PS)

in the functions.

Also, maybe just a single function with a bool argument would be more
appropriate? Call it "ieee80211_sta_ps_transition()" or something like
that. You should also remove the text about calling the internal
equivalent -- the internal details might change at any time but the API
should be documented in a way that makes sense without the internal
details for the benefit of both sides -- people implementing a driver
don't need to know about the internal details, and people changing the
internal details know what semantics to keep.

> + * This function may not be called in IRQ context or process context.

This can't be true -- the latter part you must mean "or with softirqs
enabled".


Also, I'm worried about races between this and RX. All of the RX path
assumes that it is running at the same time. The ap_sta_ps_{start,end}
functions won't be called from the RX path when the flag is set, and
this is dependent on setting the flag, but is there really nothing in
them that could race?

Finally, I'm worried about this calling back into the driver's
sta_notify callback. If that is to remain that way, it needs to be
*very* clearly documented, I'd *much* prefer it not doing that but
handing off to a work struct or so internally.

johannes

