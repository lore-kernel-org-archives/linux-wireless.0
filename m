Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:50541 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756101Ab0KVBaU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Nov 2010 20:30:20 -0500
Received: by yxf34 with SMTP id 34so3762161yxf.19
        for <linux-wireless@vger.kernel.org>; Sun, 21 Nov 2010 17:30:19 -0800 (PST)
From: Arnaud Lacombe <lacombar@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: lrodriguez@atheros.com, Arnaud Lacombe <lacombar@gmail.com>
Subject: [PATCH] compat/2.6.22: limit namespace pollution
Date: Sun, 21 Nov 2010 20:30:06 -0500
Message-Id: <1290389406-29852-1-git-send-email-lacombar@gmail.com>
In-Reply-To: <AANLkTi=BQckk2sXtR1VJ2khoK37YE=4t6k+wPb-CHhaw@mail.gmail.com>
References: <AANLkTi=BQckk2sXtR1VJ2khoK37YE=4t6k+wPb-CHhaw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
---
 include/linux/compat-2.6.22.h |   38 ++++++++++++++++++++++++++------------
 1 files changed, 26 insertions(+), 12 deletions(-)

diff --git a/include/linux/compat-2.6.22.h b/include/linux/compat-2.6.22.h
index 7c0c615..4fefe49 100644
--- a/include/linux/compat-2.6.22.h
+++ b/include/linux/compat-2.6.22.h
@@ -3,19 +3,19 @@
 
 #include <linux/version.h>
 
 /* Compat work for 2.6.21 */
 #if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,22))
 
-#include <linux/pci.h>
-#include <linux/skbuff.h>
+/* <linux/netdevice.h> */
+#ifdef _LINUX_NETDEVICE_H
+#ifdef CONFIG_AX25
+#error "Compat reuses the AX.25 pointer so that may not be enabled!"
+#endif
 
 /* reuse ax25_ptr */
 #define ieee80211_ptr ax25_ptr
-
-#ifdef CONFIG_AX25
-#error Compat reuses the AX.25 pointer so that may not be enabled!
 #endif
 
+/* <linux/skbuff.h> */
+#ifdef _LINUX_SKBUFF_H
 static inline unsigned char *skb_mac_header(const struct sk_buff *skb)
 {
 	return skb->mac.raw;
@@ -61,11 +61,6 @@ static inline unsigned char *skb_tail_pointer(const struct sk_buff *skb)
 	return skb->tail;
 }
 
-static inline struct iphdr *ip_hdr(const struct sk_buff *skb)
-{
-	return (struct iphdr *)skb_network_header(skb);
-}
-
 static inline void skb_copy_from_linear_data(const struct sk_buff *skb,
 					     void *to,
 					     const unsigned int len)
@@ -79,17 +74,26 @@ static inline void skb_copy_from_linear_data_offset(const struct sk_buff *skb,
 {
 	memcpy(to, skb->data + offset, len);
 }
+#endif /* _LINUX_SKBUFF_H */
 
+/* <linux/ip.h> */
+#ifdef _LINUX_IP_H
+static inline struct iphdr *ip_hdr(const struct sk_buff *skb)
+{
+	return (struct iphdr *)skb_network_header(skb);
+}
+#endif
 
+/* <net/ip.h> */
+#ifdef _IP_H
 static inline unsigned int ip_hdrlen(const struct sk_buff *skb)
 {
 	return ip_hdr(skb)->ihl * 4;
 }
+#endif
 
+/* <linux/tcp.h> */
+#ifdef _LINUX_TCP_H
 static inline struct tcphdr *tcp_hdr(const struct sk_buff *skb)
 {
 	return (struct tcphdr *)skb_transport_header(skb);
@@ -104,7 +108,10 @@ static inline unsigned int tcp_optlen(const struct sk_buff *skb)
 {
 	return (tcp_hdr(skb)->doff - 5) * 4;
 }
+#endif
 
+/* <linux/compiler.h> */
+#ifdef __LINUX_COMPILER_H
 #if defined(__GNUC__)
 #define __maybe_unused		__attribute__((unused))
 #define uninitialized_var(x)	x = x
@@ -117,12 +124,19 @@ static inline unsigned int tcp_optlen(const struct sk_buff *skb)
 #ifndef uninitialized_var
 #define uninitialized_var(x)	x
 #endif
+#endif /* __LINUX_COMPILER_H */
 
+/* <net/netlink.h> */
+#ifdef __NET_NETLINK_H
 /* This will lead to very weird behaviour... */
 #define NLA_BINARY NLA_STRING
+#endif
 
+/* <linux/list.h> */
+#ifdef _LINUX_LIST_H
 #define list_first_entry(ptr, type, member) \
         list_entry((ptr)->next, type, member)
+#endif
 
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,22)) */
 
-- 
1.7.2.30.gc37d7.dirty

