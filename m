Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.30]:48387 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760289AbYJJTAS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Oct 2008 15:00:18 -0400
Received: by yx-out-2324.google.com with SMTP id 8so237240yxm.1
        for <linux-wireless@vger.kernel.org>; Fri, 10 Oct 2008 12:00:17 -0700 (PDT)
Message-ID: <43e72e890810101200g3f50b204t20ea782878217369@mail.gmail.com> (sfid-20081010_210026_379003_32320103)
Date: Fri, 10 Oct 2008 12:00:17 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "David Miller" <davem@davemloft.net>
Subject: Re: [PATCH 1/1] Ath9k: fix uninitialized value in ath9k_hw_reset
Cc: jirislaby@gmail.com, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	jmalinen@atheros.com
In-Reply-To: <20081010.115318.85254002.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1223661403-21803-1-git-send-email-jirislaby@gmail.com>
	 <20081010.115318.85254002.davem@davemloft.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 10, 2008 at 11:53 AM, David Miller <davem@davemloft.net> wrote:
> From: Jiri Slaby <jirislaby@gmail.com>
> Date: Fri, 10 Oct 2008 19:56:43 +0200
>
>> status ath9k_hw_reset() parameter should be set in every case, since
>> it is used in callers to find out an error code.
>>
>> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
>> Cc: Luis R. Rodriguez <lrodriguez@atheros.com>
>> Cc: Jouni Malinen <jmalinen@atheros.com>
>> ---
>>  drivers/net/wireless/ath9k/hw.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/net/wireless/ath9k/hw.c b/drivers/net/wireless/ath9k/hw.c
>> index 62e44a0..fb6727b 100644
>> --- a/drivers/net/wireless/ath9k/hw.c
>> +++ b/drivers/net/wireless/ath9k/hw.c
>> @@ -5893,7 +5893,7 @@ bool ath9k_hw_reset(struct ath_hal *ah,
>>       }
>>
>>       if (!ath9k_hw_setpower(ah, ATH9K_PM_AWAKE))
>> -             return false;
>> +             FAIL(-EIO);
>>
>
> This fix may be correct, but this is the first time I've noticed
> these error status updating macros and they are super ugly.
>
> I really think they should be removed.  Someone casually scanning
> this code won't be able to discern the side effects and that makes
> auditing harder and more error prone.

Agreed, patches welcomed.

  Luis
