Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46195 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752061AbXBWAMP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Feb 2007 19:12:15 -0500
Received: from shell0.pdx.osdl.net (fw.osdl.org [65.172.181.6])
	by smtp.osdl.org (8.12.8/8.12.8) with ESMTP id l1N0CEhB022701
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <linux-wireless@vger.kernel.org>; Thu, 22 Feb 2007 16:12:14 -0800
Received: from freekitty (unknown-230.office.pdx.osdl.net [10.8.0.230])
	by shell0.pdx.osdl.net (8.13.1/8.11.6) with ESMTP id l1N0CDKC030536
	for <linux-wireless@vger.kernel.org>; Thu, 22 Feb 2007 16:12:14 -0800
Date: Thu, 22 Feb 2007 16:10:14 -0800
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 1/3] d80211: use const
Message-ID: <20070222161014.62d064a6@freekitty>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Use const to indicate constant arguments and encapsulation headers.

Signed-off-by: Stephen Hemminger <shemminger@linux-foundation.org>
---
 include/net/d80211.h     |    2 +-
 net/d80211/ieee80211.c   |   39 ++++++++++++++++++++-------------------
 net/d80211/ieee80211_i.h |    2 +-
 3 files changed, 22 insertions(+), 21 deletions(-)

diff --git a/include/net/d80211.h b/include/net/d80211.h
index 551fe46..5f291e9 100644
--- a/include/net/d80211.h
+++ b/include/net/d80211.h
@@ -931,7 +931,7 @@ int ieee80211_set_aid_for_sta(struct iee
  * headers). If the data in the sk_buff is too short to contain a valid 802.11
  * header the function returns 0.
  */
-int ieee80211_get_hdrlen_from_skb(struct sk_buff *skb);
+int ieee80211_get_hdrlen_from_skb(const struct sk_buff *skb);
 
 /* Like ieee80211_get_hdrlen_from_skb() but takes a FC in CPU order. */
 int ieee80211_get_hdrlen(u16 fc);
diff --git a/net/d80211/ieee80211.c b/net/d80211/ieee80211.c
index 273cba1..73e34a0 100644
--- a/net/d80211/ieee80211.c
+++ b/net/d80211/ieee80211.c
@@ -34,15 +34,16 @@ #include "ieee80211_led.h"
 
 /* See IEEE 802.1H for LLC/SNAP encapsulation/decapsulation */
 /* Ethernet-II snap header (RFC1042 for most EtherTypes) */
-static unsigned char rfc1042_header[] =
-{ 0xaa, 0xaa, 0x03, 0x00, 0x00, 0x00 };
+static const unsigned char rfc1042_header[] =
+	{ 0xaa, 0xaa, 0x03, 0x00, 0x00, 0x00 };
+
 /* Bridge-Tunnel header (for EtherTypes ETH_P_AARP and ETH_P_IPX) */
-static unsigned char bridge_tunnel_header[] =
-{ 0xaa, 0xaa, 0x03, 0x00, 0x00, 0xf8 };
-/* No encapsulation header if EtherType < 0x600 (=length) */
+static const unsigned char bridge_tunnel_header[] =
+	{ 0xaa, 0xaa, 0x03, 0x00, 0x00, 0xf8 };
 
-static unsigned char eapol_header[] =
-{ 0xaa, 0xaa, 0x03, 0x00, 0x00, 0x00, 0x88, 0x8e };
+/* No encapsulation header if EtherType < 0x600 (=length) */
+static const unsigned char eapol_header[] =
+	{ 0xaa, 0xaa, 0x03, 0x00, 0x00, 0x00, 0x88, 0x8e };
 
 
 static u8 * ieee80211_get_bssid(struct ieee80211_hdr *hdr, size_t len);
