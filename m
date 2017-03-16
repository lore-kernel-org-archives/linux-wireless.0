Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:41934 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751037AbdCPKQk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 16 Mar 2017 06:16:40 -0400
Message-ID: <1489659397.2370.8.camel@sipsolutions.net> (sfid-20170316_111643_645407_542886C7)
Subject: Re: [PATCH v2] mac80211: Jitter HWMP MPATH reply frames to reduce
 collision on dense networks.
From: Johannes Berg <johannes@sipsolutions.net>
To: agreen@cococorp.com, linux-wireless@vger.kernel.org
Cc: Jesse Jones <jjones@cococorp.com>
Date: Thu, 16 Mar 2017 11:16:37 +0100
In-Reply-To: <58B09082.7020704@cococorp.com> (sfid-20170224_205905_277542_E6C0402D)
References: <58B09082.7020704@cococorp.com>
         (sfid-20170224_205905_277542_E6C0402D)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

So I guess after all the discussion, you should amend the commit log a
bit, certainly at least to mention the hidden-node issue.

Regarding the patch itself, I'm not super happy with how big it is,
some additional comments below:

> +struct mesh_tx_queue {
> +	struct list_head list;
> +	struct sk_buff *skb;
> +};

This seems awkward, what's wrong with using an SKB list (struct
sk_buff_head, skb_queue_* etc)?

> +	/* Spinlock for trasmitted MPATH frames */
> +	spinlock_t mesh_tx_queue_lock;

That would also contain the extra spinlock.

> +	struct mesh_tx_queue tx_queue;

This was always a bad idea, since you never need the skb pointer here -
should've just used struct list_head.

> +	int tx_queue_len;

Also contained in the skb queue.

> +	struct delayed_work tx_work;

I don't really see any value here for a delayed work - a pure timer
would work just as well?

Also, these fields should be in ifmsh, I think?

johannes
