Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:47736 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756689Ab2I0Kim (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Sep 2012 06:38:42 -0400
From: Luciano Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 14/31] wlcore/wl18xx/wl12xx: allow up to 3 mac addresses
Date: Thu, 27 Sep 2012 13:37:52 +0300
Message-Id: <1348742289-6587-15-git-send-email-luca@coelho.fi> (sfid-20120927_123936_244853_7F17176E)
In-Reply-To: <1348742289-6587-1-git-send-email-luca@coelho.fi>
References: <1348742289-6587-1-git-send-email-luca@coelho.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

Allow 3 native mac addresses on 18xx. On 12xx allow 2 native mac
addresses and set the LAA bit to create a third mac address. This
enabled operation with a separate group interface.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Luciano Coelho <luca@coelho.fi>
---
 drivers/net/wireless/ti/wl12xx/main.c   |    1 +
 drivers/net/wireless/ti/wl12xx/wl12xx.h |    2 ++
 drivers/net/wireless/ti/wl18xx/main.c   |    1 +
 drivers/net/wireless/ti/wl18xx/wl18xx.h |    2 ++
 drivers/net/wireless/ti/wlcore/main.c   |   30 ++++++++++++++++++++++--------
 drivers/net/wireless/ti/wlcore/wlcore.h |   11 ++++++++++-
 6 files changed, 38 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ti/wl12xx/main.c b/drivers/net/wireless/ti/wl12xx/main.c
index 0a8bc0c..f49ce7c 100644
--- a/drivers/net/wireless/ti/wl12xx/main.c
+++ b/drivers/net/wireless/ti/wl12xx/main.c
@@ -1643,6 +1643,7 @@ static int __devinit wl12xx_probe(struct platform_device *pdev)
 	wl->rtable = wl12xx_rtable;
 	wl->num_tx_desc = WL12XX_NUM_TX_DESCRIPTORS;
 	wl->num_rx_desc = WL12XX_NUM_RX_DESCRIPTORS;
+	wl->num_mac_addr = WL12XX_NUM_MAC_ADDRESSES;
 	wl->band_rate_to_idx = wl12xx_band_rate_to_idx;
 	wl->hw_tx_rate_tbl_size = WL12XX_CONF_HW_RXTX_RATE_MAX;
 	wl->hw_min_ht_rate = WL12XX_CONF_HW_RXTX_RATE_MCS0;
diff --git a/drivers/net/wireless/ti/wl12xx/wl12xx.h b/drivers/net/wireless/ti/wl12xx/wl12xx.h
index 9953374..7182bbf 100644
--- a/drivers/net/wireless/ti/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/ti/wl12xx/wl12xx.h
@@ -43,6 +43,8 @@
 #define WL12XX_NUM_TX_DESCRIPTORS 16
 #define WL12XX_NUM_RX_DESCRIPTORS 8
 
