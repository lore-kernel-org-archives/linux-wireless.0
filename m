Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:35570 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751955AbcKPIKz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 Nov 2016 03:10:55 -0500
Received: by mail-wm0-f68.google.com with SMTP id a20so8404675wme.2
        for <linux-wireless@vger.kernel.org>; Wed, 16 Nov 2016 00:10:54 -0800 (PST)
Subject: Re: [PATCH 04/10] rt2800: do not overwrite
 WPDMA_GLO_CFG_WP_DMA_BURST_SIZE
To: Stanislaw Gruszka <sgruszka@redhat.com>
References: <1478095865-8651-1-git-send-email-sgruszka@redhat.com>
 <1478095865-8651-5-git-send-email-sgruszka@redhat.com>
 <48e4790b-7cb3-170e-eda1-11bce9934141@kresin.me>
 <20161114084238.GA12372@redhat.com>
Cc: linux-wireless@vger.kernel.org,
        Helmut Schaa <helmut.schaa@googlemail.com>
From: Mathias Kresin <dev@kresin.me>
Message-ID: <eef27450-9dbb-9c24-35ab-d2b2cacdbdc3@kresin.me> (sfid-20161116_091059_725820_1979EA1F)
Date: Wed, 16 Nov 2016 09:10:52 +0100
MIME-Version: 1.0
In-Reply-To: <20161114084238.GA12372@redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

14.11.2016 09:42, Stanislaw Gruszka:
> On Sat, Nov 05, 2016 at 01:55:14PM +0100, Mathias Kresin wrote:
>> 02.11.2016 15:10, Stanislaw Gruszka:
>>> We already initlized WPDMA_GLO_CFG_WP_DMA_BURST_SIZE to 3 on
>>> rt2800_init_registers().
>>>
>>> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
>>> ---
>>> drivers/net/wireless/ralink/rt2x00/rt2800lib.c |    1 -
>>> 1 files changed, 0 insertions(+), 1 deletions(-)
>>>
>>> diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
>>> index feceb13..9ecdc4c 100644
>>> --- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
>>> +++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
>>> @@ -6756,7 +6756,6 @@ int rt2800_enable_radio(struct rt2x00_dev *rt2x00dev)
>>> 	rt2800_register_read(rt2x00dev, WPDMA_GLO_CFG, &reg);
>>> 	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_ENABLE_TX_DMA, 1);
>>> 	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_ENABLE_RX_DMA, 1);
>>> -	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_WP_DMA_BURST_SIZE, 2);
>>
>> More a notice than a potential issue since I don't have much
>> knowledge about the driver/chip internals.
>>
>> But WPDMA_GLO_CFG_WP_DMA_BURST_SIZE in rt2800_init_registers() is
>> set conditionally for rt2x00_is_usb(rt2x00dev), where this one is
>> set unconditionally. Not sure if this change has side effects.
>
> Default HW setting of WP_DMA_BURTS_SIZE is 2, hence patch does not
> change behaviour on PCI devices. However I looked at RT3290 and
> RT5592 PCI vendor drivers and there this value is initialized to 3.
> So I think we can remove is_usb condition in rt2800_init_registers().

Shouldn't one of the explanations (depending on where you decide to set 
WP_DMA_BURTS_SIZE) go into the commit message? As said in my last mail, 
without further explanation it looks like introducing a bug.

Mathias
