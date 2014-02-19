Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47750 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752485AbaBSINK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Feb 2014 03:13:10 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 3/3] iwlegacy: properly enable power saving
Date: Wed, 19 Feb 2014 09:15:11 +0100
Message-Id: <1392797711-2564-3-git-send-email-sgruszka@redhat.com> (sfid-20140219_091314_748136_DF167A27)
In-Reply-To: <1392797711-2564-1-git-send-email-sgruszka@redhat.com>
References: <1392797711-2564-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Even if we mark PS on, device still worked in normal mode. Patch
corrects that and now we send proper powertable command to device,
which put it in sleep mode when PS is on.

Reported-and-tested-by: Tino Keitel <tino.keitel@tikei.de>
Tested-by: Pedro Francisco <pedrogfrancisco@gmail.com>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/commands.h |  3 +-
 drivers/net/wireless/iwlegacy/common.c   | 83 ++++++++++++++++++++++++++------
 drivers/net/wireless/iwlegacy/common.h   |  1 +
 3 files changed, 72 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/commands.h b/drivers/net/wireless/iwlegacy/commands.h
index 0484215..dd74413 100644
--- a/drivers/net/wireless/iwlegacy/commands.h
+++ b/drivers/net/wireless/iwlegacy/commands.h
@@ -2270,7 +2270,8 @@ struct il_spectrum_notification {
  */
 #define IL_POWER_VEC_SIZE 5
 
-#define IL_POWER_DRIVER_ALLOW_SLEEP_MSK	cpu_to_le16(BIT(0))
+#define IL_POWER_DRIVER_ALLOW_SLEEP_MSK		cpu_to_le16(BIT(0))
+#define IL_POWER_SLEEP_OVER_DTIM_MSK		cpu_to_le16(BIT(2))
 #define IL_POWER_PCI_PM_MSK			cpu_to_le16(BIT(3))
 
 struct il3945_powertable_cmd {
diff --git a/drivers/net/wireless/iwlegacy/common.c b/drivers/net/wireless/iwlegacy/common.c
index 02e8233..4f42174 100644
--- a/drivers/net/wireless/iwlegacy/common.c
+++ b/drivers/net/wireless/iwlegacy/common.c
@@ -1078,29 +1078,82 @@ EXPORT_SYMBOL(il_get_channel_info);
  * Setting power level allows the card to go to sleep when not busy.
  *
  * We calculate a sleep command based on the required latency, which
- * we get from mac80211. In order to handle thermal throttling, we can
- * also use pre-defined power levels.
+ * we get from mac80211.
  */
 
-/*
- * This defines the old power levels. They are still used by default
- * (level 1) and for thermal throttle (levels 3 through 5)
- */
-
-struct il_power_vec_entry {
-	struct il_powertable_cmd cmd;
-	u8 no_dtim;		/* number of skip dtim */
-};
+#define SLP_VEC(X0, X1, X2, X3, X4) { \
+		cpu_to_le32(X0), \
+		cpu_to_le32(X1), \
+		cpu_to_le32(X2), \
+		cpu_to_le32(X3), \
+		cpu_to_le32(X4)  \
+}
 
 static void
-il_power_sleep_cam_cmd(struct il_priv *il, struct il_powertable_cmd *cmd)
+il_build_powertable_cmd(struct il_priv *il, struct il_powertable_cmd *cmd)
 {
+	const __le32 interval[3][IL_POWER_VEC_SIZE] = {
+		SLP_VEC(2, 2, 4, 6, 0xFF),
+		SLP_VEC(2, 4, 7, 10, 10),
+		SLP_VEC(4, 7, 10, 10, 0xFF)
+	};
+	int i, dtim_period, no_dtim;
+	u32 max_sleep;
+	bool skip;
+
 	memset(cmd, 0, sizeof(*cmd));
 
 	if (il->power_data.pci_pm)
 		cmd->flags |= IL_POWER_PCI_PM_MSK;
 
-	D_POWER("Sleep command for CAM\n");
+	/* if no Power Save, we are done */
+	if (il->power_data.ps_disabled)
+		return;
+
+	cmd->flags = IL_POWER_DRIVER_ALLOW_SLEEP_MSK;
+	cmd->keep_alive_seconds = 0;
+	cmd->debug_flags = 0;
+	cmd->rx_data_timeout = cpu_to_le32(25 * 1024);
+	cmd->tx_data_timeout = cpu_to_le32(25 * 1024);
+	cmd->keep_alive_beacons = 0;
+
+	dtim_period = il->vif ? il->vif->bss_conf.dtim_period : 0;
+
+	if (dtim_period <= 2) {
+		memcpy(cmd->sleep_interval, interval[0], sizeof(interval[0]));
+		no_dtim = 2;
+	} else if (dtim_period <= 10) {
+		memcpy(cmd->sleep_interval, interval[1], sizeof(interval[1]));
+		no_dtim = 2;
+	} else {
+		memcpy(cmd->sleep_interval, interval[2], sizeof(interval[2]));
+		no_dtim = 0;
+	}
+
+	if (dtim_period == 0) {
+		dtim_period = 1;
+		skip = false;
+	} else {
+		skip = !!no_dtim;
+	}
+
+	if (skip) {
+		__le32 tmp = cmd->sleep_interval[IL_POWER_VEC_SIZE - 1];
+
+		max_sleep = le32_to_cpu(tmp);
+		if (max_sleep == 0xFF)
+			max_sleep = dtim_period * (skip + 1);
+		else if (max_sleep >  dtim_period)
+			max_sleep = (max_sleep / dtim_period) * dtim_period;
+		cmd->flags |= IL_POWER_SLEEP_OVER_DTIM_MSK;
+	} else {
+		max_sleep = dtim_period;
+		cmd->flags &= ~IL_POWER_SLEEP_OVER_DTIM_MSK;
+	}
+
+	for (i = 0; i < IL_POWER_VEC_SIZE; i++)
+		if (le32_to_cpu(cmd->sleep_interval[i]) > max_sleep)
+			cmd->sleep_interval[i] = cpu_to_le32(max_sleep);
 }
 
 static int
@@ -1173,7 +1226,8 @@ il_power_update_mode(struct il_priv *il, bool force)
 {
 	struct il_powertable_cmd cmd;
 
-	il_power_sleep_cam_cmd(il, &cmd);
+	il_build_powertable_cmd(il, &cmd);
+
 	return il_power_set_mode(il, &cmd, force);
 }
 EXPORT_SYMBOL(il_power_update_mode);
@@ -5081,6 +5135,7 @@ set_ch_out:
 	}
 
 	if (changed & (IEEE80211_CONF_CHANGE_PS | IEEE80211_CONF_CHANGE_IDLE)) {
+		il->power_data.ps_disabled = !(conf->flags & IEEE80211_CONF_PS);
 		ret = il_power_update_mode(il, false);
 		if (ret)
 			D_MAC80211("Error setting sleep level\n");
diff --git a/drivers/net/wireless/iwlegacy/common.h b/drivers/net/wireless/iwlegacy/common.h
index 21964d2..13145ad 100644
--- a/drivers/net/wireless/iwlegacy/common.h
+++ b/drivers/net/wireless/iwlegacy/common.h
@@ -1123,6 +1123,7 @@ struct il_power_mgr {
 	struct il_powertable_cmd sleep_cmd_next;
 	int debug_sleep_level_override;
 	bool pci_pm;
+	bool ps_disabled;
 };
 
 struct il_priv {
-- 
1.7.11.7

