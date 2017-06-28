Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ua0-f196.google.com ([209.85.217.196]:35754 "EHLO
        mail-ua0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751225AbdF1E3E (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Jun 2017 00:29:04 -0400
Received: by mail-ua0-f196.google.com with SMTP id j53so3666484uaa.2
        for <linux-wireless@vger.kernel.org>; Tue, 27 Jun 2017 21:29:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <80d08513-9da0-2840-dd15-0a3deace3dc7@lwfinger.net>
References: <20170622120004.GA5783@symbol-HP-ZBook-15> <80d08513-9da0-2840-dd15-0a3deace3dc7@lwfinger.net>
From: Souptick Joarder <jrdr.linux@gmail.com>
Date: Wed, 28 Jun 2017 09:59:03 +0530
Message-ID: <CAFqt6zZRJOgFkTmWtmsROx3yg91avpAZ2Xsmd+S1-UjFxBXSYg@mail.gmail.com> (sfid-20170628_062908_334838_8177469B)
Subject: Re: [PATCH v2] rtlwifi: Replace hardcode value with macro
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Chaoming Li <chaoming_li@realsil.com.cn>,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Larry,

On Thu, Jun 22, 2017 at 7:05 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> On 06/22/2017 07:00 AM, Souptick Joarder wrote:
>>
>> In _rtl_init_mac80211(), hardcoded value for hw->max_listen_interval
>> and hw->max_rate_tries are replaced by macro.
>>
>> Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>
>> ---
>> Changes in v2:
>>     - Signed-off was missing in previous one.
>
>
> This patch includes a comment that is not needed, but it is OK.
>
> Acked-by: Larry Finger <Larry.Finger@lwfinger.net>
>
> Larry

Any further review is required for this patch or it will be merged to
maintainer tree ?

>
>
>>
>>   drivers/net/wireless/realtek/rtlwifi/base.c | 6 +++---
>>   drivers/net/wireless/realtek/rtlwifi/base.h | 2 ++
>>   2 files changed, 5 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/net/wireless/realtek/rtlwifi/base.c
>> b/drivers/net/wireless/realtek/rtlwifi/base.c
>> index bdc3791..f45d093 100644
>> --- a/drivers/net/wireless/realtek/rtlwifi/base.c
>> +++ b/drivers/net/wireless/realtek/rtlwifi/base.c
>> @@ -422,9 +422,9 @@ static void _rtl_init_mac80211(struct ieee80211_hw
>> *hw)
>>         hw->extra_tx_headroom = RTL_TX_HEADER_SIZE;
>>
>>         /* TODO: Correct this value for our hw */
>> -       /* TODO: define these hard code value */
>> -       hw->max_listen_interval = 10;
>> -       hw->max_rate_tries = 4;
>> +       /* defined these hard code values */
>> +       hw->max_listen_interval = MAX_LISTEN_INTERVAL;
>> +       hw->max_rate_tries = MAX_RATE_TRIES;
>>         /* hw->max_rates = 1; */
>>         hw->sta_data_size = sizeof(struct rtl_sta_info);
>>
>> diff --git a/drivers/net/wireless/realtek/rtlwifi/base.h
>> b/drivers/net/wireless/realtek/rtlwifi/base.h
>> index 02ff0c5..d03e198 100644
>> --- a/drivers/net/wireless/realtek/rtlwifi/base.h
>> +++ b/drivers/net/wireless/realtek/rtlwifi/base.h
>> @@ -65,6 +65,8 @@ enum ap_peer {
>>   #define FRAME_OFFSET_ADDRESS3         16
>>   #define FRAME_OFFSET_SEQUENCE         22
>>   #define FRAME_OFFSET_ADDRESS4         24
>> +#define MAX_LISTEN_INTERVAL             10
>> +#define MAX_RATE_TRIES                  4
>>
>>   #define SET_80211_HDR_FRAME_CONTROL(_hdr, _val)               \
>>         WRITEEF2BYTE(_hdr, _val)
>> --
>> 1.9.1
>>
>>
>

-Souptick
