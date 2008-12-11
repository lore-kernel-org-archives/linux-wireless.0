Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:19321 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755571AbYLKScm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Dec 2008 13:32:42 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net, "Zhu, Yi" <yi.zhu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 1/6] iwlwifi: use iwl_poll_direct_bit in EEPROM reading
Date: Thu, 11 Dec 2008 10:33:36 -0800
Message-Id: <1229020421-4823-2-git-send-email-reinette.chatre@intel.com> (sfid-20081211_193250_916730_3A8207EC)
In-Reply-To: <1229020421-4823-1-git-send-email-reinette.chatre@intel.com>
References: <>
 <1229020421-4823-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Zhu, Yi <yi.zhu@intel.com>

The patch replaces the current reading EEPROM loop iterations with
iwl_poll_direct_bit(). It also fixes some comment error.

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945-hw.h  |    1 -
 drivers/net/wireless/iwlwifi/iwl-csr.h      |    2 +
 drivers/net/wireless/iwlwifi/iwl-eeprom.c   |   21 +++++++-----------
 drivers/net/wireless/iwlwifi/iwl-eeprom.h   |    7 +----
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   31 ++++++++++++--------------
 5 files changed, 26 insertions(+), 36 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-hw.h b/drivers/net/wireless/iwlwifi/iwl-3945-hw.h
index 15570e6..94ea0e6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-hw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-hw.h
@@ -103,7 +103,6 @@
  * Driver reads 16-bit value from bits 31-16 of CSR_EEPROM_REG.
  */
 #define IWL_EEPROM_ACCESS_TIMEOUT	5000 /* uSec */
-#define IWL_EEPROM_ACCESS_DELAY		10   /* uSec */
 
 /*
  * Regulatory channel usage flags in EEPROM struct iwl_eeprom_channel.flags.
diff --git a/drivers/net/wireless/iwlwifi/iwl-csr.h b/drivers/net/wireless/iwlwifi/iwl-csr.h
index b834e21..f34ede4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-csr.h
+++ b/drivers/net/wireless/iwlwifi/iwl-csr.h
@@ -216,6 +216,8 @@
 /* EEPROM REG */
 #define CSR_EEPROM_REG_READ_VALID_MSK	(0x00000001)
 #define CSR_EEPROM_REG_BIT_CMD		(0x00000002)
