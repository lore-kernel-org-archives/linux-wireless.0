Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:22357 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751511AbcBHKTU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Feb 2016 05:19:20 -0500
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Nishant Sarmukadam <nishants@marvell.com>, <wnhuang@chromium.com>,
	<devicetree@vger.kernel.org>, Xinming Hu <huxm@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH v3 2/3] mwifiex: parse chip specific gpio from device tree
Date: Mon, 8 Feb 2016 02:15:27 -0800
Message-ID: <1454926528-17480-2-git-send-email-akarwar@marvell.com> (sfid-20160208_111925_187349_EEC68984)
In-Reply-To: <1454926528-17480-1-git-send-email-akarwar@marvell.com>
References: <1454926528-17480-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Xinming Hu <huxm@marvell.com>

This patch parse chip specific gpio parameter from device
tree. Corresponding binding file is also updated.

Signed-off-by: Xinming Hu <huxm@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 Documentation/devicetree/bindings/mwifiex.txt  | 6 ++++--
 drivers/net/wireless/marvell/mwifiex/sta_cmd.c | 9 +++++++++
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/mwifiex.txt b/Documentation/devicetree/bindings/mwifiex.txt
index 39b6a74..367c97e 100644
--- a/Documentation/devicetree/bindings/mwifiex.txt
+++ b/Documentation/devicetree/bindings/mwifiex.txt
@@ -11,7 +11,9 @@ Optional properties:
   - mwifiex,caldata* : A series of properties with marvell,caldata prefix,
   		      represent Calibration data downloaded to the device during
 		      initialization. This is an array of unsigned values.
-
+  - mwifiex,chip-gpio : Chip's wakeup gpio pin number. This needs to be downloaded
+			to to firmware. Chip notifies wifi wakeup signal to SOC
+			through this pin.
 
 Example:
 
@@ -24,6 +26,6 @@ mwifiex {
 
 	mwifiex,caldata_00_txpwrlimit_2g_cfg_set = /bits/ 8 <
 0x01 0x00 0x06 0x00 0x08 0x02 0x89 0x01 ...>;
-
+	mwifiex,chip-gpio = <3>;
 };
 
diff --git a/drivers/net/wireless/marvell/mwifiex/sta_cmd.c b/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
index a8b6939..8c011eb 100644
--- a/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
@@ -2134,6 +2134,7 @@ int mwifiex_sta_init_cmd(struct mwifiex_private *priv, u8 first_sta, bool init)
 	enum state_11d_t state_11d;
 	struct mwifiex_ds_11n_tx_cfg tx_cfg;
 	u8 sdio_sp_rx_aggr_enable;
+	u32 data;
 
 	if (first_sta) {
 		if (priv->adapter->iface_type == MWIFIEX_PCIE) {
@@ -2157,6 +2158,14 @@ int mwifiex_sta_init_cmd(struct mwifiex_private *priv, u8 first_sta, bool init)
 		adapter->dt_node = mwifiex_plt_dev ?
 				mwifiex_plt_dev->dev.of_node : NULL;
 		if (adapter->dt_node) {
+			if (of_property_read_u32(adapter->dt_node,
+						 "mwifiex,chip-gpio",
+						 &data) == 0) {
+				mwifiex_dbg(adapter, INFO,
+					    "chip_gpio = 0x%x\n", data);
+				adapter->hs_cfg.gpio = data;
+			}
+
 			ret = mwifiex_dnld_dt_cfgdata(priv, adapter->dt_node,
 						      "mwifiex,caldata");
 			if (ret)
-- 
1.8.1.4

