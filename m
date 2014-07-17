Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:61393 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751516AbaGQStd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jul 2014 14:49:33 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Avinash Patil <patila@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Maithili Hinge <maithili@marvell.com>,
	Chin-Ran Lo <crlo@marvell.com>, Xinming Hu <huxm@marvell.com>,
	Bing Zhao <bzhao@marvell.com>
Subject: [PATCH] mwifiex: remove needless current_bssid variable
Date: Thu, 17 Jul 2014 11:48:47 -0700
Message-ID: <1405622927-26207-1-git-send-email-bzhao@marvell.com> (sfid-20140717_204946_832213_313A41C7)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash Patil <patila@marvell.com>

This local variable is not used anywhere in function.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/join.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/join.c b/drivers/net/wireless/mwifiex/join.c
index 0b977ea..8d6c259 100644
--- a/drivers/net/wireless/mwifiex/join.c
+++ b/drivers/net/wireless/mwifiex/join.c
@@ -1288,8 +1288,6 @@ done:
 int mwifiex_associate(struct mwifiex_private *priv,
 		      struct mwifiex_bssdescriptor *bss_desc)
 {
-	u8 current_bssid[ETH_ALEN];
-
 	/* Return error if the adapter is not STA role or table entry
 	 * is not marked as infra.
 	 */
@@ -1304,10 +1302,6 @@ int mwifiex_associate(struct mwifiex_private *priv,
 	else
 		mwifiex_set_ba_params(priv);
 
-	memcpy(&current_bssid,
-	       &priv->curr_bss_params.bss_descriptor.mac_address,
-	       sizeof(current_bssid));
-
 	/* Clear any past association response stored for application
 	   retrieval */
 	priv->assoc_rsp_size = 0;
-- 
1.8.2.3

