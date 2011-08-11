Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:53632 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753043Ab1HKLip (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Aug 2011 07:38:45 -0400
Received: by mail-bw0-f51.google.com with SMTP id r19so1257705bka.24
        for <linux-wireless@vger.kernel.org>; Thu, 11 Aug 2011 04:38:43 -0700 (PDT)
Subject: Re: [PATCH 34/40] wl12xx: schedule TX packets according to FW
 packet occupancy
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1312881233-9366-35-git-send-email-eliad@wizery.com>
References: <1312881233-9366-1-git-send-email-eliad@wizery.com>
	 <1312881233-9366-35-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 11 Aug 2011 14:38:40 +0300
Message-ID: <1313062720.2407.848.camel@cumari> (sfid-20110811_133848_133745_6514B823)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-08-09 at 12:13 +0300, Eliad Peller wrote: 
> +static struct sk_buff_head *wl1271_select_queue(struct wl1271 *wl,
> +						struct sk_buff_head *queues)
> +{
> +	int i, q = -1;
> +	u32 min_pkts = 0xffffffff;
> +
> +	/*
> +	 * Find a non-empty ac where:
> +	 * 1. There are packets to transmit
> +	 * 2. The FW has the least allocated blocks
> +	 */
> +	for (i = 0; i < NUM_TX_QUEUES; i++)
> +		if (!skb_queue_empty(&queues[i]) &&
> +		    (wl->tx_allocated_pkts[i] < min_pkts)) {
> +			q = i;
> +			min_pkts = wl->tx_allocated_pkts[q];
> +		}
> +
> +	if (q == -1)
> +		return NULL;
> +
> +	return &queues[q];
> +}

This is a nice algorithm, but now, if all queues have the same number of
allocated packets in the FW, we'll start with BE, because the enum is
like this:

enum conf_tx_ac {
CONF_TX_AC_BE = 0,         /* best effort / legacy */
CONF_TX_AC_BK = 1,         /* background */
CONF_TX_AC_VI = 2,         /* video */
CONF_TX_AC_VO = 3,         /* voice */
CONF_TX_AC_CTS2SELF = 4,   /* fictitious AC, follows AC_VO */
CONF_TX_AC_ANY_TID = 0x1f
};

...and you select the first queue in case two or more are similarly
full.

Maybe you could make the for loop go backwards instead? Or changing the
< to <= in the comparison would also work.

Another option would be to fix the enum so that it goes from higher prio
to lower prio.  If the firmware doesn't care about the actual order of
the queues and actually respects our ac_conf, this would probably be the
best solution, because we could even get rid of wl1271_tx_get_queue()
and wl1271_tx_get_mac80211_queue().

Now something else came to my mind.  Could it also happen that the other
queues would still be starved? Let's say we keep getting packets
continuously for the first queue we choose exactly at the interval it
takes the FW to empty that queue.  Meanwhile, we're getting some packets
for other queues.  In this case, we would keep selecting the same AC
because all the queues would be empty and we would keep choosing the
first one.

Maybe we should still once in a while check the other queues?

Or am I missing something again?

-- 
Cheers,
Luca.

