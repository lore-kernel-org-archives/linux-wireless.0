Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:6283 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751960AbXLSK7e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Dec 2007 05:59:34 -0500
MIME-Version: 1.0
Subject: RE: [PATCH 5/8] mac80211: A-MPDU Rx handling aggregation reordering
Date: Wed, 19 Dec 2007 12:57:48 +0200
Message-ID: <1879838866982C46A9CB3D56BA49ADEB0431391B@hasmsx411.ger.corp.intel.com> (sfid-20071219_105938_368896_5FCF3AE2)
In-Reply-To: <1197986248.4885.149.camel@johannes.berg>
References: <11979070692599-git-send-email-ron.rindjunsky@intel.com> <11979070782762-git-send-email-ron.rindjunsky@intel.com> <1197915515.4885.86.camel@johannes.berg> <c85cb4470712180544m682a93b1v9a7a34d2148a770b@mail.gmail.com> (sfid-20071218_134457_890406_A2932F58) <1197986248.4885.149.camel@johannes.berg>
From: "Rindjunsky, Ron" <ron.rindjunsky@intel.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Cc: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>,
	<flamingice@sourmilk.net>,
	"Winkler, Tomas" <tomas.winkler@intel.com>,
	"Zhu, Yi" <yi.zhu@intel.com>
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


>>> +     int ordered;
>>
>> type int was chosen as it is not a bool type (can be
>> drop/continue/queue) so it can't be fit to flags.

> No, I was thinking that it's enum txrx_result or whatever that is
named.
> But you can't use that type in mac80211.h since it's only defined in
> ieee80211_i.h... Maybe you should put the declaration into mac80211.h
> and use it here so that the compiler can error check this ordered
field
> better...

I thought about doing it. The txrx_result enum did look to me
as a very useful one for low level drivers, as the same set
of actions of drop/continue/queue is relevant there as well.
As you have the same opinion I'll go ahead with it.

>>> @@ -1252,6 +1254,20 @@ void ieee80211_sta_stop_rx_BA_session(struct 
>>>               ieee80211_send_delba(dev, ra, tid, 0, reason);
>>>
>>>       /* free the reordering buffer */
>>> +     for (i = 0; i < sta->ampdu_mlme.tid_rx[tid].buf_size; i++) {
>>> +             if (sta->ampdu_mlme.tid_rx[tid].reorder_buf[i]) {
>>> +                     /* release the reordered frames to stack,
>>> +                      * but drop them there */
>>> +                     memcpy(&status, sta->ampdu_mlme.tid_rx[tid].
>>> +                             reorder_buf[i]->cb, sizeof(status));
>>> +                     status.ordered = TXRX_DROP;
>>> +                     __ieee80211_rx(hw, sta->ampdu_mlme.
>>> +                                    tid_rx[tid].reorder_buf[i],
>>> +                                    &status);
>>>
>>> This is strange. Why are they even passed to __ieee80211_rx?
>> 
>> of course i can get rid from there here, but thought it will be more
>> systematic and clearer to pass them back to __ieee80211_rx. if you
>> have any objection to this (efficiency considerations or like) i will
>> reconsider it.

> I'm just not sure why you'd want to. As far as I can the frames
already
> passed __ieee80211_rx(), no? Maybe only as part of the aggregation?

No, not passed it yet, they are still queued for reordering, but as
aggregation is being tear down I am expected to drop the frames
that are still not in order.
Again, if you see any performance issue with it, although this may
occur only once per session, do tell, if not, I would prefer to
leave it that way, as this will 1 - give more accurate statistics
of dropped frames, 2 - I don't want to drop frames in places
people will have trouble finding, other then the in the handlers.
---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

