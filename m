Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:40231 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751836AbbE1N4O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 May 2015 09:56:14 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.14.5/8.14.5) with SMTP id t4SDoeBo018844
	for <linux-wireless@vger.kernel.org>; Thu, 28 May 2015 06:56:13 -0700
Received: from sc-owa.marvell.com ([199.233.58.135])
	by mx0b-0016f401.pphosted.com with ESMTP id 1unvy5s24u-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 28 May 2015 06:56:13 -0700
From: Avinash Patil <patila@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: <akarwar@marvell.com>, <cluo@marvell.com>, <huxm@marvell.com>,
	Avinash Patil <patila@marvell.com>
Subject: [PATCH 01/17] mwifiex: verbose logging for association failure messages
Date: Thu, 28 May 2015 18:20:34 +0530
Message-ID: <1432817450-25619-2-git-send-email-patila@marvell.com> (sfid-20150528_155617_727382_8784A19C)
In-Reply-To: <1432817450-25619-1-git-send-email-patila@marvell.com>
References: <1432817450-25619-1-git-send-email-patila@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds more logging support for association failure -
reason and states.

Signed-off-by: Avinash Patil <patila@marvell.com>
---
 drivers/net/wireless/mwifiex/fw.h   | 15 +++++++++++++--
 drivers/net/wireless/mwifiex/join.c | 30 +++++++++++++++++++++++++++---
 2 files changed, 40 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index c404390..6a062dd 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -419,8 +419,12 @@ enum P2P_MODES {
 #define HS_CFG_COND_MAC_EVENT		0x00000004
 #define HS_CFG_COND_MULTICAST_DATA	0x00000008
 
-#define MWIFIEX_TIMEOUT_FOR_AP_RESP		0xfffc
-#define MWIFIEX_STATUS_CODE_AUTH_TIMEOUT	2
+#define ASSOC_ERR_AUTH_ERR_STA_FAILURE		0xFFFB
+#define ASSOC_ERR_ASSOC_ERR_TIMEOUT		0xFFFC
+#define ASSOC_ERR_ASSOC_ERR_AUTH_REFUSED	0xFFFD
+#define ASSOC_ERR_AUTH_MSG_UNHANDLED		0xFFFE
+#define ASSOC_ERR_STA_FAILURE			0xFFFF
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
index 6208ef1..69a44bb 100644
--- a/drivers/net/wireless/mwifiex/join.c
+++ b/drivers/net/wireless/mwifiex/join.c
@@ -556,6 +556,23 @@ int mwifiex_cmd_802_11_associate(struct mwifiex_private *priv,
 	return 0;
 }
 
+static const char *assoc_failure_reason_to_str(u16 cap_info)
+{
+	switch (cap_info) {
+	case ASSOC_ERR_AUTH_ERR_STA_FAILURE:
+		return "ASSOC_ERR_AUTH_ERR_STA_FAILURE";
+	case ASSOC_ERR_AUTH_MSG_UNHANDLED:
+		return "ASSOC_ERR_AUTH_MSG_UNHANDLED";
+	case ASSOC_ERR_ASSOC_ERR_TIMEOUT:
+		return "ASSOC_ERR_ASSOC_ERR_TIMEOUT";
+	case ASSOC_ERR_ASSOC_ERR_AUTH_REFUSED:
+		return "ASSOC_ERR_ASSOC_ERR_AUTH_REFUSED";
+	case ASSOC_ERR_STA_FAILURE:
+		return "ASSOC_ERR_STA_FAILURE";
+	}
+
+	return "Unknown failure";
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
+		if (cap_info == ASSOC_ERR_ASSOC_ERR_TIMEOUT) {
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

