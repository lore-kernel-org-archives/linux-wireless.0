Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:51474 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752801AbZFRTim (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Jun 2009 15:38:42 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/2] [compat-2.6] Update conpat.diff remove last skb->requeue part
Date: Thu, 18 Jun 2009 21:38:34 +0200
Message-Id: <1245353915-30400-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This was needed as long as skb->requeue was accessed in this part.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 compat/compat.diff |   18 ------------------
 1 files changed, 0 insertions(+), 18 deletions(-)

diff --git a/compat/compat.diff b/compat/compat.diff
index c309732..fe99dec 100644
--- a/compat/compat.diff
+++ b/compat/compat.diff
@@ -858,24 +858,6 @@
  
  	return ops;
  }
---- a/net/mac80211/wme.c
-+++ b/net/mac80211/wme.c
-@@ -97,6 +97,7 @@ u16 ieee80211_select_queue(struct net_device *dev, struct sk_buff *skb)
- 	if (unlikely(queue >= local->hw.queues))
- 		queue = local->hw.queues - 1;
- 
-+#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,28))
- 	/*
- 	 * Now we know the 1d priority, fill in the QoS header if
- 	 * there is one (and we haven't done this before).
-@@ -112,6 +113,7 @@ u16 ieee80211_select_queue(struct net_device *dev, struct sk_buff *skb)
- 		*p++ = ack_policy | tid;
- 		*p = 0;
- 	}
-+#endif
- 
- 	return queue;
- }
 --- a/net/rfkill/Makefile
 +++ b/net/rfkill/Makefile
 @@ -2,6 +2,6 @@
-- 
1.6.2.1

