Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:47124 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758313AbZJLVUq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Oct 2009 17:20:46 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 9/9] [compat-2.6] Add skb_add_rx_frag to backport.
Date: Mon, 12 Oct 2009 23:19:18 +0200
Message-Id: <1255382358-20760-11-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1255382358-20760-1-git-send-email-hauke@hauke-m.de>
References: <1255382358-20760-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is needed by iwl-3945.c.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 compat/compat-2.6.28.c |   10 ++++++++++
 compat/compat-2.6.28.h |    3 +++
 2 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/compat/compat-2.6.28.c b/compat/compat-2.6.28.c
index 33871a2..c379b19 100644
--- a/compat/compat-2.6.28.c
+++ b/compat/compat-2.6.28.c
@@ -275,4 +275,14 @@ unsigned long round_jiffies_up(unsigned long j)
 }
 EXPORT_SYMBOL_GPL(round_jiffies_up);
 
+void skb_add_rx_frag(struct sk_buff *skb, int i, struct page *page, int off,
+		int size)
+{
+	skb_fill_page_desc(skb, i, page, off, size);
+	skb->len += size;
+	skb->data_len += size;
+	skb->truesize += size;
+}
+EXPORT_SYMBOL(skb_add_rx_frag);
+
 #endif /* LINUX_VERSION_CODE < KERNEL_VERSION(2,6,28) */
diff --git a/compat/compat-2.6.28.h b/compat/compat-2.6.28.h
index dd223c6..f158cbe 100644
--- a/compat/compat-2.6.28.h
+++ b/compat/compat-2.6.28.h
@@ -178,6 +178,9 @@ static inline void skb_queue_splice_tail_init(struct sk_buff_head *list,
 
 unsigned long round_jiffies_up(unsigned long j);
 
+extern void skb_add_rx_frag(struct sk_buff *skb, int i, struct page *page,
+			    int off, int size);
+
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,28)) */
 
 #endif /* LINUX_26_28_COMPAT_H */
-- 
1.6.2.1

