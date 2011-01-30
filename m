Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.platinumzone24.at ([88.198.159.93]:49100 "EHLO
	mail.platinumzone24.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752764Ab1A3STf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Jan 2011 13:19:35 -0500
Message-ID: <4D45A5F4.5080800@davizone.at>
Date: Sun, 30 Jan 2011 18:55:00 +0100
From: David Gnedt <david.gnedt@davizone.at>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org, Kalle Valo <kvalo@adurom.com>,
	Grazvydas Ignotas <notasas@gmail.com>,
	Denis 'GNUtoo' Carikli <GNUtoo@no-log.org>
Subject: [PATCH 14/18] wl1251: implement multicast address filtering
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Port multicast address filtering from wl1271 driver.
It sets up the hardware multicast address filter in configure_filter() with
addresses supplied through prepare_multicast().

Signed-off-by: David Gnedt <david.gnedt@davizone.at>
---
 drivers/net/wireless/wl1251/acx.c    |    9 +++--
 drivers/net/wireless/wl1251/acx.h    |    9 +++--
 drivers/net/wireless/wl1251/init.c   |    2 +-
 drivers/net/wireless/wl1251/main.c   |   67 ++++++++++++++++++++++++++++++----
 drivers/net/wireless/wl1251/wl1251.h |    3 +-
 5 files changed, 73 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/wl1251/acx.c b/drivers/net/wireless/wl1251/acx.c
index b002cfa..38d33f0 100644
--- a/drivers/net/wireless/wl1251/acx.c
+++ b/drivers/net/wireless/wl1251/acx.c
@@ -410,7 +410,8 @@ out:
 	return ret;
 }
 -int wl1251_acx_group_address_tbl(struct wl1251 *wl)
+int wl1251_acx_group_address_tbl(struct wl1251 *wl, bool enable,
+				 void *mc_list, u32 mc_list_len)
 {
 	struct acx_dot11_grp_addr_tbl *acx;
 	int ret;
@@ -424,9 +425,9 @@ int wl1251_acx_group_address_tbl(struct wl1251 *wl)
 	}
  	/* MAC filtering */
-	acx->enabled = 0;
-	acx->num_groups = 0;
-	memset(acx->mac_table, 0, ADDRESS_GROUP_MAX_LEN);
+	acx->enabled = enable;
+	acx->num_groups = mc_list_len;
+	memcpy(acx->mac_table, mc_list, mc_list_len * ETH_ALEN);
  	ret = wl1251_cmd_configure(wl, DOT11_GROUP_ADDRESS_TBL,
 				   acx, sizeof(*acx));
diff --git a/drivers/net/wireless/wl1251/acx.h b/drivers/net/wireless/wl1251/acx.h
index d9bc497..09e95bf 100644
--- a/drivers/net/wireless/wl1251/acx.h
+++ b/drivers/net/wireless/wl1251/acx.h
@@ -350,8 +350,8 @@ struct acx_slot {
 } __packed;
  -#define ADDRESS_GROUP_MAX	(8)
-#define ADDRESS_GROUP_MAX_LEN	(ETH_ALEN * ADDRESS_GROUP_MAX)
+#define ACX_MC_ADDRESS_GROUP_MAX	(8)
+#define ACX_MC_ADDRESS_GROUP_MAX_LEN	(ETH_ALEN * ACX_MC_ADDRESS_GROUP_MAX)
  struct acx_dot11_grp_addr_tbl {
 	struct acx_header header;
@@ -359,7 +359,7 @@ struct acx_dot11_grp_addr_tbl {
 	u8 enabled;
 	u8 num_groups;
 	u8 pad[2];
-	u8 mac_table[ADDRESS_GROUP_MAX_LEN];
+	u8 mac_table[ACX_MC_ADDRESS_GROUP_MAX_LEN];
 } __packed;
  @@ -1464,7 +1464,8 @@ int wl1251_acx_rx_msdu_life_time(struct wl1251 *wl, u32
life_time);
 int wl1251_acx_rx_config(struct wl1251 *wl, u32 config, u32 filter);
 int wl1251_acx_pd_threshold(struct wl1251 *wl);
 int wl1251_acx_slot(struct wl1251 *wl, enum acx_slot_type slot_time);
-int wl1251_acx_group_address_tbl(struct wl1251 *wl);
+int wl1251_acx_group_address_tbl(struct wl1251 *wl, bool enable,
+				 void *mc_list, u32 mc_list_len);
 int wl1251_acx_service_period_timeout(struct wl1251 *wl);
 int wl1251_acx_rts_threshold(struct wl1251 *wl, u16 rts_threshold);
 int wl1251_acx_beacon_filter_opt(struct wl1251 *wl, bool enable_filter);
diff --git a/drivers/net/wireless/wl1251/init.c b/drivers/net/wireless/wl1251/init.c
index 92de289..f8a2ea9 100644
--- a/drivers/net/wireless/wl1251/init.c
+++ b/drivers/net/wireless/wl1251/init.c
@@ -127,7 +127,7 @@ int wl1251_hw_init_phy_config(struct wl1251 *wl)
 	if (ret < 0)
 		return ret;
 -	ret = wl1251_acx_group_address_tbl(wl);
+	ret = wl1251_acx_group_address_tbl(wl, true, NULL, 0);
 	if (ret < 0)
 		return ret;
 diff --git a/drivers/net/wireless/wl1251/main.c
b/drivers/net/wireless/wl1251/main.c
index cc49e2b..d6ae6d5 100644
--- a/drivers/net/wireless/wl1251/main.c
+++ b/drivers/net/wireless/wl1251/main.c
@@ -29,6 +29,7 @@
 #include <linux/vmalloc.h>
 #include <linux/platform_device.h>
 #include <linux/slab.h>
+#include <linux/netdevice.h>
  #include "wl1251.h"
 #include "wl12xx_80211.h"
@@ -661,6 +662,44 @@ out:
 	return ret;
 }
 +struct wl1251_filter_params {
+	bool enabled;
+	int mc_list_length;
+	u8 mc_list[ACX_MC_ADDRESS_GROUP_MAX][ETH_ALEN];
+};
+
+static u64 wl1251_op_prepare_multicast(struct ieee80211_hw *hw,
+				       struct netdev_hw_addr_list *mc_list)
+{
+	struct wl1251_filter_params *fp;
+	struct netdev_hw_addr *ha;
+	struct wl1251 *wl = hw->priv;
+
+	if (unlikely(wl->state == WL1251_STATE_OFF))
+		return 0;
+
+	fp = kzalloc(sizeof(*fp), GFP_ATOMIC);
+	if (!fp) {
+		wl1251_error("Out of memory setting filters.");
+		return 0;
+	}
+
+	/* update multicast filtering parameters */
+	fp->mc_list_length = 0;
+	if (netdev_hw_addr_list_count(mc_list) > ACX_MC_ADDRESS_GROUP_MAX) {
+		fp->enabled = false;
+	} else {
+		fp->enabled = true;
+		netdev_hw_addr_list_for_each(ha, mc_list) {
+			memcpy(fp->mc_list[fp->mc_list_length],
+					ha->addr, ETH_ALEN);
+			fp->mc_list_length++;
+		}
+	}
+
+	return (u64)(unsigned long)fp;
+}
+
 #define WL1251_SUPPORTED_FILTERS (FIF_PROMISC_IN_BSS | \
 				  FIF_ALLMULTI | \
 				  FIF_FCSFAIL | \
