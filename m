Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.172]:53929 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045AbYJUTJo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Oct 2008 15:09:44 -0400
Received: by wf-out-1314.google.com with SMTP id 27so2636745wfd.4
        for <linux-wireless@vger.kernel.org>; Tue, 21 Oct 2008 12:09:43 -0700 (PDT)
To: linux-wireless@vger.kernel.org
Cc: libertas-dev@lists.infradead.org
From: Anna Neal <anna@cozybit.com>
Date: Mon, 20 Oct 2008 16:46:56 -0700
Subject: [PATCH] libertas: Fine grained configuration of wake-on-lan.
Message-ID: <48fe28f5.1f588c0a.6115.ffffe7a8@mx.google.com> (sfid-20081021_210951_650915_B168DD62)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Based on a patch from Shailendra Govardhan <shailen@marvell.com>.
This patch allows implementation of more specific wake-on-lan rules than those
of ethtool.

Please note that only firmware 5.110.22.p20 and above supports this feature.

This patch only implements the driver/firmware interface, not the
userspace/driver interface.

Signed-off-by: Anna Neal <anna@cozybit.com>
Signed-off-by: Javier Cardona <javier@cozybit.com>
---
 drivers/net/wireless/libertas/cmd.c     |   19 ++++++++++++++++---
 drivers/net/wireless/libertas/cmd.h     |    3 ++-
 drivers/net/wireless/libertas/defs.h    |   12 ++++++++++++
 drivers/net/wireless/libertas/ethtool.c |    2 +-
 drivers/net/wireless/libertas/host.h    |    8 ++++++++
 drivers/net/wireless/libertas/hostcmd.h |   26 +++++++++++++++++++++++++-
 drivers/net/wireless/libertas/if_usb.c  |    3 ++-
 7 files changed, 66 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
index aee19fa..6ffdf00 100644
--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -160,7 +160,8 @@ out:
 	return ret;
 }
 
