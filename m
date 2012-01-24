Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:60878 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755428Ab2AXJGz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jan 2012 04:06:55 -0500
Received: by mail-lpp01m010-f42.google.com with SMTP id g1so1035036lah.29
        for <linux-wireless@vger.kernel.org>; Tue, 24 Jan 2012 01:06:54 -0800 (PST)
MIME-Version: 1.0
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com, Arik Nemtsov <arik@wizery.com>,
	Igal Chernobelsky <igalc@ti.com>
Subject: [PATCH 7/8] wl12xx: use two MAC addresses based on the NVS or from fuse ROM
Date: Tue, 24 Jan 2012 11:06:28 +0200
Message-Id: <1327395989-29663-8-git-send-email-coelho@ti.com> (sfid-20120124_100712_650812_543C0A68)
In-Reply-To: <1327395989-29663-1-git-send-email-coelho@ti.com>
References: <1327395989-29663-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add support for two MAC addresses.  If the NVS has a valid MAC
address, that takes precedence and we use two sequential address
starting from the one specified.

If the NVS doesn't contain a valid MAC address (ie. if it is set to
00:00:00:00:00:00), we check if the HW PG version in use has the
BD_ADDR written in the fuse ROM.  If it does, we read it and derive
the two subsequent addresses for WLAN.

During production, 3 addresses are reserved per device.  The first for
Bluetooth (burnt in the fuse ROM) and the following two for WLAN.

This patch has some code by Igal and Arik (squashed from internal
patches).

Signed-off-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Igal Chernobelsky <igalc@ti.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/wl12xx/boot.c   |   14 +++---
 drivers/net/wireless/wl12xx/boot.h   |   10 ----
 drivers/net/wireless/wl12xx/main.c   |   99 +++++++++++++++++++++++++++++++---
 drivers/net/wireless/wl12xx/reg.h    |   27 +++++++++
 drivers/net/wireless/wl12xx/wl12xx.h |    7 ++-
 5 files changed, 131 insertions(+), 26 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/boot.c b/drivers/net/wireless/wl12xx/boot.c
index 599919e..32a7f9b 100644
--- a/drivers/net/wireless/wl12xx/boot.c
+++ b/drivers/net/wireless/wl12xx/boot.c
@@ -258,12 +258,12 @@ static int wl1271_boot_upload_nvs(struct wl1271 *wl)
 	}
 
 	/* update current MAC address to NVS */
-	nvs_ptr[11] = wl->mac_addr[0];
-	nvs_ptr[10] = wl->mac_addr[1];
-	nvs_ptr[6] = wl->mac_addr[2];
-	nvs_ptr[5] = wl->mac_addr[3];
-	nvs_ptr[4] = wl->mac_addr[4];
-	nvs_ptr[3] = wl->mac_addr[5];
+	nvs_ptr[11] = wl->addresses[0].addr[0];
+	nvs_ptr[10] = wl->addresses[0].addr[1];
+	nvs_ptr[6] = wl->addresses[0].addr[2];
+	nvs_ptr[5] = wl->addresses[0].addr[3];
+	nvs_ptr[4] = wl->addresses[0].addr[4];
+	nvs_ptr[3] = wl->addresses[0].addr[5];
 
 	/*
 	 * Layout before the actual NVS tables:
@@ -626,7 +626,7 @@ static int wl127x_boot_clk(struct wl1271 *wl)
 	u32 pause;
 	u32 clk;
 
-	if (((wl->hw_pg_ver & PG_MAJOR_VER_MASK) >> PG_MAJOR_VER_OFFSET) < 3)
+	if (WL127X_PG_GET_MAJOR(wl->hw_pg_ver) < 3)
 		wl->quirks |= WL12XX_QUIRK_END_OF_TRANSACTION;
 
 	if (wl->ref_clock == CONF_REF_CLK_19_2_E ||
diff --git a/drivers/net/wireless/wl12xx/boot.h b/drivers/net/wireless/wl12xx/boot.h
index 06dad93..c3adc09 100644
--- a/drivers/net/wireless/wl12xx/boot.h
+++ b/drivers/net/wireless/wl12xx/boot.h
@@ -55,16 +55,6 @@ struct wl1271_static_data {
 #define OCP_REG_CLK_POLARITY 0x0cb2
 #define OCP_REG_CLK_PULL     0x0cb4
 
-#define WL127X_REG_FUSE_DATA_2_1    0x050a
-#define WL128X_REG_FUSE_DATA_2_1    0x2152
-#define PG_VER_MASK          0x3c
-#define PG_VER_OFFSET        2
-
-#define PG_MAJOR_VER_MASK    0x3
-#define PG_MAJOR_VER_OFFSET  0x0
-#define PG_MINOR_VER_MASK    0xc
-#define PG_MINOR_VER_OFFSET  0x2
-
 #define CMD_MBOX_ADDRESS     0x407B4
 
 #define POLARITY_LOW         BIT(1)
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 315ffec..b9c70c6 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -2129,7 +2129,7 @@ static int wl1271_op_add_interface(struct ieee80211_hw *hw,
 		 * we still need this in order to configure the fw
 		 * while uploading the nvs
 		 */
