Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f212.google.com ([209.85.217.212]:57613 "EHLO
	mail-gx0-f212.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753601AbZLAIkE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Dec 2009 03:40:04 -0500
Received: by mail-gx0-f212.google.com with SMTP id 4so3477390gxk.8
        for <linux-wireless@vger.kernel.org>; Tue, 01 Dec 2009 00:40:11 -0800 (PST)
From: Arnaud Lacombe <lacombar@gmail.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: mcgrof@bombadil.infradead.org, linux-wireless@vger.kernel.org,
	Arnaud Lacombe <lacombar@gmail.com>
Subject: [PATCH 3/5] Add more `skb->dst' accessors
Date: Tue,  1 Dec 2009 03:38:19 -0500
Message-Id: <1259656701-12329-3-git-send-email-lacombar@gmail.com>
In-Reply-To: <1259656701-12329-2-git-send-email-lacombar@gmail.com>
References: <4B0B4405.4050605@gmail.com>
 <1259656701-12329-1-git-send-email-lacombar@gmail.com>
 <1259656701-12329-2-git-send-email-lacombar@gmail.com>
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

