Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:46334 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752781Ab1KXSeb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Nov 2011 13:34:31 -0500
Received: by wwp14 with SMTP id 14so2181429wwp.1
        for <linux-wireless@vger.kernel.org>; Thu, 24 Nov 2011 10:34:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1322158678.5366.27.camel@jlt3.sipsolutions.net>
References: <1322016630-27332-1-git-send-email-mar.kolya@gmail.com>
	<1322158678.5366.27.camel@jlt3.sipsolutions.net>
Date: Thu, 24 Nov 2011 13:34:30 -0500
Message-ID: <CALGY4fuFWf3Q2LvUgUXjnqGhWGtYYQni6pRqSnEFGop5JHmmFg@mail.gmail.com> (sfid-20111124_193434_496685_4D44D089)
Subject: Re: [PATCH v2 0/3] mac80211: timeout tx agg sessions in way similar
 to rx agg sessions
From: Nikolay Martynov <mar.kolya@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

 Thanks for spending your time looking at my patch and providing feedback!

2011/11/24 Johannes Berg <johannes@sipsolutions.net>:
> On Tue, 2011-11-22 at 21:50 -0500, Nikolay Martynov wrote:
>> Currently tx aggregation is not being timed out even if timeout is
>> specified when aggregation is opened. Tx tid stays active until delba
>> arrives from recipient (i.e. recipient times out tid when it is
>> inactive).
>>   The problem with this approach is that delba can get lost in the air
>> and tx tid will stay perpetually opened on the originator while closed
>> on recipient thus all data sent via this tid will be lost.
>>  The problem manifests itself with connection becoming slow/unusable
>> with ping times jumping to 4s. At such time opened tx tid can be seen
>> on one side of the connection without corresponding rx tid one the
>> other side. This seems to be happening quite often soon after
>> connection on ar9102 I have.
>>   This patch implements tx tid timeouting in way very similar to rx tid
>> timeouting.
>>
>>   All comments and suggestions are appreciated.
>
> Looks OK to me. Did you run it through sparse too? :-)
>
> johannes
>
>

 Please forgive my lack of experience, but could you please point me
to some docs where I can read about sparse and how to use it? I'd
really appreciate this.

 Also, I one more thing I forgot to mention in original cover letter.
Some time before this patch I've posted patch for ath9k: "[PATCH v3]
ath9k: improve ath_tx_aggr_stop to avoid TID stuck in cleanup state".
I've noticed that bug fixed in ath9k patch is triggered much more
often when this patch to mac80211 applied. Probably because of some
timing issues when TID is being closed from both ends at about same
time.
 What I mean to say is that this patch to mac80211 should probably be
applied after that patch to ath9k to avoid making ath9k less stable.

 And one more thing, if you do not mind.
'ieee80211_stop_tx_ba_session' tests tx_tid->state for
HT_AGG_STATE_STOPPING holding only spinlock on sta->lock.
'___ieee80211_stop_tx_ba_session' sets this bit when spin lock on
sta->lock is not being held. It seems to be that this could lead to
problems if these two functions get called at about same time (which
could easily happen when this patch is applied). Although actual
window when lock is not help is really small. But I think the way it
is currently done could still lead to problems. I think
'set_bit(HT_AGG_STATE_STOPPING, &tid_tx->state);' should be moved up
to be covered by spin lock. I can include this as a part of next
version of my patch. I'd really appreciate your thoughts about this.

Thanks!

-- 
Truthfully yours,
Martynov Nikolay.
Email: mar.kolya@gmail.com
