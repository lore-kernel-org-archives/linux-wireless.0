Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:47335 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754562Ab0L1Rhd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Dec 2010 12:37:33 -0500
Received: by mail-ew0-f46.google.com with SMTP id 5so4468650ewy.19
        for <linux-wireless@vger.kernel.org>; Tue, 28 Dec 2010 09:37:32 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <luciano.coelho@nokia.com>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH v3 13/18] wl1271: AP mode - changes in TX path
Date: Tue, 28 Dec 2010 19:36:43 +0200
Message-Id: <1293557808-27068-14-git-send-email-arik@wizery.com>
In-Reply-To: <1293557808-27068-1-git-send-email-arik@wizery.com>
References: <1293557808-27068-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When in AP mode set appropriate HLID and rate policy for each skb.
Respond to supported-rates related changes in op_tx only when acting
as STA.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c |    3 +-
 drivers/net/wireless/wl12xx/tx.c   |   55 ++++++++++++++++++++++++++++++------
 2 files changed, 48 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index b8a3d6d..3747d98 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -943,7 +943,8 @@ static int wl1271_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 	spin_lock_irqsave(&wl->wl_lock, flags);
 	if (sta &&
 	    (sta->supp_rates[conf->channel->band] !=
-	    (wl->sta_rate_set & HW_BG_RATES_MASK))) {
+	    (wl->sta_rate_set & HW_BG_RATES_MASK)) &&
+		wl->bss_type != BSS_TYPE_AP_BSS) {
 		wl->sta_rate_set = sta->supp_rates[conf->channel->band];
 		set_bit(WL1271_FLAG_STA_RATES_CHANGED, &wl->flags);
 	}
diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/wl12xx/tx.c
index a93fc47..3245c24 100644
--- a/drivers/net/wireless/wl12xx/tx.c
+++ b/drivers/net/wireless/wl12xx/tx.c
@@ -23,6 +23,7 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/etherdevice.h>
 
 #include "wl12xx.h"
 #include "io.h"
@@ -99,7 +100,7 @@ static void wl1271_tx_fill_hdr(struct wl1271 *wl, struct sk_buff *skb,
 {
 	struct timespec ts;
 	struct wl1271_tx_hw_descr *desc;
-	int pad, ac;
+	int pad, ac, rate_idx;
 	s64 hosttime;
 	u16 tx_attr;
 
@@ -117,7 +118,11 @@ static void wl1271_tx_fill_hdr(struct wl1271 *wl, struct sk_buff *skb,
 	getnstimeofday(&ts);
 	hosttime = (timespec_to_ns(&ts) >> 10);
 	desc->start_time = cpu_to_le32(hosttime - wl->time_offset);
-	desc->life_time = cpu_to_le16(TX_HW_MGMT_PKT_LIFETIME_TU);
+
+	if (wl->bss_type != BSS_TYPE_AP_BSS)
+		desc->life_time = cpu_to_le16(TX_HW_MGMT_PKT_LIFETIME_TU);
+	else
+		desc->life_time = cpu_to_le16(TX_HW_AP_MODE_PKT_LIFETIME_TU);
 
 	/* configure the tx attributes */
 	tx_attr = wl->session_counter << TX_HW_ATTR_OFST_SESSION_COUNTER;
@@ -125,7 +130,41 @@ static void wl1271_tx_fill_hdr(struct wl1271 *wl, struct sk_buff *skb,
 	/* queue (we use same identifiers for tid's and ac's */
 	ac = wl1271_tx_get_queue(skb_get_queue_mapping(skb));
 	desc->tid = ac;
-	desc->aid = TX_HW_DEFAULT_AID;
+
+	if (wl->bss_type != BSS_TYPE_AP_BSS) {
+		desc->aid = TX_HW_DEFAULT_AID;
+
+		/* if the packets are destined for AP (have a STA entry)
+		   send them with AP rate policies, otherwise use default
+		   basic rates */
+		if (control->control.sta)
+			rate_idx = ACX_TX_AP_FULL_RATE;
+		else
+			rate_idx = ACX_TX_BASIC_RATE;
+	} else {
+		if (control->control.sta) {
+			struct wl1271_station *wl_sta;
+
+			wl_sta = (struct wl1271_station *)
+					control->control.sta->drv_priv;
+			desc->hlid = wl_sta->hlid;
+			rate_idx = ac;
+		} else {
+			struct ieee80211_hdr *hdr;
+
+			hdr = (struct ieee80211_hdr *)
+						(skb->data + sizeof(*desc));
+			if (ieee80211_is_mgmt(hdr->frame_control)) {
+				desc->hlid = WL1271_AP_GLOBAL_HLID;
+				rate_idx = ACX_TX_AP_MODE_MGMT_RATE;
+			} else {
+				desc->hlid = WL1271_AP_BROADCAST_HLID;
+				rate_idx = ACX_TX_AP_MODE_BCST_RATE;
+			}
+		}
+	}
+
+	tx_attr |= rate_idx << TX_HW_ATTR_OFST_RATE_POLICY;
 	desc->reserved = 0;
 
 	/* align the length (and store in terms of words) */
@@ -136,14 +175,12 @@ static void wl1271_tx_fill_hdr(struct wl1271 *wl, struct sk_buff *skb,
 	pad = pad - skb->len;
 	tx_attr |= pad << TX_HW_ATTR_OFST_LAST_WORD_PAD;
 
-	/* if the packets are destined for AP (have a STA entry) send them
-	   with AP rate policies, otherwise use default basic rates */
-	if (control->control.sta)
-		tx_attr |= ACX_TX_AP_FULL_RATE << TX_HW_ATTR_OFST_RATE_POLICY;
-
 	desc->tx_attr = cpu_to_le16(tx_attr);
 
-	wl1271_debug(DEBUG_TX, "tx_fill_hdr: pad: %d", pad);
+	wl1271_debug(DEBUG_TX, "tx_fill_hdr: pad: %d hlid: %d "
+		"tx_attr: 0x%x len: %d life: %d mem: %d", pad, (int)desc->hlid,
+		(int)desc->tx_attr, (int)desc->length, (int)desc->life_time,
+		(int)desc->total_mem_blocks);
 }
 
 /* caller must hold wl->mutex */
-- 
1.7.1

