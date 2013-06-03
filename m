Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58148 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755177Ab3FCOQC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Jun 2013 10:16:02 -0400
Date: Mon, 3 Jun 2013 16:18:05 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Tino Keitel <tino.keitel@tikei.de>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Power saving features for iwl4965
Message-ID: <20130603141804.GA2146@redhat.com> (sfid-20130603_161609_130774_442E6D68)
References: <20120418203543.GA16000@x61.home>
 <20120425122554.GD2466@redhat.com>
 <20120503182853.GA12461@mac.home>
 <20121226185425.GA12627@x61.home>
 <20130107110759.GC6931@redhat.com>
 <20130603085239.GA26920@mac.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130603085239.GA26920@mac.home>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 03, 2013 at 10:52:39AM +0200, Tino Keitel wrote:
> On Mon, Jan 07, 2013 at 12:08:00 +0100, Stanislaw Gruszka wrote:
> 
> [...]
> 
> > I posted patch here
> > http://marc.info/?l=linux-wireless&m=135601033021616&w=2
> > 
> > But I did not review code regarding power save to catch possible
> > problems. Testing are bug reporting are welcome ...
> 
> Hi,
> 
> the patch is surprisingly small. To me it looks like it only contains
> the code to make "iwconfig wlan0 power on" work, the actual power
> management is missing.
> 
> I just did some tests using powertop to see if I'm right. With the old
> pre-iwlegacy driver, the difference between "iwconfig wlan0 power on"
> and "...  power off" is more then 0,8W, which is ~10% of the total idle
> power usage of my X61s with dimmed screen.  With a current kernel and
> your patch, I can't measure a difference between "iwconfig wlan0 power
> on" and "...  power off".  To me it seems that the patch is pretty
> useless, at least on 4965AGN hardware.

Yes, we do not send any command to put hardware in sleep mode when 
mac80211 enable PS.

> It would be really nice to have proper power management in a current
> kernel, as the laptop gets noticeably hotter with the current iwlegacy
> driver.  That's why I still use a 3.1.10 kernel with an old
> forward-ported iwlagn driver.

Could you try this experimental patch?

diff --git a/drivers/net/wireless/iwlegacy/commands.h b/drivers/net/wireless/iwlegacy/commands.h
index 3b6c994..baf3ae7 100644
--- a/drivers/net/wireless/iwlegacy/commands.h
+++ b/drivers/net/wireless/iwlegacy/commands.h
@@ -2278,7 +2278,8 @@ struct il_spectrum_notification {
  */
 #define IL_POWER_VEC_SIZE 5
 
-#define IL_POWER_DRIVER_ALLOW_SLEEP_MSK	cpu_to_le16(BIT(0))
+#define IL_POWER_DRIVER_ALLOW_SLEEP_MSK		cpu_to_le16(BIT(0))
+#define IL_POWER_SLEEP_OVER_DTIM_MSK		cpu_to_le16(BIT(2))
 #define IL_POWER_PCI_PM_MSK			cpu_to_le16(BIT(3))
 
 struct il3945_powertable_cmd {
diff --git a/drivers/net/wireless/iwlegacy/common.c b/drivers/net/wireless/iwlegacy/common.c
index 592d0aa..07769ae 100644
--- a/drivers/net/wireless/iwlegacy/common.c
+++ b/drivers/net/wireless/iwlegacy/common.c
@@ -1079,29 +1079,80 @@ EXPORT_SYMBOL(il_get_channel_info);
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
+#define SLP_VEC(X0, X1, X2, X3, X4) {cpu_to_le32(X0), \
+                                     cpu_to_le32(X1), \
+                                     cpu_to_le32(X2), \
+                                     cpu_to_le32(X3), \
+                                     cpu_to_le32(X4)}
 
 static void
-il_power_sleep_cam_cmd(struct il_priv *il, struct il_powertable_cmd *cmd)
+il_build_powertable_cmd(struct il_priv *il, struct il_powertable_cmd *cmd)
 {
+	const __le32 interval[3][IL_POWER_VEC_SIZE] = {
+		SLP_VEC(2, 2, 4, 6, 0xFF),
+		SLP_VEC(2, 4, 7, 10, 10),
+ 		SLP_VEC(4, 7, 10, 10, 0xFF)
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
@@ -1174,7 +1225,8 @@ il_power_update_mode(struct il_priv *il, bool force)
 {
 	struct il_powertable_cmd cmd;
 
-	il_power_sleep_cam_cmd(il, &cmd);
+	il_build_powertable_cmd(il, &cmd);
+
 	return il_power_set_mode(il, &cmd, force);
 }
 EXPORT_SYMBOL(il_power_update_mode);
@@ -5081,6 +5133,7 @@ set_ch_out:
 	}
 
 	if (changed & (IEEE80211_CONF_CHANGE_PS | IEEE80211_CONF_CHANGE_IDLE)) {
+		il->power_data.ps_disabled = !(conf->flags & IEEE80211_CONF_PS);
 		ret = il_power_update_mode(il, false);
 		if (ret)
 			D_MAC80211("Error setting sleep level\n");
diff --git a/drivers/net/wireless/iwlegacy/common.h b/drivers/net/wireless/iwlegacy/common.h
index f8246f2..8f81983 100644
--- a/drivers/net/wireless/iwlegacy/common.h
+++ b/drivers/net/wireless/iwlegacy/common.h
@@ -1123,6 +1123,7 @@ struct il_power_mgr {
 	struct il_powertable_cmd sleep_cmd_next;
 	int debug_sleep_level_override;
 	bool pci_pm;
+	bool ps_disabled;
 };
 
 struct il_priv {

