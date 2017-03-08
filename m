Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44308 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751052AbdCHImV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Mar 2017 03:42:21 -0500
Subject: Re: [PATCH v2 1/4] brcmfmac: Do not print the firmware version as an
 error
To: Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>
References: <20170227214539.16422-1-hdegoede@redhat.com>
 <5f6bb4d4-1bf1-cd5b-96ba-fc45e641aa95@broadcom.com>
Cc: Takashi Iwai <tiwai@suse.de>, linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com
From: Hans de Goede <hdegoede@redhat.com>
Message-ID: <6c1dd576-7571-e85f-ee43-8e9e69a76679@redhat.com> (sfid-20170308_094226_568808_73D3B8CF)
Date: Wed, 8 Mar 2017 09:23:00 +0100
MIME-Version: 1.0
In-Reply-To: <5f6bb4d4-1bf1-cd5b-96ba-fc45e641aa95@broadcom.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On 07-03-17 10:59, Arend Van Spriel wrote:
> On 27-2-2017 22:45, Hans de Goede wrote:
>> Using pr_err for things which are not errors is a bad idea. E.g. it
>> will cause the plymouth bootsplash screen to drop back to the text
>> console so that the user can see the error, which is not what we
>> normally want to happen.
>>
>> Instead add a new brcmf_info macro and use that.
>>
>> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
>> ---
>> Changes in v2:
>> -Fix brcm_err typo (should be brcmf_err) in CONFIG_BRCM_TRACING case
>> ---
>>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c | 2 +-
>>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h  | 3 +++
>>  2 files changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
>> index 3e15d64..6d565f1 100644
>> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
>> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
>> @@ -161,7 +161,7 @@ int brcmf_c_preinit_dcmds(struct brcmf_if *ifp)
>>  	strsep(&ptr, "\n");
>>
>>  	/* Print fw version info */
>> -	brcmf_err("Firmware version = %s\n", buf);
>> +	brcmf_info("Firmware version = %s\n", buf);
>>
>>  	/* locate firmware version number for ethtool */
>>  	ptr = strrchr(buf, ' ') + 1;
>> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h
>> index 6687812..605f260 100644
>> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h
>> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h
>> @@ -59,11 +59,14 @@
>>  			pr_err("%s: " fmt, __func__, ##__VA_ARGS__);	\
>>  	} while (0)
>>  #endif
>> +#define brcmf_info(fmt, ...)	pr_info("%s: " fmt, __func__, ##__VA_ARGS__)
>
> Prefer using the same style as for brcmf_err, ie. using do {} while (0)

OK, v3 with this fixed coming up.

Regards,

Hans


>
> Regards,
> Arend
>
>>  #else
>>  __printf(2, 3)
>>  void __brcmf_err(const char *func, const char *fmt, ...);
>>  #define brcmf_err(fmt, ...) \
>>  	__brcmf_err(__func__, fmt, ##__VA_ARGS__)
>> +/* For tracing purposes treat info messages as errors */
>> +#define brcmf_info brcmf_err
>>  #endif
>>
>>  #if defined(DEBUG) || defined(CONFIG_BRCM_TRACING)
>>
