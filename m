Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f228.google.com ([209.85.220.228]:55572 "EHLO
	mail-fx0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751656AbZHMSCY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2009 14:02:24 -0400
Received: by fxm28 with SMTP id 28so742033fxm.17
        for <linux-wireless@vger.kernel.org>; Thu, 13 Aug 2009 11:02:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200908131923.29847.mb@bu3sch.de>
References: <4A842887.2080109@gmail.com> <200908131923.29847.mb@bu3sch.de>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Thu, 13 Aug 2009 20:02:04 +0200
Message-ID: <69e28c910908131102o29273371w4f86d685f6410bf7@mail.gmail.com>
Subject: Re: [PATCH v2] b43: Update dummy transmission to match V4 specs
To: Michael Buesch <mb@bu3sch.de>
Cc: John Linville <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/8/13 Michael Buesch <mb@bu3sch.de>:
> On Thursday 13 August 2009 16:51:51 Gábor Stefanik wrote:
>> The V4 dummy transmission has two extra bools in its prototype,
>> so update all callers with the 2 bools.
>>
>> Signed-off-by: Gábor Stefanik <netrolller.3d@gmail.com>
>> ---
>> v2: Convert all callers to v4, and drop the v3->v4 wrapper.
>
>> -     /* Commit writes */
>> -     b43_read32(dev, B43_MMIO_MACCTL);
>
>> -     value = ((phy->type == B43_PHYTYPE_A) ? 1 : 0);
>> +     if (dev->dev->id.revision < 11)
>> +             b43_write16(dev, 0x07C0, 0x0000);
>> +     else
>> +             b43_write16(dev, 0x07C0, 0x0100);
>> +     value = (ofdm ? 0x41 : 0x40);
>>       b43_write16(dev, 0x050C, value);
>
> This patch changes G-PHY codepaths. Did you test it on (at least one) G-PHY device?

Not yet - if you could test it, I would be grateful.

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
