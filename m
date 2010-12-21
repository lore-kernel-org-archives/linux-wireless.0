Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41451 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800Ab0LUOHT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Dec 2010 09:07:19 -0500
Subject: Re: [PATCH] mac80211: check for CONFIG_MAC80211_LEDS in the
 tpt_led_trigger declaration
From: Johannes Berg <johannes@sipsolutions.net>
To: luciano.coelho@nokia.com
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1292940137-21850-1-git-send-email-luciano.coelho@nokia.com>
References: <1292940137-21850-1-git-send-email-luciano.coelho@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 21 Dec 2010 15:07:14 +0100
Message-ID: <1292940434.3563.5.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-12-21 at 16:02 +0200, luciano.coelho@nokia.com wrote:
> From: Luciano Coelho <luciano.coelho@nokia.com>
> 
> If CONFIG_MAC80211_LEDS is not set, ieee80211_i.h was failing to compile,
> because struct led_trigger is only declared when CONFIG_LEDS_TRIGGERS is
> set.
> 
> This patch adds ifdefs around the tpt_led_trigger declaration in
> ieee80211_i.h to avoid the problem.
> 
> Cc: Johannes Berg <johannes@sipsolutions.net>

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
> ---
>  net/mac80211/ieee80211_i.h |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
> index 0817ec6..7541d42 100644
> --- a/net/mac80211/ieee80211_i.h
> +++ b/net/mac80211/ieee80211_i.h
> @@ -631,6 +631,7 @@ enum queue_stop_reason {
>  	IEEE80211_QUEUE_STOP_REASON_SKB_ADD,
>  };
>  
> +#ifdef CONFIG_MAC80211_LEDS
>  struct tpt_led_trigger {
>  	struct led_trigger trig;
>  	char name[32];
> @@ -642,6 +643,7 @@ struct tpt_led_trigger {
>  	unsigned int active, want;
>  	bool running;
>  };
> +#endif
>  
>  /**
>   * mac80211 scan flags - currently active scan mode


