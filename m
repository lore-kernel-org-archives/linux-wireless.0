Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:55412 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357AbbJGFaz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Oct 2015 01:30:55 -0400
Subject: Re: [PATCH 02/10] staging: wilc1000: remove typedef from tenuWIDtype
To: Mike Rapoport <mike.rapoport@gmail.com>
References: <1444124541-5663-1-git-send-email-tony.cho@atmel.com>
 <1444124541-5663-2-git-send-email-tony.cho@atmel.com>
 <20151006151459.GA25750@zed.theccd.local>
CC: <gregkh@linuxfoundation.org>, <devel@driverdev.osuosl.org>,
	<rachel.kim@atmel.com>, <chris.park@atmel.com>,
	<austin.shin@atmel.com>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <Nicolas.FERRE@atmel.com>,
	<adel.noureldin@atmel.com>, <leo.kim@atmel.com>,
	<adham.abozaeid@atmel.com>
From: Tony Cho <tony.cho@atmel.com>
Message-ID: <5614ADFD.2020200@atmel.com> (sfid-20151007_073122_864646_E7789DC6)
Date: Wed, 7 Oct 2015 14:30:37 +0900
MIME-Version: 1.0
In-Reply-To: <20151006151459.GA25750@zed.theccd.local>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 2015년 10월 07일 00:14, Mike Rapoport wrote:
> On Tue, Oct 06, 2015 at 06:42:13PM +0900, Tony Cho wrote:
>> From: Leo Kim <leo.kim@atmel.com>
>>
>> This patch remove typedef from the enum tenuWIDtype
>> and rename it to WID_TYPE.
>>
>> Signed-off-by: Leo Kim <leo.kim@atmel.com>
>> Signed-off-by: Tony Cho <tony.cho@atmel.com>
>> ---
>>   drivers/staging/wilc1000/coreconfigurator.h | 2 +-
>>   drivers/staging/wilc1000/host_interface.h   | 2 +-
>>   drivers/staging/wilc1000/wilc_wlan_if.h     | 5 ++---
>>   3 files changed, 4 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/staging/wilc1000/coreconfigurator.h b/drivers/staging/wilc1000/coreconfigurator.h
>> index 306efc9..02faf58 100644
> [ snip ]
>
>> diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc1000/wilc_wlan_if.h
>> index 8fec64d..be972af 100644
>> --- a/drivers/staging/wilc1000/wilc_wlan_if.h
>> +++ b/drivers/staging/wilc1000/wilc_wlan_if.h
>> @@ -315,7 +315,7 @@ typedef enum {
>>   	SW_TRIGGER_ABORT,
>>   } TX_ABORT_OPTION_T;
>>   
>> -typedef enum {
>> +enum WID_TYPE {
> The enum name should be lowecase, i.e. 'enum wid_type'.
>
All of enumerated types aren't uppercase. Can we mark outstanding enumeration with uppercase in specific file?
If this doesn't violate any rules in Linux coding style, I want to go as it did.

Thanks for your advice,

Tony.

>>   	WID_CHAR		= 0,
>>   	WID_SHORT		= 1,
>>   	WID_INT			= 2,
>> @@ -326,8 +326,7 @@ typedef enum {
>>   	WID_ADR			= 7,
>>   	WID_UNDEF		= 8,
>>   	WID_TYPE_FORCE_32BIT	= 0xFFFFFFFF
>> -
>> -} WID_TYPE_T, tenuWIDtype;
>> +};
>>   
>>   typedef enum {
>>   	WID_NIL				= 0xffff,
>> -- 
>> 1.9.1
> --
> Sincerely yours,
> Mike.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

