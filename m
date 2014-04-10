Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:45996 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934714AbaDJIur convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Apr 2014 04:50:47 -0400
Received: by mail-wg0-f51.google.com with SMTP id k14so3597666wgh.34
        for <linux-wireless@vger.kernel.org>; Thu, 10 Apr 2014 01:50:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <53462B92.7010408@candelatech.com>
References: <1396611464-5940-1-git-send-email-michal.kazior@tieto.com>
	<1397040531-6224-1-git-send-email-michal.kazior@tieto.com>
	<5345BFA8.7040500@candelatech.com>
	<5345DE8F.2060808@candelatech.com>
	<CA+BoTQnorw7Z8ve9pvGY-RgZP2N+RWNd14Xa_yxM3q1+7ryNfw@mail.gmail.com>
	<53462B92.7010408@candelatech.com>
Date: Thu, 10 Apr 2014 10:50:46 +0200
Message-ID: <CA+BoTQ=kNdXRfnq+7ju2Bf7S_TfWPfchvRZ=PePdR4Y4_5mwuQ@mail.gmail.com> (sfid-20140410_105054_568939_C22C2073)
Subject: Re: [RFTv2 0/5] ath10k: ath10k: fix flushing and tx stalls
From: Michal Kazior <michal.kazior@tieto.com>
To: Ben Greear <greearb@candelatech.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10 April 2014 07:26, Ben Greear <greearb@candelatech.com> wrote:
> On 04/09/2014 10:10 PM, Michal Kazior wrote:
>> On 10 April 2014 01:58, Ben Greear <greearb@candelatech.com> wrote:
>>> ath10k: ep 2 got 1 credits tot 2
>>> sta219: send auth to 04:f0:21:03:38:99 (try 1/3) at: 1397086238.721985
>>> ath10k: ep 2 used 1 credits, remaining 1 dbg 1896910888 (0x71109028)
>>> ath10k: mac flushing peer 04:f0:21:03:38:99 on vdev 20 mgmt tid for
>>> unicast mgmt (204 msecs)
>>> ath10k: ep 2 used 1 credits, remaining 0 dbg 1896910878 (0x7110901e)
>>> ath10k: Creating vdev id: 22  map: 12582912
>>> ath10k: mac vdev create 22 (add interface) type 2 subtype 0
>>> sta219: send auth to 04:f0:21:03:38:99 (try 2/3) at: 1397086239.28088
>>> [firmware logging msg]
>>> ath10k: failed to create WMI vdev 22: -11
>>
>>
>> Hmm.. If I read this correctly it means that MGMT_TX and
>> PEER_FLUSH_TIDS commands are both stuck in firmware. This most likely
>> means firmware stops processing everything altogether. Having HTC
>> debug prints from ath10k_htc_notify_tx_completion() could provide more
>> insight perhaps. I suspect MGMT_TX is the trigger in all cases.
>>
>> I'm still suspicious of your firmware changes. You connect multiple
>> stations to the exact same AP. Is peer mapping working correctly? Are
>> tid queues mapped correctly in all cases? Perhaps there's some kind of
>> inconsistency that leads to this mess? I think firmware wasn't
>> originally designed to support your usecase. Or maybe firmware just
>> breaks when you try to run a hundred or so of vdevs :-D
>
>
> I have at least attempted to rectify all of that, but indeed this
> particular lockup seems like a firmware issue.  I personally suspect
> that I just find many bugs 32 times faster than simpler systems will :P
>
> The firmware has it's own sort of tx-to-host-credits logic, so if it runs
> out of space it might not be able to send any messages back to
> the host.  I've crawled through a lot of that code and didn't
> see any obvious ways to leak buffers, but it's far from simple
> code, so I could still be wrong.

I don't think that's the problem here.

Firmware seems to generate traffic to host while tx credits aren't
replenished (I've looked in traces you've send in the other email)
including wmi mgmt rx. From the traces it also looks like htc tx
completion is done for flush command suggesting it has been probably
processed by hif layer and maybe htc layer but there are no tx credits
replenished. There's even a ton of htt tx completion indications
although it seems new htt tx commands are never completed (in the
traces). This could suggest htt service is dead as well as wmi or it
just queues frames on a paused queue.

Tx credits for wmi should be replenished right away for all wmi
commands except mgmt tx and bcn tx (as they cannot be immediately
done). If tx credits are not replenished for flush command (which is
the case) it might not have reached the target wmi service at all.
>From what I understand this could happen if endpoint is paused but
this probably shouldn't happen as this is for wmi data path
synchronization apparently which is a legacy thing and should be hit.
Maybe there's a different way for wmi service to stop responding or to
prevent it from receiving and processing commands?


> Maybe I could add a small scratch area in firmware memory and place debug
> info there and read it from host over the PCI bus like when we
> dump the crash info...  This time of night I really hate firmware :P

Sounds reasonable to debug and pinpoint the cause of this problem.
Perhaps some counters to check if certain code paths are hit when you
expect them to be?


Michał
