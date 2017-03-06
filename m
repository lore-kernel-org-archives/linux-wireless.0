Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:33144 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754231AbdCGAJj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 6 Mar 2017 19:09:39 -0500
Date: Mon, 6 Mar 2017 22:11:21 +0100
From: Andrea Ghittino <aghittino@gmail.com>
To: aditya.shankar@microchip.com, ganesh.krishna@microchip.com,
        gregkh@linuxfoundation.org, linux-wireless@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: wilc1000: Fix sparse warnings incorrect type
 assignment
Message-ID: <20170306211106.GA9885@myhd3> (sfid-20170307_010950_955613_121BA59C)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fixed sparse warnings
drivers/staging/wilc1000//wilc_wfi_cfgoperations.c:2011:52: warning: incorrect type in assignment (different base types)
drivers/staging/wilc1000//wilc_wfi_cfgoperations.c:2011:52:    expected unsigned short [unsigned] [assigned] [usertype] ht_ext_params
drivers/staging/wilc1000//wilc_wfi_cfgoperations.c:2011:52:    got restricted __le16 const [usertype] extended_ht_cap_info
drivers/staging/wilc1000//wilc_wfi_cfgoperations.c:2012:51: warning: incorrect type in assignment (different base types)
drivers/staging/wilc1000//wilc_wfi_cfgoperations.c:2012:51:    expected unsigned int [unsigned] [assigned] [usertype] ht_tx_bf_cap
drivers/staging/wilc1000//wilc_wfi_cfgoperations.c:2012:51:    got restricted __le32 const [usertype] tx_BF_cap_info
drivers/staging/wilc1000//wilc_wfi_cfgoperations.c:2078:51: warning: incorrect type in assignment (different base types)
drivers/staging/wilc1000//wilc_wfi_cfgoperations.c:2078:51:    expected unsigned short [unsigned] [assigned] [usertype] ht_capa_info
drivers/staging/wilc1000//wilc_wfi_cfgoperations.c:2078:51:    got restricted __le16 const [usertype] cap_info
drivers/staging/wilc1000//wilc_wfi_cfgoperations.c:2083:52: warning: incorrect type in assignment (different base types)
drivers/staging/wilc1000//wilc_wfi_cfgoperations.c:2083:52:    expected unsigned short [unsigned] [assigned] [usertype] ht_ext_params
drivers/staging/wilc1000//wilc_wfi_cfgoperations.c:2083:52:    got restricted __le16 const [usertype] extended_ht_cap_info
drivers/staging/wilc1000//wilc_wfi_cfgoperations.c:2084:51: warning: incorrect type in assignment (different base types)
drivers/staging/wilc1000//wilc_wfi_cfgoperations.c:2084:51:    expected unsigned int [unsigned] [assigned] [usertype] ht_tx_bf_cap
drivers/staging/wilc1000//wilc_wfi_cfgoperations.c:2084:51:    got restricted __le32 const [usertype] tx_BF_cap_info


Signed-off-by: Andrea Ghittino <aghittino@gmail.com>
---
Compile tested only

 wilc_wfi_cfgoperations.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 7961d1c..d3b5ac8 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -2003,13 +2003,13 @@ static int add_station(struct wiphy *wiphy, struct net_device *dev,
 			strStaParams.ht_supported = false;
 		} else {
 			strStaParams.ht_supported = true;
-			strStaParams.ht_capa_info = params->ht_capa->cap_info;
+			strStaParams.ht_capa_info = le16_to_cpu(params->ht_capa->cap_info);
 			strStaParams.ht_ampdu_params = params->ht_capa->ampdu_params_info;
 			memcpy(strStaParams.ht_supp_mcs_set,
 			       &params->ht_capa->mcs,
 			       WILC_SUPP_MCS_SET_SIZE);
-			strStaParams.ht_ext_params = params->ht_capa->extended_ht_cap_info;
-			strStaParams.ht_tx_bf_cap = params->ht_capa->tx_BF_cap_info;
+			strStaParams.ht_ext_params = le16_to_cpu(params->ht_capa->extended_ht_cap_info);
+			strStaParams.ht_tx_bf_cap = le32_to_cpu(params->ht_capa->tx_BF_cap_info);
 			strStaParams.ht_ante_sel = params->ht_capa->antenna_selection_info;
 		}
 
@@ -2075,13 +2075,13 @@ static int change_station(struct wiphy *wiphy, struct net_device *dev,
 			strStaParams.ht_supported = false;
 		} else {
 			strStaParams.ht_supported = true;
-			strStaParams.ht_capa_info = params->ht_capa->cap_info;
+			strStaParams.ht_capa_info = le16_to_cpu(params->ht_capa->cap_info);
 			strStaParams.ht_ampdu_params = params->ht_capa->ampdu_params_info;
 			memcpy(strStaParams.ht_supp_mcs_set,
 			       &params->ht_capa->mcs,
 			       WILC_SUPP_MCS_SET_SIZE);
-			strStaParams.ht_ext_params = params->ht_capa->extended_ht_cap_info;
-			strStaParams.ht_tx_bf_cap = params->ht_capa->tx_BF_cap_info;
+			strStaParams.ht_ext_params = le16_to_cpu(params->ht_capa->extended_ht_cap_info);
+			strStaParams.ht_tx_bf_cap = le32_to_cpu(params->ht_capa->tx_BF_cap_info);
 			strStaParams.ht_ante_sel = params->ht_capa->antenna_selection_info;
 		}
 
