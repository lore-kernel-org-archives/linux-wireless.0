Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:44081 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761556AbYBMAsE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Feb 2008 19:48:04 -0500
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 1/1] iwlwifi: reverting 'misc wireless annotations' patch for iwlwifi
Date: Wed, 13 Feb 2008 02:47:54 +0200
Message-Id: <12028636742394-git-send-email-tomas.winkler@intel.com> (sfid-20080213_004815_380099_37997EB8)
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch revert commit blow that wrongly suppressed sparse warning in
iwlwifi eeprom reading
In addtion it suppresses correctly the iwlwifi eeprom register reading anomaly.

commit 45883ae47a0a4700c0f4716dc75a255cccdc3a76
misc wireless annotations
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    4 ++--
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 927f982..53207fa 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -1581,7 +1581,7 @@ static inline int iwl3945_eeprom_acquire_semaphore(struct iwl3945_priv *priv)
  */
 int iwl3945_eeprom_init(struct iwl3945_priv *priv)
 {
-	__le16 *e = (__le16 *)&priv->eeprom;
+	u16 *e = (u16 *)&priv->eeprom;
 	u32 gp = iwl3945_read32(priv, CSR_EEPROM_GP);
 	u32 r;
 	int sz = sizeof(priv->eeprom);
@@ -1624,7 +1624,7 @@ int iwl3945_eeprom_init(struct iwl3945_priv *priv)
 			IWL_ERROR("Time out reading EEPROM[%d]", addr);
 			return -ETIMEDOUT;
 		}
-		e[addr / 2] = cpu_to_le16(r >> 16);
+		e[addr / 2] = le16_to_cpu((__force __le16)(r >> 16));
 	}
 
 	return 0;
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 3fa0bb4..cc11df0 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -1654,7 +1654,7 @@ static inline void iwl4965_eeprom_release_semaphore(struct iwl4965_priv *priv)
  */
 int iwl4965_eeprom_init(struct iwl4965_priv *priv)
 {
-	__le16 *e = (__le16 *)&priv->eeprom;
+	u16 *e = (u16 *)&priv->eeprom;
 	u32 gp = iwl4965_read32(priv, CSR_EEPROM_GP);
 	u32 r;
 	int sz = sizeof(priv->eeprom);
@@ -1698,7 +1698,7 @@ int iwl4965_eeprom_init(struct iwl4965_priv *priv)
 			rc = -ETIMEDOUT;
 			goto done;
 		}
-		e[addr / 2] = cpu_to_le16(r >> 16);
+		e[addr / 2] = le16_to_cpu((__force __le16)(r >> 16));
 	}
 	rc = 0;
 
-- 
1.5.2.2

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

