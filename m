Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews01.kpnxchange.com ([213.75.39.4]:4948 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756969Ab0ELTWm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 May 2010 15:22:42 -0400
Message-ID: <4BEB0000.7070600@gmail.com>
Date: Wed, 12 May 2010 21:22:40 +0200
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: Ivo Van Doorn <ivdoorn@gmail.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [PATCH 6/9] rt2x00: Push beacon TX descriptor writing to drivers.
References: <1273614705-25118-1-git-send-email-gwingerde@gmail.com>	 <1273614705-25118-7-git-send-email-gwingerde@gmail.com>	 <AANLkTilYgBGsowRMhANjzNzv7IngLb0NZQR5QqSMDYc5@mail.gmail.com>	 <AANLkTikc49OYX7l9H1fpU0RCDU9cHAe4XAIr-nq1nWmq@mail.gmail.com>	 <AANLkTil8eCI40L90Siwpqh6qAx27IYJjVL9dCNl7o5Jm@mail.gmail.com>	 <4BEAFB90.3090301@gmail.com> <AANLkTinx3zLY3pPSfk93oaHBp_IlWuFGRJJoFiMIirws@mail.gmail.com>
In-Reply-To: <AANLkTinx3zLY3pPSfk93oaHBp_IlWuFGRJJoFiMIirws@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/12/10 21:10, Ivo Van Doorn wrote:
> On Wed, May 12, 2010 at 9:03 PM, Gertjan van Wingerde
> <gwingerde@gmail.com> wrote:
>> On 05/12/10 19:45, Ivo Van Doorn wrote:
>>> On Wed, May 12, 2010 at 11:53 AM, Gertjan van Wingerde
>>> <gwingerde@gmail.com> wrote:
>>>> On Wed, May 12, 2010 at 9:06 AM, Ivo Van Doorn <ivdoorn@gmail.com> wrote:
>>>>> On Tue, May 11, 2010 at 11:51 PM, Gertjan van Wingerde
>>>>> <gwingerde@gmail.com> wrote:
>>>>>> Not all the devices require a TX descriptor to be written (i.e. rt2800
>>>>>> device don't require them). Push down the creation of the TX descriptor
>>>>>> to the device drivers so that they can decide for themselves whether
>>>>>> a TX descriptor is to be created.
>>>>>>
>>>>>> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
>>>>>> ---
>>>>>>  drivers/net/wireless/rt2x00/rt2400pci.c   |   16 ++++++++++------
>>>>>>  drivers/net/wireless/rt2x00/rt2500pci.c   |   16 ++++++++++------
>>>>>>  drivers/net/wireless/rt2x00/rt2500usb.c   |   11 +++++++++++
>>>>>>  drivers/net/wireless/rt2x00/rt2800pci.c   |   17 +++++++++++++++++
>>>>>>  drivers/net/wireless/rt2x00/rt2800usb.c   |   17 +++++++++++++++++
>>>>>>  drivers/net/wireless/rt2x00/rt2x00debug.c |    1 +
>>>>>>  drivers/net/wireless/rt2x00/rt2x00queue.c |   10 +---------
>>>>>>  drivers/net/wireless/rt2x00/rt61pci.c     |   11 +++++++++++
>>>>>>  drivers/net/wireless/rt2x00/rt73usb.c     |   11 +++++++++++
>>>>>>  9 files changed, 89 insertions(+), 21 deletions(-)
>>>>>>
>>>>>> diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
>>>>>> index def3fa4..741c531 100644
>>>>>> --- a/drivers/net/wireless/rt2x00/rt2400pci.c
>>>>>> +++ b/drivers/net/wireless/rt2x00/rt2400pci.c
>>>>>> @@ -33,6 +33,7 @@
>>>>>>  #include <linux/eeprom_93cx6.h>
>>>>>>
>>>>>>  #include "rt2x00.h"
>>>>>> +#include "rt2x00lib.h"
>>>>>>  #include "rt2x00pci.h"
>>>>>>  #include "rt2400pci.h"
>>>>>
>>>>> rt2x00lib.h must not be used in the drivers. It is for the rt2x00lib
>>>>> internal files only.
>>>>
>>>> OK. This include is/was necessary for the rt2x00debug_dump_frame call.
>>>> So this may be handled with your next issue.
>>>>
>>>>>
>>>>>> @@ -1074,9 +1075,6 @@ static void rt2400pci_write_beacon(struct queue_entry *entry,
>>>>>>                                   struct txentry_desc *txdesc)
>>>>>>  {
>>>>>>        struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
>>>>>> -       struct queue_entry_priv_pci *entry_priv = entry->priv_data;
>>>>>> -       struct skb_frame_desc *skbdesc = get_skb_frame_desc(entry->skb);
>>>>>> -       u32 word;
>>>>>>        u32 reg;
>>>>>>
>>>>>>        /*
>>>>>> @@ -1089,9 +1087,15 @@ static void rt2400pci_write_beacon(struct queue_entry *entry,
>>>>>>
>>>>>>        rt2x00queue_map_txskb(rt2x00dev, entry->skb);
>>>>>>
>>>>>> -       rt2x00_desc_read(entry_priv->desc, 1, &word);
>>>>>> -       rt2x00_set_field32(&word, TXD_W1_BUFFER_ADDRESS, skbdesc->skb_dma);
>>>>>> -       rt2x00_desc_write(entry_priv->desc, 1, word);
>>>>>> +       /*
>>>>>> +        * Write the TX descriptor for the beacon.
>>>>>> +        */
>>>>>> +       rt2400pci_write_tx_desc(rt2x00dev, entry->skb, txdesc);
>>>>>> +
>>>>>> +       /*
>>>>>> +        * Dump beacon to userspace through debugfs.
>>>>>> +        */
>>>>>> +       rt2x00debug_dump_frame(rt2x00dev, DUMP_FRAME_BEACON, entry->skb);
>>>>>
>>>>> The goal for rt2x00debug was that the logic must be inside rt2x00lib
>>>>> as much as possible.
>>>>> This can/should be moved into rt2x00lib where write_beacon() is being called.
>>>>>
>>>>
>>>> Yes, I wasn't too happy about this part about the patch, but couldn't
>>>> find a better solution. The problem is that with the patch the frame
>>>> cannot be dumped before the call to write_beacon, as the descriptor
>>>> hasn't been set up yet. Also, it cannot be dumped after the call to
>>>> write_beacon as most of the write_beacon functions actually free the
>>>> skb with the beacon.
>>>> So, I ran out of ideas as to how to keep rt2x00debug only inside
>>>> rt2x00lib. I'm open for suggestions, though.
>>>
>>> Well ok, if there aren't obvious alternatives this change is fine.
>>> However, please move the declaration of rt2x00debug_dump_frame()
>>> into rt2x00.h? That way we don't have to include the rt2x00lib.h header.
>>>
>>
>> The only alternative I can think of is to have the chipset driver clone the skb to have
>> a private copy of the skb, so that the original one can be freed in the generic code.
>> In that case the rt2x00debug_dump_frame call can be done from rt2x00queue code, after
>> the write_beacon function has been called.
>>
>> What do you think of that solution?
> 
> I think the extra cloning isn't really worth the effort. Since it is
> only needed for debugfs,
> so the code in rt2x00queue must check for debugfs support, and debugfs code must
> be updated not to clone the frame again.
> 
> Overall I think it is in this case better to just do your change with calling
> the debugfs function from the driver, but moving the declaration of the function
> into rt2x00.h to prevent the inclusion of rt2x00lib.h into the drivers.
> 

OK. I'll move the declaration to rt2x00.h.

---
Gertjan.
