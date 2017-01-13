Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:49422 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751157AbdAMIRK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Jan 2017 03:17:10 -0500
Message-ID: <1484295383.19860.7.camel@sipsolutions.net> (sfid-20170113_091757_654162_0715FEE4)
Subject: Re: [PATCH] mac80211: prevent skb/txq mismatch
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org, greearb@candelatech.com,
        mohammed@qti.qualcomm.com
Date: Fri, 13 Jan 2017 09:16:23 +0100
In-Reply-To: <1484231321-3179-1-git-send-email-michal.kazior@tieto.com> (sfid-20170112_152717_498584_751EA79A)
References: <1484231321-3179-1-git-send-email-michal.kazior@tieto.com>
         (sfid-20170112_152717_498584_751EA79A)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2017-01-12 at 15:28 +0100, Michal Kazior wrote:
> Station structure is considered as not uploaded
> (to driver) until drv_sta_state() finishes. This
> call is however done after the structure is
> attached to mac80211 internal lists and hashes.
> This means mac80211 can lookup (and use) station
> structure before it is uploaded to a driver.
> 
> If this happens (structure exists, but
> sta->uploaded is false) fast_tx path can still be
> taken. Deep in the fastpath call the sta->uploaded
> is checked against to derive "pubsta" argument for
> ieee80211_get_txq(). If sta->uploaded is false
> (and sta is actually non-NULL) ieee80211_get_txq()
> effectively downgraded to vif->txq.
> 
> At first glance this may look innocent but coerces
> mac80211 into a state that is almost guaranteed
> (codel may drop offending skb) to crash because a
> station-oriented skb gets queued up on
> vif-oriented txq. The ieee80211_tx_dequeue() ends
> up looking at info->control.flags and tries to use
> txq->sta which in the fail case is NULL.
> 
> It's probably pointless to pretend one can
> downgrade skb from sta-txq to vif-txq.

Ok. I understand things until this point, more or less.

What I don't understand - and you haven't really described - is how the
changes fix it? Could you resend with a paragraph added that explains
that?

Also, you're adding a test:

>	if (sta && !sta->uploaded)

but couldn't do move that into the existing "if (sta)" block?
Everything before that only ever returns NULL anyway.

johannes
