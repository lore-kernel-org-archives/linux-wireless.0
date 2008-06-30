Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:24090 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754302AbYF3J0S (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jun 2008 05:26:18 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 02/33] iwlwifi: Add eeprom version to the version file in sysfs
Date: Mon, 30 Jun 2008 17:23:02 +0800
Message-Id: <1214817813-17639-3-git-send-email-yi.zhu@intel.com> (sfid-20080630_112620_738967_30BEFA77)
In-Reply-To: <1214817813-17639-2-git-send-email-yi.zhu@intel.com>
References: <1214817813-17639-1-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-2-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch adds eeprom version display into device/version sysfs file
/sys/class/net/wlanX/devices/version

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   20 ++++++++++++++++----
 1 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index f591168..6eee28d 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -3728,16 +3728,28 @@ static ssize_t show_version(struct device *d,
 {
 	struct iwl_priv *priv = d->driver_data;
 	struct iwl_alive_resp *palive = &priv->card_alive;
+	ssize_t pos = 0;
+	u16 eeprom_ver;
 
 	if (palive->is_valid)
-		return sprintf(buf, "fw version: 0x%01X.0x%01X.0x%01X.0x%01X\n"
-				    "fw type: 0x%01X 0x%01X\n",
+		pos += sprintf(buf + pos,
+				"fw version: 0x%01X.0x%01X.0x%01X.0x%01X\n"
+				"fw type: 0x%01X 0x%01X\n",
 				palive->ucode_major, palive->ucode_minor,
 				palive->sw_rev[0], palive->sw_rev[1],
 				palive->ver_type, palive->ver_subtype);
-
 	else
-		return sprintf(buf, "fw not loaded\n");
+		pos += sprintf(buf + pos, "fw not loaded\n");
+
+	if (priv->eeprom) {
+		eeprom_ver = iwl_eeprom_query16(priv, EEPROM_VERSION);
+		pos += sprintf(buf + pos, "EEPROM version: 0x%x\n",
+				 eeprom_ver);
+	} else {
+		pos += sprintf(buf + pos, "EEPROM not initialzed\n");
+	}
+
+	return pos;
 }
 
 static DEVICE_ATTR(version, S_IWUSR | S_IRUGO, show_version, NULL);
-- 
1.5.3.6

