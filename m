Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41081 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754662Ab2J3IHK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Oct 2012 04:07:10 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Assaf Krauss <assaf.krauss@intel.com>
Subject: [PATCH 2/4] iwlwifi: remove MFP Kconfig option
Date: Tue, 30 Oct 2012 09:07:41 +0100
Message-Id: <1351584463-11469-3-git-send-email-johannes@sipsolutions.net> (sfid-20121030_090728_057395_2507D638)
In-Reply-To: <1351584463-11469-1-git-send-email-johannes@sipsolutions.net>
References: <1351584463-11469-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Assaf Krauss <assaf.krauss@intel.com>

Remove the Kconfig option CONFIG_IWLWIFI_EXPERIMENTAL_MFP,
if the firmware doesn't support MFP then the user shouldn't
have the option to enable it as it won't work correctly.

Signed-off-by: Assaf Krauss <assaf.krauss@intel.com>
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/Kconfig        |    9 ---------
 drivers/net/wireless/iwlwifi/dvm/mac80211.c |    2 --
 2 files changed, 11 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/Kconfig b/drivers/net/wireless/iwlwifi/Kconfig
index 727fbb5..5cf4323 100644
--- a/drivers/net/wireless/iwlwifi/Kconfig
+++ b/drivers/net/wireless/iwlwifi/Kconfig
@@ -133,12 +133,3 @@ config IWLWIFI_P2P
 	  support when it is loaded.
 
 	  Say Y only if you want to experiment with P2P.
-
-config IWLWIFI_EXPERIMENTAL_MFP
-	bool "support MFP (802.11w) even if uCode doesn't advertise"
-	depends on IWLWIFI
-	help
-	  This option enables experimental MFP (802.11W) support
-	  even if the microcode doesn't advertise it.
-
-	  Say Y only if you want to experiment with MFP.
diff --git a/drivers/net/wireless/iwlwifi/dvm/mac80211.c b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
index ff8162d..46b0d1c 100644
--- a/drivers/net/wireless/iwlwifi/dvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
@@ -168,10 +168,8 @@ int iwlagn_mac_setup_register(struct iwl_priv *priv,
 		hw->flags |= IEEE80211_HW_SUPPORTS_DYNAMIC_SMPS |
 			     IEEE80211_HW_SUPPORTS_STATIC_SMPS;
 
-#ifndef CONFIG_IWLWIFI_EXPERIMENTAL_MFP
 	/* enable 11w if the uCode advertise */
 	if (capa->flags & IWL_UCODE_TLV_FLAGS_MFP)
-#endif /* !CONFIG_IWLWIFI_EXPERIMENTAL_MFP */
 		hw->flags |= IEEE80211_HW_MFP_CAPABLE;
 
 	hw->sta_data_size = sizeof(struct iwl_station_priv);
-- 
1.7.10.4

