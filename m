Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0166.hostedemail.com ([216.40.44.166]:57427 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751677AbeCWWzd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 23 Mar 2018 18:55:33 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Slaby <jirislaby@gmail.com>,
        Nick Kossifidis <mickflemm@gmail.com>,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        Kalle Valo <kvalo@qca.qualcomm.com>,
        QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        Christian Lamparter <chunkeey@googlemail.com>,
        Eugene Krasnikov <k.eugene.e@gmail.com>,
        Stanislav Yakovlev <stas.yakovlev@gmail.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Jakub Kicinski <kubakici@wp.pl>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        Solomon Peachy <pizza@shaftnet.org>,
        Matthias Brugger <matthias.bgg@gmail.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, wcn36xx@lists.infradead.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH 2/4] wireless: Use octal not symbolic permissions
Date: Fri, 23 Mar 2018 15:54:37 -0700
Message-Id: <a368e1c4878619172f3da4849cb211b4dfad0a58.1521845237.git.joe@perches.com> (sfid-20180323_235653_128317_04944286)
In-Reply-To: <cover.1521845235.git.joe@perches.com>
References: <cover.1521845235.git.joe@perches.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Prefer the direct use of octal for permissions.

Done with checkpatch -f --types=SYMBOLIC_PERMS --fix-inplace
and some typing.

Miscellanea:

o Whitespace neatening around these conversions.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/wireless/ath/ath5k/base.c              |   6 +-
 drivers/net/wireless/ath/ath5k/debug.c             |  37 +++----
 drivers/net/wireless/ath/ath5k/sysfs.c             |   8 +-
 drivers/net/wireless/ath/ath6kl/debug.c            |  43 ++++----
 drivers/net/wireless/ath/ath9k/common-debug.c      |   9 +-
 drivers/net/wireless/ath/ath9k/common-spectral.c   |  10 +-
 drivers/net/wireless/ath/ath9k/debug.c             |  40 ++++----
 drivers/net/wireless/ath/ath9k/debug_sta.c         |   6 +-
 drivers/net/wireless/ath/ath9k/dfs_debug.c         |   4 +-
 drivers/net/wireless/ath/ath9k/htc_drv_debug.c     |  16 +--
 drivers/net/wireless/ath/ath9k/tx99.c              |   4 +-
 drivers/net/wireless/ath/carl9170/debug.c          |   8 +-
 drivers/net/wireless/ath/carl9170/main.c           |   4 +-
 drivers/net/wireless/ath/wcn36xx/debug.c           |   5 +-
 .../wireless/broadcom/brcm80211/brcmfmac/common.c  |   6 +-
 .../wireless/broadcom/brcm80211/brcmsmac/debug.c   |   2 +-
 .../broadcom/brcm80211/brcmsmac/mac80211_if.c      |   2 +-
 drivers/net/wireless/cisco/airo.c                  |   6 +-
 drivers/net/wireless/intel/ipw2x00/ipw2100.c       |  29 +++---
 drivers/net/wireless/intel/ipw2x00/ipw2200.c       |  51 +++++-----
 drivers/net/wireless/intel/ipw2x00/libipw_module.c |   2 +-
 drivers/net/wireless/intel/iwlegacy/3945-mac.c     |  35 +++----
 drivers/net/wireless/intel/iwlegacy/4965-mac.c     |  19 ++--
 drivers/net/wireless/intel/iwlegacy/4965-rs.c      |   8 +-
 drivers/net/wireless/intel/iwlegacy/common.c       |   4 +-
 drivers/net/wireless/intel/iwlegacy/debug.c        |  58 ++++++-----
 drivers/net/wireless/intel/iwlwifi/dvm/debugfs.c   |  78 +++++++--------
 drivers/net/wireless/intel/iwlwifi/dvm/rs.c        |  16 +--
 drivers/net/wireless/intel/iwlwifi/fw/debugfs.c    |   2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c       |  43 ++++----
 .../net/wireless/intel/iwlwifi/mvm/debugfs-vif.c   |  40 +++-----
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c   | 110 ++++++++++-----------
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |   6 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c        |  12 +--
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    |  12 +--
 drivers/net/wireless/intersil/p54/main.c           |   2 +-
 drivers/net/wireless/mediatek/mt76/debugfs.c       |  10 +-
 .../net/wireless/mediatek/mt76/mt76x2_debugfs.c    |   8 +-
 drivers/net/wireless/mediatek/mt7601u/debugfs.c    |  16 ++-
 drivers/net/wireless/ralink/rt2x00/rt2500usb.c     |   2 +-
 drivers/net/wireless/ralink/rt2x00/rt2800pci.c     |   2 +-
 drivers/net/wireless/ralink/rt2x00/rt2800soc.c     |   2 +-
 drivers/net/wireless/ralink/rt2x00/rt2800usb.c     |   2 +-
 drivers/net/wireless/ralink/rt2x00/rt2x00debug.c   |  64 ++++++------
 drivers/net/wireless/ralink/rt2x00/rt61pci.c       |   2 +-
 drivers/net/wireless/ralink/rt2x00/rt73usb.c       |   2 +-
 drivers/net/wireless/ray_cs.c                      |   8 +-
 drivers/net/wireless/st/cw1200/debug.c             |   6 +-
 drivers/net/wireless/st/cw1200/main.c              |   2 +-
 drivers/net/wireless/ti/wl18xx/main.c              |  27 +++--
 drivers/net/wireless/ti/wlcore/main.c              |   8 +-
 drivers/net/wireless/ti/wlcore/sdio.c              |   2 +-
 drivers/net/wireless/ti/wlcore/sysfs.c             |   7 +-
 53 files changed, 427 insertions(+), 486 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 527afcf39246..a2351ef45ae0 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -73,16 +73,16 @@
 #include "trace.h"
 
 bool ath5k_modparam_nohwcrypt;
-module_param_named(nohwcrypt, ath5k_modparam_nohwcrypt, bool, S_IRUGO);
+module_param_named(nohwcrypt, ath5k_modparam_nohwcrypt, bool, 0444);
 MODULE_PARM_DESC(nohwcrypt, "Disable hardware encryption.");
 
 static bool modparam_fastchanswitch;
-module_param_named(fastchanswitch, modparam_fastchanswitch, bool, S_IRUGO);
+module_param_named(fastchanswitch, modparam_fastchanswitch, bool, 0444);
 MODULE_PARM_DESC(fastchanswitch, "Enable fast channel switching for AR2413/AR5413 radios.");
 
 static bool ath5k_modparam_no_hw_rfkill_switch;
 module_param_named(no_hw_rfkill_switch, ath5k_modparam_no_hw_rfkill_switch,
-								bool, S_IRUGO);
+		   bool, 0444);
 MODULE_PARM_DESC(no_hw_rfkill_switch, "Ignore the GPIO RFKill switch state");
 
 
diff --git a/drivers/net/wireless/ath/ath5k/debug.c b/drivers/net/wireless/ath/ath5k/debug.c
index bd7f6d7b199e..3513bbec4639 100644
--- a/drivers/net/wireless/ath/ath5k/debug.c
+++ b/drivers/net/wireless/ath/ath5k/debug.c
@@ -1004,32 +1004,17 @@ ath5k_debug_init_device(struct ath5k_hw *ah)
 	if (!phydir)
 		return;
 
-	debugfs_create_file("debug", S_IWUSR | S_IRUSR, phydir, ah,
-			    &fops_debug);
-
-	debugfs_create_file("registers", S_IRUSR, phydir, ah, &fops_registers);
-
-	debugfs_create_file("beacon", S_IWUSR | S_IRUSR, phydir, ah,
-			    &fops_beacon);
-
-	debugfs_create_file("reset", S_IWUSR, phydir, ah, &fops_reset);
-
-	debugfs_create_file("antenna", S_IWUSR | S_IRUSR, phydir, ah,
-			    &fops_antenna);
-
-	debugfs_create_file("misc", S_IRUSR, phydir, ah, &fops_misc);
-
-	debugfs_create_file("eeprom", S_IRUSR, phydir, ah, &fops_eeprom);
-
-	debugfs_create_file("frameerrors", S_IWUSR | S_IRUSR, phydir, ah,
-			    &fops_frameerrors);
-
-	debugfs_create_file("ani", S_IWUSR | S_IRUSR, phydir, ah, &fops_ani);
-
-	debugfs_create_file("queue", S_IWUSR | S_IRUSR, phydir, ah,
-			    &fops_queue);
-
-	debugfs_create_bool("32khz_clock", S_IWUSR | S_IRUSR, phydir,
+	debugfs_create_file("debug", 0600, phydir, ah, &fops_debug);
+	debugfs_create_file("registers", 0400, phydir, ah, &fops_registers);
+	debugfs_create_file("beacon", 0600, phydir, ah, &fops_beacon);
+	debugfs_create_file("reset", 0200, phydir, ah, &fops_reset);
+	debugfs_create_file("antenna", 0600, phydir, ah, &fops_antenna);
+	debugfs_create_file("misc", 0400, phydir, ah, &fops_misc);
+	debugfs_create_file("eeprom", 0400, phydir, ah, &fops_eeprom);
+	debugfs_create_file("frameerrors", 0600, phydir, ah, &fops_frameerrors);
+	debugfs_create_file("ani", 0600, phydir, ah, &fops_ani);
+	debugfs_create_file("queue", 0600, phydir, ah, &fops_queue);
+	debugfs_create_bool("32khz_clock", 0600, phydir,
 			    &ah->ah_use_32khz_clock);
 }
 
diff --git a/drivers/net/wireless/ath/ath5k/sysfs.c b/drivers/net/wireless/ath/ath5k/sysfs.c
index 25978c732fe1..8113baddd8fc 100644
--- a/drivers/net/wireless/ath/ath5k/sysfs.c
+++ b/drivers/net/wireless/ath/ath5k/sysfs.c
@@ -31,7 +31,7 @@ static ssize_t ath5k_attr_store_##name(struct device *dev,		\
 	set(ah, val);						\
 	return count;							\
 }									\
