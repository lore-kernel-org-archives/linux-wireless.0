Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:38745 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029Ab2HNEkc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Aug 2012 00:40:32 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: [PATCH V2 1/2] ath6kl: Fix potential skb double free in ath6kl_wmi_sync_point()
Date: Tue, 14 Aug 2012 10:10:33 +0530
Message-ID: <1344919234-5012-1-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20120814_064102_758056_B13913A4)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

skb given to ath6kl_control_tx() is owned by ath6kl_control_tx().
Calling function should not free the skb for error cases.
This is found during code review.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/txrx.c |    4 ++-
 drivers/net/wireless/ath/ath6kl/wmi.c  |   35 +++++++++++++++++--------------
 2 files changed, 22 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/txrx.c b/drivers/net/wireless/ath/ath6kl/txrx.c
index 7dfa0fd..aab8251 100644
--- a/drivers/net/wireless/ath/ath6kl/txrx.c
+++ b/drivers/net/wireless/ath/ath6kl/txrx.c
@@ -288,8 +288,10 @@ int ath6kl_control_tx(void *devt, struct sk_buff *skb,
 	int status = 0;
 	struct ath6kl_cookie *cookie = NULL;
 
-	if (WARN_ON_ONCE(ar->state == ATH6KL_STATE_WOW))
+	if (WARN_ON_ONCE(ar->state == ATH6KL_STATE_WOW)) {
+		dev_kfree_skb(skb);
 		return -EACCES;
+	}
 
 	spin_lock_bh(&ar->lock);
 
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index cf91348..039f668 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -1739,8 +1739,11 @@ int ath6kl_wmi_cmd_send(struct wmi *wmi, u8 if_idx, struct sk_buff *skb,
 	int ret;
 	u16 info1;
 
-	if (WARN_ON(skb == NULL || (if_idx > (wmi->parent_dev->vif_max - 1))))
+	if (WARN_ON(skb == NULL ||
+	    (if_idx > (wmi->parent_dev->vif_max - 1)))) {
+		dev_kfree_skb(skb);
 		return -EINVAL;
+	}
 
 	ath6kl_dbg(ATH6KL_DBG_WMI, "wmi tx id %d len %d flag %d\n",
 		   cmd_id, skb->len, sync_flag);
@@ -2352,8 +2355,10 @@ static int ath6kl_wmi_data_sync_send(struct wmi *wmi, struct sk_buff *skb,
 	struct wmi_data_hdr *data_hdr;
 	int ret;
 
-	if (WARN_ON(skb == NULL || ep_id == wmi->ep_id))
+	if (WARN_ON(skb == NULL || ep_id == wmi->ep_id)) {
+		dev_kfree_skb(skb);
 		return -EINVAL;
+	}
 
 	skb_push(skb, sizeof(struct wmi_data_hdr));
 
@@ -2390,10 +2395,8 @@ static int ath6kl_wmi_sync_point(struct wmi *wmi, u8 if_idx)
 	spin_unlock_bh(&wmi->lock);
 
 	skb = ath6kl_wmi_get_new_buf(sizeof(*cmd));
-	if (!skb) {
-		ret = -ENOMEM;
-		goto free_skb;
-	}
+	if (!skb)
+		return -ENOMEM;
 
 	cmd = (struct wmi_sync_cmd *) skb->data;
 
@@ -2416,7 +2419,7 @@ static int ath6kl_wmi_sync_point(struct wmi *wmi, u8 if_idx)
 	 * then do not send the Synchronize cmd on the control ep
 	 */
 	if (ret)
-		goto free_skb;
+		goto free_cmd_skb;
 
 	/*
 	 * Send sync cmd followed by sync data messages on all
@@ -2426,15 +2429,12 @@ static int ath6kl_wmi_sync_point(struct wmi *wmi, u8 if_idx)
 				  NO_SYNC_WMIFLAG);
 
 	if (ret)
-		goto free_skb;
-
-	/* cmd buffer sent, we no longer own it */
-	skb = NULL;
+		goto free_data_skb;
 
 	for (index = 0; index < num_pri_streams; index++) {
 
 		if (WARN_ON(!data_sync_bufs[index].skb))
-			break;
+			goto free_data_skb;
 
 		ep_id = ath6kl_ac2_endpoint_id(wmi->parent_dev,
 					       data_sync_bufs[index].
@@ -2443,17 +2443,20 @@ static int ath6kl_wmi_sync_point(struct wmi *wmi, u8 if_idx)
 		    ath6kl_wmi_data_sync_send(wmi, data_sync_bufs[index].skb,
 					      ep_id, if_idx);
 
-		if (ret)
-			break;
-
 		data_sync_bufs[index].skb = NULL;
+
+		if (ret)
+			goto free_data_skb;
 	}
 
-free_skb:
+	return 0;
+
+free_cmd_skb:
 	/* free up any resources left over (possibly due to an error) */
 	if (skb)
 		dev_kfree_skb(skb);
 
+free_data_skb:
 	for (index = 0; index < num_pri_streams; index++) {
 		if (data_sync_bufs[index].skb != NULL) {
 			dev_kfree_skb((struct sk_buff *)data_sync_bufs[index].
-- 
1.7.0.4

