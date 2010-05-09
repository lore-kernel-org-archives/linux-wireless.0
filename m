Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:56233 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751828Ab0EIJmU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 May 2010 05:42:20 -0400
Received: by bwz19 with SMTP id 19so1248091bwz.21
        for <linux-wireless@vger.kernel.org>; Sun, 09 May 2010 02:42:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4BE6832C.1020408@gmail.com>
References: <1273354826-4335-1-git-send-email-gwingerde@gmail.com>
	 <1273354826-4335-10-git-send-email-gwingerde@gmail.com>
	 <AANLkTilX7auYKpqXFyVs-1EJ8X5wL5PebnDSXtOW1Swk@mail.gmail.com>
	 <4BE6832C.1020408@gmail.com>
Date: Sun, 9 May 2010 11:42:18 +0200
Message-ID: <AANLkTikMQR4C54MzOMgpL-k2reaPb-kU2bL_Tph91IQs@mail.gmail.com>
Subject: Re: [PATCH 9/9] rt2x00: Fix beaconing on rt2800.
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, May 9, 2010 at 11:41 AM, Gertjan van Wingerde
<gwingerde@gmail.com> wrote:
> On 05/09/10 11:21, Ivo Van Doorn wrote:
>> On Sat, May 8, 2010 at 11:40 PM, Gertjan van Wingerde
>> <gwingerde@gmail.com> wrote:
>>> According to the Ralink vendor driver for rt2800 we don't need a full
>>> TXD for a beacon but just a TXWI in front of the actual beacon.
>>> Fix the rt2800pci and rt2800usb beaconing code accordingly.
>>>
>>> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
>>> ---
>>>  drivers/net/wireless/rt2x00/rt2800pci.c |   17 +++++++++--------
>>>  drivers/net/wireless/rt2x00/rt2800usb.c |   14 ++++++--------
>>>  2 files changed, 15 insertions(+), 16 deletions(-)
>>>
>>> diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
>>> index 80c6768..7d4778d 100644
>>> --- a/drivers/net/wireless/rt2x00/rt2800pci.c
>>> +++ b/drivers/net/wireless/rt2x00/rt2800pci.c
>>> @@ -682,7 +682,6 @@ static void rt2800pci_write_beacon(struct queue_entry *entry,
>>>                                   struct txentry_desc *txdesc)
>>>  {
>>>        struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
>>> -       struct skb_frame_desc *skbdesc = get_skb_frame_desc(entry->skb);
>>>        unsigned int beacon_base;
>>>        u32 reg;
>>>
>>> @@ -695,15 +694,17 @@ static void rt2800pci_write_beacon(struct queue_entry *entry,
>>>        rt2800_register_write(rt2x00dev, BCN_TIME_CFG, reg);
>>>
>>>        /*
>>> -        * Write entire beacon with descriptor to register.
>>> +        * Add the TXWI for the beacon to the skb.
>>> +        */
>>> +       rt2800_write_txwi(entry->skb, txdesc);
>>> +       skb_push(entry->skb, TXWI_DESC_SIZE);
>>
>> This looks quite suspicious...
>> First writing into the SKB and only then making room for it?
>> Perhaps we should make sure rt2800_write_txwi demands the
>> room is already added (or it calls skb_push itself).
>>
>
> Yep, I wasn't too happy with this as well. It's on my TODO-list to fix that up, but that
> requires more restructuring of the common code.
> For the sake of keeping this patch small I kept it this way, and I'm already working on
> follow-up patches to clean the skb handling up, so that we don't have to fiddle around
> with the skb->data pointer anymore when creating descriptors and TXWI's.

Ok. In that case:

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
