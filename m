Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:2165 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754857Ab1KRIVM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Nov 2011 03:21:12 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pAI8LBl2022555
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-wireless@vger.kernel.org>; Fri, 18 Nov 2011 03:21:12 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 11/77] iwlegacy: mark poll bit as unlocked function
Date: Fri, 18 Nov 2011 09:21:33 +0100
Message-Id: <1321604559-10707-11-git-send-email-sgruszka@redhat.com> (sfid-20111118_092120_913561_1274E4F7)
In-Reply-To: <1321604559-10707-1-git-send-email-sgruszka@redhat.com>
References: <1321604559-10707-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We do not take reg_lock during poll bit, so mark it such
using underscore.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/iwl-3945.c        |    4 ++--
 drivers/net/wireless/iwlegacy/iwl-4965-eeprom.c |    2 +-
 drivers/net/wireless/iwlegacy/iwl-core.c        |    4 ++--
 drivers/net/wireless/iwlegacy/iwl-eeprom.c      |    2 +-
 drivers/net/wireless/iwlegacy/iwl-io.h          |    1 -
 drivers/net/wireless/iwlegacy/iwl4965-base.c    |    4 ++--
 6 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/iwl-3945.c b/drivers/net/wireless/iwlegacy/iwl-3945.c
index 6e2e71a..8c3ae39 100644
--- a/drivers/net/wireless/iwlegacy/iwl-3945.c
+++ b/drivers/net/wireless/iwlegacy/iwl-3945.c
@@ -757,7 +757,7 @@ static void il3945_set_pwr_vmain(struct il_priv *il)
 					APMG_PS_CTRL_VAL_PWR_SRC_VAUX,
 					~APMG_PS_CTRL_MSK_PWR_SRC);
 
-			il_poll_bit(il, CSR_GPIO_IN,
+			_il_poll_bit(il, CSR_GPIO_IN,
 				     CSR_GPIO_IN_VAL_VAUX_PWR_SRC,
 				     CSR_GPIO_IN_BIT_AUX_POWER, 5000);
 		}
@@ -767,7 +767,7 @@ static void il3945_set_pwr_vmain(struct il_priv *il)
 			APMG_PS_CTRL_VAL_PWR_SRC_VMAIN,
 			~APMG_PS_CTRL_MSK_PWR_SRC);
 
-	il_poll_bit(il, CSR_GPIO_IN, CSR_GPIO_IN_VAL_VMAIN_PWR_SRC,
+	_il_poll_bit(il, CSR_GPIO_IN, CSR_GPIO_IN_VAL_VMAIN_PWR_SRC,
 		     CSR_GPIO_IN_BIT_AUX_POWER, 5000);	/* uS */
 }
 
diff --git a/drivers/net/wireless/iwlegacy/iwl-4965-eeprom.c b/drivers/net/wireless/iwlegacy/iwl-4965-eeprom.c
index 016472d..a519257 100644
--- a/drivers/net/wireless/iwlegacy/iwl-4965-eeprom.c
+++ b/drivers/net/wireless/iwlegacy/iwl-4965-eeprom.c
@@ -98,7 +98,7 @@ int il4965_eeprom_acquire_semaphore(struct il_priv *il)
 			    CSR_HW_IF_CONFIG_REG_BIT_EEPROM_OWN_SEM);
 
 		/* See if we got it */
