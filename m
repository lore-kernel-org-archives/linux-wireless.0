Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.tohojo.dk ([77.235.48.147]:42381 "EHLO mail2.tohojo.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753374AbcILK4L (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Sep 2016 06:56:11 -0400
From: =?utf-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Felix Fietkau <nbd@nbd.name>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: fix sequence number assignment for PS response
        frames
References: <20160904160059.66297-1-nbd@nbd.name>
        <1473674327.29016.3.camel@sipsolutions.net>
        <afb51baf-ec2d-3600-9e5b-f406b9e836b7@nbd.name>
        <1473674624.29016.4.camel@sipsolutions.net>
        <521f75cd-2203-efc0-77c9-d9f7b6c4079f@nbd.name>
        <1473674822.29016.6.camel@sipsolutions.net>
        <96ab269f-a40c-8824-1e61-fd17666ded46@nbd.name>
Date: Mon, 12 Sep 2016 12:56:06 +0200
In-Reply-To: <96ab269f-a40c-8824-1e61-fd17666ded46@nbd.name> (Felix Fietkau's
        message of "Mon, 12 Sep 2016 12:08:35 +0200")
Message-ID: <87sht5fku1.fsf@toke.dk> (sfid-20160912_125615_020342_54D9D9E4)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau <nbd-Vt+b4OUoWG0@public.gmane.org> writes:

> On 2016-09-12 12:07, Johannes Berg wrote:
>> On Mon, 2016-09-12 at 12:05 +0200, Felix Fietkau wrote:
>>> On 2016-09-12 12:03, Johannes Berg wrote:
>>> > 
>>> > 
>>> > > 
>>> > > Hm, I guess I didn't think of that. I guess this potential issue
>>> > > will
>>> > > go away once we get Toke's tx handler reorder patch fixed,
>>> > > rebased
>>> > > and integrated.
>>> > > 
>>> > 
>>> > I don't really see how that helps?
>>> It replaces the changes that I made.
>>> 
>> 
>> But this is a more general problem, no?
> Will look into it some more soon.
>
> - Felix

Well, ath9k calls ieee80211_tx_dequeue while holding the (driver) TXQ
lock. Which means that a packet going through the old TX path can block
waiting for the driver to finish pulling packets from the mac80211
queue. So that could definitely lead to reordering of sequence numbers.
And the obvious fix of taking a lock in mac80211 could then lead to
deadlock. Fun times! :)

Hmm, is there a reason why those packets *have* to go through the old TX
path? My reordering patchset introduces a queue that takes priority over
the FQ (for fragments created after dequeue). Would sticking the PS
response frame on there and having the driver pull it work?

-Toke
