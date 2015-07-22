Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:42667 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933918AbbGVLyW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jul 2015 07:54:22 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.15.0.59/8.15.0.59) with SMTP id t6MBnOLd031228
	for <linux-wireless@vger.kernel.org>; Wed, 22 Jul 2015 04:54:21 -0700
Received: from sc-exch01.marvell.com ([199.233.58.181])
	by mx0b-0016f401.pphosted.com with ESMTP id 1vqpahbgbv-1
	(version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 22 Jul 2015 04:54:21 -0700
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>, Zhaoyang Liu <liuzy@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 2/4] mwifiex: fix command timeout for PCIe chipsets
Date: Wed, 22 Jul 2015 04:53:43 -0700
Message-ID: <1437566025-3324-2-git-send-email-akarwar@marvell.com> (sfid-20150722_135427_784571_421A1B48)
In-Reply-To: <1437566025-3324-1-git-send-email-akarwar@marvell.com>
References: <1437566025-3324-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Zhaoyang Liu <liuzy@marvell.com>

When WLAN interface is up and running, driver unload and
load was causing command timeout error.

We enable Rx data by updating RX ring read pointer in
init_fw_port(). It should be done when FW is completely
intialialised. Command timeout is fixed in this patch by
moving init_fw_port() call to mwifiex_init_fw_complete().

Signed-off-by: Zhaoyang Liu <liuzy@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/mwifiex/init.c | 5 -----
 drivers/net/wireless/mwifiex/util.c | 4 ++++
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/init.c b/drivers/net/wireless/mwifiex/init.c
index 8fa363a..7a970c2 100644
--- a/drivers/net/wireless/mwifiex/init.c
+++ b/drivers/net/wireless/mwifiex/init.c
@@ -551,11 +551,6 @@ int mwifiex_init_fw(struct mwifiex_adapter *adapter)
 		}
 	}
 
-	if (adapter->if_ops.init_fw_port) {
-		if (adapter->if_ops.init_fw_port(adapter))
-			return -1;
-	}
-
 	for (i = 0; i < adapter->priv_num; i++) {
 		if (adapter->priv[i]) {
 			ret = mwifiex_sta_init_cmd(adapter->priv[i], first_sta,
diff --git a/drivers/net/wireless/mwifiex/util.c b/drivers/net/wireless/mwifiex/util.c
index 2504e42..46f12d3 100644
--- a/drivers/net/wireless/mwifiex/util.c
+++ b/drivers/net/wireless/mwifiex/util.c
@@ -126,6 +126,10 @@ static int num_of_items = ARRAY_SIZE(items);
 int mwifiex_init_fw_complete(struct mwifiex_adapter *adapter)
 {
 
+	if (adapter->hw_status == MWIFIEX_HW_STATUS_READY)
+		if (adapter->if_ops.init_fw_port)
+			adapter->if_ops.init_fw_port(adapter);
+
 	adapter->init_wait_q_woken = true;
 	wake_up_interruptible(&adapter->init_wait_q);
 	return 0;
-- 
1.8.1.4