@@ -670,8 +709,9 @@ out:
  static void wl1251_op_configure_filter(struct ieee80211_hw *hw,
 				       unsigned int changed,
-				       unsigned int *total,u64 multicast)
+				       unsigned int *total, u64 multicast)
 {
+	struct wl1251_filter_params *fp = (void *)(unsigned long)multicast;
 	struct wl1251 *wl = hw->priv;
 	int ret;
 @@ -680,26 +720,37 @@ static void wl1251_op_configure_filter(struct
ieee80211_hw *hw,
 	*total &= WL1251_SUPPORTED_FILTERS;
 	changed &= WL1251_SUPPORTED_FILTERS;
 -	if (changed == 0)
-		/* no filters which we support changed */
-		return;
-
 	mutex_lock(&wl->mutex);
 -	if (wl->state == WL1251_STATE_OFF)
+	if (unlikely(wl->state == WL1251_STATE_OFF))
 		goto out;
  	ret = wl1251_ps_elp_wakeup(wl);
 	if (ret < 0)
 		goto out;
 +	if (*total & FIF_ALLMULTI || *total & FIF_PROMISC_IN_BSS)
+		ret = wl1251_acx_group_address_tbl(wl, false, NULL, 0);
+	else if (fp)
+		ret = wl1251_acx_group_address_tbl(wl, fp->enabled,
+						   fp->mc_list,
+						   fp->mc_list_length);
+	if (ret < 0)
+		goto out_sleep;
+
+	if (changed == 0)
+		/* no filters which we support changed */
+		goto out_sleep;
+
 	wl->rx_config = WL1251_DEFAULT_RX_CONFIG;
 	wl->rx_filter = WL1251_DEFAULT_RX_FILTER;
  	if (!is_zero_ether_addr(wl->bssid))
 		wl->rx_config |= CFG_BSSID_FILTER_EN;
-	if (*total & FIF_PROMISC_IN_BSS)
+	if (*total & FIF_PROMISC_IN_BSS) {
 		wl->rx_config &= ~CFG_UNI_FILTER_EN;
+		wl->rx_config &= ~CFG_MC_FILTER_EN;
+	}
 	if (*total & FIF_ALLMULTI)
 		/*
 		 * CFG_MC_FILTER_EN in rx_config needs to be 0 to receive
@@ -735,6 +786,7 @@ out_sleep:
  out:
 	mutex_unlock(&wl->mutex);
+	kfree(fp);
 }
  /* HW encryption */
@@ -1260,6 +1312,7 @@ static const struct ieee80211_ops wl1251_ops = {
 	.add_interface = wl1251_op_add_interface,
 	.remove_interface = wl1251_op_remove_interface,
 	.config = wl1251_op_config,
+	.prepare_multicast = wl1251_op_prepare_multicast,
 	.configure_filter = wl1251_op_configure_filter,
 	.tx = wl1251_op_tx,
 	.set_key = wl1251_op_set_key,
diff --git a/drivers/net/wireless/wl1251/wl1251.h
b/drivers/net/wireless/wl1251/wl1251.h
index 1f9579c..184ceff 100644
--- a/drivers/net/wireless/wl1251/wl1251.h
+++ b/drivers/net/wireless/wl1251/wl1251.h
@@ -92,7 +92,8 @@ enum {
 				       true);				\
 	} while (0)
 -#define WL1251_DEFAULT_RX_CONFIG (CFG_UNI_FILTER_EN)
+#define WL1251_DEFAULT_RX_CONFIG (CFG_UNI_FILTER_EN | \
+				  CFG_MC_FILTER_EN)
  #define WL1251_DEFAULT_RX_FILTER (CFG_RX_PRSP_EN |  \
 				  CFG_RX_MGMT_EN |  \
-- 
1.7.0.4