-int lbs_host_sleep_cfg(struct lbs_private *priv, uint32_t criteria)
+int lbs_host_sleep_cfg(struct lbs_private *priv, uint32_t criteria,
+		struct wol_config *p_wol_config)
 {
 	struct cmd_ds_host_sleep cmd_config;
 	int ret;
@@ -170,10 +171,21 @@ int lbs_host_sleep_cfg(struct lbs_private *priv, uint32_t criteria)
 	cmd_config.gpio = priv->wol_gpio;
 	cmd_config.gap = priv->wol_gap;
 
+	if (p_wol_config != NULL)
+		memcpy((uint8_t *)&cmd_config.wol_conf, (uint8_t *)p_wol_config,
+				sizeof(struct wol_config));
+	else
+		cmd_config.wol_conf.action = CMD_ACT_ACTION_NONE;
+
 	ret = lbs_cmd_with_response(priv, CMD_802_11_HOST_SLEEP_CFG, &cmd_config);
 	if (!ret) {
-		lbs_deb_cmd("Set WOL criteria to %x\n", criteria);
-		priv->wol_criteria = criteria;
+		if (criteria) {
+			lbs_deb_cmd("Set WOL criteria to %x\n", criteria);
+			priv->wol_criteria = criteria;
+		} else
+			memcpy((uint8_t *) p_wol_config,
+					(uint8_t *)&cmd_config.wol_conf,
+					sizeof(struct wol_config));
 	} else {
 		lbs_pr_info("HOST_SLEEP_CFG failed %d\n", ret);
 	}
diff --git a/drivers/net/wireless/libertas/cmd.h b/drivers/net/wireless/libertas/cmd.h
index 36be4c9..392e578 100644
--- a/drivers/net/wireless/libertas/cmd.h
+++ b/drivers/net/wireless/libertas/cmd.h
@@ -56,7 +56,8 @@ int lbs_mesh_config_send(struct lbs_private *priv,
 			 uint16_t action, uint16_t type);
 int lbs_mesh_config(struct lbs_private *priv, uint16_t enable, uint16_t chan);
 
-int lbs_host_sleep_cfg(struct lbs_private *priv, uint32_t criteria);
+int lbs_host_sleep_cfg(struct lbs_private *priv, uint32_t criteria,
+		struct wol_config *p_wol_config);
 int lbs_suspend(struct lbs_private *priv);
 void lbs_resume(struct lbs_private *priv);
 
diff --git a/drivers/net/wireless/libertas/defs.h b/drivers/net/wireless/libertas/defs.h
index d21bb4e..e4771f6 100644
--- a/drivers/net/wireless/libertas/defs.h
+++ b/drivers/net/wireless/libertas/defs.h
@@ -149,6 +149,18 @@ static inline void lbs_deb_hex(unsigned int grp, const char *prompt, u8 *buf, in
 #define EHS_WAKE_ON_MAC_EVENT		0x0004
 #define EHS_WAKE_ON_MULTICAST_DATA	0x0008
 #define EHS_REMOVE_WAKEUP		0xFFFFFFFF
+/* Wake rules for Host_Sleep_CFG command */
+#define WOL_RULE_NET_TYPE_INFRA_OR_IBSS	0x00
+#define WOL_RULE_NET_TYPE_MESH		0x10
+#define WOL_RULE_ADDR_TYPE_BCAST	0x01
+#define WOL_RULE_ADDR_TYPE_MCAST	0x08
+#define WOL_RULE_ADDR_TYPE_UCAST	0x02
+#define WOL_RULE_OP_AND			0x01
+#define WOL_RULE_OP_OR			0x02
+#define WOL_RULE_OP_INVALID		0xFF
+#define WOL_RESULT_VALID_CMD		0
+#define WOL_RESULT_NOSPC_ERR		1
+#define WOL_RESULT_EEXIST_ERR		2
 
 /** Misc constants */
 /* This section defines 802.11 specific contants */
diff --git a/drivers/net/wireless/libertas/ethtool.c b/drivers/net/wireless/libertas/ethtool.c
index 688d60d..73b414f 100644
--- a/drivers/net/wireless/libertas/ethtool.c
+++ b/drivers/net/wireless/libertas/ethtool.c
@@ -180,7 +180,7 @@ static int lbs_ethtool_set_wol(struct net_device *dev,
 	if (wol->wolopts & WAKE_BCAST) criteria |= EHS_WAKE_ON_BROADCAST_DATA;
 	if (wol->wolopts & WAKE_PHY)   criteria |= EHS_WAKE_ON_MAC_EVENT;
 
-	return lbs_host_sleep_cfg(priv, criteria);
+	return lbs_host_sleep_cfg(priv, criteria, (struct wol_config *)NULL);
 }
 
 struct ethtool_ops lbs_ethtool_ops = {
diff --git a/drivers/net/wireless/libertas/host.h b/drivers/net/wireless/libertas/host.h
index 5004d76..a17b778 100644
--- a/drivers/net/wireless/libertas/host.h
+++ b/drivers/net/wireless/libertas/host.h
@@ -220,6 +220,14 @@ enum cmd_fwt_access_opts {
 	CMD_ACT_FWT_ACCESS_TIME,
 };
 
+/* Define action or option for CMD_802_11_HOST_SLEEP_CFG */
+enum cmd_wol_cfg_opts {
+	CMD_ACT_ACTION_NONE = 0,
+	CMD_ACT_SET_WOL_RULE,
+	CMD_ACT_GET_WOL_RULE,
+	CMD_ACT_RESET_WOL_RULE,
+};
+
 /* Define action or option for CMD_MESH_ACCESS */
 enum cmd_mesh_access_opts {
 	CMD_ACT_MESH_GET_TTL = 1,
diff --git a/drivers/net/wireless/libertas/hostcmd.h b/drivers/net/wireless/libertas/hostcmd.h
index d9f9a12..e173b1b 100644
--- a/drivers/net/wireless/libertas/hostcmd.h
+++ b/drivers/net/wireless/libertas/hostcmd.h
@@ -580,13 +580,37 @@ struct MrvlIEtype_keyParamSet {
 	u8 key[32];
 };
 
+#define MAX_WOL_RULES 		16
+
+struct host_wol_rule {
+	uint8_t rule_no;
+	uint8_t rule_ops;
+	__le16 sig_offset;
+	__le16 sig_length;
+	__le16 reserve;
+	__be32 sig_mask;
+	__be32 signature;
+};
+
+struct wol_config {
+	uint8_t action;
+	uint8_t pattern;
+	uint8_t no_rules_in_cmd;
+	uint8_t result;
+	struct host_wol_rule rule[MAX_WOL_RULES];
+};
+
+
 struct cmd_ds_host_sleep {
 	struct cmd_header hdr;
 	__le32 criteria;
 	uint8_t gpio;
-	uint8_t gap;
+	uint16_t gap;
+	struct wol_config wol_conf;
 } __attribute__ ((packed));
 
+
+
 struct cmd_ds_802_11_key_material {
 	struct cmd_header hdr;
 
diff --git a/drivers/net/wireless/libertas/if_usb.c b/drivers/net/wireless/libertas/if_usb.c
index cafbccb..fcd3fe6 100644
--- a/drivers/net/wireless/libertas/if_usb.c
+++ b/drivers/net/wireless/libertas/if_usb.c
@@ -178,7 +178,8 @@ static void if_usb_setup_firmware(struct lbs_private *priv)
 
 	priv->wol_gpio = 2; /* Wake via GPIO2... */
 	priv->wol_gap = 20; /* ... after 20ms    */
-	lbs_host_sleep_cfg(priv, EHS_WAKE_ON_UNICAST_DATA);
+	lbs_host_sleep_cfg(priv, EHS_WAKE_ON_UNICAST_DATA,
+			(struct wol_config *) NULL);
 
 	wake_method.hdr.size = cpu_to_le16(sizeof(wake_method));
 	wake_method.action = cpu_to_le16(CMD_ACT_GET);
-- 
1.5.4.3



