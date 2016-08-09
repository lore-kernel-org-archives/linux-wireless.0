Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:30107 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752279AbcHIOv1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Aug 2016 10:51:27 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u79EnPTX019959
	for <linux-wireless@vger.kernel.org>; Tue, 9 Aug 2016 07:51:26 -0700
Received: from sc-exch01.marvell.com ([199.233.58.181])
	by mx0a-0016f401.pphosted.com with ESMTP id 24nd8q5cud-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 09 Aug 2016 07:51:25 -0700
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Xinming Hu <huxm@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 1/3] mwifiex: correct aid value during tdls setup
Date: Tue, 9 Aug 2016 20:20:44 +0530
Message-ID: <1470754246-635-1-git-send-email-akarwar@marvell.com> (sfid-20160809_165131_426715_AA9F3A48)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Xinming Hu <huxm@marvell.com>

AID gets updated during TDLS setup, but modified value isn't reflected
in "priv->assoc_rsp_buf". This causes TDLS setup failure. The problem is
fixed here.

Fixes: 4aff53ef18e4a4 ("mwifiex: parsing aid while receiving..")
Signed-off-by: Xinming Hu <huxm@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/join.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/join.c b/drivers/net/wireless/marvell/mwifiex/join.c
index 1c7b006..b89596c 100644
--- a/drivers/net/wireless/marvell/mwifiex/join.c
+++ b/drivers/net/wireless/marvell/mwifiex/join.c
@@ -669,9 +669,8 @@ int mwifiex_ret_802_11_associate(struct mwifiex_private *priv,
 	priv->assoc_rsp_size = min(le16_to_cpu(resp->size) - S_DS_GEN,
 				   sizeof(priv->assoc_rsp_buf));
 
-	memcpy(priv->assoc_rsp_buf, &resp->params, priv->assoc_rsp_size);
-
 	assoc_rsp->a_id = cpu_to_le16(aid);
+	memcpy(priv->assoc_rsp_buf, &resp->params, priv->assoc_rsp_size);
 
 	if (status_code) {
 		priv->adapter->dbg.num_cmd_assoc_failure++;
-- 
1.9.1

