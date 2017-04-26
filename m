Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:36863 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1035773AbdDZErB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Apr 2017 00:47:01 -0400
Received: by mail-pf0-f195.google.com with SMTP id v14so12820788pfd.3
        for <linux-wireless@vger.kernel.org>; Tue, 25 Apr 2017 21:47:00 -0700 (PDT)
From: Jason Litzinger <jlitzingerdev@gmail.com>
To: aditya.shankar@microchip.com, ganesh.krishna@microchip.com,
        gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        dan.carpenter@oracle.com, Jason Litzinger <jlitzingerdev@gmail.com>
Subject: [PATCH RFC] staging: wilc1000: Refactor handling of HT caps fields
Date: Tue, 25 Apr 2017 22:46:25 -0600
Message-Id: <20170426044625.20529-1-jlitzingerdev@gmail.com> (sfid-20170426_064730_345245_1DF58A27)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The patch with this RFC addresses the following sparse warnings: 

drivers/staging/wilc1000/wilc_wfi_cfgoperations.c:2006:51: warning: incorrect type in assignment (different base types)
drivers/staging/wilc1000/wilc_wfi_cfgoperations.c:2006:51:    expected unsigned short [unsigned] [assigned] [usertype] ht_capa_info
drivers/staging/wilc1000/wilc_wfi_cfgoperations.c:2006:51:    got restricted __le16 const [usertype] cap_info
drivers/staging/wilc1000/wilc_wfi_cfgoperations.c:2011:52: warning: incorrect type in assignment (different base types)
drivers/staging/wilc1000/wilc_wfi_cfgoperations.c:2011:52:    expected unsigned short [unsigned] [assigned] [usertype] ht_ext_params
drivers/staging/wilc1000/wilc_wfi_cfgoperations.c:2011:52:    got restricted __le16 const [usertype] extended_ht_cap_info
drivers/staging/wilc1000/wilc_wfi_cfgoperations.c:2012:51: warning: incorrect type in assignment (different base types)
drivers/staging/wilc1000/wilc_wfi_cfgoperations.c:2012:51:    expected unsigned int [unsigned] [assigned] [usertype] ht_tx_bf_cap
drivers/staging/wilc1000/wilc_wfi_cfgoperations.c:2012:51:    got restricted __le32 const [usertype] tx_BF_cap_info
drivers/staging/wilc1000/wilc_wfi_cfgoperations.c:2078:51: warning: incorrect type in assignment (different base types)
drivers/staging/wilc1000/wilc_wfi_cfgoperations.c:2078:51:    expected unsigned short [unsigned] [assigned] [usertype] ht_capa_info
drivers/staging/wilc1000/wilc_wfi_cfgoperations.c:2078:51:    got restricted __le16 const [usertype] cap_info
drivers/staging/wilc1000/wilc_wfi_cfgoperations.c:2083:52: warning: incorrect type in assignment (different base types)
drivers/staging/wilc1000/wilc_wfi_cfgoperations.c:2083:52:    expected unsigned short [unsigned] [assigned] [usertype] ht_ext_params
drivers/staging/wilc1000/wilc_wfi_cfgoperations.c:2083:52:    got restricted __le16 const [usertype] extended_ht_cap_info
drivers/staging/wilc1000/wilc_wfi_cfgoperations.c:2084:51: warning: incorrect type in assignment (different base types)
drivers/staging/wilc1000/wilc_wfi_cfgoperations.c:2084:51:    expected unsigned int [unsigned] [assigned] [usertype] ht_tx_bf_cap
drivers/staging/wilc1000/wilc_wfi_cfgoperations.c:2084:51:    got restricted __le32 const [usertype] tx_BF_cap_info

This is not the first attempt to address this problem:
    https://lkml.org/lkml/2017/3/7/808

First, the current code works because the final use of the
ht_capa values (in host_interface.c: WILC_HostIf_PackStaParam) packs them
into a buffer in little-endian format. Since this matches the byte-order of 
struct ieee80211_ht_cap, all is seemingly well.

What the current code does not do, and what these warnings expose, is clearly
communicate what the fields in struct add_sta_param represent -- values
with a specific (little endian) byte order.  This will lead to problems if the
values are ever actually used by the host, and that host is not little endian.

The proposed change addresses this by embedding a struct ieee80211_ht_cap into
struct add_sta_param.  When the values are later packed out, the newly embedded
struct is copied directly into the outbound buffer.  All 16 and 32 bit types are
treated as little endian and marked as such.  Future use of the values by the
host would still require conversion, or sparse would flag them again.  

The following items are required for this to be correct:
    1.  The data is not currently used by the host.
    2.  struct ieee80211_ht_cap is packed.
    3.  The packing of the fields matches the order in struct ieee80211_ht_cap.

This is similar, I believe, to how the same data is handled in
marvell/mwifiex/11n.c.

An alternative would be to convert the values to host byte order and then
convert them back for packing, but since the values are not used elsewhere, that
seemed wasteful.

Test-compiled/loaded against staging-next on x86_64
Test-compiled on ARM
Applied/built against staging-testing.

This is an RFC vs a patch for the following reasons:
    1.  Testing.  I have a WILC1000-SD dev kit, but have some issues to work
        through getting it going on the setups available to me.  In the interim,
        I'd like some feedback as to whether a change like this is even palatable.

    2.  The source field in struct station_parameters is a const pointer to
        struct ieee80211_ht_cap.  I was tempted to embed a const pointer in
        struct add_sta_param, but that would change the semantics away from
        a per-field value copy.  Is there any reason not to embed a const
        pointer?

Regards,
Jason Litzinger

