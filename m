Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.179]:16162 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753794AbYIYXgf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Sep 2008 19:36:35 -0400
Received: by wa-out-1112.google.com with SMTP id v27so323753wah.21
        for <linux-wireless@vger.kernel.org>; Thu, 25 Sep 2008 16:36:34 -0700 (PDT)
To: linux-wireless@vger.kernel.org
Cc: libertas-dev@lists.infradead.org
From: Anna Neal <anna@cozybit.com>
Date: Thu, 25 Sep 2008 16:19:31 -0700
Subject: [PATCH] libertas: Improvements on automatic tx power control via SIOCSIWTXPOW.
Message-ID: <48dc2080.14be600a.433d.fffffde3@mx.google.com> (sfid-20080926_013639_591581_4A95FE47)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

iwconfig txpower can now be used to set tx power to fixed or auto. If set to
auto the default firmware settings are used.

The command CMD_802_11_PA_CFG is only sent to older firmware, as Dan Williams
noted the command was no longer supported in firmware V9+.

Signed-off-by: Anna Neal <anna@cozybit.com>
Signed-off-by: Javier Cardona <javier@cozybit.com>
---
 drivers/net/wireless/libertas/cmd.c     |   64 +++++++++++++++++++++++++++++++
 drivers/net/wireless/libertas/cmd.h     |    6 +++
 drivers/net/wireless/libertas/defs.h    |    9 ++++
 drivers/net/wireless/libertas/host.h    |    1 +
 drivers/net/wireless/libertas/hostcmd.h |   24 +++++++++--
 drivers/net/wireless/libertas/wext.c    |   32 ++++++++++++++-
 6 files changed, 129 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
index 7e818b0..a912fb6 100644
--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -1927,6 +1927,70 @@ void lbs_ps_confirm_sleep(struct lbs_private *priv)
 }
 
 
