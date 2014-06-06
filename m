Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:44495 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751915AbaFFRGi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jun 2014 13:06:38 -0400
Message-ID: <5391F51B.4020103@candelatech.com> (sfid-20140606_190641_493785_19B9A29D)
Date: Fri, 06 Jun 2014 10:06:35 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/4] ath10k:  provide firmware crash info via debugfs.
References: <1401904902-5842-1-git-send-email-greearb@candelatech.com> <87y4xal6vb.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87y4xal6vb.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/06/2014 02:33 AM, Kalle Valo wrote:

>> +					kfree(buffer);
>> +					goto save_regs_and_restart;
>> +				}
>> +
>> +				ath10k_dbg_save_fw_dbg_buffer(ar, buffer,
>> +							      dbuf.length);
>> +				kfree(buffer);
> 
> Instead of doing atomic allocations multiple times in a loop, would it
> be better to allocate just one buffer before the loop and free it
> afterwards?

There is no hard guarantee that the buffer lengths are the same,
so I think it needs to remain as is.  Would rather not crap out
because firmware suddenly got more clever...

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

