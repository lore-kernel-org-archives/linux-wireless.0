Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:23631 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1425508AbeCBOXk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Mar 2018 09:23:40 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 06/13] staging: wilc1000: fix line over 80 char in host_int_parse_join_bss_param()
Date: Fri, 2 Mar 2018 19:52:42 +0530
Message-ID: <1520000569-27738-7-git-send-email-ajay.kathat@microchip.com> (sfid-20180302_152343_736081_88C533D5)
In-Reply-To: <1520000569-27738-1-git-send-email-ajay.kathat@microchip.com>
References: <1520000569-27738-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix 'line over 80 characters' issue found by checkpatch.pl script.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 216 +++++++++++++++---------------
 1 file changed, 108 insertions(+), 108 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index a15c087..a7fa004 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3904,129 +3904,129 @@ static void *host_int_parse_join_bss_param(struct network_info *info)
 	ies_len = info->ies_len;
 
 	param = kzalloc(sizeof(*param), GFP_KERNEL);
-	if (param) {
-		param->dtim_period = info->dtim_period;
-		param->beacon_period = info->beacon_period;
-		param->cap_info = info->cap_info;
-		memcpy(param->bssid, info->bssid, 6);
-		memcpy((u8 *)param->ssid, info->ssid,
-		       info->ssid_len + 1);
-		param->ssid_len = info->ssid_len;
-		memset(param->rsn_pcip_policy, 0xFF, 3);
-		memset(param->rsn_auth_policy, 0xFF, 3);
-
-		while (index < ies_len) {
-			if (ies[index] == SUPP_RATES_IE) {
-				rates_no = ies[index + 1];
-				param->supp_rates[0] = rates_no;
-				index += 2;
-
-				for (i = 0; i < rates_no; i++)
-					param->supp_rates[i + 1] = ies[index + i];
-
-				index += rates_no;
-			} else if (ies[index] == EXT_SUPP_RATES_IE) {
-				ext_rates_no = ies[index + 1];
-				if (ext_rates_no > (MAX_RATES_SUPPORTED - rates_no))
-					param->supp_rates[0] = MAX_RATES_SUPPORTED;
-				else
-					param->supp_rates[0] += ext_rates_no;
-				index += 2;
-				for (i = 0; i < (param->supp_rates[0] - rates_no); i++)
-					param->supp_rates[rates_no + i + 1] = ies[index + i];
-
-				index += ext_rates_no;
-			} else if (ies[index] == HT_CAPABILITY_IE) {
-				param->ht_capable = true;
-				index += ies[index + 1] + 2;
-			} else if ((ies[index] == WMM_IE) &&
-				   (ies[index + 2] == 0x00) && (ies[index + 3] == 0x50) &&
-				   (ies[index + 4] == 0xF2) &&
-				   (ies[index + 5] == 0x02) &&
-				   ((ies[index + 6] == 0x00) || (ies[index + 6] == 0x01)) &&
-				   (ies[index + 7] == 0x01)) {
-				param->wmm_cap = true;
-
-				if (ies[index + 8] & BIT(7))
-					param->uapsd_cap = true;
-				index += ies[index + 1] + 2;
-			} else if ((ies[index] == P2P_IE) &&
-				 (ies[index + 2] == 0x50) && (ies[index + 3] == 0x6f) &&
-				 (ies[index + 4] == 0x9a) &&
-				 (ies[index + 5] == 0x09) && (ies[index + 6] == 0x0c)) {
-				u16 p2p_cnt;
-
-				param->tsf = info->tsf_lo;
-				param->noa_enabled = 1;
-				param->idx = ies[index + 9];
-
-				if (ies[index + 10] & BIT(7)) {
-					param->opp_enabled = 1;
-					param->ct_window = ies[index + 10];
-				} else {
-					param->opp_enabled = 0;
-				}
+	if (!param)
+		return NULL;
 
-				param->cnt = ies[index + 11];
-				p2p_cnt = index + 12;
+	param->dtim_period = info->dtim_period;
+	param->beacon_period = info->beacon_period;
+	param->cap_info = info->cap_info;
+	memcpy(param->bssid, info->bssid, 6);
+	memcpy((u8 *)param->ssid, info->ssid, info->ssid_len + 1);
+	param->ssid_len = info->ssid_len;
+	memset(param->rsn_pcip_policy, 0xFF, 3);
+	memset(param->rsn_auth_policy, 0xFF, 3);
+
+	while (index < ies_len) {
+		if (ies[index] == SUPP_RATES_IE) {
+			rates_no = ies[index + 1];
+			param->supp_rates[0] = rates_no;
+			index += 2;
+
+			for (i = 0; i < rates_no; i++)
+				param->supp_rates[i + 1] = ies[index + i];
+
+			index += rates_no;
+		} else if (ies[index] == EXT_SUPP_RATES_IE) {
+			ext_rates_no = ies[index + 1];
+			if (ext_rates_no > (MAX_RATES_SUPPORTED - rates_no))
+				param->supp_rates[0] = MAX_RATES_SUPPORTED;
+			else
+				param->supp_rates[0] += ext_rates_no;
+			index += 2;
+			for (i = 0; i < (param->supp_rates[0] - rates_no); i++)
+				param->supp_rates[rates_no + i + 1] = ies[index + i];
+
+			index += ext_rates_no;
+		} else if (ies[index] == HT_CAPABILITY_IE) {
+			param->ht_capable = true;
+			index += ies[index + 1] + 2;
+		} else if ((ies[index] == WMM_IE) &&
+			   (ies[index + 2] == 0x00) && (ies[index + 3] == 0x50) &&
+			   (ies[index + 4] == 0xF2) &&
+			   (ies[index + 5] == 0x02) &&
+			   ((ies[index + 6] == 0x00) || (ies[index + 6] == 0x01)) &&
+			   (ies[index + 7] == 0x01)) {
+			param->wmm_cap = true;
+
+			if (ies[index + 8] & BIT(7))
+				param->uapsd_cap = true;
+			index += ies[index + 1] + 2;
+		} else if ((ies[index] == P2P_IE) &&
+			 (ies[index + 2] == 0x50) && (ies[index + 3] == 0x6f) &&
+			 (ies[index + 4] == 0x9a) &&
+			 (ies[index + 5] == 0x09) && (ies[index + 6] == 0x0c)) {
+			u16 p2p_cnt;
+
+			param->tsf = info->tsf_lo;
+			param->noa_enabled = 1;
+			param->idx = ies[index + 9];
+
+			if (ies[index + 10] & BIT(7)) {
+				param->opp_enabled = 1;
+				param->ct_window = ies[index + 10];
+			} else {
+				param->opp_enabled = 0;
+			}
 
-				memcpy(param->duration, ies + p2p_cnt, 4);
-				p2p_cnt += 4;
+			param->cnt = ies[index + 11];
+			p2p_cnt = index + 12;
 
-				memcpy(param->interval, ies + p2p_cnt, 4);
-				p2p_cnt += 4;
+			memcpy(param->duration, ies + p2p_cnt, 4);
+			p2p_cnt += 4;
 
-				memcpy(param->start_time, ies + p2p_cnt, 4);
+			memcpy(param->interval, ies + p2p_cnt, 4);
+			p2p_cnt += 4;
 
-				index += ies[index + 1] + 2;
-			} else if ((ies[index] == RSN_IE) ||
-				 ((ies[index] == WPA_IE) && (ies[index + 2] == 0x00) &&
-				  (ies[index + 3] == 0x50) && (ies[index + 4] == 0xF2) &&
-				  (ies[index + 5] == 0x01)))	{
-				u16 rsn_idx = index;
+			memcpy(param->start_time, ies + p2p_cnt, 4);
 
-				if (ies[rsn_idx] == RSN_IE)	{
-					param->mode_802_11i = 2;
-				} else {
-					if (param->mode_802_11i == 0)
-						param->mode_802_11i = 1;
-					rsn_idx += 4;
-				}
+			index += ies[index + 1] + 2;
+		} else if ((ies[index] == RSN_IE) ||
+			 ((ies[index] == WPA_IE) && (ies[index + 2] == 0x00) &&
+			  (ies[index + 3] == 0x50) && (ies[index + 4] == 0xF2) &&
+			  (ies[index + 5] == 0x01)))	{
+			u16 rsn_idx = index;
 
-				rsn_idx += 7;
-				param->rsn_grp_policy = ies[rsn_idx];
-				rsn_idx++;
-				offset = ies[rsn_idx] * 4;
-				pcipher_cnt = (ies[rsn_idx] > 3) ? 3 : ies[rsn_idx];
-				rsn_idx += 2;
+			if (ies[rsn_idx] == RSN_IE)	{
+				param->mode_802_11i = 2;
+			} else {
+				if (param->mode_802_11i == 0)
+					param->mode_802_11i = 1;
+				rsn_idx += 4;
+			}
 
-				for (i = pcipher_total_cnt, j = 0; i < pcipher_cnt + pcipher_total_cnt && i < 3; i++, j++)
-					param->rsn_pcip_policy[i] = ies[rsn_idx + ((j + 1) * 4) - 1];
+			rsn_idx += 7;
+			param->rsn_grp_policy = ies[rsn_idx];
+			rsn_idx++;
+			offset = ies[rsn_idx] * 4;
+			pcipher_cnt = (ies[rsn_idx] > 3) ? 3 : ies[rsn_idx];
+			rsn_idx += 2;
 
-				pcipher_total_cnt += pcipher_cnt;
-				rsn_idx += offset;
+			for (i = pcipher_total_cnt, j = 0; i < pcipher_cnt + pcipher_total_cnt && i < 3; i++, j++)
+				param->rsn_pcip_policy[i] = ies[rsn_idx + ((j + 1) * 4) - 1];
 
-				offset = ies[rsn_idx] * 4;
+			pcipher_total_cnt += pcipher_cnt;
+			rsn_idx += offset;
 
-				auth_cnt = (ies[rsn_idx] > 3) ? 3 : ies[rsn_idx];
-				rsn_idx += 2;
+			offset = ies[rsn_idx] * 4;
 
-				for (i = auth_total_cnt, j = 0; i < auth_total_cnt + auth_cnt; i++, j++)
-					param->rsn_auth_policy[i] = ies[rsn_idx + ((j + 1) * 4) - 1];
+			auth_cnt = (ies[rsn_idx] > 3) ? 3 : ies[rsn_idx];
+			rsn_idx += 2;
 
-				auth_total_cnt += auth_cnt;
-				rsn_idx += offset;
+			for (i = auth_total_cnt, j = 0; i < auth_total_cnt + auth_cnt; i++, j++)
+				param->rsn_auth_policy[i] = ies[rsn_idx + ((j + 1) * 4) - 1];
 
-				if (ies[index] == RSN_IE) {
-					param->rsn_cap[0] = ies[rsn_idx];
-					param->rsn_cap[1] = ies[rsn_idx + 1];
-					rsn_idx += 2;
-				}
-				param->rsn_found = true;
-				index += ies[index + 1] + 2;
-			} else {
-				index += ies[index + 1] + 2;
+			auth_total_cnt += auth_cnt;
+			rsn_idx += offset;
+
+			if (ies[index] == RSN_IE) {
+				param->rsn_cap[0] = ies[rsn_idx];
+				param->rsn_cap[1] = ies[rsn_idx + 1];
+				rsn_idx += 2;
 			}
+			param->rsn_found = true;
+			index += ies[index + 1] + 2;
+		} else {
+			index += ies[index + 1] + 2;
 		}
 	}
 
-- 
2.7.4
