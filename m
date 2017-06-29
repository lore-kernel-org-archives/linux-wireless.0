Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ua0-f195.google.com ([209.85.217.195]:32888 "EHLO
        mail-ua0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751420AbdF2ENj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Jun 2017 00:13:39 -0400
Received: by mail-ua0-f195.google.com with SMTP id w19so5883764uac.0
        for <linux-wireless@vger.kernel.org>; Wed, 28 Jun 2017 21:13:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87zics2ijg.fsf@purkki.adurom.net>
References: <20170622120004.GA5783@symbol-HP-ZBook-15> <87zics2ijg.fsf@purkki.adurom.net>
From: Souptick Joarder <jrdr.linux@gmail.com>
Date: Thu, 29 Jun 2017 09:43:37 +0530
Message-ID: <CAFqt6zY7eLc7k5E8rAXL1NRjAaEswNDJ0E8vJB42DtHTjqt2PA@mail.gmail.com> (sfid-20170629_061343_367084_A3B863C6)
Subject: Re: [PATCH v2] rtlwifi: Replace hardcode value with macro
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

On Wed, Jun 28, 2017 at 9:47 PM, Kalle Valo <kvalo@codeaurora.org> wrote:
> Souptick Joarder <jrdr.linux@gmail.com> writes:
>
>> In _rtl_init_mac80211(), hardcoded value for hw->max_listen_interval
>> and hw->max_rate_tries are replaced by macro.
>>
>> Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>
>> ---
>> Changes in v2:
>>    - Signed-off was missing in previous one.

As Signed-off was missing in first patch, so I send v2 with change
logs mentioned the same.
Just for clarification, shall I replace the comment mentioned in
change log with "no change"?

>>
>>  drivers/net/wireless/realtek/rtlwifi/base.c | 6 +++---
>>  drivers/net/wireless/realtek/rtlwifi/base.h | 2 ++
>>  2 files changed, 5 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/net/wireless/realtek/rtlwifi/base.c b/drivers/net/wireless/realtek/rtlwifi/base.c
>> index bdc3791..f45d093 100644
>> --- a/drivers/net/wireless/realtek/rtlwifi/base.c
>> +++ b/drivers/net/wireless/realtek/rtlwifi/base.c
>> @@ -422,9 +422,9 @@ static void _rtl_init_mac80211(struct ieee80211_hw *hw)
>>       hw->extra_tx_headroom = RTL_TX_HEADER_SIZE;
>>
>>       /* TODO: Correct this value for our hw */
>> -     /* TODO: define these hard code value */
>> -     hw->max_listen_interval = 10;
>> -     hw->max_rate_tries = 4;
>> +     /* defined these hard code values */
>> +     hw->max_listen_interval = MAX_LISTEN_INTERVAL;
>> +     hw->max_rate_tries = MAX_RATE_TRIES;
>
> Like Larry said, the comment does not make any sense. Please remove it
> and send v3.
>
> --
> Kalle Valo

Souptick
