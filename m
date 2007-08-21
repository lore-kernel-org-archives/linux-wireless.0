Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:47430 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760366AbXHUPFJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Aug 2007 11:05:09 -0400
Message-Id: <20070821150040.175527000@sipsolutions.net>
References: <20070821145905.689978000@sipsolutions.net>
Date: Tue, 21 Aug 2007 16:59:09 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Jiri Benc <jbenc@suse.cz>, Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 04/27] mac80211: fix key debugfs
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes two issues with the key debugfs:
 1) key index obviously isn't unique
 2) various missing break statements led to bogus output

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 net/mac80211/debugfs_key.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- wireless-dev.orig/net/mac80211/debugfs_key.c	2007-08-21 16:17:35.565923881 +0200
+++ wireless-dev/net/mac80211/debugfs_key.c	2007-08-21 16:25:21.405923881 +0200
@@ -77,14 +77,17 @@ static ssize_t key_tx_spec_read(struct f
 	switch (key->alg) {
 	case ALG_WEP:
 		len = scnprintf(buf, sizeof(buf), "\n");
+		break;
 	case ALG_TKIP:
 		len = scnprintf(buf, sizeof(buf), "%08x %04x\n",
 				key->u.tkip.iv32,
 				key->u.tkip.iv16);
+		break;
 	case ALG_CCMP:
 		tpn = key->u.ccmp.tx_pn;
 		len = scnprintf(buf, sizeof(buf), "%02x%02x%02x%02x%02x%02x\n",
 				tpn[0], tpn[1], tpn[2], tpn[3], tpn[4], tpn[5]);
+		break;
 	default:
 		return 0;
 	}
@@ -103,6 +106,7 @@ static ssize_t key_rx_spec_read(struct f
 	switch (key->alg) {
 	case ALG_WEP:
 		len = scnprintf(buf, sizeof(buf), "\n");
+		break;
 	case ALG_TKIP:
 		for (i = 0; i < NUM_RX_DATA_QUEUES; i++)
 			p += scnprintf(p, sizeof(buf)+buf-p,
@@ -110,6 +114,7 @@ static ssize_t key_rx_spec_read(struct f
 				       key->u.tkip.iv32_rx[i],
 				       key->u.tkip.iv16_rx[i]);
 		len = p - buf;
+		break;
 	case ALG_CCMP:
 		for (i = 0; i < NUM_RX_DATA_QUEUES; i++) {
 			rpn = key->u.ccmp.rx_pn[i];
@@ -119,6 +124,7 @@ static ssize_t key_rx_spec_read(struct f
 				       rpn[3], rpn[4], rpn[5]);
 		}
 		len = p - buf;
+		break;
 	default:
 		return 0;
 	}
@@ -164,12 +170,14 @@ KEY_OPS(key);
 void ieee80211_debugfs_key_add(struct ieee80211_local *local,
 			       struct ieee80211_key *key)
 {
+	static int keycount;
 	char buf[20];
 
 	if (!local->debugfs.keys)
 		return;
 
-	sprintf(buf, "%d", key->keyidx);
+	sprintf(buf, "%d", keycount);
+	keycount++;
 	key->debugfs.dir = debugfs_create_dir(buf,
 					local->debugfs.keys);
 
@@ -239,7 +247,7 @@ void ieee80211_debugfs_key_sta_link(stru
 	if (!key->debugfs.dir)
 		return;
 
-	sprintf(buf, "../sta/" MAC_FMT, MAC_ARG(sta->addr));
+	sprintf(buf, "../../stations/" MAC_FMT, MAC_ARG(sta->addr));
 	key->debugfs.stalink =
 		debugfs_create_symlink("station", key->debugfs.dir, buf);
 }

-- 

