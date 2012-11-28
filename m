Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:39239 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753477Ab2K1JnR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2012 04:43:17 -0500
Received: by mail-wi0-f174.google.com with SMTP id hm9so5345542wib.1
        for <linux-wireless@vger.kernel.org>; Wed, 28 Nov 2012 01:43:17 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 11/20] wlcore/wl18xx: change priority calculations for links
Date: Wed, 28 Nov 2012 11:42:40 +0200
Message-Id: <1354095769-8724-12-git-send-email-arik@wizery.com> (sfid-20121128_104356_086934_409BD0F6)
In-Reply-To: <1354095769-8724-1-git-send-email-arik@wizery.com>
References: <1354095769-8724-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Update the 18xx FW status private part to include Tx related link
priorities. Introduce new HW ops to determine link priority per chip
family.

For 18xx the changes are:
- Suspended links are at most low priority and Tx for them is stopped
  beyond the suspend threshold.
- Active links now get their thresholds directly from FW
- There's a new "stop" threshold for active links, at which point a link
  stops receiving new packets.

Update the min 18xx FW version required to make sure suspended links
bitmap is advertised by the FW.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wl12xx/main.c   |   22 ++++++++++++++++
 drivers/net/wireless/ti/wl18xx/main.c   |   41 ++++++++++++++++++++++++++++
 drivers/net/wireless/ti/wl18xx/wl18xx.h |   44 ++++++++++++++++++++++++++++++-
 drivers/net/wireless/ti/wlcore/hw_ops.h |   19 +++++++++++++
 drivers/net/wireless/ti/wlcore/tx.c     |   18 +++----------
 drivers/net/wireless/ti/wlcore/wlcore.h |    4 +++
 6 files changed, 132 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/ti/wl12xx/main.c b/drivers/net/wireless/ti/wl12xx/main.c
index a03a847..be26d35 100644
--- a/drivers/net/wireless/ti/wl12xx/main.c
+++ b/drivers/net/wireless/ti/wl12xx/main.c
@@ -1642,6 +1642,26 @@ static u32 wl12xx_convert_hwaddr(struct wl1271 *wl, u32 hwaddr)
 	return hwaddr << 5;
 }
 
