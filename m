Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57082 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751026AbaBSO5l (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Feb 2014 09:57:41 -0500
Date: Wed, 19 Feb 2014 16:00:05 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/2] mac80211: fix calling ieee80211_free_txskb with NULL
 skb
Message-ID: <20140219150004.GG1851@redhat.com> (sfid-20140219_155745_481074_0A45240D)
References: <1392812916-13656-1-git-send-email-sgruszka@redhat.com>
 <1392813218.4733.20.camel@jlt4.sipsolutions.net>
 <20140219132134.GD1851@redhat.com>
 <20140219144831.GF1851@redhat.com>
 <1392821414.4733.24.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1392821414.4733.24.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 19, 2014 at 03:50:14PM +0100, Johannes Berg wrote:
> On Wed, 2014-02-19 at 15:48 +0100, Stanislaw Gruszka wrote:
> 
> > Ok, I think I see this, it seems to be race condition in 
> > ieee80211_sta_ps_deliver_wakeup().
> > 
> > Perhaps it could be solved by modifying
> > ieee80211_add_pending_skbs_fn() to take list of queues as argument,
> > that function seems properly stop queues, add buffered frames to
> > pending queue, clear WLAN_STA_PS_STA and then wake up queues. Or
> > just  stop using ieee80211_add_pending_skbs_fn() and do the same
> > sequence directly on ieee80211_sta_ps_deliver_wakeup() .
> 
> That might work, but we were considering just locking the sta->lock
> around the whole "pending" thing inside deliver_wakeup() and in the "is
> station sleeping" part. Then you also need to re-check ("is it still
> sleeping?") inside the lock.

Looks good to me, feel free to post that.

Stanislaw
