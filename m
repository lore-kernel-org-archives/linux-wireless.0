Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:9052 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756052AbYF0UUA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jun 2008 16:20:00 -0400
From: Pavel Roskin <proski@gnu.org>
Subject: [PATCH 2/5] hostap: fix sparse warnings
To: Jouni Malinen <j@w1.fi>, John W Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Date: Fri, 27 Jun 2008 16:19:58 -0400
Message-ID: <20080627201958.18603.74186.stgit@dv.roinet.com> (sfid-20080627_222009_793970_50AE47DC)
In-Reply-To: <20080627201952.18603.98308.stgit@dv.roinet.com>
References: <20080627201952.18603.98308.stgit@dv.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rewrite AID calculation in handle_pspoll() to avoid truncating bits.
Make hostap_80211_header_parse() static, don't export it.  Avoid
shadowing variables.

Signed-off-by: Pavel Roskin <proski@gnu.org>
---

 drivers/net/wireless/hostap/hostap_80211_rx.c |    6 +++---
 drivers/net/wireless/hostap/hostap_ap.c       |    2 +-
 drivers/net/wireless/hostap/hostap_cs.c       |    8 ++++----
 drivers/net/wireless/hostap/hostap_hw.c       |   10 +++++-----
 drivers/net/wireless/hostap/hostap_main.c     |    5 ++---
 5 files changed, 15 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/hostap/hostap_80211_rx.c b/drivers/net/wireless/hostap/hostap_80211_rx.c
