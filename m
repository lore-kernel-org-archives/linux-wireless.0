Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f172.google.com ([209.85.220.172]:36746 "EHLO
        mail-qk0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751320AbcLEOFS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Dec 2016 09:05:18 -0500
Received: by mail-qk0-f172.google.com with SMTP id n21so346625874qka.3
        for <linux-wireless@vger.kernel.org>; Mon, 05 Dec 2016 06:05:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1480946188.31788.6.camel@sipsolutions.net>
References: <1480442753-6830-1-git-send-email-greearb@candelatech.com>
 <1480442753-6830-2-git-send-email-greearb@candelatech.com> <1480946188.31788.6.camel@sipsolutions.net>
From: Michal Kazior <michal.kazior@tieto.com>
Date: Mon, 5 Dec 2016 15:05:11 +0100
Message-ID: <CA+BoTQm2ttaFbFuH+Sx+FSP3_-B3hZKxFyOTSPMk12WbSQL32A@mail.gmail.com> (sfid-20161205_150522_724454_4A889A44)
Subject: Re: [PATCH 2/2] mac80211: put upper bound on txqi queue length.
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Ben Greear <greearb@candelatech.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 5 December 2016 at 14:56, Johannes Berg <johannes@sipsolutions.net> wrot=
e:
> On Tue, 2016-11-29 at 10:05 -0800, greearb@candelatech.com wrote:
>> From: Ben Greear <greearb@candelatech.com>
>>
>> This fixes OOM when using pktgen to drive a wifi station at more than
>> the station can transmit.  pktgen uses ndo_start_xmit instead of
>> going
>> through the queue layer, so it will not back off when the queues are
>> stopped, and would thus cause packets to be added to the txqi->queue
>> until the system goes OOM and crashes.
>>
>> Signed-off-by: Ben Greear <greearb@candelatech.com>
>> ---
>>
>> This is against 4.7.10+, not sure if it is actually needed in latest
>> kernel.
>
> One would hope that fq_tin_enqueue() does something like that, but
> anyway the patch doesn't apply so I'm dropping it.

fq_tin_enqueue() drops "fat" flow head packet upon reaching packet
count limit (8192) or memory limit (4 or 16 mbytes depending on vht
availability) whichever is hit first.


Micha=C5=82
