Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f174.google.com ([209.85.213.174]:37574 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753138AbbGVGVr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jul 2015 02:21:47 -0400
Received: by igbpg9 with SMTP id pg9so125495882igb.0
        for <linux-wireless@vger.kernel.org>; Tue, 21 Jul 2015 23:21:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87wpxslnse.fsf@kamboji.qca.qualcomm.com>
References: <1437527130-15232-1-git-send-email-mfaltesek@google.com> <87wpxslnse.fsf@kamboji.qca.qualcomm.com>
From: Avery Pennarun <apenwarr@google.com>
Date: Wed, 22 Jul 2015 02:21:27 -0400
Message-ID: <CAPp0ZBavC33umwjraqtxpKWP6Ez9X1_7K9fZNsP2oPu4v=uyEw@mail.gmail.com> (sfid-20150722_082150_991209_B34B4782)
Subject: Re: [PATCH] ath10k: Improve performance by reducing tx_lock contention.
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Marty Faltesek <mfaltesek@google.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Denton Gentry <dgentry@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 22, 2015 at 2:16 AM, Kalle Valo <kvalo@codeaurora.org> wrote:
> Marty Faltesek <mfaltesek@google.com> writes:
>> From: Qi Zhou <qizhou@google.com>
>>
>> During tx completion, tx_lock is held for longer than required, preventing
>> efficient refill of htt->pending_tx. Refactor the code so that only MSDU
>> related operations are protected by the lock.
>>
>> Improves downstream performance on a 3x3 client from 495 to 580 Mbps.
>
> It would be good to mention the actual platform/CPU as I guess this
> improvement is platform specific?

That's a good idea to mention in the commit message, although given
that it's just an in-driver lock contention patch, it probably affects
any underpowered multicore CPU.
