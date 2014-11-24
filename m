Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:30717 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753558AbaKXPSj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2014 10:18:39 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Ben Greear <greearb@candelatech.com>
CC: <linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>
Subject: Re: [PATCH v2 04/10] ath10k: make firmware text debug messages more verbose.
References: <1411507045-18973-1-git-send-email-greearb@candelatech.com>
	<1411507045-18973-4-git-send-email-greearb@candelatech.com>
	<878uj38dbd.fsf@kamboji.qca.qualcomm.com>
	<5470B4D5.7090508@candelatech.com>
Date: Mon, 24 Nov 2014 17:18:20 +0200
In-Reply-To: <5470B4D5.7090508@candelatech.com> (Ben Greear's message of "Sat,
	22 Nov 2014 08:07:49 -0800")
Message-ID: <87d28c630j.fsf@kamboji.qca.qualcomm.com> (sfid-20141124_161842_622822_1D5E2F3E)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ben Greear <greearb@candelatech.com> writes:

> On 11/22/2014 07:28 AM, Kalle Valo wrote:
>> greearb@candelatech.com writes:
>>
>>> From: Ben Greear <greearb@candelatech.com>
>>>
>>> There are not many of these messages producted by the
>>> firmware, but they are generally fairly useful, so print
>>> them at info level.
>>>
>>> Signed-off-by: Ben Greear <greearb@candelatech.com>
>>
>> [...]
>>
>>> --- a/drivers/net/wireless/ath/ath10k/debug.h
>>> +++ b/drivers/net/wireless/ath/ath10k/debug.h
>>> @@ -35,6 +35,7 @@ enum ath10k_debug_mask {
>>>   	ATH10K_DBG_BMI		= 0x00000400,
>>>   	ATH10K_DBG_REGULATORY	= 0x00000800,
>>>   	ATH10K_DBG_TESTMODE	= 0x00001000,
>>> +	ATH10K_DBG_FW_MSG	= 0x00002000,
>>
>> I think FW_MSG is a bit too ambiguous, so I changed this to WMI_PRINT so
>> that it's closer the real event name.
>
> Better than nothing, but my idea was that this flag would be able to affect
> more than one thing related to firmware debugging.  Calling it something about
> WMI does not indicate to me that it is really about firmware debugging.

For other debug methods we can always add a new debug level, or rename
this one.

-- 
Kalle Valo
