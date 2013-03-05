Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog119.obsmtp.com ([74.125.149.246]:47110 "EHLO
	na3sys009aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753742Ab3CEA2a (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Mar 2013 19:28:30 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Paul Fox <pgf@laptop.org>, Daniel Drake <dsd@laptop.org>,
	John Rhodes <jrhodes@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 5/7] mwifiex: shorten the host sleep configuration macro names
Date: Mon,  4 Mar 2013 16:27:57 -0800
Message-Id: <1362443279-6064-6-git-send-email-bzhao@marvell.com> (sfid-20130305_012832_927609_EC1CF81B)
In-Reply-To: <1362443279-6064-1-git-send-email-bzhao@marvell.com>
References: <1362443279-6064-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

As we are adding a few more macros in this category in next
patch, this cleanup work is required.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cmdevt.c    |    2 +-
 drivers/net/wireless/mwifiex/fw.h        |    8 ++++----
 drivers/net/wireless/mwifiex/init.c      |    6 +++---
 drivers/net/wireless/mwifiex/sta_cmd.c   |    2 +-
 drivers/net/wireless/mwifiex/sta_ioctl.c |   10 +++++-----
 5 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cmdevt.c b/drivers/net/wireless/mwifiex/cmdevt.c
index 20a6c55..d19a88c 100644
--- a/drivers/net/wireless/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/mwifiex/cmdevt.c
@@ -1139,7 +1139,7 @@ int mwifiex_ret_802_11_hs_cfg(struct mwifiex_private *priv,
 			phs_cfg->params.hs_config.gpio,
 			phs_cfg->params.hs_config.gap);
 	}
-	if (conditions != HOST_SLEEP_CFG_CANCEL) {
+	if (conditions != HS_CFG_CANCEL) {
 		adapter->is_hs_configured = true;
 		if (adapter->iface_type == MWIFIEX_USB ||
 		    adapter->iface_type == MWIFIEX_PCIE)
diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index 25acb06..270685e 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -376,10 +376,10 @@ enum P2P_MODES {
 #define HostCmd_SCAN_RADIO_TYPE_BG          0
 #define HostCmd_SCAN_RADIO_TYPE_A           1
 
-#define HOST_SLEEP_CFG_CANCEL		0xffffffff
-#define HOST_SLEEP_CFG_COND_DEF		0x00000000
-#define HOST_SLEEP_CFG_GPIO_DEF		0xff
-#define HOST_SLEEP_CFG_GAP_DEF		0
+#define HS_CFG_CANCEL			0xffffffff
+#define HS_CFG_COND_DEF			0x00000000
+#define HS_CFG_GPIO_DEF			0xff
+#define HS_CFG_GAP_DEF			0
 
 #define MWIFIEX_TIMEOUT_FOR_AP_RESP		0xfffc
 #define MWIFIEX_STATUS_CODE_AUTH_TIMEOUT	2
diff --git a/drivers/net/wireless/mwifiex/init.c b/drivers/net/wireless/mwifiex/init.c
index e38aa9b..cab3434 100644
--- a/drivers/net/wireless/mwifiex/init.c
+++ b/drivers/net/wireless/mwifiex/init.c
@@ -318,9 +318,9 @@ static void mwifiex_init_adapter(struct mwifiex_adapter *adapter)
 	adapter->curr_tx_buf_size = MWIFIEX_TX_DATA_BUF_SIZE_2K;
 
 	adapter->is_hs_configured = false;
-	adapter->hs_cfg.conditions = cpu_to_le32(HOST_SLEEP_CFG_COND_DEF);
-	adapter->hs_cfg.gpio = HOST_SLEEP_CFG_GPIO_DEF;
-	adapter->hs_cfg.gap = HOST_SLEEP_CFG_GAP_DEF;
+	adapter->hs_cfg.conditions = cpu_to_le32(HS_CFG_COND_DEF);
+	adapter->hs_cfg.gpio = HS_CFG_GPIO_DEF;
+	adapter->hs_cfg.gap = HS_CFG_GAP_DEF;
 	adapter->hs_activated = false;
 
 	memset(adapter->event_body, 0, sizeof(adapter->event_body));
diff --git a/drivers/net/wireless/mwifiex/sta_cmd.c b/drivers/net/wireless/mwifiex/sta_cmd.c
index c55c5bb..3d51721 100644
--- a/drivers/net/wireless/mwifiex/sta_cmd.c
+++ b/drivers/net/wireless/mwifiex/sta_cmd.c
@@ -334,7 +334,7 @@ mwifiex_cmd_802_11_hs_cfg(struct mwifiex_private *priv,
 	cmd->command = cpu_to_le16(HostCmd_CMD_802_11_HS_CFG_ENH);
 
 	if (!hs_activate &&
-	    (hscfg_param->conditions != cpu_to_le32(HOST_SLEEP_CFG_CANCEL)) &&
+	    (hscfg_param->conditions != cpu_to_le32(HS_CFG_CANCEL)) &&
 	    ((adapter->arp_filter_size > 0) &&
 	     (adapter->arp_filter_size <= ARP_FILTER_MAX_BUF_SIZE))) {
 		dev_dbg(adapter->dev,
diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index 9f33c92..76d31de 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -388,7 +388,7 @@ static int mwifiex_set_hs_params(struct mwifiex_private *priv, u16 action,
 			break;
 		}
 		if (hs_cfg->is_invoke_hostcmd) {
-			if (hs_cfg->conditions == HOST_SLEEP_CFG_CANCEL) {
+			if (hs_cfg->conditions == HS_CFG_CANCEL) {
 				if (!adapter->is_hs_configured)
 					/* Already cancelled */
 					break;
@@ -403,8 +403,8 @@ static int mwifiex_set_hs_params(struct mwifiex_private *priv, u16 action,
 				adapter->hs_cfg.gpio = (u8)hs_cfg->gpio;
 				if (hs_cfg->gap)
 					adapter->hs_cfg.gap = (u8)hs_cfg->gap;
-			} else if (adapter->hs_cfg.conditions
-				   == cpu_to_le32(HOST_SLEEP_CFG_CANCEL)) {
+			} else if (adapter->hs_cfg.conditions ==
+				   cpu_to_le32(HS_CFG_CANCEL)) {
 				/* Return failure if no parameters for HS
 				   enable */
 				status = -1;
@@ -420,7 +420,7 @@ static int mwifiex_set_hs_params(struct mwifiex_private *priv, u16 action,
 						HostCmd_CMD_802_11_HS_CFG_ENH,
 						HostCmd_ACT_GEN_SET, 0,
 						&adapter->hs_cfg);
-			if (hs_cfg->conditions == HOST_SLEEP_CFG_CANCEL)
+			if (hs_cfg->conditions == HS_CFG_CANCEL)
 				/* Restore previous condition */
 				adapter->hs_cfg.conditions =
 						cpu_to_le32(prev_cond);
@@ -454,7 +454,7 @@ int mwifiex_cancel_hs(struct mwifiex_private *priv, int cmd_type)
 {
 	struct mwifiex_ds_hs_cfg hscfg;
 
-	hscfg.conditions = HOST_SLEEP_CFG_CANCEL;
+	hscfg.conditions = HS_CFG_CANCEL;
 	hscfg.is_invoke_hostcmd = true;
 
 	return mwifiex_set_hs_params(priv, HostCmd_ACT_GEN_SET,
-- 
1.7.0.2

