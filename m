Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:36592 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730204AbeG0NzV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 27 Jul 2018 09:55:21 -0400
Received: by mail-qt0-f195.google.com with SMTP id t5-v6so4816865qtn.3
        for <linux-wireless@vger.kernel.org>; Fri, 27 Jul 2018 05:33:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <6715f59dc8e834cddd701c6f9ee9f344@codeaurora.org>
References: <1532589677-16428-1-git-send-email-wgong@codeaurora.org>
 <1532589677-16428-3-git-send-email-wgong@codeaurora.org> <87zhye1aqg.fsf@toke.dk>
 <CABvG-CVwRyeD5=0HqTyNQPVOV1iPtAT_GJQSmSH4=DdDca6dYw@mail.gmail.com> <6715f59dc8e834cddd701c6f9ee9f344@codeaurora.org>
From: =?UTF-8?Q?Micha=C5=82_Kazior?= <kazikcz@gmail.com>
Date: Fri, 27 Jul 2018 14:33:35 +0200
Message-ID: <CABvG-CUpcK=NbC1DaNw330W4YKwH7vb0ZFwPeWt20ODUa+QyXQ@mail.gmail.com> (sfid-20180727_143340_362759_4A12ECAF)
Subject: Re: [PATCH 2/2] ath10k: Set sk_pacing_shift to 6 for 11AC WiFi chips
To: Wen Gong <wgong@codeaurora.org>
Cc: =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@toke.dk>,
        ath10k@lists.infradead.org,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 27 July 2018 at 11:39, Wen Gong <wgong@codeaurora.org> wrote:
> On 2018-07-26 21:02, Micha=C5=82 Kazior wrote:
>>
>> On 26 July 2018 at 13:45, Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk=
> wrote:
>>>
>>> Wen Gong <wgong@codeaurora.org> writes:
>>>
>>>> Upstream kernel has an interface to help adjust sk_pacing_shift to hel=
p
>>>> improve TCP UL throughput.
>>>> The sk_pacing_shift is 8 in mac80211, this is based on test with 11N
>>>> WiFi chips with ath9k. For QCA6174/QCA9377 PCI 11AC chips, the 11AC
>>>> VHT80 TCP UL throughput testing result shows 6 is the optimal.
>>>> Overwrite the sk_pacing_shift to 6 in ath10k driver.
>>>
>>>
>>> When I tested this, a pacing shift of 8 was quite close to optimal as
>>> well for ath10k. Why are you getting different results?
>>>
>>>> Tested with QCA6174 PCI with firmware
>>>> WLAN.RM.4.4.1-00109-QCARMSWPZ-1, but this will also affect QCA9377 PCI=
.
>>>> It's not a regression with new firmware releases.
>>>>
>>>> There have 2 test result of different settings:
>>>>
>>>> ARM CPU based device with QCA6174A PCI with different
>>>> sk_pacing_shift:
>>
>>
>> Different firmware releases have different tx buffering
>> characteristics. In some 10.2 firmware running on QCA9888 you can have
>> up to 5ms of delayed aggregation. Ideally sk_pacing_shift should be
>> adjusted per firmware release. Maybe this should become part of the
>> ath10k firmware wrapping "fw features" stuff?
>>
> recently we do not want to do like this since no test data for each
> firmware.

All the more reason to *not* change the pacing shift from 8 to 6 for
entire ath10k because you have no idea what impact that is going to
have on other chips/firmwares, e.g. QCA4019, QCA9888X, QCA9984.


Micha=C5=82
