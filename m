Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f171.google.com ([74.125.82.171]:58244 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755031AbaDGJG5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Apr 2014 05:06:57 -0400
Received: by mail-we0-f171.google.com with SMTP id t61so6436870wes.16
        for <linux-wireless@vger.kernel.org>; Mon, 07 Apr 2014 02:06:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <533EC686.40505@candelatech.com>
References: <1396611464-5940-1-git-send-email-michal.kazior@tieto.com>
	<533EC686.40505@candelatech.com>
Date: Mon, 7 Apr 2014 11:06:55 +0200
Message-ID: <CA+BoTQknr=Rh6izDWpsDTQM-8i=NJQA1nJomCcugD81pRPeXBw@mail.gmail.com> (sfid-20140407_110701_508599_F2873C59)
Subject: Re: [RFT 0/4] ath10k: fix flushing and tx stalls
From: Michal Kazior <michal.kazior@tieto.com>
To: Ben Greear <greearb@candelatech.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 4 April 2014 16:49, Ben Greear <greearb@candelatech.com> wrote:
> On 04/04/2014 04:37 AM, Michal Kazior wrote:
>>
>> Hi,
>>
>> After digging around I've found what seems to be
>> the problem with WMI Tx credit starvation and
>> inability to properly flush Tx in ath10k_flush().
>>
>> Long story short: if a client that was asleep (as
>> per what firmware thinks) goes out of range (or
>> just stops responding) then Tx rots in FW/HW
>> queues for a few seconds before it's discarded.
>> For WMI Tx credits this means management frames
>> eat up Tx credits for a few seconds (causing other
>> WMI commands to timeout and return -EAGAIN/-11).
>> For HTT Tx this means NullFunc frames would get
>> stuck for a few seconds before completion was
>> received.
>>
>> @Ben: Can you check if this helps you? I tested
>> this briefly and at least [1/4] seems fixes the
>> WMI Tx starvation. I'm hoping patches 2-4 help
>> with your ath10k_flush() failures which I haven't
>> been successfull in reproducing (but have observed
>> improvement with purging some frames out of FW/HW
>> queues).
>
>
> I'm out of office for a bit, but will test this as
> soon as I'm back.
>
> Thanks for looking into this!
>
> In general, would it make more sense to have a few more tx credits
> available to mitigate the slow-to-be-processed buffers?

Sure, we can disregard firmware telling us we have only 2 credits and
submit commands as we see fit. We can probably even get away with it
as long as we don't submit more than 2 WMI_MGMT_TX_CMDID commands
because it seems this is the only resource consuming command (requires
firmware to copy frame, keep it allocated and mapped for HW until
released on air). Beacons are already sent by reference. But I don't
think this is the solution.

The problem is there's no tx completion indication for
WMI_MGMT_TX_CMDID and you can't rely on tx credits replenishment for
that because (as per my observation) you have to submit an even number
of WMI_MGMT_TX_CMDID to get tx credits replenished. This means there's
no way of doing an educated timeout/flushing. This also means you can
get stuck with 2 credits and 2 frames being stuck in FW if destination
peer is unresponsive for up to 10 seconds.

Once you get stuck you can get a cascade of errors because WMI
commands time out after 3 seconds and if you're running AP you stop
beaconing because you can't even submit WMI_BCN_TX_CMDID.

Another way would be to prolong WMI command timeout to ~11 seconds...
at least for the "tx credits being stuck" problem.


Michał
