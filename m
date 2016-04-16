Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:60404 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751795AbcDPWVK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Apr 2016 18:21:10 -0400
Message-ID: <1460845267.2075.26.camel@sipsolutions.net> (sfid-20160417_002115_793877_9F4B7EC8)
Subject: Re: [PATCHv3 1/5] mac80211: skip netdev queue control with software
 queuing
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>,
	linux-wireless@vger.kernel.org
Cc: dave.taht@gmail.com, make-wifi-fast@lists.bufferbloat.net,
	codel@lists.bufferbloat.net, apenwarr@gmail.com
Date: Sun, 17 Apr 2016 00:21:07 +0200
In-Reply-To: <1460636302-31161-2-git-send-email-michal.kazior@tieto.com> (sfid-20160414_141628_659448_D3FFFECB)
References: <1459420104-31554-1-git-send-email-michal.kazior@tieto.com>
	 <1460636302-31161-1-git-send-email-michal.kazior@tieto.com>
	 <1460636302-31161-2-git-send-email-michal.kazior@tieto.com>
	 (sfid-20160414_141628_659448_D3FFFECB)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> +static void ieee80211_txq_enqueue(struct ieee80211_local *local,
> +				  struct txq_info *txqi,
> +				  struct sk_buff *skb)
> +{
> +	lockdep_assert_held(&txqi->queue.lock);
[...]
> +	atomic_inc(&local->num_tx_queued);

This global kinda bothers me - anything we can do about removing it?

We obviously didn't have it now - just one (even bigger limit!) per
queue, so that's 4000 frames default per interface ... now you're down
to 512 for the entire hardware. Perhaps keeping it per interface at
least gets away the worst of the contention here?

johannes
