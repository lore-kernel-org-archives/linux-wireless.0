Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34906 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752561Ab0EARs2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 May 2010 13:48:28 -0400
Received: by fxm10 with SMTP id 10so1067730fxm.19
        for <linux-wireless@vger.kernel.org>; Sat, 01 May 2010 10:48:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4BDC6803.9030805@lwfinger.net>
References: <4BDC56D2.5060605@gmail.com> <201005011907.05603.mb@bu3sch.de>
	<AANLkTimXBlIETHVLapuSrkI8uTIU8JPepLWvAEq6_D4T@mail.gmail.com>
	<201005011919.42294.mb@bu3sch.de> <4BDC6803.9030805@lwfinger.net>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Sat, 1 May 2010 19:48:06 +0200
Message-ID: <AANLkTimQyOq6uw9en0pBaBYfjEKjmKBvS3wkR-i8H_ak@mail.gmail.com>
Subject: Re: [PATCH] ssb: Implement fast powerup delay calculation
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Michael Buesch <mb@bu3sch.de>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	b43-dev <b43-dev@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, May 1, 2010 at 7:42 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> On 05/01/2010 12:19 PM, Michael Buesch wrote:
>> On Saturday 01 May 2010 19:13:31 Gábor Stefanik wrote:
>>> 2010/5/1 Michael Buesch <mb@bu3sch.de>:
>>>> On Saturday 01 May 2010 18:29:06 Gábor Stefanik wrote:
>>>>> +     ssb_write16(cc->dev, SSB_MMIO_POWERUP_DELAY, delay);
>>>>>   }
>>>>>
>>>>>   void ssb_chipco_suspend(struct ssb_chipcommon *cc)
>>>>> Index: wireless-testing/include/linux/ssb/ssb_regs.h
>>>>> ===================================================================
>>>>> --- wireless-testing.orig/include/linux/ssb/ssb_regs.h
>>>>> +++ wireless-testing/include/linux/ssb/ssb_regs.h
>>>>> @@ -26,6 +26,7 @@
>>>>>   #define     SSB_EUART               (SSB_EXTIF_BASE + 0x00800000)
>>>>>   #define     SSB_LED                 (SSB_EXTIF_BASE + 0x00900000)
>>>>>
>>>>> +#define SSB_MMIO_POWERUP_DELAY       0x06A8
>>>>
>>>> I think you are really confusing something here.
>>>> That register is a wireless core register and we already write it in b43.
>>>>
>>>> --
>>>> Greetings, Michael.
>>>>
>>>
>>> This is what I am implementing: http://bcm-v4.sipsolutions.net/802.11/Init
>>> Here, it clearly says MMIO offset.
>>
>> Yeah. Just what I said. It is an 802.11 core register.
>> We already write it in b43/main.c/b43_chip_init().
>> It is _wrong_ to write to the chipcommon at that offset.
>
> I may have gotten the MMIO offset part wrong in the specs, but the
> Broadcom driver definitely writes to offset 0x648 at that point.
>
> I know that b43 writes that location; however, it is much later in the
> startup sequence. Whether that is important is unknown at this point.
>
> The previous code resulted in a value of zero being written to the
> location in question, but the value for the 4315 is 7000.
>
> Larry
>

According to http://bcm-v4.sipsolutions.net/802.11/Init, b43 is right
- the write should go to the 802.11 core, not ChipCommon.

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
