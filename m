Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:37468 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084Ab1FUGdy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jun 2011 02:33:54 -0400
Received: by gxk21 with SMTP id 21so612304gxk.19
        for <linux-wireless@vger.kernel.org>; Mon, 20 Jun 2011 23:33:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTikba=gw=1itPywfUaK28pVL2Z6=2g@mail.gmail.com>
References: <1308425533-20854-1-git-send-email-arik@wizery.com>
	<BANLkTikB3egX4YikC1JdgEr-E-7Dm13_CA@mail.gmail.com>
	<BANLkTikba=gw=1itPywfUaK28pVL2Z6=2g@mail.gmail.com>
Date: Tue, 21 Jun 2011 12:03:53 +0530
Message-ID: <BANLkTimmn3o-+rexOYy2CjrOX_Xo06R+uw@mail.gmail.com> (sfid-20110621_083403_798041_91C0D7B1)
Subject: Re: [RFC] mac80211: dynamic PS - don't enter PS when TX frames are pending
From: Vivek Natarajan <vivek.natraj@gmail.com>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Sam Leffler <sleffler@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 21, 2011 at 11:13 AM, Arik Nemtsov <arik@wizery.com> wrote:
> On Tue, Jun 21, 2011 at 07:55, Vivek Natarajan <vivek.natraj@gmail.com> wrote:
>>>
>>> +       /* don't enter PS if dynamic PS is enabled and TX frames are pending */
>>> +       if (local->hw.conf.dynamic_ps_timeout > 0 &&
>>> +           !local->disable_dynamic_ps && drv_tx_frames_pending(local)) {
>>
>> netif_tx_stop_all_queues has to be called before checking
>> frames_pending(), so that we can make sure no data is transmitted in
>> the time between checking frames_pending and transmitting null data
>> frames. If it is not done, this might cause some power save states
>> mismatch between the AP and the station in some corner cases.
>
> That's a good point. But I guess its only relevant to drivers using
> IEEE80211_HW_PS_NULLFUNC_STACK.
> Still seems racy to me - even if queues are stopped it doesn't mean
> mac80211 is not in the middle of ieee80211_tx(). Is there a way to
> make sure?

Well, I can't find any way to stop this race. :)
Atleast the other race could be fixed with stop_queues.
How about the below patch? I am not sure about the disable_dynamic_ps
and its BT/WLAN antenna sharing. Please add that if you see it as
appropriate.

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index faca503..67ecad1 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -778,15 +778,14 @@ void ieee80211_dynamic_ps_enable_work(struct
work_struct *work)
        }
        spin_unlock_irqrestore(&local->queue_stop_reason_lock, flags);

-       if ((local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK) &&
-           (!(ifmgd->flags & IEEE80211_STA_NULLFUNC_ACKED))) {
+       if (!(ifmgd->flags & IEEE80211_STA_NULLFUNC_ACKED)) {
                netif_tx_stop_all_queues(sdata->dev);

                if (drv_tx_frames_pending(local))
                        mod_timer(&local->dynamic_ps_timer, jiffies +
                                  msecs_to_jiffies(
                                  local->hw.conf.dynamic_ps_timeout));
-               else {
+               else if (local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK) {
                        ieee80211_send_nullfunc(local, sdata, 1);
                        /* Flush to get the tx status of nullfunc frame */
                        drv_flush(local, false);


Vivek.
