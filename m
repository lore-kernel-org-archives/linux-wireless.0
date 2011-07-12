Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:32845 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753194Ab1GLFah (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jul 2011 01:30:37 -0400
Message-ID: <4E1BDBEF.1090505@candelatech.com> (sfid-20110712_073045_629597_D465551E)
Date: Mon, 11 Jul 2011 22:30:23 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>
CC: =?UTF-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>,
	netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	Jouni Malinen <jmalinen@atheros.com>,
	Senthil Balasubramanian <senthilkumar@atheros.com>,
	ath9k-devel@venema.h4ckr.net,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>
Subject: Re: [ath9k-devel] [PATCH v2 07/46] net/wireless: ath9k: fix DMA API
 usage
References: <cover.1310339688.git.mirq-linux@rere.qmqm.pl> <280ad9176e6532f231e054b38b952b20580874c5.1310339688.git.mirq-linux@rere.qmqm.pl> <4E1BCF36.2010506@openwrt.org>
In-Reply-To: <4E1BCF36.2010506@openwrt.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/11/2011 09:36 PM, Felix Fietkau wrote:
> On 2011-07-11 8:52 AM, Michał Mirosław wrote:
>> Also constify buf_addr for ath9k_hw_process_rxdesc_edma() to verify
>> assumptions --- dma_sync_single_for_device() call can be removed.
>>
>> Signed-off-by: Michał Mirosław<mirq-linux@rere.qmqm.pl>
>> ---
>> drivers/net/wireless/ath/ath9k/ar9003_mac.c | 4 ++--
>> drivers/net/wireless/ath/ath9k/ar9003_mac.h | 2 +-
>> drivers/net/wireless/ath/ath9k/recv.c | 10 +++-------
>> 3 files changed, 6 insertions(+), 10 deletions(-)
>>
>> diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
>> index 70dc8ec..c5f46d5 100644
>> --- a/drivers/net/wireless/ath/ath9k/recv.c
>> +++ b/drivers/net/wireless/ath/ath9k/recv.c
>> @@ -684,15 +684,11 @@ static bool ath_edma_get_buffers(struct ath_softc *sc,
>> BUG_ON(!bf);
>>
>> dma_sync_single_for_cpu(sc->dev, bf->bf_buf_addr,
>> - common->rx_bufsize, DMA_FROM_DEVICE);
>> + common->rx_bufsize, DMA_BIDIRECTIONAL);
>>
>> ret = ath9k_hw_process_rxdesc_edma(ah, NULL, skb->data);
>> - if (ret == -EINPROGRESS) {
>> - /*let device gain the buffer again*/
>> - dma_sync_single_for_device(sc->dev, bf->bf_buf_addr,
>> - common->rx_bufsize, DMA_FROM_DEVICE);
>> + if (ret == -EINPROGRESS)
>> return false;
>> - }
>>
>> __skb_unlink(skb,&rx_edma->rx_fifo);
>> if (ret == -EINVAL) {
> I have strong doubts about this change. On most MIPS devices, dma_sync_single_for_cpu is a no-op, whereas dma_sync_single_for_device flushes the cache range.
> With this change, the CPU could cache the DMA status part behind skb->data and that cache entry would not be flushed inbetween calls to this functions on the
> same buffer, likely leading to rx stalls.

At the very least, it would need heavy testing.  It took a very long time to get
the ath9k DMA issues (mostly?) resolved...so we shouldn't go mucking in this
code on theory...

Thanks,
Ben

>
> - Felix
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
