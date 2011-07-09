Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:55850 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236Ab1GIDfC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jul 2011 23:35:02 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH] mwifiex: 11n specific configuration for transmit
Date: Fri,  8 Jul 2011 20:40:30 -0700
Message-Id: <1310182830-21470-1-git-send-email-bzhao@marvell.com> (sfid-20110709_053745_713220_7CBA848E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

Currently device is not able to transmit in 40MHz in spite of
enabling 40MHz support in HTCapInfo IE in assoc req, because
11n specific FW capabilities for transmission are not initialized.
This patch adds code to initilize these capabilities.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
Signed-off-by: Kiran Divekar <dkiran@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/fw.h      |   11 +++++++++++
 drivers/net/wireless/mwifiex/sta_cmd.c |   10 +++++++++-
 2 files changed, 20 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index afdd145..4fee099 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -157,6 +157,17 @@ enum MWIFIEX_802_11_WEP_STATUS {
 #define ISSUPP_RXSTBC(Dot11nDevCap) (Dot11nDevCap & BIT(26))
 #define ISSUPP_GREENFIELD(Dot11nDevCap) (Dot11nDevCap & BIT(29))
 
+/* httxcfg bitmap
+ * 0		reserved
+ * 1		20/40 Mhz enable(1)/disable(0)
+ * 2-3		reserved
+ * 4		green field enable(1)/disable(0)
+ * 5		short GI in 20 Mhz enable(1)/disable(0)
+ * 6		short GI in 40 Mhz enable(1)/disable(0)
+ * 7-15		reserved
+ */
+#define MWIFIEX_FW_DEF_HTTXCFG (BIT(1) | BIT(4) | BIT(5) | BIT(6))
+
 #define GET_RXMCSSUPP(DevMCSSupported) (DevMCSSupported & 0x0f)
 #define SETHT_MCS32(x) (x[4] |= 1)
 
diff --git a/drivers/net/wireless/mwifiex/sta_cmd.c b/drivers/net/wireless/mwifiex/sta_cmd.c
index 49b9c13..c54ee28 100644
--- a/drivers/net/wireless/mwifiex/sta_cmd.c
+++ b/drivers/net/wireless/mwifiex/sta_cmd.c
@@ -1113,6 +1113,7 @@ int mwifiex_sta_init_cmd(struct mwifiex_private *priv, u8 first_sta)
 	struct mwifiex_ds_11n_amsdu_aggr_ctrl amsdu_aggr_ctrl;
 	struct mwifiex_ds_auto_ds auto_ds;
 	enum state_11d_t state_11d;
+	struct mwifiex_ds_11n_tx_cfg tx_cfg;
 
 	if (first_sta) {
 
@@ -1198,8 +1199,15 @@ int mwifiex_sta_init_cmd(struct mwifiex_private *priv, u8 first_sta)
 	if (ret)
 		dev_err(priv->adapter->dev, "11D: failed to enable 11D\n");
 
+	/* Send cmd to FW to configure 11n specific configuration
+	 * (Short GI, Channel BW, Green field support etc.) for transmit
+	 */
+	tx_cfg.tx_htcap = MWIFIEX_FW_DEF_HTTXCFG;
+	ret = mwifiex_send_cmd_async(priv, HostCmd_CMD_11N_CFG,
+				     HostCmd_ACT_GEN_SET, 0, &tx_cfg);
+
 	/* set last_init_cmd */
-	priv->adapter->last_init_cmd = HostCmd_CMD_802_11_SNMP_MIB;
+	priv->adapter->last_init_cmd = HostCmd_CMD_11N_CFG;
 	ret = -EINPROGRESS;
 
 	return ret;
-- 
1.7.0.2

