Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:50336 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751768AbbFCGAb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Jun 2015 02:00:31 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.14.5/8.14.5) with SMTP id t535xXQD028266
	for <linux-wireless@vger.kernel.org>; Tue, 2 Jun 2015 23:00:30 -0700
Received: from sc-owa03.marvell.com ([199.233.58.149])
	by mx0b-0016f401.pphosted.com with ESMTP id 1usqkvggtw-2
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 02 Jun 2015 23:00:30 -0700
From: Avinash Patil <patila@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: <akarwar@marvell.com>, <cluo@marvell.com>, <huxm@marvell.com>,
	Avinash Patil <patila@marvell.com>
Subject: [PATCHv5 01/17] mwifiex: verbose logging for association failure messages
Date: Wed, 3 Jun 2015 16:59:31 +0530
Message-ID: <1433330987-6808-2-git-send-email-patila@marvell.com> (sfid-20150603_080035_183576_87B77437)
In-Reply-To: <1433330987-6808-1-git-send-email-patila@marvell.com>
References: <1433330987-6808-1-git-send-email-patila@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds more detailed information about association failures
 - reason and states.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
---
 drivers/net/wireless/mwifiex/fw.h   | 15 +++++++++++++--
 drivers/net/wireless/mwifiex/join.c | 30 +++++++++++++++++++++++++++---
 2 files changed, 40 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index c404390..cf386bc 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -419,8 +419,12 @@ enum P2P_MODES {
 #define HS_CFG_COND_MAC_EVENT		0x00000004
 #define HS_CFG_COND_MULTICAST_DATA	0x00000008
 
-#define MWIFIEX_TIMEOUT_FOR_AP_RESP		0xfffc
-#define MWIFIEX_STATUS_CODE_AUTH_TIMEOUT	2
+#define CONNECT_ERR_AUTH_ERR_STA_FAILURE	0xFFFB
+#define CONNECT_ERR_ASSOC_ERR_TIMEOUT		0xFFFC
+#define CONNECT_ERR_ASSOC_ERR_AUTH_REFUSED	0xFFFD
+#define CONNECT_ERR_AUTH_MSG_UNHANDLED		0xFFFE
+#define CONNECT_ERR_STA_FAILURE			0xFFFF
+
 
 #define CMD_F_HOSTCMD           (1 << 0)
 #define CMD_F_CANCELED          (1 << 1)
@@ -1151,6 +1155,13 @@ enum SNMP_MIB_INDEX {
 	DOT11H_I = 10,
 };
 
+enum mwifiex_assocmd_failurepoint {
+	MWIFIEX_ASSOC_CMD_SUCCESS = 0,
+	MWIFIEX_ASSOC_CMD_FAILURE_ASSOC,
+	MWIFIEX_ASSOC_CMD_FAILURE_AUTH,
+	MWIFIEX_ASSOC_CMD_FAILURE_JOIN
+};
+
 #define MAX_SNMP_BUF_SIZE   128
 
 struct host_cmd_ds_802_11_snmp_mib {
diff --git a/drivers/net/wireless/mwifiex/join.c b/drivers/net/wireless/mwifiex/join.c
index 6208ef1..e233b04 100644
--- a/drivers/net/wireless/mwifiex/join.c
+++ b/drivers/net/wireless/mwifiex/join.c
@@ -556,6 +556,23 @@ int mwifiex_cmd_802_11_associate(struct mwifiex_private *priv,
 	return 0;
 }
 
+static const char *assoc_failure_reason_to_str(u16 cap_info)
+{
+	switch (cap_info) {
+	case CONNECT_ERR_AUTH_ERR_STA_FAILURE:
+		return "CONNECT_ERR_AUTH_ERR_STA_FAILURE";
+	case CONNECT_ERR_AUTH_MSG_UNHANDLED:
+		return "CONNECT_ERR_AUTH_MSG_UNHANDLED";
+	case CONNECT_ERR_ASSOC_ERR_TIMEOUT:
+		return "CONNECT_ERR_ASSOC_ERR_TIMEOUT";
+	case CONNECT_ERR_ASSOC_ERR_AUTH_REFUSED:
+		return "CONNECT_ERR_ASSOC_ERR_AUTH_REFUSED";
+	case CONNECT_ERR_STA_FAILURE:
+		return "CONNECT_ERR_STA_FAILURE";
+	}
+
+	return "Unknown connect failure";
+}
 /*
  * Association firmware command response handler
  *
@@ -656,11 +673,18 @@ int mwifiex_ret_802_11_associate(struct mwifiex_private *priv,
 			    status_code, cap_info,
 			    le16_to_cpu(assoc_rsp->a_id));
 
-		if (cap_info == MWIFIEX_TIMEOUT_FOR_AP_RESP) {
-			if (status_code == MWIFIEX_STATUS_CODE_AUTH_TIMEOUT)
+		mwifiex_dbg(priv->adapter, ERROR, "assoc failure: reason %s\n",
+			    assoc_failure_reason_to_str(cap_info));
+		if (cap_info == CONNECT_ERR_ASSOC_ERR_TIMEOUT) {
+			if (status_code == MWIFIEX_ASSOC_CMD_FAILURE_AUTH) {
 				ret = WLAN_STATUS_AUTH_TIMEOUT;
-			else
+				mwifiex_dbg(priv->adapter, ERROR,
+					    "ASSOC_RESP: AUTH timeout\n");
+			} else {
 				ret = WLAN_STATUS_UNSPECIFIED_FAILURE;
+				mwifiex_dbg(priv->adapter, ERROR,
+					    "ASSOC_RESP: UNSPECIFIED failure\n");
+			}
 		} else {
 			ret = status_code;
 		}
-- 
1.8.1.4

