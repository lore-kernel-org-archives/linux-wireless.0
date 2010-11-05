Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:36965 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753186Ab0KET02 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Nov 2010 15:26:28 -0400
Message-ID: <4CD45A5C.1050307@openwrt.org>
Date: Fri, 05 Nov 2010 20:26:20 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Bj=F6rn_Smedman?= <bjorn.smedman@venatech.se>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Ben Greear <greearb@candelatech.com>
Subject: Re: [PATCH] ath9k: rework tx queue selection and fix queue stopping/waking
References: <4CD2AC85.1090806@openwrt.org> <AANLkTi=Qz1Px=wJBL+1TdsTN0EnJ0WOY_kf-XMNf=Vtp@mail.gmail.com>
In-Reply-To: <AANLkTi=Qz1Px=wJBL+1TdsTN0EnJ0WOY_kf-XMNf=Vtp@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-11-05 12:35 PM, Björn Smedman wrote:
> On Thu, Nov 4, 2010 at 1:52 PM, Felix Fietkau <nbd@openwrt.org> wrote:
>> The main source of these issues is that in some places the queue is
>> selected via skb queue mapping in places where this mapping may no
>> longer be valid. One such place is when data frames are transmitted via
>> the CAB queue (for powersave buffered frames). This is made even worse
>> by a lookup WMM AC values from the assigned tx queue (which is
>> undefined for the CAB queue).
>>
>> This messed up the pending frame counting, which in turn caused issues
>> with queues getting stopped, but not woken again.
> 
> I took another look and isn't there one more way we can put the queue
> to sleep forever: if the mac80211 queue is stopped and the ath9k txq
> then drained for some reason. Could there be some other way skbs can
> leave the tx pipeline without the mac80211 queue getting woken up
> again?
The only place where I can see this happening is on a channel change.
This can be fixed by implementing the flush() driver op, but I think
that should be done in a separate patch later.
A flush triggered by a hardware reset (due to some stuck condition or bb
lockup) is safe, because that wakes the queues after the reset.

>> To ensure consistency wrt. pending frame count tracking, these counters
>> are moved to the ath_txq struct, updated with the txq lock held, but
>> only where the tx queue selected by the skb queue map actually matches
>> the tx queue used by the driver for the frame.
> 
> I was thinking. Now we check for counting imbalance in one direction
> (down) and actually found something if I understand correctly. Would
> it be possible to check the catastropic case as well, i.e. that we are
> off in the upward direction so that pending_frames stays so high that
> mac80211 queues lock up forever? Perhaps when we drain the txq or
> unload the driver or something we could do a WARN_ON(pending_frames !=
> 0)?
I guess we could do that, but unloading the driver isn't usually done
very often ;)
We might as well just add the pending frame count to the debugfs xmit
entry later...

- Felix
