Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:37984 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755425Ab2AXJGx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jan 2012 04:06:53 -0500
Received: by mail-lpp01m010-f48.google.com with SMTP id z14so1338292lag.21
        for <linux-wireless@vger.kernel.org>; Tue, 24 Jan 2012 01:06:52 -0800 (PST)
MIME-Version: 1.0
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com
Subject: [PATCH 6/8] wl12xx: read chip ID and HW PG version during probe
Date: Tue, 24 Jan 2012 11:06:27 +0200
Message-Id: <1327395989-29663-7-git-send-email-coelho@ti.com> (sfid-20120124_100705_611176_B451889C)
In-Reply-To: <1327395989-29663-1-git-send-email-coelho@ti.com>
References: <1327395989-29663-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In order to read the MAC addresses from the fuse ROM, we need to know
the chip ID and the HW PG version.  We need to know the MAC address
during probe, because that's when we register our HW with mac80211.

To prepare for that, this patch reads the chip ID and HW PG version
during probe instead of doing it at boot time.  We power the chip on
briefly in order to do that.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/wl12xx/boot.c  |   15 ---------
 drivers/net/wireless/wl12xx/debug.h |    1 +
 drivers/net/wireless/wl12xx/main.c  |   59 ++++++++++++++++++++++++++--------
 3 files changed, 46 insertions(+), 29 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/boot.c b/drivers/net/wireless/wl12xx/boot.c
index 84d2951..599919e 100644
--- a/drivers/net/wireless/wl12xx/boot.c
+++ b/drivers/net/wireless/wl12xx/boot.c
@@ -488,19 +488,6 @@ static int wl1271_boot_write_irq_polarity(struct wl1271 *wl)
 	return 0;
 }
 
-static void wl1271_boot_hw_version(struct wl1271 *wl)
-{
-	u32 fuse;
-
-	if (wl->chip.id == CHIP_ID_1283_PG20)
-		fuse = wl1271_top_reg_read(wl, WL128X_REG_FUSE_DATA_2_1);
-	else
-		fuse = wl1271_top_reg_read(wl, WL127X_REG_FUSE_DATA_2_1);
-	fuse = (fuse & PG_VER_MASK) >> PG_VER_OFFSET;
-
-	wl->hw_pg_ver = (s8)fuse;
-}
-
 static int wl128x_switch_tcxo_to_fref(struct wl1271 *wl)
 {
 	u16 spare_reg;
@@ -694,8 +681,6 @@ int wl1271_load_firmware(struct wl1271 *wl)
 	u32 tmp, clk;
 	int selected_clock = -1;
 
-	wl1271_boot_hw_version(wl);
-
 	if (wl->chip.id == CHIP_ID_1283_PG20) {
 		ret = wl128x_boot_clk(wl, &selected_clock);
 		if (ret < 0)
diff --git a/drivers/net/wireless/wl12xx/debug.h b/drivers/net/wireless/wl12xx/debug.h
index b85fd8c4..ec0fdc2 100644
--- a/drivers/net/wireless/wl12xx/debug.h
+++ b/drivers/net/wireless/wl12xx/debug.h
@@ -51,6 +51,7 @@ enum {
 	DEBUG_FILTERS   = BIT(15),
 	DEBUG_ADHOC     = BIT(16),
 	DEBUG_AP	= BIT(17),
+	DEBUG_PROBE	= BIT(18),
 	DEBUG_MASTER	= (DEBUG_ADHOC | DEBUG_AP),
 	DEBUG_ALL	= ~0,
 };
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 6ec22b3..315ffec 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -1232,10 +1232,9 @@ static int wl1271_setup(struct wl1271 *wl)
 	return 0;
 }
 
-static int wl1271_chip_wakeup(struct wl1271 *wl)
+static int wl12xx_set_power_on(struct wl1271 *wl)
 {
-	struct wl1271_partition_set partition;
-	int ret = 0;
+	int ret;
 
 	msleep(WL1271_PRE_POWER_ON_SLEEP);
 	ret = wl1271_power_on(wl);
@@ -1245,20 +1244,22 @@ static int wl1271_chip_wakeup(struct wl1271 *wl)
 	wl1271_io_reset(wl);
 	wl1271_io_init(wl);
 
-	/* We don't need a real memory partition here, because we only want
-	 * to use the registers at this point. */
-	memset(&partition, 0, sizeof(partition));
-	partition.reg.start = REGISTERS_BASE;
-	partition.reg.size = REGISTERS_DOWN_SIZE;
-	wl1271_set_partition(wl, &partition);
+	wl1271_set_partition(wl, &wl12xx_part_table[PART_DOWN]);
 
 	/* ELP module wake up */
 	wl1271_fw_wakeup(wl);
 
-	/* whal_FwCtrl_BootSm() */
+out:
+	return ret;
+}
 
-	/* 0. read chip id from CHIP_ID */
-	wl->chip.id = wl1271_read32(wl, CHIP_ID_B);
+static int wl1271_chip_wakeup(struct wl1271 *wl)
+{
+	int ret = 0;
+
+	ret = wl12xx_set_power_on(wl);
+	if (ret < 0)
+		goto out;
 
 	/*
 	 * For wl127x based devices we could use the default block
@@ -4855,6 +4856,29 @@ static struct bin_attribute fwlog_attr = {
 	.read = wl1271_sysfs_read_fwlog,
 };
 
+static int wl12xx_get_hw_info(struct wl1271 *wl)
+{
+	int ret;
+	u32 die_info;
+
+	ret = wl12xx_set_power_on(wl);
+	if (ret < 0)
+		goto out;
+
+	wl->chip.id = wl1271_read32(wl, CHIP_ID_B);
+
+	if (wl->chip.id == CHIP_ID_1283_PG20)
+		die_info = wl1271_top_reg_read(wl, WL128X_REG_FUSE_DATA_2_1);
+	else
+		die_info = wl1271_top_reg_read(wl, WL127X_REG_FUSE_DATA_2_1);
+
+	wl->hw_pg_ver = (s8) (die_info & PG_VER_MASK) >> PG_VER_OFFSET;
+
+	wl1271_power_off(wl);
+out:
+	return ret;
+}
+
 static int wl1271_register_hw(struct wl1271 *wl)
 {
 	int ret;
@@ -4862,6 +4886,12 @@ static int wl1271_register_hw(struct wl1271 *wl)
 	if (wl->mac80211_registered)
 		return 0;
 
+	ret = wl12xx_get_hw_info(wl);
+	if (ret < 0) {
+		wl1271_error("couldn't get hw info");
+		goto out;
+	}
+
 	ret = wl1271_fetch_nvs(wl);
 	if (ret == 0) {
 		/* NOTE: The wl->nvs->nvs element must be first, in
@@ -4883,7 +4913,7 @@ static int wl1271_register_hw(struct wl1271 *wl)
 	ret = ieee80211_register_hw(wl->hw);
 	if (ret < 0) {
 		wl1271_error("unable to register mac80211 hw: %d", ret);
-		return ret;
+		goto out;
 	}
 
 	wl->mac80211_registered = true;
@@ -4894,7 +4924,8 @@ static int wl1271_register_hw(struct wl1271 *wl)
 
 	wl1271_notice("loaded");
 
-	return 0;
+out:
+	return ret;
 }
 
 static void wl1271_unregister_hw(struct wl1271 *wl)
-- 
1.7.4.1

