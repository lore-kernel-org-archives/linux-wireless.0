Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog126.obsmtp.com ([74.125.149.155]:41833 "EHLO
	na3sys009aog126.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753673Ab1LMNqP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Dec 2011 08:46:15 -0500
Received: by laah2 with SMTP id h2so1587362laa.3
        for <linux-wireless@vger.kernel.org>; Tue, 13 Dec 2011 05:46:12 -0800 (PST)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com
Subject: [PATCH] wl12xx: remove deprecated packet detection threshold config
Date: Tue, 13 Dec 2011 15:45:54 +0200
Message-Id: <1323783954-26402-1-git-send-email-coelho@ti.com> (sfid-20111213_144618_817711_1CEB4085)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The ACX_PD_THRESHOLD configuration command is deprecated and should
not be used anymore.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/wl12xx/acx.c  |   26 --------------------------
 drivers/net/wireless/wl12xx/acx.h  |    8 --------
 drivers/net/wireless/wl12xx/init.c |   16 ----------------
 drivers/net/wireless/wl12xx/init.h |    1 -
 drivers/net/wireless/wl12xx/main.c |    5 -----
 5 files changed, 0 insertions(+), 56 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/acx.c b/drivers/net/wireless/wl12xx/acx.c
index bde1d86..7537c40 100644
--- a/drivers/net/wireless/wl12xx/acx.c
+++ b/drivers/net/wireless/wl12xx/acx.c
@@ -186,32 +186,6 @@ out:
 	return ret;
 }
 
-int wl1271_acx_pd_threshold(struct wl1271 *wl)
-{
-	struct acx_packet_detection *pd;
-	int ret;
-
-	wl1271_debug(DEBUG_ACX, "acx data pd threshold");
-
-	pd = kzalloc(sizeof(*pd), GFP_KERNEL);
-	if (!pd) {
-		ret = -ENOMEM;
-		goto out;
-	}
-
-	pd->threshold = cpu_to_le32(wl->conf.rx.packet_detection_threshold);
-
-	ret = wl1271_cmd_configure(wl, ACX_PD_THRESHOLD, pd, sizeof(*pd));
-	if (ret < 0) {
-		wl1271_warning("failed to set pd threshold: %d", ret);
-		goto out;
-	}
-
-out:
-	kfree(pd);
-	return ret;
-}
-
 int wl1271_acx_slot(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 		    enum acx_slot_type slot_time)
 {
diff --git a/drivers/net/wireless/wl12xx/acx.h b/drivers/net/wireless/wl12xx/acx.h
index b2d85be..69892b4 100644
--- a/drivers/net/wireless/wl12xx/acx.h
+++ b/drivers/net/wireless/wl12xx/acx.h
@@ -171,13 +171,6 @@ struct acx_rx_msdu_lifetime {
 	__le32 lifetime;
 } __packed;
 
-struct acx_packet_detection {
-	struct acx_header header;
-
-	__le32 threshold;
-} __packed;
-
-
 enum acx_slot_type {
 	SLOT_TIME_LONG = 0,
 	SLOT_TIME_SHORT = 1,
@@ -1238,7 +1231,6 @@ int wl1271_acx_feature_cfg(struct wl1271 *wl, struct wl12xx_vif *wlvif);
 int wl1271_acx_mem_map(struct wl1271 *wl,
 		       struct acx_header *mem_map, size_t len);
 int wl1271_acx_rx_msdu_life_time(struct wl1271 *wl);
-int wl1271_acx_pd_threshold(struct wl1271 *wl);
 int wl1271_acx_slot(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 		    enum acx_slot_type slot_time);
 int wl1271_acx_group_address_tbl(struct wl1271 *wl, struct wl12xx_vif *wlvif,
diff --git a/drivers/net/wireless/wl12xx/init.c b/drivers/net/wireless/wl12xx/init.c
index 7662514..ca7ee59 100644
--- a/drivers/net/wireless/wl12xx/init.c
+++ b/drivers/net/wireless/wl12xx/init.c
@@ -223,17 +223,6 @@ static int wl12xx_init_rx_config(struct wl1271 *wl)
 	return 0;
 }
 
-int wl1271_init_phy_config(struct wl1271 *wl)
-{
-	int ret;
-
-	ret = wl1271_acx_pd_threshold(wl);
-	if (ret < 0)
-		return ret;
-
-	return 0;
-}
-
 static int wl12xx_init_phy_vif_config(struct wl1271 *wl,
 					    struct wl12xx_vif *wlvif)
 {
@@ -706,11 +695,6 @@ int wl1271_hw_init(struct wl1271 *wl)
 	if (ret < 0)
 		goto out_free_memmap;
 
-	/* PHY layer config */
-	ret = wl1271_init_phy_config(wl);
-	if (ret < 0)
-		goto out_free_memmap;
-
 	ret = wl1271_acx_dco_itrim_params(wl);
 	if (ret < 0)
 		goto out_free_memmap;
diff --git a/drivers/net/wireless/wl12xx/init.h b/drivers/net/wireless/wl12xx/init.h
index 81140b8..2da0f40 100644
--- a/drivers/net/wireless/wl12xx/init.h
+++ b/drivers/net/wireless/wl12xx/init.h
@@ -28,7 +28,6 @@
 
 int wl1271_hw_init_power_auth(struct wl1271 *wl);
 int wl1271_init_templates_config(struct wl1271 *wl);
-int wl1271_init_phy_config(struct wl1271 *wl);
 int wl1271_init_pta(struct wl1271 *wl);
 int wl1271_init_energy_detection(struct wl1271 *wl);
 int wl1271_chip_specific_init(struct wl1271 *wl);
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 2f7bfa8..2d80d4a 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -674,11 +674,6 @@ static int wl1271_plt_init(struct wl1271 *wl)
 	if (ret < 0)
 		return ret;
 
-	/* PHY layer config */
-	ret = wl1271_init_phy_config(wl);
-	if (ret < 0)
-		goto out_free_memmap;
-
 	ret = wl12xx_acx_mem_cfg(wl);
 	if (ret < 0)
 		goto out_free_memmap;
-- 
1.7.4.1

