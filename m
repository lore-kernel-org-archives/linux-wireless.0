Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:50498 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752796Ab0ABQs6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Jan 2010 11:48:58 -0500
Received: by ewy19 with SMTP id 19so5982403ewy.21
        for <linux-wireless@vger.kernel.org>; Sat, 02 Jan 2010 08:48:56 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <69e28c911001020843n42e588beraa99ea18474b1e0@mail.gmail.com>
References: <op.u5wyi5dd9lhzdc@linux-g0th.site>
	 <69e28c911001020826q575f65fbp6b48232e83392dcb@mail.gmail.com>
	 <b170af451001020840i4bb5e752gcf960e632ae3e7c0@mail.gmail.com>
	 <69e28c911001020843n42e588beraa99ea18474b1e0@mail.gmail.com>
Date: Sat, 2 Jan 2010 17:48:56 +0100
Message-ID: <b170af451001020848u16c7e5f9pe580f8b01a54416@mail.gmail.com>
Subject: Re: [PATCH] b43: Add new SSB's core id for BCM4328
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: =?UTF-8?Q?G=C3=A1bor_Stefanik?= <netrolller.3d@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 2 stycznia 2010 17:43 użytkownik Gábor Stefanik
<netrolller.3d@gmail.com> napisał:
> 2010/1/2 Rafał Miłecki <zajec5@gmail.com>:
>> W dniu 2 stycznia 2010 17:26 użytkownik Gábor Stefanik
>> <netrolller.3d@gmail.com> napisał:
>>> 2010/1/2 Rafał Miłecki <zajec5@gmail.com>:
>>>> Finally I've possibility to test my Christmas-gift N-PHY :) b43 didn't
>>>> really "notice" it, so I needed to write this little patch. Now b43 at least
>>>> look for firmware for my card.
>>>>
>>>> Does this patch look OK?
>>>>
>>>> This time I post from Opera mail so I hope white-spaces will be fine.
>>>>
>>>> From 9b3ea4f29b038f732aba737323e2f89b275ce1ab Mon Sep 17 00:00:00 2001
>>>> From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
>>>> Date: Sat, 2 Jan 2010 16:58:16 +0100
>>>> Subject: [PATCH] b43: Add new SSB's core id for BCM4328
>>>> MIME-Version: 1.0
>>>> Content-Type: text/plain; charset=UTF-8
>>>> Content-Transfer-Encoding: 8bit
>>>>
>>>> Following line shows my BCM4328 detected on SSB. We didn't include 0x0C rev.
>>>> ssb: Core 1 found: IEEE 802.11 (cc 0x812, rev 0x0C, vendor 0x4243)
>>>>
>>>> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
>>>> ---
>>>>  drivers/net/wireless/b43/main.c |    1 +
>>>>  1 files changed, 1 insertions(+), 0 deletions(-)
>>>>
>>>> diff --git a/drivers/net/wireless/b43/main.c
>>>> b/drivers/net/wireless/b43/main.c
>>>> index 098dda1..3aa45b8 100644
>>>> --- a/drivers/net/wireless/b43/main.c
>>>> +++ b/drivers/net/wireless/b43/main.c
>>>> @@ -110,6 +110,7 @@ static const struct ssb_device_id b43_ssb_tbl[] = {
>>>>        SSB_DEVICE(SSB_VENDOR_BROADCOM, SSB_DEV_80211, 9),
>>>>        SSB_DEVICE(SSB_VENDOR_BROADCOM, SSB_DEV_80211, 10),
>>>>        SSB_DEVICE(SSB_VENDOR_BROADCOM, SSB_DEV_80211, 11),
>>>> +       SSB_DEVICE(SSB_VENDOR_BROADCOM, SSB_DEV_80211, 12),
>>>
>>> Rev.14 is also missing (which AFAIK is used by some LP cards).
>>
>> Thanks, I'll post patch for that as well. Is adding this 0x0C (==13)
>> fine in this form? Or maybe we should use ifdef CONFIG_B43_NPHY for
>> some reason?
>
> I would say it's OK this way (BTW 0x0C == 12); we also didn't put
> rev.15 under CONFIG_B43_PHY_LP.

OK, thanks. And of course I've meant 0x0C == 12 :) After applying this
patch b43 won't try to init N-PHY device until CONFIG_B43_NPHY is set.
So I believe this patch is fine, thanks for sharing opinion :)


> (BTW I'm planning to rename CONFIG_B43_NPHY to CONFIG_B43_PHY_N in
> preparation for further PHY types, as well as the ability to only
> build certain PHYs as needed if EMBEDDED is set - a kernel for an
> LP-PHY SoC might save some space by not building G-PHY code.)

Heh, I was planning to do that :) OK, I'll focus on other stuff,
waiting for your patch :)

-- 
Rafał
