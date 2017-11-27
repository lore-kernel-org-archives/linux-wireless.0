Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.13]:50301 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752096AbdK0Ltb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 27 Nov 2017 06:49:31 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: y2038@lists.linaro.org, Arnd Bergmann <arnd@arndb.de>,
        Johannes Berg <johannes.berg@intel.com>,
        Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Iain Hunter <drhunter95@gmail.com>,
        "Reizer, Eyal" <eyalr@ti.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] wlcore: use boottime for fw time sync
Date: Mon, 27 Nov 2017 12:48:19 +0100
Message-Id: <20171127114903.2779545-1-arnd@arndb.de> (sfid-20171127_125003_673329_A6645012)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Using getnstimeofday()/timespec_to_ns() causes an overflow on 32-bit
architectures in 2038, and may suffer from time jumps due to
settimeofday() or leap seconds.

I don't see a reason why this needs to be UTC, so either monotonic
or boot time would be better here. Assuming that the fw time keeps
running during suspend, boottime is better than monotonic, and
ktime_get_boot_ns() will also save the additional conversion to
nanoseconds.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/wireless/ti/wlcore/main.c | 4 +---
 drivers/net/wireless/ti/wlcore/tx.c   | 4 +---
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index d47921a84509..946a7124b09e 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -388,7 +388,6 @@ static void wl12xx_irq_update_links_status(struct wl1271 *wl,
 static int wlcore_fw_status(struct wl1271 *wl, struct wl_fw_status *status)
 {
 	struct wl12xx_vif *wlvif;
-	struct timespec ts;
 	u32 old_tx_blk_count = wl->tx_blocks_available;
 	int avail, freed_blocks;
 	int i;
@@ -485,8 +484,7 @@ static int wlcore_fw_status(struct wl1271 *wl, struct wl_fw_status *status)
 	}
 
 	/* update the host-chipset time offset */
-	getnstimeofday(&ts);
-	wl->time_offset = (timespec_to_ns(&ts) >> 10) -
+	wl->time_offset = (ktime_get_boot_ns() >> 10) -
 		(s64)(status->fw_localtime);
 
 	wl->fw_fast_lnk_map = status->link_fast_bitmap;
diff --git a/drivers/net/wireless/ti/wlcore/tx.c b/drivers/net/wireless/ti/wlcore/tx.c
index a3f5e9ca492a..00e9b4624dcf 100644
--- a/drivers/net/wireless/ti/wlcore/tx.c
+++ b/drivers/net/wireless/ti/wlcore/tx.c
@@ -264,7 +264,6 @@ static void wl1271_tx_fill_hdr(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 			       struct sk_buff *skb, u32 extra,
 			       struct ieee80211_tx_info *control, u8 hlid)
 {
-	struct timespec ts;
 	struct wl1271_tx_hw_descr *desc;
 	int ac, rate_idx;
 	s64 hosttime;
@@ -287,8 +286,7 @@ static void wl1271_tx_fill_hdr(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 	}
 
 	/* configure packet life time */
-	getnstimeofday(&ts);
-	hosttime = (timespec_to_ns(&ts) >> 10);
+	hosttime = (ktime_get_boot_ns() >> 10);
 	desc->start_time = cpu_to_le32(hosttime - wl->time_offset);
 
 	is_dummy = wl12xx_is_dummy_packet(wl, skb);
-- 
2.9.0
