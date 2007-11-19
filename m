Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:1835 "EHLO
	mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751846AbXKSJRF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2007 04:17:05 -0500
From: Guillaume Chazarain <guichaz@yahoo.fr>
Subject: [PATCH] ieee80211: Stop net_ratelimit/IEEE80211_DEBUG_DROP log
	pollution
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Date: Mon, 19 Nov 2007 10:07:00 +0100
Message-ID: <20071119090700.24011.97730.stgit@cheypa.inria.fr> (sfid-20071119_091713_186695_B6FF9232)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

if (net_ratelimit())
	IEEE80211_DEBUG_DROP(...)

can pollute the logs with messages like:

printk: 1 messages suppressed.
printk: 2 messages suppressed.
printk: 7 messages suppressed.

if debugging information is disabled. These messages are printed by
net_ratelimit(). Add a wrapper to net_ratelimit() that takes into account
the log level, so that net_ratelimit() is called only when we really want
to print something.

Signed-off-by: Guillaume Chazarain <guichaz@yahoo.fr>
---

 include/net/ieee80211.h              |    8 ++++++++
 net/ieee80211/ieee80211_crypt_ccmp.c |    2 +-
 net/ieee80211/ieee80211_crypt_tkip.c |    4 ++--
 3 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/include/net/ieee80211.h b/include/net/ieee80211.h
index 164d132..d8ae484 100644
--- a/include/net/ieee80211.h
+++ b/include/net/ieee80211.h
@@ -115,8 +115,16 @@ extern u32 ieee80211_debug_level;
 do { if (ieee80211_debug_level & (level)) \
   printk(KERN_DEBUG "ieee80211: %c %s " fmt, \
          in_interrupt() ? 'I' : 'U', __FUNCTION__ , ## args); } while (0)
+static inline bool ieee80211_ratelimit_debug(u32 level)
+{
+	return (ieee80211_debug_level & level) && net_ratelimit();
+}
 #else
 #define IEEE80211_DEBUG(level, fmt, args...) do {} while (0)
+static inline bool ieee80211_ratelimit_debug(u32 level)
+{
+	return false;
+}
 #endif				/* CONFIG_IEEE80211_DEBUG */
 
 /* escape_essid() is intended to be used in debug (and possibly error)
diff --git a/net/ieee80211/ieee80211_crypt_ccmp.c b/net/ieee80211/ieee80211_crypt_ccmp.c
index c6d760d..208bf35 100644
--- a/net/ieee80211/ieee80211_crypt_ccmp.c
+++ b/net/ieee80211/ieee80211_crypt_ccmp.c
@@ -338,7 +338,7 @@ static int ieee80211_ccmp_decrypt(struct sk_buff *skb, int hdr_len, void *priv)
 	pos += 8;
 
 	if (ccmp_replay_check(pn, key->rx_pn)) {
-		if (net_ratelimit()) {
+		if (ieee80211_ratelimit_debug(IEEE80211_DL_DROP)) {
 			IEEE80211_DEBUG_DROP("CCMP: replay detected: STA=%s "
 				 "previous PN %02x%02x%02x%02x%02x%02x "
 				 "received PN %02x%02x%02x%02x%02x%02x\n",
diff --git a/net/ieee80211/ieee80211_crypt_tkip.c b/net/ieee80211/ieee80211_crypt_tkip.c
index 58b2261..8e14694 100644
--- a/net/ieee80211/ieee80211_crypt_tkip.c
+++ b/net/ieee80211/ieee80211_crypt_tkip.c
@@ -464,7 +464,7 @@ static int ieee80211_tkip_decrypt(struct sk_buff *skb, int hdr_len, void *priv)
 	pos += 8;
 
 	if (tkip_replay_check(iv32, iv16, tkey->rx_iv32, tkey->rx_iv16)) {
-		if (net_ratelimit()) {
+		if (ieee80211_ratelimit_debug(IEEE80211_DL_DROP)) {
 			IEEE80211_DEBUG_DROP("TKIP: replay detected: STA=%s"
 			       " previous TSC %08x%04x received TSC "
 			       "%08x%04x\n", print_mac(mac, hdr->addr2),
@@ -504,7 +504,7 @@ static int ieee80211_tkip_decrypt(struct sk_buff *skb, int hdr_len, void *priv)
 			 * it needs to be recalculated for the next packet. */
 			tkey->rx_phase1_done = 0;
 		}
-		if (net_ratelimit()) {
+		if (ieee80211_ratelimit_debug(IEEE80211_DL_DROP)) {
 			IEEE80211_DEBUG_DROP("TKIP: ICV error detected: STA="
 			       "%s\n", print_mac(mac, hdr->addr2));
 		}
