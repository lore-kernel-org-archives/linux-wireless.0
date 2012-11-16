Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:17338 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751733Ab2KPMwa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Nov 2012 07:52:30 -0500
To: <ath6kl-devel@qca.qualcomm.com>
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
CC: Kalle Valo <kvalo@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Subject: [PATCH 3/8] ath6kl: remove unnecessary check for NULL skb
Date: Fri, 16 Nov 2012 18:22:22 +0530
Message-ID: <1353070342-5973-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20121116_135234_113721_E8E98E76)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

dev_kfree_skb kernel API itself takes for checking for NULL
skb, so an explicit check is not required.

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/htc_pipe.c |    8 +++-----
 drivers/net/wireless/ath/ath6kl/usb.c      |    6 ++----
 drivers/net/wireless/ath/ath6kl/wmi.c      |   11 +++--------
 3 files changed, 8 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/htc_pipe.c b/drivers/net/wireless/ath/ath6kl/htc_pipe.c
index 575e7d7..73a38f9 100644
--- a/drivers/net/wireless/ath/ath6kl/htc_pipe.c
+++ b/drivers/net/wireless/ath/ath6kl/htc_pipe.c
@@ -509,9 +509,7 @@ static void destroy_htc_txctrl_packet(struct htc_packet *packet)
 {
 	struct sk_buff *skb;
 	skb = packet->skb;
-	if (skb != NULL)
-		dev_kfree_skb(skb);
-
+	dev_kfree_skb(skb);
 	kfree(packet);
 }
 
@@ -1054,6 +1052,7 @@ static int ath6kl_htc_pipe_rx_complete(struct ath6kl *ar, struct sk_buff *skb,
 
 		dev_kfree_skb(skb);
 		skb = NULL;
+
 		goto free_skb;
 	}
 
@@ -1089,8 +1088,7 @@ static int ath6kl_htc_pipe_rx_complete(struct ath6kl *ar, struct sk_buff *skb,
 	skb = NULL;
 
 free_skb:
-	if (skb != NULL)
-		dev_kfree_skb(skb);
+	dev_kfree_skb(skb);
 
 	return status;
 
diff --git a/drivers/net/wireless/ath/ath6kl/usb.c b/drivers/net/wireless/ath/ath6kl/usb.c
index a6d1377..d425c5d 100644
--- a/drivers/net/wireless/ath/ath6kl/usb.c
+++ b/drivers/net/wireless/ath/ath6kl/usb.c
@@ -159,10 +159,8 @@ static void ath6kl_usb_free_urb_to_pipe(struct ath6kl_usb_pipe *pipe,
 
 static void ath6kl_usb_cleanup_recv_urb(struct ath6kl_urb_context *urb_context)
 {
-	if (urb_context->skb != NULL) {
-		dev_kfree_skb(urb_context->skb);
-		urb_context->skb = NULL;
-	}
+	dev_kfree_skb(urb_context->skb);
+	urb_context->skb = NULL;
 
 	ath6kl_usb_free_urb_to_pipe(urb_context->pipe, urb_context);
 }
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index f3aeebb..7c5da1e 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -2481,16 +2481,11 @@ static int ath6kl_wmi_sync_point(struct wmi *wmi, u8 if_idx)
 
 free_cmd_skb:
 	/* free up any resources left over (possibly due to an error) */
-	if (skb)
-		dev_kfree_skb(skb);
+	dev_kfree_skb(skb);
 
 free_data_skb:
-	for (index = 0; index < num_pri_streams; index++) {
-		if (data_sync_bufs[index].skb != NULL) {
-			dev_kfree_skb((struct sk_buff *)data_sync_bufs[index].
-				      skb);
-		}
-	}
+	for (index = 0; index < num_pri_streams; index++)
+		dev_kfree_skb((struct sk_buff *)data_sync_bufs[index].skb);
 
 	return ret;
 }
-- 
1.7.0.4

