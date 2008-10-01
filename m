Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.188]:10592 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696AbYJAAHx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Sep 2008 20:07:53 -0400
Received: by fk-out-0910.google.com with SMTP id 18so2397273fkq.5
        for <linux-wireless@vger.kernel.org>; Tue, 30 Sep 2008 17:07:49 -0700 (PDT)
Message-ID: <1ba2fa240809301707i22cab6b7hb1b22fc88ebda7f0@mail.gmail.com> (sfid-20081001_020758_390145_FB753FD4)
Date: Wed, 1 Oct 2008 03:07:49 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [RFC v4] mac80211: re-enable aggregation on 2.6.27
Cc: "Luis Rodriguez" <Luis.Rodriguez@atheros.com>,
	"johannes@sipsolutions.net" <johannes@sipsolutions.net>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20080930152524.GA8131@tesla>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1222790548-7391-1-git-send-email-lrodriguez@atheros.com>
	 <1ba2fa240809301318p16bedbdr31fdaea97c3cf3be@mail.gmail.com>
	 <20080930152524.GA8131@tesla>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 30, 2008 at 6:25 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> A quick test indicates it works but the removal is still an issue.

I didn't implement it yet I just wanted a feedback if I'm in correct
direction with the starting part.

We also
> have to make lockdep happy -- one more complaint (even with your v3
> patch).

Strange I haven't seen one, can you post the log.

I have another patch I'm going to test now which tries to
> address removal correctly. It doesn't seem we ever del_timer()'d the
> addba_resp_timer in a addition to other cleanups.
>
> I'll condense the relevant sections of your reply.
>
> On Tue, Sep 30, 2008 at 01:18:46PM -0700, Tomas Winkler wrote:
>> On Tue, Sep 30, 2008 at 7:02 PM, Luis R. Rodriguez
>
> Note declrations:
>
>> > +void initiate_aggr_and_timer(struct sta_info *sta, u16 tid, u16 start_seq_num);
>> > +int __ieee80211_start_tx_ba_session(struct ieee80211_local *local,
>> > +                   struct sta_info *sta, u16 tid, u16 *start_seq_num);
>
>
> Note parts of the routine that use start_seq_num:

Okay, I've missed that.
>
>> > +void initiate_aggr_and_timer(struct sta_info *sta, u16 tid,
>> > +       u16 start_seq_num)
>> > +{
>
> <-- foo -->
>
>> > +       sta->ampdu_mlme.tid_tx[tid]->ssn = start_seq_num;
>
> <-- bar -->
>
>> > +}
>
> Note the pointer on u16 *start_seq_num:
>
>> > +int __ieee80211_start_tx_ba_session(struct ieee80211_local *local,
>> > +          struct sta_info *sta, u16 tid, u16 *start_seq_num)
>> >  {
>
> <-- foo -->
>> >        if (local->ops->ampdu_action)
>> > -               ret = local->ops->ampdu_action(hw, IEEE80211_AMPDU_TX_START,
>> > -                                               ra, tid, &start_seq_num);
>> > +               ret = local->ops->ampdu_action(local_to_hw(local),
>> > +                                               IEEE80211_AMPDU_TX_START,
>> > +                                               sta->addr, tid, start_seq_num);
>> Doesn't look good, we need to get the sequence number from the driver
>> Tomas
>
> We use u16 *start_seq_num, so yes, we are retrieving it from the driver
> here.
>
>> > +static void __ieee80211_run_ba_session(struct ieee80211_local *local)
>> > +{
>> > +       struct sta_info *sta, *sta_tmp;
>> > +       u8 *state;
>> > +       u16 start_seq_num = 0;
>> > +       int tid, r = -EINVAL;
>> > +
>> > +       ASSERT_RTNL();
>> > +
>> > +       spin_lock_bh(&local->sta_ba_lock);
>> > +       list_for_each_entry_safe(sta, sta_tmp,
>> > +                       &local->sta_ba_session_list, ba_list) {
>> > +               list_del(&sta->ba_list);
>> > +               spin_lock_bh(&sta->lock);
>> > +               for (tid = 0; tid < STA_TID_NUM; tid++) {
>> > +                       state = &sta->ampdu_mlme.tid_state_tx[tid];
>> > +                       r = -EINVAL;
>> > +                       if (*state & HT_AGG_START_PEND_REQ) {
>> > +                               *state &= ~HT_AGG_START_PEND_REQ;
>> > +                               r = __ieee80211_start_tx_ba_session(local,
>> > +                                       sta, tid, &start_seq_num);
>> > +                       }
>> > +                       if (!r)
>> > +                               initiate_aggr_and_timer(sta, tid, start_seq_num);
>> This is rather a strange name for a function,
>
> Yeah, got a better idea? I had originally called it foo_aggr(), I think
> this is a little better.

yes ieee80211_init_agg()

>> > +               }
>> > +               spin_unlock_bh(&sta->lock);
>> Don't think you can hold this lock across the whole loop
>
> I was wondering about that too, but don't see why not, your v3 patch
> changed the order in which this locking was done

I don't see the change of the order. ?

. I'm moving it back to
> how it was so the local->ops->ampdu_action now runder the same lock too.

It' doesn't have to be locked by that lock,

> I don't think it was locking before under the code which is now
> under initiate_aggr_and_timer() though.

Correct you cannot lock this part it leads to soft lock.

The sta->lock is used just  to lock the aggregation state machine,
Johannes has reduced  the original aggregation lock not sure if it
just didn't create artificial lock conflict, but I'm not a locking
expert.

Hope I'll have more time tomorrow to look into it.
Tomas
