Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:52322 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727416AbeGSGqw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 19 Jul 2018 02:46:52 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 19/23] staging: wilc1000: avoid forward declaration of host_int_parse_join_bss_param()
Date: Thu, 19 Jul 2018 04:15:15 +0530
Message-ID: <1531953919-20804-20-git-send-email-ajay.kathat@microchip.com> (sfid-20180719_080529_001831_724E3069)
In-Reply-To: <1531953919-20804-1-git-send-email-ajay.kathat@microchip.com>
References: <1531953919-20804-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Reorder the functions position in host interface to avoid forward
declaration of host_int_parse_join_bss_param().

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 333 +++++++++++++++---------------
 1 file changed, 166 insertions(+), 167 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index f49e849..895a126 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -197,7 +197,6 @@ static u8 set_ip[2][4];
 static u8 get_ip[2][4];
 static u32 clients_count;
 
-static void *host_int_parse_join_bss_param(struct network_info *info);
 static int host_int_get_ipaddress(struct wilc_vif *vif, u8 *ip_addr, u8 idx);
 
 /* 'msg' should be free by the caller for syc */
@@ -1216,6 +1215,172 @@ static void handle_connect_timeout(struct work_struct *work)
 	kfree(msg);
 }
 
+static void host_int_fill_join_bss_param(struct join_bss_param *param, u8 *ies,
+					 u16 *out_index, u8 *pcipher_tc,
+					 u8 *auth_total_cnt, u32 tsf_lo,
+					 u8 *rates_no)
+{
+	u8 ext_rates_no;
+	u16 offset;
+	u8 pcipher_cnt;
+	u8 auth_cnt;
+	u8 i, j;
+	u16 index = *out_index;
+
+	if (ies[index] == WLAN_EID_SUPP_RATES) {
+		*rates_no = ies[index + 1];
+		param->supp_rates[0] = *rates_no;
+		index += 2;
+
+		for (i = 0; i < *rates_no; i++)
+			param->supp_rates[i + 1] = ies[index + i];
+
+		index += *rates_no;
+	} else if (ies[index] == WLAN_EID_EXT_SUPP_RATES) {
+		ext_rates_no = ies[index + 1];
+		if (ext_rates_no > (MAX_RATES_SUPPORTED - *rates_no))
+			param->supp_rates[0] = MAX_RATES_SUPPORTED;
+		else
+			param->supp_rates[0] += ext_rates_no;
+		index += 2;
+		for (i = 0; i < (param->supp_rates[0] - *rates_no); i++)
+			param->supp_rates[*rates_no + i + 1] = ies[index + i];
+
+		index += ext_rates_no;
+	} else if (ies[index] == WLAN_EID_HT_CAPABILITY) {
+		param->ht_capable = true;
+		index += ies[index + 1] + 2;
+	} else if ((ies[index] == WLAN_EID_VENDOR_SPECIFIC) &&
+		   (ies[index + 2] == 0x00) && (ies[index + 3] == 0x50) &&
+		   (ies[index + 4] == 0xF2) && (ies[index + 5] == 0x02) &&
+		   ((ies[index + 6] == 0x00) || (ies[index + 6] == 0x01)) &&
+		   (ies[index + 7] == 0x01)) {
+		param->wmm_cap = true;
+
+		if (ies[index + 8] & BIT(7))
+			param->uapsd_cap = true;
+		index += ies[index + 1] + 2;
+	} else if ((ies[index] == WLAN_EID_VENDOR_SPECIFIC) &&
+		 (ies[index + 2] == 0x50) && (ies[index + 3] == 0x6f) &&
+		 (ies[index + 4] == 0x9a) &&
+		 (ies[index + 5] == 0x09) && (ies[index + 6] == 0x0c)) {
+		u16 p2p_cnt;
+
+		param->tsf = tsf_lo;
+		param->noa_enabled = 1;
+		param->idx = ies[index + 9];
+
+		if (ies[index + 10] & BIT(7)) {
+			param->opp_enabled = 1;
+			param->ct_window = ies[index + 10];
+		} else {
+			param->opp_enabled = 0;
+		}
+
+		param->cnt = ies[index + 11];
+		p2p_cnt = index + 12;
+
+		memcpy(param->duration, ies + p2p_cnt, 4);
+		p2p_cnt += 4;
+
+		memcpy(param->interval, ies + p2p_cnt, 4);
+		p2p_cnt += 4;
+
+		memcpy(param->start_time, ies + p2p_cnt, 4);
+
+		index += ies[index + 1] + 2;
+	} else if ((ies[index] == WLAN_EID_RSN) ||
+		 ((ies[index] == WLAN_EID_VENDOR_SPECIFIC) &&
+		  (ies[index + 2] == 0x00) &&
+		  (ies[index + 3] == 0x50) && (ies[index + 4] == 0xF2) &&
+		  (ies[index + 5] == 0x01))) {
+		u16 rsn_idx = index;
+
+		if (ies[rsn_idx] == WLAN_EID_RSN) {
+			param->mode_802_11i = 2;
+		} else {
+			if (param->mode_802_11i == 0)
+				param->mode_802_11i = 1;
+			rsn_idx += 4;
+		}
+
+		rsn_idx += 7;
+		param->rsn_grp_policy = ies[rsn_idx];
+		rsn_idx++;
+		offset = ies[rsn_idx] * 4;
+		pcipher_cnt = (ies[rsn_idx] > 3) ? 3 : ies[rsn_idx];
+		rsn_idx += 2;
+
+		i = *pcipher_tc;
+		j = 0;
+		for (; i < (pcipher_cnt + *pcipher_tc) && i < 3; i++, j++) {
+			u8 *policy =  &param->rsn_pcip_policy[i];
+
+			*policy = ies[rsn_idx + ((j + 1) * 4) - 1];
+		}
+
+		*pcipher_tc += pcipher_cnt;
+		rsn_idx += offset;
+
+		offset = ies[rsn_idx] * 4;
+
+		auth_cnt = (ies[rsn_idx] > 3) ? 3 : ies[rsn_idx];
+		rsn_idx += 2;
+		i = *auth_total_cnt;
+		j = 0;
+		for (; i < (*auth_total_cnt + auth_cnt); i++, j++) {
+			u8 *policy =  &param->rsn_auth_policy[i];
+
+			*policy = ies[rsn_idx + ((j + 1) * 4) - 1];
+		}
+
+		*auth_total_cnt += auth_cnt;
+		rsn_idx += offset;
+
+		if (ies[index] == WLAN_EID_RSN) {
+			param->rsn_cap[0] = ies[rsn_idx];
+			param->rsn_cap[1] = ies[rsn_idx + 1];
+			rsn_idx += 2;
+		}
+		param->rsn_found = true;
+		index += ies[index + 1] + 2;
+	} else {
+		index += ies[index + 1] + 2;
+	}
+
+	*out_index = index;
+}
+
+static void *host_int_parse_join_bss_param(struct network_info *info)
+{
+	struct join_bss_param *param;
+	u16 index = 0;
+	u8 rates_no = 0;
+	u8 pcipher_total_cnt = 0;
+	u8 auth_total_cnt = 0;
+
+	param = kzalloc(sizeof(*param), GFP_KERNEL);
+	if (!param)
+		return NULL;
+
+	param->dtim_period = info->dtim_period;
+	param->beacon_period = info->beacon_period;
+	param->cap_info = info->cap_info;
+	memcpy(param->bssid, info->bssid, 6);
+	memcpy((u8 *)param->ssid, info->ssid, info->ssid_len + 1);
+	param->ssid_len = info->ssid_len;
+	memset(param->rsn_pcip_policy, 0xFF, 3);
+	memset(param->rsn_auth_policy, 0xFF, 3);
+
+	while (index < info->ies_len)
+		host_int_fill_join_bss_param(param, info->ies, &index,
+					     &pcipher_total_cnt,
+					     &auth_total_cnt, info->tsf_lo,
+					     &rates_no);
+
+	return (void *)param;
+}
+
 static void handle_rcvd_ntwrk_info(struct work_struct *work)
 {
 	struct host_if_msg *msg = container_of(work, struct host_if_msg, work);
@@ -3840,172 +4005,6 @@ int wilc_setup_multicast_filter(struct wilc_vif *vif, bool enabled,
 	return result;
 }
 
-static void host_int_fill_join_bss_param(struct join_bss_param *param, u8 *ies,
-					 u16 *out_index, u8 *pcipher_tc,
-					 u8 *auth_total_cnt, u32 tsf_lo,
-					 u8 *rates_no)
-{
-	u8 ext_rates_no;
-	u16 offset;
-	u8 pcipher_cnt;
-	u8 auth_cnt;
-	u8 i, j;
-	u16 index = *out_index;
-
-	if (ies[index] == WLAN_EID_SUPP_RATES) {
-		*rates_no = ies[index + 1];
-		param->supp_rates[0] = *rates_no;
-		index += 2;
-
-		for (i = 0; i < *rates_no; i++)
-			param->supp_rates[i + 1] = ies[index + i];
-
-		index += *rates_no;
-	} else if (ies[index] == WLAN_EID_EXT_SUPP_RATES) {
-		ext_rates_no = ies[index + 1];
-		if (ext_rates_no > (MAX_RATES_SUPPORTED - *rates_no))
-			param->supp_rates[0] = MAX_RATES_SUPPORTED;
-		else
-			param->supp_rates[0] += ext_rates_no;
-		index += 2;
-		for (i = 0; i < (param->supp_rates[0] - *rates_no); i++)
-			param->supp_rates[*rates_no + i + 1] = ies[index + i];
-
-		index += ext_rates_no;
-	} else if (ies[index] == WLAN_EID_HT_CAPABILITY) {
-		param->ht_capable = true;
-		index += ies[index + 1] + 2;
-	} else if ((ies[index] == WLAN_EID_VENDOR_SPECIFIC) &&
-		   (ies[index + 2] == 0x00) && (ies[index + 3] == 0x50) &&
-		   (ies[index + 4] == 0xF2) && (ies[index + 5] == 0x02) &&
-		   ((ies[index + 6] == 0x00) || (ies[index + 6] == 0x01)) &&
-		   (ies[index + 7] == 0x01)) {
-		param->wmm_cap = true;
-
-		if (ies[index + 8] & BIT(7))
-			param->uapsd_cap = true;
-		index += ies[index + 1] + 2;
-	} else if ((ies[index] == WLAN_EID_VENDOR_SPECIFIC) &&
-		 (ies[index + 2] == 0x50) && (ies[index + 3] == 0x6f) &&
-		 (ies[index + 4] == 0x9a) &&
-		 (ies[index + 5] == 0x09) && (ies[index + 6] == 0x0c)) {
-		u16 p2p_cnt;
-
-		param->tsf = tsf_lo;
-		param->noa_enabled = 1;
-		param->idx = ies[index + 9];
-
-		if (ies[index + 10] & BIT(7)) {
-			param->opp_enabled = 1;
-			param->ct_window = ies[index + 10];
-		} else {
-			param->opp_enabled = 0;
-		}
-
-		param->cnt = ies[index + 11];
-		p2p_cnt = index + 12;
-
-		memcpy(param->duration, ies + p2p_cnt, 4);
-		p2p_cnt += 4;
-
-		memcpy(param->interval, ies + p2p_cnt, 4);
-		p2p_cnt += 4;
-
-		memcpy(param->start_time, ies + p2p_cnt, 4);
-
-		index += ies[index + 1] + 2;
-	} else if ((ies[index] == WLAN_EID_RSN) ||
-		 ((ies[index] == WLAN_EID_VENDOR_SPECIFIC) &&
-		  (ies[index + 2] == 0x00) &&
-		  (ies[index + 3] == 0x50) && (ies[index + 4] == 0xF2) &&
-		  (ies[index + 5] == 0x01))) {
-		u16 rsn_idx = index;
-
-		if (ies[rsn_idx] == WLAN_EID_RSN) {
-			param->mode_802_11i = 2;
-		} else {
-			if (param->mode_802_11i == 0)
-				param->mode_802_11i = 1;
-			rsn_idx += 4;
-		}
-
-		rsn_idx += 7;
-		param->rsn_grp_policy = ies[rsn_idx];
-		rsn_idx++;
-		offset = ies[rsn_idx] * 4;
-		pcipher_cnt = (ies[rsn_idx] > 3) ? 3 : ies[rsn_idx];
-		rsn_idx += 2;
-
-		i = *pcipher_tc;
-		j = 0;
-		for (; i < (pcipher_cnt + *pcipher_tc) && i < 3; i++, j++) {
-			u8 *policy =  &param->rsn_pcip_policy[i];
-
-			*policy = ies[rsn_idx + ((j + 1) * 4) - 1];
-		}
-
-		*pcipher_tc += pcipher_cnt;
-		rsn_idx += offset;
-
-		offset = ies[rsn_idx] * 4;
-
-		auth_cnt = (ies[rsn_idx] > 3) ? 3 : ies[rsn_idx];
-		rsn_idx += 2;
-		i = *auth_total_cnt;
-		j = 0;
-		for (; i < (*auth_total_cnt + auth_cnt); i++, j++) {
-			u8 *policy =  &param->rsn_auth_policy[i];
-
-			*policy = ies[rsn_idx + ((j + 1) * 4) - 1];
-		}
-
-		*auth_total_cnt += auth_cnt;
-		rsn_idx += offset;
-
-		if (ies[index] == WLAN_EID_RSN) {
-			param->rsn_cap[0] = ies[rsn_idx];
-			param->rsn_cap[1] = ies[rsn_idx + 1];
-			rsn_idx += 2;
-		}
-		param->rsn_found = true;
-		index += ies[index + 1] + 2;
-	} else {
-		index += ies[index + 1] + 2;
-	}
-
-	*out_index = index;
-}
-
-static void *host_int_parse_join_bss_param(struct network_info *info)
-{
-	struct join_bss_param *param = NULL;
-	u16 index = 0;
-	u8 rates_no = 0;
-	u8 pcipher_total_cnt = 0;
-	u8 auth_total_cnt = 0;
-
-	param = kzalloc(sizeof(*param), GFP_KERNEL);
-	if (!param)
-		return NULL;
-
-	param->dtim_period = info->dtim_period;
-	param->beacon_period = info->beacon_period;
-	param->cap_info = info->cap_info;
-	memcpy(param->bssid, info->bssid, 6);
-	memcpy((u8 *)param->ssid, info->ssid, info->ssid_len + 1);
-	param->ssid_len = info->ssid_len;
-	memset(param->rsn_pcip_policy, 0xFF, 3);
-	memset(param->rsn_auth_policy, 0xFF, 3);
-
-	while (index < info->ies_len)
-		host_int_fill_join_bss_param(param, info->ies, &index,
-					     &pcipher_total_cnt,
-					     &auth_total_cnt, info->tsf_lo,
-					     &rates_no);
-
-	return (void *)param;
-}
-
 int wilc_setup_ipaddress(struct wilc_vif *vif, u8 *ip_addr, u8 idx)
 {
 	int result = 0;
-- 
2.7.4
