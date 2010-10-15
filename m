Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:58966 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756266Ab0JOO1V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Oct 2010 10:27:21 -0400
Received: by qwa26 with SMTP id 26so398886qwa.19
        for <linux-wireless@vger.kernel.org>; Fri, 15 Oct 2010 07:27:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTim==y20jOa6SpvZogZ+0inFGvmpnN-nTKFZp2Xz@mail.gmail.com>
References: <1287090064-14607-1-git-send-email-zajec5@gmail.com>
	<AANLkTimnzeRa53g0i2ZkB4Qy_x_P3h4Z+ZwC2HdJPxFC@mail.gmail.com>
	<AANLkTinnOm5rg8FKxFct1zKHZZi7k9nxEKtBYkLFktSS@mail.gmail.com>
	<AANLkTim==y20jOa6SpvZogZ+0inFGvmpnN-nTKFZp2Xz@mail.gmail.com>
Date: Fri, 15 Oct 2010 16:27:20 +0200
Message-ID: <AANLkTimvMCRVLzNjM+vsVEyHHAV0fLF4ABeV_20CdOCa@mail.gmail.com>
Subject: Re: [PATCH 1/3] b43: N-PHY: define channel table struct for rev3+ devices
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: =?UTF-8?Q?G=C3=A1bor_Stefanik?= <netrolller.3d@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 15 października 2010 16:13 użytkownik Gábor Stefanik
<netrolller.3d@gmail.com> napisał:
> 2010/10/15 Rafał Miłecki <zajec5@gmail.com>:
>> W dniu 15 października 2010 00:39 użytkownik Gábor Stefanik
>> <netrolller.3d@gmail.com> napisał:
>>> 2010/10/14 Rafał Miłecki <zajec5@gmail.com>:
>>>> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
>>>> ---
>>>>  drivers/net/wireless/b43/radio_2056.c |   51 +++++++++++++++++++++++++++++++++
>>>>  drivers/net/wireless/b43/radio_2056.h |   40 ++++++++++++++++++++++++--
>>>>  2 files changed, 88 insertions(+), 3 deletions(-)
>>>>
>>>> diff --git a/drivers/net/wireless/b43/radio_2056.c b/drivers/net/wireless/b43/radio_2056.c
>>>> index d856319..f710c01 100644
>>>> --- a/drivers/net/wireless/b43/radio_2056.c
>>>> +++ b/drivers/net/wireless/b43/radio_2056.c
>>>> @@ -24,9 +24,60 @@
>>>>  #include "radio_2056.h"
>>>>  #include "phy_common.h"
>>>>
>>>> +#define RADIOREGS3(r00, r01, r02, r03, r04, r05, r06, r07, r08, r09, \
>>>> +                  r10, r11, r12, r13, r14, r15, r16, r17, r18, r19, \
>>>> +                  r20, r21, r22, r23, r24, r25, r26, r27, r28, r29, \
>>>> +                  r30, r31, r32, r33, r34, r35, r36) \
>>>> +       .radio_syn_pll_vcocal1          = r00,  \
>>>> +       .radio_syn_pll_vcocal2          = r01,  \
>>>> +       .radio_syn_pll_refdiv           = r02,  \
>>>> +       .radio_syn_pll_mmd2             = r03,  \
>>>> +       .radio_syn_pll_mmd1             = r04,  \
>>>> +       .radio_syn_pll_loopfilter1      = r05,  \
>>>> +       .radio_syn_pll_loopfilter2      = r06,  \
>>>> +       .radio_syn_pll_loopfilter3      = r07,  \
>>>> +       .radio_syn_pll_loopfilter4      = r08,  \
>>>> +       .radio_syn_pll_loopfilter5      = r09,  \
>>>> +       .radio_syn_reserved_addr27      = r10,  \
>>>> +       .radio_syn_reserved_addr28      = r11,  \
>>>> +       .radio_syn_reserved_addr29      = r12,  \
>>>> +       .radio_syn_logen_vcobuf1        = r13,  \
>>>> +       .radio_syn_logen_mixer2         = r14,  \
>>>> +       .radio_syn_logen_buf3           = r15,  \
>>>> +       .radio_syn_logen_buf4           = r16,  \
>>>> +       .radio_rx0_lnaa_tune            = r17,  \
>>>> +       .radio_rx0_lnag_tune            = r18,  \
>>>> +       .radio_tx0_intpaa_boost_tune    = r19,  \
>>>> +       .radio_tx0_intpag_boost_tune    = r20,  \
>>>> +       .radio_tx0_pada_boost_tune      = r21,  \
>>>> +       .radio_tx0_padg_boost_tune      = r22,  \
>>>> +       .radio_tx0_pgaa_boost_tune      = r23,  \
>>>> +       .radio_tx0_pgag_boost_tune      = r24,  \
>>>> +       .radio_tx0_mixa_boost_tune      = r25,  \
>>>> +       .radio_tx0_mixg_boost_tune      = r26,  \
>>>> +       .radio_rx1_lnaa_tune            = r27,  \
>>>> +       .radio_rx1_lnag_tune            = r28,  \
>>>> +       .radio_tx1_intpaa_boost_tune    = r29,  \
>>>> +       .radio_tx1_intpag_boost_tune    = r30,  \
>>>> +       .radio_tx1_pada_boost_tune      = r31,  \
>>>> +       .radio_tx1_padg_boost_tune      = r32,  \
>>>> +       .radio_tx1_pgaa_boost_tune      = r33,  \
>>>> +       .radio_tx1_pgag_boost_tune      = r34,  \
>>>> +       .radio_tx1_mixa_boost_tune      = r35,  \
>>>> +       .radio_tx1_mixg_boost_tune      = r36
>>>
>>> You might want to use parentheses around parameter names: e.g.:
>>> .radio_tx1_mixa_boost_tune = (r35), \
>>
>> We use this macro only for defining radio tables, only in this file.
>> Plus we don't use any math or sth as you can see in next patch (3/3).
>> That way it will not hit random developer using this macro in other
>> place of code.
>
> That's OK, but I believe that there is a coding style requirement to
> always parenthesize macro parameters. If there isn't, then it's OK.

There is "Chapter 12: Macros, Enums and RTL" in:
http://www.kernel.org/doc/Documentation/CodingStyle

Some quotes:
1) "Macros with multiple statements should be enclosed in a do - while block:"
2) "macros defining constants using expressions must enclose the
expression in parentheses"

Second one may sound like sth close, but it's just about expressions like:
#define CONSTEXP (CONSTANT | 3)

So there doesn't seem to be any "rule" in CodingStyle wanting us to
add parentheses when you suggested.

-- 
Rafał
