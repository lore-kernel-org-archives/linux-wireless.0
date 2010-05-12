Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:4622 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755032Ab0ELSnG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 May 2010 14:43:06 -0400
Message-ID: <4BEAF6B1.3000200@gmail.com>
Date: Wed, 12 May 2010 20:42:57 +0200
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: Ivo Van Doorn <ivdoorn@gmail.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [PATCH 2/9] rt2x00: Fix beacon descriptor writing for rt61pci.
References: <1273614705-25118-1-git-send-email-gwingerde@gmail.com>	 <1273614705-25118-3-git-send-email-gwingerde@gmail.com>	 <AANLkTikOV973PKZYkNyUoaFOXhSPOumhmHwQ7Ei8tvgv@mail.gmail.com>	 <AANLkTilDv-tY_UIbc_lh8EaNdV7MRNAbDA4Oe5nFiDNh@mail.gmail.com> <AANLkTimubF1UWmzLwhJ7vhquBHmRywJQTvJciU3D3SNx@mail.gmail.com>
In-Reply-To: <AANLkTimubF1UWmzLwhJ7vhquBHmRywJQTvJciU3D3SNx@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/12/10 19:43, Ivo Van Doorn wrote:
> On Wed, May 12, 2010 at 11:46 AM, Gertjan van Wingerde
> <gwingerde@gmail.com> wrote:
>> On Wed, May 12, 2010 at 8:59 AM, Ivo Van Doorn <ivdoorn@gmail.com> wrote:
>>> On Tue, May 11, 2010 at 11:51 PM, Gertjan van Wingerde
>>> <gwingerde@gmail.com> wrote:
>>>> The buffer address descriptor word is not part of the TXINFO structure
>>>> needed for beacons. The current writing of that word for beacons is
>>>> therefore an out-of-bounds write.
>>>> Fix this by only writing the buffer address descriptor word for TX
>>>> queues.
>>>>
>>>> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
>>>> ---
>>>>  drivers/net/wireless/rt2x00/rt61pci.c |   10 +++++-----
>>>>  1 files changed, 5 insertions(+), 5 deletions(-)
>>>>
>>>> diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
>>>> index 2436363..99c2981 100644
>>>> --- a/drivers/net/wireless/rt2x00/rt61pci.c
>>>> +++ b/drivers/net/wireless/rt2x00/rt61pci.c
>>>> @@ -1801,12 +1801,12 @@ static void rt61pci_write_tx_desc(struct rt2x00_dev *rt2x00dev,
>>>>        rt2x00_set_field32(&word, TXD_W5_WAITING_DMA_DONE_INT, 1);
>>>>        rt2x00_desc_write(txd, 5, word);
>>>>
>>>> -       rt2x00_desc_read(txd, 6, &word);
>>>> -       rt2x00_set_field32(&word, TXD_W6_BUFFER_PHYSICAL_ADDRESS,
>>>> -                          skbdesc->skb_dma);
>>>> -       rt2x00_desc_write(txd, 6, word);
>>>> +       if (txdesc->queue != QID_BEACON) {
>>>> +               rt2x00_desc_read(txd, 6, &word);
>>>> +               rt2x00_set_field32(&word, TXD_W6_BUFFER_PHYSICAL_ADDRESS,
>>>> +                                  skbdesc->skb_dma);
>>>> +               rt2x00_desc_write(txd, 6, word);
>>>>
>>>> -       if (skbdesc->desc_len > TXINFO_SIZE) {
>>>>                rt2x00_desc_read(txd, 11, &word);
>>>>                rt2x00_set_field32(&word, TXD_W11_BUFFER_LENGTH0,
>>>>                                   txdesc->length);
>>>
>>> Shouldn't the check for TXINFO_SIZE be used rather than explicitly
>>> checking for the QID?
>>>
>>
>> I agree that this is a change that didn't have to be made in this patch.
>> However, after patch 4 of the series we cannot depend on the
>> skbdesc->desc_len being set anymore, and we would have to depend on
>> checking the QID anyway.
>> Note that in reality these two checks are completely equivalent with
>> respect to the result.
> 
> Hmm, is that a good idea? I mean we are using the skbdesc inside the
> function, but we can't be sure that one of the basic values contains the right
> value?
> 

To be honest, the chipset drivers don't need the skbdesc->desc and skbdesc->desc_len
at all. Based on the queue ID they already have everything they need to know to write
a descriptor. As far as I can tell the only code that really needs those two fields is
the rt2x00debug code, to dump a frame to userspace via debugfs.

As the dumping through debugfs is done after writing the TX descriptor, with this patch
I changed the desc and desc_len fields of the skbdesc to be output of the write_tx_desc
function (for the generic parts of the rt2x00 code) rather than being input.

Note that originally my plan was to get rid of the desc and desc_len field altogether,
but for now I refrained from doing that.

---
Gertjan.

