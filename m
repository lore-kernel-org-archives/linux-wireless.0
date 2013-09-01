Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:52950 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626Ab3IAGep (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Sep 2013 02:34:45 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	<ath10k@lists.infradead.org>
Subject: Re: [PATCH v2 1/6] ath10k: use inline ce_state structure
References: <1377068249-26025-1-git-send-email-michal.kazior@tieto.com>
	<1377601683-12072-1-git-send-email-michal.kazior@tieto.com>
	<1377601683-12072-2-git-send-email-michal.kazior@tieto.com>
	<87y57mjvwu.fsf@kamboji.qca.qualcomm.com>
	<CA+BoTQ=mBeWQLvaLUL4gnTENRbGUK_fTkj9bP3HP-OSzBwG0Dg@mail.gmail.com>
Date: Sun, 1 Sep 2013 09:34:24 +0300
In-Reply-To: <CA+BoTQ=mBeWQLvaLUL4gnTENRbGUK_fTkj9bP3HP-OSzBwG0Dg@mail.gmail.com>
	(Michal Kazior's message of "Wed, 28 Aug 2013 07:32:50 +0200")
Message-ID: <874na582z3.fsf@kamboji.qca.qualcomm.com> (sfid-20130901_083458_955338_ED767CE5)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> On 28 August 2013 06:12, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
>> Michal Kazior <michal.kazior@tieto.com> writes:
>>
>>> Simplifies memory managament of ce_state.
>>>
>>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>>
>> Sorry, I noticed this only in my second review round:
>>
>>> --- a/drivers/net/wireless/ath/ath10k/pci.h
>>> +++ b/drivers/net/wireless/ath/ath10k/pci.h
>>> @@ -233,7 +233,10 @@ struct ath10k_pci {
>>>       spinlock_t ce_lock;
>>>
>>>       /* Map CE id to ce_state */
>>> -     struct ce_state *ce_id_to_state[CE_COUNT_MAX];
>>> +     struct ce_state ce_states[CE_COUNT_MAX];
>>> +
>>> +     /* makes sure that dummy reads are atomic */
>>> +     spinlock_t hw_v1_workaround_lock;
>>>  };
>>
>> That lock doesn't look right. Is it a leftover from a rebase?
>
> Oh, good catch. I wonder how it got there..

I had patches pending on this patchset, so I removed the lock from this
patch and applied it.

-- 
Kalle Valo
