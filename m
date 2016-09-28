Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:45488 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752590AbcI1Kzn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Sep 2016 06:55:43 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Mathias Kresin <dev@kresin.me>
Cc: linux-wireless@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [v2] rt2x00: add support for mac addr from device tree
References: <1472195813-30471-1-git-send-email-dev@kresin.me>
        <20160927155057.A4182616F6@smtp.codeaurora.org>
        <CABwW5nn9gGpzBQq3ag1MhsA-bxGop93=C7mjZG9nmi26G4ar5A@mail.gmail.com>
Date: Wed, 28 Sep 2016 13:55:38 +0300
In-Reply-To: <CABwW5nn9gGpzBQq3ag1MhsA-bxGop93=C7mjZG9nmi26G4ar5A@mail.gmail.com>
        (Mathias Kresin's message of "Wed, 28 Sep 2016 12:36:46 +0200")
Message-ID: <87shskwaxh.fsf@kamboji.qca.qualcomm.com> (sfid-20160928_125547_945704_98F9C83A)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mathias Kresin <dev@kresin.me> writes:

> 2016-09-27 17:50 GMT+02:00 Kalle Valo <kvalo@codeaurora.org>:
>> Mathias Kresin <dev@kresin.me> wrote:
>>> On some devices the EEPROMs of Ralink Wi-Fi chips have a default Ralink
>>> MAC address set (RT3062F: 00:0C:43:30:62:00, RT3060F:
>>> 00:0C:43:30:60:00). Using multiple of these devices in the same network
>>> can cause nasty issues.
>>>
>>> Allow to override the MAC in the EEPROM with (a known good) one set in
>>> the device tree to bypass the issue.
>>>
>>> Signed-off-by: Mathias Kresin <dev@kresin.me>
>>> Acked-by: Stanislaw Gruszka <sgruszka@redhat.com>
>>
>> I think this needs to update the devicetree binding document. Also
>> remember to CC the devicetree mailing list.
>>
>> Patch set to Changes Requested.
>>
>> --
>> https://patchwork.kernel.org/patch/9300893/
>
> Hey Kalle,
>
> was it intentional not to CC the linux-wireless list?

No, that was a bug in my script. Thanks for noticing it! Please always
report back if my script does something strange.

I'm adding now linux-wireless back.

> I thought about _adding_ a devicetree binding document before sending
> the patch. But in the end it would be an empty file, since I neither
> add any bindings nor introduce a compatible string. I'm just add
> support for the generic of_get_mac_address() devicetree property,
> which is meant to be used via a devicetree pci childnode.
>
> I grepped though the 4.7 code and found a few driver using
> of_get_mac_address() without having a devicetree binding document:
>
> - drivers/net/usb/smsc95xx.c
> - drivers/net/usb/smsc75xx.c
> - drivers/net/ethernet/marvell/sky2.c
> - drivers/net/ethernet/cavium/thunder/thunder_bgx.c
> - drivers/net/ethernet/wiznet/w5100-spi.c
> - drivers/net/ethernet/arc/emac_main.c
>
> Just let me know if you are still the opinion that a devicetree
> binding document is required to get this patch accepted.

I'm not familiar enough device tree to really comment. Can someone from
the device tree list (CCed) help?

Full patch here:

https://patchwork.kernel.org/patch/9300893/


-- 
Kalle Valo
