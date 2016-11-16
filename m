Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f41.google.com ([209.85.218.41]:34874 "EHLO
        mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751572AbcKPPyZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 Nov 2016 10:54:25 -0500
Received: by mail-oi0-f41.google.com with SMTP id b126so27026341oia.2
        for <linux-wireless@vger.kernel.org>; Wed, 16 Nov 2016 07:54:25 -0800 (PST)
Received: from mail-oi0-f44.google.com (mail-oi0-f44.google.com. [209.85.218.44])
        by smtp.gmail.com with ESMTPSA id n65sm10518724oif.24.2016.11.16.07.54.24
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 16 Nov 2016 07:54:24 -0800 (PST)
Received: by mail-oi0-f44.google.com with SMTP id v84so64557421oie.3
        for <linux-wireless@vger.kernel.org>; Wed, 16 Nov 2016 07:54:24 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20161116120213.GB26475@redhat.com>
References: <1478095865-8651-1-git-send-email-sgruszka@redhat.com>
 <1478095865-8651-6-git-send-email-sgruszka@redhat.com> <ebc4779b-a68b-f3b3-c8fc-87db9401a603@kresin.me>
 <20161114084536.GB12372@redhat.com> <20161114124323.GA31857@redhat.com>
 <e4dfaa30-7dd6-c485-3e30-71bfafbc1502@kresin.me> <20161116120213.GB26475@redhat.com>
From: Mathias Kresin <dev@kresin.me>
Date: Wed, 16 Nov 2016 16:54:03 +0100
Message-ID: <CABwW5nnxnEHDQhytZvMsnBubEnm=FYGUWF0NE=3FbUeMJZHoVQ@mail.gmail.com> (sfid-20161116_165429_110247_11104A63)
Subject: Re: [PATCH 05/10] rt2800: make ba_size depend on ampdu_factor
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        Felix Fietkau <nbd@nbd.name>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2016-11-16 13:02 GMT+01:00 Stanislaw Gruszka <sgruszka@redhat.com>:
> On Wed, Nov 16, 2016 at 09:07:00AM +0100, Mathias Kresin wrote:
>> Here are the results of the requested tests. Please keep in mind, I'm not in
>> a lab environment:
>>
>> LEDE head
>>   connect
>>     action 0 sta 9c:f3:87:bc:AA:BB tid 6 buf_size 64 ampdu_factor 3
>>     action 2 sta 9c:f3:87:bc:AA:BB tid 0 buf_size 0 ampdu_factor 3
>>     action 6 sta 9c:f3:87:bc:AA:BB tid 0 buf_size 64 ampdu_factor 3
>>     action 0 sta 9c:f3:87:bc:AA:BB tid 0 buf_size 64 ampdu_factor 3
>
> No problem here - buf_size corresponds to ampdu_factor.
>
>>     ieee80211 phy0: rt2x00queue_flush_queue: Warning - Queue 2 failed
>>                     to flush
>>     ieee80211 phy0: rt2x00queue_flush_queue: Warning - Queue 2 failed
>>                     to flush
>
> I think we do not give device enough time to post AMPDU consisted
> with bigger amount of frames. If we want to increase ba_size we will
> need also some other changes in the driver. Anyway I already request
> Kalle to drop this patch. I assume other patches do not cause
> regression for you, correct?


Correct. Just 05/10 caused issues.
