Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:43499 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750696AbYIPJIz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Sep 2008 05:08:55 -0400
Message-ID: <9f26451d5e126b98b80e38137152ef55.squirrel@secure.sipsolutions.net>
In-Reply-To: <1ba2fa240809160136w7af27d48ud979c0e3d68b933@mail.gmail.com> 
References: <1221550508-3338-1-git-send-email-tomas.winkler@intel.com>
    <1221552471.8916.17.camel@johannes.berg>
    <1ba2fa240809160136w7af27d48ud979c0e3d68b933@mail.gmail.com>
Date: Tue, 16 Sep 2008 11:08:48 +0200 (CEST)
Subject: Re: [RFC V2] mac80211: re-enable aggregation on 2.6.27
From: "Johannes Berg" <johannes@sipsolutions.net>
To: "Tomas Winkler" <tomasw@gmail.com>
Cc: linville@tuxdriver.com, yi.zhu@intel.com, ron.rindjunsky@intel.com,
	linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tomas Winkler wrote:
> On Tue, Sep 16, 2008 at 11:07 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
>> On Tue, 2008-09-16 at 10:35 +0300, Tomas Winkler wrote:
>>> Re-enable aggregation by addressing skb->cb overwrites
>>> after insertion into the qdisc. Aggregation was disabled
>>> after the new TX multiqueue changes were introduced. Instead
>>> of relying on the skb->cb we use two flags on the skb.
>>>
>>> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
>>> ---
>>>
>>> Users have been reporting low rates on 2.6.27 with 11n drivers, the
>>> problem is been 11n aggregation was disabled due to the new TX multique
>>> changes. We should have addressed this sooner but we just got to it
>>> now.
>>>
>>> Without addressing this we won't get 11n aggregation on 2.6.27. I tried
>>> to minimize the changes required. I'm about to test this, it compiles.
>>>
>>> If this doesn't get upstream for 27 perhaps distributions are willing
>>> to
>>> carry it around then and if so oh well (grr...).
>>>
>>> V2:
>>>  1. removed skbuff ->is_part_ampdu
>>>  2. fixed compilation warnings
>>
>> Looks better. However, still problems remain.
>>
>> ieee80211_start_tx_ba_session has a comment saying
>>
>>                /* No need to requeue the packets in the agg queue, since
>> we
>>                 * held the tx lock: no packet could be enqueued to the
>> newly
>>                 * allocated queue */
>>
>> which is clearly no longer true since there is no TX lock. You should
>> maintain a similar invariant instead, namely that sta->tid_to_tx_q[tid]
>> isn't updated until after ampdu_action(), in which case also no frames
>> will go to the aggregation queue.
>>
>> However, to avoid reordering issues at aggregation start, you also need
>> to stop the AC queue the TID falls into, to restart it only after
>> ieee80211_requeue. This is tricky as it might be stopped due to a scan
>> starting at the same time, so additional bookkeeping about who stopped a
>> queue for what reason will be needed so you don't enable a queue that
>> the scan has stopped or vice versa.
>>
>> As for ieee80211_requeue, it will need to be run from process context to
>> be able to synchronize_rcu() at the beginning of the function to make
>> sure any concurrent select_queue() has finished. That way, it can be
>> sure that all frames on the queues will be properly classified: when
>> aggregation was just _enabled_ frames after synchronize_rcu() will go to
>> the aggregation queue and we can safely requeue the frames on the AC
>> queue; when aggregation was just _disabled_ after synchronize_rcu() no
>> frames will go to the aggregation queue any more.
>>
>> Note that for both cases both queues have to be stopped, the aggregation
>> queue is easy to handle since it can just start out in stopped until
>> ieee80211_requeue is run from the workqueue, but for the AC queue as I
>> mentioned this requires extra bookkeeping to not collide with the driver
>> or the scan stopping queues. Incidentally, it looks as though the scan
>> might collide with the driver here, the fact that we allow pending
>> packets probably rescues us here, but we cannot rely on that for
>> aggregation because there we need it for correct ordering.
>>
>> I think that covers it all, but I might be wrong.
>
> Try to address these.  Scan is no issue if HW scan is enabled, haven't
> look if athk9 is using sw or hw scan.

ath9k is sw scan. I just had another idea, it might be possible to do
everything under the sta spinlock to avoid having to stop queues, but I'm
not sure that can work out.

johannes
