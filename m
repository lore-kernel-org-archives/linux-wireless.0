Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:54570 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730244AbeG0LAt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 27 Jul 2018 07:00:49 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Fri, 27 Jul 2018 17:39:44 +0800
From: Wen Gong <wgong@codeaurora.org>
To: =?UTF-8?Q?Micha=C5=82_Kazior?= <kazikcz@gmail.com>
Cc: =?UTF-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        ath10k@lists.infradead.org,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/2] ath10k: Set sk_pacing_shift to 6 for 11AC WiFi chips
In-Reply-To: <CABvG-CVwRyeD5=0HqTyNQPVOV1iPtAT_GJQSmSH4=DdDca6dYw@mail.gmail.com>
References: <1532589677-16428-1-git-send-email-wgong@codeaurora.org>
 <1532589677-16428-3-git-send-email-wgong@codeaurora.org>
 <87zhye1aqg.fsf@toke.dk>
 <CABvG-CVwRyeD5=0HqTyNQPVOV1iPtAT_GJQSmSH4=DdDca6dYw@mail.gmail.com>
Message-ID: <6715f59dc8e834cddd701c6f9ee9f344@codeaurora.org> (sfid-20180727_113948_690480_29642F66)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-07-26 21:02, Michał Kazior wrote:
> On 26 July 2018 at 13:45, Toke Høiland-Jørgensen <toke@toke.dk> wrote:
>> Wen Gong <wgong@codeaurora.org> writes:
>> 
>>> Upstream kernel has an interface to help adjust sk_pacing_shift to 
>>> help
>>> improve TCP UL throughput.
>>> The sk_pacing_shift is 8 in mac80211, this is based on test with 11N
>>> WiFi chips with ath9k. For QCA6174/QCA9377 PCI 11AC chips, the 11AC
>>> VHT80 TCP UL throughput testing result shows 6 is the optimal.
>>> Overwrite the sk_pacing_shift to 6 in ath10k driver.
>> 
>> When I tested this, a pacing shift of 8 was quite close to optimal as
>> well for ath10k. Why are you getting different results?
>> 
>>> Tested with QCA6174 PCI with firmware
>>> WLAN.RM.4.4.1-00109-QCARMSWPZ-1, but this will also affect QCA9377 
>>> PCI.
>>> It's not a regression with new firmware releases.
>>> 
>>> There have 2 test result of different settings:
>>> 
>>> ARM CPU based device with QCA6174A PCI with different
>>> sk_pacing_shift:
> 
> Different firmware releases have different tx buffering
> characteristics. In some 10.2 firmware running on QCA9888 you can have
> up to 5ms of delayed aggregation. Ideally sk_pacing_shift should be
> adjusted per firmware release. Maybe this should become part of the
> ath10k firmware wrapping "fw features" stuff?
> 
recently we do not want to do like this since no test data for each 
firmware.
> 
> Michał
