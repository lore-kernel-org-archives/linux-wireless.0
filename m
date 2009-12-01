Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 30.mail-out.ovh.net ([213.186.62.213]:44280 "HELO
	30.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753402AbZLAUda (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Dec 2009 15:33:30 -0500
Message-ID: <4B157D9B.5000508@free.fr>
Date: Tue, 01 Dec 2009 21:33:31 +0100
From: Benoit PAPILLAULT <benoit.papillault@free.fr>
MIME-Version: 1.0
To: Luis Correia <buga@loide.net>
CC: rt2x00 Users List <users@rt2x00.serialmonkey.com>,
	Luis Correia <luis.f.correia@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [rt2x00-users] [PATCH 1/2] rt2x00: Disable RX aggregation for
 	rt2800usb
References: <1259619690-2749-1-git-send-email-benoit.papillault@free.fr>	 <200912012017.11986.IvDoorn@gmail.com> <880c1630912011159m604ee187xa496c00a800f1100@mail.gmail.com>
In-Reply-To: <880c1630912011159m604ee187xa496c00a800f1100@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis Correia a écrit :
> On Tue, Dec 1, 2009 at 19:17, Ivo van Doorn <ivdoorn@gmail.com> wrote:
>> On Monday 30 November 2009, Benoit Papillault wrote:
>>> From: Benoit PAPILLAULT <benoit.papillault@free.fr>
>>>
>>> RX aggregation is a way to receive multiple 802.11 frames in one RX buffer.
>>> However, we don't know yet how to handle this case in rt2800usb_fill_rxdone
>>> and this has probably no impact on RX performance as well, so we disable it
>>>
>>> Signed-off-by: Benoit Papillault <benoit.papillault@free.fr>
>>> ---
>>>  drivers/net/wireless/rt2x00/rt2800usb.c |    4 +---
>>>  1 files changed, 1 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
>>> index af85d18..ed31763 100644
>>> --- a/drivers/net/wireless/rt2x00/rt2800usb.c
>>> +++ b/drivers/net/wireless/rt2x00/rt2800usb.c
>>> @@ -295,9 +295,7 @@ static int rt2800usb_enable_radio(struct rt2x00_dev *rt2x00dev)
>>>
>>>       rt2800_register_read(rt2x00dev, USB_DMA_CFG, &reg);
>>>       rt2x00_set_field32(&reg, USB_DMA_CFG_PHY_CLEAR, 0);
>>> -     /* Don't use bulk in aggregation when working with USB 1.1 */
>>> -     rt2x00_set_field32(&reg, USB_DMA_CFG_RX_BULK_AGG_EN,
>>> -                        (rt2x00dev->rx->usb_maxpacket == 512));
>>> +     rt2x00_set_field32(&reg, USB_DMA_CFG_RX_BULK_AGG_EN, 0);
>>>       rt2x00_set_field32(&reg, USB_DMA_CFG_RX_BULK_AGG_TIMEOUT, 128);
>>>       /*
>>>        * Total room for RX frames in kilobytes, PBF might still exceed
>>
>> Are you sure this works? I think Luis tried this 2 weeks ago and it didn't
>> disable the aggregation... (Luis, please confirm that this was indeed the change you made...)
> 
> Yes, it was one of the changes I made.
> 
> However, I wouldn't say that it didn't disable aggregation, it just
> didn't fix the problem I was pursuing (receiving 11n beacon frames).
> 
> So I guess that for now, we could just go with it disabled and try
> later on to enable it when the driver is more useable.
> 
> Luis Correia
> 

Without this patch, the driver is receiving several 802.11 frames inside
the same buffer and only one is sent to mac80211, so this patch is a
quick fix for that issue.

Regards,
Benoit