+#define CSR_EEPROM_REG_MSK_ADDR		(0x0000FFFC)
+#define CSR_EEPROM_REG_MSK_DATA		(0xFFFF0000)
 
 /* EEPROM GP */
 #define CSR_EEPROM_GP_VALID_MSK		(0x00000006)
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.c b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
index a47fa38..ce2f473 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.c
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
@@ -209,10 +209,8 @@ int iwl_eeprom_init(struct iwl_priv *priv)
 {
 	u16 *e;
 	u32 gp = iwl_read32(priv, CSR_EEPROM_GP);
-	u32 r;
 	int sz = priv->cfg->eeprom_size;
 	int ret;
-	int i;
 	u16 addr;
 
 	/* allocate eeprom */
@@ -240,22 +238,19 @@ int iwl_eeprom_init(struct iwl_priv *priv)
 
 	/* eeprom is an array of 16bit values */
 	for (addr = 0; addr < sz; addr += sizeof(u16)) {
-		_iwl_write32(priv, CSR_EEPROM_REG, addr << 1);
-		_iwl_clear_bit(priv, CSR_EEPROM_REG, CSR_EEPROM_REG_BIT_CMD);
-
-		for (i = 0; i < IWL_EEPROM_ACCESS_TIMEOUT;
-					i += IWL_EEPROM_ACCESS_DELAY) {
-			r = _iwl_read_direct32(priv, CSR_EEPROM_REG);
-			if (r & CSR_EEPROM_REG_READ_VALID_MSK)
-				break;
-			udelay(IWL_EEPROM_ACCESS_DELAY);
-		}
+		u32 r;
+
+		_iwl_write32(priv, CSR_EEPROM_REG,
+			     CSR_EEPROM_REG_MSK_ADDR & (addr << 1));
 
-		if (!(r & CSR_EEPROM_REG_READ_VALID_MSK)) {
+		ret = iwl_poll_direct_bit(priv, CSR_EEPROM_REG,
+					  CSR_EEPROM_REG_READ_VALID_MSK,
+					  IWL_EEPROM_ACCESS_TIMEOUT);
+		if (ret < 0) {
 			IWL_ERROR("Time out reading EEPROM[%d]\n", addr);
-			ret = -ETIMEDOUT;
 			goto done;
 		}
+		r = _iwl_read_direct32(priv, CSR_EEPROM_REG);
 		e[addr / 2] = le16_to_cpu((__force __le16)(r >> 16));
 	}
 	ret = 0;
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.h b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
index 4b9de7a..603c84b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.h
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
@@ -68,17 +68,14 @@ struct iwl_priv;
 /*
  * EEPROM access time values:
  *
- * Driver initiates EEPROM read by writing byte address << 1 to CSR_EEPROM_REG,
- *   then clearing (with subsequent read/modify/write) CSR_EEPROM_REG bit
- *   CSR_EEPROM_REG_BIT_CMD (0x2).
+ * Driver initiates EEPROM read by writing byte address << 1 to CSR_EEPROM_REG.
  * Driver then polls CSR_EEPROM_REG for CSR_EEPROM_REG_READ_VALID_MSK (0x1).
  * When polling, wait 10 uSec between polling loops, up to a maximum 5000 uSec.
  * Driver reads 16-bit value from bits 31-16 of CSR_EEPROM_REG.
  */
 #define IWL_EEPROM_ACCESS_TIMEOUT	5000 /* uSec */
-#define IWL_EEPROM_ACCESS_DELAY		10   /* uSec */
 
-#define IWL_EEPROM_SEM_TIMEOUT 		10   /* milliseconds */
+#define IWL_EEPROM_SEM_TIMEOUT 		10   /* microseconds */
 #define IWL_EEPROM_SEM_RETRY_LIMIT	1000 /* number of attempts (not time) */
 
 
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 5dcdeeb..3f41836 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -1506,10 +1506,8 @@ int iwl3945_eeprom_init(struct iwl3945_priv *priv)
 {
 	u16 *e = (u16 *)&priv->eeprom;
 	u32 gp = iwl3945_read32(priv, CSR_EEPROM_GP);
-	u32 r;
 	int sz = sizeof(priv->eeprom);
-	int rc;
-	int i;
+	int ret;
 	u16 addr;
 
 	/* The EEPROM structure has several padding buffers within it
@@ -1524,29 +1522,28 @@ int iwl3945_eeprom_init(struct iwl3945_priv *priv)
 	}
 
 	/* Make sure driver (instead of uCode) is allowed to read EEPROM */
-	rc = iwl3945_eeprom_acquire_semaphore(priv);
-	if (rc < 0) {
+	ret = iwl3945_eeprom_acquire_semaphore(priv);
+	if (ret < 0) {
 		IWL_ERROR("Failed to acquire EEPROM semaphore.\n");
 		return -ENOENT;
 	}
 
 	/* eeprom is an array of 16bit values */
 	for (addr = 0; addr < sz; addr += sizeof(u16)) {
-		_iwl3945_write32(priv, CSR_EEPROM_REG, addr << 1);
-		_iwl3945_clear_bit(priv, CSR_EEPROM_REG, CSR_EEPROM_REG_BIT_CMD);
+		u32 r;
 
-		for (i = 0; i < IWL_EEPROM_ACCESS_TIMEOUT;
-					i += IWL_EEPROM_ACCESS_DELAY) {
-			r = _iwl3945_read_direct32(priv, CSR_EEPROM_REG);
-			if (r & CSR_EEPROM_REG_READ_VALID_MSK)
-				break;
-			udelay(IWL_EEPROM_ACCESS_DELAY);
-		}
-
-		if (!(r & CSR_EEPROM_REG_READ_VALID_MSK)) {
+		_iwl3945_write32(priv, CSR_EEPROM_REG,
+				 CSR_EEPROM_REG_MSK_ADDR & (addr << 1));
+		_iwl3945_clear_bit(priv, CSR_EEPROM_REG, CSR_EEPROM_REG_BIT_CMD);
+		ret = iwl3945_poll_direct_bit(priv, CSR_EEPROM_REG,
+					      CSR_EEPROM_REG_READ_VALID_MSK,
+					      IWL_EEPROM_ACCESS_TIMEOUT);
+		if (ret < 0) {
 			IWL_ERROR("Time out reading EEPROM[%d]\n", addr);
-			return -ETIMEDOUT;
+			return ret;
 		}
+
+		r = _iwl3945_read_direct32(priv, CSR_EEPROM_REG);
 		e[addr / 2] = le16_to_cpu((__force __le16)(r >> 16));
 	}
 
-- 
1.5.4.3

