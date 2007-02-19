Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:34627 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932639AbXBSUtV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Feb 2007 15:49:21 -0500
Date: Mon, 19 Feb 2007 21:49:19 +0100
From: Jiri Benc <jbenc@suse.cz>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
Subject: Re: [PATCH 06/10] d80211: update for wiphy api
Message-ID: <20070219214919.44838d97@griffin.suse.cz>
In-Reply-To: <20070215144258.819563000@sipsolutions.net>
References: <20070215144241.847938000@sipsolutions.net>
	<20070215144258.819563000@sipsolutions.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 15 Feb 2007 15:42:47 +0100, Johannes Berg wrote:
> 
> --- wireless-dev.orig/include/net/d80211.h	2007-02-15 13:28:04.547940064 +0100
> +++ wireless-dev/include/net/d80211.h	2007-02-15 13:28:52.417940064 +0100
> @@ -16,6 +16,8 @@
>  #include <linux/wireless.h>
>  #include <linux/device.h>
>  #include <linux/ieee80211.h>
> +#include <net/wireless.h>
> +#include <net/cfg80211.h>
>  
>  /* Note! Only ieee80211_tx_status_irqsafe() and ieee80211_rx_irqsafe() can be
>   * called in hardware interrupt context. The low-level driver must not call any
> @@ -457,8 +459,12 @@ typedef enum {
>  
>  /* This is driver-visible part of the per-hw state the stack keeps. */
>  struct ieee80211_hw {
> -	/* these are assigned by d80211, don't write */
> -	int index;
> +	/* points to the cfg80211 wiphy for this piece. Note
> +	 * that you must fill in the perm_addr and dev fields
> +	 * of this structure, use the macros provided below. */
> +	struct wiphy *wiphy;
> +
> +	/* assigned by d80211, don't write */
>  	struct ieee80211_conf conf;
>  
>  	/* Pointer to the private area that was

Couldn't we just allow embedding of wiphy into a custom structure?
Something like:

struct ieee80211_hw {
	struct wiphy wiphy;
	...
}

This way the memory could become less fragmented and less pointer
dereferencing would be needed.

 Jiri

-- 
Jiri Benc
SUSE Labs
