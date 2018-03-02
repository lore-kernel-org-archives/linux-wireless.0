Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:57547 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1425508AbeCBOXY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Mar 2018 09:23:24 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 02/13] staging: wilc1000: remove always 'true' check from 'if' statement
Date: Fri, 2 Mar 2018 19:52:38 +0530
Message-ID: <1520000569-27738-3-git-send-email-ajay.kathat@microchip.com> (sfid-20180302_152329_209514_7962A127)
In-Reply-To: <1520000569-27738-1-git-send-email-ajay.kathat@microchip.com>
References: <1520000569-27738-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix few smatch warning related to 'warn: always true condition'.

handle_cfg_param() warn: always true condition
'(cfg_param_attr->auth_timeout < 65536) => (0-u16max < 65536)'
handle_cfg_param() warn: always true condition
'(cfg_param_attr->rts_threshold < 65536) => (0-u16max < 65536)'
handle_cfg_param() warn: always true condition
'(cfg_param_attr->beacon_interval < 65536) => (0-u16max < 65536)'
handle_cfg_param() warn: always true condition
'(cfg_param_attr->site_survey_scan_time < 65536) => (0-u16max <
65536)'
handle_cfg_param() warn: always true condition
'(cfg_param_attr->active_scan_time < 65536) => (0-u16max < 65536)'
handle_cfg_param() warn: always true condition
'(cfg_param_attr->passive_scan_time < 65536) => (0-u16max < 65536)'

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index b46a759..f992e5d 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -510,8 +510,7 @@ static void handle_cfg_param(struct wilc_vif *vif,
 		i++;
 	}
 	if (cfg_param_attr->flag & AUTHEN_TIMEOUT) {
-		if (cfg_param_attr->auth_timeout > 0 &&
-		    cfg_param_attr->auth_timeout < 65536) {
+		if (cfg_param_attr->auth_timeout > 0) {
 			wid_list[i].id = WID_AUTH_TIMEOUT;
 			wid_list[i].val = (s8 *)&cfg_param_attr->auth_timeout;
 			wid_list[i].type = WID_SHORT;
@@ -579,8 +578,7 @@ static void handle_cfg_param(struct wilc_vif *vif,
 		i++;
 	}
 	if (cfg_param_attr->flag & RTS_THRESHOLD) {
-		if (cfg_param_attr->rts_threshold > 255 &&
-		    cfg_param_attr->rts_threshold < 65536) {
+		if (cfg_param_attr->rts_threshold > 255) {
 			wid_list[i].id = WID_RTS_THRESHOLD;
 			wid_list[i].val = (s8 *)&cfg_param_attr->rts_threshold;
 			wid_list[i].type = WID_SHORT;
@@ -632,8 +630,7 @@ static void handle_cfg_param(struct wilc_vif *vif,
 		i++;
 	}
 	if (cfg_param_attr->flag & BEACON_INTERVAL) {
-		if (cfg_param_attr->beacon_interval > 0 &&
-		    cfg_param_attr->beacon_interval < 65536) {
+		if (cfg_param_attr->beacon_interval > 0) {
 			wid_list[i].id = WID_BEACON_INTERVAL;
 			wid_list[i].val = (s8 *)&cfg_param_attr->beacon_interval;
 			wid_list[i].type = WID_SHORT;
@@ -673,8 +670,7 @@ static void handle_cfg_param(struct wilc_vif *vif,
 		i++;
 	}
 	if (cfg_param_attr->flag & SITE_SURVEY_SCAN_TIME) {
-		if (cfg_param_attr->site_survey_scan_time > 0 &&
-		    cfg_param_attr->site_survey_scan_time < 65536) {
+		if (cfg_param_attr->site_survey_scan_time > 0) {
 			wid_list[i].id = WID_SITE_SURVEY_SCAN_TIME;
 			wid_list[i].val = (s8 *)&cfg_param_attr->site_survey_scan_time;
 			wid_list[i].type = WID_SHORT;
@@ -687,8 +683,7 @@ static void handle_cfg_param(struct wilc_vif *vif,
 		i++;
 	}
 	if (cfg_param_attr->flag & ACTIVE_SCANTIME) {
-		if (cfg_param_attr->active_scan_time > 0 &&
-		    cfg_param_attr->active_scan_time < 65536) {
+		if (cfg_param_attr->active_scan_time > 0) {
 			wid_list[i].id = WID_ACTIVE_SCAN_TIME;
 			wid_list[i].val = (s8 *)&cfg_param_attr->active_scan_time;
 			wid_list[i].type = WID_SHORT;
@@ -701,8 +696,7 @@ static void handle_cfg_param(struct wilc_vif *vif,
 		i++;
 	}
 	if (cfg_param_attr->flag & PASSIVE_SCANTIME) {
-		if (cfg_param_attr->passive_scan_time > 0 &&
-		    cfg_param_attr->passive_scan_time < 65536) {
+		if (cfg_param_attr->passive_scan_time > 0) {
 			wid_list[i].id = WID_PASSIVE_SCAN_TIME;
 			wid_list[i].val = (s8 *)&cfg_param_attr->passive_scan_time;
 			wid_list[i].type = WID_SHORT;
-- 
2.7.4
