Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48486 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752925Ab0G0RxK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jul 2010 13:53:10 -0400
Subject: [wt PATCH 1/16] libertas: clean up MONITOR_MODE command
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1280260357.19686.13.camel@dcbw.foobar.com>
References: <1280260357.19686.13.camel@dcbw.foobar.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 27 Jul 2010 12:54:34 -0700
Message-ID: <1280260474.19686.14.camel@dcbw.foobar.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Convert to a full direct command; previous code rolled a direct
command by handle but left the original indirect command code
lying around.

Signed-off-by: Dan Williams <dcbw@redhat.com>
---
 drivers/net/wireless/libertas/cfg.c  |   57 ++--------------------------------
 drivers/net/wireless/libertas/cmd.c  |   42 +++++++++++++++----------
 drivers/net/wireless/libertas/cmd.h  |    2 +
 drivers/net/wireless/libertas/host.h |    4 ++-
 4 files changed, 33 insertions(+), 72 deletions(-)

diff --git a/drivers/net/wireless/libertas/cfg.c b/drivers/net/wireless/libertas/cfg.c
index 7e07416..5110a77 100644
--- a/drivers/net/wireless/libertas/cfg.c
+++ b/drivers/net/wireless/libertas/cfg.c
@@ -7,7 +7,6 @@
  */
 
 #include <linux/slab.h>
-#include <linux/if_arp.h>
 #include <linux/ieee80211.h>
 #include <net/cfg80211.h>
 #include <asm/unaligned.h>
@@ -1383,56 +1382,6 @@ static int lbs_cfg_del_key(struct wiphy *wiphy, struct net_device *netdev,
 }
 
 
-
-/***************************************************************************
- * Monitor mode
- */
-
-/* like "struct cmd_ds_802_11_monitor_mode", but with cmd_header. Once we
- * get rid of WEXT, this should go into host.h */
-struct cmd_monitor_mode {
-	struct cmd_header hdr;
-
-	__le16 action;
-	__le16 mode;
-} __packed;
-
-static int lbs_enable_monitor_mode(struct lbs_private *priv, int mode)
-{
-	struct cmd_monitor_mode cmd;
-	int ret;
-
-	lbs_deb_enter(LBS_DEB_CFG80211);
-
-	/*
-	 * cmd       98 00
-	 * size      0c 00
-	 * sequence  xx xx
-	 * result    00 00
-	 * action    01 00    ACT_SET
-	 * enable    01 00
-	 */
-	memset(&cmd, 0, sizeof(cmd));
-	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
-	cmd.action = cpu_to_le16(CMD_ACT_SET);
-	cmd.mode = cpu_to_le16(mode);
-
-	ret = lbs_cmd_with_response(priv, CMD_802_11_MONITOR_MODE, &cmd);
-
-	if (ret == 0)
-		priv->dev->type = ARPHRD_IEEE80211_RADIOTAP;
-	else
-		priv->dev->type = ARPHRD_ETHER;
-
-	lbs_deb_leave(LBS_DEB_CFG80211);
-	return ret;
-}
-
-
-
-
-
-
 /***************************************************************************
  * Get station
  */
