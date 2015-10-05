Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:9000 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752208AbbJEG1r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Oct 2015 02:27:47 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 16/18] staging: wilc1000: wilc_wfi_cfgoperations.c : remove unused functions
Date: Mon, 5 Oct 2015 15:25:51 +0900
Message-ID: <1444026353-29024-16-git-send-email-tony.cho@atmel.com> (sfid-20151005_082750_510774_4CAC1ABB)
In-Reply-To: <1444026353-29024-1-git-send-email-tony.cho@atmel.com>
References: <1444026353-29024-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch removes unused functions from the wilc_wfi_cfgoperations.c.
 - WILC_WFI_dump_survey
 - WILC_WFI_auth
 - WILC_WFI_assoc
 - WILC_WFI_deauth
 - WILC_WFI_disassoc
 - WILC_WFI_set_bitrate_mask

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 109 ----------------------
 1 file changed, 109 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 5905040..2f67546 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -1533,31 +1533,6 @@ static int set_default_key(struct wiphy *wiphy, struct net_device *netdev, u8 ke
 }
 
 /**
- *  @brief      WILC_WFI_dump_survey
- *  @details    Get site survey information
- *  @param[in]
- *  @return     int : Return 0 on Success.
- *  @author	mdaftedar
- *  @date	01 MAR 2012
- *  @version	1.0
- */
-static int WILC_WFI_dump_survey(struct wiphy *wiphy, struct net_device *netdev,
-				int idx, struct survey_info *info)
-{
-	s32 s32Error = 0;
-
-
-	if (idx != 0) {
-		s32Error = -ENOENT;
-		PRINT_ER("Error Idx value doesn't equal zero: Error(%d)\n", s32Error);
-
-	}
-
-	return s32Error;
-}
-
-
-/**
  *  @brief      get_station
  *  @details    Get station information for the station identified by @mac
  *  @param[in]   NONE
@@ -1666,70 +1641,6 @@ static int change_bss(struct wiphy *wiphy, struct net_device *dev,
 }
 
 /**
- *  @brief      WILC_WFI_auth
- *  @details    Request to authenticate with the specified peer
- *  @param[in]
- *  @return     int : Return 0 on Success.
- *  @author	mdaftedar
- *  @date	01 MAR 2012
- *  @version	1.0
- */
-static int WILC_WFI_auth(struct wiphy *wiphy, struct net_device *dev,
-			 struct cfg80211_auth_request *req)
-{
-	PRINT_D(CFG80211_DBG, "In Authentication Function\n");
-	return 0;
-}
-
-/**
- *  @brief      WILC_WFI_assoc
- *  @details    Request to (re)associate with the specified peer
- *  @param[in]
- *  @return     int : Return 0 on Success.
- *  @author	mdaftedar
- *  @date	01 MAR 2012
- *  @version	1.0
- */
-static int WILC_WFI_assoc(struct wiphy *wiphy, struct net_device *dev,
-			  struct cfg80211_assoc_request *req)
-{
-	PRINT_D(CFG80211_DBG, "In Association Function\n");
-	return 0;
-}
-
-/**
- *  @brief      WILC_WFI_deauth
- *  @details    Request to deauthenticate from the specified peer
- *  @param[in]
- *  @return     int : Return 0 on Success.
- *  @author	mdaftedar
- *  @date	01 MAR 2012
- *  @version	1.0
- */
-static int  WILC_WFI_deauth(struct wiphy *wiphy, struct net_device *dev,
-			    struct cfg80211_deauth_request *req, void *cookie)
-{
-	PRINT_D(CFG80211_DBG, "In De-authentication Function\n");
-	return 0;
-}
-
-/**
- *  @brief      WILC_WFI_disassoc
- *  @details    Request to disassociate from the specified peer
- *  @param[in]
- *  @return     int : Return 0 on Success
- *  @author	mdaftedar
- *  @date	01 MAR 2012
- *  @version	1.0
- */
-static int  WILC_WFI_disassoc(struct wiphy *wiphy, struct net_device *dev,
-			      struct cfg80211_disassoc_request *req, void *cookie)
-{
-	PRINT_D(CFG80211_DBG, "In Disassociation Function\n");
-	return 0;
-}
-
-/**
  *  @brief      set_wiphy_params
  *  @details    Notify that wiphy parameters have changed;
  *  @param[in]   Changed bitfield (see &enum wiphy_params_flags) describes which values
@@ -1788,26 +1699,6 @@ static int set_wiphy_params(struct wiphy *wiphy, u32 changed)
 }
 
 /**
- *  @brief      WILC_WFI_set_bitrate_mask
- *  @details    set the bitrate mask configuration
- *  @param[in]
- *  @return     int : Return 0 on Success
- *  @author	mdaftedar
- *  @date	01 MAR 2012
- *  @version	1.0
- */
-static int WILC_WFI_set_bitrate_mask(struct wiphy *wiphy,
-				     struct net_device *dev, const u8 *peer,
-				     const struct cfg80211_bitrate_mask *mask)
-{
-	s32 s32Error = 0;
-
-	PRINT_D(CFG80211_DBG, "Setting Bitrate mask function\n");
-	return s32Error;
-
-}
-
-/**
  *  @brief      set_pmksa
  *  @details    Cache a PMKID for a BSSID. This is mostly useful for fullmac
  *                      devices running firmwares capable of generating the (re) association
-- 
1.9.1

