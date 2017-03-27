Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:42829 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752145AbdC0NHn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 27 Mar 2017 09:07:43 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v2RD5EjR002049
        for <linux-wireless@vger.kernel.org>; Mon, 27 Mar 2017 06:07:17 -0700
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0b-0016f401.pphosted.com with ESMTP id 29exna8ybq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-wireless@vger.kernel.org>; Mon, 27 Mar 2017 06:07:17 -0700
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH] mwifiex: enable auto deep sleep mode for USB chipsets
Date: Mon, 27 Mar 2017 18:36:51 +0530
Message-ID: <1490620012-2733-1-git-send-email-akarwar@marvell.com> (sfid-20170327_150929_771068_DA9A6374)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Chip goes into low power state when this feature is enabled.
This was already enabled for SDIO and PCIe interface based
chipsets.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/sta_cmd.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/sta_cmd.c b/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
index f6056ab..83916c1 100644
--- a/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
@@ -2364,8 +2364,7 @@ int mwifiex_sta_init_cmd(struct mwifiex_private *priv, u8 first_sta, bool init)
 	if (ret)
 		return -1;
 
-	if (!disable_auto_ds &&
-	    first_sta && priv->adapter->iface_type != MWIFIEX_USB &&
+	if (!disable_auto_ds && first_sta &&
 	    priv->bss_type != MWIFIEX_BSS_TYPE_UAP) {
 		/* Enable auto deep sleep */
 		auto_ds.auto_ds = DEEP_SLEEP_ON;
-- 
1.9.1
