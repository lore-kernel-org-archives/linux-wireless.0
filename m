Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:34527 "EHLO
	mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751635AbcF2Wiy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2016 18:38:54 -0400
Received: by mail-wm0-f68.google.com with SMTP id 187so17869718wmz.1
        for <linux-wireless@vger.kernel.org>; Wed, 29 Jun 2016 15:37:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <a19c21f6-40b9-98e9-30dc-c21fb2143534@nbd.name>
References: <20160624123430.4097-1-martin.blumenstingl@googlemail.com>
 <20160624123430.4097-3-martin.blumenstingl@googlemail.com> <a19c21f6-40b9-98e9-30dc-c21fb2143534@nbd.name>
From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date: Thu, 30 Jun 2016 00:37:33 +0200
Message-ID: <CAFBinCDXDgLp79DVFvSES08=bFWMr_GvM+Kebj4f4crZyRKvEQ@mail.gmail.com> (sfid-20160630_003859_464132_EF6BD282)
Subject: Re: [PATCH v3 2/3] ath9k: add a helper to get the string
 representation of ath_bus_type
To: Felix Fietkau <nbd@nbd.name>
Cc: ath9k-devel@qca.qualcomm.com, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org, chunkeey@googlemail.com,
	mark.rutland@arm.com, robh+dt@kernel.org,
	arend.vanspriel@broadcom.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 27, 2016 at 12:26 PM, Felix Fietkau <nbd@nbd.name> wrote:
> On 2016-06-24 14:34, Martin Blumenstingl wrote:
>> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
>> ---
>> this is a new patch which didn't exist in v2 yet, it prepares the new
>> function ath_bus_type_to_string which will be used in patch #3
>>
>>  drivers/net/wireless/ath/ath.h  |  2 ++
>>  drivers/net/wireless/ath/main.c | 15 +++++++++++++++
>>  2 files changed, 17 insertions(+)
>>
>> diff --git a/drivers/net/wireless/ath/ath.h b/drivers/net/wireless/ath/ath.h
>> index da7a7c8..be0d292 100644
>> --- a/drivers/net/wireless/ath/ath.h
>> +++ b/drivers/net/wireless/ath/ath.h
>> @@ -327,4 +327,6 @@ static inline const char *ath_opmode_to_string(enum nl80211_iftype opmode)
>>  }
>>  #endif
>>
>> +const char *ath_bus_type_to_string(enum ath_bus_type bustype);
>> +
>>  #endif /* ATH_H */
>> diff --git a/drivers/net/wireless/ath/main.c b/drivers/net/wireless/ath/main.c
>> index 338d723..90427cb 100644
>> --- a/drivers/net/wireless/ath/main.c
>> +++ b/drivers/net/wireless/ath/main.c
>> @@ -90,3 +90,18 @@ void ath_printk(const char *level, const struct ath_common* common,
>>       va_end(args);
>>  }
>>  EXPORT_SYMBOL(ath_printk);
>> +
>> +const char *ath_bus_type_to_string(enum ath_bus_type bustype)
>> +{
>> +     switch (bustype) {
>> +     case ATH_PCI:
>> +             return "pci";
>> +     case ATH_AHB:
>> +             return "ahb";
>> +     case ATH_USB:
>> +             return "usb";
>> +     default:
>> +             return "unknown";
>> +     }
>> +}
>> +EXPORT_SYMBOL(ath_bus_type_to_string);
> Why not simply add a const char* array with ath_bus_type as index?
Would you add this const char* array directly in ath.h or would you
define it as extern there and set it in main.c?
I would still provide the ath_bus_type_to_string function, but make it
static inline in that case.
