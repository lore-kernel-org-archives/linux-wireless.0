Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:46041 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932140AbaDBO6R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Apr 2014 10:58:17 -0400
Message-ID: <533C256B.9090209@candelatech.com> (sfid-20140402_165820_717729_B61B0636)
Date: Wed, 02 Apr 2014 07:57:47 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/1] ath10k:  add helper method to grab debug stats.
References: <1396374940-21453-1-git-send-email-greearb@candelatech.com> <8738hwrxso.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <8738hwrxso.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/02/2014 12:32 AM, Kalle Valo wrote:
> greearb@candelatech.com writes:
>
>> From: Ben Greear <greearb@candelatech.com>
>>
>> It can be nice to update the firmware's stats while
>> debugging other bits of the driver, so add helper method
>> to do this.
>>
>> Signed-off-by: Ben Greear <greearb@candelatech.com>
>
> [...]
>
>> --- a/drivers/net/wireless/ath/ath10k/debug.h
>> +++ b/drivers/net/wireless/ath/ath10k/debug.h
>> @@ -135,4 +135,6 @@ struct dbglog_hdr_s {
>>
>>   void ath10k_dbg_print_fw_dbg_buffer(u8 *buffer, int len, const char* lvl);
>>
>> +int ath10k_refresh_peer_stats(struct ath10k *ar);
>
> I don't see anyone calling this. How are you planning to use it?


The RFC patch that debugs tx-hang calls it..nice to see he firmware's
buffer reap stats and such before/after trying to flush the buffers.

I figure it will be useful for other such uses as well, now that stats
actually work.

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

