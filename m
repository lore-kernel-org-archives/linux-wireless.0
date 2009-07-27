Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:48641 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751368AbZG0QkW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jul 2009 12:40:22 -0400
Subject: Re: [PATCH 1/3] mac80211: cooperate more with network namespaces
From: Pavel Roskin <proski@gnu.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1248711120.6965.6.camel@mj>
References: <20090713223333.042733013@sipsolutions.net>
	 <20090713223413.255405284@sipsolutions.net>  <1248653082.3106.7.camel@mj>
	 <1248683249.19945.29.camel@johannes.local>  <1248708886.2688.4.camel@mj>
	 <1248710387.8500.5.camel@johannes.local>
	 <1248710568.8500.7.camel@johannes.local>  <1248711120.6965.6.camel@mj>
Content-Type: text/plain
Date: Mon, 27 Jul 2009 12:40:21 -0400
Message-Id: <1248712821.11808.6.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2009-07-27 at 12:12 -0400, Pavel Roskin wrote:
> +			if (!(info->flags & IEEE80211_TX_INTFL_NEED_TXPROCESSING))
> +				continue;

P.S. ieee80211_tx_pending_skb() actually checks
IEEE80211_TX_INTFL_NEED_TXPROCESSING and doesn't use sdata in that case.

Perhaps we could use skb->dev instead of sdata->dev in that case.

Also, the existence of ieee80211_tx_pending_skb() doesn't seem justified
in its present form.  It's a piece of ieee80211_tx_pending() that
calculates the same variables and does the checks that the caller should
be doing.  I would just integrate it into ieee80211_tx_pending().  If
the result is too complex, we could split it in a more logical way.

-- 
Regards,
Pavel Roskin
