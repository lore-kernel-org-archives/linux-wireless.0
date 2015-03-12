Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:55898 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751812AbbCLShw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2015 14:37:52 -0400
Message-ID: <1426185468.1885.17.camel@sipsolutions.net> (sfid-20150312_193809_528042_40B37C38)
Subject: Re: [RFC v3] mac80211: lock rate control
From: Johannes Berg <johannes@sipsolutions.net>
To: Sven Eckelmann <sven@narfation.org>
Cc: linux-wireless@vger.kernel.org, Felix Fietkau <nbd@openwrt.org>,
	Sven Eckelmann <sven@open-mesh.com>,
	Arik Nemtsov <arik@wizery.com>, liad.kaufman@intel.com
Date: Thu, 12 Mar 2015 19:37:48 +0100
In-Reply-To: <1426061656-17546-1-git-send-email-sven@narfation.org> (sfid-20150311_091501_300586_8F374DB3)
References: <1426061656-17546-1-git-send-email-sven@narfation.org>
	 (sfid-20150311_091501_300586_8F374DB3)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-03-11 at 09:14 +0100, Sven Eckelmann wrote:

> Since fixing all rate control algorithms will be very difficult,
> just provide locking for invocations. This protects the internal
> data structures the algorithms maintain.

So ... we've been running with this and found that it causes a potential
deadlock.

The sta->lock is held in many places (particularly mesh, but in one case
also for delBA) while transmitting frames, so this causes a
lock->rate_ctrl_lock dependency.

At the same time, that lock is acquired for aggregation state machines,
i.e. the exported function calls ieee80211_stop_rx_ba_session(),
ieee80211_start_tx_ba_session() and ieee80211_stop_tx_ba_session().
These are often called from the rate control algorithm (minstrel,
rtlwifi, iwlwifi, ...) and thus cause a rate_ctrl_lock->lock dependency.

Combined, this clearly creates potential for classic ABBA deadlocks.

I'm not really sure yet how to fix this. One way would be to avoid all
TX under the sta->lock, which is a relatively simple patch for the
aggregation case since there's just one place
(http://p.sipsolutions.net/f951b8da4e78112a.txt) but mesh is far more
complex and has many places that send frames while holding sta->lock.

Another way would to avoid all such things would be to just make all the
internal mac80211 TX asynchronous by punting to the TX tasklet we have
anyway, but that seems overkill.

Another option might be to let mesh use a different spinlock, but then
we'd have to be careful not to cause a lock->mesh_lock dependency since
that would again lead to a lock->mesh_lock->rate_ctrl_lock dependency,
which is still buggy since the aggregation code paths cause the other
dependency.

Yet another option might be to make the three mentioned aggregation
functions asynchronous entirely, but that might cause interesting races
in the aggregation state machines again, and some drivers even rely on
the return value which could obviously then not be given.

If anyone has any good ideas ...

johannes

