Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55909 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757243Ab2CBId5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Mar 2012 03:33:57 -0500
Subject: Re: [PATCH 07/21] cw1200: queue.*, implementation of TX queues of
 the cw1200 driver.
From: Johannes Berg <johannes@sipsolutions.net>
To: Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1330652495-25837-8-git-send-email-dmitry.tarnyagin@stericsson.com> (sfid-20120302_024202_033691_19CC47E6)
References: <d53e019b1a0bcd29c2c367fbe5665413f2d33938-submit>
	 <1330652495-25837-1-git-send-email-dmitry.tarnyagin@stericsson.com>
	 <1330652495-25837-8-git-send-email-dmitry.tarnyagin@stericsson.com>
	 (sfid-20120302_024202_033691_19CC47E6)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 02 Mar 2012 09:33:53 +0100
Message-ID: <1330677233.3367.7.camel@jlt3.sipsolutions.net> (sfid-20120302_093400_703213_4A10812A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-03-02 at 02:41 +0100, Dmitry Tarnyagin wrote:
> The code implements cw1200 TX queues, used for holding TX frames pending
> transmission. The code supports garbage collecting and accounting of the frames.
> 
> Note that link_id_map here and in the rest of the code is used to track
> (ieee80211) power management state of connected stations in AP mode.
> 
> Signed-off-by: Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>
> ---
>  drivers/staging/cw1200/queue.c |  584 ++++++++++++++++++++++++++++++++++++++++
>  drivers/staging/cw1200/queue.h |  116 ++++++++
>  2 files changed, 700 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/staging/cw1200/queue.c
>  create mode 100644 drivers/staging/cw1200/queue.h
> 
> diff --git a/drivers/staging/cw1200/queue.c b/drivers/staging/cw1200/queue.c
> new file mode 100644
> index 0000000..014e6b2
> --- /dev/null
> +++ b/drivers/staging/cw1200/queue.c
> @@ -0,0 +1,584 @@
> +/*
> + * O(1) TX queue with built-in allocator for ST-Ericsson CW1200 drivers
> + *
> + * Copyright (c) 2010, ST-Ericsson
> + * Author: Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <net/mac80211.h>
> +#include <linux/sched.h>
> +#include "queue.h"
> +#include "cw1200.h"
> +#include "debug.h"
> +
> +/* private */ struct cw1200_queue_item
> +{
> +	struct list_head	head;
> +	struct sk_buff		*skb;
> +	u32			packetID;
> +	unsigned long		queue_timestamp;
> +	unsigned long		xmit_timestamp;
> +	struct cw1200_txpriv	txpriv;
> +	u8			generation;
> +};
> +
> +static inline void __cw1200_queue_lock(struct cw1200_queue *queue)
> +{
> +	struct cw1200_queue_stats *stats = queue->stats;
> +	if (queue->tx_locked_cnt++ == 0) {

Is there some common lock that prevents this getting corrupted? mac80211
and higher layers do not have any synchronisation between the different
TX queues, and you'll need to call this from a few places ... maybe it
needs to be atomic_t?

johannes