+#define WL12XX_NUM_MAC_ADDRESSES 2
+
 struct wl127x_rx_mem_pool_addr {
 	u32 addr;
 	u32 addr_extra;
diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index 3f4fbd8..93b148f 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -1394,6 +1394,7 @@ static int __devinit wl18xx_probe(struct platform_device *pdev)
 	wl->rtable = wl18xx_rtable;
 	wl->num_tx_desc = WL18XX_NUM_TX_DESCRIPTORS;
 	wl->num_rx_desc = WL18XX_NUM_TX_DESCRIPTORS;
+	wl->num_mac_addr = WL18XX_NUM_MAC_ADDRESSES;
 	wl->band_rate_to_idx = wl18xx_band_rate_to_idx;
 	wl->hw_tx_rate_tbl_size = WL18XX_CONF_HW_RXTX_RATE_MAX;
 	wl->hw_min_ht_rate = WL18XX_CONF_HW_RXTX_RATE_MCS0;
diff --git a/drivers/net/wireless/ti/wl18xx/wl18xx.h b/drivers/net/wireless/ti/wl18xx/wl18xx.h
index a6e61a2..96a1e43 100644
--- a/drivers/net/wireless/ti/wl18xx/wl18xx.h
+++ b/drivers/net/wireless/ti/wl18xx/wl18xx.h
@@ -38,6 +38,8 @@
 #define WL18XX_NUM_TX_DESCRIPTORS 32
 #define WL18XX_NUM_RX_DESCRIPTORS 32
 
+#define WL18XX_NUM_MAC_ADDRESSES 3
+
 struct wl18xx_priv {
 	/* buffer for sending commands to FW */
 	u8 cmd_buf[WL18XX_CMD_MAX_SIZE];
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index ae2b0fd..dd0cbd9 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -5074,18 +5074,17 @@ out:
 	mutex_unlock(&wl->mutex);
 }
 
-static void wl12xx_derive_mac_addresses(struct wl1271 *wl,
-					u32 oui, u32 nic, int n)
+static void wl12xx_derive_mac_addresses(struct wl1271 *wl, u32 oui, u32 nic)
 {
 	int i;
 
-	wl1271_debug(DEBUG_PROBE, "base address: oui %06x nic %06x, n %d",
-		     oui, nic, n);
+	wl1271_debug(DEBUG_PROBE, "base address: oui %06x nic %06x",
+		     oui, nic);
 
-	if (nic + n - 1 > 0xffffff)
+	if (nic + WLCORE_NUM_MAC_ADDRESSES - wl->num_mac_addr > 0xffffff)
 		wl1271_warning("NIC part of the MAC address wraps around!");
 
-	for (i = 0; i < n; i++) {
+	for (i = 0; i < wl->num_mac_addr; i++) {
 		wl->addresses[i].addr[0] = (u8)(oui >> 16);
 		wl->addresses[i].addr[1] = (u8)(oui >> 8);
 		wl->addresses[i].addr[2] = (u8) oui;
@@ -5095,7 +5094,22 @@ static void wl12xx_derive_mac_addresses(struct wl1271 *wl,
 		nic++;
 	}
 
-	wl->hw->wiphy->n_addresses = n;
+	/* we may be one address short at the most */
+	WARN_ON(wl->num_mac_addr + 1 < WLCORE_NUM_MAC_ADDRESSES);
+
+	/*
+	 * turn on the LAA bit in the first address and use it as
+	 * the last address.
+	 */
+	if (wl->num_mac_addr < WLCORE_NUM_MAC_ADDRESSES) {
+		int idx = WLCORE_NUM_MAC_ADDRESSES - 1;
+		memcpy(&wl->addresses[idx], &wl->addresses[0],
+		       sizeof(wl->addresses[0]));
+		/* LAA bit */
+		wl->addresses[idx].addr[2] |= BIT(1);
+	}
+
+	wl->hw->wiphy->n_addresses = WLCORE_NUM_MAC_ADDRESSES;
 	wl->hw->wiphy->addresses = wl->addresses;
 }
 
@@ -5155,7 +5169,7 @@ static int wl1271_register_hw(struct wl1271 *wl)
 		nic_addr = wl->fuse_nic_addr + 1;
 	}
 
-	wl12xx_derive_mac_addresses(wl, oui_addr, nic_addr, 2);
+	wl12xx_derive_mac_addresses(wl, oui_addr, nic_addr);
 
 	ret = ieee80211_register_hw(wl->hw);
 	if (ret < 0) {
diff --git a/drivers/net/wireless/ti/wlcore/wlcore.h b/drivers/net/wireless/ti/wlcore/wlcore.h
index a7e9d58..165afae 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore.h
@@ -31,6 +31,12 @@
 /* The maximum number of Tx descriptors in all chip families */
 #define WLCORE_MAX_TX_DESCRIPTORS 32
 
+/*
+ * We always allocate this number of mac addresses. If we don't
+ * have enough allocated addresses, the LAA bit is used
+ */
+#define WLCORE_NUM_MAC_ADDRESSES 3
+
 /* forward declaration */
 struct wl1271_tx_hw_descr;
 enum wl_rx_buf_align;
@@ -181,7 +187,7 @@ struct wl1271 {
 	u32 fuse_nic_addr;
 
 	/* we have up to 2 MAC addresses */
-	struct mac_address addresses[2];
+	struct mac_address addresses[WLCORE_NUM_MAC_ADDRESSES];
 	int channel;
 	u8 system_hlid;
 
@@ -394,6 +400,9 @@ struct wl1271 {
 	/* sleep auth value currently configured to FW */
 	int sleep_auth;
 
+	/* the number of allocated MAC addresses in this chip */
+	int num_mac_addr;
+
 	/* the minimum FW version required for the driver to work */
 	unsigned int min_fw_ver[NUM_FW_VER];
 };
-- 
1.7.10.4

