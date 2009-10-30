Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:9059 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757467AbZJ3VgO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Oct 2009 17:36:14 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 01/15] iwlwifi: provide firmware version
Date: Fri, 30 Oct 2009 14:36:04 -0700
Message-Id: <1256938578-9638-2-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1256938578-9638-1-git-send-email-reinette.chatre@intel.com>
References: <1256938578-9638-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Reinette Chatre <reinette.chatre@intel.com>

By setting the firmware version in wiphy it is possible to obtain this
information via ethtool. Some examples,

	    # ethtool -i wlan1
	    driver: iwlagn
	    version: 2.6.32-rc5-wl-56840-g26d8540
	    firmware-version: 228.57.2.23
	    bus-info: 0000:03:00.0
	    # ethtool -i wlan0
	    driver: iwl3945
	    version: 2.6.32-rc5-wl-56840-g26d8540
	    firmware-version: 15.28.2.8
	    bus-info: 0000:02:00.0

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    8 ++++++++
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    8 ++++++++
 2 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 06717fc..1f60d64 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1378,6 +1378,14 @@ static int iwl_read_ucode(struct iwl_priv *priv)
 	       IWL_UCODE_API(priv->ucode_ver),
 	       IWL_UCODE_SERIAL(priv->ucode_ver));
 
+	snprintf(priv->hw->wiphy->fw_version,
+		 sizeof(priv->hw->wiphy->fw_version),
+		 "%u.%u.%u.%u",
+		 IWL_UCODE_MAJOR(priv->ucode_ver),
+		 IWL_UCODE_MINOR(priv->ucode_ver),
+		 IWL_UCODE_API(priv->ucode_ver),
+		 IWL_UCODE_SERIAL(priv->ucode_ver));
+
 	if (build)
 		IWL_DEBUG_INFO(priv, "Build %u\n", build);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index c3b0669..d63a04d 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -2161,6 +2161,14 @@ static int iwl3945_read_ucode(struct iwl_priv *priv)
 		IWL_UCODE_API(priv->ucode_ver),
 		IWL_UCODE_SERIAL(priv->ucode_ver));
 
+	snprintf(priv->hw->wiphy->fw_version,
+		 sizeof(priv->hw->wiphy->fw_version),
+		 "%u.%u.%u.%u",
+		 IWL_UCODE_MAJOR(priv->ucode_ver),
+		 IWL_UCODE_MINOR(priv->ucode_ver),
+		 IWL_UCODE_API(priv->ucode_ver),
+		 IWL_UCODE_SERIAL(priv->ucode_ver));
+
 	IWL_DEBUG_INFO(priv, "f/w package hdr ucode version raw = 0x%x\n",
 		       priv->ucode_ver);
 	IWL_DEBUG_INFO(priv, "f/w package hdr runtime inst size = %u\n",
-- 
1.5.6.3