-static DEVICE_ATTR(name, S_IRUGO | S_IWUSR,				\
+static DEVICE_ATTR(name, 0644,						\
 		   ath5k_attr_show_##name, ath5k_attr_store_##name)
 
 #define SIMPLE_SHOW(name, get)						\
@@ -43,7 +43,7 @@ static ssize_t ath5k_attr_show_##name(struct device *dev,		\
 	struct ath5k_hw *ah = hw->priv;				\
 	return snprintf(buf, PAGE_SIZE, "%d\n", get);			\
 }									\
-static DEVICE_ATTR(name, S_IRUGO, ath5k_attr_show_##name, NULL)
+static DEVICE_ATTR(name, 0444, ath5k_attr_show_##name, NULL)
 
 /*** ANI ***/
 
@@ -66,7 +66,7 @@ static ssize_t ath5k_attr_show_noise_immunity_level_max(struct device *dev,
 {
 	return snprintf(buf, PAGE_SIZE, "%d\n", ATH5K_ANI_MAX_NOISE_IMM_LVL);
 }
-static DEVICE_ATTR(noise_immunity_level_max, S_IRUGO,
+static DEVICE_ATTR(noise_immunity_level_max, 0444,
 		   ath5k_attr_show_noise_immunity_level_max, NULL);
 
 static ssize_t ath5k_attr_show_firstep_level_max(struct device *dev,
@@ -75,7 +75,7 @@ static ssize_t ath5k_attr_show_firstep_level_max(struct device *dev,
 {
 	return snprintf(buf, PAGE_SIZE, "%d\n", ATH5K_ANI_MAX_FIRSTEP_LVL);
 }
-static DEVICE_ATTR(firstep_level_max, S_IRUGO,
+static DEVICE_ATTR(firstep_level_max, 0444,
 		   ath5k_attr_show_firstep_level_max, NULL);
 
 static struct attribute *ath5k_sysfs_entries_ani[] = {
diff --git a/drivers/net/wireless/ath/ath6kl/debug.c b/drivers/net/wireless/ath/ath6kl/debug.c
index 1eea6c23976f..0f965e9f38a4 100644
--- a/drivers/net/wireless/ath/ath6kl/debug.c
+++ b/drivers/net/wireless/ath/ath6kl/debug.c
@@ -1794,69 +1794,68 @@ int ath6kl_debug_init_fs(struct ath6kl *ar)
 	if (!ar->debugfs_phy)
 		return -ENOMEM;
 
-	debugfs_create_file("tgt_stats", S_IRUSR, ar->debugfs_phy, ar,
+	debugfs_create_file("tgt_stats", 0400, ar->debugfs_phy, ar,
 			    &fops_tgt_stats);
 
 	if (ar->hif_type == ATH6KL_HIF_TYPE_SDIO)
-		debugfs_create_file("credit_dist_stats", S_IRUSR,
+		debugfs_create_file("credit_dist_stats", 0400,
 				    ar->debugfs_phy, ar,
 				    &fops_credit_dist_stats);
 
-	debugfs_create_file("endpoint_stats", S_IRUSR | S_IWUSR,
+	debugfs_create_file("endpoint_stats", 0600,
 			    ar->debugfs_phy, ar, &fops_endpoint_stats);
 
-	debugfs_create_file("fwlog", S_IRUSR, ar->debugfs_phy, ar,
-			    &fops_fwlog);
+	debugfs_create_file("fwlog", 0400, ar->debugfs_phy, ar, &fops_fwlog);
 
-	debugfs_create_file("fwlog_block", S_IRUSR, ar->debugfs_phy, ar,
+	debugfs_create_file("fwlog_block", 0400, ar->debugfs_phy, ar,
 			    &fops_fwlog_block);
 
-	debugfs_create_file("fwlog_mask", S_IRUSR | S_IWUSR, ar->debugfs_phy,
+	debugfs_create_file("fwlog_mask", 0600, ar->debugfs_phy,
 			    ar, &fops_fwlog_mask);
 
-	debugfs_create_file("reg_addr", S_IRUSR | S_IWUSR, ar->debugfs_phy, ar,
+	debugfs_create_file("reg_addr", 0600, ar->debugfs_phy, ar,
 			    &fops_diag_reg_read);
 
-	debugfs_create_file("reg_dump", S_IRUSR, ar->debugfs_phy, ar,
+	debugfs_create_file("reg_dump", 0400, ar->debugfs_phy, ar,
 			    &fops_reg_dump);
 
-	debugfs_create_file("lrssi_roam_threshold", S_IRUSR | S_IWUSR,
+	debugfs_create_file("lrssi_roam_threshold", 0600,
 			    ar->debugfs_phy, ar, &fops_lrssi_roam_threshold);
 
-	debugfs_create_file("reg_write", S_IRUSR | S_IWUSR,
+	debugfs_create_file("reg_write", 0600,
 			    ar->debugfs_phy, ar, &fops_diag_reg_write);
 
-	debugfs_create_file("war_stats", S_IRUSR, ar->debugfs_phy, ar,
+	debugfs_create_file("war_stats", 0400, ar->debugfs_phy, ar,
 			    &fops_war_stats);
 
-	debugfs_create_file("roam_table", S_IRUSR, ar->debugfs_phy, ar,
+	debugfs_create_file("roam_table", 0400, ar->debugfs_phy, ar,
 			    &fops_roam_table);
 
-	debugfs_create_file("force_roam", S_IWUSR, ar->debugfs_phy, ar,
+	debugfs_create_file("force_roam", 0200, ar->debugfs_phy, ar,
 			    &fops_force_roam);
 
-	debugfs_create_file("roam_mode", S_IWUSR, ar->debugfs_phy, ar,
+	debugfs_create_file("roam_mode", 0200, ar->debugfs_phy, ar,
 			    &fops_roam_mode);
 
-	debugfs_create_file("keepalive", S_IRUSR | S_IWUSR, ar->debugfs_phy, ar,
+	debugfs_create_file("keepalive", 0600, ar->debugfs_phy, ar,
 			    &fops_keepalive);
 
-	debugfs_create_file("disconnect_timeout", S_IRUSR | S_IWUSR,
+	debugfs_create_file("disconnect_timeout", 0600,
 			    ar->debugfs_phy, ar, &fops_disconnect_timeout);
 
-	debugfs_create_file("create_qos", S_IWUSR, ar->debugfs_phy, ar,
+	debugfs_create_file("create_qos", 0200, ar->debugfs_phy, ar,
 			    &fops_create_qos);
 
-	debugfs_create_file("delete_qos", S_IWUSR, ar->debugfs_phy, ar,
+	debugfs_create_file("delete_qos", 0200, ar->debugfs_phy, ar,
 			    &fops_delete_qos);
 
-	debugfs_create_file("bgscan_interval", S_IWUSR,
+	debugfs_create_file("bgscan_interval", 0200,
 			    ar->debugfs_phy, ar, &fops_bgscan_int);
 
-	debugfs_create_file("listen_interval", S_IRUSR | S_IWUSR,
+	debugfs_create_file("listen_interval", 0600,
 			    ar->debugfs_phy, ar, &fops_listen_int);
 
-	debugfs_create_file("power_params", S_IWUSR, ar->debugfs_phy, ar,
+	debugfs_create_file("power_params", 0200, ar->debugfs_phy, ar,
 			    &fops_power_params);
 
 	return 0;
diff --git a/drivers/net/wireless/ath/ath9k/common-debug.c b/drivers/net/wireless/ath/ath9k/common-debug.c
index 84afcf78151f..239429f10378 100644
--- a/drivers/net/wireless/ath/ath9k/common-debug.c
+++ b/drivers/net/wireless/ath/ath9k/common-debug.c
@@ -47,7 +47,7 @@ static const struct file_operations fops_modal_eeprom = {
 void ath9k_cmn_debug_modal_eeprom(struct dentry *debugfs_phy,
 				  struct ath_hw *ah)
 {
-	debugfs_create_file("modal_eeprom", S_IRUSR, debugfs_phy, ah,
+	debugfs_create_file("modal_eeprom", 0400, debugfs_phy, ah,
 			    &fops_modal_eeprom);
 }
 EXPORT_SYMBOL(ath9k_cmn_debug_modal_eeprom);
@@ -82,7 +82,7 @@ static const struct file_operations fops_base_eeprom = {
 void ath9k_cmn_debug_base_eeprom(struct dentry *debugfs_phy,
 				 struct ath_hw *ah)
 {
-	debugfs_create_file("base_eeprom", S_IRUSR, debugfs_phy, ah,
+	debugfs_create_file("base_eeprom", 0400, debugfs_phy, ah,
 			    &fops_base_eeprom);
 }
 EXPORT_SYMBOL(ath9k_cmn_debug_base_eeprom);
@@ -178,8 +178,7 @@ static const struct file_operations fops_recv = {
 void ath9k_cmn_debug_recv(struct dentry *debugfs_phy,
 			  struct ath_rx_stats *rxstats)
 {
-	debugfs_create_file("recv", S_IRUSR, debugfs_phy, rxstats,
-			    &fops_recv);
+	debugfs_create_file("recv", 0400, debugfs_phy, rxstats, &fops_recv);
 }
 EXPORT_SYMBOL(ath9k_cmn_debug_recv);
 
@@ -255,7 +254,7 @@ static const struct file_operations fops_phy_err = {
 void ath9k_cmn_debug_phy_err(struct dentry *debugfs_phy,
 			     struct ath_rx_stats *rxstats)
 {
-	debugfs_create_file("phy_err", S_IRUSR, debugfs_phy, rxstats,
+	debugfs_create_file("phy_err", 0400, debugfs_phy, rxstats,
 			    &fops_phy_err);
 }
 EXPORT_SYMBOL(ath9k_cmn_debug_phy_err);
diff --git a/drivers/net/wireless/ath/ath9k/common-spectral.c b/drivers/net/wireless/ath/ath9k/common-spectral.c
index 5e77fe1f5b0d..809a2646bc6d 100644
--- a/drivers/net/wireless/ath/ath9k/common-spectral.c
+++ b/drivers/net/wireless/ath/ath9k/common-spectral.c
@@ -1096,23 +1096,23 @@ void ath9k_cmn_spectral_init_debug(struct ath_spec_scan_priv *spec_priv,
 		return;
 
 	debugfs_create_file("spectral_scan_ctl",
-			    S_IRUSR | S_IWUSR,
+			    0600,
 			    debugfs_phy, spec_priv,
 			    &fops_spec_scan_ctl);
 	debugfs_create_file("spectral_short_repeat",
-			    S_IRUSR | S_IWUSR,
+			    0600,
 			    debugfs_phy, spec_priv,
 			    &fops_spectral_short_repeat);
 	debugfs_create_file("spectral_count",
-			    S_IRUSR | S_IWUSR,
+			    0600,
 			    debugfs_phy, spec_priv,
 			    &fops_spectral_count);
 	debugfs_create_file("spectral_period",
-			    S_IRUSR | S_IWUSR,
+			    0600,
 			    debugfs_phy, spec_priv,
 			    &fops_spectral_period);
 	debugfs_create_file("spectral_fft_period",
-			    S_IRUSR | S_IWUSR,
+			    0600,
 			    debugfs_phy, spec_priv,
 			    &fops_spectral_fft_period);
 }
diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index 9e8aed5c478c..f685843a2ff3 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -1385,7 +1385,7 @@ int ath9k_init_debug(struct ath_hw *ah)
 		return -ENOMEM;
 
 #ifdef CONFIG_ATH_DEBUG
-	debugfs_create_file("debug", S_IRUSR | S_IWUSR, sc->debug.debugfs_phy,
+	debugfs_create_file("debug", 0600, sc->debug.debugfs_phy,
 			    sc, &fops_debug);
 #endif
 
@@ -1409,22 +1409,22 @@ int ath9k_init_debug(struct ath_hw *ah)
 	ath9k_cmn_debug_recv(sc->debug.debugfs_phy, &sc->debug.stats.rxstats);
 	ath9k_cmn_debug_phy_err(sc->debug.debugfs_phy, &sc->debug.stats.rxstats);
 
-	debugfs_create_u8("rx_chainmask", S_IRUSR, sc->debug.debugfs_phy,
+	debugfs_create_u8("rx_chainmask", 0400, sc->debug.debugfs_phy,
 			  &ah->rxchainmask);
-	debugfs_create_u8("tx_chainmask", S_IRUSR, sc->debug.debugfs_phy,
+	debugfs_create_u8("tx_chainmask", 0400, sc->debug.debugfs_phy,
 			  &ah->txchainmask);
-	debugfs_create_file("ani", S_IRUSR | S_IWUSR,
+	debugfs_create_file("ani", 0600,
 			    sc->debug.debugfs_phy, sc, &fops_ani);
-	debugfs_create_bool("paprd", S_IRUSR | S_IWUSR, sc->debug.debugfs_phy,
+	debugfs_create_bool("paprd", 0600, sc->debug.debugfs_phy,
 			    &sc->sc_ah->config.enable_paprd);
-	debugfs_create_file("regidx", S_IRUSR | S_IWUSR, sc->debug.debugfs_phy,
+	debugfs_create_file("regidx", 0600, sc->debug.debugfs_phy,
 			    sc, &fops_regidx);
-	debugfs_create_file("regval", S_IRUSR | S_IWUSR, sc->debug.debugfs_phy,
+	debugfs_create_file("regval", 0600, sc->debug.debugfs_phy,
 			    sc, &fops_regval);
-	debugfs_create_bool("ignore_extcca", S_IRUSR | S_IWUSR,
+	debugfs_create_bool("ignore_extcca", 0600,
 			    sc->debug.debugfs_phy,
 			    &ah->config.cwm_ignore_extcca);
-	debugfs_create_file("regdump", S_IRUSR, sc->debug.debugfs_phy, sc,
+	debugfs_create_file("regdump", 0400, sc->debug.debugfs_phy, sc,
 			    &fops_regdump);
 	debugfs_create_devm_seqfile(sc->dev, "dump_nfcal",
 				    sc->debug.debugfs_phy,
@@ -1433,35 +1433,33 @@ int ath9k_init_debug(struct ath_hw *ah)
 	ath9k_cmn_debug_base_eeprom(sc->debug.debugfs_phy, sc->sc_ah);
 	ath9k_cmn_debug_modal_eeprom(sc->debug.debugfs_phy, sc->sc_ah);
 
-	debugfs_create_u32("gpio_mask", S_IRUSR | S_IWUSR,
+	debugfs_create_u32("gpio_mask", 0600,
 			   sc->debug.debugfs_phy, &sc->sc_ah->gpio_mask);
-	debugfs_create_u32("gpio_val", S_IRUSR | S_IWUSR,
+	debugfs_create_u32("gpio_val", 0600,
 			   sc->debug.debugfs_phy, &sc->sc_ah->gpio_val);
-	debugfs_create_file("antenna_diversity", S_IRUSR,
+	debugfs_create_file("antenna_diversity", 0400,
 			    sc->debug.debugfs_phy, sc, &fops_antenna_diversity);
 #ifdef CONFIG_ATH9K_BTCOEX_SUPPORT
-	debugfs_create_file("bt_ant_diversity", S_IRUSR | S_IWUSR,
+	debugfs_create_file("bt_ant_diversity", 0600,
 			    sc->debug.debugfs_phy, sc, &fops_bt_ant_diversity);
-	debugfs_create_file("btcoex", S_IRUSR, sc->debug.debugfs_phy, sc,
+	debugfs_create_file("btcoex", 0400, sc->debug.debugfs_phy, sc,
 			    &fops_btcoex);
 #endif
 
 #ifdef CONFIG_ATH9K_WOW
-	debugfs_create_file("wow", S_IRUSR | S_IWUSR,
-			    sc->debug.debugfs_phy, sc, &fops_wow);
+	debugfs_create_file("wow", 0600, sc->debug.debugfs_phy, sc, &fops_wow);
 #endif
 
 #ifdef CONFIG_ATH9K_DYNACK
-	debugfs_create_file("ack_to", S_IRUSR, sc->debug.debugfs_phy,
+	debugfs_create_file("ack_to", 0400, sc->debug.debugfs_phy,
 			    sc, &fops_ackto);
 #endif
-	debugfs_create_file("tpc", S_IRUSR | S_IWUSR,
-			    sc->debug.debugfs_phy, sc, &fops_tpc);
+	debugfs_create_file("tpc", 0600, sc->debug.debugfs_phy, sc, &fops_tpc);
 
-	debugfs_create_u16("airtime_flags", S_IRUSR | S_IWUSR,
+	debugfs_create_u16("airtime_flags", 0600,
 			   sc->debug.debugfs_phy, &sc->airtime_flags);
 
-	debugfs_create_file("nf_override", S_IRUSR | S_IWUSR,
+	debugfs_create_file("nf_override", 0600,
 			    sc->debug.debugfs_phy, sc, &fops_nf_override);
 
 	return 0;
diff --git a/drivers/net/wireless/ath/ath9k/debug_sta.c b/drivers/net/wireless/ath/ath9k/debug_sta.c
index efc692ee67d4..a6f45f1bb5bb 100644
--- a/drivers/net/wireless/ath/ath9k/debug_sta.c
+++ b/drivers/net/wireless/ath/ath9k/debug_sta.c
@@ -302,7 +302,7 @@ void ath9k_sta_add_debugfs(struct ieee80211_hw *hw,
 {
 	struct ath_node *an = (struct ath_node *)sta->drv_priv;
 
-	debugfs_create_file("node_aggr", S_IRUGO, dir, an, &fops_node_aggr);
-	debugfs_create_file("node_recv", S_IRUGO, dir, an, &fops_node_recv);
-	debugfs_create_file("airtime", S_IRUGO, dir, an, &fops_airtime);
+	debugfs_create_file("node_aggr", 0444, dir, an, &fops_node_aggr);
+	debugfs_create_file("node_recv", 0444, dir, an, &fops_node_recv);
+	debugfs_create_file("airtime", 0444, dir, an, &fops_airtime);
 }
diff --git a/drivers/net/wireless/ath/ath9k/dfs_debug.c b/drivers/net/wireless/ath/ath9k/dfs_debug.c
index 8824610c21fb..3251c9abe270 100644
--- a/drivers/net/wireless/ath/ath9k/dfs_debug.c
+++ b/drivers/net/wireless/ath/ath9k/dfs_debug.c
@@ -144,8 +144,8 @@ static const struct file_operations fops_dfs_stats = {
 
 void ath9k_dfs_init_debug(struct ath_softc *sc)
 {
-	debugfs_create_file("dfs_stats", S_IRUSR,
+	debugfs_create_file("dfs_stats", 0400,
 			    sc->debug.debugfs_phy, sc, &fops_dfs_stats);
-	debugfs_create_file("dfs_simulate_radar", S_IWUSR,
+	debugfs_create_file("dfs_simulate_radar", 0200,
 			    sc->debug.debugfs_phy, sc, &fops_simulate_radar);
 }
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_debug.c b/drivers/net/wireless/ath/ath9k/htc_drv_debug.c
index dc79afd7e151..b3ed65e5c4da 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_debug.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_debug.c
@@ -496,25 +496,25 @@ int ath9k_htc_init_debug(struct ath_hw *ah)
 
 	ath9k_cmn_spectral_init_debug(&priv->spec_priv, priv->debug.debugfs_phy);
 
-	debugfs_create_file("tgt_int_stats", S_IRUSR, priv->debug.debugfs_phy,
+	debugfs_create_file("tgt_int_stats", 0400, priv->debug.debugfs_phy,
 			    priv, &fops_tgt_int_stats);
-	debugfs_create_file("tgt_tx_stats", S_IRUSR, priv->debug.debugfs_phy,
+	debugfs_create_file("tgt_tx_stats", 0400, priv->debug.debugfs_phy,
 			    priv, &fops_tgt_tx_stats);
-	debugfs_create_file("tgt_rx_stats", S_IRUSR, priv->debug.debugfs_phy,
+	debugfs_create_file("tgt_rx_stats", 0400, priv->debug.debugfs_phy,
 			    priv, &fops_tgt_rx_stats);
-	debugfs_create_file("xmit", S_IRUSR, priv->debug.debugfs_phy,
+	debugfs_create_file("xmit", 0400, priv->debug.debugfs_phy,
 			    priv, &fops_xmit);
-	debugfs_create_file("skb_rx", S_IRUSR, priv->debug.debugfs_phy,
+	debugfs_create_file("skb_rx", 0400, priv->debug.debugfs_phy,
 			    priv, &fops_skb_rx);
 
 	ath9k_cmn_debug_recv(priv->debug.debugfs_phy, &priv->debug.rx_stats);
 	ath9k_cmn_debug_phy_err(priv->debug.debugfs_phy, &priv->debug.rx_stats);
 
-	debugfs_create_file("slot", S_IRUSR, priv->debug.debugfs_phy,
+	debugfs_create_file("slot", 0400, priv->debug.debugfs_phy,
 			    priv, &fops_slot);
-	debugfs_create_file("queue", S_IRUSR, priv->debug.debugfs_phy,
+	debugfs_create_file("queue", 0400, priv->debug.debugfs_phy,
 			    priv, &fops_queue);
-	debugfs_create_file("debug", S_IRUSR | S_IWUSR, priv->debug.debugfs_phy,
+	debugfs_create_file("debug", 0600, priv->debug.debugfs_phy,
 			    priv, &fops_debug);
 
 	ath9k_cmn_debug_base_eeprom(priv->debug.debugfs_phy, priv->ah);
diff --git a/drivers/net/wireless/ath/ath9k/tx99.c b/drivers/net/wireless/ath/ath9k/tx99.c
index fe3a8263b224..ce50d8f5835e 100644
--- a/drivers/net/wireless/ath/ath9k/tx99.c
+++ b/drivers/net/wireless/ath/ath9k/tx99.c
@@ -278,10 +278,10 @@ void ath9k_tx99_init_debug(struct ath_softc *sc)
 	if (!AR_SREV_9280_20_OR_LATER(sc->sc_ah))
 		return;
 
-	debugfs_create_file("tx99", S_IRUSR | S_IWUSR,
+	debugfs_create_file("tx99", 0600,
 			    sc->debug.debugfs_phy, sc,
 			    &fops_tx99);
-	debugfs_create_file("tx99_power", S_IRUSR | S_IWUSR,
+	debugfs_create_file("tx99_power", 0600,
 			    sc->debug.debugfs_phy, sc,
 			    &fops_tx99_power);
 }
diff --git a/drivers/net/wireless/ath/carl9170/debug.c b/drivers/net/wireless/ath/carl9170/debug.c
index ec3a64e5d2bb..a9b6dc17e408 100644
--- a/drivers/net/wireless/ath/carl9170/debug.c
+++ b/drivers/net/wireless/ath/carl9170/debug.c
@@ -187,21 +187,21 @@ static const struct carl9170_debugfs_fops carl_debugfs_##name ##_ops = {\
 
 #define DEBUGFS_DECLARE_RO_FILE(name, _read_bufsize)			\
 	DEBUGFS_DECLARE_FILE(name, carl9170_debugfs_##name ##_read,	\
-			     NULL, _read_bufsize, S_IRUSR)
+			     NULL, _read_bufsize, 0400)
 
 #define DEBUGFS_DECLARE_WO_FILE(name)					\
 	DEBUGFS_DECLARE_FILE(name, NULL, carl9170_debugfs_##name ##_write,\
-			     0, S_IWUSR)
+			     0, 0200)
 
 #define DEBUGFS_DECLARE_RW_FILE(name, _read_bufsize)			\
 	DEBUGFS_DECLARE_FILE(name, carl9170_debugfs_##name ##_read,	\
 			     carl9170_debugfs_##name ##_write,		\
-			     _read_bufsize, S_IRUSR | S_IWUSR)
+			     _read_bufsize, 0600)
 
 #define __DEBUGFS_DECLARE_RW_FILE(name, _read_bufsize, _dstate)		\
 	__DEBUGFS_DECLARE_FILE(name, carl9170_debugfs_##name ##_read,	\
 			     carl9170_debugfs_##name ##_write,		\
-			     _read_bufsize, S_IRUSR | S_IWUSR, _dstate)
+			     _read_bufsize, 0600, _dstate)
 
 #define DEBUGFS_READONLY_FILE(name, _read_bufsize, fmt, value...)	\
 static char *carl9170_debugfs_ ##name ## _read(struct ar9170 *ar,	\
diff --git a/drivers/net/wireless/ath/carl9170/main.c b/drivers/net/wireless/ath/carl9170/main.c
index 988c8857d78c..29e93c953d93 100644
--- a/drivers/net/wireless/ath/carl9170/main.c
+++ b/drivers/net/wireless/ath/carl9170/main.c
@@ -48,11 +48,11 @@
 #include "cmd.h"
 
 static bool modparam_nohwcrypt;
-module_param_named(nohwcrypt, modparam_nohwcrypt, bool, S_IRUGO);
+module_param_named(nohwcrypt, modparam_nohwcrypt, bool, 0444);
 MODULE_PARM_DESC(nohwcrypt, "Disable hardware crypto offload.");
 
 int modparam_noht;
-module_param_named(noht, modparam_noht, int, S_IRUGO);
+module_param_named(noht, modparam_noht, int, 0444);
 MODULE_PARM_DESC(noht, "Disable MPDU aggregation.");
 
 #define RATE(_bitrate, _hw_rate, _txpidx, _flags) {	\
diff --git a/drivers/net/wireless/ath/wcn36xx/debug.c b/drivers/net/wireless/ath/wcn36xx/debug.c
index 2a6bb62e785c..389b5e7129a6 100644
--- a/drivers/net/wireless/ath/wcn36xx/debug.c
+++ b/drivers/net/wireless/ath/wcn36xx/debug.c
@@ -161,9 +161,8 @@ void wcn36xx_debugfs_init(struct wcn36xx *wcn)
 		dfs->rootdir = NULL;
 	}
 
-	ADD_FILE(bmps_switcher, S_IRUSR | S_IWUSR,
-		 &fops_wcn36xx_bmps, wcn);
-	ADD_FILE(dump, S_IWUSR, &fops_wcn36xx_dump, wcn);
+	ADD_FILE(bmps_switcher, 0600, &fops_wcn36xx_bmps, wcn);
+	ADD_FILE(dump, 0200, &fops_wcn36xx_dump, wcn);
 }
 
 void wcn36xx_debugfs_exit(struct wcn36xx *wcn)
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
index 5532ef39439f..549c6c3254cb 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
@@ -51,7 +51,7 @@ MODULE_PARM_DESC(txglomsz, "Maximum tx packet chain size [SDIO]");
 
 /* Debug level configuration. See debug.h for bits, sysfs modifiable */
 int brcmf_msg_level;
-module_param_named(debug, brcmf_msg_level, int, S_IRUSR | S_IWUSR);
+module_param_named(debug, brcmf_msg_level, int, 0600);
 MODULE_PARM_DESC(debug, "Level of debug output");
 
 static int brcmf_p2p_enable;
@@ -64,7 +64,7 @@ MODULE_PARM_DESC(feature_disable, "Disable features");
 
 static char brcmf_firmware_path[BRCMF_FW_ALTPATH_LEN];
 module_param_string(alternative_fw_path, brcmf_firmware_path,
-		    BRCMF_FW_ALTPATH_LEN, S_IRUSR);
+		    BRCMF_FW_ALTPATH_LEN, 0400);
 MODULE_PARM_DESC(alternative_fw_path, "Alternative firmware path");
 
 static int brcmf_fcmode;
@@ -72,7 +72,7 @@ module_param_named(fcmode, brcmf_fcmode, int, 0);
 MODULE_PARM_DESC(fcmode, "Mode of firmware signalled flow control");
 
 static int brcmf_roamoff;
-module_param_named(roamoff, brcmf_roamoff, int, S_IRUSR);
+module_param_named(roamoff, brcmf_roamoff, int, 0400);
 MODULE_PARM_DESC(roamoff, "Do not use internal roaming engine");
 
 static int brcmf_iapp_enable;
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/debug.c b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/debug.c
index 7a1fbb2e3a71..2fe1f6863278 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/debug.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/debug.c
@@ -214,7 +214,7 @@ brcms_debugfs_add_entry(struct brcms_pub *drvr, const char *fn,
 	entry->read = read_fn;
 	entry->drvr = drvr;
 
-	dentry = debugfs_create_file(fn, S_IRUGO, dentry, entry,
+	dentry = debugfs_create_file(fn, 0444, dentry, entry,
 				     &brcms_debugfs_def_ops);
 
 	return PTR_ERR_OR_ZERO(dentry);
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.c b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.c
index ddfdfe177e24..8e58f6800483 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.c
@@ -108,7 +108,7 @@ MODULE_DEVICE_TABLE(bcma, brcms_coreid_table);
  * flags are specified by the BRCM_DL_* macros in
  * drivers/net/wireless/brcm80211/include/defs.h.
  */
-module_param_named(debug, brcm_msg_level, uint, S_IRUGO | S_IWUSR);
+module_param_named(debug, brcm_msg_level, uint, 0644);
 #endif
 
 static struct ieee80211_channel brcms_2ghz_chantable[] = {
diff --git a/drivers/net/wireless/cisco/airo.c b/drivers/net/wireless/cisco/airo.c
index 54201c02fdb8..ce0fbf83285f 100644
--- a/drivers/net/wireless/cisco/airo.c
+++ b/drivers/net/wireless/cisco/airo.c
@@ -4519,21 +4519,21 @@ static int setup_proc_entry( struct net_device *dev,
 	proc_set_user(apriv->proc_entry, proc_kuid, proc_kgid);
 
 	/* Setup the StatsDelta */
-	entry = proc_create_data("StatsDelta", S_IRUGO & proc_perm,
+	entry = proc_create_data("StatsDelta", 0444 & proc_perm,
 				 apriv->proc_entry, &proc_statsdelta_ops, dev);
 	if (!entry)
 		goto fail;
 	proc_set_user(entry, proc_kuid, proc_kgid);
 
 	/* Setup the Stats */
-	entry = proc_create_data("Stats", S_IRUGO & proc_perm,
+	entry = proc_create_data("Stats", 0444 & proc_perm,
 				 apriv->proc_entry, &proc_stats_ops, dev);
 	if (!entry)
 		goto fail;
 	proc_set_user(entry, proc_kuid, proc_kgid);
 
 	/* Setup the Status */
-	entry = proc_create_data("Status", S_IRUGO & proc_perm,
+	entry = proc_create_data("Status", 0444 & proc_perm,
 				 apriv->proc_entry, &proc_status_ops, dev);
 	if (!entry)
 		goto fail;
diff --git a/drivers/net/wireless/intel/ipw2x00/ipw2100.c b/drivers/net/wireless/intel/ipw2x00/ipw2100.c
index 19c442cb93e4..236b52423506 100644
--- a/drivers/net/wireless/intel/ipw2x00/ipw2100.c
+++ b/drivers/net/wireless/intel/ipw2x00/ipw2100.c
@@ -3538,7 +3538,7 @@ static ssize_t show_pci(struct device *d, struct device_attribute *attr,
 	return out - buf;
 }
 
-static DEVICE_ATTR(pci, S_IRUGO, show_pci, NULL);
+static DEVICE_ATTR(pci, 0444, show_pci, NULL);
 
 static ssize_t show_cfg(struct device *d, struct device_attribute *attr,
 			char *buf)
@@ -3547,7 +3547,7 @@ static ssize_t show_cfg(struct device *d, struct device_attribute *attr,
 	return sprintf(buf, "0x%08x\n", (int)p->config);
 }
 
-static DEVICE_ATTR(cfg, S_IRUGO, show_cfg, NULL);
+static DEVICE_ATTR(cfg, 0444, show_cfg, NULL);
 
 static ssize_t show_status(struct device *d, struct device_attribute *attr,
 			   char *buf)
@@ -3556,7 +3556,7 @@ static ssize_t show_status(struct device *d, struct device_attribute *attr,
 	return sprintf(buf, "0x%08x\n", (int)p->status);
 }
 
-static DEVICE_ATTR(status, S_IRUGO, show_status, NULL);
+static DEVICE_ATTR(status, 0444, show_status, NULL);
 
 static ssize_t show_capability(struct device *d, struct device_attribute *attr,
 			       char *buf)
@@ -3565,7 +3565,7 @@ static ssize_t show_capability(struct device *d, struct device_attribute *attr,
 	return sprintf(buf, "0x%08x\n", (int)p->capability);
 }
 
-static DEVICE_ATTR(capability, S_IRUGO, show_capability, NULL);
+static DEVICE_ATTR(capability, 0444, show_capability, NULL);
 
 #define IPW2100_REG(x) { IPW_ ##x, #x }
 static const struct {
@@ -3822,7 +3822,7 @@ static ssize_t show_registers(struct device *d, struct device_attribute *attr,
 	return out - buf;
 }
 
-static DEVICE_ATTR(registers, S_IRUGO, show_registers, NULL);
+static DEVICE_ATTR(registers, 0444, show_registers, NULL);
 
 static ssize_t show_hardware(struct device *d, struct device_attribute *attr,
 			     char *buf)
@@ -3863,7 +3863,7 @@ static ssize_t show_hardware(struct device *d, struct device_attribute *attr,
 	return out - buf;
 }
 
-static DEVICE_ATTR(hardware, S_IRUGO, show_hardware, NULL);
+static DEVICE_ATTR(hardware, 0444, show_hardware, NULL);
 
 static ssize_t show_memory(struct device *d, struct device_attribute *attr,
 			   char *buf)
@@ -3957,7 +3957,7 @@ static ssize_t store_memory(struct device *d, struct device_attribute *attr,
 	return count;
 }
 
-static DEVICE_ATTR(memory, S_IWUSR | S_IRUGO, show_memory, store_memory);
+static DEVICE_ATTR(memory, 0644, show_memory, store_memory);
 
 static ssize_t show_ordinals(struct device *d, struct device_attribute *attr,
 			     char *buf)
@@ -3993,7 +3993,7 @@ static ssize_t show_ordinals(struct device *d, struct device_attribute *attr,
 	return len;
 }
 
-static DEVICE_ATTR(ordinals, S_IRUGO, show_ordinals, NULL);
+static DEVICE_ATTR(ordinals, 0444, show_ordinals, NULL);
 
 static ssize_t show_stats(struct device *d, struct device_attribute *attr,
 			  char *buf)
@@ -4014,7 +4014,7 @@ static ssize_t show_stats(struct device *d, struct device_attribute *attr,
 	return out - buf;
 }
 
-static DEVICE_ATTR(stats, S_IRUGO, show_stats, NULL);
+static DEVICE_ATTR(stats, 0444, show_stats, NULL);
 
 static int ipw2100_switch_mode(struct ipw2100_priv *priv, u32 mode)
 {
@@ -4112,7 +4112,7 @@ static ssize_t show_internals(struct device *d, struct device_attribute *attr,
 	return len;
 }
 
-static DEVICE_ATTR(internals, S_IRUGO, show_internals, NULL);
+static DEVICE_ATTR(internals, 0444, show_internals, NULL);
 
 static ssize_t show_bssinfo(struct device *d, struct device_attribute *attr,
 			    char *buf)
@@ -4157,7 +4157,7 @@ static ssize_t show_bssinfo(struct device *d, struct device_attribute *attr,
 	return out - buf;
 }
 
-static DEVICE_ATTR(bssinfo, S_IRUGO, show_bssinfo, NULL);
+static DEVICE_ATTR(bssinfo, 0444, show_bssinfo, NULL);
 
 #ifdef CONFIG_IPW2100_DEBUG
 static ssize_t debug_level_show(struct device_driver *d, char *buf)
@@ -4216,8 +4216,7 @@ static ssize_t store_fatal_error(struct device *d,
 	return count;
 }
 
-static DEVICE_ATTR(fatal_error, S_IWUSR | S_IRUGO, show_fatal_error,
-		   store_fatal_error);
+static DEVICE_ATTR(fatal_error, 0644, show_fatal_error, store_fatal_error);
 
 static ssize_t show_scan_age(struct device *d, struct device_attribute *attr,
 			     char *buf)
@@ -4250,7 +4249,7 @@ static ssize_t store_scan_age(struct device *d, struct device_attribute *attr,
 	return strnlen(buf, count);
 }
 
-static DEVICE_ATTR(scan_age, S_IWUSR | S_IRUGO, show_scan_age, store_scan_age);
+static DEVICE_ATTR(scan_age, 0644, show_scan_age, store_scan_age);
 
 static ssize_t show_rf_kill(struct device *d, struct device_attribute *attr,
 			    char *buf)
@@ -4304,7 +4303,7 @@ static ssize_t store_rf_kill(struct device *d, struct device_attribute *attr,
 	return count;
 }
 
-static DEVICE_ATTR(rf_kill, S_IWUSR | S_IRUGO, show_rf_kill, store_rf_kill);
+static DEVICE_ATTR(rf_kill, 0644, show_rf_kill, store_rf_kill);
 
 static struct attribute *ipw2100_sysfs_entries[] = {
 	&dev_attr_hardware.attr,
diff --git a/drivers/net/wireless/intel/ipw2x00/ipw2200.c b/drivers/net/wireless/intel/ipw2x00/ipw2200.c
index 8da87496cb58..87a5e414c2f7 100644
--- a/drivers/net/wireless/intel/ipw2x00/ipw2200.c
+++ b/drivers/net/wireless/intel/ipw2x00/ipw2200.c
@@ -1303,7 +1303,7 @@ static ssize_t show_event_log(struct device *d,
 	return len;
 }
 
-static DEVICE_ATTR(event_log, S_IRUGO, show_event_log, NULL);
+static DEVICE_ATTR(event_log, 0444, show_event_log, NULL);
 
 static ssize_t show_error(struct device *d,
 			  struct device_attribute *attr, char *buf)
@@ -1351,7 +1351,7 @@ static ssize_t clear_error(struct device *d,
 	return count;
 }
 
-static DEVICE_ATTR(error, S_IRUGO | S_IWUSR, show_error, clear_error);
+static DEVICE_ATTR(error, 0644, show_error, clear_error);
 
 static ssize_t show_cmd_log(struct device *d,
 			    struct device_attribute *attr, char *buf)
@@ -1378,7 +1378,7 @@ static ssize_t show_cmd_log(struct device *d,
 	return len;
 }
 
-static DEVICE_ATTR(cmd_log, S_IRUGO, show_cmd_log, NULL);
+static DEVICE_ATTR(cmd_log, 0444, show_cmd_log, NULL);
 
 #ifdef CONFIG_IPW2200_PROMISCUOUS
 static void ipw_prom_free(struct ipw_priv *priv);
@@ -1443,8 +1443,7 @@ static ssize_t show_rtap_iface(struct device *d,
 	}
 }
 
-static DEVICE_ATTR(rtap_iface, S_IWUSR | S_IRUSR, show_rtap_iface,
-		   store_rtap_iface);
+static DEVICE_ATTR(rtap_iface, 0600, show_rtap_iface, store_rtap_iface);
 
 static ssize_t store_rtap_filter(struct device *d,
 			 struct device_attribute *attr,
@@ -1475,8 +1474,7 @@ static ssize_t show_rtap_filter(struct device *d,
 		       priv->prom_priv ? priv->prom_priv->filter : 0);
 }
 
-static DEVICE_ATTR(rtap_filter, S_IWUSR | S_IRUSR, show_rtap_filter,
-		   store_rtap_filter);
+static DEVICE_ATTR(rtap_filter, 0600, show_rtap_filter, store_rtap_filter);
 #endif
 
 static ssize_t show_scan_age(struct device *d, struct device_attribute *attr,
@@ -1520,7 +1518,7 @@ static ssize_t store_scan_age(struct device *d, struct device_attribute *attr,
 	return len;
 }
 
-static DEVICE_ATTR(scan_age, S_IWUSR | S_IRUGO, show_scan_age, store_scan_age);
+static DEVICE_ATTR(scan_age, 0644, show_scan_age, store_scan_age);
 
 static ssize_t show_led(struct device *d, struct device_attribute *attr,
 			char *buf)
@@ -1553,7 +1551,7 @@ static ssize_t store_led(struct device *d, struct device_attribute *attr,
 	return count;
 }
 
-static DEVICE_ATTR(led, S_IWUSR | S_IRUGO, show_led, store_led);
+static DEVICE_ATTR(led, 0644, show_led, store_led);
 
 static ssize_t show_status(struct device *d,
 			   struct device_attribute *attr, char *buf)
@@ -1562,7 +1560,7 @@ static ssize_t show_status(struct device *d,
 	return sprintf(buf, "0x%08x\n", (int)p->status);
 }
 
-static DEVICE_ATTR(status, S_IRUGO, show_status, NULL);
+static DEVICE_ATTR(status, 0444, show_status, NULL);
 
 static ssize_t show_cfg(struct device *d, struct device_attribute *attr,
 			char *buf)
@@ -1571,7 +1569,7 @@ static ssize_t show_cfg(struct device *d, struct device_attribute *attr,
 	return sprintf(buf, "0x%08x\n", (int)p->config);
 }
 
-static DEVICE_ATTR(cfg, S_IRUGO, show_cfg, NULL);
+static DEVICE_ATTR(cfg, 0444, show_cfg, NULL);
 
 static ssize_t show_nic_type(struct device *d,
 			     struct device_attribute *attr, char *buf)
@@ -1580,7 +1578,7 @@ static ssize_t show_nic_type(struct device *d,
 	return sprintf(buf, "TYPE: %d\n", priv->nic_type);
 }
 
-static DEVICE_ATTR(nic_type, S_IRUGO, show_nic_type, NULL);
+static DEVICE_ATTR(nic_type, 0444, show_nic_type, NULL);
 
 static ssize_t show_ucode_version(struct device *d,
 				  struct device_attribute *attr, char *buf)
@@ -1594,7 +1592,7 @@ static ssize_t show_ucode_version(struct device *d,
 	return sprintf(buf, "0x%08x\n", tmp);
 }
 
-static DEVICE_ATTR(ucode_version, S_IWUSR | S_IRUGO, show_ucode_version, NULL);
+static DEVICE_ATTR(ucode_version, 0644, show_ucode_version, NULL);
 
 static ssize_t show_rtc(struct device *d, struct device_attribute *attr,
 			char *buf)
@@ -1608,7 +1606,7 @@ static ssize_t show_rtc(struct device *d, struct device_attribute *attr,
 	return sprintf(buf, "0x%08x\n", tmp);
 }
 
-static DEVICE_ATTR(rtc, S_IWUSR | S_IRUGO, show_rtc, NULL);
+static DEVICE_ATTR(rtc, 0644, show_rtc, NULL);
 
 /*
  * Add a device attribute to view/control the delay between eeprom
@@ -1630,8 +1628,7 @@ static ssize_t store_eeprom_delay(struct device *d,
 	return strnlen(buf, count);
 }
 
-static DEVICE_ATTR(eeprom_delay, S_IWUSR | S_IRUGO,
-		   show_eeprom_delay, store_eeprom_delay);
+static DEVICE_ATTR(eeprom_delay, 0644, show_eeprom_delay, store_eeprom_delay);
 
 static ssize_t show_command_event_reg(struct device *d,
 				      struct device_attribute *attr, char *buf)
@@ -1654,7 +1651,7 @@ static ssize_t store_command_event_reg(struct device *d,
 	return strnlen(buf, count);
 }
 
-static DEVICE_ATTR(command_event_reg, S_IWUSR | S_IRUGO,
+static DEVICE_ATTR(command_event_reg, 0644,
 		   show_command_event_reg, store_command_event_reg);
 
 static ssize_t show_mem_gpio_reg(struct device *d,
@@ -1678,8 +1675,7 @@ static ssize_t store_mem_gpio_reg(struct device *d,
 	return strnlen(buf, count);
 }
 
-static DEVICE_ATTR(mem_gpio_reg, S_IWUSR | S_IRUGO,
-		   show_mem_gpio_reg, store_mem_gpio_reg);
+static DEVICE_ATTR(mem_gpio_reg, 0644, show_mem_gpio_reg, store_mem_gpio_reg);
 
 static ssize_t show_indirect_dword(struct device *d,
 				   struct device_attribute *attr, char *buf)
@@ -1705,7 +1701,7 @@ static ssize_t store_indirect_dword(struct device *d,
 	return strnlen(buf, count);
 }
 
-static DEVICE_ATTR(indirect_dword, S_IWUSR | S_IRUGO,
+static DEVICE_ATTR(indirect_dword, 0644,
 		   show_indirect_dword, store_indirect_dword);
 
 static ssize_t show_indirect_byte(struct device *d,
@@ -1732,7 +1728,7 @@ static ssize_t store_indirect_byte(struct device *d,
 	return strnlen(buf, count);
 }
 
-static DEVICE_ATTR(indirect_byte, S_IWUSR | S_IRUGO,
+static DEVICE_ATTR(indirect_byte, 0644,
 		   show_indirect_byte, store_indirect_byte);
 
 static ssize_t show_direct_dword(struct device *d,
@@ -1759,8 +1755,7 @@ static ssize_t store_direct_dword(struct device *d,
 	return strnlen(buf, count);
 }
 
-static DEVICE_ATTR(direct_dword, S_IWUSR | S_IRUGO,
-		   show_direct_dword, store_direct_dword);
+static DEVICE_ATTR(direct_dword, 0644, show_direct_dword, store_direct_dword);
 
 static int rf_kill_active(struct ipw_priv *priv)
 {
@@ -1831,7 +1826,7 @@ static ssize_t store_rf_kill(struct device *d, struct device_attribute *attr,
 	return count;
 }
 
-static DEVICE_ATTR(rf_kill, S_IWUSR | S_IRUGO, show_rf_kill, store_rf_kill);
+static DEVICE_ATTR(rf_kill, 0644, show_rf_kill, store_rf_kill);
 
 static ssize_t show_speed_scan(struct device *d, struct device_attribute *attr,
 			       char *buf)
@@ -1884,8 +1879,7 @@ static ssize_t store_speed_scan(struct device *d, struct device_attribute *attr,
 	return count;
 }
 
-static DEVICE_ATTR(speed_scan, S_IWUSR | S_IRUGO, show_speed_scan,
-		   store_speed_scan);
+static DEVICE_ATTR(speed_scan, 0644, show_speed_scan, store_speed_scan);
 
 static ssize_t show_net_stats(struct device *d, struct device_attribute *attr,
 			      char *buf)
@@ -1906,8 +1900,7 @@ static ssize_t store_net_stats(struct device *d, struct device_attribute *attr,
 	return count;
 }
 
-static DEVICE_ATTR(net_stats, S_IWUSR | S_IRUGO,
-		   show_net_stats, store_net_stats);
+static DEVICE_ATTR(net_stats, 0644, show_net_stats, store_net_stats);
 
 static ssize_t show_channels(struct device *d,
 			     struct device_attribute *attr,
@@ -1953,7 +1946,7 @@ static ssize_t show_channels(struct device *d,
 	return len;
 }
 
-static DEVICE_ATTR(channels, S_IRUSR, show_channels, NULL);
+static DEVICE_ATTR(channels, 0400, show_channels, NULL);
 
 static void notify_wx_assoc_event(struct ipw_priv *priv)
 {
diff --git a/drivers/net/wireless/intel/ipw2x00/libipw_module.c b/drivers/net/wireless/intel/ipw2x00/libipw_module.c
index c58c5b2dcce5..f00d45f54c76 100644
--- a/drivers/net/wireless/intel/ipw2x00/libipw_module.c
+++ b/drivers/net/wireless/intel/ipw2x00/libipw_module.c
@@ -276,7 +276,7 @@ static int __init libipw_init(void)
 				" proc directory\n");
 		return -EIO;
 	}
-	e = proc_create("debug_level", S_IRUGO | S_IWUSR, libipw_proc,
+	e = proc_create("debug_level", 0644, libipw_proc,
 			&debug_level_proc_fops);
 	if (!e) {
 		remove_proc_entry(DRV_PROCNAME, init_net.proc_net);
diff --git a/drivers/net/wireless/intel/iwlegacy/3945-mac.c b/drivers/net/wireless/intel/iwlegacy/3945-mac.c
index 4b53ebf00c7f..62a9794f952b 100644
--- a/drivers/net/wireless/intel/iwlegacy/3945-mac.c
+++ b/drivers/net/wireless/intel/iwlegacy/3945-mac.c
@@ -3122,7 +3122,7 @@ il3945_store_debug_level(struct device *d, struct device_attribute *attr,
 	return strnlen(buf, count);
 }
 
-static DEVICE_ATTR(debug_level, S_IWUSR | S_IRUGO, il3945_show_debug_level,
+static DEVICE_ATTR(debug_level, 0644, il3945_show_debug_level,
 		   il3945_store_debug_level);
 
 #endif /* CONFIG_IWLEGACY_DEBUG */
@@ -3139,7 +3139,7 @@ il3945_show_temperature(struct device *d, struct device_attribute *attr,
 	return sprintf(buf, "%d\n", il3945_hw_get_temperature(il));
 }
 
-static DEVICE_ATTR(temperature, S_IRUGO, il3945_show_temperature, NULL);
+static DEVICE_ATTR(temperature, 0444, il3945_show_temperature, NULL);
 
 static ssize_t
 il3945_show_tx_power(struct device *d, struct device_attribute *attr, char *buf)
@@ -3165,8 +3165,7 @@ il3945_store_tx_power(struct device *d, struct device_attribute *attr,
 	return count;
 }
 
-static DEVICE_ATTR(tx_power, S_IWUSR | S_IRUGO, il3945_show_tx_power,
-		   il3945_store_tx_power);
+static DEVICE_ATTR(tx_power, 0644, il3945_show_tx_power, il3945_store_tx_power);
 
 static ssize_t
 il3945_show_flags(struct device *d, struct device_attribute *attr, char *buf)
@@ -3199,8 +3198,7 @@ il3945_store_flags(struct device *d, struct device_attribute *attr,
 	return count;
 }
 
-static DEVICE_ATTR(flags, S_IWUSR | S_IRUGO, il3945_show_flags,
-		   il3945_store_flags);
+static DEVICE_ATTR(flags, 0644, il3945_show_flags, il3945_store_flags);
 
 static ssize_t
 il3945_show_filter_flags(struct device *d, struct device_attribute *attr,
@@ -3235,7 +3233,7 @@ il3945_store_filter_flags(struct device *d, struct device_attribute *attr,
 	return count;
 }
 
-static DEVICE_ATTR(filter_flags, S_IWUSR | S_IRUGO, il3945_show_filter_flags,
+static DEVICE_ATTR(filter_flags, 0644, il3945_show_filter_flags,
 		   il3945_store_filter_flags);
 
 static ssize_t
@@ -3306,7 +3304,7 @@ il3945_store_measurement(struct device *d, struct device_attribute *attr,
 	return count;
 }
 
-static DEVICE_ATTR(measurement, S_IRUSR | S_IWUSR, il3945_show_measurement,
+static DEVICE_ATTR(measurement, 0600, il3945_show_measurement,
 		   il3945_store_measurement);
 
 static ssize_t
@@ -3330,7 +3328,7 @@ il3945_show_retry_rate(struct device *d, struct device_attribute *attr,
 	return sprintf(buf, "%d", il->retry_rate);
 }
 
-static DEVICE_ATTR(retry_rate, S_IWUSR | S_IRUSR, il3945_show_retry_rate,
+static DEVICE_ATTR(retry_rate, 0600, il3945_show_retry_rate,
 		   il3945_store_retry_rate);
 
 static ssize_t
@@ -3340,7 +3338,7 @@ il3945_show_channels(struct device *d, struct device_attribute *attr, char *buf)
 	return 0;
 }
 
-static DEVICE_ATTR(channels, S_IRUSR, il3945_show_channels, NULL);
+static DEVICE_ATTR(channels, 0400, il3945_show_channels, NULL);
 
 static ssize_t
 il3945_show_antenna(struct device *d, struct device_attribute *attr, char *buf)
@@ -3377,8 +3375,7 @@ il3945_store_antenna(struct device *d, struct device_attribute *attr,
 	return count;
 }
 
-static DEVICE_ATTR(antenna, S_IWUSR | S_IRUGO, il3945_show_antenna,
-		   il3945_store_antenna);
+static DEVICE_ATTR(antenna, 0644, il3945_show_antenna, il3945_store_antenna);
 
 static ssize_t
 il3945_show_status(struct device *d, struct device_attribute *attr, char *buf)
@@ -3389,7 +3386,7 @@ il3945_show_status(struct device *d, struct device_attribute *attr, char *buf)
 	return sprintf(buf, "0x%08x\n", (int)il->status);
 }
 
-static DEVICE_ATTR(status, S_IRUGO, il3945_show_status, NULL);
+static DEVICE_ATTR(status, 0444, il3945_show_status, NULL);
 
 static ssize_t
 il3945_dump_error_log(struct device *d, struct device_attribute *attr,
@@ -3404,7 +3401,7 @@ il3945_dump_error_log(struct device *d, struct device_attribute *attr,
 	return strnlen(buf, count);
 }
 
-static DEVICE_ATTR(dump_errors, S_IWUSR, NULL, il3945_dump_error_log);
+static DEVICE_ATTR(dump_errors, 0200, NULL, il3945_dump_error_log);
 
 /*****************************************************************************
  *
@@ -3943,18 +3940,18 @@ il3945_exit(void)
 
 MODULE_FIRMWARE(IL3945_MODULE_FIRMWARE(IL3945_UCODE_API_MAX));
 
-module_param_named(antenna, il3945_mod_params.antenna, int, S_IRUGO);
+module_param_named(antenna, il3945_mod_params.antenna, int, 0444);
 MODULE_PARM_DESC(antenna, "select antenna (1=Main, 2=Aux, default 0 [both])");
-module_param_named(swcrypto, il3945_mod_params.sw_crypto, int, S_IRUGO);
+module_param_named(swcrypto, il3945_mod_params.sw_crypto, int, 0444);
 MODULE_PARM_DESC(swcrypto, "using software crypto (default 1 [software])");
 module_param_named(disable_hw_scan, il3945_mod_params.disable_hw_scan, int,
-		   S_IRUGO);
+		   0444);
 MODULE_PARM_DESC(disable_hw_scan, "disable hardware scanning (default 1)");
 #ifdef CONFIG_IWLEGACY_DEBUG
-module_param_named(debug, il_debug_level, uint, S_IRUGO | S_IWUSR);
+module_param_named(debug, il_debug_level, uint, 0644);
 MODULE_PARM_DESC(debug, "debug output mask");
 #endif
-module_param_named(fw_restart, il3945_mod_params.restart_fw, int, S_IRUGO);
+module_param_named(fw_restart, il3945_mod_params.restart_fw, int, 0444);
 MODULE_PARM_DESC(fw_restart, "restart firmware in case of error");
 
 module_exit(il3945_exit);
diff --git a/drivers/net/wireless/intel/iwlegacy/4965-mac.c b/drivers/net/wireless/intel/iwlegacy/4965-mac.c
index de63f2518f23..562e94870a9c 100644
--- a/drivers/net/wireless/intel/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/intel/iwlegacy/4965-mac.c
@@ -4591,7 +4591,7 @@ il4965_store_debug_level(struct device *d, struct device_attribute *attr,
 	return strnlen(buf, count);
 }
 
-static DEVICE_ATTR(debug_level, S_IWUSR | S_IRUGO, il4965_show_debug_level,
+static DEVICE_ATTR(debug_level, 0644, il4965_show_debug_level,
 		   il4965_store_debug_level);
 
 #endif /* CONFIG_IWLEGACY_DEBUG */
@@ -4608,7 +4608,7 @@ il4965_show_temperature(struct device *d, struct device_attribute *attr,
 	return sprintf(buf, "%d\n", il->temperature);
 }
 
-static DEVICE_ATTR(temperature, S_IRUGO, il4965_show_temperature, NULL);
+static DEVICE_ATTR(temperature, 0444, il4965_show_temperature, NULL);
 
 static ssize_t
 il4965_show_tx_power(struct device *d, struct device_attribute *attr, char *buf)
@@ -4642,7 +4642,7 @@ il4965_store_tx_power(struct device *d, struct device_attribute *attr,
 	return ret;
 }
 
-static DEVICE_ATTR(tx_power, S_IWUSR | S_IRUGO, il4965_show_tx_power,
+static DEVICE_ATTR(tx_power, 0644, il4965_show_tx_power,
 		   il4965_store_tx_power);
 
 static struct attribute *il_sysfs_entries[] = {
@@ -6859,18 +6859,17 @@ module_exit(il4965_exit);
 module_init(il4965_init);
 
 #ifdef CONFIG_IWLEGACY_DEBUG
-module_param_named(debug, il_debug_level, uint, S_IRUGO | S_IWUSR);
+module_param_named(debug, il_debug_level, uint, 0644);
 MODULE_PARM_DESC(debug, "debug output mask");
 #endif
 
-module_param_named(swcrypto, il4965_mod_params.sw_crypto, int, S_IRUGO);
+module_param_named(swcrypto, il4965_mod_params.sw_crypto, int, 0444);
 MODULE_PARM_DESC(swcrypto, "using crypto in software (default 0 [hardware])");
-module_param_named(queues_num, il4965_mod_params.num_of_queues, int, S_IRUGO);
+module_param_named(queues_num, il4965_mod_params.num_of_queues, int, 0444);
 MODULE_PARM_DESC(queues_num, "number of hw queues.");
-module_param_named(11n_disable, il4965_mod_params.disable_11n, int, S_IRUGO);
+module_param_named(11n_disable, il4965_mod_params.disable_11n, int, 0444);
 MODULE_PARM_DESC(11n_disable, "disable 11n functionality");
-module_param_named(amsdu_size_8K, il4965_mod_params.amsdu_size_8K, int,
-		   S_IRUGO);
+module_param_named(amsdu_size_8K, il4965_mod_params.amsdu_size_8K, int, 0444);
 MODULE_PARM_DESC(amsdu_size_8K, "enable 8K amsdu size (default 0 [disabled])");
-module_param_named(fw_restart, il4965_mod_params.restart_fw, int, S_IRUGO);
+module_param_named(fw_restart, il4965_mod_params.restart_fw, int, 0444);
 MODULE_PARM_DESC(fw_restart, "restart firmware in case of error");
diff --git a/drivers/net/wireless/intel/iwlegacy/4965-rs.c b/drivers/net/wireless/intel/iwlegacy/4965-rs.c
index 365a4187fc37..54ff83829afb 100644
--- a/drivers/net/wireless/intel/iwlegacy/4965-rs.c
+++ b/drivers/net/wireless/intel/iwlegacy/4965-rs.c
@@ -2768,16 +2768,16 @@ il4965_rs_add_debugfs(void *il, void *il_sta, struct dentry *dir)
 {
 	struct il_lq_sta *lq_sta = il_sta;
 	lq_sta->rs_sta_dbgfs_scale_table_file =
-	    debugfs_create_file("rate_scale_table", S_IRUSR | S_IWUSR, dir,
+	    debugfs_create_file("rate_scale_table", 0600, dir,
 				lq_sta, &rs_sta_dbgfs_scale_table_ops);
 	lq_sta->rs_sta_dbgfs_stats_table_file =
-	    debugfs_create_file("rate_stats_table", S_IRUSR, dir, lq_sta,
+	    debugfs_create_file("rate_stats_table", 0400, dir, lq_sta,
 				&rs_sta_dbgfs_stats_table_ops);
 	lq_sta->rs_sta_dbgfs_rate_scale_data_file =
-	    debugfs_create_file("rate_scale_data", S_IRUSR, dir, lq_sta,
+	    debugfs_create_file("rate_scale_data", 0400, dir, lq_sta,
 				&rs_sta_dbgfs_rate_scale_data_ops);
 	lq_sta->rs_sta_dbgfs_tx_agg_tid_en_file =
-	    debugfs_create_u8("tx_agg_tid_enable", S_IRUSR | S_IWUSR, dir,
+	    debugfs_create_u8("tx_agg_tid_enable", 0600, dir,
 			      &lq_sta->tx_agg_tid_en);
 
 }
diff --git a/drivers/net/wireless/intel/iwlegacy/common.c b/drivers/net/wireless/intel/iwlegacy/common.c
index 558bb16bfd46..063e19ced7c8 100644
--- a/drivers/net/wireless/intel/iwlegacy/common.c
+++ b/drivers/net/wireless/intel/iwlegacy/common.c
@@ -435,7 +435,7 @@ EXPORT_SYMBOL(il_send_cmd_pdu_async);
 
 /* default: IL_LED_BLINK(0) using blinking idx table */
 static int led_mode;
-module_param(led_mode, int, S_IRUGO);
+module_param(led_mode, int, 0444);
 MODULE_PARM_DESC(led_mode,
 		 "0=system default, " "1=On(RF On)/Off(RF Off), 2=blinking");
 
@@ -3372,7 +3372,7 @@ MODULE_LICENSE("GPL");
  * default: bt_coex_active = true (BT_COEX_ENABLE)
  */
 static bool bt_coex_active = true;
-module_param(bt_coex_active, bool, S_IRUGO);
+module_param(bt_coex_active, bool, 0444);
 MODULE_PARM_DESC(bt_coex_active, "enable wifi/bluetooth co-exist");
 
 u32 il_debug_level;
diff --git a/drivers/net/wireless/intel/iwlegacy/debug.c b/drivers/net/wireless/intel/iwlegacy/debug.c
index 6fc6b7ff9849..d76073def677 100644
--- a/drivers/net/wireless/intel/iwlegacy/debug.c
+++ b/drivers/net/wireless/intel/iwlegacy/debug.c
@@ -135,16 +135,14 @@ EXPORT_SYMBOL(il_update_stats);
 
 #define DEBUGFS_ADD_BOOL(name, parent, ptr) do {			\
 	struct dentry *__tmp;						\
-	__tmp = debugfs_create_bool(#name, S_IWUSR | S_IRUSR,		\
-				    parent, ptr);			\
+	__tmp = debugfs_create_bool(#name, 0600, parent, ptr);		\
 	if (IS_ERR(__tmp) || !__tmp)					\
 		goto err;						\
 } while (0)
 
 #define DEBUGFS_ADD_X32(name, parent, ptr) do {				\
 	struct dentry *__tmp;						\
-	__tmp = debugfs_create_x32(#name, S_IWUSR | S_IRUSR,		\
-				   parent, ptr);			\
+	__tmp = debugfs_create_x32(#name, 0600, parent, ptr);		\
 	if (IS_ERR(__tmp) || !__tmp)					\
 		goto err;						\
 } while (0)
@@ -1365,35 +1363,35 @@ il_dbgfs_register(struct il_priv *il, const char *name)
 	if (!dir_debug)
 		goto err;
 
-	DEBUGFS_ADD_FILE(nvm, dir_data, S_IRUSR);
-	DEBUGFS_ADD_FILE(sram, dir_data, S_IWUSR | S_IRUSR);
-	DEBUGFS_ADD_FILE(stations, dir_data, S_IRUSR);
-	DEBUGFS_ADD_FILE(channels, dir_data, S_IRUSR);
-	DEBUGFS_ADD_FILE(status, dir_data, S_IRUSR);
-	DEBUGFS_ADD_FILE(interrupt, dir_data, S_IWUSR | S_IRUSR);
-	DEBUGFS_ADD_FILE(qos, dir_data, S_IRUSR);
-	DEBUGFS_ADD_FILE(disable_ht40, dir_data, S_IWUSR | S_IRUSR);
-	DEBUGFS_ADD_FILE(rx_stats, dir_debug, S_IRUSR);
-	DEBUGFS_ADD_FILE(tx_stats, dir_debug, S_IRUSR);
-	DEBUGFS_ADD_FILE(rx_queue, dir_debug, S_IRUSR);
-	DEBUGFS_ADD_FILE(tx_queue, dir_debug, S_IRUSR);
-	DEBUGFS_ADD_FILE(power_save_status, dir_debug, S_IRUSR);
-	DEBUGFS_ADD_FILE(clear_ucode_stats, dir_debug, S_IWUSR);
-	DEBUGFS_ADD_FILE(clear_traffic_stats, dir_debug, S_IWUSR);
-	DEBUGFS_ADD_FILE(fh_reg, dir_debug, S_IRUSR);
-	DEBUGFS_ADD_FILE(missed_beacon, dir_debug, S_IWUSR);
-	DEBUGFS_ADD_FILE(force_reset, dir_debug, S_IWUSR | S_IRUSR);
-	DEBUGFS_ADD_FILE(ucode_rx_stats, dir_debug, S_IRUSR);
-	DEBUGFS_ADD_FILE(ucode_tx_stats, dir_debug, S_IRUSR);
-	DEBUGFS_ADD_FILE(ucode_general_stats, dir_debug, S_IRUSR);
+	DEBUGFS_ADD_FILE(nvm, dir_data, 0400);
+	DEBUGFS_ADD_FILE(sram, dir_data, 0600);
+	DEBUGFS_ADD_FILE(stations, dir_data, 0400);
+	DEBUGFS_ADD_FILE(channels, dir_data, 0400);
+	DEBUGFS_ADD_FILE(status, dir_data, 0400);
+	DEBUGFS_ADD_FILE(interrupt, dir_data, 0600);
+	DEBUGFS_ADD_FILE(qos, dir_data, 0400);
+	DEBUGFS_ADD_FILE(disable_ht40, dir_data, 0600);
+	DEBUGFS_ADD_FILE(rx_stats, dir_debug, 0400);
+	DEBUGFS_ADD_FILE(tx_stats, dir_debug, 0400);
+	DEBUGFS_ADD_FILE(rx_queue, dir_debug, 0400);
+	DEBUGFS_ADD_FILE(tx_queue, dir_debug, 0400);
+	DEBUGFS_ADD_FILE(power_save_status, dir_debug, 0400);
+	DEBUGFS_ADD_FILE(clear_ucode_stats, dir_debug, 0200);
+	DEBUGFS_ADD_FILE(clear_traffic_stats, dir_debug, 0200);
+	DEBUGFS_ADD_FILE(fh_reg, dir_debug, 0400);
+	DEBUGFS_ADD_FILE(missed_beacon, dir_debug, 0200);
+	DEBUGFS_ADD_FILE(force_reset, dir_debug, 0600);
+	DEBUGFS_ADD_FILE(ucode_rx_stats, dir_debug, 0400);
+	DEBUGFS_ADD_FILE(ucode_tx_stats, dir_debug, 0400);
+	DEBUGFS_ADD_FILE(ucode_general_stats, dir_debug, 0400);
 
 	if (il->cfg->sensitivity_calib_by_driver)
-		DEBUGFS_ADD_FILE(sensitivity, dir_debug, S_IRUSR);
+		DEBUGFS_ADD_FILE(sensitivity, dir_debug, 0400);
 	if (il->cfg->chain_noise_calib_by_driver)
-		DEBUGFS_ADD_FILE(chain_noise, dir_debug, S_IRUSR);
-	DEBUGFS_ADD_FILE(rxon_flags, dir_debug, S_IWUSR);
-	DEBUGFS_ADD_FILE(rxon_filter_flags, dir_debug, S_IWUSR);
-	DEBUGFS_ADD_FILE(wd_timeout, dir_debug, S_IWUSR);
+		DEBUGFS_ADD_FILE(chain_noise, dir_debug, 0400);
+	DEBUGFS_ADD_FILE(rxon_flags, dir_debug, 0200);
+	DEBUGFS_ADD_FILE(rxon_filter_flags, dir_debug, 0200);
+	DEBUGFS_ADD_FILE(wd_timeout, dir_debug, 0200);
 	if (il->cfg->sensitivity_calib_by_driver)
 		DEBUGFS_ADD_BOOL(disable_sensitivity, dir_rf,
 				 &il->disable_sens_cal);
diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/debugfs.c b/drivers/net/wireless/intel/iwlwifi/dvm/debugfs.c
index 482ac8fdc67b..096a07c5a33f 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/debugfs.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/debugfs.c
@@ -48,16 +48,14 @@
 
 #define DEBUGFS_ADD_BOOL(name, parent, ptr) do {			\
 	struct dentry *__tmp;						\
-	__tmp = debugfs_create_bool(#name, S_IWUSR | S_IRUSR,		\
-				    parent, ptr);			\
+	__tmp = debugfs_create_bool(#name, 0600, parent, ptr);		\
 	if (IS_ERR(__tmp) || !__tmp)					\
 		goto err;						\
 } while (0)
 
 #define DEBUGFS_ADD_X32(name, parent, ptr) do {				\
 	struct dentry *__tmp;						\
-	__tmp = debugfs_create_x32(#name, S_IWUSR | S_IRUSR,		\
-				   parent, ptr);			\
+	__tmp = debugfs_create_x32(#name, 0600, parent, ptr);		\
 	if (IS_ERR(__tmp) || !__tmp)					\
 		goto err;						\
 } while (0)
@@ -2370,48 +2368,48 @@ int iwl_dbgfs_register(struct iwl_priv *priv, struct dentry *dbgfs_dir)
 	if (!dir_debug)
 		goto err;
 
-	DEBUGFS_ADD_FILE(nvm, dir_data, S_IRUSR);
-	DEBUGFS_ADD_FILE(sram, dir_data, S_IWUSR | S_IRUSR);
-	DEBUGFS_ADD_FILE(wowlan_sram, dir_data, S_IRUSR);
-	DEBUGFS_ADD_FILE(stations, dir_data, S_IRUSR);
-	DEBUGFS_ADD_FILE(channels, dir_data, S_IRUSR);
-	DEBUGFS_ADD_FILE(status, dir_data, S_IRUSR);
-	DEBUGFS_ADD_FILE(rx_handlers, dir_data, S_IWUSR | S_IRUSR);
-	DEBUGFS_ADD_FILE(qos, dir_data, S_IRUSR);
-	DEBUGFS_ADD_FILE(sleep_level_override, dir_data, S_IWUSR | S_IRUSR);
-	DEBUGFS_ADD_FILE(current_sleep_command, dir_data, S_IRUSR);
-	DEBUGFS_ADD_FILE(thermal_throttling, dir_data, S_IRUSR);
-	DEBUGFS_ADD_FILE(disable_ht40, dir_data, S_IWUSR | S_IRUSR);
-	DEBUGFS_ADD_FILE(temperature, dir_data, S_IRUSR);
-
-	DEBUGFS_ADD_FILE(power_save_status, dir_debug, S_IRUSR);
-	DEBUGFS_ADD_FILE(clear_ucode_statistics, dir_debug, S_IWUSR);
-	DEBUGFS_ADD_FILE(missed_beacon, dir_debug, S_IWUSR);
-	DEBUGFS_ADD_FILE(plcp_delta, dir_debug, S_IWUSR | S_IRUSR);
-	DEBUGFS_ADD_FILE(rf_reset, dir_debug, S_IWUSR | S_IRUSR);
-	DEBUGFS_ADD_FILE(ucode_rx_stats, dir_debug, S_IRUSR);
-	DEBUGFS_ADD_FILE(ucode_tx_stats, dir_debug, S_IRUSR);
-	DEBUGFS_ADD_FILE(ucode_general_stats, dir_debug, S_IRUSR);
-	DEBUGFS_ADD_FILE(txfifo_flush, dir_debug, S_IWUSR);
-	DEBUGFS_ADD_FILE(protection_mode, dir_debug, S_IWUSR | S_IRUSR);
-	DEBUGFS_ADD_FILE(sensitivity, dir_debug, S_IRUSR);
-	DEBUGFS_ADD_FILE(chain_noise, dir_debug, S_IRUSR);
-	DEBUGFS_ADD_FILE(ucode_tracing, dir_debug, S_IWUSR | S_IRUSR);
-	DEBUGFS_ADD_FILE(ucode_bt_stats, dir_debug, S_IRUSR);
-	DEBUGFS_ADD_FILE(reply_tx_error, dir_debug, S_IRUSR);
-	DEBUGFS_ADD_FILE(rxon_flags, dir_debug, S_IWUSR);
-	DEBUGFS_ADD_FILE(rxon_filter_flags, dir_debug, S_IWUSR);
-	DEBUGFS_ADD_FILE(echo_test, dir_debug, S_IWUSR);
-	DEBUGFS_ADD_FILE(fw_restart, dir_debug, S_IWUSR);
+	DEBUGFS_ADD_FILE(nvm, dir_data, 0400);
+	DEBUGFS_ADD_FILE(sram, dir_data, 0600);
+	DEBUGFS_ADD_FILE(wowlan_sram, dir_data, 0400);
+	DEBUGFS_ADD_FILE(stations, dir_data, 0400);
+	DEBUGFS_ADD_FILE(channels, dir_data, 0400);
+	DEBUGFS_ADD_FILE(status, dir_data, 0400);
+	DEBUGFS_ADD_FILE(rx_handlers, dir_data, 0600);
+	DEBUGFS_ADD_FILE(qos, dir_data, 0400);
+	DEBUGFS_ADD_FILE(sleep_level_override, dir_data, 0600);
+	DEBUGFS_ADD_FILE(current_sleep_command, dir_data, 0400);
+	DEBUGFS_ADD_FILE(thermal_throttling, dir_data, 0400);
+	DEBUGFS_ADD_FILE(disable_ht40, dir_data, 0600);
+	DEBUGFS_ADD_FILE(temperature, dir_data, 0400);
+
+	DEBUGFS_ADD_FILE(power_save_status, dir_debug, 0400);
+	DEBUGFS_ADD_FILE(clear_ucode_statistics, dir_debug, 0200);
+	DEBUGFS_ADD_FILE(missed_beacon, dir_debug, 0200);
+	DEBUGFS_ADD_FILE(plcp_delta, dir_debug, 0600);
+	DEBUGFS_ADD_FILE(rf_reset, dir_debug, 0600);
+	DEBUGFS_ADD_FILE(ucode_rx_stats, dir_debug, 0400);
+	DEBUGFS_ADD_FILE(ucode_tx_stats, dir_debug, 0400);
+	DEBUGFS_ADD_FILE(ucode_general_stats, dir_debug, 0400);
+	DEBUGFS_ADD_FILE(txfifo_flush, dir_debug, 0200);
+	DEBUGFS_ADD_FILE(protection_mode, dir_debug, 0600);
+	DEBUGFS_ADD_FILE(sensitivity, dir_debug, 0400);
+	DEBUGFS_ADD_FILE(chain_noise, dir_debug, 0400);
+	DEBUGFS_ADD_FILE(ucode_tracing, dir_debug, 0600);
+	DEBUGFS_ADD_FILE(ucode_bt_stats, dir_debug, 0400);
+	DEBUGFS_ADD_FILE(reply_tx_error, dir_debug, 0400);
+	DEBUGFS_ADD_FILE(rxon_flags, dir_debug, 0200);
+	DEBUGFS_ADD_FILE(rxon_filter_flags, dir_debug, 0200);
+	DEBUGFS_ADD_FILE(echo_test, dir_debug, 0200);
+	DEBUGFS_ADD_FILE(fw_restart, dir_debug, 0200);
 #ifdef CONFIG_IWLWIFI_DEBUG
-	DEBUGFS_ADD_FILE(log_event, dir_debug, S_IWUSR | S_IRUSR);
+	DEBUGFS_ADD_FILE(log_event, dir_debug, 0600);
 #endif
 
 	if (iwl_advanced_bt_coexist(priv))
-		DEBUGFS_ADD_FILE(bt_traffic, dir_debug, S_IRUSR);
+		DEBUGFS_ADD_FILE(bt_traffic, dir_debug, 0400);
 
 	/* Calibrations disabled/enabled status*/
-	DEBUGFS_ADD_FILE(calib_disabled, dir_rf, S_IWUSR | S_IRUSR);
+	DEBUGFS_ADD_FILE(calib_disabled, dir_rf, 0600);
 
 	/*
 	 * Create a symlink with mac80211. This is not very robust, as it does
diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/rs.c b/drivers/net/wireless/intel/iwlwifi/dvm/rs.c
index ddcd8c2d66cd..98050d7be411 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/rs.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/rs.c
@@ -3276,17 +3276,17 @@ static void rs_add_debugfs(void *priv, void *priv_sta,
 {
 	struct iwl_lq_sta *lq_sta = priv_sta;
 	lq_sta->rs_sta_dbgfs_scale_table_file =
-		debugfs_create_file("rate_scale_table", S_IRUSR | S_IWUSR, dir,
-				lq_sta, &rs_sta_dbgfs_scale_table_ops);
+		debugfs_create_file("rate_scale_table", 0600, dir,
+				    lq_sta, &rs_sta_dbgfs_scale_table_ops);
 	lq_sta->rs_sta_dbgfs_stats_table_file =
-		debugfs_create_file("rate_stats_table", S_IRUSR, dir,
-			lq_sta, &rs_sta_dbgfs_stats_table_ops);
+		debugfs_create_file("rate_stats_table", 0400, dir,
+				    lq_sta, &rs_sta_dbgfs_stats_table_ops);
 	lq_sta->rs_sta_dbgfs_rate_scale_data_file =
-		debugfs_create_file("rate_scale_data", S_IRUSR, dir,
-			lq_sta, &rs_sta_dbgfs_rate_scale_data_ops);
+		debugfs_create_file("rate_scale_data", 0400, dir,
+				    lq_sta, &rs_sta_dbgfs_rate_scale_data_ops);
 	lq_sta->rs_sta_dbgfs_tx_agg_tid_en_file =
-		debugfs_create_u8("tx_agg_tid_enable", S_IRUSR | S_IWUSR, dir,
-		&lq_sta->tx_agg_tid_en);
+		debugfs_create_u8("tx_agg_tid_enable", 0600, dir,
+				  &lq_sta->tx_agg_tid_en);
 
 }
 
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/debugfs.c b/drivers/net/wireless/intel/iwlwifi/fw/debugfs.c
index e2ded29a145d..baec2fbaaf68 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/debugfs.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/debugfs.c
@@ -187,7 +187,7 @@ int iwl_fwrt_dbgfs_register(struct iwl_fw_runtime *fwrt,
 			    struct dentry *dbgfs_dir)
 {
 	INIT_DELAYED_WORK(&fwrt->timestamp.wk, iwl_fw_timestamp_marker_wk);
-	FWRT_DEBUGFS_ADD_FILE(timestamp_marker, dbgfs_dir, S_IWUSR);
+	FWRT_DEBUGFS_ADD_FILE(timestamp_marker, dbgfs_dir, 0200);
 	return 0;
 err:
 	IWL_ERR(fwrt, "Can't create the fwrt debugfs directory\n");
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
index 9c4a7f648a44..aa2d5c14e202 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -1768,41 +1768,36 @@ static void __exit iwl_drv_exit(void)
 module_exit(iwl_drv_exit);
 
 #ifdef CONFIG_IWLWIFI_DEBUG
-module_param_named(debug, iwlwifi_mod_params.debug_level, uint,
-		   S_IRUGO | S_IWUSR);
+module_param_named(debug, iwlwifi_mod_params.debug_level, uint, 0644);
 MODULE_PARM_DESC(debug, "debug output mask");
 #endif
 
-module_param_named(swcrypto, iwlwifi_mod_params.swcrypto, int, S_IRUGO);
+module_param_named(swcrypto, iwlwifi_mod_params.swcrypto, int, 0444);
 MODULE_PARM_DESC(swcrypto, "using crypto in software (default 0 [hardware])");
-module_param_named(11n_disable, iwlwifi_mod_params.disable_11n, uint, S_IRUGO);
+module_param_named(11n_disable, iwlwifi_mod_params.disable_11n, uint, 0444);
 MODULE_PARM_DESC(11n_disable,
 	"disable 11n functionality, bitmap: 1: full, 2: disable agg TX, 4: disable agg RX, 8 enable agg TX");
-module_param_named(amsdu_size, iwlwifi_mod_params.amsdu_size,
-		   int, S_IRUGO);
+module_param_named(amsdu_size, iwlwifi_mod_params.amsdu_size, int, 0444);
 MODULE_PARM_DESC(amsdu_size,
 		 "amsdu size 0: 12K for multi Rx queue devices, 4K for other devices 1:4K 2:8K 3:12K (default 0)");
-module_param_named(fw_restart, iwlwifi_mod_params.fw_restart, bool, S_IRUGO);
+module_param_named(fw_restart, iwlwifi_mod_params.fw_restart, bool, 0444);
 MODULE_PARM_DESC(fw_restart, "restart firmware in case of error (default true)");
 
 module_param_named(antenna_coupling, iwlwifi_mod_params.antenna_coupling,
-		   int, S_IRUGO);
+		   int, 0444);
 MODULE_PARM_DESC(antenna_coupling,
 		 "specify antenna coupling in dB (default: 0 dB)");
 
-module_param_named(nvm_file, iwlwifi_mod_params.nvm_file, charp, S_IRUGO);
+module_param_named(nvm_file, iwlwifi_mod_params.nvm_file, charp, 0444);
 MODULE_PARM_DESC(nvm_file, "NVM file name");
 
-module_param_named(d0i3_disable, iwlwifi_mod_params.d0i3_disable,
-		   bool, S_IRUGO);
+module_param_named(d0i3_disable, iwlwifi_mod_params.d0i3_disable, bool, 0444);
 MODULE_PARM_DESC(d0i3_disable, "disable d0i3 functionality (default: Y)");
 
-module_param_named(lar_disable, iwlwifi_mod_params.lar_disable,
-		   bool, S_IRUGO);
+module_param_named(lar_disable, iwlwifi_mod_params.lar_disable, bool, 0444);
 MODULE_PARM_DESC(lar_disable, "disable LAR functionality (default: N)");
 
-module_param_named(uapsd_disable, iwlwifi_mod_params.uapsd_disable,
-		   uint, S_IRUGO | S_IWUSR);
+module_param_named(uapsd_disable, iwlwifi_mod_params.uapsd_disable, uint, 0644);
 MODULE_PARM_DESC(uapsd_disable,
 		 "disable U-APSD functionality bitmap 1: BSS 2: P2P Client (default: 3)");
 
@@ -1823,31 +1818,27 @@ MODULE_PARM_DESC(uapsd_disable,
  * default: bt_coex_active = true (BT_COEX_ENABLE)
  */
 module_param_named(bt_coex_active, iwlwifi_mod_params.bt_coex_active,
-		bool, S_IRUGO);
+		   bool, 0444);
 MODULE_PARM_DESC(bt_coex_active, "enable wifi/bt co-exist (default: enable)");
 
-module_param_named(led_mode, iwlwifi_mod_params.led_mode, int, S_IRUGO);
+module_param_named(led_mode, iwlwifi_mod_params.led_mode, int, 0444);
 MODULE_PARM_DESC(led_mode, "0=system default, "
 		"1=On(RF On)/Off(RF Off), 2=blinking, 3=Off (default: 0)");
 
-module_param_named(power_save, iwlwifi_mod_params.power_save,
-		bool, S_IRUGO);
+module_param_named(power_save, iwlwifi_mod_params.power_save, bool, 0444);
 MODULE_PARM_DESC(power_save,
 		 "enable WiFi power management (default: disable)");
 
-module_param_named(power_level, iwlwifi_mod_params.power_level,
-		int, S_IRUGO);
+module_param_named(power_level, iwlwifi_mod_params.power_level, int, 0444);
 MODULE_PARM_DESC(power_level,
 		 "default power save level (range from 1 - 5, default: 1)");
 
-module_param_named(fw_monitor, iwlwifi_mod_params.fw_monitor, bool, S_IRUGO);
+module_param_named(fw_monitor, iwlwifi_mod_params.fw_monitor, bool, 0444);
 MODULE_PARM_DESC(fw_monitor,
 		 "firmware monitor - to debug FW (default: false - needs lots of memory)");
 
-module_param_named(d0i3_timeout, iwlwifi_mod_params.d0i3_timeout,
-		   uint, S_IRUGO);
+module_param_named(d0i3_timeout, iwlwifi_mod_params.d0i3_timeout, uint, 0444);
 MODULE_PARM_DESC(d0i3_timeout, "Timeout to D0i3 entry when idle (ms)");
 
-module_param_named(disable_11ac, iwlwifi_mod_params.disable_11ac, bool,
-		   S_IRUGO);
+module_param_named(disable_11ac, iwlwifi_mod_params.disable_11ac, bool, 0444);
 MODULE_PARM_DESC(disable_11ac, "Disable VHT capabilities (default: false)");
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c
index 4228fac77f41..4e9d1792baf3 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c
@@ -1506,44 +1506,36 @@ void iwl_mvm_vif_dbgfs_register(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 	if (iwlmvm_mod_params.power_scheme != IWL_POWER_SCHEME_CAM &&
 	    ((vif->type == NL80211_IFTYPE_STATION && !vif->p2p) ||
 	     (vif->type == NL80211_IFTYPE_STATION && vif->p2p)))
-		MVM_DEBUGFS_ADD_FILE_VIF(pm_params, mvmvif->dbgfs_dir, S_IWUSR |
-					 S_IRUSR);
-
-	MVM_DEBUGFS_ADD_FILE_VIF(tx_pwr_lmt, mvmvif->dbgfs_dir, S_IRUSR);
-	MVM_DEBUGFS_ADD_FILE_VIF(mac_params, mvmvif->dbgfs_dir, S_IRUSR);
-	MVM_DEBUGFS_ADD_FILE_VIF(low_latency, mvmvif->dbgfs_dir,
-				 S_IRUSR | S_IWUSR);
-	MVM_DEBUGFS_ADD_FILE_VIF(uapsd_misbehaving, mvmvif->dbgfs_dir,
-				 S_IRUSR | S_IWUSR);
-	MVM_DEBUGFS_ADD_FILE_VIF(rx_phyinfo, mvmvif->dbgfs_dir,
-				 S_IRUSR | S_IWUSR);
-	MVM_DEBUGFS_ADD_FILE_VIF(quota_min, mvmvif->dbgfs_dir,
-				 S_IRUSR | S_IWUSR);
-	MVM_DEBUGFS_ADD_FILE_VIF(os_device_timediff,
-				 mvmvif->dbgfs_dir, S_IRUSR);
+		MVM_DEBUGFS_ADD_FILE_VIF(pm_params, mvmvif->dbgfs_dir, 0600);
+
+	MVM_DEBUGFS_ADD_FILE_VIF(tx_pwr_lmt, mvmvif->dbgfs_dir, 0400);
+	MVM_DEBUGFS_ADD_FILE_VIF(mac_params, mvmvif->dbgfs_dir, 0400);
+	MVM_DEBUGFS_ADD_FILE_VIF(low_latency, mvmvif->dbgfs_dir, 0600);
+	MVM_DEBUGFS_ADD_FILE_VIF(uapsd_misbehaving, mvmvif->dbgfs_dir, 0600);
+	MVM_DEBUGFS_ADD_FILE_VIF(rx_phyinfo, mvmvif->dbgfs_dir, 0600);
+	MVM_DEBUGFS_ADD_FILE_VIF(quota_min, mvmvif->dbgfs_dir, 0600);
+	MVM_DEBUGFS_ADD_FILE_VIF(os_device_timediff, mvmvif->dbgfs_dir, 0400);
 
 	if (vif->type == NL80211_IFTYPE_STATION && !vif->p2p &&
 	    mvmvif == mvm->bf_allowed_vif)
-		MVM_DEBUGFS_ADD_FILE_VIF(bf_params, mvmvif->dbgfs_dir,
-					 S_IRUSR | S_IWUSR);
+		MVM_DEBUGFS_ADD_FILE_VIF(bf_params, mvmvif->dbgfs_dir, 0600);
 
 	if (fw_has_capa(&mvm->fw->ucode_capa, IWL_UCODE_TLV_CAPA_TOF_SUPPORT) &&
 	    !vif->p2p && (vif->type != NL80211_IFTYPE_P2P_DEVICE)) {
 		if (IWL_MVM_TOF_IS_RESPONDER && vif->type == NL80211_IFTYPE_AP)
 			MVM_DEBUGFS_ADD_FILE_VIF(tof_responder_params,
-						 mvmvif->dbgfs_dir,
-						 S_IRUSR | S_IWUSR);
+						 mvmvif->dbgfs_dir, 0600);
 
 		MVM_DEBUGFS_ADD_FILE_VIF(tof_range_request, mvmvif->dbgfs_dir,
-					 S_IRUSR | S_IWUSR);
+					 0600);
 		MVM_DEBUGFS_ADD_FILE_VIF(tof_range_req_ext, mvmvif->dbgfs_dir,
-					 S_IRUSR | S_IWUSR);
+					 0600);
 		MVM_DEBUGFS_ADD_FILE_VIF(tof_enable, mvmvif->dbgfs_dir,
-					 S_IRUSR | S_IWUSR);
+					 0600);
 		MVM_DEBUGFS_ADD_FILE_VIF(tof_range_abort, mvmvif->dbgfs_dir,
-					 S_IRUSR | S_IWUSR);
+					 0600);
 		MVM_DEBUGFS_ADD_FILE_VIF(tof_range_response, mvmvif->dbgfs_dir,
-					 S_IRUSR);
+					 0400);
 	}
 
 	/*
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
index 9c436d8d001d..0e6401cd7ccc 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
@@ -1914,7 +1914,7 @@ void iwl_mvm_sta_add_debugfs(struct ieee80211_hw *hw,
 	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
 
 	if (iwl_mvm_has_tlc_offload(mvm))
-		MVM_DEBUGFS_ADD_STA_FILE(rs_data, dir, S_IRUSR);
+		MVM_DEBUGFS_ADD_STA_FILE(rs_data, dir, 0400);
 
 	return;
 err:
@@ -1930,48 +1930,45 @@ int iwl_mvm_dbgfs_register(struct iwl_mvm *mvm, struct dentry *dbgfs_dir)
 
 	mvm->debugfs_dir = dbgfs_dir;
 
-	MVM_DEBUGFS_ADD_FILE(tx_flush, mvm->debugfs_dir, S_IWUSR);
-	MVM_DEBUGFS_ADD_FILE(sta_drain, mvm->debugfs_dir, S_IWUSR);
-	MVM_DEBUGFS_ADD_FILE(sram, mvm->debugfs_dir, S_IWUSR | S_IRUSR);
-	MVM_DEBUGFS_ADD_FILE(set_nic_temperature, mvm->debugfs_dir,
-			     S_IWUSR | S_IRUSR);
-	MVM_DEBUGFS_ADD_FILE(nic_temp, dbgfs_dir, S_IRUSR);
-	MVM_DEBUGFS_ADD_FILE(ctdp_budget, dbgfs_dir, S_IRUSR);
-	MVM_DEBUGFS_ADD_FILE(stop_ctdp, dbgfs_dir, S_IWUSR);
-	MVM_DEBUGFS_ADD_FILE(force_ctkill, dbgfs_dir, S_IWUSR);
-	MVM_DEBUGFS_ADD_FILE(stations, dbgfs_dir, S_IRUSR);
-	MVM_DEBUGFS_ADD_FILE(bt_notif, dbgfs_dir, S_IRUSR);
-	MVM_DEBUGFS_ADD_FILE(bt_cmd, dbgfs_dir, S_IRUSR);
-	MVM_DEBUGFS_ADD_FILE(disable_power_off, mvm->debugfs_dir,
-			     S_IRUSR | S_IWUSR);
-	MVM_DEBUGFS_ADD_FILE(fw_ver, mvm->debugfs_dir, S_IRUSR);
-	MVM_DEBUGFS_ADD_FILE(fw_rx_stats, mvm->debugfs_dir, S_IRUSR);
-	MVM_DEBUGFS_ADD_FILE(drv_rx_stats, mvm->debugfs_dir, S_IRUSR);
-	MVM_DEBUGFS_ADD_FILE(fw_restart, mvm->debugfs_dir, S_IWUSR);
-	MVM_DEBUGFS_ADD_FILE(fw_nmi, mvm->debugfs_dir, S_IWUSR);
-	MVM_DEBUGFS_ADD_FILE(bt_tx_prio, mvm->debugfs_dir, S_IWUSR);
-	MVM_DEBUGFS_ADD_FILE(bt_force_ant, mvm->debugfs_dir, S_IWUSR);
-	MVM_DEBUGFS_ADD_FILE(scan_ant_rxchain, mvm->debugfs_dir,
-			     S_IWUSR | S_IRUSR);
-	MVM_DEBUGFS_ADD_FILE(prph_reg, mvm->debugfs_dir, S_IWUSR | S_IRUSR);
-	MVM_DEBUGFS_ADD_FILE(d0i3_refs, mvm->debugfs_dir, S_IRUSR | S_IWUSR);
-	MVM_DEBUGFS_ADD_FILE(fw_dbg_conf, mvm->debugfs_dir, S_IRUSR | S_IWUSR);
-	MVM_DEBUGFS_ADD_FILE(fw_dbg_collect, mvm->debugfs_dir, S_IWUSR);
-	MVM_DEBUGFS_ADD_FILE(max_amsdu_len, mvm->debugfs_dir, S_IWUSR);
-	MVM_DEBUGFS_ADD_FILE(send_echo_cmd, mvm->debugfs_dir, S_IWUSR);
-	MVM_DEBUGFS_ADD_FILE(cont_recording, mvm->debugfs_dir, S_IWUSR);
-	MVM_DEBUGFS_ADD_FILE(indirection_tbl, mvm->debugfs_dir, S_IWUSR);
-	MVM_DEBUGFS_ADD_FILE(inject_packet, mvm->debugfs_dir, S_IWUSR);
+	MVM_DEBUGFS_ADD_FILE(tx_flush, mvm->debugfs_dir, 0200);
+	MVM_DEBUGFS_ADD_FILE(sta_drain, mvm->debugfs_dir, 0200);
+	MVM_DEBUGFS_ADD_FILE(sram, mvm->debugfs_dir, 0600);
+	MVM_DEBUGFS_ADD_FILE(set_nic_temperature, mvm->debugfs_dir, 0600);
+	MVM_DEBUGFS_ADD_FILE(nic_temp, dbgfs_dir, 0400);
+	MVM_DEBUGFS_ADD_FILE(ctdp_budget, dbgfs_dir, 0400);
+	MVM_DEBUGFS_ADD_FILE(stop_ctdp, dbgfs_dir, 0200);
+	MVM_DEBUGFS_ADD_FILE(force_ctkill, dbgfs_dir, 0200);
+	MVM_DEBUGFS_ADD_FILE(stations, dbgfs_dir, 0400);
+	MVM_DEBUGFS_ADD_FILE(bt_notif, dbgfs_dir, 0400);
+	MVM_DEBUGFS_ADD_FILE(bt_cmd, dbgfs_dir, 0400);
+	MVM_DEBUGFS_ADD_FILE(disable_power_off, mvm->debugfs_dir, 0600);
+	MVM_DEBUGFS_ADD_FILE(fw_ver, mvm->debugfs_dir, 0400);
+	MVM_DEBUGFS_ADD_FILE(fw_rx_stats, mvm->debugfs_dir, 0400);
+	MVM_DEBUGFS_ADD_FILE(drv_rx_stats, mvm->debugfs_dir, 0400);
+	MVM_DEBUGFS_ADD_FILE(fw_restart, mvm->debugfs_dir, 0200);
+	MVM_DEBUGFS_ADD_FILE(fw_nmi, mvm->debugfs_dir, 0200);
+	MVM_DEBUGFS_ADD_FILE(bt_tx_prio, mvm->debugfs_dir, 0200);
+	MVM_DEBUGFS_ADD_FILE(bt_force_ant, mvm->debugfs_dir, 0200);
+	MVM_DEBUGFS_ADD_FILE(scan_ant_rxchain, mvm->debugfs_dir, 0600);
+	MVM_DEBUGFS_ADD_FILE(prph_reg, mvm->debugfs_dir, 0600);
+	MVM_DEBUGFS_ADD_FILE(d0i3_refs, mvm->debugfs_dir, 0600);
+	MVM_DEBUGFS_ADD_FILE(fw_dbg_conf, mvm->debugfs_dir, 0600);
+	MVM_DEBUGFS_ADD_FILE(fw_dbg_collect, mvm->debugfs_dir, 0200);
+	MVM_DEBUGFS_ADD_FILE(max_amsdu_len, mvm->debugfs_dir, 0200);
+	MVM_DEBUGFS_ADD_FILE(send_echo_cmd, mvm->debugfs_dir, 0200);
+	MVM_DEBUGFS_ADD_FILE(cont_recording, mvm->debugfs_dir, 0200);
+	MVM_DEBUGFS_ADD_FILE(indirection_tbl, mvm->debugfs_dir, 0200);
+	MVM_DEBUGFS_ADD_FILE(inject_packet, mvm->debugfs_dir, 0200);
 #ifdef CONFIG_ACPI
-	MVM_DEBUGFS_ADD_FILE(sar_geo_profile, dbgfs_dir, S_IRUSR);
+	MVM_DEBUGFS_ADD_FILE(sar_geo_profile, dbgfs_dir, 0400);
 #endif
 
 	if (!debugfs_create_bool("enable_scan_iteration_notif",
-				 S_IRUSR | S_IWUSR,
+				 0600,
 				 mvm->debugfs_dir,
 				 &mvm->scan_iter_notif_enabled))
 		goto err;
-	if (!debugfs_create_bool("drop_bcn_ap_mode", S_IRUSR | S_IWUSR,
+	if (!debugfs_create_bool("drop_bcn_ap_mode", 0600,
 				 mvm->debugfs_dir, &mvm->drop_bcn_ap_mode))
 		goto err;
 
@@ -1982,50 +1979,49 @@ int iwl_mvm_dbgfs_register(struct iwl_mvm *mvm, struct dentry *dbgfs_dir)
 		if (!bcast_dir)
 			goto err;
 
-		if (!debugfs_create_bool("override", S_IRUSR | S_IWUSR,
-				bcast_dir,
-				&mvm->dbgfs_bcast_filtering.override))
+		if (!debugfs_create_bool("override", 0600,
+					 bcast_dir,
+					 &mvm->dbgfs_bcast_filtering.override))
 			goto err;
 
 		MVM_DEBUGFS_ADD_FILE_ALIAS("filters", bcast_filters,
-					   bcast_dir, S_IWUSR | S_IRUSR);
+					   bcast_dir, 0600);
 		MVM_DEBUGFS_ADD_FILE_ALIAS("macs", bcast_filters_macs,
-					   bcast_dir, S_IWUSR | S_IRUSR);
+					   bcast_dir, 0600);
 	}
 #endif
 
 #ifdef CONFIG_PM_SLEEP
-	MVM_DEBUGFS_ADD_FILE(d3_sram, mvm->debugfs_dir, S_IRUSR | S_IWUSR);
-	MVM_DEBUGFS_ADD_FILE(d3_test, mvm->debugfs_dir, S_IRUSR);
-	if (!debugfs_create_bool("d3_wake_sysassert", S_IRUSR | S_IWUSR,
+	MVM_DEBUGFS_ADD_FILE(d3_sram, mvm->debugfs_dir, 0600);
+	MVM_DEBUGFS_ADD_FILE(d3_test, mvm->debugfs_dir, 0400);
+	if (!debugfs_create_bool("d3_wake_sysassert", 0600,
 				 mvm->debugfs_dir, &mvm->d3_wake_sysassert))
 		goto err;
-	if (!debugfs_create_u32("last_netdetect_scans", S_IRUSR,
+	if (!debugfs_create_u32("last_netdetect_scans", 0400,
 				mvm->debugfs_dir, &mvm->last_netdetect_scans))
 		goto err;
 #endif
 
-	if (!debugfs_create_u8("ps_disabled", S_IRUSR,
+	if (!debugfs_create_u8("ps_disabled", 0400,
 			       mvm->debugfs_dir, &mvm->ps_disabled))
 		goto err;
-	if (!debugfs_create_blob("nvm_hw", S_IRUSR,
-				  mvm->debugfs_dir, &mvm->nvm_hw_blob))
+	if (!debugfs_create_blob("nvm_hw", 0400,
+				 mvm->debugfs_dir, &mvm->nvm_hw_blob))
 		goto err;
-	if (!debugfs_create_blob("nvm_sw", S_IRUSR,
-				  mvm->debugfs_dir, &mvm->nvm_sw_blob))
+	if (!debugfs_create_blob("nvm_sw", 0400,
+				 mvm->debugfs_dir, &mvm->nvm_sw_blob))
 		goto err;
-	if (!debugfs_create_blob("nvm_calib", S_IRUSR,
-				  mvm->debugfs_dir, &mvm->nvm_calib_blob))
+	if (!debugfs_create_blob("nvm_calib", 0400,
+				 mvm->debugfs_dir, &mvm->nvm_calib_blob))
 		goto err;
-	if (!debugfs_create_blob("nvm_prod", S_IRUSR,
-				  mvm->debugfs_dir, &mvm->nvm_prod_blob))
+	if (!debugfs_create_blob("nvm_prod", 0400,
+				 mvm->debugfs_dir, &mvm->nvm_prod_blob))
 		goto err;
-	if (!debugfs_create_blob("nvm_phy_sku", S_IRUSR,
+	if (!debugfs_create_blob("nvm_phy_sku", 0400,
 				 mvm->debugfs_dir, &mvm->nvm_phy_sku_blob))
 		goto err;
 
-	debugfs_create_file("mem", S_IRUSR | S_IWUSR, dbgfs_dir, mvm,
-			    &iwl_dbgfs_mem_ops);
+	debugfs_create_file("mem", 0600, dbgfs_dir, mvm, &iwl_dbgfs_mem_ops);
 
 	/*
 	 * Create a symlink with mac80211. It will be removed when mac80211
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index ab7fb5aad984..224bfa1bcf53 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -104,14 +104,14 @@ struct iwl_mvm_mod_params iwlmvm_mod_params = {
 	/* rest of fields are 0 by default */
 };
 
-module_param_named(init_dbg, iwlmvm_mod_params.init_dbg, bool, S_IRUGO);
+module_param_named(init_dbg, iwlmvm_mod_params.init_dbg, bool, 0444);
 MODULE_PARM_DESC(init_dbg,
 		 "set to true to debug an ASSERT in INIT fw (default: false");
-module_param_named(power_scheme, iwlmvm_mod_params.power_scheme, int, S_IRUGO);
+module_param_named(power_scheme, iwlmvm_mod_params.power_scheme, int, 0444);
 MODULE_PARM_DESC(power_scheme,
 		 "power management scheme: 1-active, 2-balanced, 3-low power, default: 2");
 module_param_named(tfd_q_hang_detect, iwlmvm_mod_params.tfd_q_hang_detect,
-		   bool, S_IRUGO);
+		   bool, 0444);
 MODULE_PARM_DESC(tfd_q_hang_detect,
 		 "TFD queues hang detection (default: true");
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rs.c b/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
index 47f4c7a1d80d..5d776ec1840f 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
@@ -4010,18 +4010,18 @@ static void rs_drv_add_sta_debugfs(void *mvm, void *priv_sta,
 	if (!mvmsta->vif)
 		return;
 
-	debugfs_create_file("rate_scale_table", S_IRUSR | S_IWUSR, dir,
+	debugfs_create_file("rate_scale_table", 0600, dir,
 			    lq_sta, &rs_sta_dbgfs_scale_table_ops);
-	debugfs_create_file("rate_stats_table", S_IRUSR, dir,
+	debugfs_create_file("rate_stats_table", 0400, dir,
 			    lq_sta, &rs_sta_dbgfs_stats_table_ops);
-	debugfs_create_file("drv_tx_stats", S_IRUSR | S_IWUSR, dir,
+	debugfs_create_file("drv_tx_stats", 0600, dir,
 			    lq_sta, &rs_sta_dbgfs_drv_tx_stats_ops);
-	debugfs_create_u8("tx_agg_tid_enable", S_IRUSR | S_IWUSR, dir,
+	debugfs_create_u8("tx_agg_tid_enable", 0600, dir,
 			  &lq_sta->tx_agg_tid_en);
-	debugfs_create_u8("reduced_tpc", S_IRUSR | S_IWUSR, dir,
+	debugfs_create_u8("reduced_tpc", 0600, dir,
 			  &lq_sta->pers.dbg_fixed_txp_reduction);
 
-	MVM_DEBUGFS_ADD_FILE_RS(ss_force, dir, S_IRUSR | S_IWUSR);
+	MVM_DEBUGFS_ADD_FILE_RS(ss_force, dir, 0600);
 	return;
 err:
 	IWL_ERR((struct iwl_mvm *)mvm, "Can't create debugfs entity\n");
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index b406b536c850..f8a0234d332c 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -2616,12 +2616,12 @@ int iwl_trans_pcie_dbgfs_register(struct iwl_trans *trans)
 {
 	struct dentry *dir = trans->dbgfs_dir;
 
-	DEBUGFS_ADD_FILE(rx_queue, dir, S_IRUSR);
-	DEBUGFS_ADD_FILE(tx_queue, dir, S_IRUSR);
-	DEBUGFS_ADD_FILE(interrupt, dir, S_IWUSR | S_IRUSR);
-	DEBUGFS_ADD_FILE(csr, dir, S_IWUSR);
-	DEBUGFS_ADD_FILE(fh_reg, dir, S_IRUSR);
-	DEBUGFS_ADD_FILE(rfkill, dir, S_IWUSR | S_IRUSR);
+	DEBUGFS_ADD_FILE(rx_queue, dir, 0400);
+	DEBUGFS_ADD_FILE(tx_queue, dir, 0400);
+	DEBUGFS_ADD_FILE(interrupt, dir, 0600);
+	DEBUGFS_ADD_FILE(csr, dir, 0200);
+	DEBUGFS_ADD_FILE(fh_reg, dir, 0400);
+	DEBUGFS_ADD_FILE(rfkill, dir, 0600);
 	return 0;
 
 err:
diff --git a/drivers/net/wireless/intersil/p54/main.c b/drivers/net/wireless/intersil/p54/main.c
index ab6d39e12069..1c6d428515a4 100644
--- a/drivers/net/wireless/intersil/p54/main.c
+++ b/drivers/net/wireless/intersil/p54/main.c
@@ -27,7 +27,7 @@
 #include "lmac.h"
 
 static bool modparam_nohwcrypt;
-module_param_named(nohwcrypt, modparam_nohwcrypt, bool, S_IRUGO);
+module_param_named(nohwcrypt, modparam_nohwcrypt, bool, 0444);
 MODULE_PARM_DESC(nohwcrypt, "Disable hardware encryption.");
 MODULE_AUTHOR("Michael Wu <flamingice@sourmilk.net>");
 MODULE_DESCRIPTION("Softmac Prism54 common code");
diff --git a/drivers/net/wireless/mediatek/mt76/debugfs.c b/drivers/net/wireless/mediatek/mt76/debugfs.c
index c121b502a462..a38d05dea599 100644
--- a/drivers/net/wireless/mediatek/mt76/debugfs.c
+++ b/drivers/net/wireless/mediatek/mt76/debugfs.c
@@ -64,13 +64,13 @@ struct dentry *mt76_register_debugfs(struct mt76_dev *dev)
 	if (!dir)
 		return NULL;
 
-	debugfs_create_u8("led_pin", S_IRUSR | S_IWUSR, dir, &dev->led_pin);
-	debugfs_create_u32("regidx", S_IRUSR | S_IWUSR, dir, &dev->debugfs_reg);
-	debugfs_create_file_unsafe("regval", S_IRUSR | S_IWUSR, dir, dev,
+	debugfs_create_u8("led_pin", 0600, dir, &dev->led_pin);
+	debugfs_create_u32("regidx", 0600, dir, &dev->debugfs_reg);
+	debugfs_create_file_unsafe("regval", 0600, dir, dev,
 				   &fops_regval);
-	debugfs_create_blob("eeprom", S_IRUSR, dir, &dev->eeprom);
+	debugfs_create_blob("eeprom", 0400, dir, &dev->eeprom);
 	if (dev->otp.data)
-		debugfs_create_blob("otp", S_IRUSR, dir, &dev->otp);
+		debugfs_create_blob("otp", 0400, dir, &dev->otp);
 	debugfs_create_devm_seqfile(dev->dev, "queues", dir, mt76_queues_read);
 
 	return dir;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_debugfs.c b/drivers/net/wireless/mediatek/mt76/mt76x2_debugfs.c
index 612feb593d7d..955ea3e692dd 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_debugfs.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_debugfs.c
@@ -123,11 +123,11 @@ void mt76x2_init_debugfs(struct mt76x2_dev *dev)
 	if (!dir)
 		return;
 
-	debugfs_create_u8("temperature", S_IRUSR, dir, &dev->cal.temp);
-	debugfs_create_bool("tpc", S_IRUSR | S_IWUSR, dir, &dev->enable_tpc);
+	debugfs_create_u8("temperature", 0400, dir, &dev->cal.temp);
+	debugfs_create_bool("tpc", 0600, dir, &dev->enable_tpc);
 
-	debugfs_create_file("ampdu_stat", S_IRUSR, dir, dev, &fops_ampdu_stat);
-	debugfs_create_file("dfs_stats", S_IRUSR, dir, dev, &fops_dfs_stat);
+	debugfs_create_file("ampdu_stat", 0400, dir, dev, &fops_ampdu_stat);
+	debugfs_create_file("dfs_stats", 0400, dir, dev, &fops_dfs_stat);
 	debugfs_create_devm_seqfile(dev->mt76.dev, "txpower", dir,
 				    read_txpower);
 }
diff --git a/drivers/net/wireless/mediatek/mt7601u/debugfs.c b/drivers/net/wireless/mediatek/mt7601u/debugfs.c
index fc008475a03b..991a6a729b1e 100644
--- a/drivers/net/wireless/mediatek/mt7601u/debugfs.c
+++ b/drivers/net/wireless/mediatek/mt7601u/debugfs.c
@@ -160,13 +160,11 @@ void mt7601u_init_debugfs(struct mt7601u_dev *dev)
 	if (!dir)
 		return;
 
-	debugfs_create_u8("temperature", S_IRUSR, dir, &dev->raw_temp);
-	debugfs_create_u32("temp_mode", S_IRUSR, dir, &dev->temp_mode);
-
-	debugfs_create_u32("regidx", S_IRUSR | S_IWUSR, dir, &dev->debugfs_reg);
-	debugfs_create_file("regval", S_IRUSR | S_IWUSR, dir, dev,
-			    &fops_regval);
-	debugfs_create_file("ampdu_stat", S_IRUSR, dir, dev, &fops_ampdu_stat);
-	debugfs_create_file("eeprom_param", S_IRUSR, dir, dev,
-			    &fops_eeprom_param);
+	debugfs_create_u8("temperature", 0400, dir, &dev->raw_temp);
+	debugfs_create_u32("temp_mode", 0400, dir, &dev->temp_mode);
+
+	debugfs_create_u32("regidx", 0600, dir, &dev->debugfs_reg);
+	debugfs_create_file("regval", 0600, dir, dev, &fops_regval);
+	debugfs_create_file("ampdu_stat", 0400, dir, dev, &fops_ampdu_stat);
+	debugfs_create_file("eeprom_param", 0400, dir, dev, &fops_eeprom_param);
 }
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2500usb.c b/drivers/net/wireless/ralink/rt2x00/rt2500usb.c
index f4b48b77c491..3df8c4b895e7 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2500usb.c
@@ -37,7 +37,7 @@
  * Allow hardware encryption to be disabled.
  */
 static bool modparam_nohwcrypt;
-module_param_named(nohwcrypt, modparam_nohwcrypt, bool, S_IRUGO);
+module_param_named(nohwcrypt, modparam_nohwcrypt, bool, 0444);
 MODULE_PARM_DESC(nohwcrypt, "Disable hardware encryption.");
 
 /*
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800pci.c b/drivers/net/wireless/ralink/rt2x00/rt2800pci.c
index 5cf655ff1430..1172eefd1c1a 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800pci.c
@@ -49,7 +49,7 @@
  * Allow hardware encryption to be disabled.
  */
 static bool modparam_nohwcrypt = false;
-module_param_named(nohwcrypt, modparam_nohwcrypt, bool, S_IRUGO);
+module_param_named(nohwcrypt, modparam_nohwcrypt, bool, 0444);
 MODULE_PARM_DESC(nohwcrypt, "Disable hardware encryption.");
 
 static bool rt2800pci_hwcrypt_disabled(struct rt2x00_dev *rt2x00dev)
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800soc.c b/drivers/net/wireless/ralink/rt2x00/rt2800soc.c
index a985a5a7945e..6848ebc83534 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800soc.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800soc.c
@@ -41,7 +41,7 @@
 
 /* Allow hardware encryption to be disabled. */
 static bool modparam_nohwcrypt;
-module_param_named(nohwcrypt, modparam_nohwcrypt, bool, S_IRUGO);
+module_param_named(nohwcrypt, modparam_nohwcrypt, bool, 0444);
 MODULE_PARM_DESC(nohwcrypt, "Disable hardware encryption.");
 
 static bool rt2800soc_hwcrypt_disabled(struct rt2x00_dev *rt2x00dev)
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800usb.c b/drivers/net/wireless/ralink/rt2x00/rt2800usb.c
index 24fc6d2045ef..d901a41d36e4 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800usb.c
@@ -43,7 +43,7 @@
  * Allow hardware encryption to be disabled.
  */
 static bool modparam_nohwcrypt;
-module_param_named(nohwcrypt, modparam_nohwcrypt, bool, S_IRUGO);
+module_param_named(nohwcrypt, modparam_nohwcrypt, bool, 0444);
 MODULE_PARM_DESC(nohwcrypt, "Disable hardware encryption.");
 
 static bool rt2800usb_hwcrypt_disabled(struct rt2x00_dev *rt2x00dev)
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00debug.c b/drivers/net/wireless/ralink/rt2x00/rt2x00debug.c
index ac2572943ed0..0eee479583b8 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00debug.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00debug.c
@@ -606,7 +606,7 @@ static struct dentry *rt2x00debug_create_file_driver(const char *name,
 	data += sprintf(data, "version:\t%s\n", DRV_VERSION);
 	blob->size = strlen(blob->data);
 
-	return debugfs_create_blob(name, S_IRUSR, intf->driver_folder, blob);
+	return debugfs_create_blob(name, 0400, intf->driver_folder, blob);
 }
 
 static struct dentry *rt2x00debug_create_file_chipset(const char *name,
@@ -647,7 +647,7 @@ static struct dentry *rt2x00debug_create_file_chipset(const char *name,
 
 	blob->size = strlen(blob->data);
 
-	return debugfs_create_blob(name, S_IRUSR, intf->driver_folder, blob);
+	return debugfs_create_blob(name, 0400, intf->driver_folder, blob);
 }
 
 void rt2x00debug_register(struct rt2x00_dev *rt2x00dev)
@@ -682,13 +682,13 @@ void rt2x00debug_register(struct rt2x00_dev *rt2x00dev)
 	if (IS_ERR(intf->chipset_entry) || !intf->chipset_entry)
 		goto exit;
 
-	intf->dev_flags = debugfs_create_file("dev_flags", S_IRUSR,
+	intf->dev_flags = debugfs_create_file("dev_flags", 0400,
 					      intf->driver_folder, intf,
 					      &rt2x00debug_fop_dev_flags);
 	if (IS_ERR(intf->dev_flags) || !intf->dev_flags)
 		goto exit;
 
-	intf->cap_flags = debugfs_create_file("cap_flags", S_IRUSR,
+	intf->cap_flags = debugfs_create_file("cap_flags", 0400,
 					      intf->driver_folder, intf,
 					      &rt2x00debug_fop_cap_flags);
 	if (IS_ERR(intf->cap_flags) || !intf->cap_flags)
@@ -699,27 +699,28 @@ void rt2x00debug_register(struct rt2x00_dev *rt2x00dev)
 	if (IS_ERR(intf->register_folder) || !intf->register_folder)
 		goto exit;
 
-#define RT2X00DEBUGFS_CREATE_REGISTER_ENTRY(__intf, __name)			\
-({										\
-	if (debug->__name.read) {						\
-		(__intf)->__name##_off_entry =					\
-		debugfs_create_u32(__stringify(__name) "_offset",		\
-				       S_IRUSR | S_IWUSR,			\
-				       (__intf)->register_folder,		\
-				       &(__intf)->offset_##__name);		\
-		if (IS_ERR((__intf)->__name##_off_entry)			\
-				|| !(__intf)->__name##_off_entry)		\
-			goto exit;						\
-										\
-		(__intf)->__name##_val_entry =					\
-		debugfs_create_file(__stringify(__name) "_value",		\
-					S_IRUSR | S_IWUSR,			\
-					(__intf)->register_folder,		\
-					(__intf), &rt2x00debug_fop_##__name);	\
-		if (IS_ERR((__intf)->__name##_val_entry)			\
-				|| !(__intf)->__name##_val_entry)		\
-			goto exit;						\
-	}									\
+#define RT2X00DEBUGFS_CREATE_REGISTER_ENTRY(__intf, __name)		\
+({									\
+	if (debug->__name.read) {					\
+		(__intf)->__name##_off_entry =				\
+			debugfs_create_u32(__stringify(__name) "_offset", \
+					   0600,			\
+					   (__intf)->register_folder,	\
+					   &(__intf)->offset_##__name);	\
+		if (IS_ERR((__intf)->__name##_off_entry) ||		\
+		    !(__intf)->__name##_off_entry)			\
+			goto exit;					\
+									\
+		(__intf)->__name##_val_entry =				\
+			debugfs_create_file(__stringify(__name) "_value", \
+					    0600,			\
+					    (__intf)->register_folder,	\
+					    (__intf),			\
+					    &rt2x00debug_fop_##__name); \
+		if (IS_ERR((__intf)->__name##_val_entry) ||		\
+		    !(__intf)->__name##_val_entry)			\
+			goto exit;					\
+	}								\
 })
 
 	RT2X00DEBUGFS_CREATE_REGISTER_ENTRY(intf, csr);
@@ -736,8 +737,8 @@ void rt2x00debug_register(struct rt2x00_dev *rt2x00dev)
 		goto exit;
 
 	intf->queue_frame_dump_entry =
-	    debugfs_create_file("dump", S_IRUSR, intf->queue_folder,
-				intf, &rt2x00debug_fop_queue_dump);
+		debugfs_create_file("dump", 0400, intf->queue_folder,
+				    intf, &rt2x00debug_fop_queue_dump);
 	if (IS_ERR(intf->queue_frame_dump_entry)
 		|| !intf->queue_frame_dump_entry)
 		goto exit;
@@ -746,14 +747,15 @@ void rt2x00debug_register(struct rt2x00_dev *rt2x00dev)
 	init_waitqueue_head(&intf->frame_dump_waitqueue);
 
 	intf->queue_stats_entry =
-	    debugfs_create_file("queue", S_IRUSR, intf->queue_folder,
-				intf, &rt2x00debug_fop_queue_stats);
+		debugfs_create_file("queue", 0400, intf->queue_folder,
+				    intf, &rt2x00debug_fop_queue_stats);
 
 #ifdef CONFIG_RT2X00_LIB_CRYPTO
 	if (rt2x00_has_cap_hw_crypto(rt2x00dev))
 		intf->crypto_stats_entry =
-		    debugfs_create_file("crypto", S_IRUGO, intf->queue_folder,
-					intf, &rt2x00debug_fop_crypto_stats);
+			debugfs_create_file("crypto", 0444, intf->queue_folder,
+					    intf,
+					    &rt2x00debug_fop_crypto_stats);
 #endif
 
 	return;
diff --git a/drivers/net/wireless/ralink/rt2x00/rt61pci.c b/drivers/net/wireless/ralink/rt2x00/rt61pci.c
index 234310200759..cb0e1196f2c2 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt61pci.c
@@ -40,7 +40,7 @@
  * Allow hardware encryption to be disabled.
  */
 static bool modparam_nohwcrypt = false;
-module_param_named(nohwcrypt, modparam_nohwcrypt, bool, S_IRUGO);
+module_param_named(nohwcrypt, modparam_nohwcrypt, bool, 0444);
 MODULE_PARM_DESC(nohwcrypt, "Disable hardware encryption.");
 
 /*
diff --git a/drivers/net/wireless/ralink/rt2x00/rt73usb.c b/drivers/net/wireless/ralink/rt2x00/rt73usb.c
index 9a212823f42c..319ec4f2d9d2 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt73usb.c
@@ -38,7 +38,7 @@
  * Allow hardware encryption to be disabled.
  */
 static bool modparam_nohwcrypt;
-module_param_named(nohwcrypt, modparam_nohwcrypt, bool, S_IRUGO);
+module_param_named(nohwcrypt, modparam_nohwcrypt, bool, 0444);
 MODULE_PARM_DESC(nohwcrypt, "Disable hardware encryption.");
 
 /*
diff --git a/drivers/net/wireless/ray_cs.c b/drivers/net/wireless/ray_cs.c
index 0133fcd4601b..7f9b16b97ea3 100644
--- a/drivers/net/wireless/ray_cs.c
+++ b/drivers/net/wireless/ray_cs.c
@@ -2815,9 +2815,11 @@ static int __init init_ray_cs(void)
 	proc_mkdir("driver/ray_cs", NULL);
 
 	proc_create("driver/ray_cs/ray_cs", 0, NULL, &ray_cs_proc_fops);
-	proc_create("driver/ray_cs/essid", S_IWUSR, NULL, &ray_cs_essid_proc_fops);
-	proc_create_data("driver/ray_cs/net_type", S_IWUSR, NULL, &int_proc_fops, &net_type);
-	proc_create_data("driver/ray_cs/translate", S_IWUSR, NULL, &int_proc_fops, &translate);
+	proc_create("driver/ray_cs/essid", 0200, NULL, &ray_cs_essid_proc_fops);
+	proc_create_data("driver/ray_cs/net_type", 0200, NULL, &int_proc_fops,
+			 &net_type);
+	proc_create_data("driver/ray_cs/translate", 0200, NULL, &int_proc_fops,
+			 &translate);
 #endif
 	if (translate != 0)
 		translate = 1;
diff --git a/drivers/net/wireless/st/cw1200/debug.c b/drivers/net/wireless/st/cw1200/debug.c
index 34f97c31eecf..295cb1a29f25 100644
--- a/drivers/net/wireless/st/cw1200/debug.c
+++ b/drivers/net/wireless/st/cw1200/debug.c
@@ -398,15 +398,15 @@ int cw1200_debug_init(struct cw1200_common *priv)
 	if (!d->debugfs_phy)
 		goto err;
 
-	if (!debugfs_create_file("status", S_IRUSR, d->debugfs_phy,
+	if (!debugfs_create_file("status", 0400, d->debugfs_phy,
 				 priv, &fops_status))
 		goto err;
 
-	if (!debugfs_create_file("counters", S_IRUSR, d->debugfs_phy,
+	if (!debugfs_create_file("counters", 0400, d->debugfs_phy,
 				 priv, &fops_counters))
 		goto err;
 
-	if (!debugfs_create_file("wsm_dumps", S_IWUSR, d->debugfs_phy,
+	if (!debugfs_create_file("wsm_dumps", 0200, d->debugfs_phy,
 				 priv, &fops_wsm_dumps))
 		goto err;
 
diff --git a/drivers/net/wireless/st/cw1200/main.c b/drivers/net/wireless/st/cw1200/main.c
index a186d1df1f29..90dc979f260b 100644
--- a/drivers/net/wireless/st/cw1200/main.c
+++ b/drivers/net/wireless/st/cw1200/main.c
@@ -46,7 +46,7 @@ MODULE_ALIAS("cw1200_core");
 
 /* Accept MAC address of the form macaddr=0x00,0x80,0xE1,0x30,0x40,0x50 */
 static u8 cw1200_mac_template[ETH_ALEN] = {0x02, 0x80, 0xe1, 0x00, 0x00, 0x00};
-module_param_array_named(macaddr, cw1200_mac_template, byte, NULL, S_IRUGO);
+module_param_array_named(macaddr, cw1200_mac_template, byte, NULL, 0444);
 MODULE_PARM_DESC(macaddr, "Override platform_data MAC address");
 
 static char *cw1200_sdd_path;
diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index 0cf3b4013dd6..ca0f936fc119 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -2092,54 +2092,51 @@ static struct platform_driver wl18xx_driver = {
 };
 
 module_platform_driver(wl18xx_driver);
-module_param_named(ht_mode, ht_mode_param, charp, S_IRUSR);
+module_param_named(ht_mode, ht_mode_param, charp, 0400);
 MODULE_PARM_DESC(ht_mode, "Force HT mode: wide or siso20");
 
-module_param_named(board_type, board_type_param, charp, S_IRUSR);
+module_param_named(board_type, board_type_param, charp, 0400);
 MODULE_PARM_DESC(board_type, "Board type: fpga, hdk (default), evb, com8 or "
 		 "dvp");
 
-module_param_named(checksum, checksum_param, bool, S_IRUSR);
+module_param_named(checksum, checksum_param, bool, 0400);
 MODULE_PARM_DESC(checksum, "Enable TCP checksum: boolean (defaults to false)");
 
-module_param_named(dc2dc, dc2dc_param, int, S_IRUSR);
+module_param_named(dc2dc, dc2dc_param, int, 0400);
 MODULE_PARM_DESC(dc2dc, "External DC2DC: u8 (defaults to 0)");
 
-module_param_named(n_antennas_2, n_antennas_2_param, int, S_IRUSR);
+module_param_named(n_antennas_2, n_antennas_2_param, int, 0400);
 MODULE_PARM_DESC(n_antennas_2,
 		 "Number of installed 2.4GHz antennas: 1 (default) or 2");
 
-module_param_named(n_antennas_5, n_antennas_5_param, int, S_IRUSR);
+module_param_named(n_antennas_5, n_antennas_5_param, int, 0400);
 MODULE_PARM_DESC(n_antennas_5,
 		 "Number of installed 5GHz antennas: 1 (default) or 2");
 
-module_param_named(low_band_component, low_band_component_param, int,
-		   S_IRUSR);
+module_param_named(low_band_component, low_band_component_param, int, 0400);
 MODULE_PARM_DESC(low_band_component, "Low band component: u8 "
 		 "(default is 0x01)");
 
 module_param_named(low_band_component_type, low_band_component_type_param,
-		   int, S_IRUSR);
+		   int, 0400);
 MODULE_PARM_DESC(low_band_component_type, "Low band component type: u8 "
 		 "(default is 0x05 or 0x06 depending on the board_type)");
 
-module_param_named(high_band_component, high_band_component_param, int,
-		   S_IRUSR);
+module_param_named(high_band_component, high_band_component_param, int, 0400);
 MODULE_PARM_DESC(high_band_component, "High band component: u8, "
 		 "(default is 0x01)");
 
 module_param_named(high_band_component_type, high_band_component_type_param,
-		   int, S_IRUSR);
+		   int, 0400);
 MODULE_PARM_DESC(high_band_component_type, "High band component type: u8 "
 		 "(default is 0x09)");
 
 module_param_named(pwr_limit_reference_11_abg,
-		   pwr_limit_reference_11_abg_param, int, S_IRUSR);
+		   pwr_limit_reference_11_abg_param, int, 0400);
 MODULE_PARM_DESC(pwr_limit_reference_11_abg, "Power limit reference: u8 "
 		 "(default is 0xc8)");
 
-module_param_named(num_rx_desc,
-		   num_rx_desc_param, int, S_IRUSR);
+module_param_named(num_rx_desc, num_rx_desc_param, int, 0400);
 MODULE_PARM_DESC(num_rx_desc_param,
 		 "Number of Rx descriptors: u8 (default is 32)");
 
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 09714034dbf1..3a51ab116e79 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -6630,20 +6630,20 @@ EXPORT_SYMBOL_GPL(wlcore_remove);
 
 u32 wl12xx_debug_level = DEBUG_NONE;
 EXPORT_SYMBOL_GPL(wl12xx_debug_level);
-module_param_named(debug_level, wl12xx_debug_level, uint, S_IRUSR | S_IWUSR);
+module_param_named(debug_level, wl12xx_debug_level, uint, 0600);
 MODULE_PARM_DESC(debug_level, "wl12xx debugging level");
 
 module_param_named(fwlog, fwlog_param, charp, 0);
 MODULE_PARM_DESC(fwlog,
 		 "FW logger options: continuous, dbgpins or disable");
 
-module_param(fwlog_mem_blocks, int, S_IRUSR | S_IWUSR);
+module_param(fwlog_mem_blocks, int, 0600);
 MODULE_PARM_DESC(fwlog_mem_blocks, "fwlog mem_blocks");
 
-module_param(bug_on_recovery, int, S_IRUSR | S_IWUSR);
+module_param(bug_on_recovery, int, 0600);
 MODULE_PARM_DESC(bug_on_recovery, "BUG() on fw recovery");
 
-module_param(no_recovery, int, S_IRUSR | S_IWUSR);
+module_param(no_recovery, int, 0600);
 MODULE_PARM_DESC(no_recovery, "Prevent HW recovery. FW will remain stuck.");
 
 MODULE_LICENSE("GPL");
diff --git a/drivers/net/wireless/ti/wlcore/sdio.c b/drivers/net/wireless/ti/wlcore/sdio.c
index f8a1fea64e25..1f727babbea0 100644
--- a/drivers/net/wireless/ti/wlcore/sdio.c
+++ b/drivers/net/wireless/ti/wlcore/sdio.c
@@ -469,7 +469,7 @@ static void __exit wl1271_exit(void)
 module_init(wl1271_init);
 module_exit(wl1271_exit);
 
-module_param(dump, bool, S_IRUSR | S_IWUSR);
+module_param(dump, bool, 0600);
 MODULE_PARM_DESC(dump, "Enable sdio read/write dumps.");
 
 MODULE_LICENSE("GPL");
diff --git a/drivers/net/wireless/ti/wlcore/sysfs.c b/drivers/net/wireless/ti/wlcore/sysfs.c
index b72e2101488b..d31eb775e023 100644
--- a/drivers/net/wireless/ti/wlcore/sysfs.c
+++ b/drivers/net/wireless/ti/wlcore/sysfs.c
@@ -80,7 +80,7 @@ static ssize_t wl1271_sysfs_store_bt_coex_state(struct device *dev,
 	return count;
 }
 
-static DEVICE_ATTR(bt_coex_state, S_IRUGO | S_IWUSR,
+static DEVICE_ATTR(bt_coex_state, 0644,
 		   wl1271_sysfs_show_bt_coex_state,
 		   wl1271_sysfs_store_bt_coex_state);
 
@@ -103,8 +103,7 @@ static ssize_t wl1271_sysfs_show_hw_pg_ver(struct device *dev,
 	return len;
 }
 
-static DEVICE_ATTR(hw_pg_ver, S_IRUGO,
-		   wl1271_sysfs_show_hw_pg_ver, NULL);
+static DEVICE_ATTR(hw_pg_ver, 0444, wl1271_sysfs_show_hw_pg_ver, NULL);
 
 static ssize_t wl1271_sysfs_read_fwlog(struct file *filp, struct kobject *kobj,
 				       struct bin_attribute *bin_attr,
@@ -139,7 +138,7 @@ static ssize_t wl1271_sysfs_read_fwlog(struct file *filp, struct kobject *kobj,
 }
 
 static const struct bin_attribute fwlog_attr = {
-	.attr = {.name = "fwlog", .mode = S_IRUSR},
+	.attr = { .name = "fwlog", .mode = 0400 },
 	.read = wl1271_sysfs_read_fwlog,
 };
 
-- 
2.15.0
