Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:51937 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759716Ab2CGTGg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Mar 2012 14:06:36 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	David Spinadel <david.spinadel@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH RESEND 22/35] iwlwifi: add option to test MFP
Date: Wed,  7 Mar 2012 09:52:31 -0800
Message-Id: <1331142764-5750-23-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120307_200656_269607_FABC2503)
In-Reply-To: <1331142764-5750-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1331142764-5750-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: David Spinadel <david.spinadel@intel.com>

Add a Kconfig symbol to enable MFP for testing even
if the firmware file doesn't advertise it.

Signed-off-by: David Spinadel <david.spinadel@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/Kconfig        |    9 +++++++++
 drivers/net/wireless/iwlwifi/iwl-mac80211.c |    3 +++
 2 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/Kconfig b/drivers/net/wireless/iwlwifi/Kconfig
index 5afd06e..2fe6273 100644
--- a/drivers/net/wireless/iwlwifi/Kconfig
+++ b/drivers/net/wireless/iwlwifi/Kconfig
@@ -127,3 +127,12 @@ config IWLWIFI_P2P
          support when it is loaded.
 
          Say Y only if you want to experiment with P2P.
+
+config IWLWIFI_EXPERIMENTAL_MFP
+	bool "support MFP (802.11w) even if uCode doesn't advertise"
+	depends on IWLWIFI
+	help
+	  This option enables experimental MFP (802.11W) support
+	  even if the microcode doesn't advertise it.
+
+	  Say Y only if you want to experiment with MFP.
diff --git a/drivers/net/wireless/iwlwifi/iwl-mac80211.c b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
index 91a42c3..dcf39f8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-mac80211.c
+++ b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
@@ -163,7 +163,10 @@ int iwlagn_mac_setup_register(struct iwl_priv *priv,
 		hw->flags |= IEEE80211_HW_SUPPORTS_DYNAMIC_SMPS |
 			     IEEE80211_HW_SUPPORTS_STATIC_SMPS;
 
+#ifndef CONFIG_IWLWIFI_EXPERIMENTAL_MFP
+	/* enable 11w if the uCode advertise */
 	if (capa->flags & IWL_UCODE_TLV_FLAGS_MFP)
+#endif /* !CONFIG_IWLWIFI_EXPERIMENTAL_MFP */
 		hw->flags |= IEEE80211_HW_MFP_CAPABLE;
 
 	hw->sta_data_size = sizeof(struct iwl_station_priv);
-- 
1.7.0.4

