Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.156]:8403 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182Ab0EARNy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 May 2010 13:13:54 -0400
Received: by fg-out-1718.google.com with SMTP id 19so320931fgg.1
        for <linux-wireless@vger.kernel.org>; Sat, 01 May 2010 10:13:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201005011907.05603.mb@bu3sch.de>
References: <4BDC56D2.5060605@gmail.com> <201005011907.05603.mb@bu3sch.de>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Sat, 1 May 2010 19:13:31 +0200
Message-ID: <AANLkTimXBlIETHVLapuSrkI8uTIU8JPepLWvAEq6_D4T@mail.gmail.com>
Subject: Re: [PATCH] ssb: Implement fast powerup delay calculation
To: Michael Buesch <mb@bu3sch.de>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	b43-dev <b43-dev@lists.infradead.org>,
	Larry Finger <larry.finger@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/5/1 Michael Buesch <mb@bu3sch.de>:
> On Saturday 01 May 2010 18:29:06 Gábor Stefanik wrote:
>> +     ssb_write16(cc->dev, SSB_MMIO_POWERUP_DELAY, delay);
>>   }
>>
>>   void ssb_chipco_suspend(struct ssb_chipcommon *cc)
>> Index: wireless-testing/include/linux/ssb/ssb_regs.h
>> ===================================================================
>> --- wireless-testing.orig/include/linux/ssb/ssb_regs.h
>> +++ wireless-testing/include/linux/ssb/ssb_regs.h
>> @@ -26,6 +26,7 @@
>>   #define     SSB_EUART               (SSB_EXTIF_BASE + 0x00800000)
>>   #define     SSB_LED                 (SSB_EXTIF_BASE + 0x00900000)
>>
>> +#define SSB_MMIO_POWERUP_DELAY       0x06A8
>
> I think you are really confusing something here.
> That register is a wireless core register and we already write it in b43.
>
> --
> Greetings, Michael.
>

This is what I am implementing: http://bcm-v4.sipsolutions.net/802.11/Init
Here, it clearly says MMIO offset.

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
