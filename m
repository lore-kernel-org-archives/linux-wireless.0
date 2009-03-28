Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.174]:60325 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753024AbZC1TSV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Mar 2009 15:18:21 -0400
Received: by wf-out-1314.google.com with SMTP id 29so1907945wff.4
        for <linux-wireless@vger.kernel.org>; Sat, 28 Mar 2009 12:18:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1238262118.4217.13.camel@johannes.local>
References: <20090323162834.154525349@sipsolutions.net> <20090323163053.344441542@sipsolutions.net>
	<20090328045529.GF5543@bombadil.infradead.org> <1238262118.4217.13.camel@johannes.local>
Date: Sat, 28 Mar 2009 12:18:03 -0700
Message-ID: <43e72e890903281218s6b4eeb9eu4a97aa3e87c5a3a6@mail.gmail.com> (sfid-20090328_201825_549378_A8582F74)
Subject: Re: [PATCH 7/8] mac80211: fix aggregation to not require queue stop
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Mar 28, 2009 at 10:41 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Sat, 2009-03-28 at 00:55 -0400, Luis R. Rodriguez wrote:
>
>
>> > This changes how mac80211 behaves towards drivers that support
>> > aggregation but have no hardware queues -- those drivers will now
>> > not be handed packets while the aggregation session is being
>> > established, but only after it has been fully established.
>>
>> That's fine from a logical point of view as compromise here as our
>> ampdu start should be relatively quick. Now while I can say this
>> from a logical point of view this patch obviously needed more
>> testing but lets see how it holds up and I'm glad you're the one
>> who wrote it. I'm confident there won't be any issues but that
>> is something I cannot gaurantee just based on the review. We now
>> need to go out and tests this. All other patches previous to this
>> make 100% perfect sense.
>
> :)
> I think it also makes more _sense_ to not ask the driver to handle th=
ese
> frames, because we won't set the AMPDU flag correctly if the session
> start is declined.

Hm, wouldn't we send them as normal frames if its declined here eventua=
lly?

>> > @@ -602,22 +637,19 @@ void ieee80211_stop_tx_ba_cb(struct ieee
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 WLAN_BACK_INITIATOR, WLAN_REASON_QSTA_NOT_USE);
>> >
>> > =C2=A0 =C2=A0 spin_lock_bh(&sta->lock);
>> > + =C2=A0 spin_lock(&local->ampdu_lock);
>> >
>> > - =C2=A0 if (*state & HT_AGG_STATE_INITIATOR_MSK &&
>> > - =C2=A0 =C2=A0 =C2=A0 hw->ampdu_queues) {
>> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /*
>> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* Wake up this queue, w=
e stopped it earlier,
>> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* this will in turn wak=
e the entire AC.
>> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*/
>> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ieee80211_wake_queue_by_reaso=
n(hw,
>> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 h=
w->queues + sta->tid_to_tx_q[tid],
>> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 I=
EEE80211_QUEUE_STOP_REASON_AGGREGATION);
>> > - =C2=A0 }
>> > + =C2=A0 ieee80211_agg_splice_packets(local, sta, tid);
>>
>> Is it possible for ieee80211_stop_tx_ba_cb() to be called while
>> state of the tid is not yet operational? from what I can tell
>> that's the only case when we would have added skbs to the STA's tid
>> pending queue.
>
> This happens when the session is denied by the peer.

Ah, got it, thanks.

>> > =C2=A0 =C2=A0 *state =3D HT_AGG_STATE_IDLE;
>> > + =C2=A0 /* from now on packets are no longer put onto sta->pendin=
g */
>>
>> I think it would help to refer to the pendign queue consitantly inst=
ead
>> as something like "STA's TID pending queue" as that is what it is. W=
e also
>> now have the local->pending queue. STA's pending queue seems to impl=
y
>> its also used for non-aggregation sessions.
>>
>> See -- if the state is not operation nothing would have gone
>> been put into the STA's tid pending queue. Might also be worth
>> mentioning that in the comment.
>
> Hmm, yeah, might rewrite the comments a bit. Mind if I do a separate
> patch later?

Nope.

