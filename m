Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f195.google.com ([209.85.212.195]:47485 "EHLO
	mail-vw0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752081AbZHZRDI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Aug 2009 13:03:08 -0400
Received: by vws33 with SMTP id 33so260144vws.33
        for <linux-wireless@vger.kernel.org>; Wed, 26 Aug 2009 10:03:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090826162941.GA4417@mosca>
References: <1251224728-7180-1-git-send-email-lrodriguez@atheros.com>
	 <b6c5339f0908251145h3a075b86hab00d2223f9acc58@mail.gmail.com>
	 <20090825185842.GA7357@mosca>
	 <b6c5339f0908251222h5fb281c3vf3ecea8b27eb02ed@mail.gmail.com>
	 <20090825233827.GA10998@mosca>
	 <b6c5339f0908260708l38208046o43330d9eda808b1e@mail.gmail.com>
	 <20090826162941.GA4417@mosca>
Date: Wed, 26 Aug 2009 13:03:09 -0400
Message-ID: <b6c5339f0908261003g40ed910amc347305e4604ee4a@mail.gmail.com>
Subject: Re: [PATCH] ath5k: fix print on warning on ath5k_hw_to_driver_rix()
From: Bob Copeland <me@bobcopeland.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 26, 2009 at 12:29 PM, Luis R.
Rodriguez<lrodriguez@atheros.com> wrote:

> Not sure I follow. Let me explain the logic here a little better.
> ath5k_reset() had a check to see if we switched channels. The check
> is above, and I moved it ath5k_chan_set() called by the config callback.
> Reason for this is channel change *only* occurs through the config callback
> so we can be certain no other path will call reset with a channel change
> request.

But previously we did all this stuff for _every_ reset except the first
one, now we only do it for channel change resets.  It may make sense your
way, but I'd rather see that as a separate patch rather than part of a
cleanup.  (Also, chan_change is used to skip a bunch of phy register writes
that we only need to do once, not sure if that changes here).

>> There's just no synchronization of this stuff, not too surprising there
>> are races.
>
> config calls for reset seem to be with sc->lock. ath9k uses a mutex to
> protect races between mac80211 callback calls, ath5k seems to use the
> sc->lock *sometimes*, a good review of that may help but for channel
> change this seems protected unless I missed something. Since channel
> change goes through the config callback and since the callback protects
> through sc->lock I can't see how we'd race against changing channels.

rx_tasklet doesn't (can't) take the mutex though.  Here's the race:

cpu 1                       cpu 2
                            1mbit packet received, ack intr and queue it
client changes to 5ghz band
hw->conf.channel = 36
                            ath5k_rx_tasklet runs
                            hmm, we got 1mbit packet on channel 36, wtf
ath5k_chan_change()

This is still racy with curband variables of course, but IMO the
proposed change actually makes the race wider (in current code, we only
update the band after we disable the interrupts, but the tasklet can
still run on queued packets).

The right thing to do is either process or drop all of those packets
with interrupts disabled before updating the band/channel (rx_drainq),
or protect that channel info with a spinlock.   Or perhaps we can
figure it out directly from the rx descriptor -- I looked at this
briefly and didn't think there was enough info there, but didn't spend
much time on it.

-- 
Bob Copeland %% www.bobcopeland.com
