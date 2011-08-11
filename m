Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:55701 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753938Ab1HKUyk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Aug 2011 16:54:40 -0400
Received: by ywf7 with SMTP id 7so1590346ywf.19
        for <linux-wireless@vger.kernel.org>; Thu, 11 Aug 2011 13:54:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1313062720.2407.848.camel@cumari>
References: <1312881233-9366-1-git-send-email-eliad@wizery.com>
 <1312881233-9366-35-git-send-email-eliad@wizery.com> <1313062720.2407.848.camel@cumari>
From: Arik Nemtsov <anamtsov@gmail.com>
Date: Thu, 11 Aug 2011 23:54:24 +0300
Message-ID: <CA+XVXfeXfxtv1UO+tFjub6+n2P8dtcHyaHo0gpgv=kETwVRJHA@mail.gmail.com> (sfid-20110811_225443_235882_1E540DB5)
Subject: Re: [PATCH 34/40] wl12xx: schedule TX packets according to FW packet occupancy
To: Luciano Coelho <coelho@ti.com>
Cc: Eliad Peller <eliad@wizery.com>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 11, 2011 at 14:38, Luciano Coelho <coelho@ti.com> wrote:
> On Tue, 2011-08-09 at 12:13 +0300, Eliad Peller wrote:
>> +static struct sk_buff_head *wl1271_select_queue(struct wl1271 *wl,
>> +                                             struct sk_buff_head *queues)
>> +{
>> +     int i, q = -1;
>> +     u32 min_pkts = 0xffffffff;
>> +
>> +     /*
>> +      * Find a non-empty ac where:
>> +      * 1. There are packets to transmit
>> +      * 2. The FW has the least allocated blocks
>> +      */
>> +     for (i = 0; i < NUM_TX_QUEUES; i++)
>> +             if (!skb_queue_empty(&queues[i]) &&
>> +                 (wl->tx_allocated_pkts[i] < min_pkts)) {
>> +                     q = i;
>> +                     min_pkts = wl->tx_allocated_pkts[q];
>> +             }
>> +
>> +     if (q == -1)
>> +             return NULL;
>> +
>> +     return &queues[q];
>> +}
>
> This is a nice algorithm, but now, if all queues have the same number of
> allocated packets in the FW, we'll start with BE, because the enum is
> like this:
>
> enum conf_tx_ac {
> CONF_TX_AC_BE = 0,         /* best effort / legacy */
> CONF_TX_AC_BK = 1,         /* background */
> CONF_TX_AC_VI = 2,         /* video */
> CONF_TX_AC_VO = 3,         /* voice */
> CONF_TX_AC_CTS2SELF = 4,   /* fictitious AC, follows AC_VO */
> CONF_TX_AC_ANY_TID = 0x1f
> };
>
> ...and you select the first queue in case two or more are similarly
> full.
>
> Maybe you could make the for loop go backwards instead? Or changing the
> < to <= in the comparison would also work.

sure we can change it to <=. VO is usually a higher priority than BK.

>
> Another option would be to fix the enum so that it goes from higher prio
> to lower prio.  If the firmware doesn't care about the actual order of
> the queues and actually respects our ac_conf, this would probably be the
> best solution, because we could even get rid of wl1271_tx_get_queue()
> and wl1271_tx_get_mac80211_queue().

I suspect the FW is using these constants, so we wouldn't want to touch those.

>
> Now something else came to my mind.  Could it also happen that the other
> queues would still be starved? Let's say we keep getting packets
> continuously for the first queue we choose exactly at the interval it
> takes the FW to empty that queue.  Meanwhile, we're getting some packets
> for other queues.  In this case, we would keep selecting the same AC
> because all the queues would be empty and we would keep choosing the
> first one.
>

That is a theoretical starvation condition (among several others).
This was there before this patch as well. The ratio of packet
throughput/FW memory/air throughput has to be just right for this to
happen, and it doesn't occur with current hardware. We'll handle this
when the problem arises (at the cost of added complexity).

Arik

> Maybe we should still once in a while check the other queues?
>
> Or am I missing something again?
>
> --
> Cheers,
> Luca.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
