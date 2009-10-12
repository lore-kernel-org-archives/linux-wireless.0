Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:56596 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758068AbZJLVUE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Oct 2009 17:20:04 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/9] [compat-2.6 and compat-stable] Remove unused code
Date: Mon, 12 Oct 2009 23:19:11 +0200
Message-Id: <1255382358-20760-4-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1255382358-20760-1-git-send-email-hauke@hauke-m.de>
References: <1255382358-20760-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,28) can not be true in
compat-2.6.28.h. The definitions are not needed in compat-wireless any
more. Removing this does not break compiling with mainline kernel 2.6.25
to 2.6.32

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 compat/compat-2.6.28.h |   24 ------------------------
 1 files changed, 0 insertions(+), 24 deletions(-)

diff --git a/compat/compat-2.6.28.h b/compat/compat-2.6.28.h
index 90d080c..dd223c6 100644
--- a/compat/compat-2.6.28.h
+++ b/compat/compat-2.6.28.h
@@ -146,22 +146,6 @@ static inline void skb_queue_splice_tail_init(struct sk_buff_head *list,
 	}
 } /* From include/linux/skbuff.h */
 
-struct module;
-struct tracepoint;
-
-#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,28))
-struct tracepoint {
-	const char *name;		/* Tracepoint name */
-	int state;			/* State. */
-	void **funcs;
-} __attribute__((aligned(32)));		/*
-					 * Aligned on 32 bytes because it is
-					 * globally visible and gcc happily
-					 * align these on the structure size.
-					 * Keep in sync with vmlinux.lds.h.
-					 */
-#endif
-
 #ifndef DECLARE_TRACE
 
 #define TP_PROTO(args...)	args
@@ -181,17 +165,9 @@ struct tracepoint {
 		return -ENOSYS;						\
 	}
 
-#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,28))
-#define DEFINE_TRACE(name)
-#endif
 #define EXPORT_TRACEPOINT_SYMBOL_GPL(name)
 #define EXPORT_TRACEPOINT_SYMBOL(name)
 
-#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,28))
-static inline void tracepoint_update_probe_range(struct tracepoint *begin,
-	struct tracepoint *end)
-{ }
-#endif
 
 #endif
 
-- 
1.6.2.1

