Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60963 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752563Ab1BHKN1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Feb 2011 05:13:27 -0500
Received: by wyb28 with SMTP id 28so5529551wyb.19
        for <linux-wireless@vger.kernel.org>; Tue, 08 Feb 2011 02:13:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1296825156.3671.7.camel@jlt3.sipsolutions.net>
References: <1296822326-4878-1-git-send-email-vnatarajan@atheros.com>
	<1296824920.3671.4.camel@jlt3.sipsolutions.net>
	<1296825156.3671.7.camel@jlt3.sipsolutions.net>
Date: Tue, 8 Feb 2011 15:43:25 +0530
Message-ID: <AANLkTi=eJf+ge7_w1-r1hmZE0aaPzm_NP-Y-v81uctXG@mail.gmail.com>
Subject: Re: [PATCH v2] mac80211: Fix a race on enabling power save.
From: Vivek Natarajan <vivek.natraj@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 4, 2011 at 6:42 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Fri, 2011-02-04 at 14:08 +0100, Johannes Berg wrote:
>> On Fri, 2011-02-04 at 17:55 +0530, Vivek Natarajan wrote:
>> > There is a race on sending a data frame before the tx completion
>> > of nullfunc frame for enabling power save. As the data quickly
>> > follows the nullfunc frame, the AP thinks that the station is out
>> > of power save and continues to send the frames. Whereas in the
>> > station, the nullfunc ack will be processed after the tx completion
>> > of data frame and mac80211 goes to powersave. Thus the power
>> > save state mismatch between the station and the AP causes some
>> > data loss and some applications fail because of that. This patch
>> > fixes this issue.
>> >
>> > Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
>> > ---
>> >  net/mac80211/ieee80211_i.h |    1 +
>> >  net/mac80211/mlme.c        |    8 ++++++--
>> >  net/mac80211/tx.c          |    8 ++++++++
>> >  3 files changed, 15 insertions(+), 2 deletions(-)
>> >
>> > diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
>> > index 533fd32..6ad97f6 100644
>> > --- a/net/mac80211/ieee80211_i.h
>> > +++ b/net/mac80211/ieee80211_i.h
>> > @@ -346,6 +346,7 @@ enum ieee80211_sta_flags {
>> >     IEEE80211_STA_UAPSD_ENABLED     = BIT(7),
>> >     IEEE80211_STA_NULLFUNC_ACKED    = BIT(8),
>> >     IEEE80211_STA_RESET_SIGNAL_AVE  = BIT(9),
>> > +   IEEE80211_STA_PS_PENDING        = BIT(10),
>> >  };
>> >
>> >  struct ieee80211_if_managed {
>> > diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
>> > index e059b3a..45f736e 100644
>> > --- a/net/mac80211/mlme.c
>> > +++ b/net/mac80211/mlme.c
>> > @@ -727,13 +727,17 @@ void ieee80211_dynamic_ps_enable_work(struct work_struct *work)
>> >             return;
>> >
>> >     if ((local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK) &&
>> > -       (!(ifmgd->flags & IEEE80211_STA_NULLFUNC_ACKED)))
>> > +       (!(ifmgd->flags & IEEE80211_STA_NULLFUNC_ACKED))) {
>> > +           ifmgd->flags |= IEEE80211_STA_PS_PENDING;
>> >             ieee80211_send_nullfunc(local, sdata, 1);
>> > +   }
>> >
>> >     if (!((local->hw.flags & IEEE80211_HW_REPORTS_TX_ACK_STATUS) &&
>> >           (local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK)) ||
>> > -       (ifmgd->flags & IEEE80211_STA_NULLFUNC_ACKED)) {
>> > +       ((ifmgd->flags & IEEE80211_STA_NULLFUNC_ACKED) &&
>> > +         ifmgd->flags & IEEE80211_STA_PS_PENDING))  {
>> >             ifmgd->flags &= ~IEEE80211_STA_NULLFUNC_ACKED;
>> > +           ifmgd->flags &= ~IEEE80211_STA_PS_PENDING;
>> >             local->hw.conf.flags |= IEEE80211_CONF_PS;
>> >             ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_PS);
>> >     }
>> > diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
>> > index 8fbbc7a..e1c2256 100644
>> > --- a/net/mac80211/tx.c
>> > +++ b/net/mac80211/tx.c
>> > @@ -185,6 +185,7 @@ ieee80211_tx_h_dynamic_ps(struct ieee80211_tx_data *tx)
>> >  {
>> >     struct ieee80211_local *local = tx->local;
>> >     struct ieee80211_if_managed *ifmgd;
>> > +   struct ieee80211_hdr *hdr;
>> >
>> >     /* driver doesn't support power save */
>> >     if (!(local->hw.flags & IEEE80211_HW_SUPPORTS_PS))
>> > @@ -233,6 +234,13 @@ ieee80211_tx_h_dynamic_ps(struct ieee80211_tx_data *tx)
>> >         && skb_get_queue_mapping(tx->skb) == 0)
>> >             return TX_CONTINUE;
>> >
>> > +   hdr = (struct ieee80211_hdr *)tx->skb->data;
>> > +
>> > +   if (!(ieee80211_is_nullfunc(hdr->frame_control) &&
>> > +        ieee80211_has_pm(hdr->frame_control)) &&
>> > +       (ifmgd->flags & IEEE80211_STA_PS_PENDING))
>> > +           ifmgd->flags &= ~IEEE80211_STA_PS_PENDING;
>> > +
>> >     if (local->hw.conf.flags & IEEE80211_CONF_PS) {
>>
>
> Maybe the subif queues should be stopped, then flush, then tx nullfunc,
> then stop all queues to configure the HW or something like that?

I tried this sequence:
the subif queues stopped, then flush, then tx nullfunc, and wake subif
queues,(we cannot have the queues stopped till we receive tx_status
because nullfunc might have failed during tx path itself and mac80211
will not receive tx_status)
After some time interval, once again stop queues on receiving ack for
nullfunc, configure the hw and then wake up queues. So, during the
above time interval, there is a race of queuing a frame to the hw. I
have tested this and the issue is quickly reproducible.

> Indeed, but the trace still exists between checking PS_PENDING and
> setting CONF_PS.

But this race(in microseconds?) did not happen in my testing for 10 hrs.

For tx path and the mlme PS path to be atomic, a new spinlock is
needed. So, to fix this, I can think of only a lock to protect the
checking of PS_PENDING and setting CONF_PS in mlme.c and lock in tx
path where we check the PS_PENDING.

Thanks
Vivek.
