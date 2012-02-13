Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38713 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756524Ab2BMKYM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Feb 2012 05:24:12 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 09/24] iwlegacy: merge eeprom_ops into lib_ops
Date: Mon, 13 Feb 2012 11:23:16 +0100
Message-Id: <1329128611-6815-10-git-send-email-sgruszka@redhat.com> (sfid-20120213_112441_523352_82428B1F)
In-Reply-To: <1329128611-6815-1-git-send-email-sgruszka@redhat.com>
References: <1329128611-6815-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/3945.c   |    6 ++----
 drivers/net/wireless/iwlegacy/4965.c   |    6 ++----
 drivers/net/wireless/iwlegacy/common.c |    4 ++--
 drivers/net/wireless/iwlegacy/common.h |    8 ++------
 4 files changed, 8 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/3945.c b/drivers/net/wireless/iwlegacy/3945.c
index 4e63e7d..95d88b4 100644
--- a/drivers/net/wireless/iwlegacy/3945.c
+++ b/drivers/net/wireless/iwlegacy/3945.c
@@ -2645,12 +2645,10 @@ static struct il_lib_ops il3945_lib = {
 		    .init = il3945_apm_init,
 		    .config = il3945_nic_config,
 		    },
-	.eeprom_ops = {
-		.acquire_semaphore = il3945_eeprom_acquire_semaphore,
-		.release_semaphore = il3945_eeprom_release_semaphore,
-	},
 	.send_tx_power = il3945_send_tx_power,
 	.is_valid_rtc_data_addr = il3945_hw_valid_rtc_data_addr,
+	.eeprom_acquire_semaphore = il3945_eeprom_acquire_semaphore,
+	.eeprom_release_semaphore = il3945_eeprom_release_semaphore,
 };
 
 static const struct il_legacy_ops il3945_legacy_ops = {
diff --git a/drivers/net/wireless/iwlegacy/4965.c b/drivers/net/wireless/iwlegacy/4965.c
index 3a30aac..3ddc31f 100644
--- a/drivers/net/wireless/iwlegacy/4965.c
+++ b/drivers/net/wireless/iwlegacy/4965.c
@@ -1904,12 +1904,10 @@ static struct il_lib_ops il4965_lib = {
 		    .init = il_apm_init,
 		    .config = il4965_nic_config,
 		    },
-	.eeprom_ops = {
-		       .acquire_semaphore = il4965_eeprom_acquire_semaphore,
-		       .release_semaphore = il4965_eeprom_release_semaphore,
-		       },
 	.send_tx_power = il4965_send_tx_power,
 	.update_chain_flags = il4965_update_chain_flags,
+	.eeprom_acquire_semaphore = il4965_eeprom_acquire_semaphore,
+	.eeprom_release_semaphore = il4965_eeprom_release_semaphore,
 };
 
 static const struct il_legacy_ops il4965_legacy_ops = {
diff --git a/drivers/net/wireless/iwlegacy/common.c b/drivers/net/wireless/iwlegacy/common.c
index 5a7ad52..5de2340 100644
--- a/drivers/net/wireless/iwlegacy/common.c
+++ b/drivers/net/wireless/iwlegacy/common.c
@@ -740,7 +740,7 @@ il_eeprom_init(struct il_priv *il)
 	}
 
 	/* Make sure driver (instead of uCode) is allowed to read EEPROM */
-	ret = il->ops->lib->eeprom_ops.acquire_semaphore(il);
+	ret = il->ops->lib->eeprom_acquire_semaphore(il);
 	if (ret < 0) {
 		IL_ERR("Failed to acquire EEPROM semaphore.\n");
 		ret = -ENOENT;
@@ -772,7 +772,7 @@ il_eeprom_init(struct il_priv *il)
 
 	ret = 0;
 done:
-	il->ops->lib->eeprom_ops.release_semaphore(il);
+	il->ops->lib->eeprom_release_semaphore(il);
 
 err:
 	if (ret)
diff --git a/drivers/net/wireless/iwlegacy/common.h b/drivers/net/wireless/iwlegacy/common.h
index 6f42f56..b588a5f 100644
--- a/drivers/net/wireless/iwlegacy/common.h
+++ b/drivers/net/wireless/iwlegacy/common.h
@@ -425,11 +425,6 @@ struct il_eeprom_calib_info {
 
 #define EEPROM_REGULATORY_BAND_NO_HT40			(0)
 
-struct il_eeprom_ops {
-	int (*acquire_semaphore) (struct il_priv *il);
-	void (*release_semaphore) (struct il_priv *il);
-};
-
 int il_eeprom_init(struct il_priv *il);
 void il_eeprom_free(struct il_priv *il);
 const u8 *il_eeprom_query_addr(const struct il_priv *il, size_t offset);
@@ -1617,7 +1612,8 @@ struct il_lib_ops {
 	void (*update_chain_flags) (struct il_priv *il);
 
 	/* eeprom operations */
-	struct il_eeprom_ops eeprom_ops;
+	int (*eeprom_acquire_semaphore) (struct il_priv *il);
+	void (*eeprom_release_semaphore) (struct il_priv *il);
 };
 
 struct il_led_ops {
-- 
1.7.1

