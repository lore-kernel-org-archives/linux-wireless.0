Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:51792 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753635AbbCBSxr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Mar 2015 13:53:47 -0500
Message-ID: <1425322425.1906.4.camel@sipsolutions.net> (sfid-20150302_195354_759126_A9E6657C)
Subject: Re: [PATCH RFC 08/14] net: wireless: mac80211: shrink
 ieee80211_tx_info
From: Johannes Berg <johannes@sipsolutions.net>
To: Florian Westphal <fw@strlen.de>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Date: Mon, 02 Mar 2015 19:53:45 +0100
In-Reply-To: <1425318028-26531-9-git-send-email-fw@strlen.de> (sfid-20150302_184059_463522_70F2B3E8)
References: <1425318028-26531-1-git-send-email-fw@strlen.de>
	 <1425318028-26531-9-git-send-email-fw@strlen.de>
	 (sfid-20150302_184059_463522_70F2B3E8)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-03-02 at 18:40 +0100, Florian Westphal wrote:
> to make it fit into (future) 44-byte sized skb->cb[].
> 
> This works, since flags is only used to store values
> from mac80211_tx_control_flags enum, and these are just 2 bits.
> We can thus move this to the padding hole inside the union.
> 
> Also add BUILD_BUG_ON magic to make sure that the new flags
> field doesn't share storage w. other members of the union.

This is really ugly - what's the point of this?

Mind you - we are actually acutely out of space and would rather have
*more*, not less.

johannes

