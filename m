Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:50897 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751122Ab1IZK3V convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Sep 2011 06:29:21 -0400
Received: by mail-ww0-f48.google.com with SMTP id 32so5038498wwe.17
        for <linux-wireless@vger.kernel.org>; Mon, 26 Sep 2011 03:29:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1317018322.2171.17.camel@cumari>
References: <1315476093-27583-1-git-send-email-shahar_levi@ti.com>
	<1316698619.2157.628.camel@cumari>
	<1316775583.2157.728.camel@cumari>
	<CAHiDVwkeMTYdVubk=YPp6XTfNtmr2+mTwuX-ED0TcmzmrvEfUw@mail.gmail.com>
	<1317018322.2171.17.camel@cumari>
Date: Mon, 26 Sep 2011 13:29:20 +0300
Message-ID: <CAHiDVwksE1pjwij9cJDbFjQ_6XVdk2X=ULPpvL4KBnJzqJVLUg@mail.gmail.com> (sfid-20110926_122924_825497_ABE5B66D)
Subject: Re: [PATCH] wl12xx: Add support for HW channel switch
From: "Levi, Shahar" <shahar_levi@ti.com>
To: Luciano Coelho <coelho@ti.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 26, 2011 at 9:25 AM, Luciano Coelho <coelho@ti.com> wrote:
> On Sun, 2011-09-25 at 19:08 +0300, Levi, Shahar wrote:
>> On Fri, Sep 23, 2011 at 1:59 PM, Luciano Coelho <coelho@ti.com> wrote:
>> > On Thu, 2011-09-22 at 16:36 +0300, Luciano Coelho wrote:
>> >> On Thu, 2011-09-08 at 13:01 +0300, Shahar Levi wrote:
>> >> > +static void wl12xx_op_channel_switch(struct ieee80211_hw *hw,
>> >> > +                                struct ieee80211_channel_switch *ch_switch)
>> >> > +{
>> >> > +   struct wl1271 *wl = hw->priv;
>> >> > +   int ret;
>> >> > +
>> >> > +   wl1271_debug(DEBUG_MAC80211, "mac80211 channel switch");
>> >> > +
>> >> > +   mutex_lock(&wl->mutex);
>> >> > +
>> >> > +   if (unlikely(wl->state == WL1271_STATE_OFF)) {
>> >> > +           mutex_unlock(&wl->mutex);
>> >> > +           ieee80211_chswitch_done(wl->vif, false);
>> >> > +           return;
>> >> > +   }
>> >> > +
>> >> > +   ret = wl1271_ps_elp_wakeup(wl);
>> >> > +   if (ret < 0)
>> >> > +           goto out;
>> >> > +
>> >> > +   /* send all pending packets */
>> >> > +   wl1271_tx_work_locked(wl);
>> >>
>> >> Is this really needed? Can anyone tell why?
>> I have re- discussed with the FW guys and it seems that when using HW
>> channel switch sending all TX packet isn't needed.
>
> As I suspected. ;)
>
>
>> > I checked this a bit further and I don't see the point in sending all
>> > packets here.  In fact, if block_tx is set, we can't even send any more
>> > frames until the switch happens (or fails).  So we should at least check
>> > this here.
>> The block_tx is taken into account in the mac layer.
>
> This is a bit strange, though.  I checked the code and nobody seems to
> be using the block_tx element of ieee80211_channel_switch, so I wonder
> why it's there at all.
>
> In any case, wouldn't it be a good idea for us to use it and send it to
> the firmware, since our firmware supports it? This way we would also
> block TX packets that are queued in the firmware, wouldn't we?
The FW support blocking TX in case of block_tx. The sepc definition is
to block TX in case of block_tx. Is that peer respectability?

>
>> > I'm leaving this patch out for now until I understand this better.
>> Do you prefer me to set v2 without that line or you could fix that in
>> the apply stage?
>
> No need to send v2.  It seems that Victor will need this change for
> something else he's working on, so I guess he can take it over once it
> is needed.  I don't want to include this unless we have a good reason to
> do it.
There is a good reason to include this:
a) It solve STA calibration issue in the FW in case of SW channel
switch (Rx issues)
b) This is FW support for channel switch with one command instead of
using several commands: rate_policies, roc \ join...

Our latest version pass full test cycle with that fix that solve CS issues.
> --
> Cheers,
> Luca.
All the best,
Shahar
