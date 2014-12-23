Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:24598 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754823AbaLWIO7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Dec 2014 03:14:59 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.14.5/8.14.5) with SMTP id sBN8EnkE010339
	for <linux-wireless@vger.kernel.org>; Tue, 23 Dec 2014 00:14:59 -0800
Received: from sc-owa04.marvell.com ([199.233.58.150])
	by mx0b-0016f401.pphosted.com with ESMTP id 1rd602ptbd-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 23 Dec 2014 00:14:59 -0800
From: Avinash Patil <patila@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: <akarwar@marvell.com>, <cluo@marvell.com>, <yangyang@marvell.com>,
	<huxm@marvell.com>, Avinash Patil <patila@marvell.com>
Subject: [PATCH 8/8] mwifiex: module parameter for deep sleep configuration
Date: Tue, 23 Dec 2014 19:14:12 +0530
Message-ID: <1419342252-2702-9-git-send-email-patila@marvell.com> (sfid-20141223_091517_738053_1BCFA378)
In-Reply-To: <1419342252-2702-1-git-send-email-patila@marvell.com>
References: <1419342252-2702-1-git-send-email-patila@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds module parameter for auto deepsleep configuration.
By default, module_param is 0 and auto deep sleep is enabled.
If mwifiex driver is loaded with disable_auto_ds=1, deep sleep
configuration would not be downloaded to FW and FW would not enter
deepsleep upon initializing.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/mwifiex/sta_cmd.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mwifiex/sta_cmd.c b/drivers/net/wireless/mwifiex/sta_cmd.c
index 1c2ca29..f7b920d 100644
--- a/drivers/net/wireless/mwifiex/sta_cmd.c
+++ b/drivers/net/wireless/mwifiex/sta_cmd.c
@@ -26,6 +26,10 @@
 #include "11n.h"
 #include "11ac.h"
 
+static bool disable_auto_ds;
+module_param(disable_auto_ds, bool, 0);
+MODULE_PARM_DESC(disable_auto_ds,
+		 "deepsleep enabled=0(default), deepsleep disabled=1");
 /*
  * This function prepares command to set/get RSSI information.
  *
@@ -2031,7 +2035,8 @@ int mwifiex_sta_init_cmd(struct mwifiex_private *priv, u8 first_sta)
 	if (ret)
 		return -1;
 
-	if (first_sta && priv->adapter->iface_type != MWIFIEX_USB &&
+	if (!disable_auto_ds &&
+	    first_sta && priv->adapter->iface_type != MWIFIEX_USB &&
 	    priv->bss_type != MWIFIEX_BSS_TYPE_UAP) {
 		/* Enable auto deep sleep */
 		auto_ds.auto_ds = DEEP_SLEEP_ON;
-- 
1.8.1.4

