Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f45.google.com ([74.125.83.45]:34441 "EHLO
        mail-pg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751686AbdATKOq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 20 Jan 2017 05:14:46 -0500
Received: by mail-pg0-f45.google.com with SMTP id 14so22702256pgg.1
        for <linux-wireless@vger.kernel.org>; Fri, 20 Jan 2017 02:14:45 -0800 (PST)
Subject: Re: [PATCH RFC 1/2] brcmfmac: merge two brcmf_err macros into one
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
References: <20170118142703.9824-1-zajec5@gmail.com>
 <da843f98-cd01-17f7-45cc-4530e8b87bfe@broadcom.com>
Cc: Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Franky Lin <frankyl@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <52453214-bab2-dc0b-c684-2389fe028442@broadcom.com> (sfid-20170120_111455_069987_9D32C906)
Date: Fri, 20 Jan 2017 11:14:33 +0100
MIME-Version: 1.0
In-Reply-To: <da843f98-cd01-17f7-45cc-4530e8b87bfe@broadcom.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 20-1-2017 11:13, Arend Van Spriel wrote:
> On 18-1-2017 15:27, Rafał Miłecki wrote:
>> From: Rafał Miłecki <rafal@milecki.pl>
>>
>> This allows simplifying the code by adding a simple IS_ENABLED check for
>> CONFIG_BRCMDB symbol.

Actually it should be CONFIG_BRCMDBG above.

Kalle,

Can you fix that in the commit message?

Regards,
Arend

> Nice!
> 
> Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
>> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
>> ---
>>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h | 8 ++------
>>  1 file changed, 2 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h
>> index 6687812..1fe4aa9 100644
>> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h
>> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h
>> @@ -45,20 +45,16 @@
>>  #undef pr_fmt
>>  #define pr_fmt(fmt)		KBUILD_MODNAME ": " fmt
>>  
>> +#ifndef CONFIG_BRCM_TRACING
>>  /* Macro for error messages. net_ratelimit() is used when driver
>>   * debugging is not selected. When debugging the driver error
>>   * messages are as important as other tracing or even more so.
>>   */
>> -#ifndef CONFIG_BRCM_TRACING
>> -#ifdef CONFIG_BRCMDBG
>> -#define brcmf_err(fmt, ...)	pr_err("%s: " fmt, __func__, ##__VA_ARGS__)
>> -#else
>>  #define brcmf_err(fmt, ...)						\
>>  	do {								\
>> -		if (net_ratelimit())					\
>> +		if (IS_ENABLED(CONFIG_BRCMDBG) || net_ratelimit())	\
>>  			pr_err("%s: " fmt, __func__, ##__VA_ARGS__);	\
>>  	} while (0)
>> -#endif
>>  #else
>>  __printf(2, 3)
>>  void __brcmf_err(const char *func, const char *fmt, ...);
>>
