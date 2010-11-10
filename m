Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:65142 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754940Ab0KJCVl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Nov 2010 21:21:41 -0500
Received: by mail-qw0-f46.google.com with SMTP id 5so5749qwh.19
        for <linux-wireless@vger.kernel.org>; Tue, 09 Nov 2010 18:21:41 -0800 (PST)
From: Arnaud Lacombe <lacombar@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: lrodriguez@atheros.com, Arnaud Lacombe <lacombar@gmail.com>
Subject: [PATCH 31/44] compat/2.6.22: add compat for couple of TCP accessors
Date: Tue,  9 Nov 2010 21:20:13 -0500
Message-Id: <1289355626-25373-32-git-send-email-lacombar@gmail.com>
In-Reply-To: <1289355626-25373-1-git-send-email-lacombar@gmail.com>
References: <1289355626-25373-1-git-send-email-lacombar@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
---
 include/linux/compat-2.6.22.h |   20 ++++++++++++++++++++
 1 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/include/linux/compat-2.6.22.h b/include/linux/compat-2.6.22.h
index e0cdab2..73dbbb6 100644
--- a/include/linux/compat-2.6.22.h
+++ b/include/linux/compat-2.6.22.h
@@ -80,6 +80,26 @@ static inline void skb_copy_from_linear_data_offset(const struct sk_buff *skb,
 	memcpy(to, skb->data + offset, len);
 }
 
+static inline struct iphdr *ip_hdr(const struct sk_buff *skb)
+{
+	return (struct iphdr *)skb_network_header(skb);
+}
+
+static inline struct tcphdr *tcp_hdr(const struct sk_buff *skb)
+{
+	return (struct tcphdr *)skb_transport_header(skb);
+}
+
+static inline unsigned int tcp_hdrlen(const struct sk_buff *skb)
+{
+	return tcp_hdr(skb)->doff * 4;
+}
+
+static inline unsigned int tcp_optlen(const struct sk_buff *skb)
+{
+	return (tcp_hdr(skb)->doff - 5) * 4;
+}
+
 #if defined(__GNUC__)
 #define __maybe_unused		__attribute__((unused))
 #define uninitialized_var(x)	x = x
-- 
1.7.2.30.gc37d7.dirty

