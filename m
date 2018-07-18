Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:13402 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725934AbeGSGqA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 19 Jul 2018 02:46:00 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 04/23] staging: wilc1000: remove extra enums defined for ieee80211_eid
Date: Thu, 19 Jul 2018 04:15:00 +0530
Message-ID: <1531953919-20804-5-git-send-email-ajay.kathat@microchip.com> (sfid-20180719_080438_300800_EF074CF6)
In-Reply-To: <1531953919-20804-1-git-send-email-ajay.kathat@microchip.com>
References: <1531953919-20804-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cleanup patch to make use of existing enum 'ieee80211_eid' instead of
adding new enum in WILC for element ID's.

The below mapping is same to remove extra enum in WILC.

SUPP_RATES_IE   	-> WLAN_EID_SUPP_RATES
EXT_SUPP_RATES_IE	-> WLAN_EID_EXT_SUPP_RATES
HT_CAPABILITY_IE	-> WLAN_EID_HT_CAPABILITY
RSN_IE			-> WLAN_EID_RSN
WPA_IE			-> WLAN_EID_VENDOR_SPECIFIC
WMM_IE			-> WLAN_EID_VENDOR_SPECIFIC
P2P_IE			-> WLAN_EID_VENDOR_SPECIFIC

Also remove enum 'info_element_id' as its same as 'ieee80211_eid', below
the mapping of elements of enums which are used.

ITIM -> WLAN_EID_TIM
IDSPARMS -> WLAN_EID_DS_PARAMS

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/coreconfigurator.c | 47 ++---------------------------
 drivers/staging/wilc1000/host_interface.c   | 19 ++++++------
 drivers/staging/wilc1000/wilc_wlan_if.h     | 10 ------
 3 files changed, 12 insertions(+), 64 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index a987953..5933e4d 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -45,49 +45,6 @@ enum sub_frame_type {
 	FRAME_SUBTYPE_FORCE_32BIT  = 0xFFFFFFFF
 };
 
