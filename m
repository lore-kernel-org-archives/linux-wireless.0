Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:42901 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726008AbeIEQKg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Sep 2018 12:10:36 -0400
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
Cc: Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH] mac80211: TDLS: fix skb queue/priority assignment
In-Reply-To: <1536147453.3528.11.camel@sipsolutions.net>
References: <20180905113402.7665-1-johannes@sipsolutions.net> <1536147453.3528.11.camel@sipsolutions.net>
Date: Wed, 05 Sep 2018 13:40:43 +0200
Message-ID: <87k1o05g04.fsf@toke.dk> (sfid-20180905_134050_407059_0CDDF5C2)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Wed, 2018-09-05 at 13:34 +0200, Johannes Berg wrote:
>> From: Johannes Berg <johannes.berg@intel.com>
>> 
>> If the TDLS setup happens over a connection to an AP that
>> doesn't have QoS, we nevertheless assign a non-zero TID
>> (skb->priority) and queue mapping, which may confuse us or
>> drivers later.
>> 
>> Fix it by just assigning the special skb->priority and then
>> using ieee80211_select_queue() just like other data frames
>> would go through.
>> 
>> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
>> ---
>> OK, this addresses the case I was worried about - perhaps
>> better take this than the txq patch?

(This is just you talking to yourself, right? :))

> I really only found this. All the other cases aren't doing real data
> frames, only null-data and management. So I guess for those we're OK,
> and this was the only special case after all.

SGTM.

Guess we'll have to deal with everything else if we ever move management
frames onto the TXQ path as well...

-Toke
