Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60691 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752671Ab1KUQDc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Nov 2011 11:03:32 -0500
Subject: Re: [PATCH 1/3] mac80211: add tx agg session timer to timeout
 inactive tids in way similar to rx agg sessions are being timed out
From: Johannes Berg <johannes@sipsolutions.net>
To: Nikolay Martynov <mar.kolya@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <CALGY4ftYb=QS+-3B4kPEJpYf+pdhwrWu5pj+yg-ceO4PU-PwmA@mail.gmail.com> (sfid-20111121_165816_850771_E5B84BD4)
References: <1321842172-6732-1-git-send-email-mar.kolya@gmail.com>
	 <1321842172-6732-2-git-send-email-mar.kolya@gmail.com>
	 <1321868083.3999.15.camel@jlt3.sipsolutions.net>
	 <CALGY4ftYb=QS+-3B4kPEJpYf+pdhwrWu5pj+yg-ceO4PU-PwmA@mail.gmail.com>
	 (sfid-20111121_165816_850771_E5B84BD4)
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 21 Nov 2011 17:03:29 +0100
Message-ID: <1321891409.3999.52.camel@jlt3.sipsolutions.net> (sfid-20111121_170335_238212_717D7727)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-11-21 at 10:57 -0500, Nikolay Martynov wrote:

> >> @@ -689,6 +716,8 @@ void ieee80211_stop_tx_ba_cb(struct ieee80211_vif *vif, u8 *ra, u8 tid)
> >>        * more.
> >>        */
> >>
> >> +     del_timer_sync(&tid_tx->session_timer);
> >> +
> >>       ieee80211_agg_splice_packets(local, tid_tx, tid);
> >
> > This is a deadlock waiting to happen.

>   I'd really appreciate if you could be a bit more specific on why
> this could lead to deadlock. Thanks!

It's within the spinlock, and you take the spinlock in the timer. So
this can happen:

cpu 1				cpu 2
stop_tx_ba_cb
  spin_lock_bh(&sta->lock);
				start your timer function
  del_timer_sync
    wait for timer to finish
				spin_lock_bh(&sta->lock);

johannes

