Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:50494 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752784AbdIFKWN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 6 Sep 2017 06:22:13 -0400
Message-ID: <1504693330.13457.3.camel@sipsolutions.net> (sfid-20170906_122221_007943_38DCAEE3)
Subject: Re: [PATCH] mac80211: Complete ampdu work schedule during session
 tear down
From: Johannes Berg <johannes@sipsolutions.net>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org, Ilan Peer <ilan.peer@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Wed, 06 Sep 2017 12:22:10 +0200
In-Reply-To: <20170825081533.27916-1-luca@coelho.fi>
References: <20170825081533.27916-1-luca@coelho.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I was going to apply this, but running with lockdep enabled tells me
that this patch is broken.

In the callers of ieee80211_sta_tear_down_BA_sessions(), we only hold
the &local->sta_mtx.

However,

> +			rcu_dereference_protected_tid_tx(sta, i);

requires (and checks, if you have lockdep) that you hold either
	&sta->ampdu_mlme.mtx
or
	&sta->lock.

Additionally, ieee80211_remove_tid_tx(), called via
ieee80211_stop_tx_ba_cb(), requires holding both - and
ieee80211_stop_tx_ba_cb() only requires the spinlock.

johannes
