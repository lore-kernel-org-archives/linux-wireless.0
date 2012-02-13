Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31506 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756531Ab2BMKYJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Feb 2012 05:24:09 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 10/24] iwlegacy: remove il_apm_ops
Date: Mon, 13 Feb 2012 11:23:17 +0100
Message-Id: <1329128611-6815-11-git-send-email-sgruszka@redhat.com> (sfid-20120213_112423_823274_682E98DD)
In-Reply-To: <1329128611-6815-1-git-send-email-sgruszka@redhat.com>
References: <1329128611-6815-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/3945-mac.c |    2 +-
 drivers/net/wireless/iwlegacy/3945.c     |   10 +++-------
 drivers/net/wireless/iwlegacy/4965-mac.c |    8 ++------
 drivers/net/wireless/iwlegacy/4965.c     |    7 ++-----
 drivers/net/wireless/iwlegacy/4965.h     |    2 ++
 drivers/net/wireless/iwlegacy/common.c   |    2 +-
 drivers/net/wireless/iwlegacy/common.h   |    9 ++-------
 7 files changed, 13 insertions(+), 27 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/3945-mac.c b/drivers/net/wireless/iwlegacy/3945-mac.c
index b7d5ebc..ba01d2d 100644
--- a/drivers/net/wireless/iwlegacy/3945-mac.c
+++ b/drivers/net/wireless/iwlegacy/3945-mac.c
@@ -3672,7 +3672,7 @@ il3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	 * PCI Tx retries from interfering with C3 CPU state */
 	pci_write_config_byte(pdev, 0x41, 0x00);
 
-	/* these spin locks will be used in apm_ops.init and EEPROM access
+	/* these spin locks will be used in apm_init and EEPROM access
 	 * we should init now
 	 */
 	spin_lock_init(&il->reg_lock);
diff --git a/drivers/net/wireless/iwlegacy/3945.c b/drivers/net/wireless/iwlegacy/3945.c
index 95d88b4..a21ec25 100644
--- a/drivers/net/wireless/iwlegacy/3945.c
+++ b/drivers/net/wireless/iwlegacy/3945.c
@@ -958,12 +958,11 @@ il3945_hw_nic_init(struct il_priv *il)
 	struct il_rx_queue *rxq = &il->rxq;
 
 	spin_lock_irqsave(&il->lock, flags);
-	il->ops->lib->apm_ops.init(il);
+	il3945_apm_init(il);
 	spin_unlock_irqrestore(&il->lock, flags);
 
 	il3945_set_pwr_vmain(il);
