Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:34675 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750978AbbK0J7U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Nov 2015 04:59:20 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.15.0.59/8.15.0.59) with SMTP id tAR9xJQg006808
	for <linux-wireless@vger.kernel.org>; Fri, 27 Nov 2015 01:59:20 -0800
Received: from sc-exch04.marvell.com ([199.233.58.184])
	by mx0b-0016f401.pphosted.com with ESMTP id 1yema882qk-2
	(version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 27 Nov 2015 01:59:20 -0800
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Nishant Sarmukadam <nishants@marvell.com>,
	Xinming Hu <huxm@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH] mwifiex: parse hscfg_gpio info from device tree
Date: Fri, 27 Nov 2015 01:58:17 -0800
Message-ID: <1448618297-19803-1-git-send-email-akarwar@marvell.com> (sfid-20151127_105924_379429_8B14C796)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Xinming Hu <huxm@marvell.com>

This patch reads hscfg_gpio from device tree and update
internal variable

Signed-off-by: Xinming Hu <huxm@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/sta_cmd.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/sta_cmd.c b/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
index e486867..d28a53f 100644
--- a/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
@@ -1459,10 +1459,21 @@ int mwifiex_dnld_dt_cfgdata(struct mwifiex_private *priv,
 #ifdef CONFIG_OF
 	struct property *prop;
 	size_t len = strlen(prefix);
+	u32 data;
 	int ret;
 
 	/* look for all matching property names */
 	for_each_property_of_node(node, prop) {
+		if (!strncmp(prop->name, "marvell,hscfg_gpio",
+			     strlen("marvell,hscfg_gpio"))) {
+			if (!of_property_read_u32(priv->adapter->dt_node,
+						  prop->name, &data)) {
+				dev_dbg(priv->adapter->dev,
+					"hscfg gpio = 0x%x\n", data);
+				priv->adapter->hs_cfg.gpio = data;
+			}
+		}
+
 		if (len > strlen(prop->name) ||
 		    strncmp(prop->name, prefix, len))
 			continue;
-- 
1.8.1.4

