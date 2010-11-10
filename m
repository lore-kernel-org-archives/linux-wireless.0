Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:47672 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753136Ab0KJCVs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Nov 2010 21:21:48 -0500
Received: by mail-qy0-f174.google.com with SMTP id 12so2500227qyk.19
        for <linux-wireless@vger.kernel.org>; Tue, 09 Nov 2010 18:21:48 -0800 (PST)
From: Arnaud Lacombe <lacombar@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: lrodriguez@atheros.com, Arnaud Lacombe <lacombar@gmail.com>
Subject: [PATCH 32/44] compat/2.6.22: add compat inline for ip_hdrlen()
Date: Tue,  9 Nov 2010 21:20:14 -0500
Message-Id: <1289355626-25373-33-git-send-email-lacombar@gmail.com>
In-Reply-To: <1289355626-25373-1-git-send-email-lacombar@gmail.com>
References: <1289355626-25373-1-git-send-email-lacombar@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
---
 include/linux/compat-2.6.22.h |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/include/linux/compat-2.6.22.h b/include/linux/compat-2.6.22.h
index 73dbbb6..6675027 100644
--- a/include/linux/compat-2.6.22.h
+++ b/include/linux/compat-2.6.22.h
@@ -85,6 +85,11 @@ static inline struct iphdr *ip_hdr(const struct sk_buff *skb)
 	return (struct iphdr *)skb_network_header(skb);
 }
 
+static inline unsigned int ip_hdrlen(const struct sk_buff *skb)
+{
+	return ip_hdr(skb)->ihl * 4;
+}
+
 static inline struct tcphdr *tcp_hdr(const struct sk_buff *skb)
 {
 	return (struct tcphdr *)skb_transport_header(skb);
-- 
1.7.2.30.gc37d7.dirty

