Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:56556 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132AbaBSOuX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Feb 2014 09:50:23 -0500
Message-ID: <1392821414.4733.24.camel@jlt4.sipsolutions.net> (sfid-20140219_155027_426371_615F16D5)
Subject: Re: [PATCH 1/2] mac80211: fix calling ieee80211_free_txskb with
 NULL skb
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	linux-wireless@vger.kernel.org
Date: Wed, 19 Feb 2014 15:50:14 +0100
In-Reply-To: <20140219144831.GF1851@redhat.com>
References: <1392812916-13656-1-git-send-email-sgruszka@redhat.com>
	 <1392813218.4733.20.camel@jlt4.sipsolutions.net>
	 <20140219132134.GD1851@redhat.com> <20140219144831.GF1851@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-02-19 at 15:48 +0100, Stanislaw Gruszka wrote:

> Ok, I think I see this, it seems to be race condition in 
> ieee80211_sta_ps_deliver_wakeup().
> 
> Perhaps it could be solved by modifying
> ieee80211_add_pending_skbs_fn() to take list of queues as argument,
> that function seems properly stop queues, add buffered frames to
> pending queue, clear WLAN_STA_PS_STA and then wake up queues. Or
> just  stop using ieee80211_add_pending_skbs_fn() and do the same
> sequence directly on ieee80211_sta_ps_deliver_wakeup() .

That might work, but we were considering just locking the sta->lock
around the whole "pending" thing inside deliver_wakeup() and in the "is
station sleeping" part. Then you also need to re-check ("is it still
sleeping?") inside the lock.

johannes

