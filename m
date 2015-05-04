Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:37115 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750715AbbEDLK2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 May 2015 07:10:28 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.14.5/8.14.5) with SMTP id t44B9GQ1010234
	for <linux-wireless@vger.kernel.org>; Mon, 4 May 2015 04:10:27 -0700
Received: from sc-owa04.marvell.com ([199.233.58.150])
	by mx0a-0016f401.pphosted.com with ESMTP id 1u60sk8xhm-2
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 04 May 2015 04:10:27 -0700
From: Avinash Patil <patila@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: <akarwar@marvell.com>, <cluo@marvell.com>, <huxm@marvell.com>,
	Avinash Patil <patila@marvell.com>
Subject: [PATCH] mwifiex: parsing aid while receiving association response
Date: Mon, 4 May 2015 22:10:08 +0530
Message-ID: <1430757608-2365-1-git-send-email-patila@marvell.com> (sfid-20150504_131031_396720_FD29F625)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Xinming Hu <huxm@marvell.com>

cfg80211 would complain about invalid AID in during TDLS setup.
This was happening because we use same AID value as provide by AP
while forming setup messages.
Parse AID from Association response and filter BIT14 and BIT15
of AID to get valid AID.

Signed-off-by: Xinming Hu <huxm@marvell.com>
Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
---
 drivers/net/wireless/mwifiex/join.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mwifiex/join.c b/drivers/net/wireless/mwifiex/join.c
index 411a6c2..f214a7c 100644
--- a/drivers/net/wireless/mwifiex/join.c
+++ b/drivers/net/wireless/mwifiex/join.c
@@ -621,18 +621,28 @@ int mwifiex_ret_802_11_associate(struct mwifiex_private *priv,
 	struct ieee_types_assoc_rsp *assoc_rsp;
 	struct mwifiex_bssdescriptor *bss_desc;
 	bool enable_data = true;
-	u16 cap_info, status_code;
+	u16 cap_info, status_code, aid;
 
 	assoc_rsp = (struct ieee_types_assoc_rsp *) &resp->params;
 
 	cap_info = le16_to_cpu(assoc_rsp->cap_info_bitmap);
 	status_code = le16_to_cpu(assoc_rsp->status_code);
+	aid = le16_to_cpu(assoc_rsp->a_id);
+
+	if ((aid & (BIT(15) | BIT(14))) != (BIT(15) | BIT(14)))
+		dev_err(priv->adapter->dev,
+			"invalid AID value 0x%x; bits 15:14 not set\n",
+			aid);
+
+	aid &= ~(BIT(15) | BIT(14));
 
 	priv->assoc_rsp_size = min(le16_to_cpu(resp->size) - S_DS_GEN,
 				   sizeof(priv->assoc_rsp_buf));
 
 	memcpy(priv->assoc_rsp_buf, &resp->params, priv->assoc_rsp_size);
 
+	assoc_rsp->a_id = cpu_to_le16(aid);
+
 	if (status_code) {
 		priv->adapter->dbg.num_cmd_assoc_failure++;
 		dev_err(priv->adapter->dev,
-- 
1.8.1.4

