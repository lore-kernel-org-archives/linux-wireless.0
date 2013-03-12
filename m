Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:45528 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755450Ab3CLNpf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Mar 2013 09:45:35 -0400
From: Luciano Coelho <coelho@ti.com>
To: <linux-wireless@vger.kernel.org>
CC: <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 03/13] wlcore: fix link count in single-link-PSM optimization
Date: Tue, 12 Mar 2013 15:44:14 +0200
Message-ID: <1363095864-24422-4-git-send-email-coelho@ti.com> (sfid-20130312_144550_089011_6612A675)
In-Reply-To: <1363095864-24422-1-git-send-email-coelho@ti.com>
References: <1363095864-24422-1-git-send-email-coelho@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

commit 144614f3eebd7d only allowed a single active link when
turning on the optimization, ignoring the fact that an AP has two
additional global links.
Use 3 links as an indication for a single active link. Use the
FW PSM bits to verify the extra active link belongs to the AP role.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wlcore/main.c |   10 +++++++---
 drivers/net/wireless/ti/wlcore/tx.c   |   10 +++++++---
 2 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 3fc86c4..389ae1a 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -332,10 +332,9 @@ static void wl12xx_irq_ps_regulate_link(struct wl1271 *wl,
 					struct wl12xx_vif *wlvif,
 					u8 hlid, u8 tx_pkts)
 {
-	bool fw_ps, single_link;
+	bool fw_ps;
 
 	fw_ps = test_bit(hlid, (unsigned long *)&wl->ap_fw_ps_map);
-	single_link = (wl->active_link_count == 1);
 
 	/*
 	 * Wake up from high level PS if the STA is asleep with too little
@@ -348,8 +347,13 @@ static void wl12xx_irq_ps_regulate_link(struct wl1271 *wl,
 	 * Start high-level PS if the STA is asleep with enough blocks in FW.
 	 * Make an exception if this is the only connected link. In this
 	 * case FW-memory congestion is less of a problem.
+	 * Note that a single connected STA means 3 active links, since we must
+	 * account for the global and broadcast AP links. The "fw_ps" check
+	 * assures us the third link is a STA connected to the AP. Otherwise
+	 * the FW would not set the PSM bit.
 	 */
-	else if (!single_link && fw_ps && tx_pkts >= WL1271_PS_STA_MAX_PACKETS)
+	else if (wl->active_link_count > 3 && fw_ps &&
+		 tx_pkts >= WL1271_PS_STA_MAX_PACKETS)
 		wl12xx_ps_link_start(wl, wlvif, hlid, true);
 }
 
diff --git a/drivers/net/wireless/ti/wlcore/tx.c b/drivers/net/wireless/ti/wlcore/tx.c
index ece392c..07a3e42 100644
--- a/drivers/net/wireless/ti/wlcore/tx.c
+++ b/drivers/net/wireless/ti/wlcore/tx.c
@@ -104,7 +104,7 @@ static void wl1271_tx_regulate_link(struct wl1271 *wl,
 				    struct wl12xx_vif *wlvif,
 				    u8 hlid)
 {
-	bool fw_ps, single_link;
+	bool fw_ps;
 	u8 tx_pkts;
 
 	if (WARN_ON(!test_bit(hlid, wlvif->links_map)))
@@ -112,15 +112,19 @@ static void wl1271_tx_regulate_link(struct wl1271 *wl,
 
 	fw_ps = test_bit(hlid, (unsigned long *)&wl->ap_fw_ps_map);
 	tx_pkts = wl->links[hlid].allocated_pkts;
-	single_link = (wl->active_link_count == 1);
 
 	/*
 	 * if in FW PS and there is enough data in FW we can put the link
 	 * into high-level PS and clean out its TX queues.
 	 * Make an exception if this is the only connected link. In this
 	 * case FW-memory congestion is less of a problem.
+	 * Note that a single connected STA means 3 active links, since we must
+	 * account for the global and broadcast AP links. The "fw_ps" check
+	 * assures us the third link is a STA connected to the AP. Otherwise
+	 * the FW would not set the PSM bit.
 	 */
-	if (!single_link && fw_ps && tx_pkts >= WL1271_PS_STA_MAX_PACKETS)
+	if (wl->active_link_count > 3 && fw_ps &&
+	    tx_pkts >= WL1271_PS_STA_MAX_PACKETS)
 		wl12xx_ps_link_start(wl, wlvif, hlid, true);
 }
 
-- 
1.7.10.4

