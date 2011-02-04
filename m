Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55807 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525Ab1BDN24 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Feb 2011 08:28:56 -0500
Received: by wyb28 with SMTP id 28so2243886wyb.19
        for <linux-wireless@vger.kernel.org>; Fri, 04 Feb 2011 05:28:54 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1296825156.3671.7.camel@jlt3.sipsolutions.net>
References: <1296822326-4878-1-git-send-email-vnatarajan@atheros.com>
	<1296824920.3671.4.camel@jlt3.sipsolutions.net>
	<1296825156.3671.7.camel@jlt3.sipsolutions.net>
Date: Fri, 4 Feb 2011 18:58:54 +0530
Message-ID: <AANLkTim+g=qT1JHyK9--Tqw=NfE_ccFL+hiYzwz-m-V_@mail.gmail.com>
Subject: Re: [PATCH v2] mac80211: Fix a race on enabling power save.
From: Vivek Natarajan <vivek.natraj@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Vivek Natarajan <vnatarajan@atheros.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 4, 2011 at 6:42 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Fri, 2011-02-04 at 14:08 +0100, Johannes Berg wrote:
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
>> I don't see how this patch helps anything. Should the last line I quoted
>> be replaced instead by checking if PS was requested? We used to not wait
>> for the ACK -- so waiting for the ACK broke this.
>
> Ok maybe I see how this helps -- but I don't think it's race-free. When
> the PS-pending flag is cleared here, the code above that checks it might
> already have passed and be in the driver callback or so.

When it is in the driver callback, IEEE80211_CONF_PS would have been
set and when this is set, ieee80211_tx_h_dynamic_ps will disable PS
and there wont be any discrepancy in power save states between AP and
the station.

Vivek.
