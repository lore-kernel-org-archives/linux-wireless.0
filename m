Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:51804 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027AbaKYKNX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Nov 2014 05:13:23 -0500
Message-ID: <5474538B.70207@broadcom.com> (sfid-20141125_111330_496448_6EEE9DA0)
Date: Tue, 25 Nov 2014 11:01:47 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/4] brcmutil: add helper function to format board revision
References: <1416518822-29585-1-git-send-email-arend@broadcom.com> <1416518822-29585-3-git-send-email-arend@broadcom.com> <20141124215352.GB4484@tuxdriver.com>
In-Reply-To: <20141124215352.GB4484@tuxdriver.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/24/14 22:53, John W. Linville wrote:
> I am holding patches 2-4 until we resolve the brcmu_boardrev_str
> build thing...

Actually, only patch 2 and 3 are related to the build thing. If that is 
what this is.

Regards,
Arend

> On Thu, Nov 20, 2014 at 10:27:00PM +0100, Arend van Spriel wrote:
>> The board revision that is available in hardware can be translated
>> so it matches the labelling on the board. This is accomplished by
>> this helper function.
>>
>> Reviewed-by: Hante Meuleman<meuleman@broadcom.com>
>> Reviewed-by: Pieter-Paul Giesberts<pieterpg@broadcom.com>
>> Signed-off-by: Arend van Spriel<arend@broadcom.com>
>> ---
>>   drivers/net/wireless/brcm80211/brcmutil/utils.c      | 16 ++++++++++++++++
>>   drivers/net/wireless/brcm80211/include/brcmu_utils.h |  2 ++
>>   2 files changed, 18 insertions(+)
>>
>> diff --git a/drivers/net/wireless/brcm80211/brcmutil/utils.c b/drivers/net/wireless/brcm80211/brcmutil/utils.c
>> index 0f7e1c7..af97f8b 100644
>> --- a/drivers/net/wireless/brcm80211/brcmutil/utils.c
>> +++ b/drivers/net/wireless/brcm80211/brcmutil/utils.c
>> @@ -292,4 +292,20 @@ void brcmu_dbg_hex_dump(const void *data, size_t size, const char *fmt, ...)
>>   	print_hex_dump_bytes("", DUMP_PREFIX_OFFSET, data, size);
>>   }
>>   EXPORT_SYMBOL(brcmu_dbg_hex_dump);
>> +
>> +/* Produce a human-readable string for boardrev */
>> +char *brcmu_boardrev_str(u32 brev, char *buf)
>> +{
>> +	char c;
>> +
>> +	if (brev<  0x100) {
>> +		snprintf(buf, 8, "%d.%d", (brev&  0xf0)>>  4, brev&  0xf);
>> +	} else {
>> +		c = (brev&  0xf000) == 0x1000 ? 'P' : 'A';
>> +		snprintf(buf, 8, "%c%03x", c, brev&  0xfff);
>> +	}
>> +	return buf;
>> +}
>> +EXPORT_SYMBOL(brcmu_boardrev_str);
>> +
>>   #endif				/* defined(DEBUG) */
>> diff --git a/drivers/net/wireless/brcm80211/include/brcmu_utils.h b/drivers/net/wireless/brcm80211/include/brcmu_utils.h
>> index 8ba445b..a043e29 100644
>> --- a/drivers/net/wireless/brcm80211/include/brcmu_utils.h
>> +++ b/drivers/net/wireless/brcm80211/include/brcmu_utils.h
>> @@ -218,4 +218,6 @@ void brcmu_dbg_hex_dump(const void *data, size_t size, const char *fmt, ...)
>>   }
>>   #endif
>>
>> +char *brcmu_boardrev_str(u32 brev, char *buf);
>> +
>>   #endif				/* _BRCMU_UTILS_H_ */
>> --
>> 1.9.1
>>
>>
>

