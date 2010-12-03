Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:36954 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753385Ab0LCTIA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Dec 2010 14:08:00 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/2] compat-wireless: make patches apply again.
Date: Fri,  3 Dec 2010 20:07:48 +0100
Message-Id: <1291403269-2938-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These patches are applying now, but crap/0002-ath9k-tlog-support.patch
does not apply any more, some more changes have to be done to make it
work again.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 ...k-Add-debugfs-interface-to-dump-registers.patch |   19 +++++--------------
 patches/11-dev-pm-ops.patch                        |   12 ++++++------
 2 files changed, 11 insertions(+), 20 deletions(-)

diff --git a/crap/0001-ath9k-Add-debugfs-interface-to-dump-registers.patch b/crap/0001-ath9k-Add-debugfs-interface-to-dump-registers.patch
index a99f60d..1a89e9a 100644
--- a/crap/0001-ath9k-Add-debugfs-interface-to-dump-registers.patch
+++ b/crap/0001-ath9k-Add-debugfs-interface-to-dump-registers.patch
@@ -22,7 +22,7 @@ Signed-off-by: Felix Fietkau <nbd@openwrt.org>
  #include <asm/unaligned.h>
  
  #include "ath9k.h"
-@@ -32,6 +33,19 @@ static int ath9k_debugfs_open(struct ino
+@@ -30,6 +31,19 @@ static int ath9k_debugfs_open(struct ino
  	return 0;
  }
  
@@ -42,7 +42,7 @@ Signed-off-by: Felix Fietkau <nbd@openwrt.org>
  #ifdef CONFIG_ATH_DEBUG
  
  static ssize_t read_file_debug(struct file *file, char __user *user_buf,
-@@ -873,6 +887,40 @@ static const struct file_operations fops
+@@ -871,6 +885,40 @@ static const struct file_operations fops
  	.llseek = default_llseek,
  };
  
@@ -83,26 +83,17 @@ Signed-off-by: Felix Fietkau <nbd@openwrt.org>
  int ath9k_init_debug(struct ath_hw *ah)
  {
  	struct ath_common *common = ath9k_hw_common(ah);
-@@ -933,6 +981,11 @@ int ath9k_init_debug(struct ath_hw *ah)
+@@ -927,6 +975,10 @@ int ath9k_init_debug(struct ath_hw *ah)
+ 			sc->debug.debugfs_phy, &ah->config.cwm_ignore_extcca))
  		goto err;
  
- 	sc->debug.regidx = 0;
-+
 +	if (!debugfs_create_file("regdump", S_IRUSR, sc->debug.debugfs_phy,
 +			sc, &fops_regdump))
 +		goto err;
 +
+ 	sc->debug.regidx = 0;
  	return 0;
  err:
- 	ath9k_exit_debug(ah);
-@@ -944,6 +997,7 @@ void ath9k_exit_debug(struct ath_hw *ah)
- 	struct ath_common *common = ath9k_hw_common(ah);
- 	struct ath_softc *sc = (struct ath_softc *) common->priv;
- 
-+	debugfs_remove(sc->debug.debugfs_regdump);
- 	debugfs_remove_recursive(sc->debug.debugfs_phy);
- }
- 
 --- a/drivers/net/wireless/ath/ath9k/debug.h
 +++ b/drivers/net/wireless/ath/ath9k/debug.h
 @@ -160,6 +160,14 @@ struct ath_stats {
diff --git a/patches/11-dev-pm-ops.patch b/patches/11-dev-pm-ops.patch
index 3c13dcd..77768e5 100644
--- a/patches/11-dev-pm-ops.patch
+++ b/patches/11-dev-pm-ops.patch
@@ -7,9 +7,9 @@ calls on compat code with only slight modifications.
 
 [1] http://lxr.linux.no/#linux+v2.6.29/include/linux/pm.h#L170
 
---- a/drivers/net/wireless/ath/ath5k/base.c
-+++ b/drivers/net/wireless/ath/ath5k/base.c
-@@ -3758,6 +3758,34 @@ static int ath5k_pci_resume(struct devic
+--- a/drivers/net/wireless/ath/ath5k/pci.c
++++ b/drivers/net/wireless/ath/ath5k/pci.c
+@@ -285,6 +285,34 @@ static int ath5k_pci_resume(struct devic
  	return 0;
  }
  
@@ -44,7 +44,7 @@ calls on compat code with only slight modifications.
  static SIMPLE_DEV_PM_OPS(ath5k_pm_ops, ath5k_pci_suspend, ath5k_pci_resume);
  #define ATH5K_PM_OPS	(&ath5k_pm_ops)
  #else
-@@ -3769,7 +3797,12 @@ static struct pci_driver ath5k_pci_drive
+@@ -296,7 +324,12 @@ static struct pci_driver ath5k_pci_drive
  	.id_table	= ath5k_pci_id_table,
  	.probe		= ath5k_pci_probe,
  	.remove		= __devexit_p(ath5k_pci_remove),
@@ -119,7 +119,7 @@ calls on compat code with only slight modifications.
  int ath_pci_init(void)
 --- a/drivers/net/wireless/iwlwifi/iwl-agn.c
 +++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
-@@ -4501,7 +4501,12 @@ static struct pci_driver iwl_driver = {
+@@ -4502,7 +4502,12 @@ static struct pci_driver iwl_driver = {
  	.id_table = iwl_hw_card_ids,
  	.probe = iwl_pci_probe,
  	.remove = __devexit_p(iwl_pci_remove),
@@ -187,7 +187,7 @@ calls on compat code with only slight modifications.
  #endif /* CONFIG_PM */
 --- a/drivers/net/wireless/iwlwifi/iwl-core.h
 +++ b/drivers/net/wireless/iwlwifi/iwl-core.h
-@@ -629,7 +629,12 @@ __le32 iwl_add_beacon_time(struct iwl_pr
+@@ -633,7 +633,12 @@ __le32 iwl_add_beacon_time(struct iwl_pr
  #ifdef CONFIG_PM
  int iwl_pci_suspend(struct device *device);
  int iwl_pci_resume(struct device *device);
-- 
1.7.1

