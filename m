Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:55943 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752063AbaKVQHu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Nov 2014 11:07:50 -0500
Message-ID: <5470B4D5.7090508@candelatech.com> (sfid-20141122_170755_855038_CF8FD37F)
Date: Sat, 22 Nov 2014 08:07:49 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Subject: Re: [PATCH v2 04/10] ath10k: make firmware text debug messages more
 verbose.
References: <1411507045-18973-1-git-send-email-greearb@candelatech.com>	<1411507045-18973-4-git-send-email-greearb@candelatech.com> <878uj38dbd.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <878uj38dbd.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 11/22/2014 07:28 AM, Kalle Valo wrote:
> greearb@candelatech.com writes:
>
>> From: Ben Greear <greearb@candelatech.com>
>>
>> There are not many of these messages producted by the
>> firmware, but they are generally fairly useful, so print
>> them at info level.
>>
>> Signed-off-by: Ben Greear <greearb@candelatech.com>
>
> [...]
>
>> --- a/drivers/net/wireless/ath/ath10k/debug.h
>> +++ b/drivers/net/wireless/ath/ath10k/debug.h
>> @@ -35,6 +35,7 @@ enum ath10k_debug_mask {
>>   	ATH10K_DBG_BMI		= 0x00000400,
>>   	ATH10K_DBG_REGULATORY	= 0x00000800,
>>   	ATH10K_DBG_TESTMODE	= 0x00001000,
>> +	ATH10K_DBG_FW_MSG	= 0x00002000,
>
> I think FW_MSG is a bit too ambiguous, so I changed this to WMI_PRINT so
> that it's closer the real event name.

Better than nothing, but my idea was that this flag would be able to affect
more than one thing related to firmware debugging.  Calling it something about
WMI does not indicate to me that it is really about firmware debugging.

Thanks,
Ben

> Full patch: https://github.com/kvalo/ath/commit/ce4269787f4b5e538731f34cb3a7358343efaa00
>

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
