Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:20988 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934412AbeEXAHl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 23 May 2018 20:07:41 -0400
From: Adham Abozaeid <adham.abozaeid@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        Ganesh Krishna <Ganesh.Krishna@microchip.com>,
        Robert Jensen Tebbs <Robert.Jensen-Tebbs@microchip.com>,
        Aditya Shankar <Aditya.Shankar@microchip.com>,
        Claudiu Beznea <Claudiu.Beznea@microchip.com>,
        Ajay Kathat <Ajay.Kathat@microchip.com>,
        Adham Abozaeid <adham.abozaeid@microchip.com>
Subject: [PATCH] staging: wilc1000: Avoid overriding rates_no while parsing ies element.
Date: Wed, 23 May 2018 17:02:14 -0700
Message-ID: <1527120134-11058-1-git-send-email-adham.abozaeid@microchip.com> (sfid-20180524_020805_326311_382264A2)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Commit d4b4aaba515a ("staging: wilc1000: fix line over 80 characters in
host_int_parse_join_bss_param()") introduced a bug by not keeping the
rates_no value while parsing ies elements.
It also increments auth_total_cnt as a pointer instead of its reference.

This commit fixes the bug by passing reference to rates_no to
host_int_parse_join_bss_param() and by incrementing reference of
auth_total_cnt

Fixes: d4b4aaba515a (staging: wilc1000: fix line over 80 characters in host_int_parse_join_bss_param())
Signed-off-by: Adham Abozaeid <adham.abozaeid@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index a2f82c8..bf7dd18d 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3813,9 +3813,9 @@ int wilc_setup_multicast_filter(struct wilc_vif *vif, bool enabled,
 
 static void host_int_fill_join_bss_param(struct join_bss_param *param, u8 *ies,
 					 u16 *out_index, u8 *pcipher_tc,
-					 u8 *auth_total_cnt, u32 tsf_lo)
+					 u8 *auth_total_cnt, u32 tsf_lo,
+					 u8 *rates_no)
 {
-	u8 rates_no = 0;
 	u8 ext_rates_no;
 	u16 offset;
 	u8 pcipher_cnt;
@@ -3824,23 +3824,23 @@ static void host_int_fill_join_bss_param(struct join_bss_param *param, u8 *ies,
 	u16 index = *out_index;
 
 	if (ies[index] == SUPP_RATES_IE) {
-		rates_no = ies[index + 1];
-		param->supp_rates[0] = rates_no;
+		*rates_no = ies[index + 1];
+		param->supp_rates[0] = *rates_no;
 		index += 2;
 
-		for (i = 0; i < rates_no; i++)
+		for (i = 0; i < *rates_no; i++)
 			param->supp_rates[i + 1] = ies[index + i];
 
-		index += rates_no;
+		index += *rates_no;
 	} else if (ies[index] == EXT_SUPP_RATES_IE) {
 		ext_rates_no = ies[index + 1];
-		if (ext_rates_no > (MAX_RATES_SUPPORTED - rates_no))
+		if (ext_rates_no > (MAX_RATES_SUPPORTED - *rates_no))
 			param->supp_rates[0] = MAX_RATES_SUPPORTED;
 		else
 			param->supp_rates[0] += ext_rates_no;
 		index += 2;
-		for (i = 0; i < (param->supp_rates[0] - rates_no); i++)
-			param->supp_rates[rates_no + i + 1] = ies[index + i];
+		for (i = 0; i < (param->supp_rates[0] - *rates_no); i++)
+			param->supp_rates[*rates_no + i + 1] = ies[index + i];
 
 		index += ext_rates_no;
 	} else if (ies[index] == HT_CAPABILITY_IE) {
@@ -3929,7 +3929,7 @@ static void host_int_fill_join_bss_param(struct join_bss_param *param, u8 *ies,
 			*policy = ies[rsn_idx + ((j + 1) * 4) - 1];
 		}
 
-		auth_total_cnt += auth_cnt;
+		*auth_total_cnt += auth_cnt;
 		rsn_idx += offset;
 
 		if (ies[index] == RSN_IE) {
@@ -3950,6 +3950,7 @@ static void *host_int_parse_join_bss_param(struct network_info *info)
 {
 	struct join_bss_param *param = NULL;
 	u16 index = 0;
+	u8 rates_no = 0;
 	u8 pcipher_total_cnt = 0;
 	u8 auth_total_cnt = 0;
 
@@ -3969,7 +3970,8 @@ static void *host_int_parse_join_bss_param(struct network_info *info)
 	while (index < info->ies_len)
 		host_int_fill_join_bss_param(param, info->ies, &index,
 					     &pcipher_total_cnt,
-					     &auth_total_cnt, info->tsf_lo);
+					     &auth_total_cnt, info->tsf_lo,
+					     &rates_no);
 
 	return (void *)param;
 }
-- 
2.7.4
