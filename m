Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f173.google.com ([74.125.82.173]:59663 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933353AbaDJFKg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Apr 2014 01:10:36 -0400
Received: by mail-we0-f173.google.com with SMTP id w61so3392319wes.18
        for <linux-wireless@vger.kernel.org>; Wed, 09 Apr 2014 22:10:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5345DE8F.2060808@candelatech.com>
References: <1396611464-5940-1-git-send-email-michal.kazior@tieto.com>
	<1397040531-6224-1-git-send-email-michal.kazior@tieto.com>
	<5345BFA8.7040500@candelatech.com>
	<5345DE8F.2060808@candelatech.com>
Date: Thu, 10 Apr 2014 07:10:34 +0200
Message-ID: <CA+BoTQnorw7Z8ve9pvGY-RgZP2N+RWNd14Xa_yxM3q1+7ryNfw@mail.gmail.com> (sfid-20140410_071043_142120_701E2F69)
Subject: Re: [RFTv2 0/5] ath10k: ath10k: fix flushing and tx stalls
From: Michal Kazior <michal.kazior@tieto.com>
To: Ben Greear <greearb@candelatech.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10 April 2014 01:58, Ben Greear <greearb@candelatech.com> wrote:
> On 04/09/2014 02:46 PM, Ben Greear wrote:
>> Here's another log snippet with these 5 patches (and lots more
>> mostly non ath10k patches of my own) applied:
>
> And another one, this time with more debugging enabled.
> The 0x7110XXXX numbers indicate the command-id (the XXXX part
> is the cmd id).
>
> After this below, I see a debug-log message come from
> the firmware, and then nothing else.  I had added a sort
> of keep-alive message in the firmware, and I do not see that
> in my logs, so probably firmware is wedged in such a way that
> it cannot or will not send packets to the host at this point.
>
> I had chased this sort of problem previously, and ended up
> with a hack to reset firmware when the flush failed twice.
> I backed that out when applying your patches, but I guess
> it is still needed.

Then this looks like a different issue from what I've been trying to
fix actually.

In my case when acting as AP it's possible to get WMI mgmt tx frames
stuck in FW queues when sleeping client stops responding for about 10
seconds. If you use up all tx credits (the multitude of 2 that there
are :-) beaconing stops and everything just fails.


> ath10k: ep 2 got 1 credits tot 2
> ath10k: mac vdev 20 start 04:f0:21:03:38:99
> ath10k: mac vdev 20 start center_freq 5180 phymode 11ac-vht80

> ath10k: ep 2 used 1 credits, remaining 1 dbg 1896910867 (0x71109013)

I suppose this print is located in ath10k_htc_send()?


> ath10k: ep 2 got 1 credits tot 2
> sta219: send auth to 04:f0:21:03:38:99 (try 1/3) at: 1397086238.721985
> ath10k: ep 2 used 1 credits, remaining 1 dbg 1896910888 (0x71109028)
> ath10k: mac flushing peer 04:f0:21:03:38:99 on vdev 20 mgmt tid for unicast mgmt (204 msecs)
> ath10k: ep 2 used 1 credits, remaining 0 dbg 1896910878 (0x7110901e)
> ath10k: Creating vdev id: 22  map: 12582912
> ath10k: mac vdev create 22 (add interface) type 2 subtype 0
> sta219: send auth to 04:f0:21:03:38:99 (try 2/3) at: 1397086239.28088
> [firmware logging msg]
> ath10k: failed to create WMI vdev 22: -11

Hmm.. If I read this correctly it means that MGMT_TX and
PEER_FLUSH_TIDS commands are both stuck in firmware. This most likely
means firmware stops processing everything altogether. Having HTC
debug prints from ath10k_htc_notify_tx_completion() could provide more
insight perhaps. I suspect MGMT_TX is the trigger in all cases.

I'm still suspicious of your firmware changes. You connect multiple
stations to the exact same AP. Is peer mapping working correctly? Are
tid queues mapped correctly in all cases? Perhaps there's some kind of
inconsistency that leads to this mess? I think firmware wasn't
originally designed to support your usecase. Or maybe firmware just
breaks when you try to run a hundred or so of vdevs :-D


Michał