-
-	il->ops->lib->apm_ops.config(il);
+	il3945_nic_config(il);
 
 	/* Allocate the RX queue, or reset if it is already allocated */
 	if (!rxq->bd) {
@@ -2641,10 +2640,7 @@ static struct il_lib_ops il3945_lib = {
 	.txq_init = il3945_hw_tx_queue_init,
 	.load_ucode = il3945_load_bsm,
 	.dump_nic_error_log = il3945_dump_nic_error_log,
-	.apm_ops = {
-		    .init = il3945_apm_init,
-		    .config = il3945_nic_config,
-		    },
+	.apm_init = il3945_apm_init,
 	.send_tx_power = il3945_send_tx_power,
 	.is_valid_rtc_data_addr = il3945_hw_valid_rtc_data_addr,
 	.eeprom_acquire_semaphore = il3945_eeprom_acquire_semaphore,
diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
index e113dc5..ebfcfc8 100644
--- a/drivers/net/wireless/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/iwlegacy/4965-mac.c
@@ -199,18 +199,14 @@ il4965_hw_nic_init(struct il_priv *il)
 	struct il_rx_queue *rxq = &il->rxq;
 	int ret;
 
-	/* nic_init */
 	spin_lock_irqsave(&il->lock, flags);
-	il->ops->lib->apm_ops.init(il);
-
+	il_apm_init(il);
 	/* Set interrupt coalescing calibration timer to default (512 usecs) */
 	il_write8(il, CSR_INT_COALESCING, IL_HOST_INT_CALIB_TIMEOUT_DEF);
-
 	spin_unlock_irqrestore(&il->lock, flags);
 
 	il4965_set_pwr_vmain(il);
-
-	il->ops->lib->apm_ops.config(il);
+	il4965_nic_config(il);
 
 	/* Allocate the RX queue, or reset if it is already allocated */
 	if (!rxq->bd) {
diff --git a/drivers/net/wireless/iwlegacy/4965.c b/drivers/net/wireless/iwlegacy/4965.c
index 3ddc31f..e5e5ab2 100644
--- a/drivers/net/wireless/iwlegacy/4965.c
+++ b/drivers/net/wireless/iwlegacy/4965.c
@@ -508,7 +508,7 @@ iw4965_is_ht40_channel(__le32 rxon_flags)
 		chan_mod == CHANNEL_MODE_MIXED);
 }
 
-static void
+void
 il4965_nic_config(struct il_priv *il)
 {
 	unsigned long flags;
@@ -1900,10 +1900,7 @@ static struct il_lib_ops il4965_lib = {
 	.dump_nic_error_log = il4965_dump_nic_error_log,
 	.dump_fh = il4965_dump_fh,
 	.set_channel_switch = il4965_hw_channel_switch,
-	.apm_ops = {
-		    .init = il_apm_init,
-		    .config = il4965_nic_config,
-		    },
+	.apm_init = il_apm_init,
 	.send_tx_power = il4965_send_tx_power,
 	.update_chain_flags = il4965_update_chain_flags,
 	.eeprom_acquire_semaphore = il4965_eeprom_acquire_semaphore,
diff --git a/drivers/net/wireless/iwlegacy/4965.h b/drivers/net/wireless/iwlegacy/4965.h
index 7c6b9b9..208a456 100644
--- a/drivers/net/wireless/iwlegacy/4965.h
+++ b/drivers/net/wireless/iwlegacy/4965.h
@@ -60,6 +60,8 @@ int il4965_rx_init(struct il_priv *il, struct il_rx_queue *rxq);
 int il4965_hw_nic_init(struct il_priv *il);
 int il4965_dump_fh(struct il_priv *il, char **buf, bool display);
 
+void il4965_nic_config(struct il_priv *il);
+
 /* rx */
 void il4965_rx_queue_restock(struct il_priv *il);
 void il4965_rx_replenish(struct il_priv *il);
diff --git a/drivers/net/wireless/iwlegacy/common.c b/drivers/net/wireless/iwlegacy/common.c
index 5de2340..6e63d9f 100644
--- a/drivers/net/wireless/iwlegacy/common.c
+++ b/drivers/net/wireless/iwlegacy/common.c
@@ -730,7 +730,7 @@ il_eeprom_init(struct il_priv *il)
 	}
 	e = (__le16 *) il->eeprom;
 
-	il->ops->lib->apm_ops.init(il);
+	il->ops->lib->apm_init(il);
 
 	ret = il_eeprom_verify_signature(il);
 	if (ret < 0) {
diff --git a/drivers/net/wireless/iwlegacy/common.h b/drivers/net/wireless/iwlegacy/common.h
index b588a5f..ca68b58 100644
--- a/drivers/net/wireless/iwlegacy/common.h
+++ b/drivers/net/wireless/iwlegacy/common.h
@@ -1566,11 +1566,6 @@ struct il_hcmd_utils_ops {
 	void (*post_scan) (struct il_priv *il);
 };
 
-struct il_apm_ops {
-	int (*init) (struct il_priv *il);
-	void (*config) (struct il_priv *il);
-};
-
 #ifdef CONFIG_IWLEGACY_DEBUGFS
 struct il_debugfs_ops {
 	ssize_t(*rx_stats_read) (struct file *file, char __user *user_buf,
@@ -1605,9 +1600,9 @@ struct il_lib_ops {
 	int (*set_channel_switch) (struct il_priv *il,
 				   struct ieee80211_channel_switch *ch_switch);
 	/* power management */
-	struct il_apm_ops apm_ops;
+	int (*apm_init) (struct il_priv *il);
 
-	/* power */
+	/* tx power */
 	int (*send_tx_power) (struct il_priv *il);
 	void (*update_chain_flags) (struct il_priv *il);
 
-- 
1.7.1

