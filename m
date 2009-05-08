Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:20126 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756739AbZEHUiY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 May 2009 16:38:24 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 05/11] iwlwifi: more descriptive unsupported hardware message
Date: Fri,  8 May 2009 13:44:40 -0700
Message-Id: <1241815486-13510-6-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1241815486-13510-5-git-send-email-reinette.chatre@intel.com>
References: <1241815486-13510-1-git-send-email-reinette.chatre@intel.com>
 <1241815486-13510-2-git-send-email-reinette.chatre@intel.com>
 <1241815486-13510-3-git-send-email-reinette.chatre@intel.com>
 <1241815486-13510-4-git-send-email-reinette.chatre@intel.com>
 <1241815486-13510-5-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Reinette Chatre <reinette.chatre@intel.com>

Somehow these pre-production cards are showing up in the community.
With this message we hope that it will be clear that the hardware is not
supported.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-eeprom.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.c b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
index 75517d0..401438a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.c
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
@@ -285,7 +285,7 @@ int iwl_eeprom_check_version(struct iwl_priv *priv)
 
 	return 0;
 err:
-	IWL_ERR(priv, "Unsupported EEPROM VER=0x%x < 0x%x CALIB=0x%x < 0x%x\n",
+	IWL_ERR(priv, "Unsupported (too old) EEPROM VER=0x%x < 0x%x CALIB=0x%x < 0x%x\n",
 		  eeprom_ver, priv->cfg->eeprom_ver,
 		  calib_ver,  priv->cfg->eeprom_calib_ver);
 	return -EINVAL;
-- 
1.5.6.3

