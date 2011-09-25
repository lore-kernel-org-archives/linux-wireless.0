Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:48025 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751926Ab1IYQIl convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Sep 2011 12:08:41 -0400
Received: by wyf23 with SMTP id 23so6164262wyf.37
        for <linux-wireless@vger.kernel.org>; Sun, 25 Sep 2011 09:08:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1316775583.2157.728.camel@cumari>
References: <1315476093-27583-1-git-send-email-shahar_levi@ti.com>
	<1316698619.2157.628.camel@cumari>
	<1316775583.2157.728.camel@cumari>
Date: Sun, 25 Sep 2011 19:08:39 +0300
Message-ID: <CAHiDVwkeMTYdVubk=YPp6XTfNtmr2+mTwuX-ED0TcmzmrvEfUw@mail.gmail.com> (sfid-20110925_180852_062748_6B1E4AC3)
Subject: Re: [PATCH] wl12xx: Add support for HW channel switch
From: "Levi, Shahar" <shahar_levi@ti.com>
To: Luciano Coelho <coelho@ti.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 23, 2011 at 1:59 PM, Luciano Coelho <coelho@ti.com> wrote:
> On Thu, 2011-09-22 at 16:36 +0300, Luciano Coelho wrote:
>> On Thu, 2011-09-08 at 13:01 +0300, Shahar Levi wrote:
>> > WL12xx FW supports HW channel switch mechanism.
>> > Add HW channel switch support via channel_switch ops.
>> >
>> > Signed-off-by: Shahar Levi <shahar_levi@ti.com>
>> > ---
>>
>> [...]
Hi Luca,

>>
>> > +static void wl12xx_op_channel_switch(struct ieee80211_hw *hw,
>> > +                                struct ieee80211_channel_switch *ch_switch)
>> > +{
>> > +   struct wl1271 *wl = hw->priv;
>> > +   int ret;
>> > +
>> > +   wl1271_debug(DEBUG_MAC80211, "mac80211 channel switch");
>> > +
>> > +   mutex_lock(&wl->mutex);
>> > +
>> > +   if (unlikely(wl->state == WL1271_STATE_OFF)) {
>> > +           mutex_unlock(&wl->mutex);
>> > +           ieee80211_chswitch_done(wl->vif, false);
>> > +           return;
>> > +   }
>> > +
>> > +   ret = wl1271_ps_elp_wakeup(wl);
>> > +   if (ret < 0)
>> > +           goto out;
>> > +
>> > +   /* send all pending packets */
>> > +   wl1271_tx_work_locked(wl);
>>
>> Is this really needed? Can anyone tell why?
I have re- discussed with the FW guys and it seems that when using HW
channel switch sending all TX packet isn't needed.

>
> I checked this a bit further and I don't see the point in sending all
> packets here.  In fact, if block_tx is set, we can't even send any more
> frames until the switch happens (or fails).  So we should at least check
> this here.
The block_tx is taken into account in the mac layer.

>
> I'm leaving this patch out for now until I understand this better.
Do you prefer me to set v2 without that line or you could fix that in
the apply stage?

>
> --
> Cheers,
> Luca.
Thanks for your comment.
All the best,
Shahar
