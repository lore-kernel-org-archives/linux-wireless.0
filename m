Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37866
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754845AbYELJJK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 May 2008 05:09:10 -0400
Date: Mon, 12 May 2008 02:09:04 -0700 (PDT)
Message-Id: <20080512.020904.187999229.davem@davemloft.net> (sfid-20080512_110916_335277_F824EBAF)
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org
Subject: Re: [RFT/C 2/7] mac80211: clean up skb reallocation code
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080510221906.261962000@sipsolutions.net>
References: <20080510221845.340428000@sipsolutions.net>
	<20080510221906.261962000@sipsolutions.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>
Date: Sun, 11 May 2008 00:18:47 +0200

In patch one, you changed the call site of this new
ieee80211_skb_resize() to properly use skb_header_cloned().  But
skb_cloned snuck back into the statistics code in this patch:

> +	if (skb_cloned(skb))
> +		I802_DEBUG_INC(local->tx_expand_skb_head_cloned);
> +	else
> +		I802_DEBUG_INC(local->tx_expand_skb_head);
