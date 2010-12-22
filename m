Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46792 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193Ab0LVVLF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Dec 2010 16:11:05 -0500
Subject: [PATCH] compat: remove print_mac et al
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 22 Dec 2010 22:11:05 +0100
Message-ID: <1293052265.3531.26.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This has disappeared upstream and is no longer used.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 compat/compat-2.6.24.c        |    9 ---------
 include/linux/compat-2.6.24.h |    7 -------
 2 files changed, 0 insertions(+), 16 deletions(-)

diff --git a/compat/compat-2.6.24.c b/compat/compat-2.6.24.c
index 5e2a77d..b9ae16b 100644
--- a/compat/compat-2.6.24.c
+++ b/compat/compat-2.6.24.c
@@ -18,15 +18,6 @@
 struct net init_net;
 EXPORT_SYMBOL(init_net);
 
-/* Part of net/ethernet/eth.c as of 2.6.24 */
-char *print_mac(char *buf, const u8 *addr)
-{
-	sprintf(buf, MAC_FMT,
-		addr[0], addr[1], addr[2], addr[3], addr[4], addr[5]);
-	return buf;
-}
-EXPORT_SYMBOL(print_mac);
-
 /* 2.6.22 and 2.6.23 have eth_header_cache_update defined as extern in include/linux/etherdevice.h
  * and actually defined in net/ethernet/eth.c but 2.6.24 exports it. Lets export it here */
 
diff --git a/include/linux/compat-2.6.24.h b/include/linux/compat-2.6.24.h
index 6e09530..456dcb6 100644
--- a/include/linux/compat-2.6.24.h
+++ b/include/linux/compat-2.6.24.h
@@ -162,13 +162,6 @@ struct ssb_device_id {
 #define dev_get_by_index(a, b)		dev_get_by_index(b)
 #define __dev_get_by_index(a, b)	__dev_get_by_index(b)
 
-/*
- * Display a 6 byte device address (MAC) in a readable format.
- */
-#define MAC_FMT "%02x:%02x:%02x:%02x:%02x:%02x"
-extern char *print_mac(char *buf, const u8 *addr);
-#define DECLARE_MAC_BUF(var) char var[18] __maybe_unused
-
 extern int		eth_header(struct sk_buff *skb, struct net_device *dev,
 				unsigned short type, void *daddr,
 				void *saddr, unsigned len);
-- 
1.7.2.3



