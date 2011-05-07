Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail81.extendcp.co.uk ([79.170.40.81]:48807 "EHLO
	mail81.extendcp.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754301Ab1EGUwB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 May 2011 16:52:01 -0400
Received: from 188-222-111-86.zone13.bethere.co.uk ([188.222.111.86] helo=toddler)
	by mail81.extendcp.com with esmtpa (Exim 4.73)
	id 1QIo8F-0001Q3-HU
	for linux-wireless@vger.kernel.org; Sat, 07 May 2011 21:29:43 +0100
Date: Sat, 7 May 2011 21:29:42 +0100
From: Tony Houghton <h@realh.co.uk>
To: linux-wireless@vger.kernel.org
Subject: Building current snapshot against kernel 2.6.38 (kfree_rcu problem)
Message-ID: <20110507212942.7ba668a8@toddler> (sfid-20110507_225220_597083_5B288EE8)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I haven't heard any news about the ath9k bug that's been plaguing me so
I thought I'd try doing some debugging myself by adding printk messages
to shutdown functions. The trouble is the current snapshot (2011-05-05)
won't build against Debian's 2.6.38 kernel:

/home/tony/compat-wireless-2011-05-05/net/mac80211/agg-tx.c: In function ‘___ieee80211_stop_tx_ba_session’:
/home/tony/compat-wireless-2011-05-05/net/mac80211/agg-tx.c:158: error: implicit declaration of function ‘kfree_rcu’
/home/tony/compat-wireless-2011-05-05/net/mac80211/agg-tx.c:158: error: ‘rcu_head’ undeclared (first use in this function)
/home/tony/compat-wireless-2011-05-05/net/mac80211/agg-tx.c:158: error: (Each undeclared identifier is reported only once
/home/tony/compat-wireless-2011-05-05/net/mac80211/agg-tx.c:158: error: for each function it appears in.)
/home/tony/compat-wireless-2011-05-05/net/mac80211/agg-tx.c: In function ‘ieee80211_tx_ba_session_handle_start’:
/home/tony/compat-wireless-2011-05-05/net/mac80211/agg-tx.c:317: error: ‘rcu_head’ undeclared (first use in this function)
/home/tony/compat-wireless-2011-05-05/net/mac80211/agg-tx.c: In function ‘ieee80211_stop_tx_ba_cb’:
/home/tony/compat-wireless-2011-05-05/net/mac80211/agg-tx.c:696: error: ‘rcu_head’ undeclared (first use in this function)

I think the errors about rcu_head are actually caused by the lack of a
definition for kfree_rcu. I Googled it and AFAICT kfree_rcu was only
introduced this March. But compat-wireless is supposed to work with all
2.6 kernels isn't it, so why is it using such a new feature? Have I just
caught a "bad" snapshot before an alternative for kfree_rcu was added
for older kernels?

I'd prefer to build against 2.6.38 if possible because compiling a
2.6.39-rc will take hours and then cause some inconvenience with the
nvidia packages.

Please Cc replies to me because I'm not subscribed to the list.
