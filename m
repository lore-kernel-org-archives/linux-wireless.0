Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:51146 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964995AbbA1Enc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jan 2015 23:43:32 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.14.5/8.14.5) with SMTP id t0S4hW1c031555
	for <linux-wireless@vger.kernel.org>; Tue, 27 Jan 2015 20:43:32 -0800
Received: from sc-owa04.marvell.com ([199.233.58.150])
	by mx0a-0016f401.pphosted.com with ESMTP id 1s49ry0grd-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 27 Jan 2015 20:43:32 -0800
From: Avinash Patil <patila@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: <akarwar@marvell.com>, <cluo@marvell.com>,
	Avinash Patil <patila@marvell.com>
Subject: [PATCH v2 5/8] mwifiex: add init parameter to init command routine
Date: Wed, 28 Jan 2015 15:42:02 +0530
Message-ID: <1422439925-25666-6-git-send-email-patila@marvell.com> (sfid-20150128_054337_073646_1A66EC52)
In-Reply-To: <1422439925-25666-1-git-send-email-patila@marvell.com>
References: <1422439925-25666-1-git-send-email-patila@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

FW initialization routine can also be called while changing
virtual interface types.
This patch adds bool parameter "init" to init command routine
so as to differentiate between initialization during driver load
and change virtual interface handler.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
---
 drivers/net/wireless/mwifiex/init.c      |  3 ++-
 drivers/net/wireless/mwifiex/main.h      |  2 +-
 drivers/net/wireless/mwifiex/sta_cmd.c   | 13 ++++++++-----
 drivers/net/wireless/mwifiex/sta_ioctl.c |  2 +-
 4 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/init.c b/drivers/net/wireless/mwifiex/init.c
index 44babc3..2975b51 100644
--- a/drivers/net/wireless/mwifiex/init.c
+++ b/drivers/net/wireless/mwifiex/init.c
@@ -552,7 +552,8 @@ int mwifiex_init_fw(struct mwifiex_adapter *adapter)
 
 	for (i = 0; i < adapter->priv_num; i++) {
 		if (adapter->priv[i]) {
-			ret = mwifiex_sta_init_cmd(adapter->priv[i], first_sta);
+			ret = mwifiex_sta_init_cmd(adapter->priv[i], first_sta,
+						   true);
 			if (ret == -1)
 				return -1;
 
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 45b40af..9686bd8 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -989,7 +989,7 @@ void mwifiex_wmm_del_peer_ra_list(struct mwifiex_private *priv,
 				  const u8 *ra_addr);
 void *mwifiex_process_sta_txpd(struct mwifiex_private *, struct sk_buff *skb);
 void *mwifiex_process_uap_txpd(struct mwifiex_private *, struct sk_buff *skb);
-int mwifiex_sta_init_cmd(struct mwifiex_private *, u8 first_sta);
+int mwifiex_sta_init_cmd(struct mwifiex_private *, u8 first_sta, bool init);
 int mwifiex_cmd_802_11_scan(struct host_cmd_ds_command *cmd,
 			    struct mwifiex_scan_cmd_config *scan_cfg);
 void mwifiex_queue_scan_cmd(struct mwifiex_private *priv,
diff --git a/drivers/net/wireless/mwifiex/sta_cmd.c b/drivers/net/wireless/mwifiex/sta_cmd.c
index f7b920d..92a66e8 100644
--- a/drivers/net/wireless/mwifiex/sta_cmd.c
+++ b/drivers/net/wireless/mwifiex/sta_cmd.c
@@ -1911,6 +1911,8 @@ int mwifiex_sta_prepare_cmd(struct mwifiex_private *priv, uint16_t cmd_no,
  *
  * This is called after firmware download to bring the card to
  * working state.
+ * Function is also called during reinitialization of virtual
+ * interfaces.
  *
  * The following commands are issued sequentially -
  *      - Set PCI-Express host buffer configuration (PCIE only)
@@ -1925,7 +1927,7 @@ int mwifiex_sta_prepare_cmd(struct mwifiex_private *priv, uint16_t cmd_no,
  *      - Set 11d control
  *      - Set MAC control (this must be the last command to initialize firmware)
  */
-int mwifiex_sta_init_cmd(struct mwifiex_private *priv, u8 first_sta)
+int mwifiex_sta_init_cmd(struct mwifiex_private *priv, u8 first_sta, bool init)
 {
 	struct mwifiex_adapter *adapter = priv->adapter;
 	int ret;
@@ -2059,9 +2061,6 @@ int mwifiex_sta_init_cmd(struct mwifiex_private *priv, u8 first_sta)
 				"11D: failed to enable 11D\n");
 	}
 
-	/* set last_init_cmd before sending the command */
-	priv->adapter->last_init_cmd = HostCmd_CMD_11N_CFG;
-
 	/* Send cmd to FW to configure 11n specific configuration
 	 * (Short GI, Channel BW, Green field support etc.) for transmit
 	 */
@@ -2069,7 +2068,11 @@ int mwifiex_sta_init_cmd(struct mwifiex_private *priv, u8 first_sta)
 	ret = mwifiex_send_cmd(priv, HostCmd_CMD_11N_CFG,
 			       HostCmd_ACT_GEN_SET, 0, &tx_cfg, true);
 
-	ret = -EINPROGRESS;
+	if (init) {
+		/* set last_init_cmd before sending the command */
+		priv->adapter->last_init_cmd = HostCmd_CMD_11N_CFG;
+		ret = -EINPROGRESS;
+	}
 
 	return ret;
 }
diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index 329cd51..2faa517 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -1162,7 +1162,7 @@ mwifiex_set_bss_role(struct mwifiex_private *priv, u8 bss_role)
 	mwifiex_send_cmd(priv, HostCmd_CMD_SET_BSS_MODE,
 			 HostCmd_ACT_GEN_SET, 0, NULL, true);
 
-	return mwifiex_sta_init_cmd(priv, false);
+	return mwifiex_sta_init_cmd(priv, false, false);
 }
 
 /*
-- 
1.8.1.4

