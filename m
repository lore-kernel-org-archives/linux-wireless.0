Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f182.google.com ([209.85.211.182]:46844 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757786AbZKXC0b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Nov 2009 21:26:31 -0500
Received: by ywh12 with SMTP id 12so5947609ywh.21
        for <linux-wireless@vger.kernel.org>; Mon, 23 Nov 2009 18:26:38 -0800 (PST)
Message-ID: <4B0B441C.8090801@gmail.com>
Date: Mon, 23 Nov 2009 21:25:32 -0500
From: Arnaud Lacombe <lacombar@gmail.com>
MIME-Version: 1.0
To: mcgrof@bombadil.infradead.org
CC: linux-wireless@vger.kernel.org, lrodriguez@atheros.com
Subject: [PATCH 11/13] Add more `skb->dst' accessors
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
---
 compat-2.6.31.h |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/compat-2.6.31.h b/compat-2.6.31.h
index a91e033..6b2dd5e 100644
--- a/compat-2.6.31.h
+++ b/compat-2.6.31.h
@@ -99,6 +99,21 @@ static inline void skb_dst_drop(struct sk_buff *skb)
 	skb->dst = NULL;
 }

+static inline struct dst_entry *skb_dst(const struct sk_buff *skb)
+{
+	return (struct dst_entry *)skb->dst;
+}
+
+static inline void skb_dst_set(struct sk_buff *skb, struct dst_entry *dst)
+{
+	skb->dst = (unsigned long)dst;
+}
+
+static inline struct rtable *skb_rtable(const struct sk_buff *skb)
+{
+	return (struct rtable *)skb_dst(skb);
+}
+
 extern int genl_register_family_with_ops(struct genl_family *family,
 	struct genl_ops *ops, size_t n_ops);

-- 
1.6.3.3.385.g60647.dirty