index 47884c3..020f450 100644
--- a/drivers/net/wireless/hostap/hostap_80211_rx.c
+++ b/drivers/net/wireless/hostap/hostap_80211_rx.c
@@ -64,7 +64,7 @@ int prism2_rx_80211(struct net_device *dev, struct sk_buff *skb,
 	int hdrlen, phdrlen, head_need, tail_need;
 	u16 fc;
 	int prism_header, ret;
-	struct ieee80211_hdr_4addr *hdr;
+	struct ieee80211_hdr_4addr *fhdr;
 
 	iface = netdev_priv(dev);
 	local = iface->local;
@@ -83,8 +83,8 @@ int prism2_rx_80211(struct net_device *dev, struct sk_buff *skb,
 		phdrlen = 0;
 	}
 
-	hdr = (struct ieee80211_hdr_4addr *) skb->data;
-	fc = le16_to_cpu(hdr->frame_ctl);
+	fhdr = (struct ieee80211_hdr_4addr *) skb->data;
+	fc = le16_to_cpu(fhdr->frame_ctl);
 
 	if (type == PRISM2_RX_MGMT && (fc & IEEE80211_FCTL_VERS)) {
 		printk(KERN_DEBUG "%s: dropped management frame with header "
diff --git a/drivers/net/wireless/hostap/hostap_ap.c b/drivers/net/wireless/hostap/hostap_ap.c
index 06b23df..af3d4ef 100644
--- a/drivers/net/wireless/hostap/hostap_ap.c
+++ b/drivers/net/wireless/hostap/hostap_ap.c
@@ -1930,7 +1930,7 @@ static void handle_pspoll(local_info_t *local,
 		PDEBUG(DEBUG_PS, "   PSPOLL and AID[15:14] not set\n");
 		return;
 	}
-	aid &= ~BIT(15) & ~BIT(14);
+	aid &= ~(BIT(15) | BIT(14));
 	if (aid == 0 || aid > MAX_AID_TABLE_SIZE) {
 		PDEBUG(DEBUG_PS, "   invalid aid=%d\n", aid);
 		return;
diff --git a/drivers/net/wireless/hostap/hostap_cs.c b/drivers/net/wireless/hostap/hostap_cs.c
index ed4317a..80039a0 100644
--- a/drivers/net/wireless/hostap/hostap_cs.c
+++ b/drivers/net/wireless/hostap/hostap_cs.c
@@ -533,10 +533,10 @@ static void prism2_detach(struct pcmcia_device *link)
 do { last_fn = (fn); if ((last_ret = (ret)) != 0) goto cs_failed; } while (0)
 
 #define CFG_CHECK2(fn, retf) \
-do { int ret = (retf); \
-if (ret != 0) { \
-	PDEBUG(DEBUG_EXTRA, "CardServices(" #fn ") returned %d\n", ret); \
-	cs_error(link, fn, ret); \
+do { int _ret = (retf); \
+if (_ret != 0) { \
+	PDEBUG(DEBUG_EXTRA, "CardServices(" #fn ") returned %d\n", _ret); \
+	cs_error(link, fn, _ret); \
 	goto next_entry; \
 } \
 } while (0)
diff --git a/drivers/net/wireless/hostap/hostap_hw.c b/drivers/net/wireless/hostap/hostap_hw.c
index cdf90c4..936f52e 100644
--- a/drivers/net/wireless/hostap/hostap_hw.c
+++ b/drivers/net/wireless/hostap/hostap_hw.c
@@ -2835,7 +2835,7 @@ static void hostap_passive_scan(unsigned long data)
 {
 	local_info_t *local = (local_info_t *) data;
 	struct net_device *dev = local->dev;
-	u16 channel;
+	u16 chan;
 
 	if (local->passive_scan_interval <= 0)
 		return;
@@ -2872,11 +2872,11 @@ static void hostap_passive_scan(unsigned long data)
 
 		printk(KERN_DEBUG "%s: passive scan channel %d\n",
 		       dev->name, local->passive_scan_channel);
-		channel = local->passive_scan_channel;
+		chan = local->passive_scan_channel;
 		local->passive_scan_state = PASSIVE_SCAN_WAIT;
 		local->passive_scan_timer.expires = jiffies + HZ / 10;
 	} else {
-		channel = local->channel;
+		chan = local->channel;
 		local->passive_scan_state = PASSIVE_SCAN_LISTEN;
 		local->passive_scan_timer.expires = jiffies +
 			local->passive_scan_interval * HZ;
@@ -2884,9 +2884,9 @@ static void hostap_passive_scan(unsigned long data)
 
 	if (hfa384x_cmd_callback(dev, HFA384X_CMDCODE_TEST |
 				 (HFA384X_TEST_CHANGE_CHANNEL << 8),
-				 channel, NULL, 0))
+				 chan, NULL, 0))
 		printk(KERN_ERR "%s: passive scan channel set %d "
-		       "failed\n", dev->name, channel);
+		       "failed\n", dev->name, chan);
 
 	add_timer(&local->passive_scan_timer);
 }
diff --git a/drivers/net/wireless/hostap/hostap_main.c b/drivers/net/wireless/hostap/hostap_main.c
index f7aec93..a38e85f 100644
--- a/drivers/net/wireless/hostap/hostap_main.c
+++ b/drivers/net/wireless/hostap/hostap_main.c
@@ -594,7 +594,8 @@ void hostap_dump_tx_header(const char *name, const struct hfa384x_tx_frame *tx)
 }
 
 
-int hostap_80211_header_parse(const struct sk_buff *skb, unsigned char *haddr)
+static int hostap_80211_header_parse(const struct sk_buff *skb,
+				     unsigned char *haddr)
 {
 	struct hostap_interface *iface = netdev_priv(skb->dev);
 	local_info_t *local = iface->local;
@@ -857,7 +858,6 @@ const struct header_ops hostap_80211_ops = {
 	.rebuild	= eth_rebuild_header,
 	.cache		= eth_header_cache,
 	.cache_update	= eth_header_cache_update,
-
 	.parse		= hostap_80211_header_parse,
 };
 EXPORT_SYMBOL(hostap_80211_ops);
@@ -1150,7 +1150,6 @@ EXPORT_SYMBOL(hostap_set_roaming);
 EXPORT_SYMBOL(hostap_set_auth_algs);
 EXPORT_SYMBOL(hostap_dump_rx_header);
 EXPORT_SYMBOL(hostap_dump_tx_header);
-EXPORT_SYMBOL(hostap_80211_header_parse);
 EXPORT_SYMBOL(hostap_80211_get_hdrlen);
 EXPORT_SYMBOL(hostap_get_stats);
 EXPORT_SYMBOL(hostap_setup_dev);
