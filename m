Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:49451 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255Ab2B1KJz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Feb 2012 05:09:55 -0500
Received: by bkcik5 with SMTP id ik5so1064047bkc.19
        for <linux-wireless@vger.kernel.org>; Tue, 28 Feb 2012 02:09:54 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1330422678.18637.28.camel@cumari>
References: <1330382494-31148-1-git-send-email-arik@wizery.com>
 <1330382494-31148-3-git-send-email-arik@wizery.com> <1330422678.18637.28.camel@cumari>
From: Arik Nemtsov <arik@wizery.com>
Date: Tue, 28 Feb 2012 12:09:39 +0200
Message-ID: <CA+XVXfeWotOQky8TouJSzhNxCzR4TR3uPYPJ0wDOYzkFhekqig@mail.gmail.com> (sfid-20120228_110959_681416_6DA04A0A)
Subject: Re: [PATCH 3/7] wl12xx: reset link Tx queues when freeing it
To: Luciano Coelho <coelho@ti.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 28, 2012 at 11:51, Luciano Coelho <coelho@ti.com> wrote:
> On Tue, 2012-02-28 at 00:41 +0200, Arik Nemtsov wrote:
>> Before, the link was first freed (invalidating it in the map), and later
>> on vif removal, all valid wlvif-related links were reset. Since these
>> links were already invalid, we failed to reset them.
>> The bug was made worse by op_stop, which set the tx_queue_count to 0
>> arbitrarily. This resulted in a negative tx_queue_count in some scenarios.
>>
>> Fix this by resetting the Tx-queues of a link when freeing it. Add a
>> WARN_ON and reset all link Tx-queues in op_stop, to avoid a negative
>> tx_queue_count.
>>
>> Signed-off-by: Arik Nemtsov <arik@wizery.com>
>> ---
>
> [...]
>
>> diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/wl12xx/tx.c
>> index 6446e4d..311b5a2 100644
>> --- a/drivers/net/wireless/wl12xx/tx.c
>> +++ b/drivers/net/wireless/wl12xx/tx.c
>> @@ -527,6 +527,7 @@ static struct sk_buff *wl12xx_lnk_skb_dequeue(struct wl1271 *wl,
>>       if (skb) {
>>               int q = wl1271_tx_get_queue(skb_get_queue_mapping(skb));
>>               spin_lock_irqsave(&wl->wl_lock, flags);
>> +             WARN_ON(wl->tx_queue_count[q] <= 0);
>>               wl->tx_queue_count[q]--;
>>               spin_unlock_irqrestore(&wl->wl_lock, flags);
>>       }
>> @@ -602,6 +603,7 @@ static struct sk_buff *wl1271_skb_dequeue(struct wl1271 *wl)
>>               skb = wl->dummy_packet;
>>               q = wl1271_tx_get_queue(skb_get_queue_mapping(skb));
>>               spin_lock_irqsave(&wl->wl_lock, flags);
>> +             WARN_ON(wl->tx_queue_count[q] <= 0);
>>               wl->tx_queue_count[q]--;
>>               spin_unlock_irqrestore(&wl->wl_lock, flags);
>>       }
>
> [...]
>
>> @@ -973,8 +974,14 @@ void wl12xx_tx_reset(struct wl1271 *wl, bool reset_tx_queues)
>>       struct sk_buff *skb;
>>       struct ieee80211_tx_info *info;
>>
>> -     for (i = 0; i < NUM_TX_QUEUES; i++)
>> -             wl->tx_queue_count[i] = 0;
>> +     /* only reset the queues if something bad happened */
>> +     if (WARN_ON(wl1271_tx_total_queue_count(wl) != 0)) {
>
> Let's make all these WARN_ONs as WARN_ON_ONCE as it is recommended
> nowadays.  This will make Kalle Valo happier. :)
>
> I can do a quick sed before I apply this, if you agree.

Sure thing.

Arik
