Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:36489 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751644AbbLDOOg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Dec 2015 09:14:36 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.15.0.59/8.15.0.59) with SMTP id tB4E9al4029059
	for <linux-wireless@vger.kernel.org>; Fri, 4 Dec 2015 06:14:35 -0800
Received: from sc-exch02.marvell.com ([199.233.58.182])
	by mx0a-0016f401.pphosted.com with ESMTP id 1yk5tpa12f-1
	(version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 04 Dec 2015 06:14:35 -0800
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 1/6] mwifiex: parse adhoc start/join result
Date: Fri, 4 Dec 2015 06:13:02 -0800
Message-ID: <1449238387-27396-1-git-send-email-akarwar@marvell.com> (sfid-20151204_151445_037671_B5FACC2C)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Even if ADHOC start or join attempt is failed, these commands
are returned with success status by firmware. Actual connection
result is provided inside command response.

This patch parses the adhoc connection result and resets
connection state variables if connection is not successful.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/fw.h   | 11 +++++++++--
 drivers/net/wireless/marvell/mwifiex/join.c | 20 +++++++++++++-------
 2 files changed, 22 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/fw.h b/drivers/net/wireless/marvell/mwifiex/fw.h
index 1e1e81a..89938f6 100644
--- a/drivers/net/wireless/marvell/mwifiex/fw.h
+++ b/drivers/net/wireless/marvell/mwifiex/fw.h
@@ -1092,9 +1092,15 @@ struct host_cmd_ds_802_11_ad_hoc_start {
 	u8 data_rate[HOSTCMD_SUPPORTED_RATES];
 } __packed;
 
-struct host_cmd_ds_802_11_ad_hoc_result {
+struct host_cmd_ds_802_11_ad_hoc_start_result {
 	u8 pad[3];
 	u8 bssid[ETH_ALEN];
+	u8 pad2[2];
+	u8 result;
+} __packed;
+
+struct host_cmd_ds_802_11_ad_hoc_join_result {
+	u8 result;
 } __packed;
 
 struct adhoc_bss_desc {
@@ -2124,7 +2130,8 @@ struct host_cmd_ds_command {
 		struct host_cmd_ds_802_11_associate_rsp associate_rsp;
 		struct host_cmd_ds_802_11_deauthenticate deauth;
 		struct host_cmd_ds_802_11_ad_hoc_start adhoc_start;
-		struct host_cmd_ds_802_11_ad_hoc_result adhoc_result;
+		struct host_cmd_ds_802_11_ad_hoc_start_result start_result;
+		struct host_cmd_ds_802_11_ad_hoc_join_result join_result;
 		struct host_cmd_ds_802_11_ad_hoc_join adhoc_join;
 		struct host_cmd_ds_802_11d_domain_info domain_info;
 		struct host_cmd_ds_802_11d_domain_info_rsp domain_info_resp;
diff --git a/drivers/net/wireless/marvell/mwifiex/join.c b/drivers/net/wireless/marvell/mwifiex/join.c
index 3cda1f9..cc09a81 100644
--- a/drivers/net/wireless/marvell/mwifiex/join.c
+++ b/drivers/net/wireless/marvell/mwifiex/join.c
@@ -1247,20 +1247,26 @@ int mwifiex_ret_802_11_ad_hoc(struct mwifiex_private *priv,
 {
 	int ret = 0;
 	struct mwifiex_adapter *adapter = priv->adapter;
-	struct host_cmd_ds_802_11_ad_hoc_result *adhoc_result;
+	struct host_cmd_ds_802_11_ad_hoc_start_result *start_result =
+				&resp->params.start_result;
+	struct host_cmd_ds_802_11_ad_hoc_join_result *join_result =
+				&resp->params.join_result;
 	struct mwifiex_bssdescriptor *bss_desc;
-	u16 reason_code;
+	u16 cmd = le16_to_cpu(resp->command);
+	u8 result;
 
-	adhoc_result = &resp->params.adhoc_result;
+	if (cmd == HostCmd_CMD_802_11_AD_HOC_START)
+		result = start_result->result;
+	else
+		result = join_result->result;
 
 	bss_desc = priv->attempted_bss_desc;
 
 	/* Join result code 0 --> SUCCESS */
-	reason_code = le16_to_cpu(resp->result);
-	if (reason_code) {
+	if (result) {
 		mwifiex_dbg(priv->adapter, ERROR, "ADHOC_RESP: failed\n");
 		if (priv->media_connected)
-			mwifiex_reset_connect_state(priv, reason_code);
+			mwifiex_reset_connect_state(priv, result);
 
 		memset(&priv->curr_bss_params.bss_descriptor,
 		       0x00, sizeof(struct mwifiex_bssdescriptor));
@@ -1278,7 +1284,7 @@ int mwifiex_ret_802_11_ad_hoc(struct mwifiex_private *priv,
 
 		/* Update the created network descriptor with the new BSSID */
 		memcpy(bss_desc->mac_address,
-		       adhoc_result->bssid, ETH_ALEN);
+		       start_result->bssid, ETH_ALEN);
 
 		priv->adhoc_state = ADHOC_STARTED;
 	} else {
-- 
1.8.1.4

