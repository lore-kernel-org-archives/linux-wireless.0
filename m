Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:55985 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762799AbXLMG74 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2007 01:59:56 -0500
Subject: [PATCH 87/48] libertas: add lbs_host_sleep_cfg() command function
From: David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <libertas-12345@shinybook.infradead.org>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
Message-Id: <E1J2i3B-0005u8-GD@shinybook.infradead.org> (sfid-20071213_070027_161293_91EAF39C)
Date: Thu, 13 Dec 2007 02:00:05 -0500
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Date: Wed, 12 Dec 2007 15:19:29 -0500

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/libertas/cmd.c     |   19 +++++++++++++++++++
 drivers/net/wireless/libertas/cmd.h     |    3 +++
 drivers/net/wireless/libertas/defs.h    |    7 +++++++
 drivers/net/wireless/libertas/host.h    |    2 ++
 drivers/net/wireless/libertas/hostcmd.h |    7 +++++++
 5 files changed, 38 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
index 8d8f9d9..2d7b646 100644
--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -111,6 +111,25 @@ out:
 	return ret;
 }
 
+int lbs_host_sleep_cfg(struct lbs_private *priv, uint32_t criteria,
+		       uint8_t gpio, uint8_t gap)
+{
+	struct cmd_ds_host_sleep cmd_config;
+	int ret;
+
+	cmd_config.criteria = cpu_to_le32(criteria);
+	cmd_config.gpio = gpio;
+	cmd_config.gap = gap;
+
+	ret = lbs_cmd_with_response(priv, CMD_802_11_HOST_SLEEP_CFG, cmd_config);
+	if (ret) {
+		lbs_pr_info("HOST_SLEEP_CFG failed %d\n", ret);
+		return ret;
+	}
+	return ret;
+}
+EXPORT_SYMBOL_GPL(lbs_host_sleep_cfg);
+
 static int lbs_cmd_802_11_ps_mode(struct lbs_private *priv,
 				   struct cmd_ds_command *cmd,
 				   u16 cmd_action)
diff --git a/drivers/net/wireless/libertas/cmd.h b/drivers/net/wireless/libertas/cmd.h
index 80714b5..8d72c7e 100644
--- a/drivers/net/wireless/libertas/cmd.h
+++ b/drivers/net/wireless/libertas/cmd.h
@@ -35,4 +35,7 @@ int lbs_set_channel(struct lbs_private *priv, u8 channel);
 
 int lbs_mesh_config(struct lbs_private *priv, int enable);
 
+int lbs_host_sleep_cfg(struct lbs_private *priv, uint32_t criteria,
+		       uint8_t gpio, uint8_t gap);
+
 #endif /* _LBS_CMD_H */
diff --git a/drivers/net/wireless/libertas/defs.h b/drivers/net/wireless/libertas/defs.h
index 9b98ae7..3053cc2 100644
--- a/drivers/net/wireless/libertas/defs.h
+++ b/drivers/net/wireless/libertas/defs.h
@@ -141,6 +141,13 @@ static inline void lbs_deb_hex(unsigned int grp, const char *prompt, u8 *buf, in
 #define	LBS_UPLD_SIZE			2312
 #define DEV_NAME_LEN			32
 
+/* Wake criteria for HOST_SLEEP_CFG command */
+#define EHS_WAKE_ON_BROADCAST_DATA	0x0001
+#define EHS_WAKE_ON_UNICAST_DATA	0x0002
+#define EHS_WAKE_ON_MAC_EVENT		0x0004
+#define EHS_WAKE_ON_MULTICAST_DATA	0x0008
+#define EHS_REMOVE_WAKEUP		0xFFFFFFFF
+
 /** Misc constants */
 /* This section defines 802.11 specific contants */
 
diff --git a/drivers/net/wireless/libertas/host.h b/drivers/net/wireless/libertas/host.h
index 64178cf..fe00081 100644
--- a/drivers/net/wireless/libertas/host.h
+++ b/drivers/net/wireless/libertas/host.h
@@ -73,6 +73,8 @@
 #define CMD_802_11_SET_AFC			0x003c
 #define CMD_802_11_GET_AFC			0x003d
 #define CMD_802_11_AD_HOC_STOP			0x0040
+#define CMD_802_11_HOST_SLEEP_CFG		0x0043
+#define CMD_802_11_HOST_SLEEP_ACTIVATE		0x0045
 #define CMD_802_11_BEACON_STOP			0x0049
 #define CMD_802_11_MAC_ADDRESS			0x004d
 #define CMD_802_11_LED_GPIO_CTRL		0x004e
diff --git a/drivers/net/wireless/libertas/hostcmd.h b/drivers/net/wireless/libertas/hostcmd.h
index aab5d64..aa4cea0 100644
--- a/drivers/net/wireless/libertas/hostcmd.h
+++ b/drivers/net/wireless/libertas/hostcmd.h
@@ -540,6 +540,13 @@ struct MrvlIEtype_keyParamSet {
 	u8 key[32];
 };
 
+struct cmd_ds_host_sleep {
+	struct cmd_header hdr;
+	__le32 criteria;
+	uint8_t gpio;
+	uint8_t gap;
+} __attribute__ ((packed));
+
 struct cmd_ds_802_11_key_material {
 	__le16 action;
 	struct MrvlIEtype_keyParamSet keyParamSet[2];
-- 
1.5.3.4

