Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f67.google.com ([209.85.214.67]:52918 "EHLO
        mail-it0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751476AbeEBNeY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 2 May 2018 09:34:24 -0400
Received: by mail-it0-f67.google.com with SMTP id i136-v6so8504967ita.2
        for <linux-wireless@vger.kernel.org>; Wed, 02 May 2018 06:34:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180502130726.GA13887@redhat.com>
References: <cover.1525096206.git.lorenzo.bianconi@redhat.com>
 <9d50bf4d74ec52e141dd112768570e15a481ad2e.1525096206.git.lorenzo.bianconi@redhat.com>
 <20180502130726.GA13887@redhat.com>
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Date: Wed, 2 May 2018 15:34:22 +0200
Message-ID: <CAJ0CqmUEULD0X_CaLLnF3jeRJQdgLM2LK-XPt==nDuThF7wGKA@mail.gmail.com> (sfid-20180502_153728_769779_B50B3FE8)
Subject: Re: [RFC 06/18] mt76x2: introduce mt76x2_mac_load_tx_status routine
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Felix Fietkau <nbd@nbd.name>,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> On Mon, Apr 30, 2018 at 04:12:21PM +0200, Lorenzo Bianconi wrote:
>> Add mt76x2_mac_load_tx_status routine since tx stats register map is
>> shared between usb and pci based devices but usb devices do not have a
>> tx stat irq line as pcie ones and it is necessary to load tx statistics
>> using a workqueue
>>
>> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
>> ---
>>  drivers/net/wireless/mediatek/mt76/mt76x2_mac.c | 43 +++++++++++++++----------
>>  1 file changed, 26 insertions(+), 17 deletions(-)
>>
>> diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x2_mac.c
>> index d18315652583..0ddc84525ffa 100644
>> --- a/drivers/net/wireless/mediatek/mt76/mt76x2_mac.c
>> +++ b/drivers/net/wireless/mediatek/mt76/mt76x2_mac.c
>> @@ -515,6 +515,28 @@ mt76x2_send_tx_status(struct mt76x2_dev *dev, struct mt76x2_tx_status *stat,
>>       rcu_read_unlock();
>>  }
>>
>> +static struct mt76x2_tx_status
>> +mt76x2_mac_load_tx_status(struct mt76x2_dev *dev)
>> +{
>> +     struct mt76x2_tx_status stat = {};
>> +     u32 stat1, stat2;
>> +
>> +     stat2 = mt76_rr(dev, MT_TX_STAT_FIFO_EXT);
>> +     stat1 = mt76_rr(dev, MT_TX_STAT_FIFO);
>> +
>> +     stat.valid = !!(stat1 & MT_TX_STAT_FIFO_VALID);
>> +     stat.success = !!(stat1 & MT_TX_STAT_FIFO_SUCCESS);
>> +     stat.aggr = !!(stat1 & MT_TX_STAT_FIFO_AGGR);
>> +     stat.ack_req = !!(stat1 & MT_TX_STAT_FIFO_ACKREQ);
>> +     stat.wcid = FIELD_GET(MT_TX_STAT_FIFO_WCID, stat1);
>> +     stat.rate = FIELD_GET(MT_TX_STAT_FIFO_RATE, stat1);
>> +
>> +     stat.retry = FIELD_GET(MT_TX_STAT_FIFO_EXT_RETRY, stat2);
>> +     stat.pktid = FIELD_GET(MT_TX_STAT_FIFO_EXT_PKTID, stat2);
>> +
>> +     return stat;
>> +}
>> +
>
> Just two minor points. We do not need fill structure if stat is
> not valid. Also returning mt76x2_tx_status structure might require
> full copy of it. Returning boolean indicator of validity and pass
> pointer to struct mt76x2_tx_status to the subroutine would be more
> efficient.
>
> Regards
> Stanislaw

I agree, thx for the review. I will address your suggestions in v1.

Regards,
Lorenzo
