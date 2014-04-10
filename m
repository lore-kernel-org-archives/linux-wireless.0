Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:41023 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934575AbaDJF1N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Apr 2014 01:27:13 -0400
Message-ID: <53462B92.7010408@candelatech.com> (sfid-20140410_072717_777588_E7753889)
Date: Wed, 09 Apr 2014 22:26:42 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Michal Kazior <michal.kazior@tieto.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [RFTv2 0/5] ath10k: ath10k: fix flushing and tx stalls
References: <1396611464-5940-1-git-send-email-michal.kazior@tieto.com>	<1397040531-6224-1-git-send-email-michal.kazior@tieto.com>	<5345BFA8.7040500@candelatech.com>	<5345DE8F.2060808@candelatech.com> <CA+BoTQnorw7Z8ve9pvGY-RgZP2N+RWNd14Xa_yxM3q1+7ryNfw@mail.gmail.com>
In-Reply-To: <CA+BoTQnorw7Z8ve9pvGY-RgZP2N+RWNd14Xa_yxM3q1+7ryNfw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/09/2014 10:10 PM, Michal Kazior wrote:
> On 10 April 2014 01:58, Ben Greear <greearb@candelatech.com> wrote:
>> On 04/09/2014 02:46 PM, Ben Greear wrote:
>>> Here's another log snippet with these 5 patches (and lots more
>>> mostly non ath10k patches of my own) applied:
>>
>> And another one, this time with more debugging enabled.
>> The 0x7110XXXX numbers indicate the command-id (the XXXX part
>> is the cmd id).
>>
>> After this below, I see a debug-log message come from
>> the firmware, and then nothing else.  I had added a sort
>> of keep-alive message in the firmware, and I do not see that
>> in my logs, so probably firmware is wedged in such a way that
>> it cannot or will not send packets to the host at this point.
>>
>> I had chased this sort of problem previously, and ended up
>> with a hack to reset firmware when the flush failed twice.
>> I backed that out when applying your patches, but I guess
>> it is still needed.
>
> Then this looks like a different issue from what I've been trying to
> fix actually.
>
> In my case when acting as AP it's possible to get WMI mgmt tx frames
> stuck in FW queues when sleeping client stops responding for about 10
> seconds. If you use up all tx credits (the multitude of 2 that there
> are :-) beaconing stops and everything just fails.

I see them stuck for a long while in STA mode too, but usually
it recovers.  I tried finding where in firmware I could increase
the tx-credits to 4 or something, but had no luck...tis a twisty
maze.


>> ath10k: ep 2 got 1 credits tot 2
>> ath10k: mac vdev 20 start 04:f0:21:03:38:99
>> ath10k: mac vdev 20 start center_freq 5180 phymode 11ac-vht80
>
>> ath10k: ep 2 used 1 credits, remaining 1 dbg 1896910867 (0x71109013)
>
> I suppose this print is located in ath10k_htc_send()?

Yes, right after decrementing credits.

>> ath10k: ep 2 got 1 credits tot 2
>> sta219: send auth to 04:f0:21:03:38:99 (try 1/3) at: 1397086238.721985
>> ath10k: ep 2 used 1 credits, remaining 1 dbg 1896910888 (0x71109028)
>> ath10k: mac flushing peer 04:f0:21:03:38:99 on vdev 20 mgmt tid for unicast mgmt (204 msecs)
>> ath10k: ep 2 used 1 credits, remaining 0 dbg 1896910878 (0x7110901e)
>> ath10k: Creating vdev id: 22  map: 12582912
>> ath10k: mac vdev create 22 (add interface) type 2 subtype 0
>> sta219: send auth to 04:f0:21:03:38:99 (try 2/3) at: 1397086239.28088
>> [firmware logging msg]
>> ath10k: failed to create WMI vdev 22: -11
>
> Hmm.. If I read this correctly it means that MGMT_TX and
> PEER_FLUSH_TIDS commands are both stuck in firmware. This most likely
> means firmware stops processing everything altogether. Having HTC
> debug prints from ath10k_htc_notify_tx_completion() could provide more
> insight perhaps. I suspect MGMT_TX is the trigger in all cases.
>
> I'm still suspicious of your firmware changes. You connect multiple
> stations to the exact same AP. Is peer mapping working correctly? Are
> tid queues mapped correctly in all cases? Perhaps there's some kind of
> inconsistency that leads to this mess? I think firmware wasn't
> originally designed to support your usecase. Or maybe firmware just
> breaks when you try to run a hundred or so of vdevs :-D

I have at least attempted to rectify all of that, but indeed this
particular lockup seems like a firmware issue.  I personally suspect
that I just find many bugs 32 times faster than simpler systems will :P

The firmware has it's own sort of tx-to-host-credits logic, so if it runs
out of space it might not be able to send any messages back to
the host.  I've crawled through a lot of that code and didn't
see any obvious ways to leak buffers, but it's far from simple
code, so I could still be wrong.

Maybe I could add a small scratch area in firmware memory and place debug
info there and read it from host over the PCI bus like when we
dump the crash info...  This time of night I really hate firmware :P

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