-enum info_element_id {
-	ISSID               = 0,   /* Service Set Identifier         */
-	ISUPRATES           = 1,   /* Supported Rates                */
-	IFHPARMS            = 2,   /* FH parameter set               */
-	IDSPARMS            = 3,   /* DS parameter set               */
-	ICFPARMS            = 4,   /* CF parameter set               */
-	ITIM                = 5,   /* Traffic Information Map        */
-	IIBPARMS            = 6,   /* IBSS parameter set             */
-	ICOUNTRY            = 7,   /* Country element                */
-	IEDCAPARAMS         = 12,  /* EDCA parameter set             */
-	ITSPEC              = 13,  /* Traffic Specification          */
-	ITCLAS              = 14,  /* Traffic Classification         */
-	ISCHED              = 15,  /* Schedule                       */
-	ICTEXT              = 16,  /* Challenge Text                 */
-	IPOWERCONSTRAINT    = 32,  /* Power Constraint               */
-	IPOWERCAPABILITY    = 33,  /* Power Capability               */
-	ITPCREQUEST         = 34,  /* TPC Request                    */
-	ITPCREPORT          = 35,  /* TPC Report                     */
-	ISUPCHANNEL         = 36,  /* Supported channel list         */
-	ICHSWANNOUNC        = 37,  /* Channel Switch Announcement    */
-	IMEASUREMENTREQUEST = 38,  /* Measurement request            */
-	IMEASUREMENTREPORT  = 39,  /* Measurement report             */
-	IQUIET              = 40,  /* Quiet element Info             */
-	IIBSSDFS            = 41,  /* IBSS DFS                       */
-	IERPINFO            = 42,  /* ERP Information                */
-	ITSDELAY            = 43,  /* TS Delay                       */
-	ITCLASPROCESS       = 44,  /* TCLAS Processing               */
-	IHTCAP              = 45,  /* HT Capabilities                */
-	IQOSCAP             = 46,  /* QoS Capability                 */
-	IRSNELEMENT         = 48,  /* RSN Information Element        */
-	IEXSUPRATES         = 50,  /* Extended Supported Rates       */
-	IEXCHSWANNOUNC      = 60,  /* Extended Ch Switch Announcement*/
-	IHTOPERATION        = 61,  /* HT Information                 */
-	ISECCHOFF           = 62,  /* Secondary Channel Offeset      */
-	I2040COEX           = 72,  /* 20/40 Coexistence IE           */
-	I2040INTOLCHREPORT  = 73,  /* 20/40 Intolerant channel report*/
-	IOBSSSCAN           = 74,  /* OBSS Scan parameters           */
-	IEXTCAP             = 127, /* Extended capability            */
-	IWMM                = 221, /* WMM parameters                 */
-	IWPAELEMENT         = 221, /* WPA Information Element        */
-	INFOELEM_ID_FORCE_32BIT  = 0xFFFFFFFF
-};
-
 static inline u16 get_beacon_period(u8 *data)
 {
 	u16 bcn_per;
@@ -216,7 +173,7 @@ static u8 *get_tim_elm(u8 *msa, u16 rx_len, u16 tag_param_offset)
 	index = tag_param_offset;
 
 	while (index < (rx_len - FCS_LEN)) {
-		if (msa[index] == ITIM)
+		if (msa[index] == WLAN_EID_TIM)
 			return &msa[index];
 		index += (IE_HDR_LEN + msa[index + 1]);
 	}
@@ -230,7 +187,7 @@ static u8 get_current_channel_802_11n(u8 *msa, u16 rx_len)
 
 	index = TAG_PARAM_OFFSET;
 	while (index < (rx_len - FCS_LEN)) {
-		if (msa[index] == IDSPARMS)
+		if (msa[index] == WLAN_EID_DS_PARAMS)
 			return msa[index + 2];
 		index += msa[index + 1] + IE_HDR_LEN;
 	}
diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 9b5bf3c..7309b7e 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3861,7 +3861,7 @@ static void host_int_fill_join_bss_param(struct join_bss_param *param, u8 *ies,
 	u8 i, j;
 	u16 index = *out_index;
 
-	if (ies[index] == SUPP_RATES_IE) {
+	if (ies[index] == WLAN_EID_SUPP_RATES) {
 		*rates_no = ies[index + 1];
 		param->supp_rates[0] = *rates_no;
 		index += 2;
@@ -3870,7 +3870,7 @@ static void host_int_fill_join_bss_param(struct join_bss_param *param, u8 *ies,
 			param->supp_rates[i + 1] = ies[index + i];
 
 		index += *rates_no;
-	} else if (ies[index] == EXT_SUPP_RATES_IE) {
+	} else if (ies[index] == WLAN_EID_EXT_SUPP_RATES) {
 		ext_rates_no = ies[index + 1];
 		if (ext_rates_no > (MAX_RATES_SUPPORTED - *rates_no))
 			param->supp_rates[0] = MAX_RATES_SUPPORTED;
@@ -3881,10 +3881,10 @@ static void host_int_fill_join_bss_param(struct join_bss_param *param, u8 *ies,
 			param->supp_rates[*rates_no + i + 1] = ies[index + i];
 
 		index += ext_rates_no;
-	} else if (ies[index] == HT_CAPABILITY_IE) {
+	} else if (ies[index] == WLAN_EID_HT_CAPABILITY) {
 		param->ht_capable = true;
 		index += ies[index + 1] + 2;
-	} else if ((ies[index] == WMM_IE) &&
+	} else if ((ies[index] == WLAN_EID_VENDOR_SPECIFIC) &&
 		   (ies[index + 2] == 0x00) && (ies[index + 3] == 0x50) &&
 		   (ies[index + 4] == 0xF2) && (ies[index + 5] == 0x02) &&
 		   ((ies[index + 6] == 0x00) || (ies[index + 6] == 0x01)) &&
@@ -3894,7 +3894,7 @@ static void host_int_fill_join_bss_param(struct join_bss_param *param, u8 *ies,
 		if (ies[index + 8] & BIT(7))
 			param->uapsd_cap = true;
 		index += ies[index + 1] + 2;
-	} else if ((ies[index] == P2P_IE) &&
+	} else if ((ies[index] == WLAN_EID_VENDOR_SPECIFIC) &&
 		 (ies[index + 2] == 0x50) && (ies[index + 3] == 0x6f) &&
 		 (ies[index + 4] == 0x9a) &&
 		 (ies[index + 5] == 0x09) && (ies[index + 6] == 0x0c)) {
@@ -3923,13 +3923,14 @@ static void host_int_fill_join_bss_param(struct join_bss_param *param, u8 *ies,
 		memcpy(param->start_time, ies + p2p_cnt, 4);
 
 		index += ies[index + 1] + 2;
-	} else if ((ies[index] == RSN_IE) ||
-		 ((ies[index] == WPA_IE) && (ies[index + 2] == 0x00) &&
+	} else if ((ies[index] == WLAN_EID_RSN) ||
+		 ((ies[index] == WLAN_EID_VENDOR_SPECIFIC) &&
+		  (ies[index + 2] == 0x00) &&
 		  (ies[index + 3] == 0x50) && (ies[index + 4] == 0xF2) &&
 		  (ies[index + 5] == 0x01))) {
 		u16 rsn_idx = index;
 
-		if (ies[rsn_idx] == RSN_IE) {
+		if (ies[rsn_idx] == WLAN_EID_RSN) {
 			param->mode_802_11i = 2;
 		} else {
 			if (param->mode_802_11i == 0)
@@ -3970,7 +3971,7 @@ static void host_int_fill_join_bss_param(struct join_bss_param *param, u8 *ies,
 		*auth_total_cnt += auth_cnt;
 		rsn_idx += offset;
 
-		if (ies[index] == RSN_IE) {
+		if (ies[index] == WLAN_EID_RSN) {
 			param->rsn_cap[0] = ies[rsn_idx];
 			param->rsn_cap[1] = ies[rsn_idx + 1];
 			rsn_idx += 2;
diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc1000/wilc_wlan_if.h
index b23f86c..af414d7 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -71,16 +71,6 @@ typedef void (*wilc_tx_complete_func_t)(void *, int);
 #define MAX_SSID_LEN            33
 #define MAX_RATES_SUPPORTED     12
 
-enum {
-	SUPP_RATES_IE		= 1,
-	EXT_SUPP_RATES_IE	= 50,
-	HT_CAPABILITY_IE	= 45,
-	RSN_IE			= 48,
-	WPA_IE			= 221,
-	WMM_IE			= 221,
-	P2P_IE			= 221,
-};
-
 enum bss_types {
 	INFRASTRUCTURE		= 0,
 	INDEPENDENT,
-- 
2.7.4
