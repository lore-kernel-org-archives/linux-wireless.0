Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:5366 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752456AbaFGM5e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Jun 2014 08:57:34 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Ben Greear <greearb@candelatech.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/4] ath10k:  provide firmware crash info via debugfs.
References: <1401904902-5842-1-git-send-email-greearb@candelatech.com>
	<87y4xal6vb.fsf@kamboji.qca.qualcomm.com>
	<5391F51B.4020103@candelatech.com>
Date: Sat, 7 Jun 2014 15:57:26 +0300
In-Reply-To: <5391F51B.4020103@candelatech.com> (Ben Greear's message of "Fri,
	6 Jun 2014 10:06:35 -0700")
Message-ID: <87zjhoj2rt.fsf@kamboji.qca.qualcomm.com> (sfid-20140607_145741_495840_015D9D2D)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ben Greear <greearb@candelatech.com> writes:

> On 06/06/2014 02:33 AM, Kalle Valo wrote:
>
>>> +					kfree(buffer);
>>> +					goto save_regs_and_restart;
>>> +				}
>>> +
>>> +				ath10k_dbg_save_fw_dbg_buffer(ar, buffer,
>>> +							      dbuf.length);
>>> +				kfree(buffer);
>> 
>> Instead of doing atomic allocations multiple times in a loop, would it
>> be better to allocate just one buffer before the loop and free it
>> afterwards?
>
> There is no hard guarantee that the buffer lengths are the same,
> so I think it needs to remain as is.  Would rather not crap out
> because firmware suddenly got more clever...

This is related to my earlier comment about having a max len for the
buffers. So why not come up with a sane max length, allocate once a
temporary buffer of that length and use the same buffer in the loop?

-- 
Kalle Valo
