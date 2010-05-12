Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f46.google.com ([74.125.82.46]:46549 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753447Ab0ELJqD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 May 2010 05:46:03 -0400
Received: by wwi18 with SMTP id 18so646429wwi.19
        for <linux-wireless@vger.kernel.org>; Wed, 12 May 2010 02:46:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTikOV973PKZYkNyUoaFOXhSPOumhmHwQ7Ei8tvgv@mail.gmail.com>
References: <1273614705-25118-1-git-send-email-gwingerde@gmail.com>
	 <1273614705-25118-3-git-send-email-gwingerde@gmail.com>
	 <AANLkTikOV973PKZYkNyUoaFOXhSPOumhmHwQ7Ei8tvgv@mail.gmail.com>
Date: Wed, 12 May 2010 11:46:02 +0200
Message-ID: <AANLkTilDv-tY_UIbc_lh8EaNdV7MRNAbDA4Oe5nFiDNh@mail.gmail.com>
Subject: Re: [PATCH 2/9] rt2x00: Fix beacon descriptor writing for rt61pci.
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: Ivo Van Doorn <ivdoorn@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 12, 2010 at 8:59 AM, Ivo Van Doorn <ivdoorn@gmail.com> wrote:
> On Tue, May 11, 2010 at 11:51 PM, Gertjan van Wingerde
> <gwingerde@gmail.com> wrote:
>> The buffer address descriptor word is not part of the TXINFO structure
>> needed for beacons. The current writing of that word for beacons is
>> therefore an out-of-bounds write.
>> Fix this by only writing the buffer address descriptor word for TX
>> queues.
>>
>> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
>> ---
>>  drivers/net/wireless/rt2x00/rt61pci.c |   10 +++++-----
>>  1 files changed, 5 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
>> index 2436363..99c2981 100644
>> --- a/drivers/net/wireless/rt2x00/rt61pci.c
>> +++ b/drivers/net/wireless/rt2x00/rt61pci.c
>> @@ -1801,12 +1801,12 @@ static void rt61pci_write_tx_desc(struct rt2x00_dev *rt2x00dev,
>>        rt2x00_set_field32(&word, TXD_W5_WAITING_DMA_DONE_INT, 1);
>>        rt2x00_desc_write(txd, 5, word);
>>
>> -       rt2x00_desc_read(txd, 6, &word);
>> -       rt2x00_set_field32(&word, TXD_W6_BUFFER_PHYSICAL_ADDRESS,
>> -                          skbdesc->skb_dma);
>> -       rt2x00_desc_write(txd, 6, word);
>> +       if (txdesc->queue != QID_BEACON) {
>> +               rt2x00_desc_read(txd, 6, &word);
>> +               rt2x00_set_field32(&word, TXD_W6_BUFFER_PHYSICAL_ADDRESS,
>> +                                  skbdesc->skb_dma);
>> +               rt2x00_desc_write(txd, 6, word);
>>
>> -       if (skbdesc->desc_len > TXINFO_SIZE) {
>>                rt2x00_desc_read(txd, 11, &word);
>>                rt2x00_set_field32(&word, TXD_W11_BUFFER_LENGTH0,
>>                                   txdesc->length);
>
> Shouldn't the check for TXINFO_SIZE be used rather than explicitly
> checking for the QID?
>

I agree that this is a change that didn't have to be made in this patch.
However, after patch 4 of the series we cannot depend on the
skbdesc->desc_len being set anymore, and we would have to depend on
checking the QID anyway.
Note that in reality these two checks are completely equivalent with
respect to the result.

---
Gertjan.
