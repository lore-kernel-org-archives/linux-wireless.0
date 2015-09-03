Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:40412 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753795AbbICKR1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Sep 2015 06:17:27 -0400
Message-ID: <1441275442.2565.17.camel@sipsolutions.net> (sfid-20150903_121753_260910_EC3B2004)
Subject: Re: [PATCH 1/1] New driver: rtl8xxxu (mac80211)
From: Johannes Berg <johannes@sipsolutions.net>
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: linux-wireless@vger.kernel.org, kvalo@codeaurora.org,
	Larry.Finger@lwfinger.net
Date: Thu, 03 Sep 2015 12:17:22 +0200
In-Reply-To: <wrfj4mjcqn3x.fsf@redhat.com>
References: <1440883083-32498-1-git-send-email-Jes.Sorensen@redhat.com>
	 <1440883083-32498-2-git-send-email-Jes.Sorensen@redhat.com>
	 <1441032517.13980.21.camel@sipsolutions.net> <wrfjmvx73u0l.fsf@redhat.com>
	 <1441120044.2441.9.camel@sipsolutions.net> <wrfj4mjcqn3x.fsf@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-09-02 at 21:59 -0400, Jes Sorensen wrote:
> 
> The code mimics what the vendor driver does - part of the bringup of the
> chip sets a bunch of parameters from an register value array. Rather
> than guessing what their default is, I feel it's safer to just shut 
> it down here and stick with that.

Ok, fair enough. Might be worth putting that into start() rather than
add_interface() though? Anyway, it's not a big deal, I just wasn't sure
if that was intentional.

> > I'd be extremely surprised if any of this worked - perhaps you're 
> > not advertising A-MPDU support (yet)?
> > 
> > You're not calling ieee80211_start_tx_ba_cb_irqsafe() or
> > ieee80211_stop_tx_ba_cb_irqsafe(), so this can't really work. The
> > session might be set up but will never actually start.
> > 
> > That said, the code also looks incomplete. Perhaps better to just
> > remove it entirely for now?
> 
> I started working on this, but I guess I didn't finish it. One thing I
> haven't figured out yet is why I see AMPDU_RX_START events, but I never
> see AMPDU_TX_START events show in the log.

Nothing in your system is calling ieee80211_start_tx_ba_session() then.


johannes
