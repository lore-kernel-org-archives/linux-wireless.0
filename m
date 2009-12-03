Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.89]:23097 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755939AbZLCKjY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Dec 2009 05:39:24 -0500
From: Samuel Ortiz <sameo@linux.intel.com>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>,
	Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 3/4] iwmc3200wifi: Add wifi-wimax coexistence mode as a module parameter
Date: Thu,  3 Dec 2009 11:40:17 +0100
Message-Id: <f623da29d10f87111c698e7d9750ae39cd98bb09.1259835655.git.sameo@linux.intel.com>
In-Reply-To: <3259e3798cc114c1d6da7e764ce9da739b4e88b4.1259835655.git.sameo@linux.intel.com>
References: <cover.1259835655.git.sameo@linux.intel.com>
 <4790a128344a09f0bdb2249c8ee831f254ca72ec.1259835655.git.sameo@linux.intel.com>
 <3259e3798cc114c1d6da7e764ce9da739b4e88b4.1259835655.git.sameo@linux.intel.com>
In-Reply-To: <cover.1259835655.git.sameo@linux.intel.com>
References: <cover.1259835655.git.sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Wifi and wimax coexistence mode is set by wifi at boot time. There can be
several modes, defined by priority tables. User space components can decide
which one to select by writing to /sys/module/iwmc3200wifi/parameters/wiwi
with this patch, before bringing the interface up.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 drivers/net/wireless/iwmc3200wifi/commands.c |   12 ++++++++----
 drivers/net/wireless/iwmc3200wifi/iwm.h      |    1 -
 drivers/net/wireless/iwmc3200wifi/main.c     |    1 -
 3 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwmc3200wifi/commands.c b/drivers/net/wireless/iwmc3200wifi/commands.c
index 1a4b7fb..5520693 100644
--- a/drivers/net/wireless/iwmc3200wifi/commands.c
+++ b/drivers/net/wireless/iwmc3200wifi/commands.c
@@ -99,6 +99,10 @@ int iwm_send_wifi_if_cmd(struct iwm_priv *iwm, void *payload, u16 payload_size,
 	return ret;
 }
 
+static int modparam_wiwi = COEX_MODE_CM;
+module_param_named(wiwi, modparam_wiwi, int, 0644);
+MODULE_PARM_DESC(wiwi, "Wifi-WiMAX coexistence: 1=SA, 2=XOR, 3=CM (default)");
+
 static struct coex_event iwm_sta_xor_prio_tbl[COEX_EVENTS_NUM] =
 {
 	{4, 3, 0, COEX_UNASSOC_IDLE_FLAGS},
@@ -148,7 +152,7 @@ int iwm_send_prio_table(struct iwm_priv *iwm)
 
 	coex_table_cmd.flags = COEX_FLAGS_STA_TABLE_VALID_MSK;
 
-	switch (iwm->conf.coexist_mode) {
+	switch (modparam_wiwi) {
 	case COEX_MODE_XOR:
 	case COEX_MODE_CM:
 		coex_enabled = 1;
@@ -173,7 +177,7 @@ int iwm_send_prio_table(struct iwm_priv *iwm)
 					COEX_FLAGS_ASSOC_WAKEUP_UMASK_MSK |
 					COEX_FLAGS_UNASSOC_WAKEUP_UMASK_MSK;
 
-		switch (iwm->conf.coexist_mode) {
+		switch (modparam_wiwi) {
 		case COEX_MODE_XOR:
 			memcpy(coex_table_cmd.sta_prio, iwm_sta_xor_prio_tbl,
 			       sizeof(iwm_sta_xor_prio_tbl));
@@ -184,7 +188,7 @@ int iwm_send_prio_table(struct iwm_priv *iwm)
 			break;
 		default:
 			IWM_ERR(iwm, "Invalid coex_mode 0x%x\n",
-				iwm->conf.coexist_mode);
+				modparam_wiwi);
 			break;
 		}
 	} else
@@ -396,7 +400,7 @@ int iwm_send_umac_config(struct iwm_priv *iwm, __le32 reset_flags)
 		return ret;
 
 	ret = iwm_umac_set_config_fix(iwm, UMAC_PARAM_TBL_CFG_FIX,
-				      CFG_COEX_MODE, iwm->conf.coexist_mode);
+				      CFG_COEX_MODE, modparam_wiwi);
 	if (ret < 0)
 		return ret;
 
diff --git a/drivers/net/wireless/iwmc3200wifi/iwm.h b/drivers/net/wireless/iwmc3200wifi/iwm.h
index 8d091f9..5a26bb0 100644
--- a/drivers/net/wireless/iwmc3200wifi/iwm.h
+++ b/drivers/net/wireless/iwmc3200wifi/iwm.h
@@ -81,7 +81,6 @@ struct iwm_conf {
 	u32 assoc_timeout;
 	u32 roam_timeout;
 	u32 wireless_mode;
-	u32 coexist_mode;
 
 	u8 ibss_band;
 	u8 ibss_channel;
diff --git a/drivers/net/wireless/iwmc3200wifi/main.c b/drivers/net/wireless/iwmc3200wifi/main.c
index 087f043..0ffb041 100644
--- a/drivers/net/wireless/iwmc3200wifi/main.c
+++ b/drivers/net/wireless/iwmc3200wifi/main.c
@@ -82,7 +82,6 @@ static struct iwm_conf def_iwm_conf = {
 	.roam_timeout		= 10,
 	.wireless_mode		= WIRELESS_MODE_11A | WIRELESS_MODE_11G |
 				  WIRELESS_MODE_11N,
-	.coexist_mode		= COEX_MODE_CM,
 
 	/* IBSS */
 	.ibss_band		= UMAC_BAND_2GHZ,
-- 
1.6.3.3

