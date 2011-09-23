Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:32792 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753054Ab1IWK7v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Sep 2011 06:59:51 -0400
Received: by bkar4 with SMTP id r4so3988637bka.15
        for <linux-wireless@vger.kernel.org>; Fri, 23 Sep 2011 03:59:47 -0700 (PDT)
Subject: Re: [PATCH] wl12xx: Add support for HW channel switch
From: Luciano Coelho <coelho@ti.com>
To: Shahar Levi <shahar_levi@ti.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1316698619.2157.628.camel@cumari>
References: <1315476093-27583-1-git-send-email-shahar_levi@ti.com>
	 <1316698619.2157.628.camel@cumari>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 23 Sep 2011 13:59:43 +0300
Message-ID: <1316775583.2157.728.camel@cumari> (sfid-20110923_125954_304007_7278A506)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-09-22 at 16:36 +0300, Luciano Coelho wrote: 
> On Thu, 2011-09-08 at 13:01 +0300, Shahar Levi wrote: 
> > WL12xx FW supports HW channel switch mechanism.
> > Add HW channel switch support via channel_switch ops.
> > 
> > Signed-off-by: Shahar Levi <shahar_levi@ti.com>
> > ---
> 
> [...]
> 
> > +static void wl12xx_op_channel_switch(struct ieee80211_hw *hw,
> > +				     struct ieee80211_channel_switch *ch_switch)
> > +{
> > +	struct wl1271 *wl = hw->priv;
> > +	int ret;
> > +
> > +	wl1271_debug(DEBUG_MAC80211, "mac80211 channel switch");
> > +
> > +	mutex_lock(&wl->mutex);
> > +
> > +	if (unlikely(wl->state == WL1271_STATE_OFF)) {
> > +		mutex_unlock(&wl->mutex);
> > +		ieee80211_chswitch_done(wl->vif, false);
> > +		return;
> > +	}
> > +
> > +	ret = wl1271_ps_elp_wakeup(wl);
> > +	if (ret < 0)
> > +		goto out;
> > +
> > +	/* send all pending packets */
> > +	wl1271_tx_work_locked(wl);
> 
> Is this really needed? Can anyone tell why?

I checked this a bit further and I don't see the point in sending all
packets here.  In fact, if block_tx is set, we can't even send any more
frames until the switch happens (or fails).  So we should at least check
this here.

I'm leaving this patch out for now until I understand this better.

-- 
Cheers,
Luca.