-		ret = il_poll_bit(il, CSR_HW_IF_CONFIG_REG,
+		ret = _il_poll_bit(il, CSR_HW_IF_CONFIG_REG,
 				CSR_HW_IF_CONFIG_REG_BIT_EEPROM_OWN_SEM,
 				CSR_HW_IF_CONFIG_REG_BIT_EEPROM_OWN_SEM,
 				EEPROM_SEM_TIMEOUT);
diff --git a/drivers/net/wireless/iwlegacy/iwl-core.c b/drivers/net/wireless/iwlegacy/iwl-core.c
index c5ffd91..d2534fb 100644
--- a/drivers/net/wireless/iwlegacy/iwl-core.c
+++ b/drivers/net/wireless/iwlegacy/iwl-core.c
@@ -960,7 +960,7 @@ static int il_apm_stop_master(struct il_priv *il)
 	/* stop device's busmaster DMA activity */
 	il_set_bit(il, CSR_RESET, CSR_RESET_REG_FLAG_STOP_MASTER);
 
-	ret = il_poll_bit(il, CSR_RESET, CSR_RESET_REG_FLAG_MASTER_DISABLED,
+	ret = _il_poll_bit(il, CSR_RESET, CSR_RESET_REG_FLAG_MASTER_DISABLED,
 			CSR_RESET_REG_FLAG_MASTER_DISABLED, 100);
 	if (ret)
 		IL_WARN("Master Disable Timed Out, 100 usec\n");
@@ -1072,7 +1072,7 @@ int il_apm_init(struct il_priv *il)
 	 * device-internal resources is supported, e.g. il_write_prph()
 	 * and accesses to uCode SRAM.
 	 */
-	ret = il_poll_bit(il, CSR_GP_CNTRL,
+	ret = _il_poll_bit(il, CSR_GP_CNTRL,
 			CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY,
 			CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY, 25000);
 	if (ret < 0) {
diff --git a/drivers/net/wireless/iwlegacy/iwl-eeprom.c b/drivers/net/wireless/iwlegacy/iwl-eeprom.c
index 26cf506..ba2be7b 100644
--- a/drivers/net/wireless/iwlegacy/iwl-eeprom.c
+++ b/drivers/net/wireless/iwlegacy/iwl-eeprom.c
@@ -226,7 +226,7 @@ int il_eeprom_init(struct il_priv *il)
 		_il_wr(il, CSR_EEPROM_REG,
 			     CSR_EEPROM_REG_MSK_ADDR & (addr << 1));
 
-		ret = il_poll_bit(il, CSR_EEPROM_REG,
+		ret = _il_poll_bit(il, CSR_EEPROM_REG,
 					  CSR_EEPROM_REG_READ_VALID_MSK,
 					  CSR_EEPROM_REG_READ_VALID_MSK,
 					  IL_EEPROM_ACCESS_TIMEOUT);
diff --git a/drivers/net/wireless/iwlegacy/iwl-io.h b/drivers/net/wireless/iwlegacy/iwl-io.h
index cdbcfde..7ad262e 100644
--- a/drivers/net/wireless/iwlegacy/iwl-io.h
+++ b/drivers/net/wireless/iwlegacy/iwl-io.h
@@ -66,7 +66,6 @@ _il_poll_bit(struct il_priv *il, u32 addr,
 
 	return -ETIMEDOUT;
 }
-#define il_poll_bit(p, a, b, m, t) _il_poll_bit(p, a, b, m, t)
 
 static inline void _il_set_bit(struct il_priv *il, u32 reg, u32 mask)
 {
diff --git a/drivers/net/wireless/iwlegacy/iwl4965-base.c b/drivers/net/wireless/iwlegacy/iwl4965-base.c
index a774373..f3ec8bb 100644
--- a/drivers/net/wireless/iwlegacy/iwl4965-base.c
+++ b/drivers/net/wireless/iwlegacy/iwl4965-base.c
@@ -1907,7 +1907,7 @@ static int il4965_set_hw_ready(struct il_priv *il)
 		CSR_HW_IF_CONFIG_REG_BIT_NIC_READY);
 
 	/* See if we got it */
-	ret = il_poll_bit(il, CSR_HW_IF_CONFIG_REG,
+	ret = _il_poll_bit(il, CSR_HW_IF_CONFIG_REG,
 				CSR_HW_IF_CONFIG_REG_BIT_NIC_READY,
 				CSR_HW_IF_CONFIG_REG_BIT_NIC_READY,
 				HW_READY_TIMEOUT);
@@ -1935,7 +1935,7 @@ static int il4965_prepare_card_hw(struct il_priv *il)
 	il_set_bit(il, CSR_HW_IF_CONFIG_REG,
 			CSR_HW_IF_CONFIG_REG_PREPARE);
 
-	ret = il_poll_bit(il, CSR_HW_IF_CONFIG_REG,
+	ret = _il_poll_bit(il, CSR_HW_IF_CONFIG_REG,
 			~CSR_HW_IF_CONFIG_REG_BIT_NIC_PREPARE_DONE,
 			CSR_HW_IF_CONFIG_REG_BIT_NIC_PREPARE_DONE, 150000);
 
-- 
1.7.1

