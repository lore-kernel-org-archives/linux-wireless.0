Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:64628 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760273Ab2COIrP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Mar 2012 04:47:15 -0400
Received: by yhmm54 with SMTP id m54so2840033yhm.19
        for <linux-wireless@vger.kernel.org>; Thu, 15 Mar 2012 01:47:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1331798610.3432.0.camel@jlt3.sipsolutions.net>
References: <1331797479-2838-1-git-send-email-nataraja@qca.qualcomm.com>
	<1331798610.3432.0.camel@jlt3.sipsolutions.net>
Date: Thu, 15 Mar 2012 14:17:14 +0530
Message-ID: <CAJqpcCSxpy6+bwB9E+4Ub6z1nojzit99u_cg81xoK=Lm1E0iYA@mail.gmail.com> (sfid-20120315_094722_863385_A99724CC)
Subject: Re: [PATCH 1/2] cfg80211: Fix a compilation warning
From: Vivek Natarajan <vivek.natraj@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 15, 2012 at 1:33 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2012-03-15 at 13:14 +0530, Vivek Natarajan wrote:
>> Fix a macro redefined warning:
>>
>> net/wireless/reg.c:45:1 warning: "pr_fmt" redefined
>>
>> Also remove an unused instance in core.c
>>
>> Signed-off-by: Vivek Natarajan <nataraja@qca.qualcomm.com>
>> ---
>>  net/wireless/core.c |    2 --
>>  net/wireless/reg.c  |    2 ++
>>  2 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/net/wireless/core.c b/net/wireless/core.c
>> index ccdfed8..067c008 100644
>> --- a/net/wireless/core.c
>> +++ b/net/wireless/core.c
>> @@ -4,8 +4,6 @@
>>   * Copyright 2006-2010               Johannes Berg <johannes@sipsolutions.net>
>>   */
>>
>> -#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>> -
>>  #include <linux/if.h>
>>  #include <linux/module.h>
>>  #include <linux/err.h>
>> diff --git a/net/wireless/reg.c b/net/wireless/reg.c
>> index e9a0ac8..1797fcc 100644
>> --- a/net/wireless/reg.c
>> +++ b/net/wireless/reg.c
>> @@ -42,7 +42,9 @@
>>   *
>>   */
>>
>> +#ifndef pr_fmt
>>  #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>> +#endif
>
> Umm, no? This isn't right -- are you getting this warning while building
> a compat tree?

Yes, on compiling it with compat-wireless.

Vivek.
