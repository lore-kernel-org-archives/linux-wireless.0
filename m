Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59455 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751408Ab0I2HCP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Sep 2010 03:02:15 -0400
Subject: Re: [PATCH v3] mac80211:  Allow scanning single channel if other
 VIF is associated.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1285708650-21858-1-git-send-email-greearb@candelatech.com>
References: <1285708650-21858-1-git-send-email-greearb@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 29 Sep 2010 09:02:13 +0200
Message-ID: <1285743733.3756.3.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-09-28 at 14:17 -0700, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> This patch aims to decrease channel switching when there is at least one
> interface associated.  This should help multiple station interfaces co-exist
> on the same hardware, especially in WPA mode.
> 
> Signed-off-by: Ben Greear <greearb@candelatech.com>
> ---
> 
> v2 -> v3:  Just check can_scan_one flag and if set and there is
>    a vif associated, select the active channel as scan-channel and
>    let core scanning logic function as designed.
> 
>    This gets much of the really ugly logic changes out of the
>    scanning core, and any optimizations to this should help
>    general purpose scanning on a single channel as well.

> --- a/include/linux/nl80211.h
> +++ b/include/linux/nl80211.h
> @@ -965,6 +965,8 @@ enum nl80211_attrs {
>  	NL80211_ATTR_CONTROL_PORT_ETHERTYPE,
>  	NL80211_ATTR_CONTROL_PORT_NO_ENCRYPT,
>  
> +	NL80211_ATTR_SCAN_ONE_IF_ASSOC,
> +

Still NACK, I don't see the need for new API for this odd case.

Please don't resubmit similar patches to this, I don't want to nack them
all the time.

johannes

