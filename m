Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:34432 "EHLO
        mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752648AbcKROtw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 Nov 2016 09:49:52 -0500
Received: by mail-wm0-f44.google.com with SMTP id u144so6312244wmu.1
        for <linux-wireless@vger.kernel.org>; Fri, 18 Nov 2016 06:49:52 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <5b62d41b-7125-f1ce-b09f-29db7572a748@gmail.com>
References: <1479141222-8493-1-git-send-email-erik.stromdahl@gmail.com>
 <1479141222-8493-5-git-send-email-erik.stromdahl@gmail.com>
 <CA+BoTQnTkwQjmNBdr8a+YauXffWGNBNyPTZ=RByoviTSp+1ZYQ@mail.gmail.com> <5b62d41b-7125-f1ce-b09f-29db7572a748@gmail.com>
From: Michal Kazior <michal.kazior@tieto.com>
Date: Fri, 18 Nov 2016 15:49:50 +0100
Message-ID: <CA+BoTQk8kov-fZ3CiTrVdfoevM=AmO-a2GK2PcGtLh6Ch2-x6g@mail.gmail.com> (sfid-20161118_155012_760355_59662FE6)
Subject: Re: [RFC 04/12] ath10k: htc: refactorization
To: Erik Stromdahl <erik.stromdahl@gmail.com>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 17 November 2016 at 17:32, Erik Stromdahl <erik.stromdahl@gmail.com> wro=
te:
>
>
> On 11/15/2016 11:19 AM, Michal Kazior wrote:
>> On 14 November 2016 at 17:33, Erik Stromdahl <erik.stromdahl@gmail.com> =
wrote:
>>> Code refactorization:
>>>
>>> Moved the code for ep 0 in ath10k_htc_rx_completion_handler
>>> to ath10k_htc_control_rx_complete.
>>>
>>> This eases the implementation of SDIO/mbox significantly since
>>> the ep_rx_complete cb is invoked directly from the SDIO/mbox
>>> hif layer.
>>>
>>> Since the ath10k_htc_control_rx_complete already is present
>>> (only containing a warning message) there is no reason for not
>>> using it (instead of having a special case for ep 0 in
>>> ath10k_htc_rx_completion_handler).
>>
>> This should be squashed with Patch 3 since it's inseparable part of
>> the same refactorization.
>>
>>
>> Micha=C5=82
>>
>
>
> Hmm, I don't really see why this is an inseparable part of the previous
> patch.
>
> As far as I see this patch has nothing to do with patch 3, or am I
> missing anything?
>
> Are you really sure they should be squashed?

Hmm.. on second thought this should be fine as it is.


Micha=C5=82
