Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:54233 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727738AbeIFPPC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Sep 2018 11:15:02 -0400
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Louie Lu <git@louie.lu>
Cc: kvalo@codeaurora.org, ath9k-devel@qca.qualcomm.com,
        davem@davemloft.net, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] ath9k: add reset for airtime station debugfs
In-Reply-To: <CADMDV=ws-iM6+L+CLyrGK=srV56jbYgBbOVWg2AxEX0gR6t8WQ@mail.gmail.com>
References: <20180906035323.GA11337@nems_nctu_lu> <877ejzynz9.fsf@toke.dk> <CADMDV=ws-iM6+L+CLyrGK=srV56jbYgBbOVWg2AxEX0gR6t8WQ@mail.gmail.com>
Date: Thu, 06 Sep 2018 12:40:10 +0200
Message-ID: <87sh2mykmt.fsf@toke.dk> (sfid-20180906_124017_573091_D08FB8CA)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Louie Lu <git@louie.lu> writes:

> Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk> =E6=96=BC 2018=E5=B9=B49=
=E6=9C=886=E6=97=A5 =E9=80=B1=E5=9B=9B =E4=B8=8B=E5=8D=885:27=E5=AF=AB=E9=
=81=93=EF=BC=9A
>
>> Louie Lu <git@louie.lu> writes:
>>
>> > Let user can reset station airtime status by debugfs, it will
>> > reset all airtime deficit to ATH_AIRTIME_QUANTUM and reset rx/tx
>> > airtime accumulate to 0.
>>
>> No objections to the patch, but I'm curious which issues you were
>> debugging that led you to needing it? :)
>>
> I'm testing to get the packet queue time + airtime in
> ath_tx_process_buffer,

Right; I've been thinking that it would be useful to make the CoDel
enqueue time available to drivers. And minstrel, for that matter
(lowering the number of retries for packets that has queued for a long
time, for instance). Good to hear that others are looking into something
similar :)

> it would be useful if I can reset the station airtime accumulated
> value, so I can observe in each test round (e.g. 5 ping) airtime
> accumulated
>
> Also to reset the deficit to make sure it run like fresh one.

Yup, makes sense.

-Toke
