Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:52079 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753307AbaDEGRp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Apr 2014 02:17:45 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Ben Greear <greearb@candelatech.com>
CC: <linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>
Subject: Re: [PATCH 1/1] ath10k:  add helper method to grab debug stats.
References: <1396374940-21453-1-git-send-email-greearb@candelatech.com>
	<8738hwrxso.fsf@kamboji.qca.qualcomm.com>
	<533C256B.9090209@candelatech.com>
Date: Sat, 5 Apr 2014 09:17:39 +0300
In-Reply-To: <533C256B.9090209@candelatech.com> (Ben Greear's message of "Wed,
	02 Apr 2014 07:57:47 -0700")
Message-ID: <87bnwgpaf0.fsf@kamboji.qca.qualcomm.com> (sfid-20140405_081819_302669_42C137E9)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ben Greear <greearb@candelatech.com> writes:

> On 04/02/2014 12:32 AM, Kalle Valo wrote:
>> greearb@candelatech.com writes:
>>
>>> From: Ben Greear <greearb@candelatech.com>
>>>
>>> It can be nice to update the firmware's stats while
>>> debugging other bits of the driver, so add helper method
>>> to do this.
>>>
>>> Signed-off-by: Ben Greear <greearb@candelatech.com>
>>
>> [...]
>>
>>> --- a/drivers/net/wireless/ath/ath10k/debug.h
>>> +++ b/drivers/net/wireless/ath/ath10k/debug.h
>>> @@ -135,4 +135,6 @@ struct dbglog_hdr_s {
>>>
>>>   void ath10k_dbg_print_fw_dbg_buffer(u8 *buffer, int len, const char* lvl);
>>>
>>> +int ath10k_refresh_peer_stats(struct ath10k *ar);
>>
>> I don't see anyone calling this. How are you planning to use it?
>
> The RFC patch that debugs tx-hang calls it..nice to see he firmware's
> buffer reap stats and such before/after trying to flush the buffers.
>
> I figure it will be useful for other such uses as well, now that stats
> actually work.

Ok, I'll drop this patch for now. You can resend when we have callers
for this.

-- 
Kalle Valo
