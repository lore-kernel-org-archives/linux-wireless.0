Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:31462 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932406Ab3JPMrU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Oct 2013 08:47:20 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	<ath10k@lists.infradead.org>
Subject: Re: [PATCH 3/7] ath10k: track vif list internally
References: <20131015184548.14123.56949.stgit@localhost6.localdomain6>
	<20131015184656.14123.70575.stgit@localhost6.localdomain6>
	<87a9iabc9c.fsf@kamboji.qca.qualcomm.com>
	<CA+BoTQ=CqXN24Y-tb=r_ruUUNR_imcztULnoTScAvScvbPDbdA@mail.gmail.com>
Date: Wed, 16 Oct 2013 15:47:15 +0300
In-Reply-To: <CA+BoTQ=CqXN24Y-tb=r_ruUUNR_imcztULnoTScAvScvbPDbdA@mail.gmail.com>
	(Michal Kazior's message of "Tue, 15 Oct 2013 12:37:42 -0700")
Message-ID: <87k3hd757w.fsf@kamboji.qca.qualcomm.com> (sfid-20131016_144729_091789_BD206C64)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> On 15 October 2013 11:49, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
>> Kalle Valo <kvalo@qca.qualcomm.com> writes:
>>
>>> From: Michal Kazior <michal.kazior@tieto.com>
>>>
>>> mac80211 interface interations functions have
>>> peculiar locking issues. This patch introduces
>>> internal (to ath10k) vif list that will be used
>>> for vif iteration purposes.
>>>
>>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>>> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
>>
>> [...]
>>
>> Michal, why do the INIT_LIST_HEAD() twice? Isn't it enough to do it
>> core_start()?
>
> Ah, good point. It's most likely okay to just do it in
> ath10k_core_start(). The one in ath10k_core_create() isn't required.

Ok, I removed the one from ath10k_core_create() before I commited this.

-- 
Kalle Valo
