Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:47600 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752209AbdLHMfk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Dec 2017 07:35:40 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Fri, 08 Dec 2017 18:05:38 +0530
From: akolli@codeaurora.org
To: Sven Eckelmann <sven.eckelmann@openmesh.com>
Cc: akolli@qti.qualcomm.com, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org,
        linux-wireless-owner@vger.kernel.org
Subject: Re: [PATCH] ath10k: Add BMI parameters to fix calibration from
 DT/pre-cal
In-Reply-To: <6476910.M9FJQ0px1r@bentobox>
References: <1495709483-29793-1-git-send-email-akolli@qti.qualcomm.com>
 <6476910.M9FJQ0px1r@bentobox>
Message-ID: <637ab47b1794b409e595b7e219cd904f@codeaurora.org> (sfid-20171208_133543_654008_23F26AB3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2017-12-08 17:42, Sven Eckelmann wrote:
> On Donnerstag, 25. Mai 2017 16:21:23 CET akolli@qti.qualcomm.com wrote:
>> From: Anilkumar Kolli <akolli@qti.qualcomm.com>
>> 
>> QCA99X0, QCA9888, QCA9984 supports calibration data in
>> either OTP or DT/pre-cal file. Current ath10k supports
>> Calibration data from OTP only.
>> 
>> If caldata is loaded from DT/pre-cal file, fetching board id
>> and applying calibration parameters like tx power gets failed.
>> 
>> error log:
>> [   15.733663] ath10k_pci 0000:01:00.0: failed to fetch board file: -2
>> [   15.741474] ath10k_pci 0000:01:00.0: could not probe fw (-2)
>> 
>> This patch adds calibration data support from DT/pre-cal
>> file.  Below parameters are used to get board id and
>> applying calibration parameters from cal data.
>> 
>> 		EEPROM[OTP]	FLASH[DT/pre-cal file]
>> Cal param	0x700		0x10000
>> Board id	0x10		0x8000
>> 
>> Tested on QCA9888 with pre-cal file.
>> 
>> Signed-off-by: Anilkumar Kolli <akolli@qti.qualcomm.com>
>> ---
>>  drivers/net/wireless/ath/ath10k/bmi.h  |    2 ++
>>  drivers/net/wireless/ath/ath10k/core.c |   16 +++++++++++++---
>>  2 files changed, 15 insertions(+), 3 deletions(-)
> 
> Just tried this on an QCA9984 which doesn't seem to have the
> calibration data in the PCI EEPROM.
> 
>     [   71.728929] ath10k_pci 0000:01:00.0: qca9984/qca9994 hw1.0
> target 0x01000000 chip_id 0x00000000 sub 168c:cafe
>     [   71.732926] ath10k_pci 0000:01:00.0: kconfig debug 1 debugfs 1
> tracing 0 dfs 1 testmode 1
>     [   71.752282] ath10k_pci 0000:01:00.0: firmware ver
> 10.4-ct-9984-fW-009-dfa0083 api 5 features peer-flow-ctrl crc32
> 7198d117
>     [   73.805730] ath10k_pci 0000:01:00.0: unable to read from the 
> device
>     [   73.805769] ath10k_pci 0000:01:00.0: could not execute otp for
> board id check: -110
> 

'ATH10K driver <-> 10.4 firmware' expects cal data to be either in 
EEPROM or pre-cal-file or DT.
Hope the error is observed when there is no cal data loaded.

> It works when I use the pre-cal data as calibration data. The checksum 
> in the
> pre-cal seems to be correct. Also the pre-cal data from 0:ART for the 
> 2.4GHz
> and 5GHz QCA4019 seem to work perfectly fine.
> 

Do you mean this patch works for only QCA4019 and not working for 
QCA9984 ?

> Anything which I could have missed or what I could test? Btw. I've also 
> tested
> the non-ct firmware (aka the official one from QCA).
> 

Thanks,
Anil.
