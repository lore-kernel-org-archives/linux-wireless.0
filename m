Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:24719 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752949AbZGaV2L (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jul 2009 17:28:11 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Jay Sternberg <jay.e.sternberg@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 4/4] iwlwifi: remove duplicated version info from sysfs
Date: Fri, 31 Jul 2009 14:28:09 -0700
Message-Id: <1249075689-8973-5-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1249075689-8973-1-git-send-email-reinette.chatre@intel.com>
References: <1249075689-8973-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jay Sternberg <jay.e.sternberg@intel.com>

version info in sysfs had been determined to be unnecessary as it
is already provided in syslog info.  nvm version is added to syslog
version info as a debug level message to provide all info that was
in the version sysfs data.

Signed-off-by: Jay Sternberg <jay.e.sternberg@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |   40 ++++---------------------------
 1 files changed, 6 insertions(+), 34 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 467c861..db580cb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1291,6 +1291,7 @@ static int iwl_read_ucode(struct iwl_priv *priv)
 	size_t len;
 	u32 api_ver, build;
 	u32 inst_size, data_size, init_size, init_data_size, boot_size;
+	u16 eeprom_ver;
 
 	/* Ask kernel firmware_class module to get the boot firmware off disk.
 	 * request_firmware() is synchronous, file is in memory on return. */
@@ -1368,6 +1369,11 @@ static int iwl_read_ucode(struct iwl_priv *priv)
 	if (build)
 		IWL_DEBUG_INFO(priv, "Build %u\n", build);
 
+	eeprom_ver = iwl_eeprom_query16(priv, EEPROM_VERSION);
+	IWL_DEBUG_INFO(priv, "NVM Type: %s, version: 0x%x\n",
+		       (priv->nvm_device_type == NVM_DEVICE_TYPE_OTP)
+		       ? "OTP" : "EEPROM", eeprom_ver);
+
 	IWL_DEBUG_INFO(priv, "f/w package hdr ucode version raw = 0x%x\n",
 		       priv->ucode_ver);
 	IWL_DEBUG_INFO(priv, "f/w package hdr runtime inst size = %u\n",
@@ -2483,39 +2489,6 @@ static DEVICE_ATTR(debug_level, S_IWUSR | S_IRUGO,
 #endif /* CONFIG_IWLWIFI_DEBUG */
 
 
-static ssize_t show_version(struct device *d,
-				struct device_attribute *attr, char *buf)
-{
-	struct iwl_priv *priv = dev_get_drvdata(d);
-	struct iwl_alive_resp *palive = &priv->card_alive;
-	ssize_t pos = 0;
-	u16 eeprom_ver;
-
-	if (palive->is_valid)
-		pos += sprintf(buf + pos,
-				"fw version: 0x%01X.0x%01X.0x%01X.0x%01X\n"
-				"fw type: 0x%01X 0x%01X\n",
-				palive->ucode_major, palive->ucode_minor,
-				palive->sw_rev[0], palive->sw_rev[1],
-				palive->ver_type, palive->ver_subtype);
-	else
-		pos += sprintf(buf + pos, "fw not loaded\n");
-
-	if (priv->eeprom) {
-		eeprom_ver = iwl_eeprom_query16(priv, EEPROM_VERSION);
-		pos += sprintf(buf + pos, "NVM Type: %s, version: 0x%x\n",
-			       (priv->nvm_device_type == NVM_DEVICE_TYPE_OTP)
-			       ? "OTP" : "EEPROM", eeprom_ver);
-
-	} else {
-		pos += sprintf(buf + pos, "EEPROM not initialzed\n");
-	}
-
-	return pos;
-}
-
-static DEVICE_ATTR(version, S_IWUSR | S_IRUGO, show_version, NULL);
-
 static ssize_t show_temperature(struct device *d,
 				struct device_attribute *attr, char *buf)
 {
@@ -2779,7 +2752,6 @@ static struct attribute *iwl_sysfs_entries[] = {
 #ifdef CONFIG_IWLWIFI_DEBUG
 	&dev_attr_debug_level.attr,
 #endif
-	&dev_attr_version.attr,
 	NULL
 };
 
-- 
1.5.6.3

