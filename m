Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:36016 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752981AbbCRUS5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Mar 2015 16:18:57 -0400
Message-ID: <5509DDAF.80706@openwrt.org> (sfid-20150318_211900_911381_6BAC8F9D)
Date: Wed, 18 Mar 2015 21:18:55 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v4] mac80211: add an intermediate software queue implementation
References: <1426609283-83954-1-git-send-email-nbd@openwrt.org>	 <1426707672.3001.39.camel@sipsolutions.net> <5509DA00.6030002@openwrt.org> <1426709222.3001.42.camel@sipsolutions.net>
In-Reply-To: <1426709222.3001.42.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2015-03-18 21:07, Johannes Berg wrote:
> On Wed, 2015-03-18 at 21:03 +0100, Felix Fietkau wrote:
>> On 2015-03-18 20:41, Johannes Berg wrote:
>> >> + * The driver is expected to release its own buffered frames and also call
>> >> + * ieee80211_tx_dequeue() within that callback.
>> > 
>> > Perhaps that should read
>> > "The driver is expected to release its own buffered frames (if any) and
>> > request the remaining dequeued frames by calling
>> > ieee80211_tx_dequeue()."
>> > 
>> > I'm not really sure it needs to be within that callback? I see no
>> > particular reason for that.
>> Releasing multiple packets works, even if there is only one packet
>> buffered in the driver and the rest in the txq. It also keeps the code
>> more consistent.
> 
> Right. I still phrased that badly. I meant that the "also" should be
> limited by the number of frames really needed, i.e. use driver-buffered
> first and fill up with any mac80211-buffered by dequeuing. That's
> probably obvious enough though.
> 
> Anyway - not sure it needs to be in the callback?
I think it makes things simpler this way. What would you prefer?

>> If I don't lock here, one last dequeue call might still be running on
>> another CPU. This would produce a theoretical race in accessing the
>> sequence number, which the caller of this function reads before setting
>> up the BA request.
>> Dequeueing happens outside of the normal network stack tx context, so
>> synchronize_net is not enough.
> 
> Ah, makes sense, I didn't think of the seqno. Can you please put that in
> a comment somewhere? :)
Sure.

- Felix
