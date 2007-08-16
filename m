Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:49532 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754506AbXHPNLp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Aug 2007 09:11:45 -0400
Subject: [PATCH] mac80211: fix key debugfs
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 16 Aug 2007 14:44:14 +0200
Message-Id: <1187268254.5141.24.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Looks like I was dreaming when writing that code.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 net/mac80211/debugfs_key.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- wireless-dev.orig/net/mac80211/debugfs_key.c	2007-08-15 20:06:36.003475381 +0200
+++ wireless-dev/net/mac80211/debugfs_key.c	2007-08-15 20:19:47.383475381 +0200
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
@@ -239,7 +245,7 @@ void ieee80211_debugfs_key_sta_link(stru
 	if (!key->debugfs.dir)
 		return;
 
-	sprintf(buf, "../sta/" MAC_FMT, MAC_ARG(sta->addr));
+	sprintf(buf, "../../stations/" MAC_FMT, MAC_ARG(sta->addr));
 	key->debugfs.stalink =
 		debugfs_create_symlink("station", key->debugfs.dir, buf);
 }


