Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:59901 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932768AbeEHPIK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 May 2018 11:08:10 -0400
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Kalle Valo <kvalo@codeaurora.org>,
        Jia-Ju Bai <baijiaju1990@gmail.com>
Cc: ath9k-devel@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: wireless: ath: ath9k: Fix a possible data race in ath_chanctx_set_next
In-Reply-To: <87o9hqxktc.fsf@kamboji.qca.qualcomm.com>
References: <20180508080636.13827-1-baijiaju1990@gmail.com> <87o9hqxktc.fsf@kamboji.qca.qualcomm.com>
Date: Tue, 08 May 2018 17:08:08 +0200
Message-ID: <87h8ni423r.fsf@toke.dk> (sfid-20180508_170830_799829_79C1D1E3)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@codeaurora.org> writes:

> Jia-Ju Bai <baijiaju1990@gmail.com> writes:
>
>> The write operation to "sc->next_chan" is protected by
>> the lock on line 1287, but the read operation to
>> this data on line 1262 is not protected by the lock.
>> Thus, there may exist a data race for "sc->next_chan".
>>
>> To fix this data race, the read operation to "sc->next_chan" 
>> should be also protected by the lock.
>>
>> Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
>
> I need this reviewed by someone else before I'm willing to take it.

Only possible issue I can see is that it puts a call to
getrawmonotonic() under the spinlock. Not sure if that has any bad
implications...

-Toke
