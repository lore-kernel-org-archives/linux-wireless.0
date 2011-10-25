Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:3966 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933531Ab1JYOGg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Oct 2011 10:06:36 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH V2 20/31] ath6kl: Cleanup parameters in ath6kl_init_control_info() and ath6kl_init_profile_info()
Date: Tue, 25 Oct 2011 19:34:15 +0530
Message-ID: <1319551466-29070-21-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20111025_160640_698974_3D874548)
In-Reply-To: <1319551466-29070-1-git-send-email-vthiagar@qca.qualcomm.com>
References: <1319551466-29070-1-git-send-email-vthiagar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pass vif structure to those functions instead of ath6kl because these
functions do vif specific information initialization.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |    2 +-
 drivers/net/wireless/ath/ath6kl/core.h     |    4 ++--
 drivers/net/wireless/ath/ath6kl/init.c     |   12 +++---------
 drivers/net/wireless/ath/ath6kl/main.c     |    4 ++--
 4 files changed, 8 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 636b64e..0d02ba0 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -2118,7 +2118,7 @@ struct net_device *ath6kl_interface_add(struct ath6kl *ar, char *name,
 
 	init_netdev(ndev);
 
-	ath6kl_init_control_info(ar);
+	ath6kl_init_control_info(vif);
 
 	/* TODO: Pass interface specific pointer instead of ar */
 	if (ath6kl_init_if_data(vif))
diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index 4db0b15..de288ff 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -602,7 +602,7 @@ int ath6kl_diag_write(struct ath6kl *ar, u32 address, void *data, u32 length);
 int ath6kl_diag_read32(struct ath6kl *ar, u32 address, u32 *value);
 int ath6kl_diag_read(struct ath6kl *ar, u32 address, void *data, u32 length);
 int ath6kl_read_fwlogs(struct ath6kl *ar);
-void ath6kl_init_profile_info(struct ath6kl *ar);
+void ath6kl_init_profile_info(struct ath6kl_vif *vif);
 void ath6kl_tx_data_cleanup(struct ath6kl *ar);
 void ath6kl_stop_endpoint(struct net_device *dev, bool keep_profile,
 			  bool get_dbglogs);
@@ -657,7 +657,7 @@ void aggr_recv_addba_req_evt(struct ath6kl_vif *vif, u8 tid, u16 seq_no,
 void ath6kl_wakeup_event(void *dev);
 void ath6kl_target_failure(struct ath6kl *ar);
 
-void ath6kl_init_control_info(struct ath6kl *ar);
+void ath6kl_init_control_info(struct ath6kl_vif *vif);
 void ath6kl_deinit_if_data(struct ath6kl_vif *vif);
 void ath6kl_core_free(struct ath6kl *ar);
 #endif /* CORE_H */
diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index a874665..4bb348e 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -73,11 +73,8 @@ struct sk_buff *ath6kl_buf_alloc(int size)
 	return skb;
 }
 
-void ath6kl_init_profile_info(struct ath6kl *ar)
+void ath6kl_init_profile_info(struct ath6kl_vif *vif)
 {
-	/* TODO: Findout vif */
-	struct ath6kl_vif *vif = ar->vif;
-
 	vif->ssid_len = 0;
 	memset(vif->ssid, 0, sizeof(vif->ssid));
 
@@ -246,12 +243,9 @@ static int ath6kl_init_service_ep(struct ath6kl *ar)
 	return 0;
 }
 
-void ath6kl_init_control_info(struct ath6kl *ar)
+void ath6kl_init_control_info(struct ath6kl_vif *vif)
 {
-	/* TODO: Findout vif */
-	struct ath6kl_vif *vif = ar->vif;
-
-	ath6kl_init_profile_info(ar);
+	ath6kl_init_profile_info(vif);
 	vif->def_txkey_index = 0;
 	memset(vif->wep_key_list, 0, sizeof(vif->wep_key_list));
 	vif->ch_hint = 0;
diff --git a/drivers/net/wireless/ath/ath6kl/main.c b/drivers/net/wireless/ath/ath6kl/main.c
index 023624d..08af257 100644
--- a/drivers/net/wireless/ath/ath6kl/main.c
+++ b/drivers/net/wireless/ath/ath6kl/main.c
@@ -443,7 +443,7 @@ void ath6kl_stop_endpoint(struct net_device *dev, bool keep_profile,
 				 test_bit(CONNECT_PEND, &vif->flags));
 		ath6kl_disconnect(vif);
 		if (!keep_profile)
-			ath6kl_init_profile_info(ar);
+			ath6kl_init_profile_info(vif);
 
 		del_timer(&vif->disconnect_timer);
 
@@ -913,7 +913,7 @@ void disconnect_timer_handler(unsigned long ptr)
 	struct net_device *dev = (struct net_device *)ptr;
 	struct ath6kl_vif *vif = netdev_priv(dev);
 
-	ath6kl_init_profile_info(vif->ar);
+	ath6kl_init_profile_info(vif);
 	ath6kl_disconnect(vif);
 }
 
-- 
1.7.0.4

