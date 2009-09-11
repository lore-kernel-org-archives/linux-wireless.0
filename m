Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:49357 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755718AbZIKRiU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Sep 2009 13:38:20 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 10/13] iwlwifi: show NVM version in debugfs
Date: Fri, 11 Sep 2009 10:38:16 -0700
Message-Id: <1252690699-25796-11-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1252690699-25796-1-git-send-email-reinette.chatre@intel.com>
References: <1252690699-25796-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Show version number along with dumping NVM data, the version information
being removed from sysfs, add it back to debugfs to help debugging.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-debugfs.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index fb84485..1a0337f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -383,6 +383,7 @@ static ssize_t iwl_dbgfs_nvm_read(struct file *file,
 	int pos = 0, ofs = 0, buf_size = 0;
 	const u8 *ptr;
 	char *buf;
+	u16 eeprom_ver;
 	size_t eeprom_len = priv->cfg->eeprom_size;
 	buf_size = 4 * eeprom_len + 256;
 
@@ -403,9 +404,11 @@ static ssize_t iwl_dbgfs_nvm_read(struct file *file,
 		IWL_ERR(priv, "Can not allocate Buffer\n");
 		return -ENOMEM;
 	}
-	pos += scnprintf(buf + pos, buf_size - pos, "NVM Type: %s\n",
+	eeprom_ver = iwl_eeprom_query16(priv, EEPROM_VERSION);
+	pos += scnprintf(buf + pos, buf_size - pos, "NVM Type: %s, "
+			"version: 0x%x\n",
 			(priv->nvm_device_type == NVM_DEVICE_TYPE_OTP)
-			? "OTP" : "EEPROM");
+			 ? "OTP" : "EEPROM", eeprom_ver);
 	for (ofs = 0 ; ofs < eeprom_len ; ofs += 16) {
 		pos += scnprintf(buf + pos, buf_size - pos, "0x%.4x ", ofs);
 		hex_dump_to_buffer(ptr + ofs, 16 , 16, 2, buf + pos,
-- 
1.5.6.3

