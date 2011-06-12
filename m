Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:38842 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160Ab1FLSPy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Jun 2011 14:15:54 -0400
Received: by qyg14 with SMTP id 14so2231134qyg.19
        for <linux-wireless@vger.kernel.org>; Sun, 12 Jun 2011 11:15:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110612182916.6afc781a@maggie>
References: <1307891513-6812-1-git-send-email-zajec5@gmail.com>
	<20110612182916.6afc781a@maggie>
Date: Sun, 12 Jun 2011 20:15:53 +0200
Message-ID: <BANLkTikVLH8xApD4e5uNW-3Eg6kaMXipBg@mail.gmail.com> (sfid-20110612_201601_998554_E57E2FB3)
Subject: Re: [RFC][PATCH] b43: do not try sending packets when ring can be full
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: =?UTF-8?Q?Michael_B=C3=BCsch?= <m@bues.ch>
Cc: linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
	francesco.gringoli@ing.unibs.it,
	=?UTF-8?Q?Michael_B=C3=BCsch?= <mb@bu3sch.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/6/12 Michael Büsch <m@bues.ch>:
> On Sun, 12 Jun 2011 17:11:53 +0200
> Rafał Miłecki <zajec5@gmail.com> wrote:
>
>> ---
>> This prevents us from hitting "Packet after queue stopped", but still
>> is not an optimal solution. We stop sending packets from queue to
>> hardware if just a one ring is full. It may happen there are packets on
>> the queue that want to be send to different ring (qos).
>> ---
>>  drivers/net/wireless/b43/b43.h  |    2 ++
>>  drivers/net/wireless/b43/dma.c  |    5 +++++
>>  drivers/net/wireless/b43/main.c |    5 +++++
>>  3 files changed, 12 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/net/wireless/b43/b43.h b/drivers/net/wireless/b43/b43.h
>> index 1cb2dde..8d4bb28 100644
>> --- a/drivers/net/wireless/b43/b43.h
>> +++ b/drivers/net/wireless/b43/b43.h
>> @@ -582,6 +582,8 @@ struct b43_dma {
>>       struct b43_dmaring *rx_ring;
>>
>>       u32 translation; /* Routing bits */
>> +
>> +     u8 stopped_rings; /* Amount of stopped rings */
>>  };
>>
>>  struct b43_pio_txqueue;
>> diff --git a/drivers/net/wireless/b43/dma.c b/drivers/net/wireless/b43/dma.c
>> index d02cf83..a501992 100644
>> --- a/drivers/net/wireless/b43/dma.c
>> +++ b/drivers/net/wireless/b43/dma.c
>> @@ -1056,6 +1056,7 @@ int b43_dma_init(struct b43_wldev *dev)
>>       if (err)
>>               return err;
>>       dma->translation = ssb_dma_translation(dev->sdev);
>> +     dma->stopped_rings = 0;
>>
>>       err = -ENOMEM;
>>       /* setup TX DMA channels. */
>> @@ -1374,6 +1375,8 @@ int b43_dma_tx(struct b43_wldev *dev, struct sk_buff *skb)
>>               /* This TX ring is full. */
>>               ieee80211_stop_queue(dev->wl->hw, skb_get_queue_mapping(skb));
>>               ring->stopped = 1;
>> +             dev->dma.stopped_rings++;
>> +
>>               if (b43_debug(dev, B43_DBG_DMAVERBOSE)) {
>>                       b43dbg(dev->wl, "Stopped TX ring %d\n", ring->index);
>>               }
>> @@ -1493,9 +1496,11 @@ void b43_dma_handle_txstatus(struct b43_wldev *dev,
>>               B43_WARN_ON(free_slots(ring) < TX_SLOTS_PER_FRAME);
>>               ieee80211_wake_queue(dev->wl->hw, ring->queue_prio);
>>               ring->stopped = 0;
>> +             dev->dma.stopped_rings--;
>>               if (b43_debug(dev, B43_DBG_DMAVERBOSE)) {
>>                       b43dbg(dev->wl, "Woke up TX ring %d\n", ring->index);
>>               }
>> +             ieee80211_queue_work(dev->wl->hw, &dev->wl->tx_work);
>>       }
>>  }
>>
>> diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
>> index 1d8d983..2260b36 100644
>> --- a/drivers/net/wireless/b43/main.c
>> +++ b/drivers/net/wireless/b43/main.c
>> @@ -3219,6 +3219,11 @@ static void b43_tx_work(struct work_struct *work)
>>       }
>>
>>       while (skb_queue_len(&wl->tx_queue)) {
>> +             if (!b43_using_pio_transfers(dev) && dev->dma.stopped_rings) {
>> +                     mutex_unlock(&wl->mutex);
>> +                     return;
>> +             }
>> +
>>               skb = skb_dequeue(&wl->tx_queue);
>>
>>               if (b43_using_pio_transfers(dev))
>
> This can probably serve as a quick workaround, as long as a real fix is being developed.

Yeah, that's what my summary/comment say :)


> I'm not sure if multiple queues are needed for this to work. I think it could work
> with a single queue as well. We just must not _unqueue_ it, if we are unable to transmit
> it due to stopped ring. I don't know if there are skb_queue mechanisms that help
> us achieve this.

Well, as I said, we may be unable to transmit the first element of the
queue, but 2nd/3rd/... may be for different ring (qos) (we can
transmit).

Looping through the whole queue every time, just to find packets we
may transmit, sounds surely as a bad idea.

The only idea I've right now, are separated TX skb queues, one for each qos.

-- 
Rafał
