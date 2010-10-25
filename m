Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39664 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884Ab0JYI1D (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Oct 2010 04:27:03 -0400
Subject: Re: [RFT] mac80211: fix null pointer dereference on
 ieee80211_stop_tx_ba_session()
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	amod.bodas@atheros.com, pstew@google.com, stable@kernel.org
In-Reply-To: <1287803778-10330-1-git-send-email-lrodriguez@atheros.com>
References: <1287803778-10330-1-git-send-email-lrodriguez@atheros.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 25 Oct 2010 10:23:32 +0200
Message-ID: <1287995012.3587.2.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-10-22 at 20:16 -0700, Luis R. Rodriguez wrote:
> RCU was not being used so we could race against the free'ing of the TID.

>  	spin_lock_bh(&sta->lock);
> -	tid_tx = sta->ampdu_mlme.tid_tx[tid];
> +	tid_tx = rcu_dereference(sta->ampdu_mlme.tid_tx[tid]);

As I mentioned to Luis on IRC, I believe that the spinlock is held
across all assignments to ampdu_mlme.tid_tx, so this is definitely not
necessary (nor really correct). If there is a place that doesn't hold
the spinlock that may be a bug, but a cursory look suggested that all
places hold the lock correctly.

johannes

