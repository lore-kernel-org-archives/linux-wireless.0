Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47368
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754349AbYELJLv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 May 2008 05:11:51 -0400
Date: Mon, 12 May 2008 02:11:45 -0700 (PDT)
Message-Id: <20080512.021145.265455571.davem@davemloft.net> (sfid-20080512_111153_740595_BCE08C01)
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, IvDoorn@gmail.com
Subject: Re: [RFT/C 7/7] mac80211: move TX info into skb->cb
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080510221908.875473000@sipsolutions.net>
References: <20080510221845.340428000@sipsolutions.net>
	<20080510221908.875473000@sipsolutions.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>
Date: Sun, 11 May 2008 00:18:52 +0200

> This patch converts mac80211 and all drivers to have transmit
> information and status in skb->cb rather than allocating extra
> memory for it and copying all the data around. To make it fit,
> a union is used where only data that is necessary for all steps
> is kept outside of the union.
> 
> A number of fixes were done by Ivo, as well as the rt2x00 part
> of this patch.
> 
> Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

Please create an IEEE80211_SKB_CB() or similar macro to wrap
these casts around with, like all other SKB CB users do.

Otherwise:

Acked-by: David S. Miller <davem@davemloft.net>
