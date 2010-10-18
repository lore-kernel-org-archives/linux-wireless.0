Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:54605 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933151Ab0JRUgq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Oct 2010 16:36:46 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] compat: backport sock_recv_ts_and_drops
Date: Mon, 18 Oct 2010 22:36:35 +0200
Message-Id: <1287434195-8833-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is needed for bluetooth

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 include/linux/compat-2.6.33.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/compat-2.6.33.h b/include/linux/compat-2.6.33.h
index 6a7cd3e..c2dbc1b 100644
--- a/include/linux/compat-2.6.33.h
+++ b/include/linux/compat-2.6.33.h
@@ -145,6 +145,8 @@ static inline void compat_kfifo_free(struct kfifo **fifo) {
 	     prefetch(pos->member.next), &pos->member != (head);	\
 	     pos = list_entry_rcu(pos->member.next, typeof(*pos), member))
 
+#define sock_recv_ts_and_drops(msg, sk, skb) sock_recv_timestamp(msg, sk, skb)
+
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,33)) */
 
 #endif /* LINUX_26_33_COMPAT_H */
-- 
1.7.0.4

