Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:31736 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756877AbYBURQE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Feb 2008 12:16:04 -0500
Subject: Re: [PATCH] mac80211: fix IBSS code
From: Pavel Roskin <proski@gnu.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	bruno randolf <br1@einfach.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1203588513.17534.138.camel@johannes.berg>
References: <1203588513.17534.138.camel@johannes.berg>
Content-Type: text/plain
Date: Thu, 21 Feb 2008 12:16:02 -0500
Message-Id: <1203614162.2141.2.camel@dv> (sfid-20080221_171613_305417_338AAF29)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2008-02-21 at 11:08 +0100, Johannes Berg wrote:
> -			if (CONFIG_MAC80211_IBSS_DEBUG || net_ratelimit())
> +#ifndef CONFIG_MAC80211_IBSS_DEBUG
> +			if (net_ratelimit())
> +#endif

It looks like you did a better job at guessing the intention of the code
than me.

Please apply this patch, not mine.

-- 
Regards,
Pavel Roskin
