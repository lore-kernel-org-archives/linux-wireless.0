Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:48984 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314Ab2HUUHF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Aug 2012 16:07:05 -0400
Received: by wgbdr13 with SMTP id dr13so169310wgb.1
        for <linux-wireless@vger.kernel.org>; Tue, 21 Aug 2012 13:07:03 -0700 (PDT)
References: <20120820205355.7ccc0450@emcraft.com> <20120821114343.GB2380@redhat.com> <CAOZOX0V5ehfSZKQ=tPpowH35ct230nBXk6wSBiTcb10UUbieCA@mail.gmail.com> <20120821141842.GF2380@redhat.com>
In-Reply-To: <20120821141842.GF2380@redhat.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <A1D107E0-1E78-4123-88C1-9550064DC9AC@gmail.com> (sfid-20120821_220710_115173_CE8562DD)
Cc: Ivo Van Doorn <ivdoorn@gmail.com>,
	Sergei Poselenov <sposelenov@emcraft.com>,
	"users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
From: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [rt2x00-users] [PATCH] compat-wireless:rt2800usb: Added rx packet length validity check
Date: Tue, 21 Aug 2012 22:07:03 +0200
To: Stanislaw Gruszka <sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 21 aug. 2012, at 16:18, Stanislaw Gruszka <sgruszka@redhat.com> wrote:

> On Tue, Aug 21, 2012 at 03:39:41PM +0200, Ivo Van Doorn wrote:
>> On Tue, Aug 21, 2012 at 1:43 PM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
>>> On Mon, Aug 20, 2012 at 08:53:55PM +0400, Sergei Poselenov wrote:
>>>> On our system (ARM Cortex-M3 SOC running linux-2.6.33 with
>>>> compat-wireless-3.4-rc3-1 modules configured for rt2x00) frequent
>>> Please remove compat-wireless reference here and in the subject.
>>> 
>>>> crashes were observed in rt2800usb module because of the invalid
>>>> length of the received packet (3392, 46920...). This patch adds
>>>> the sanity check on the packet legth. In case of the bad length,
>>>> mark the packet as with CRC error.
>>>> 
>>>> The fix was also tested on the latest
>>>> compat-wireless-3.5.1-1-snpc.tar.bz2, applies cleanly.
>>>> 
>>>> Cc: stable@vger.kernel.org
>>>> Signed-off-by: Sergei Poselenov <sposelenov@emcraft.com>
>>>> ---
>>>> drivers/net/wireless/rt2x00/rt2800usb.c |   10 ++++++++--
>>>> 1 files changed, 8 insertions(+), 2 deletions(-)
>>>> 
>>>> diff --git a/usbwifi/compat-wireless-3.4-rc3-1/drivers/net/wireless/rt2x00/rt2800usb.c b/usbwifi/compat-wireless-3.4-rc3-1/drivers/net/wireless/rt2x00/rt2800usb.c
>>>> index 001735f..6776ec8 100644
>>>> --- a/usbwifi/compat-wireless-3.4-rc3-1/drivers/net/wireless/rt2x00/rt2800usb.c
>>>> +++ b/usbwifi/compat-wireless-3.4-rc3-1/drivers/net/wireless/rt2x00/rt2800usb.c
>>>> @@ -662,13 +662,18 @@ static void rt2800usb_fill_rxdone(struct queue_entry *entry,
>>>>      rx_pkt_len = rt2x00_get_field32(word, RXINFO_W0_USB_DMA_RX_PKT_LEN);
>>>> 
>>>>      /*
>>>> -      * Remove the RXINFO structure from the sbk.
>>>> +      * Remove the RXINFO structure from the skb.
>>>>       */
>>>>      skb_pull(entry->skb, RXINFO_DESC_SIZE);
>>> Would be great if you could post this as separate patch.
>>> 
>>>>      /*
>>>> -      * FIXME: we need to check for rx_pkt_len validity
>>>> +      * Check for rx_pkt_len validity, mark as failed.
>>>>       */
>>>> +     if (rx_pkt_len > entry->skb->len) {
>>>> +             rxdesc->flags |= RX_FLAG_FAILED_FCS_CRC;
>>>> +             goto procrxwi;
>>> 
>>> I would rather prefer something like
>>> 
>>> if (unlikely(rx_pkt_len == 0 || rx_pkt_len > entry->queue->data_size)) {
>>>        /* Process error in rt2x00lib_rxdone() */
>>>        rxdesc->size = rx_pkt_len;
>>>        return;
>>> }
>> 
>> But how do you know the packet is correct then?
> Non zero rx_pkt_len smaller than data_size indicate correct package.

To be honest, I think the original approach of Sergei is better. Not touching rxdesc beyond setting the flag will ensure that rt2x00lib_rxdone will simply bounce the skb without handing an invalid packet over to mac80211. That said, it isn't necessary to set the flag. Just returning from the function is good enough.

However, the check that Sergei does is not correct either. The real check that should be done is checking whether the skb has enough data to hold both rx_pkt_len bytes + the size of the rxd, which is 1 word (4 bytes). If only rx_pkt_len are left we don't have an rxd, and is the usb packet invalid as well.

> 
>> Obviously something is wrong,
>> so just resetting the rxdesc->size wouldn't be a solution right?
> 
> rt2x00lib_rxdone has rxdesc->size check too, if ->size is bad it 
> prints warning, and requeue skb. 
> 
> Perhaps this could be coded in some cleaner way (avoid double check),
> but basically this should do the job. 

As I mentioned above, simply bailing out if rt2800usb_fill_rxdone without doing anything (not even setting a flag) should do the trick and IMHO is the cleanest approach.

---
Gertjan