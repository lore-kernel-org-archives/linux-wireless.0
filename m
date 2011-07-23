Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:15161 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752232Ab1GWOWT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Jul 2011 10:22:19 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: [PATCH 01/11] ath6kl: Cleanup void *parent_dev in struct wmi
Date: Sat, 23 Jul 2011 19:43:07 +0530
Message-ID: <1311430397-4960-1-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20110723_162222_738258_D9B2F7F1)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/init.c |    2 +-
 drivers/net/wireless/ath/ath6kl/wmi.c  |    2 +-
 drivers/net/wireless/ath/ath6kl/wmi.h  |    4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index d574d08..1d6294f 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -1053,7 +1053,7 @@ static int ath6kl_init(struct net_device *dev)
 
 	/* Indicate that WMI is enabled (although not ready yet) */
 	set_bit(WMI_ENABLED, &ar->flag);
-	ar->wmi = ath6kl_wmi_init((void *) ar);
+	ar->wmi = ath6kl_wmi_init(ar);
 	if (!ar->wmi) {
 		ath6kl_err("failed to initialize wmi\n");
 		status = -EIO;
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index 6e4febf..9b06a82 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -2724,7 +2724,7 @@ static void ath6kl_wmi_qos_state_init(struct wmi *wmi)
 	spin_unlock_bh(&wmi->lock);
 }
 
-void *ath6kl_wmi_init(void *dev)
+void *ath6kl_wmi_init(struct ath6kl *dev)
 {
 	struct wmi *wmi;
 
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.h b/drivers/net/wireless/ath/ath6kl/wmi.h
index bbaa704..afc9be9 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.h
+++ b/drivers/net/wireless/ath/ath6kl/wmi.h
@@ -114,7 +114,7 @@ struct wmi {
 	bool ready;
 	u16 stream_exist_for_ac[WMM_NUM_AC];
 	u8 fat_pipe_exist;
-	void *parent_dev;
+	struct ath6kl *parent_dev;
 	struct wmi_stats stat;
 	struct ath6kl_node_table scan_table;
 	u8 bssid[ETH_ALEN];
@@ -2018,7 +2018,7 @@ int ath6kl_wmi_set_pvb_cmd(struct wmi *wmi, u16 aid, bool flag);
 int ath6kl_wmi_set_rx_frame_format_cmd(struct wmi *wmi, u8 rx_meta_version,
 				       bool rx_dot11_hdr, bool defrag_on_host);
 
-void *ath6kl_wmi_init(void *devt);
+void *ath6kl_wmi_init(struct ath6kl *devt);
 void ath6kl_wmi_shutdown(struct wmi *wmi);
 
 #endif /* WMI_H */
-- 
1.7.0.4

