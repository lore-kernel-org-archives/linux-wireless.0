Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:36190 "HELO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752948Ab2ECHXS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 May 2012 03:23:18 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Stone Piao <piaoyun@marvell.com>,
	Frank Huang <frankh@marvell.com>,
	Bing Zhao <bzhao@marvell.com>,
	harvey yang <harvey.huawei.yang@gmail.com>
Subject: [PATCH 02/18] mwifiex: handle station specific commands on STA interface only
Date: Thu,  3 May 2012 00:22:24 -0700
Message-Id: <1336029760-22565-3-git-send-email-bzhao@marvell.com> (sfid-20120503_092321_474178_6E17784C)
In-Reply-To: <1336029760-22565-1-git-send-email-bzhao@marvell.com>
References: <1336029760-22565-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash Patil <patila@marvell.com>

Commands like IBSS coalescing status, power save, 11D should be
handled only when bss_type is STA.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
Signed-off-by: Kiran Divekar <dkiran@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cmdevt.c  |    5 +++
 drivers/net/wireless/mwifiex/sta_cmd.c |   44 +++++++++++++++++++-------------
 2 files changed, 31 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cmdevt.c b/drivers/net/wireless/mwifiex/cmdevt.c
index 1710bef..d9f30c5 100644
--- a/drivers/net/wireless/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/mwifiex/cmdevt.c
@@ -440,6 +440,11 @@ int mwifiex_process_event(struct mwifiex_adapter *adapter)
 		do_gettimeofday(&tstamp);
 		dev_dbg(adapter->dev, "event: %lu.%lu: cause: %#x\n",
 			tstamp.tv_sec, tstamp.tv_usec, eventcause);
+	} else {
+		/* Handle PS_SLEEP/AWAKE events on STA */
+		priv = mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_STA);
+		if (!priv)
+			priv = mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_ANY);
 	}
 
 	ret = mwifiex_process_sta_event(priv);
diff --git a/drivers/net/wireless/mwifiex/sta_cmd.c b/drivers/net/wireless/mwifiex/sta_cmd.c
index 87ed2a1..9a3976c 100644
--- a/drivers/net/wireless/mwifiex/sta_cmd.c
+++ b/drivers/net/wireless/mwifiex/sta_cmd.c
@@ -1248,13 +1248,15 @@ int mwifiex_sta_init_cmd(struct mwifiex_private *priv, u8 first_sta)
 		if (ret)
 			return -1;
 
-		/* Enable IEEE PS by default */
-		priv->adapter->ps_mode = MWIFIEX_802_11_POWER_MODE_PSP;
-		ret = mwifiex_send_cmd_async(priv,
+		if (priv->bss_type != MWIFIEX_BSS_TYPE_UAP) {
+			/* Enable IEEE PS by default */
+			priv->adapter->ps_mode = MWIFIEX_802_11_POWER_MODE_PSP;
+			ret = mwifiex_send_cmd_async(priv,
 					     HostCmd_CMD_802_11_PS_MODE_ENH,
 					     EN_AUTO_PS, BITMAP_STA_PS, NULL);
-		if (ret)
-			return -1;
+			if (ret)
+				return -1;
+		}
 	}
 
 	/* get tx rate */
@@ -1270,12 +1272,14 @@ int mwifiex_sta_init_cmd(struct mwifiex_private *priv, u8 first_sta)
 	if (ret)
 		return -1;
 
-	/* set ibss coalescing_status */
-	ret = mwifiex_send_cmd_async(priv,
-				     HostCmd_CMD_802_11_IBSS_COALESCING_STATUS,
-				     HostCmd_ACT_GEN_SET, 0, &enable);
-	if (ret)
-		return -1;
+	if (priv->bss_type == MWIFIEX_BSS_TYPE_STA) {
+		/* set ibss coalescing_status */
+		ret = mwifiex_send_cmd_async(priv,
+				HostCmd_CMD_802_11_IBSS_COALESCING_STATUS,
+				HostCmd_ACT_GEN_SET, 0, &enable);
+		if (ret)
+			return -1;
+	}
 
 	memset(&amsdu_aggr_ctrl, 0, sizeof(amsdu_aggr_ctrl));
 	amsdu_aggr_ctrl.enable = true;
@@ -1293,7 +1297,8 @@ int mwifiex_sta_init_cmd(struct mwifiex_private *priv, u8 first_sta)
 	if (ret)
 		return -1;
 
-	if (first_sta && (priv->adapter->iface_type != MWIFIEX_USB)) {
+	if (first_sta && priv->adapter->iface_type != MWIFIEX_USB &&
+	    priv->bss_type != MWIFIEX_BSS_TYPE_UAP) {
 		/* Enable auto deep sleep */
 		auto_ds.auto_ds = DEEP_SLEEP_ON;
 		auto_ds.idle_time = DEEP_SLEEP_IDLE_TIME;
@@ -1305,12 +1310,15 @@ int mwifiex_sta_init_cmd(struct mwifiex_private *priv, u8 first_sta)
 			return -1;
 	}
 
-	/* Send cmd to FW to enable/disable 11D function */
-	state_11d = ENABLE_11D;
-	ret = mwifiex_send_cmd_async(priv, HostCmd_CMD_802_11_SNMP_MIB,
-				     HostCmd_ACT_GEN_SET, DOT11D_I, &state_11d);
-	if (ret)
-		dev_err(priv->adapter->dev, "11D: failed to enable 11D\n");
+	if (priv->bss_type != MWIFIEX_BSS_TYPE_UAP) {
+		/* Send cmd to FW to enable/disable 11D function */
+		state_11d = ENABLE_11D;
+		ret = mwifiex_send_cmd_async(priv, HostCmd_CMD_802_11_SNMP_MIB,
+			     HostCmd_ACT_GEN_SET, DOT11D_I, &state_11d);
+		if (ret)
+			dev_err(priv->adapter->dev,
+				"11D: failed to enable 11D\n");
+	}
 
 	/* Send cmd to FW to configure 11n specific configuration
 	 * (Short GI, Channel BW, Green field support etc.) for transmit
-- 
1.7.0.2

