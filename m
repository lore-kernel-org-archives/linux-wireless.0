Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:52385 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752227Ab1DTOoT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Apr 2011 10:44:19 -0400
Received: by pvg12 with SMTP id 12so406999pvg.19
        for <linux-wireless@vger.kernel.org>; Wed, 20 Apr 2011 07:44:19 -0700 (PDT)
Message-ID: <4DAEF13E.7000502@lwfinger.net>
Date: Wed, 20 Apr 2011 09:44:14 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	=?UTF-8?B?TWljaGFlbCBCw7xzY2g=?= <mb@bu3sch.de>,
	b43-dev@lists.infradead.org
Subject: Re: [RFC][PATCH] ssb: cc: add & fix defines
References: <1303262232-2605-1-git-send-email-zajec5@gmail.com>	<4DAE3B17.4080308@lwfinger.net> <BANLkTikssXGwo7e1aqz-Qb8D08mv9g_MNA@mail.gmail.com>
In-Reply-To: <BANLkTikssXGwo7e1aqz-Qb8D08mv9g_MNA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/20/2011 03:15 AM, Rafał Miłecki wrote:
> 2011/4/20 Larry Finger<Larry.Finger@lwfinger.net>:
>> On 04/19/2011 08:17 PM, Rafał Miłecki wrote:
>>>
>>> Signed-off-by: Rafał Miłecki<zajec5@gmail.com>
>>> ---
>>> With updated defines following MMIO with defines makes sense:
>>>   read32 0xf04001e0 ->    0x00010000
>>> write32 0xf04001e0<- 0x00010002 |= SSB_CHIPCO_CLKCTLST_FORCEHT
>>>   read32 0xf04001e0 ->    0x00010002
>>> (...)
>>>   read32 0xf04001e0 ->    0x00010002
>>>   read32 0xf04001e0 ->    0x00010002
>>>   read32 0xf04001e0 ->    0x00030002      (&    SSB_CHIPCO_CLKCTLST_HAVEHT)
>>>
>>> Of course MMIO does not come from 4328. It is from 4312 and wl (just SSB
>>> defs).
>>>
>>> The tricky part is that we were using SSB_CHIPCO_CLKCTLST_HAVEHT in PMU
>>> driver.
>>>
>>> My guess is that we were always checking for the wrong register and we got
>>> false positives on test for turning PLL down.
>>> ---
>>>   include/linux/ssb/ssb_driver_chipcommon.h |    9 +++++++--
>>>   1 files changed, 7 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/include/linux/ssb/ssb_driver_chipcommon.h
>>> b/include/linux/ssb/ssb_driver_chipcommon.h
>>> index ba83bc5..45e7b6c 100644
>>> --- a/include/linux/ssb/ssb_driver_chipcommon.h
>>> +++ b/include/linux/ssb/ssb_driver_chipcommon.h
>>> @@ -133,6 +133,9 @@
>>>   #define SSB_CHIPCO_GPIOIRQ            0x0074
>>>   #define SSB_CHIPCO_WATCHDOG           0x0080
>>>   #define SSB_CHIPCO_GPIOTIMER          0x0088          /* LED powersave
>>> (corerev>= 16) */
>>> +#define  SSB_CHIPCO_GPIOTIMER_OFFTIME  0x0000FFFF
>>> +#define  SSB_CHIPCO_GPIOTIMER_OFFTIME_SHIFT    0
>>> +#define  SSB_CHIPCO_GPIOTIMER_ONTIME   0xFFFF0000
>>>   #define  SSB_CHIPCO_GPIOTIMER_ONTIME_SHIFT    16
>>>   #define SSB_CHIPCO_GPIOTOUTM          0x008C          /* LED powersave
>>> (corerev>= 16) */
>>>   #define SSB_CHIPCO_CLOCK_N            0x0090
>>> @@ -191,8 +194,10 @@
>>>   #define  SSB_CHIPCO_CLKCTLST_HAVEALPREQ       0x00000008 /* ALP available
>>> request */
>>>   #define  SSB_CHIPCO_CLKCTLST_HAVEHTREQ        0x00000010 /* HT available
>>> request */
>>>   #define  SSB_CHIPCO_CLKCTLST_HWCROFF  0x00000020 /* Force HW clock
>>> request off */
>>> -#define  SSB_CHIPCO_CLKCTLST_HAVEHT    0x00010000 /* HT available */
>>> -#define  SSB_CHIPCO_CLKCTLST_HAVEALP   0x00020000 /* APL available */
>>> +#define  SSB_CHIPCO_CLKCTLST_HAVEHT    0x00010000 /* ALP available */
>>> +#define  SSB_CHIPCO_CLKCTLST_HAVEALP   0x00020000 /* HT available */
>>> +#define  SSB_CHIPCO_CLKCTLST_4328A0_HAVEHT     0x00010000 /* 4328a0 has
>>> reversed bits */
>>> +#define  SSB_CHIPCO_CLKCTLST_4328A0_HAVEALP    0x00020000 /* 4328a0 has
>>> reversed bits */
>>>   #define SSB_CHIPCO_HW_WORKAROUND      0x01E4 /* Hardware workaround
>>> (rev>= 20) */
>>>   #define SSB_CHIPCO_UART0_DATA         0x0300
>>>   #define SSB_CHIPCO_UART0_IMR          0x0304
>>
>> I agree that the HAVEHT bit is different for the 4328 than for the rest of
>> the versions, but I think you did not get the rest quite right. Having the
>> HT bit attached to a symbol named ALP and vice versa will only create
>> confusion. Make SSB_CHIPCO_CLKCTLST_HAVEHT be 0x00020000 and
>> SSB_CHIPCO_CLKCTLST_HAVEALP be 0x000100000.
>
> It was bad idea to send patch so late. Did I really update comments
> hoping it will work? :|

I thought you were using the experimental, virtual compiler that produces code 
based on intent as written in the comments. :)

Larry
