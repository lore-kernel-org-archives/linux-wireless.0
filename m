Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f178.google.com ([209.85.223.178]:33130 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757808Ab3EGM7C (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 May 2013 08:59:02 -0400
Received: by mail-ie0-f178.google.com with SMTP id b11so818793iee.23
        for <linux-wireless@vger.kernel.org>; Tue, 07 May 2013 05:59:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1367930971.32148.85.camel@cumari.coelho.fi>
References: <1367930469-29826-1-git-send-email-eliad@wizery.com>
	<1367930971.32148.85.camel@cumari.coelho.fi>
Date: Tue, 7 May 2013 15:59:01 +0300
Message-ID: <CAB3XZEcyaXwy6w440AWo1JKMB-ZpPzhOc+cKnR=3fFqentdT+g@mail.gmail.com> (sfid-20130507_145907_066177_E0DD7F16)
Subject: Re: [PATCH 1/3] wlcore: allow TX BA on all TIDs
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 7, 2013 at 3:49 PM, Luciano Coelho <coelho@ti.com> wrote:
> Hi Eliad,
>
> On Tue, 2013-05-07 at 15:41 +0300, Eliad Peller wrote:
>> Previous fw limitation prevented us from from doing
>> TX BA on TIDs 6/7. However, this restriction no
>> longer exists, so enable TX BA on all TIDs.
>>
>> Signed-off-by: Eliad Peller <eliad@wizery.com>
>> ---
>>  drivers/net/wireless/ti/wlcore/conf.h | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/wireless/ti/wlcore/conf.h b/drivers/net/wireless/ti/wlcore/conf.h
>> index 2b96ff8..80c1ac1 100644
>> --- a/drivers/net/wireless/ti/wlcore/conf.h
>> +++ b/drivers/net/wireless/ti/wlcore/conf.h
>> @@ -590,8 +590,8 @@ struct conf_tx_ac_category {
>>
>>  #define CONF_TX_MAX_TID_COUNT 8
>>
>> -/* Allow TX BA on all TIDs but 6,7. These are currently reserved in the FW */
>> -#define CONF_TX_BA_ENABLED_TID_BITMAP 0x3F
>> +/* Allow TX BA on all TIDs */
>> +#define CONF_TX_BA_ENABLED_TID_BITMAP 0xFF
>>
>>  enum {
>>       CONF_CHANNEL_TYPE_DCF = 0,   /* DC/LEGACY*/
>
> What happened with this?
>
> https://patchwork.kernel.org/patch/1802841/
>
hmm... you're right.
i forgot about it.
i'll delete it from my internal tree :)

thanks for catching it.
Eliad.