+static bool wl12xx_lnk_high_prio(struct wl1271 *wl, u8 hlid,
+				 struct wl1271_link *lnk)
+{
+	u8 thold;
+
+	if (test_bit(hlid, (unsigned long *)&wl->fw_fast_lnk_map))
+		thold = wl->conf.tx.fast_link_thold;
+	else
+		thold = wl->conf.tx.slow_link_thold;
+
+	return lnk->allocated_pkts < thold;
+}
+
+static bool wl12xx_lnk_low_prio(struct wl1271 *wl, u8 hlid,
+				struct wl1271_link *lnk)
+{
+	/* any link is good for low priority */
+	return true;
+}
+
 static int wl12xx_setup(struct wl1271 *wl);
 
 static struct wlcore_ops wl12xx_ops = {
@@ -1680,6 +1700,8 @@ static struct wlcore_ops wl12xx_ops = {
 	.pre_pkt_send		= NULL,
 	.set_peer_cap		= wl12xx_set_peer_cap,
 	.convert_hwaddr = wl12xx_convert_hwaddr,
+	.lnk_high_prio		= wl12xx_lnk_high_prio,
+	.lnk_low_prio		= wl12xx_lnk_low_prio,
 };
 
 static struct ieee80211_sta_ht_cap wl12xx_ht_cap = {
diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index dc73f8a..3836dbd 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -1433,6 +1433,45 @@ static u32 wl18xx_convert_hwaddr(struct wl1271 *wl, u32 hwaddr)
 	return hwaddr & ~0x80000000;
 }
 
+static bool wl18xx_lnk_high_prio(struct wl1271 *wl, u8 hlid,
+				 struct wl1271_link *lnk)
+{
+	u8 thold;
+	struct wl18xx_fw_status_priv *status_priv =
+		(struct wl18xx_fw_status_priv *)wl->fw_status_2->priv;
+	u32 suspend_bitmap = le32_to_cpu(status_priv->link_suspend_bitmap);
+
+	/* suspended links are never high priority */
+	if (test_bit(hlid, (unsigned long *)&suspend_bitmap))
+		return false;
+
+	/* the priority thresholds are taken from FW */
+	if (test_bit(hlid, (unsigned long *)&wl->fw_fast_lnk_map))
+		thold = status_priv->tx_fast_link_prio_threshold;
+	else
+		thold = status_priv->tx_slow_link_prio_threshold;
+
+	return lnk->allocated_pkts < thold;
+}
+
+static bool wl18xx_lnk_low_prio(struct wl1271 *wl, u8 hlid,
+				struct wl1271_link *lnk)
+{
+	u8 thold;
+	struct wl18xx_fw_status_priv *status_priv =
+		(struct wl18xx_fw_status_priv *)wl->fw_status_2->priv;
+	u32 suspend_bitmap = le32_to_cpu(status_priv->link_suspend_bitmap);
+
+	if (test_bit(hlid, (unsigned long *)&suspend_bitmap))
+		thold = status_priv->tx_suspend_threshold;
+	else if (test_bit(hlid, (unsigned long *)&wl->fw_fast_lnk_map))
+		thold = status_priv->tx_fast_stop_threshold;
+	else
+		thold = status_priv->tx_slow_stop_threshold;
+
+	return lnk->allocated_pkts < thold;
+}
+
 static int wl18xx_setup(struct wl1271 *wl);
 
 static struct wlcore_ops wl18xx_ops = {
@@ -1471,6 +1510,8 @@ static struct wlcore_ops wl18xx_ops = {
 	.sta_rc_update	= wl18xx_sta_rc_update,
 	.set_peer_cap	= wl18xx_set_peer_cap,
 	.convert_hwaddr = wl18xx_convert_hwaddr,
+	.lnk_high_prio	= wl18xx_lnk_high_prio,
+	.lnk_low_prio	= wl18xx_lnk_low_prio,
 };
 
 /* HT cap appropriate for wide channels in 2Ghz */
diff --git a/drivers/net/wireless/ti/wl18xx/wl18xx.h b/drivers/net/wireless/ti/wl18xx/wl18xx.h
index 4d295a5..53bae22 100644
--- a/drivers/net/wireless/ti/wl18xx/wl18xx.h
+++ b/drivers/net/wireless/ti/wl18xx/wl18xx.h
@@ -68,7 +68,49 @@ struct wl18xx_fw_status_priv {
 	 */
 	u8 released_tx_desc[WL18XX_FW_MAX_TX_STATUS_DESC];
 
-	u8 padding[2];
+	/*
+	 * A bitmap representing the currently suspended links. The suspend
+	 * is short lived, for multi-channel Tx requirements.
+	 */
+	__le32 link_suspend_bitmap;
+
+	/*
+	 * packet threshold for an "almost empty" AC,
+	 * for Tx schedulng purposes
+	 */
+	u8 tx_ac_threshold;
+
+	/* number of packets to queue up for a link in PS */
+	u8 tx_ps_threshold;
+
+	/* number of packet to queue up for a suspended link */
+	u8 tx_suspend_threshold;
+
+	/*
+	 * Should have less than this number of packets in queue of a slow
+	 * link to qualify as high priority link
+	 */
+	u8 tx_slow_link_prio_threshold;
+
+	/*
+	 * Should have less than this number of packets in queue of a fast
+	 * link to qualify as high priority link
+	 */
+	u8 tx_fast_link_prio_threshold;
+
+	/*
+	 * Should have less than this number of packets in queue of a slow
+	 * link before we stop queuing up packets for it.
+	 */
+	u8 tx_slow_stop_threshold;
+
+	/*
+	 * Should have less than this number of packets in queue of a fast
+	 * link before we stop queuing up packets for it.
+	 */
+	u8 tx_fast_stop_threshold;
+
+	u8 padding[3];
 };
 
 #define WL18XX_PHY_VERSION_MAX_LEN 20
diff --git a/drivers/net/wireless/ti/wlcore/hw_ops.h b/drivers/net/wireless/ti/wlcore/hw_ops.h
index 802a345..58aa848 100644
--- a/drivers/net/wireless/ti/wlcore/hw_ops.h
+++ b/drivers/net/wireless/ti/wlcore/hw_ops.h
@@ -231,4 +231,23 @@ wlcore_hw_convert_hwaddr(struct wl1271 *wl, u32 hwaddr)
 	return wl->ops->convert_hwaddr(wl, hwaddr);
 }
 
+static inline bool
+wlcore_hw_lnk_high_prio(struct wl1271 *wl, u8 hlid,
+			struct wl1271_link *lnk)
+{
+	if (!wl->ops->lnk_high_prio)
+		BUG_ON(1);
+
+	return wl->ops->lnk_high_prio(wl, hlid, lnk);
+}
+
+static inline bool
+wlcore_hw_lnk_low_prio(struct wl1271 *wl, u8 hlid,
+		       struct wl1271_link *lnk)
+{
+	if (!wl->ops->lnk_low_prio)
+		BUG_ON(1);
+
+	return wl->ops->lnk_low_prio(wl, hlid, lnk);
+}
 #endif
diff --git a/drivers/net/wireless/ti/wlcore/tx.c b/drivers/net/wireless/ti/wlcore/tx.c
index d34945a..3a56a87 100644
--- a/drivers/net/wireless/ti/wlcore/tx.c
+++ b/drivers/net/wireless/ti/wlcore/tx.c
@@ -504,28 +504,16 @@ static struct sk_buff *wlcore_lnk_dequeue(struct wl1271 *wl,
 	return skb;
 }
 
-static bool wlcore_lnk_high_prio(struct wl1271 *wl, u8 hlid,
-				 struct wl1271_link *lnk)
-{
-	u8 thold;
-
-	if (test_bit(hlid, (unsigned long *)&wl->fw_fast_lnk_map))
-		thold = wl->conf.tx.fast_link_thold;
-	else
-		thold = wl->conf.tx.slow_link_thold;
-
-	return lnk->allocated_pkts < thold;
-}
-
 static struct sk_buff *wlcore_lnk_dequeue_high_prio(struct wl1271 *wl,
 						    u8 hlid, u8 ac,
 						    u8 *low_prio_hlid)
 {
 	struct wl1271_link *lnk = &wl->links[hlid];
 
-	if (!wlcore_lnk_high_prio(wl, hlid, lnk)) {
+	if (!wlcore_hw_lnk_high_prio(wl, hlid, lnk)) {
 		if (*low_prio_hlid == WL12XX_INVALID_LINK_ID &&
-		    !skb_queue_empty(&lnk->tx_queue[ac]))
+		    !skb_queue_empty(&lnk->tx_queue[ac]) &&
+		    wlcore_hw_lnk_low_prio(wl, hlid, lnk))
 			/* we found the first non-empty low priority queue */
 			*low_prio_hlid = hlid;
 
diff --git a/drivers/net/wireless/ti/wlcore/wlcore.h b/drivers/net/wireless/ti/wlcore/wlcore.h
index f48f57a..cf0290a 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore.h
@@ -111,6 +111,10 @@ struct wlcore_ops {
 			    bool allow_ht_operation,
 			    u32 rate_set, u8 hlid);
 	u32 (*convert_hwaddr)(struct wl1271 *wl, u32 hwaddr);
+	bool (*lnk_high_prio)(struct wl1271 *wl, u8 hlid,
+			      struct wl1271_link *lnk);
+	bool (*lnk_low_prio)(struct wl1271 *wl, u8 hlid,
+			      struct wl1271_link *lnk);
 };
 
 enum wlcore_partitions {
-- 
1.7.9.5

