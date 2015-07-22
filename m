Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:58289 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755966AbbGVG2W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jul 2015 02:28:22 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Avery Pennarun <apenwarr@google.com>
Cc: Marty Faltesek <mfaltesek@google.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Denton Gentry <dgentry@google.com>
Subject: Re: [PATCH] ath10k: Improve performance by reducing tx_lock contention.
References: <1437527130-15232-1-git-send-email-mfaltesek@google.com>
	<87wpxslnse.fsf@kamboji.qca.qualcomm.com>
	<CAPp0ZBavC33umwjraqtxpKWP6Ez9X1_7K9fZNsP2oPu4v=uyEw@mail.gmail.com>
Date: Wed, 22 Jul 2015 09:28:16 +0300
In-Reply-To: <CAPp0ZBavC33umwjraqtxpKWP6Ez9X1_7K9fZNsP2oPu4v=uyEw@mail.gmail.com>
	(Avery Pennarun's message of "Wed, 22 Jul 2015 02:21:27 -0400")
Message-ID: <87si8gln9b.fsf@kamboji.qca.qualcomm.com> (sfid-20150722_082825_711737_5C0D8617)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Avery Pennarun <apenwarr@google.com> writes:

> On Wed, Jul 22, 2015 at 2:16 AM, Kalle Valo <kvalo@codeaurora.org> wrote:
>> Marty Faltesek <mfaltesek@google.com> writes:
>>> From: Qi Zhou <qizhou@google.com>
>>>
>>> During tx completion, tx_lock is held for longer than required, preventing
>>> efficient refill of htt->pending_tx. Refactor the code so that only MSDU
>>> related operations are protected by the lock.
>>>
>>> Improves downstream performance on a 3x3 client from 495 to 580 Mbps.
>>
>> It would be good to mention the actual platform/CPU as I guess this
>> improvement is platform specific?
>
> That's a good idea to mention in the commit message, although given
> that it's just an in-driver lock contention patch, it probably affects
> any underpowered multicore CPU.

Yeah, that would be good to mention as well :)

-- 
Kalle Valo
