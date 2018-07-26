Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f175.google.com ([209.85.216.175]:37584 "EHLO
        mail-qt0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729902AbeGZOTl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 26 Jul 2018 10:19:41 -0400
Received: by mail-qt0-f175.google.com with SMTP id n6-v6so1409190qtl.4
        for <linux-wireless@vger.kernel.org>; Thu, 26 Jul 2018 06:02:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87zhye1aqg.fsf@toke.dk>
References: <1532589677-16428-1-git-send-email-wgong@codeaurora.org>
 <1532589677-16428-3-git-send-email-wgong@codeaurora.org> <87zhye1aqg.fsf@toke.dk>
From: =?UTF-8?Q?Micha=C5=82_Kazior?= <kazikcz@gmail.com>
Date: Thu, 26 Jul 2018 15:02:53 +0200
Message-ID: <CABvG-CVwRyeD5=0HqTyNQPVOV1iPtAT_GJQSmSH4=DdDca6dYw@mail.gmail.com> (sfid-20180726_150257_466520_5B823EC4)
Subject: Re: [PATCH 2/2] ath10k: Set sk_pacing_shift to 6 for 11AC WiFi chips
To: =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@toke.dk>
Cc: Wen Gong <wgong@codeaurora.org>, ath10k@lists.infradead.org,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 26 July 2018 at 13:45, Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk> w=
rote:
> Wen Gong <wgong@codeaurora.org> writes:
>
>> Upstream kernel has an interface to help adjust sk_pacing_shift to help
>> improve TCP UL throughput.
>> The sk_pacing_shift is 8 in mac80211, this is based on test with 11N
>> WiFi chips with ath9k. For QCA6174/QCA9377 PCI 11AC chips, the 11AC
>> VHT80 TCP UL throughput testing result shows 6 is the optimal.
>> Overwrite the sk_pacing_shift to 6 in ath10k driver.
>
> When I tested this, a pacing shift of 8 was quite close to optimal as
> well for ath10k. Why are you getting different results?
>
>> Tested with QCA6174 PCI with firmware
>> WLAN.RM.4.4.1-00109-QCARMSWPZ-1, but this will also affect QCA9377 PCI.
>> It's not a regression with new firmware releases.
>>
>> There have 2 test result of different settings:
>>
>> ARM CPU based device with QCA6174A PCI with different
>> sk_pacing_shift:

Different firmware releases have different tx buffering
characteristics. In some 10.2 firmware running on QCA9888 you can have
up to 5ms of delayed aggregation. Ideally sk_pacing_shift should be
adjusted per firmware release. Maybe this should become part of the
ath10k firmware wrapping "fw features" stuff?


Micha=C5=82
