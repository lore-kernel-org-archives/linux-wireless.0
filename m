Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:50039 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932465Ab3CLSQR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Mar 2013 14:16:17 -0400
Message-ID: <513F70E5.2050004@candelatech.com> (sfid-20130312_191622_477521_01718479)
Date: Tue, 12 Mar 2013 11:16:05 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>
CC: Sujith Manoharan <sujith@msujith.org>,
	ath9k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org
Subject: Re: [ath9k-devel] [RFC] ath9k: Detect and work-around tx-queue hang.
References: <1361498797-14361-1-git-send-email-greearb@candelatech.com> <20774.62475.588131.344540@gargle.gargle.HOWL> <5126F732.6040007@candelatech.com> <20774.63702.208829.602903@gargle.gargle.HOWL> <51270186.6070003@candelatech.com> <51275837.4020708@openwrt.org> <20775.25545.671357.512930@gargle.gargle.HOWL> <512766B8.3030008@openwrt.org> <51276AA6.4000805@candelatech.com>
In-Reply-To: <51276AA6.4000805@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/22/2013 04:55 AM, Ben Greear wrote:
> On 02/22/2013 04:38 AM, Felix Fietkau wrote:
>> On 2013-02-22 1:25 PM, Sujith Manoharan wrote:
>>> Felix Fietkau wrote:
>>>> Please also check if the station(s) that the frames are queued for are
>>>> in powersave state for some reason. That would prevent the tx path from
>>>> throwing them in the hw queue, yet they'd still take up pending-frame
>>>> slots. I was planning on fixing this eventually by expiring frames that
>>>> stay in the queue for too long, but haven't decided on the exact
>>>> approach yet.
>>>
>>> PS is disabled for multi-VIF.
>> What about off-channel PS due to scans, etc.
>
> Scan is always locked to the same channel in this setup (once
> a single station is associated).
>
> The stations stay associated while this problem happens (the
> high-priority queue seems to work just fine, which may be
> the reason they stay associated just fine.)
>
> In some cases, I see packets delivered around 30 seconds late...
> aside from PS and off-channel..any idea what could make a packet
> stick around that long in the tx queues?

One of our customers on a 3.5.7+ kernel hit the problem without
using any RF attenuator...just over-the-air communication to
their AP.  It happened on both 2.4 and 5Ghz bands.  Seems rx
signal is around 40 in their environment. It took them around
24 hours to hit the problem on average.

Last we checked, we could fairly easily reproduce this in
our lab using an attenuator and a certain setup, so if there
is any debugging we could add to help narrow down what
might be causing this, we can give that a try.

For instance, is there any good way to know for certain
if packets in the queue are in power-save or not?  I know
we at least attempt to disable power-save, but possibly
it gets re-enabled somehow?

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