>> > @@ -1013,20 +1013,53 @@ __ieee80211_tx_prepare(struct ieee80211_
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*/
>> > =C2=A0 =C2=A0 }
>> >
>> > + =C2=A0 /*
>> > + =C2=A0 =C2=A0* If this flag is set to true anywhere, and we get =
here,
>> > + =C2=A0 =C2=A0* we are doing the needed processing, so remove the=
 flag
>> > + =C2=A0 =C2=A0* now.
>> > + =C2=A0 =C2=A0*/
>> > + =C2=A0 info->flags &=3D ~IEEE80211_TX_INTFL_NEED_TXPROCESSING;
>> > +
>> > =C2=A0 =C2=A0 hdr =3D (struct ieee80211_hdr *) skb->data;
>> >
>> > =C2=A0 =C2=A0 tx->sta =3D sta_info_get(local, hdr->addr1);
>> >
>> > - =C2=A0 if (tx->sta && ieee80211_is_data_qos(hdr->frame_control))=
 {
>> > + =C2=A0 if (tx->sta && ieee80211_is_data_qos(hdr->frame_control) =
&&
>> > + =C2=A0 =C2=A0 =C2=A0 (local->hw.flags & IEEE80211_HW_AMPDU_AGGRE=
GATION)) {
>>
>> Hm, why were we not crashing here before? I figure we would have
>> with something like this:
>>
>> state =3D &tx->sta->ampdu_mlme.tid_state_tx[tid];
>>
>> That it itself should be separate patch, but too late now. Anyway
>> the new added check for IEEE80211_HW_AMPDU_AGGREGATION should go
>> to stable.
>
> Nah, state_tx always exists (and will be IDLE) but this was just an
> added check to make us not need the spinlock for non-ampdu hw.

Ah yes, its the ampdu_mlme.tid_tx that gets kmalloc'd only on aggr
session start.

>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 unsigned long flags;
>> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct tid_ampdu_tx *tid_tx;
>> > +
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 qc =3D ieee80211_get_qos=
_ctl(hdr);
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 tid =3D *qc & IEEE80211_=
QOS_CTL_TID_MASK;
>> >
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 spin_lock_irqsave(&tx->s=
ta->lock, flags);
>> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /*
>> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* XXX: This spinlock co=
uld be fairly expensive, but see the
>> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* =C2=A0 =C2=A0 =C2=A0c=
omment in agg-tx.c:ieee80211_agg_tx_operational().
>> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* =C2=A0 =C2=A0 =C2=A0O=
ne way to solve this would be to do something RCU-like
>> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* =C2=A0 =C2=A0 =C2=A0f=
or managing the tid_tx struct and using atomic bitops
>> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* =C2=A0 =C2=A0 =C2=A0f=
or the actual state -- by introducing an actual
>> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* =C2=A0 =C2=A0 =C2=A0'=
operational' bit that would be possible. It would
>> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* =C2=A0 =C2=A0 =C2=A0r=
equire changing ieee80211_agg_tx_operational() to
>> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* =C2=A0 =C2=A0 =C2=A0s=
et that bit, and changing the way tid_tx is managed
>> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* =C2=A0 =C2=A0 =C2=A0e=
verywhere, including races between that bit and
>> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* =C2=A0 =C2=A0 =C2=A0t=
id_tx going away (tid_tx being added can be easily
>> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* =C2=A0 =C2=A0 =C2=A0c=
ommitted to memory before the 'operational' bit).
>> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*/
>> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 tid_tx =3D tx->sta->ampdu_mlm=
e.tid_tx[tid];
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 state =3D &tx->sta->ampd=
u_mlme.tid_state_tx[tid];
>> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (*state =3D=3D HT_AGG_STAT=
E_OPERATIONAL)
>> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (*state =3D=3D HT_AGG_STAT=
E_OPERATIONAL) {
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 info->flags |=3D IEEE80211_TX_CTL_AMPDU;
>>
>> See, when its operational we don't add stuff to the STA's TID pendin=
g
>> queue.
>>
>> This piece:
>>
>> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 } else if (*state !=3D HT_AGG=
_STATE_IDLE) {
>> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /=
* in progress */
>> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 q=
ueued =3D true;
>> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 i=
nfo->flags |=3D IEEE80211_TX_INTFL_NEED_TXPROCESSING;
>> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 _=
_skb_queue_tail(&tid_tx->pending, skb);
>> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
>>
>> Can probably be ported to stable too, to just TX_DROP.
>
> No, why? We're handing the frames to the driver. It wants to handle
> those frames before agg session is started correctly. That's what I w=
as
> referring to before with this making more sense now.

OK I see that but I am not sure of what's done to the skb in the old
case if the session is note complete yet, nor now if the session gets
declined. I can check later, right now I'm feeling lazy.

>> > @@ -1251,7 +1295,12 @@ static int ieee80211_tx(struct net_devic
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 do {
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 next =3D skb->next;
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 skb->next =3D NULL;
>> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 skb_queue_tail(&local->pending[queue], skb);
>> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 if (unlikely(txpending))
>> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 skb_queue_head(&lo=
cal->pending[queue],
>> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0skb);
>> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 else
>> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 skb_queue_tail(&lo=
cal->pending[queue],
>> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0skb);
>>
>> For someone who hasn't read all the pending queue code stuff the abo=
ve would be
>> a little brain twister. It might be good to leave a comment explaini=
ng why
>> txpendign would be set and why we add it to the head (i.e. because t=
he "skb" sent
>> at a previous time was put into a pending queue). Maybe even rename =
txpending to
>> something like skb_was_pending.
>
> Ok that might make some sense, though as a parameter you can easily s=
ee
> where it's coming from, I think :) I agree that the entire code is a
> little brain twister...

Yeah.. I had to re-read aggregation code again to get the hang of it.
Anything we can do to make
it easier for people to pick would be nice. I think I'll go patch up
the aggr-tx kdoc too now, unless we
plan on nuking some stuff soon again. I suspect the next big change
will be to move software based
aggregation queue handling and mapping to ACs within mac80211 for that
type of hardware which
we'll need for ar9170, ralink stuff, broadcom (if that ever happens)
and our next generation 11n USB
driver.

>> > @@ -1360,7 +1407,7 @@ int ieee80211_master_start_xmit(struct s
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0"originating device\n", dev->name);
>> > =C2=A0#endif
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 dev_kfree_skb(skb);
>> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;
>> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return NETDEV_TX_OK;
>>
>> All these NETDEV_TX_OK could've gone into a separate patch.
>
> I guess, they're also not strictly necessary since 0 =3D=3D TX_OK :)

Sure, what I'm trying to say is these patches are pretty hard to
review because of the topic,
it just helps to trim them down as much as possible -- but I realize
even that is painful.

  Luis
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
