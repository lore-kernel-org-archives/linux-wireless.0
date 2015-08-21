Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yk0-f177.google.com ([209.85.160.177]:34055 "EHLO
	mail-yk0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048AbbHURAn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Aug 2015 13:00:43 -0400
Received: by ykdt205 with SMTP id t205so76771616ykd.1
        for <linux-wireless@vger.kernel.org>; Fri, 21 Aug 2015 10:00:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1440143920.2107.3.camel@sipsolutions.net>
References: <CAOiWkA9iotcGij6wNeCUw+2iSfvWZGH+=vv_R2bwuDp92aXukw@mail.gmail.com>
	<1440143840.2107.2.camel@sipsolutions.net>
	<1440143920.2107.3.camel@sipsolutions.net>
Date: Fri, 21 Aug 2015 13:00:42 -0400
Message-ID: <CAOiWkA-rNVHiVZo5oSuEOk_o6ioPzfpd0qzw_QsekRSHQ1EeEw@mail.gmail.com> (sfid-20150821_190047_161863_137F4E37)
Subject: Re: mac80211: When adding a new station, notify driver before adding
 to hash
From: Marty Faltesek <mfaltesek@google.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 21, 2015 at 3:58 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Fri, 2015-08-21 at 09:57 +0200, Johannes Berg wrote:
>> On Thu, 2015-08-20 at 17:39 -0400, Marty Faltesek wrote:
>> >
>> > I believe the following race occurs:
>> >
>> > 1. mac80211 is processing a new station that just joined.
>> > 2. Before it's completed initializing the station, we take an
>> > interrupt,
>> >    with a packet from the STA.
>> > 3. That interrupt is a management frame from the station which
>> > causes
>> >    rate_control_rate_update to be called, which calls back into the
>> >
>> > ath10k
>> >    with the not-fully initialized station.
>>
>> I'm a bit confused by the stack trace - is this IBSS and the stack
>> trace is just bad? I don't really see how we get from
>> sta_ps_transition
>> to sta_rc_update?
>>
>> > 4. It reaches ath10k_sta_rc_update before the interrupted thread
>> > had
>> > reached ath10k_sta_state()
>> >    Therefore it has not yet initialized its workqueue. Still NULL.
>> > 5. When this NULL workqueue gets passed to queue_work, it passes
>> >    the first check that its not in use because of the NULL struct,
>> > but fails the
>> >    next check in __queue_work because a NULL structure makes the
>> > test
>> >    for an empty list fail.
>> >
>> >
>> > Proposed patch is to not add the new station in the hash until
>> > after
>> > the
>> > driver initializes it. But I'm not clear what implications this
>> > has.
>> > Could this
>> > cause other problems?
>> >
>>
>> I think the issue Michał pointed out is valid - but we can probably
>> check sta->uploaded in the relevant places?
>>
>
> Come to think of it though - we might cache & delay the call so drivers
> actually get the updated values.
>
> johannes

It's not IBSS and the stack is messed up, I guess because of statics.
It's probably more likely this manually crafted stack:

__queue_work    (fails BUG_ON(!list_empty(&work->entry));) NULL work
causes this check fail.
queue_work_on   WORK_STRUCT_PENDING_BIT check passes cause NULL work.
queue_work
ieee80211_queue_work
ath10k_sta_rc_update
drv_sta_rc_update
rate_control_rate_update
ieee80211_rx_h_action
ieee80211_rx_handlers
ieee80211_invoke_rx_handlers
ieee80211_prepare_and_rx_handle
__ieee80211_rx_handle_packet
ieee80211_rx
