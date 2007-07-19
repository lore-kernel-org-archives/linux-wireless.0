Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:38463 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1764612AbXGSPbt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Jul 2007 11:31:49 -0400
Date: Thu, 19 Jul 2007 17:32:05 +0200
From: Jiri Benc <jbenc@suse.cz>
To: "Li YanBo" <dreamfly281@gmail.com>
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Jeff willam" <angelbane@gmail.com>
Subject: Re: Airgo MIMO Wireless card mac80211 driver (unfinished)
Message-ID: <20070719173205.622e2223@griffin.suse.cz>
In-Reply-To: <1197ff4c0707190820s26f28fafy784900d41f6b1ad4@mail.gmail.com>
References: <1197ff4c0707190820s26f28fafy784900d41f6b1ad4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 19 Jul 2007 23:20:35 +0800, Li YanBo wrote:
> BTW, I find a problem in the file ieee80211.c it locals in the
> function "static int __ieee80211_tx()", I think the if (i ==
> tx->u.tx.num_extra_frag)  is ineffective, because 'i' always lower
> than tx->u.tx.num_extra_frag. I guess maybe it should be if (i ==
> (tx->u.tx.num_extra_frag - 1)), below is the patch, CMIIW.

You're right. Could you add your Signed-off-by?

Thanks,

 Jiri

> 
> BR
> LiYanBo
> 
> diff --git a/net/mac80211/ieee80211.c b/net/mac80211/ieee80211.c
> index fcad801..48c51bf 100644
> --- a/net/mac80211/ieee80211.c
> +++ b/net/mac80211/ieee80211.c
> @@ -1406,7 +1406,7 @@ static int __ieee80211_tx(struct ieee80211_local
> *local, struct sk_buff *
>                                 continue;
>                         if (__ieee80211_queue_stopped(local, control->queue))
>                                 return IEEE80211_TX_FRAG_AGAIN;
> -                       if (i == tx->u.tx.num_extra_frag) {
> +                       if (i == (tx->u.tx.num_extra_frag - 1)) {
>                                 control->tx_rate = tx->u.tx.last_frag_hwrate;
>                                 control->rate = tx->u.tx.last_frag_rate;
>                                 if (tx->u.tx.probe_last_frag)


-- 
Jiri Benc
SUSE Labs
