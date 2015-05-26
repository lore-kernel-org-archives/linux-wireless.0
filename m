Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:54891 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754914AbbEZNf3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 May 2015 09:35:29 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.14.5/8.14.5) with SMTP id t4QDYxsN003727
	for <linux-wireless@vger.kernel.org>; Tue, 26 May 2015 06:35:28 -0700
Received: from sc-owa04.marvell.com ([199.233.58.150])
	by mx0b-0016f401.pphosted.com with ESMTP id 1umqg00bqj-8
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 26 May 2015 06:35:28 -0700
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>, Avinash Patil <patila@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 4/6] mwifiex: minor changes in debug messages
Date: Tue, 26 May 2015 06:34:30 -0700
Message-ID: <1432647272-5734-5-git-send-email-akarwar@marvell.com> (sfid-20150526_153541_329949_B748124E)
In-Reply-To: <1432647272-5734-1-git-send-email-akarwar@marvell.com>
References: <1432647272-5734-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Small letters are used in debug messages to match coding style
at other places.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
---
 drivers/net/wireless/mwifiex/main.c | 8 ++++----
 drivers/net/wireless/mwifiex/sdio.c | 4 ++--
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index cb009789..3e7774f 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -890,7 +890,7 @@ void mwifiex_dump_drv_info(struct mwifiex_adapter *adapter)
 		adapter->drv_info_size = 0;
 	}
 
-	mwifiex_dbg(adapter, MSG, "=== DRIVER INFO DUMP START===\n");
+	mwifiex_dbg(adapter, MSG, "===mwifiex driverinfo dump start===\n");
 
 	adapter->drv_info_dump = vzalloc(MWIFIEX_DRV_INFO_SIZE_MAX);
 
@@ -958,12 +958,12 @@ void mwifiex_dump_drv_info(struct mwifiex_adapter *adapter)
 	}
 
 	if (adapter->iface_type == MWIFIEX_SDIO) {
-		p += sprintf(p, "\n=== SDIO register DUMP===\n");
+		p += sprintf(p, "\n=== SDIO register dump===\n");
 		if (adapter->if_ops.reg_dump)
 			p += adapter->if_ops.reg_dump(adapter, p);
 	}
 
-	p += sprintf(p, "\n=== MORE DEBUG INFORMATION\n");
+	p += sprintf(p, "\n=== more debug information\n");
 	debug_info = kzalloc(sizeof(*debug_info), GFP_KERNEL);
 	if (debug_info) {
 		for (i = 0; i < adapter->priv_num; i++) {
@@ -978,7 +978,7 @@ void mwifiex_dump_drv_info(struct mwifiex_adapter *adapter)
 	}
 
 	adapter->drv_info_size = p - adapter->drv_info_dump;
-	mwifiex_dbg(adapter, MSG, "=== DRIVER INFO DUMP END===\n");
+	mwifiex_dbg(adapter, MSG, "===mwifiex driverinfo dump end===\n");
 }
 EXPORT_SYMBOL_GPL(mwifiex_dump_drv_info);
 
diff --git a/drivers/net/wireless/mwifiex/sdio.c b/drivers/net/wireless/mwifiex/sdio.c
index a3d810b8..467ee9a 100644
--- a/drivers/net/wireless/mwifiex/sdio.c
+++ b/drivers/net/wireless/mwifiex/sdio.c
@@ -2356,7 +2356,7 @@ mwifiex_sdio_reg_dump(struct mwifiex_adapter *adapter, char *drv_buf)
 	if (!p)
 		return 0;
 
-	mwifiex_dbg(adapter, MSG, "SDIO register DUMP START\n");
+	mwifiex_dbg(adapter, MSG, "SDIO register dump start\n");
 
 	mwifiex_pm_wakeup_card(adapter);
 
@@ -2428,7 +2428,7 @@ mwifiex_sdio_reg_dump(struct mwifiex_adapter *adapter, char *drv_buf)
 
 	sdio_release_host(cardp->func);
 
-	mwifiex_dbg(adapter, MSG, "SDIO register DUMP END\n");
+	mwifiex_dbg(adapter, MSG, "SDIO register dump end\n");
 
 	return p - drv_buf;
 }
-- 
1.8.1.4

