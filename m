Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:33060 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751520Ab1GLOW6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jul 2011 10:22:58 -0400
References: <cover.1310339688.git.mirq-linux@rere.qmqm.pl> <280ad9176e6532f231e054b38b952b20580874c5.1310339688.git.mirq-linux@rere.qmqm.pl> <4E1BCF36.2010506@openwrt.org> <20110712095541.GA6236@rere.qmqm.pl> <B4765EFC-B5C9-4E2D-BE00-ED5519D13A4E@nbd.name> <20110712130316.GA8621@rere.qmqm.pl>
In-Reply-To: <20110712130316.GA8621@rere.qmqm.pl>
Mime-Version: 1.0 (iPhone Mail 8H7)
Content-Type: text/plain;
	charset=utf-8
Message-Id: <EC2F82D7-9206-4139-9539-F5DDE38A5629@nbd.name> (sfid-20110712_162302_896785_0A4C38AC)
Cc: Felix Fietkau <nbd@openwrt.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Jouni Malinen <jmalinen@atheros.com>,
	Senthil Balasubramanian <senthilkumar@atheros.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Ralf Baechle <ralf@linux-mips.org>,
	"linux-mips@linux-mips.org" <linux-mips@linux-mips.org>
From: Felix Fietkau <nbd@nbd.name>
Subject: Re: [ath9k-devel] [PATCH v2 07/46] net/wireless: ath9k: fix DMA API usage
Date: Tue, 12 Jul 2011 22:21:05 +0800
To: =?utf-8?Q?Micha=C5=82_Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12.07.2011, at 21:03, Michał Mirosław <mirq-linux@rere.qmqm.pl> wrote:

> On Tue, Jul 12, 2011 at 08:54:32PM +0800, Felix Fietkau wrote:
>> On 12.07.2011, at 17:55, Michał Mirosław <mirq-linux@rere.qmqm.pl> wrote:
>> 
>>> On Tue, Jul 12, 2011 at 12:36:06PM +0800, Felix Fietkau wrote:
>>>> On 2011-07-11 8:52 AM, Michał Mirosław wrote:
>>>>> Also constify buf_addr for ath9k_hw_process_rxdesc_edma() to verify
>>>>> assumptions --- dma_sync_single_for_device() call can be removed.
>>>>> 
>>>>> Signed-off-by: Michał Mirosław<mirq-linux@rere.qmqm.pl>
>>>>> ---
>>>>> drivers/net/wireless/ath/ath9k/ar9003_mac.c |    4 ++--
>>>>> drivers/net/wireless/ath/ath9k/ar9003_mac.h |    2 +-
>>>>> drivers/net/wireless/ath/ath9k/recv.c       |   10 +++-------
>>>>> 3 files changed, 6 insertions(+), 10 deletions(-)
>>>>> 
>>>>> diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
>>>>> index 70dc8ec..c5f46d5 100644
>>>>> --- a/drivers/net/wireless/ath/ath9k/recv.c
>>>>> +++ b/drivers/net/wireless/ath/ath9k/recv.c
>>>>> @@ -684,15 +684,11 @@ static bool ath_edma_get_buffers(struct ath_softc *sc,
>>>>>   BUG_ON(!bf);
>>>>> 
>>>>>   dma_sync_single_for_cpu(sc->dev, bf->bf_buf_addr,
>>>>> -                common->rx_bufsize, DMA_FROM_DEVICE);
>>>>> +                common->rx_bufsize, DMA_BIDIRECTIONAL);
>>>>> 
>>>>>   ret = ath9k_hw_process_rxdesc_edma(ah, NULL, skb->data);
>>>>> -    if (ret == -EINPROGRESS) {
>>>>> -        /*let device gain the buffer again*/
>>>>> -        dma_sync_single_for_device(sc->dev, bf->bf_buf_addr,
>>>>> -                common->rx_bufsize, DMA_FROM_DEVICE);
>>>>> +    if (ret == -EINPROGRESS)
>>>>>       return false;
>>>>> -    }
>>>>> 
>>>>>   __skb_unlink(skb,&rx_edma->rx_fifo);
>>>>>   if (ret == -EINVAL) {
>>>> I have strong doubts about this change. On most MIPS devices,
>>>> dma_sync_single_for_cpu is a no-op, whereas
>>>> dma_sync_single_for_device flushes the cache range. With this
>>>> change, the CPU could cache the DMA status part behind skb->data and
>>>> that cache entry would not be flushed inbetween calls to this
>>>> functions on the same buffer, likely leading to rx stalls.
>>> 
>>> You're suggesting a platform implementation bug then. If the platform is not
>>> cache-coherent, it should invalidate relevant CPU cache lines for sync_to_cpu
>>> and unmap cases. Do other devices show such symptoms on MIPS systems?
>>> 
>>> I'm not familiar with the platform internals, so we should ask MIPS people.
>> I only mentioned MIPS to describe the potential side effect of this change. From my current understanding of the DMA API, it would be wrong on other platforms as well. I believe the _for_device function needs to be used to transfer ownership of the buffer back to the device, before calling _for_cpu again later for another read.
> 
> What you're saying reminds the wording in DMA-API-HOWTO.txt that I find
> wrong (or at least misleading) compared to what DMA-API.txt describes.
> DMA sync calls do not transfer the ownership of the buffer - they are
> cache synchronization points, ownership passing is handled entirely by
> the driver.
What I meant was that the DMA sync calls reflect the ownership transfer of the memory regions. In this case ownership is transferred between device and CPU multiple times and the code reflects that.

> 
>> This is definitely required in this case, because when the return code is -EINPROGRESS, the driver waits for the hardware to complete this buffer, and the next call has to fetch the memory again after the device has updated it.
> 
> Correctness of this access should be provided by sync_to_cpu() call.
At least in MIPS I'm sure it isn't. If I remember correctly, it also isn't on ARM, so I'm pretty sure that either your understanding of the API is incorrect, or arch code does not implement it properly. In either case, this change (and probably also the p54 one) should not be merged.

- Felix