+/**
+ * @brief Configures the transmission power control functionality.
+ *
+ * @param priv		A pointer to struct lbs_private structure
+ * @param enable	Transmission power control enable
+ * @param p0		Power level when link quality is good (dBm).
+ * @param p1		Power level when link quality is fair (dBm).
+ * @param p2		Power level when link quality is poor (dBm).
+ * @param usesnr	Use Signal to Noise Ratio in TPC
+ *
+ * @return 0 on success
+ */
+int lbs_set_tpc_cfg(struct lbs_private *priv, int enable, int8_t p0, int8_t p1,
+		int8_t p2, int usesnr)
+{
+	struct cmd_ds_802_11_tpc_cfg cmd;
+	int ret;
+
+	memset(&cmd, 0, sizeof(cmd));
+	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
+	cmd.action = cpu_to_le16(CMD_ACT_SET);
+	cmd.enable = !!enable;
+	cmd.usesnr = !!usesnr;
+	cmd.P0 = p0;
+	cmd.P1 = p1;
+	cmd.P2 = p2;
+
+	ret = lbs_cmd_with_response(priv, CMD_802_11_TPC_CFG, &cmd);
+
+	return ret;
+}
+
+/**
+ * @brief Configures the power adaptation settings.
+ *
+ * @param priv		A pointer to struct lbs_private structure
+ * @param enable	Power adaptation enable
+ * @param p0		Power level for 1, 2, 5.5 and 11 Mbps (dBm).
+ * @param p1		Power level for 6, 9, 12, 18, 22, 24 and 36 Mbps (dBm).
+ * @param p2		Power level for 48 and 54 Mbps (dBm).
+ *
+ * @return 0 on Success
+ */
+
+int lbs_set_power_adapt_cfg(struct lbs_private *priv, int enable, int8_t p0,
+		int8_t p1, int8_t p2)
+{
+	struct cmd_ds_802_11_pa_cfg cmd;
+	int ret;
+
+	memset(&cmd, 0, sizeof(cmd));
+	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
+	cmd.action = cpu_to_le16(CMD_ACT_SET);
+	cmd.enable = !!enable;
+	cmd.P0 = p0;
+	cmd.P1 = p1;
+	cmd.P2 = p2;
+
+	ret = lbs_cmd_with_response(priv, CMD_802_11_PA_CFG , &cmd);
+
+	return ret;
+}
+
+
 static struct cmd_ctrl_node *__lbs_cmd_async(struct lbs_private *priv,
 	uint16_t command, struct cmd_header *in_cmd, int in_cmd_size,
 	int (*callback)(struct lbs_private *, unsigned long, struct cmd_header *),
diff --git a/drivers/net/wireless/libertas/cmd.h b/drivers/net/wireless/libertas/cmd.h
index 9a35e15..d002160 100644
--- a/drivers/net/wireless/libertas/cmd.h
+++ b/drivers/net/wireless/libertas/cmd.h
@@ -26,6 +26,12 @@ int __lbs_cmd(struct lbs_private *priv, uint16_t command,
 	      int (*callback)(struct lbs_private *, unsigned long, struct cmd_header *),
 	      unsigned long callback_arg);
 
+int lbs_set_power_adapt_cfg(struct lbs_private *priv, int enable, int8_t p0,
+		int8_t p1, int8_t p2);
+
+int lbs_set_tpc_cfg(struct lbs_private *priv, int enable, int8_t p0, int8_t p1,
+		int8_t p2, int usesnr);
+
 int lbs_cmd_copyback(struct lbs_private *priv, unsigned long extra,
 		     struct cmd_header *resp);
 
diff --git a/drivers/net/wireless/libertas/defs.h b/drivers/net/wireless/libertas/defs.h
index c20fcf1..58d11a3 100644
--- a/drivers/net/wireless/libertas/defs.h
+++ b/drivers/net/wireless/libertas/defs.h
@@ -189,6 +189,15 @@ static inline void lbs_deb_hex(unsigned int grp, const char *prompt, u8 *buf, in
 #define MRVDRV_CMD_UPLD_RDY		0x0008
 #define MRVDRV_CARDEVENT		0x0010
 
+
+/* Automatic TX control default levels */
+#define POW_ADAPT_DEFAULT_P0 13
+#define POW_ADAPT_DEFAULT_P1 15
+#define POW_ADAPT_DEFAULT_P2 18
+#define TPC_DEFAULT_P0 5
+#define TPC_DEFAULT_P1 10
+#define TPC_DEFAULT_P2 13
+
 /** TxPD status */
 
 /*	Station firmware use TxPD status field to report final Tx transmit
diff --git a/drivers/net/wireless/libertas/host.h b/drivers/net/wireless/libertas/host.h
index d1d0666..5004d76 100644
--- a/drivers/net/wireless/libertas/host.h
+++ b/drivers/net/wireless/libertas/host.h
@@ -72,6 +72,7 @@
 #define CMD_802_11_INACTIVITY_TIMEOUT		0x0067
 #define CMD_802_11_SLEEP_PERIOD			0x0068
 #define CMD_802_11_TPC_CFG			0x0072
+#define CMD_802_11_PA_CFG			0x0073
 #define CMD_802_11_FW_WAKE_METHOD		0x0074
 #define CMD_802_11_SUBSCRIBE_EVENT		0x0075
 #define CMD_802_11_RATE_ADAPT_RATESET		0x0076
diff --git a/drivers/net/wireless/libertas/hostcmd.h b/drivers/net/wireless/libertas/hostcmd.h
index b4ae2c2..d9f9a12 100644
--- a/drivers/net/wireless/libertas/hostcmd.h
+++ b/drivers/net/wireless/libertas/hostcmd.h
@@ -605,14 +605,28 @@ struct cmd_ds_802_11_eeprom_access {
 } __attribute__ ((packed));
 
 struct cmd_ds_802_11_tpc_cfg {
+	struct cmd_header hdr;
+
 	__le16 action;
-	u8 enable;
-	s8 P0;
-	s8 P1;
-	s8 P2;
-	u8 usesnr;
+	uint8_t enable;
+	int8_t P0;
+	int8_t P1;
+	int8_t P2;
+	uint8_t usesnr;
 } __attribute__ ((packed));
 
+
+struct cmd_ds_802_11_pa_cfg {
+	struct cmd_header hdr;
+
+	__le16 action;
+	uint8_t enable;
+	int8_t P0;
+	int8_t P1;
+	int8_t P2;
+} __attribute__ ((packed));
+
+
 struct cmd_ds_802_11_led_ctrl {
 	__le16 action;
 	__le16 numled;
diff --git a/drivers/net/wireless/libertas/wext.c b/drivers/net/wireless/libertas/wext.c
index 641e1c6..caf6108 100644
--- a/drivers/net/wireless/libertas/wext.c
+++ b/drivers/net/wireless/libertas/wext.c
@@ -1856,7 +1856,22 @@ static int lbs_set_txpow(struct net_device *dev, struct iw_request_info *info,
 	}
 
 	if (vwrq->fixed == 0) {
-		/* Auto power control */
+		/* User requests automatic tx power control, however there are
+		 * many auto tx settings.  For now use firmware defaults
+		 * (enable power adaptation and disable TPC) until we come up
+		 * with a good way to expose these to the user. */
+		if (priv->fwrelease < 0x09000000) {
+			ret = lbs_set_power_adapt_cfg(priv, 1,
+					POW_ADAPT_DEFAULT_P0,
+					POW_ADAPT_DEFAULT_P1,
+					POW_ADAPT_DEFAULT_P2);
+			if (ret)
+				goto out;
+		}
+		ret = lbs_set_tpc_cfg(priv, 0, TPC_DEFAULT_P0, TPC_DEFAULT_P1,
+				TPC_DEFAULT_P2, 1);
+		if (ret)
+			goto out;
 		dbm = priv->txpower_max;
 	} else {
 		/* Userspace check in iwrange if it should use dBm or mW,
@@ -1866,7 +1881,8 @@ static int lbs_set_txpow(struct net_device *dev, struct iw_request_info *info,
 			goto out;
 		}
 
-		/* Validate requested power level against firmware allowed levels */
+		/* Validate requested power level against firmware allowed
+		 * levels */
 		if (priv->txpower_min && (dbm < priv->txpower_min)) {
 			ret = -EINVAL;
 			goto out;
@@ -1876,6 +1892,18 @@ static int lbs_set_txpow(struct net_device *dev, struct iw_request_info *info,
 			ret = -EINVAL;
 			goto out;
 		}
+		if (priv->fwrelease < 0x09000000) {
+			ret = lbs_set_power_adapt_cfg(priv, 0,
+					POW_ADAPT_DEFAULT_P0,
+					POW_ADAPT_DEFAULT_P1,
+					POW_ADAPT_DEFAULT_P2);
+			if (ret)
+				goto out;
+		}
+		ret = lbs_set_tpc_cfg(priv, 0, TPC_DEFAULT_P0, TPC_DEFAULT_P1,
+				TPC_DEFAULT_P2, 1);
+		if (ret)
+			goto out;
 	}
 
 	/* If the radio was off, turn it on */
-- 
1.5.4.3



