Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:62306 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754597Ab0KBSML convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Nov 2010 14:12:11 -0400
Received: by iwn10 with SMTP id 10so8658920iwn.19
        for <linux-wireless@vger.kernel.org>; Tue, 02 Nov 2010 11:12:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4CD046D2.4080703@openwrt.org>
References: <alpine.DEB.2.00.1011021655080.23045@vtdt3>
	<4CD046D2.4080703@openwrt.org>
Date: Tue, 2 Nov 2010 19:12:10 +0100
Message-ID: <AANLkTi=oMPqrPte+KHCpt_YGsZjLgNxWUNYPWQPY6J2e@mail.gmail.com>
Subject: Re: [ath9k-devel] [RFC] ath9k: fix tx queue selection
From: =?ISO-8859-1?Q?Bj=F6rn_Smedman?= <bjorn.smedman@venatech.se>
To: Felix Fietkau <nbd@openwrt.org>
Cc: ath9k-devel@lists.ath9k.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/11/2 Felix Fietkau <nbd@openwrt.org>:
> On 2010-11-02 5:13 PM, Björn Smedman wrote:
>> Hi all,
>>
>> The following patch attempts to fix some problems with ath9k tx queue
>> selection:
>>
>> 1. There was a posible mismatch between the queue selected for QoS packets
>> (on which locking, queue start/stop and statistics where performed) and
>> the queue actually used for TX. This is fixed by selecting the tx queue
>> based on the TID of the 802.11 header for this type of packet.
> This should not be necessary. mac80211 should take care of queue
> selection properly for QoS frames. If it doesn't, then that is the bug
> that needs to be fixed...

The problem is rather that ath9k sets up its own skb -> txq mapping by
tying the txq to the tid (tid -> ac -> txq). To understand better ask
the question, should mac80211 be allowed to set the queue mapping to 1
but the qos data tid to 5? If the answer is yes then ath9k is broken.
Even if the answer is no I don't really like that ath9k will corrupt
DMA if somebody changes the queue mapping / tid logic in mac80211...

I agree however that there are better solutions (that's why the
subject says RFC). If you want to honor the mapping set up by mac80211
then it might be better to break the connection tid ---> ac -X-> txq
in xmit.c so that ampdu frames are always tx:ed on the queue in
txctl->txq. However, that is not trivial to do since the aggregation
logic depends on scheduling new aggregates from ath_tx_processq().

>> 2. Even with the above fix there was still a risk of mac80211 queue
>> "deadlock" because the queue to stop was selected on the basis of the skb
>> queue mapping whereas the queue to start was selected based on the hardware
>> tx queue to mac80211 queue mapping. These may not in all situations be one
>> and the same.
> Instead of working around this, we need to make sure that those are
> always identical.

But they cannot be... If we have for example hardware with only one tx
queue then it is impossible to use the hw queue to mac80211 queue
mapping. I see some comments here and there about such chipsets. In
general I think we should assume mac80211 can have more queues than
hardware, no?

>> This patch is against latest wireless-testing but I've only tested it
>> against compat-wireless-2010-10-19 with openwrt patches on top (including
>> Luis latest pcu lock patch) and some other patches I'm working on. If you
>> can run wireless-testing directly, please give it a spin. For me it's a
>> big improvement in stability under high tx/rx load.
>>
>> Any thoughts?
> Let's do a thorough review of the tx path and figure out where the
> mismatch is actually coming from.

It's quite complex but if you read through mac80211 and ath9k you will
see the fundamental problem is that you cannot be sure that

#define TID_TO_WME_AC(_tid)                             \
        ((((_tid) == 0) || ((_tid) == 3)) ? WME_AC_BE : \
         (((_tid) == 1) || ((_tid) == 2)) ? WME_AC_BK : \
         (((_tid) == 4) || ((_tid) == 5)) ? WME_AC_VI : \
         WME_AC_VO)

will give you the same tid -> txq mapping as (some function of)
skb_get_queue_mapping(). Or maybe you can, but then you should at
least do something better than break DMA locking when that assumption
yet again becomes false.

> - Felix

/Björn