-		memcpy(wl->mac_addr, vif->addr, ETH_ALEN);
+		memcpy(wl->addresses[0].addr, vif->addr, ETH_ALEN);
 
 		booted = wl12xx_init_fw(wl);
 		if (!booted) {
@@ -4856,6 +4856,76 @@ static struct bin_attribute fwlog_attr = {
 	.read = wl1271_sysfs_read_fwlog,
 };
 
+static bool wl12xx_mac_in_fuse(struct wl1271 *wl)
+{
+	bool supported = false;
+	u8 major, minor;
+
+	if (wl->chip.id == CHIP_ID_1283_PG20) {
+		major = WL128X_PG_GET_MAJOR(wl->hw_pg_ver);
+		minor = WL128X_PG_GET_MINOR(wl->hw_pg_ver);
+
+		/* in wl128x we have the MAC address if the PG is >= (2, 1) */
+		if (major > 2 || (major == 2 && minor >= 1))
+			supported = true;
+	} else {
+		major = WL127X_PG_GET_MAJOR(wl->hw_pg_ver);
+		minor = WL127X_PG_GET_MINOR(wl->hw_pg_ver);
+
+		/* in wl127x we have the MAC address if the PG is >= (3, 1) */
+		if (major == 3 && minor >= 1)
+			supported = true;
+	}
+
+	wl1271_debug(DEBUG_PROBE,
+		     "PG Ver major = %d minor = %d, MAC %s present",
+		     major, minor, supported ? "is" : "is not");
+
+	return supported;
+}
+
+static void wl12xx_derive_mac_addresses(struct wl1271 *wl,
+					u32 oui, u32 nic, int n)
+{
+	int i;
+
+	wl1271_debug(DEBUG_PROBE, "base address: oui %06x nic %06x, n %d",
+		     oui, nic, n);
+
+	if (nic + n - 1 > 0xffffff)
+		wl1271_warning("NIC part of the MAC address wraps around!");
+
+	for (i = 0; i < n; i++) {
+		wl->addresses[i].addr[0] = (u8)(oui >> 16);
+		wl->addresses[i].addr[1] = (u8)(oui >> 8);
+		wl->addresses[i].addr[2] = (u8) oui;
+		wl->addresses[i].addr[3] = (u8)(nic >> 16);
+		wl->addresses[i].addr[4] = (u8)(nic >> 8);
+		wl->addresses[i].addr[5] = (u8) nic;
+		nic++;
+	}
+
+	wl->hw->wiphy->n_addresses = n;
+	wl->hw->wiphy->addresses = wl->addresses;
+}
+
+static void wl12xx_get_fuse_mac(struct wl1271 *wl)
+{
+	u32 mac1, mac2;
+
+	wl1271_set_partition(wl, &wl12xx_part_table[PART_DRPW]);
+
+	mac1 = wl1271_read32(wl, WL12XX_REG_FUSE_BD_ADDR_1);
+	mac2 = wl1271_read32(wl, WL12XX_REG_FUSE_BD_ADDR_2);
+
+	/* these are the two parts of the BD_ADDR */
+	wl->fuse_oui_addr = ((mac2 & 0xffff) << 8) +
+		((mac1 & 0xff000000) >> 24);
+	wl->fuse_nic_addr = mac1 & 0xffffff;
+
+	wl1271_set_partition(wl, &wl12xx_part_table[PART_DOWN]);
+}
+
 static int wl12xx_get_hw_info(struct wl1271 *wl)
 {
 	int ret;
@@ -4874,6 +4944,13 @@ static int wl12xx_get_hw_info(struct wl1271 *wl)
 
 	wl->hw_pg_ver = (s8) (die_info & PG_VER_MASK) >> PG_VER_OFFSET;
 
+	if (!wl12xx_mac_in_fuse(wl)) {
+		wl->fuse_oui_addr = 0;
+		wl->fuse_nic_addr = 0;
+	} else {
+		wl12xx_get_fuse_mac(wl);
+	}
+
 	wl1271_power_off(wl);
 out:
 	return ret;
@@ -4882,6 +4959,7 @@ out:
 static int wl1271_register_hw(struct wl1271 *wl)
 {
 	int ret;
+	u32 oui_addr = 0, nic_addr = 0;
 
 	if (wl->mac80211_registered)
 		return 0;
@@ -4900,15 +4978,20 @@ static int wl1271_register_hw(struct wl1271 *wl)
 		 */
 		u8 *nvs_ptr = (u8 *)wl->nvs;
 
-		wl->mac_addr[0] = nvs_ptr[11];
-		wl->mac_addr[1] = nvs_ptr[10];
-		wl->mac_addr[2] = nvs_ptr[6];
-		wl->mac_addr[3] = nvs_ptr[5];
-		wl->mac_addr[4] = nvs_ptr[4];
-		wl->mac_addr[5] = nvs_ptr[3];
+		oui_addr =
+			(nvs_ptr[11] << 16) + (nvs_ptr[10] << 8) + nvs_ptr[6];
+		nic_addr =
+			(nvs_ptr[5] << 16) + (nvs_ptr[4] << 8) + nvs_ptr[3];
+	}
+
+	/* if the MAC address is zeroed in the NVS derive from fuse */
+	if (oui_addr == 0 && nic_addr == 0) {
+		oui_addr = wl->fuse_oui_addr;
+		/* fuse has the BD_ADDR, the WLAN addresses are the next two */
+		nic_addr = wl->fuse_nic_addr + 1;
 	}
 
-	SET_IEEE80211_PERM_ADDR(wl->hw, wl->mac_addr);
+	wl12xx_derive_mac_addresses(wl, oui_addr, nic_addr, 2);
 
 	ret = ieee80211_register_hw(wl->hw);
 	if (ret < 0) {
diff --git a/drivers/net/wireless/wl12xx/reg.h b/drivers/net/wireless/wl12xx/reg.h
index df34d59..340db32 100644
--- a/drivers/net/wireless/wl12xx/reg.h
+++ b/drivers/net/wireless/wl12xx/reg.h
@@ -525,4 +525,31 @@ b12-b0 - Supported Rate indicator bits as defined below.
  */
 #define INTR_TRIG_TX_PROC1 BIT(18)
 
+#define WL127X_REG_FUSE_DATA_2_1	0x050a
+#define WL128X_REG_FUSE_DATA_2_1	0x2152
+#define PG_VER_MASK			0x3c
+#define PG_VER_OFFSET			2
+
+#define WL127X_PG_MAJOR_VER_MASK	0x3
+#define WL127X_PG_MAJOR_VER_OFFSET	0x0
+#define WL127X_PG_MINOR_VER_MASK	0xc
+#define WL127X_PG_MINOR_VER_OFFSET	0x2
+
+#define WL128X_PG_MAJOR_VER_MASK	0xc
+#define WL128X_PG_MAJOR_VER_OFFSET	0x2
+#define WL128X_PG_MINOR_VER_MASK	0x3
+#define WL128X_PG_MINOR_VER_OFFSET	0x0
+
+#define WL127X_PG_GET_MAJOR(pg_ver) ((pg_ver & WL127X_PG_MAJOR_VER_MASK) >> \
+				     WL127X_PG_MAJOR_VER_OFFSET)
+#define WL127X_PG_GET_MINOR(pg_ver) ((pg_ver & WL127X_PG_MINOR_VER_MASK) >> \
+				     WL127X_PG_MINOR_VER_OFFSET)
+#define WL128X_PG_GET_MAJOR(pg_ver) ((pg_ver & WL128X_PG_MAJOR_VER_MASK) >> \
+				     WL128X_PG_MAJOR_VER_OFFSET)
+#define WL128X_PG_GET_MINOR(pg_ver) ((pg_ver & WL128X_PG_MINOR_VER_MASK) >> \
+				     WL128X_PG_MINOR_VER_OFFSET)
+
+#define WL12XX_REG_FUSE_BD_ADDR_1	0x00310eb4
+#define WL12XX_REG_FUSE_BD_ADDR_2	0x00310eb8
+
 #endif
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index b2b09cd..1f629fa 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -313,7 +313,12 @@ struct wl1271 {
 
 	s8 hw_pg_ver;
 
-	u8 mac_addr[ETH_ALEN];
+	/* address read from the fuse ROM */
+	u32 fuse_oui_addr;
+	u32 fuse_nic_addr;
+
+	/* we have up to 2 MAC addresses */
+	struct mac_address addresses[2];
 	int channel;
 	u8 system_hlid;
 
-- 
1.7.4.1