@@ -1558,17 +1507,17 @@ static int lbs_change_intf(struct wiphy *wiphy, struct net_device *dev,
 
 	switch (type) {
 	case NL80211_IFTYPE_MONITOR:
-		ret = lbs_enable_monitor_mode(priv, 1);
+		ret = lbs_set_monitor_mode(priv, 1);
 		break;
 	case NL80211_IFTYPE_STATION:
 		if (priv->wdev->iftype == NL80211_IFTYPE_MONITOR)
-			ret = lbs_enable_monitor_mode(priv, 0);
+			ret = lbs_set_monitor_mode(priv, 0);
 		if (!ret)
 			ret = lbs_set_snmp_mib(priv, SNMP_MIB_OID_BSS_TYPE, 1);
 		break;
 	case NL80211_IFTYPE_ADHOC:
 		if (priv->wdev->iftype == NL80211_IFTYPE_MONITOR)
-			ret = lbs_enable_monitor_mode(priv, 0);
+			ret = lbs_set_monitor_mode(priv, 0);
 		if (!ret)
 			ret = lbs_set_snmp_mib(priv, SNMP_MIB_OID_BSS_TYPE, 2);
 		break;
diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
index 749fbde..4454988 100644
--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -6,6 +6,7 @@
 #include <linux/kfifo.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
+#include <linux/if_arp.h>
 
 #include "decl.h"
 #include "cfg.h"
@@ -576,23 +577,35 @@ int lbs_set_tx_power(struct lbs_private *priv, s16 dbm)
 	return ret;
 }
 
-static int lbs_cmd_802_11_monitor_mode(struct cmd_ds_command *cmd,
-				      u16 cmd_action, void *pdata_buf)
+/**
+ *  @brief Enable or disable monitor mode (only implemented on OLPC usb8388 FW)
+ *
+ *  @param priv        A pointer to struct lbs_private structure
+ *  @param enable      1 to enable monitor mode, 0 to disable
+ *
+ *  @return            0 on success, error on failure
+ */
+int lbs_set_monitor_mode(struct lbs_private *priv, int enable)
 {
-	struct cmd_ds_802_11_monitor_mode *monitor = &cmd->params.monitor;
+	struct cmd_ds_802_11_monitor_mode cmd;
+	int ret;
 
-	cmd->command = cpu_to_le16(CMD_802_11_MONITOR_MODE);
-	cmd->size =
-	    cpu_to_le16(sizeof(struct cmd_ds_802_11_monitor_mode) +
-			     sizeof(struct cmd_header));
+	memset(&cmd, 0, sizeof(cmd));
+	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
+	cmd.action = cpu_to_le16(CMD_ACT_SET);
+	if (enable)
+		cmd.mode = cpu_to_le16(0x1);
 
-	monitor->action = cpu_to_le16(cmd_action);
-	if (cmd_action == CMD_ACT_SET) {
-		monitor->mode =
-		    cpu_to_le16((u16) (*(u32 *) pdata_buf));
+	lbs_deb_cmd("SET_MONITOR_MODE: %d\n", enable);
+
+	ret = lbs_cmd_with_response(priv, CMD_802_11_MONITOR_MODE, &cmd);
+	if (ret == 0) {
+		priv->dev->type = enable ? ARPHRD_IEEE80211_RADIOTAP :
+						ARPHRD_ETHER;
 	}
 
-	return 0;
+	lbs_deb_leave(LBS_DEB_CMD);
+	return ret;
 }
 
 /**
@@ -1093,11 +1106,6 @@ int lbs_prepare_and_send_command(struct lbs_private *priv,
 		ret = lbs_cmd_reg_access(cmdptr, cmd_action, pdata_buf);
 		break;
 
-	case CMD_802_11_MONITOR_MODE:
-		ret = lbs_cmd_802_11_monitor_mode(cmdptr,
-				          cmd_action, pdata_buf);
-		break;
-
 	case CMD_802_11_RSSI:
 		ret = lbs_cmd_802_11_rssi(priv, cmdptr);
 		break;
diff --git a/drivers/net/wireless/libertas/cmd.h b/drivers/net/wireless/libertas/cmd.h
index 386e565..1b9092f 100644
--- a/drivers/net/wireless/libertas/cmd.h
+++ b/drivers/net/wireless/libertas/cmd.h
@@ -129,4 +129,6 @@ int lbs_set_deep_sleep(struct lbs_private *priv, int deep_sleep);
 
 int lbs_set_host_sleep(struct lbs_private *priv, int host_sleep);
 
+int lbs_set_monitor_mode(struct lbs_private *priv, int enable);
+
 #endif /* _LBS_CMD_H */
diff --git a/drivers/net/wireless/libertas/host.h b/drivers/net/wireless/libertas/host.h
index d70355c..aeecf58 100644
--- a/drivers/net/wireless/libertas/host.h
+++ b/drivers/net/wireless/libertas/host.h
@@ -675,7 +675,10 @@ struct cmd_ds_802_11_rf_tx_power {
 	s8 minlevel;
 } __attribute__ ((packed));
 
+/* MONITOR_MODE only exists in OLPC v5 firmware */
 struct cmd_ds_802_11_monitor_mode {
+	struct cmd_header hdr;
+
 	__le16 action;
 	__le16 mode;
 } __attribute__ ((packed));
@@ -966,7 +969,6 @@ struct cmd_ds_command {
 	/* command Body */
 	union {
 		struct cmd_ds_802_11_ps_mode psmode;
-		struct cmd_ds_802_11_monitor_mode monitor;
 		struct cmd_ds_802_11_rssi rssi;
 		struct cmd_ds_802_11_rssi_rsp rssirsp;
 		struct cmd_ds_mac_reg_access macreg;
-- 
1.7.1.1


