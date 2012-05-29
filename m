Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:44015 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752176Ab2E2WmC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 May 2012 18:42:02 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com
Cc: lf_driver_backport@lists.linux-foundation.org,
	linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/4] comapt: add skb_queue_walk_from
Date: Wed, 30 May 2012 00:41:46 +0200
Message-Id: <1338331308-29732-3-git-send-email-hauke@hauke-m.de> (sfid-20120530_004207_256664_CD63F9B0)
In-Reply-To: <1338331308-29732-1-git-send-email-hauke@hauke-m.de>
References: <1338331308-29732-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 include/linux/compat-2.6.28.h |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/linux/compat-2.6.28.h b/include/linux/compat-2.6.28.h
index 3980989..9b6b958 100644
--- a/include/linux/compat-2.6.28.h
+++ b/include/linux/compat-2.6.28.h
@@ -214,6 +214,10 @@ static inline void skb_queue_splice_tail(const struct sk_buff_head *list,
 	}
 }
 
+#define skb_queue_walk_from(queue, skb)						\
+		for (; skb != (struct sk_buff *)(queue);			\
+		     skb = skb->next)
+
 #ifndef DECLARE_TRACE
 
 #define TP_PROTO(args...)	args
-- 
1.7.9.5

