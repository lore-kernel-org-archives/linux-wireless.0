Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:54492 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933072AbcJLMxp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Oct 2016 08:53:45 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Mathias Kresin <dev@kresin.me>
Cc: linux-wireless@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [v2] rt2x00: add support for mac addr from device tree
References: <1472195813-30471-1-git-send-email-dev@kresin.me>
        <20160927155057.A4182616F6@smtp.codeaurora.org>
        <CABwW5nn9gGpzBQq3ag1MhsA-bxGop93=C7mjZG9nmi26G4ar5A@mail.gmail.com>
        <87shskwaxh.fsf@kamboji.qca.qualcomm.com>
Date: Wed, 12 Oct 2016 15:53:37 +0300
In-Reply-To: <87shskwaxh.fsf@kamboji.qca.qualcomm.com> (Kalle Valo's message
        of "Wed, 28 Sep 2016 13:55:38 +0300")
Message-ID: <87mvi9g23y.fsf@kamboji.qca.qualcomm.com> (sfid-20161012_145403_812911_01949E50)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@codeaurora.org> writes:

>> I thought about _adding_ a devicetree binding document before sending
>> the patch. But in the end it would be an empty file, since I neither
>> add any bindings nor introduce a compatible string. I'm just add
>> support for the generic of_get_mac_address() devicetree property,
>> which is meant to be used via a devicetree pci childnode.
>>
>> I grepped though the 4.7 code and found a few driver using
>> of_get_mac_address() without having a devicetree binding document:
>>
>> - drivers/net/usb/smsc95xx.c
>> - drivers/net/usb/smsc75xx.c
>> - drivers/net/ethernet/marvell/sky2.c
>> - drivers/net/ethernet/cavium/thunder/thunder_bgx.c
>> - drivers/net/ethernet/wiznet/w5100-spi.c
>> - drivers/net/ethernet/arc/emac_main.c
>>
>> Just let me know if you are still the opinion that a devicetree
>> binding document is required to get this patch accepted.
>
> I'm not familiar enough device tree to really comment. Can someone from
> the device tree list (CCed) help?
>
> Full patch here:
>
> https://patchwork.kernel.org/patch/9300893/

I didn't get any comments so I guess we don't need to document the use
of mac-address in the driver binding document. At least
Documentation/devicetree/bindings/net/ethernet.txt supports that, even
if rt2x00 is a wireless driver.

Unless I get any objections I'm planning to apply this to
wireless-drivers-next (once it's open again).

-- 
Kalle Valo