Signed-off-by: Jason Litzinger <jlitzingerdev@gmail.com>
---
Note this leaves in place three checkpatch warnings regarding CamelCase.

 drivers/staging/wilc1000/host_interface.c         | 20 +++-----------------
 drivers/staging/wilc1000/host_interface.h         | 10 ++--------
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 18 ++----------------
 3 files changed, 7 insertions(+), 41 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index c3a8af081880..c8e3229a2809 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -2052,23 +2052,9 @@ static u32 WILC_HostIf_PackStaParam(u8 *pu8Buffer,
 	pu8CurrByte += pstrStationParam->rates_len;
 
 	*pu8CurrByte++ = pstrStationParam->ht_supported;
-	*pu8CurrByte++ = pstrStationParam->ht_capa_info & 0xFF;
-	*pu8CurrByte++ = (pstrStationParam->ht_capa_info >> 8) & 0xFF;
-
-	*pu8CurrByte++ = pstrStationParam->ht_ampdu_params;
-	memcpy(pu8CurrByte, pstrStationParam->ht_supp_mcs_set,
-	       WILC_SUPP_MCS_SET_SIZE);
-	pu8CurrByte += WILC_SUPP_MCS_SET_SIZE;
-
-	*pu8CurrByte++ = pstrStationParam->ht_ext_params & 0xFF;
-	*pu8CurrByte++ = (pstrStationParam->ht_ext_params >> 8) & 0xFF;
-
-	*pu8CurrByte++ = pstrStationParam->ht_tx_bf_cap & 0xFF;
-	*pu8CurrByte++ = (pstrStationParam->ht_tx_bf_cap >> 8) & 0xFF;
-	*pu8CurrByte++ = (pstrStationParam->ht_tx_bf_cap >> 16) & 0xFF;
-	*pu8CurrByte++ = (pstrStationParam->ht_tx_bf_cap >> 24) & 0xFF;
-
-	*pu8CurrByte++ = pstrStationParam->ht_ante_sel;
+	memcpy(pu8CurrByte, &pstrStationParam->ht_capa,
+	       sizeof(struct ieee80211_ht_cap));
+	pu8CurrByte += sizeof(struct ieee80211_ht_cap);
 
 	*pu8CurrByte++ = pstrStationParam->flags_mask & 0xFF;
 	*pu8CurrByte++ = (pstrStationParam->flags_mask >> 8) & 0xFF;
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index f36d3b5a0370..0e72b9193734 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -1,6 +1,6 @@
 #ifndef HOST_INT_H
 #define HOST_INT_H
-
+#include <linux/ieee80211.h>
 #include "coreconfigurator.h"
 
 #define IP_ALEN  4
@@ -47,7 +47,6 @@
 #define ETH_ALEN				6
 #define PMKID_LEN				16
 #define WILC_MAX_NUM_PMKIDS			16
-#define WILC_SUPP_MCS_SET_SIZE			16
 #define WILC_ADD_STA_LENGTH			40
 #define SCAN_EVENT_DONE_ABORTED
 #define NUM_CONCURRENT_IFC			2
@@ -289,12 +288,7 @@ struct add_sta_param {
 	u8 rates_len;
 	const u8 *rates;
 	bool ht_supported;
-	u16 ht_capa_info;
-	u8 ht_ampdu_params;
-	u8 ht_supp_mcs_set[16];
-	u16 ht_ext_params;
-	u32 ht_tx_bf_cap;
-	u8 ht_ante_sel;
+	struct ieee80211_ht_cap ht_capa;
 	u16 flags_mask;
 	u16 flags_set;
 };
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index b02a83bac166..10c018467e8e 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -2003,14 +2003,7 @@ static int add_station(struct wiphy *wiphy, struct net_device *dev,
 			strStaParams.ht_supported = false;
 		} else {
 			strStaParams.ht_supported = true;
-			strStaParams.ht_capa_info = params->ht_capa->cap_info;
-			strStaParams.ht_ampdu_params = params->ht_capa->ampdu_params_info;
-			memcpy(strStaParams.ht_supp_mcs_set,
-			       &params->ht_capa->mcs,
-			       WILC_SUPP_MCS_SET_SIZE);
-			strStaParams.ht_ext_params = params->ht_capa->extended_ht_cap_info;
-			strStaParams.ht_tx_bf_cap = params->ht_capa->tx_BF_cap_info;
-			strStaParams.ht_ante_sel = params->ht_capa->antenna_selection_info;
+			strStaParams.ht_capa = *params->ht_capa;
 		}
 
 		strStaParams.flags_mask = params->sta_flags_mask;
@@ -2075,14 +2068,7 @@ static int change_station(struct wiphy *wiphy, struct net_device *dev,
 			strStaParams.ht_supported = false;
 		} else {
 			strStaParams.ht_supported = true;
-			strStaParams.ht_capa_info = params->ht_capa->cap_info;
-			strStaParams.ht_ampdu_params = params->ht_capa->ampdu_params_info;
-			memcpy(strStaParams.ht_supp_mcs_set,
-			       &params->ht_capa->mcs,
-			       WILC_SUPP_MCS_SET_SIZE);
-			strStaParams.ht_ext_params = params->ht_capa->extended_ht_cap_info;
-			strStaParams.ht_tx_bf_cap = params->ht_capa->tx_BF_cap_info;
-			strStaParams.ht_ante_sel = params->ht_capa->antenna_selection_info;
+			strStaParams.ht_capa = *params->ht_capa;
 		}
 
 		strStaParams.flags_mask = params->sta_flags_mask;
-- 
2.12.1
