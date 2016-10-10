Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:55199 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751790AbcJJKQr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Oct 2016 06:16:47 -0400
Message-ID: <1476094604.7895.9.camel@sipsolutions.net> (sfid-20161010_121650_807691_F2B14D6A)
Subject: Re: [PATCH] mac80211: enable to inject a-msdu frames using monitor
 interface
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Braun <michael-dev@fami-braun.de>
Cc: linux-wireless@vger.kernel.org, projekt-wlan@fem.tu-ilmenau.de
Date: Mon, 10 Oct 2016 12:16:44 +0200
In-Reply-To: <1475872162-2835-1-git-send-email-michael-dev@fami-braun.de>
References: <1475872162-2835-1-git-send-email-michael-dev@fami-braun.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2016-10-07 at 22:29 +0200, Michael Braun wrote:
> 
> I guess the same is needed for packets with IEEE80211_TX_CTRL_AMSDU
> set.

I don't think that's true, since we don't get here after A-MSDU
building in mac80211.

>  	/* preserve EOSP bit */
>  	ack_policy = *p & IEEE80211_QOS_CTL_EOSP;
>  
> +	/* preserve A-MSDU bit for MONITOR interfaces to allow
> injecting
> +	 * A-MSDU frames
> +	 */
> +	if (info->flags & IEEE80211_TX_CTL_INJECTED ||
> +	    info->control.flags & IEEE80211_TX_CTRL_AMSDU)
> +		ack_policy |= *p & IEEE80211_QOS_CTL_A_MSDU_PRESENT;

However, why not just unconditionally preserve it?

johannes