@@ -52,7 +53,7 @@ static int ieee80211_mgmt_start_xmit(str
 
 struct ieee80211_key_conf *
 ieee80211_key_data2conf(struct ieee80211_local *local,
-			struct ieee80211_key *data)
+			const struct ieee80211_key *data)
 {
 	struct ieee80211_key_conf *conf;
 
@@ -114,7 +115,7 @@ void ieee80211_key_release(struct kobjec
 	kfree(key);
 }
 
-static int rate_list_match(int *rate_list, int rate)
+static int rate_list_match(const int *rate_list, int rate)
 {
 	int i;
 
@@ -269,9 +270,9 @@ int ieee80211_get_hdrlen(u16 fc)
 }
 EXPORT_SYMBOL(ieee80211_get_hdrlen);
 
-int ieee80211_get_hdrlen_from_skb(struct sk_buff *skb)
+int ieee80211_get_hdrlen_from_skb(const struct sk_buff *skb)
 {
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
+	const struct ieee80211_hdr *hdr = (const struct ieee80211_hdr *) skb->data;
 	int hdrlen;
 
 	if (unlikely(skb->len < 10))
@@ -285,9 +286,9 @@ EXPORT_SYMBOL(ieee80211_get_hdrlen_from_
 
 #ifdef CONFIG_D80211_LOWTX_FRAME_DUMP
 static void ieee80211_dump_frame(const char *ifname, const char *title,
-				 struct sk_buff *skb)
+				 const struct sk_buff *skb)
 {
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
+	const struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 	u16 fc;
 	int hdrlen;
 
@@ -322,16 +323,16 @@ static inline void ieee80211_dump_frame(
 #endif /* CONFIG_D80211_LOWTX_FRAME_DUMP */
 
 
-static int ieee80211_is_eapol(struct sk_buff *skb)
+static int ieee80211_is_eapol(const struct sk_buff *skb)
 {
-	struct ieee80211_hdr *hdr;
+	const struct ieee80211_hdr *hdr;
 	u16 fc;
 	int hdrlen;
 
 	if (unlikely(skb->len < 10))
 		return 0;
 
-	hdr = (struct ieee80211_hdr *) skb->data;
+	hdr = (const struct ieee80211_hdr *) skb->data;
 	fc = le16_to_cpu(hdr->frame_control);
 
 	if (unlikely(!WLAN_FC_DATA_PRESENT(fc)))
@@ -1118,13 +1119,13 @@ static void inline ieee80211_tx_prepare(
 	__ieee80211_tx_prepare(tx, skb, dev, control);
 }
 
-static inline int __ieee80211_queue_stopped(struct ieee80211_local *local,
+static inline int __ieee80211_queue_stopped(const struct ieee80211_local *local,
 					    int queue)
 {
 	return test_bit(IEEE80211_LINK_STATE_XOFF, &local->state[queue]);
 }
 
-static inline int __ieee80211_queue_pending(struct ieee80211_local *local,
+static inline int __ieee80211_queue_pending(const struct ieee80211_local *local,
 					    int queue)
 {
 	return test_bit(IEEE80211_LINK_STATE_PENDING, &local->state[queue]);
@@ -1429,7 +1430,7 @@ static int ieee80211_subif_start_xmit(st
 	int ret = 1, head_need;
 	u16 ethertype, hdrlen, fc;
 	struct ieee80211_hdr hdr;
-	u8 *encaps_data;
+	const u8 *encaps_data;
         int encaps_len, skip_header_bytes;
 	int nh_pos, h_pos, no_encrypt = 0;
 	struct sta_info *sta;
diff --git a/net/d80211/ieee80211_i.h b/net/d80211/ieee80211_i.h
index 0c3b054..71eb25f 100644
--- a/net/d80211/ieee80211_i.h
+++ b/net/d80211/ieee80211_i.h
@@ -607,7 +607,7 @@ int ieee80211_if_config(struct net_devic
 int ieee80211_if_config_beacon(struct net_device *dev);
 struct ieee80211_key_conf *
 ieee80211_key_data2conf(struct ieee80211_local *local,
-			struct ieee80211_key *data);
+			const struct ieee80211_key *data);
 struct ieee80211_key *ieee80211_key_alloc(struct ieee80211_sub_if_data *sdata,
 					  int idx, size_t key_len, gfp_t flags);
 void ieee80211_key_free(struct ieee80211_key *key);
-- 
1.4.1

