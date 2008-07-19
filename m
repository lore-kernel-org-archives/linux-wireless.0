Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53566 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402AbYGSApy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jul 2008 20:45:54 -0400
Message-Id: <20080719004147.795661000@sipsolutions.net> (sfid-20080719_024557_245995_824DD6A8)
Date: Sat, 19 Jul 2008 02:41:47 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: David Miller <davem@davemloft.net>,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
Subject: [RFC 0/3] mac80211 tx mq aggregation fixes
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As we discussed earlier, there is now a race in mac80211 where 
you can get packets queued onto the aggregation queue while draining
it, and some can be left on there. Fixing that is achieved by deferring
the draining to a workqueue and calling synchronize_net() before doing   
it.

Also noticed another problem: when we start aggregation we add the
queue before the hardware said it's ok, thus we can end up queuing    
packets to a new aggregation queue we won't be using, fix that one    
before since it was easier.        

Locking gets a bit tricky unfortunately.

johannes

