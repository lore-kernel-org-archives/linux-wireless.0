Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:61667 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752339AbcFPNXu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jun 2016 09:23:50 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u5GDM9Ra019733
	for <linux-wireless@vger.kernel.org>; Thu, 16 Jun 2016 06:23:49 -0700
Received: from sc-exch04.marvell.com ([199.233.58.184])
	by mx0b-0016f401.pphosted.com with ESMTP id 23gj5fs01c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 16 Jun 2016 06:23:49 -0700
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Nishant Sarmukadam <nishants@marvell.com>,
	Cathy Luo <cluo@marvell.com>,
	Ganapathi Bhat <gbhat@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 1/6] mwifiex: Fix an issue spotted by KASAN
Date: Thu, 16 Jun 2016 18:52:21 +0530
Message-ID: <1466083346-18607-1-git-send-email-akarwar@marvell.com> (sfid-20160616_152352_791126_165DD4DB)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ganapathi Bhat <gbhat@marvell.com>

When an association command is sent to firmware but the process is
killed before the command response arrives, driver will try to
access bss_desc which is already freed. This issue is fixed by
checking return value of bss_start.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/join.c      | 12 ++++++++++++
 drivers/net/wireless/marvell/mwifiex/sta_ioctl.c |  4 ++++
 2 files changed, 16 insertions(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/join.c b/drivers/net/wireless/marvell/mwifiex/join.c
index a4b773d..1c7b006 100644
--- a/drivers/net/wireless/marvell/mwifiex/join.c
+++ b/drivers/net/wireless/marvell/mwifiex/join.c
@@ -647,6 +647,12 @@ int mwifiex_ret_802_11_associate(struct mwifiex_private *priv,
 	const u8 *ie_ptr;
 	struct ieee80211_ht_operation *assoc_resp_ht_oper;
 
+	if (!priv->attempted_bss_desc) {
+		mwifiex_dbg(priv->adapter, ERROR,
+			    "ASSOC_RESP: failed, association terminated by host\n");
+		goto done;
+	}
+
 	assoc_rsp = (struct ieee_types_assoc_rsp *) &resp->params;
 
 	cap_info = le16_to_cpu(assoc_rsp->cap_info_bitmap);
@@ -1270,6 +1276,12 @@ int mwifiex_ret_802_11_ad_hoc(struct mwifiex_private *priv,
 	u16 cmd = le16_to_cpu(resp->command);
 	u8 result;
 
+	if (!priv->attempted_bss_desc) {
+		mwifiex_dbg(priv->adapter, ERROR,
+			    "ADHOC_RESP: failed, association terminated by host\n");
+		goto done;
+	}
+
 	if (cmd == HostCmd_CMD_802_11_AD_HOC_START)
 		result = start_result->result;
 	else
diff --git a/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c b/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c
index 8e08626..2ba5397 100644
--- a/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c
@@ -426,6 +426,10 @@ done:
 	if (bss_desc)
 		kfree(bss_desc->beacon_buf);
 	kfree(bss_desc);
+
+	if (ret < 0)
+		priv->attempted_bss_desc = NULL;
+
 	return ret;
 }
 
-- 
1.9.1

