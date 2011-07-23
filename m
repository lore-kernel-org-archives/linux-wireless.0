Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:15859 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752243Ab1GWOWu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Jul 2011 10:22:50 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: [PATCH 06/11] ath6kl: Cleanup parameters of wlan_node_table_init()
Date: Sat, 23 Jul 2011 19:43:12 +0530
Message-ID: <1311430397-4960-6-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20110723_162253_032336_E4DF4603)
In-Reply-To: <1311430397-4960-1-git-send-email-vthiagar@qca.qualcomm.com>
References: <1311430397-4960-1-git-send-email-vthiagar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/common.h |    2 +-
 drivers/net/wireless/ath/ath6kl/node.c   |    2 +-
 drivers/net/wireless/ath/ath6kl/wmi.c    |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/common.h b/drivers/net/wireless/ath/ath6kl/common.h
index cc8b040..e37ae9b 100644
--- a/drivers/net/wireless/ath/ath6kl/common.h
+++ b/drivers/net/wireless/ath/ath6kl/common.h
@@ -155,7 +155,7 @@ void wlan_iterate_nodes(struct ath6kl_node_table *nt,
 			void (*f) (void *arg, struct bss *),
 			void *arg);
 
-void wlan_node_table_init(void *wmip, struct ath6kl_node_table *nt);
+void wlan_node_table_init(struct ath6kl_node_table *nt);
 void wlan_node_table_cleanup(struct ath6kl_node_table *nt);
 
 void wlan_refresh_inactive_nodes(struct ath6kl *ar);
diff --git a/drivers/net/wireless/ath/ath6kl/node.c b/drivers/net/wireless/ath/ath6kl/node.c
index 9611541..7c9fbde 100644
--- a/drivers/net/wireless/ath/ath6kl/node.c
+++ b/drivers/net/wireless/ath/ath6kl/node.c
@@ -160,7 +160,7 @@ void wlan_iterate_nodes(struct ath6kl_node_table *nt,
 	spin_unlock_bh(&nt->nt_nodelock);
 }
 
-void wlan_node_table_init(void *wmi, struct ath6kl_node_table *nt)
+void wlan_node_table_init(struct ath6kl_node_table *nt)
 {
 	ath6kl_dbg(ATH6KL_DBG_WLAN_NODE, "node table = 0x%lx\n",
 		   (unsigned long)nt);
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index 50cee9b..6f145d4 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -2727,7 +2727,7 @@ void *ath6kl_wmi_init(struct ath6kl *dev)
 
 	wmi->parent_dev = dev;
 
-	wlan_node_table_init(wmi, &dev->scan_table);
+	wlan_node_table_init(&dev->scan_table);
 	ath6kl_wmi_qos_state_init(wmi);
 
 	wmi->pwr_mode = REC_POWER;
-- 
1.7.0.4

