Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:52258 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751064AbaKQM3J (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Nov 2014 07:29:09 -0500
Message-ID: <1416227346.2031.3.camel@sipsolutions.net> (sfid-20141117_132913_426156_071F0C6B)
Subject: Re: [PATCH] mac80211: fix 11b fragmentation rx
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 17 Nov 2014 13:29:06 +0100
In-Reply-To: <1416223626-10980-1-git-send-email-michal.kazior@tieto.com> (sfid-20141117_123935_571471_5D6961B2)
References: <1416223626-10980-1-git-send-email-michal.kazior@tieto.com>
	 (sfid-20141117_123935_571471_5D6961B2)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-11-17 at 12:27 +0100, Michal Kazior wrote:
> After fragmentation reassembly was complete code
> tried to dereference hdr pointer which pointed to
> data of an sk_buff that has been freed.

Curious. This bug has been around forever (since the introduction of
mac80211). I wonder what changed that you *also* found it now - because
we also found it recently!

> --- a/net/mac80211/rx.c
> +++ b/net/mac80211/rx.c
> @@ -1854,6 +1854,7 @@ ieee80211_rx_h_defragment(struct ieee80211_rx_data *rx)
>  	/* Complete frame has been reassembled - process it now */
>  	status = IEEE80211_SKB_RXCB(rx->skb);
>  	status->rx_flags |= IEEE80211_RX_FRAGMENTED;
> +	hdr = (struct ieee80211_hdr *)rx->skb->data;

This is technically correct, but useless. I already have this patch in
my tree instead:

https://git.kernel.org/cgit/linux/kernel/git/jberg/mac80211.git/commit/?id=b8fff407a180286aa683d543d878d98d9fc57b13

johannes

