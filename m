Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp2.u-psud.fr ([129.175.33.42]:49786 "EHLO smtp2.u-psud.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758159Ab2IROrW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Sep 2012 10:47:22 -0400
Message-ID: <5058899F.1090906@lri.fr> (sfid-20120918_164729_003989_13E861C1)
Date: Tue, 18 Sep 2012 16:47:59 +0200
From: Nicolas Cavallari <Nicolas.Cavallari@lri.fr>
MIME-Version: 1.0
To: Sujith Manoharan <c_manoha@qualcomm.com>
CC: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Subject: Re: [ath9k-devel] ath9k: spurious queue reset (beacon stuck) when
 joining an IBSS.
References: <50582CF8.4020608@lri.fr> <5058737E.4090601@lri.fr> <20568.31520.887555.183389@gargle.gargle.HOWL>
In-Reply-To: <20568.31520.887555.183389@gargle.gargle.HOWL>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 18/09/2012 15:46, Sujith Manoharan wrote:
> Nicolas Cavallari wrote:
>> With an AR9382 (well, i think, its PCI-id is 168c:0030 rev 1/168c:3116),
>> each time I join an IBSS network, the driver repeatedly
>> resets the queue for a while, because of too many missed beacons.  After
>> some time, this stops and the card behave normally.  But many packets
>> are lost in the process.
>>
>> The problem seems to aggravate when the number of IBSS nodes is higher :
>> When joining a IBSS network with only one node, Only a few (e.g. 4)
>> beacons are lost, and no reset takes places. When joining an IBSS
>> network with two nodes, the queues can be reset up to 224 times in 20
>> seconds. When joining large IBSS networks, it sometimes never stop
>> resetting.  Occasionally, when resetting, the driver fails to reset TX DMA
>>
>> If i hack the driver to not reset when the beacon is stuck, the beacon
>> tx resumes quickly by itself after 80-200 misses and the network seems
>> to work normally (if not better). On large&clogged ad-hoc networks, the
>> card sometimes miss between 1 and 80 beacons, but it might be due to
>> background scanning i think.
>>
>> What could be the problem here ? is ad-hoc beaconing kind of broken ?
>> I do not have the problem with AR9285.
> 
> I think the problem is that we are programming the beacon timers based on
> the beacon interval right after joining, but we base it on the HW TSF which
> has just been reset. We should be updating the timers based on the TSF after a
> HW sync has been done with a received beacon. This is being done for station
> mode, but IBSS mode is missing this.
> 
> Here is a very rough patch, it abuses STA-mode flags and doesn't differentiate
> between creator/joiner mode, but can you check if it makes any difference ?

With this patch, i see no beacon miss in the logs when joining a large
ad-hoc network. So yes, it does make a difference! haven't tested what
happens when creating an IBSS with or without this patch yet.

Thanks.
