Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.177]:9642 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870AbYG1NEj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jul 2008 09:04:39 -0400
Received: by py-out-1112.google.com with SMTP id p76so3281101pyb.10
        for <linux-wireless@vger.kernel.org>; Mon, 28 Jul 2008 06:04:38 -0700 (PDT)
Message-ID: <40f31dec0807280604m19a8c511nf2568bb7aa357b90@mail.gmail.com> (sfid-20080728_150442_645761_53D448BD)
Date: Mon, 28 Jul 2008 16:04:37 +0300
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Jiri Slaby" <jirislaby@gmail.com>
Subject: Re: [ath5k-devel] [PATCH 12/12] ath5k: Fix a compilation error after reg list update
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, mcgrof@gmail.com
In-Reply-To: <4885F055.8000304@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20080720035221.GL7440@makis> <4885F055.8000304@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2008/7/22 Jiri Slaby <jirislaby@gmail.com>:
> On 07/20/2008 05:52 AM, Nick Kossifidis wrote:
>>  Last minute fix...
>>
>>  AR5K_CPCORN is changed to AR5K_CPCOVF in reg list update so we have to update debug.c in order to compile
>>
>>  Changes-licensed-under: ISC
>>  Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>
>>
>> ---
>> diff --git a/drivers/net/wireless/ath5k/debug.c b/drivers/net/wireless/ath5k/debug.c
>> index 41d5fa3..6fa6c8e 100644
>> --- a/drivers/net/wireless/ath5k/debug.c
>> +++ b/drivers/net/wireless/ath5k/debug.c
>> @@ -129,7 +129,7 @@ static struct reg regs[] = {
>>       REG_STRUCT_INIT(AR5K_CPC1),
>>       REG_STRUCT_INIT(AR5K_CPC2),
>>       REG_STRUCT_INIT(AR5K_CPC3),
>> -     REG_STRUCT_INIT(AR5K_CPCORN),
>> +     REG_STRUCT_INIT(AR5K_CPCOVF),
>>       REG_STRUCT_INIT(AR5K_RESET_CTL),
>>       REG_STRUCT_INIT(AR5K_SLEEP_CTL),
>>       REG_STRUCT_INIT(AR5K_INTPEND),
>
> Please amend this to the patch 1 to not break bisectability.

I see your point but this series is meant to be applied as a whole, i
didn't notice this bug until i tested the code with debugging enabled
(which is off by default), that's why it's "last minute fix". Is it
really that much needed to repost the first patch ? I mean the patch
series works and doesn't introduce any problems...

-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
