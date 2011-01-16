Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59367 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823Ab1API2q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Jan 2011 03:28:46 -0500
Subject: Re: [PATCH] wl12xx: fix some sparse warnings
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: Luciano Coelho <coelho@ti.com>, linux-wireless@vger.kernel.org
In-Reply-To: <1295164184-25592-1-git-send-email-eliad@wizery.com>
References: <1295164184-25592-1-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 16 Jan 2011 09:28:42 +0100
Message-ID: <1295166522.3574.1.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2011-01-16 at 09:49 +0200, Eliad Peller wrote:

> @@ -813,7 +813,7 @@ int wl1271_acx_ap_rate_policy(struct wl1271 *wl, struct conf_tx_rate_class *c,
>  	acx->rate_policy.long_retry_limit = c->long_retry_limit;
>  	acx->rate_policy.aflags = c->aflags;
>  
> -	acx->rate_policy_idx = idx;
> +	acx->rate_policy_idx = __cpu_to_le32(idx);

The underscore version doesn't look appropriate at this point or in fact
anywhere in this patch.

Also, your patch subject and commit log is wrong -- this doesn't just
fix sparse warnings, it fixes actual bugs pointed out by sparse, so
commit log should reflect that.
 
johannes

