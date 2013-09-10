Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:42868 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752129Ab3IJNuP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Sep 2013 09:50:15 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 7/7] ath10k: remove wmi event worker thread
Date: Tue, 10 Sep 2013 15:50:03 +0200
Message-ID: <1378821003-22925-8-git-send-email-michal.kazior@tieto.com> (sfid-20130910_155022_039357_15EC3485)
In-Reply-To: <1378821003-22925-1-git-send-email-michal.kazior@tieto.com>
References: <1378821003-22925-1-git-send-email-michal.kazior@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It's not really necessary to have this processed
in a worker. There are no sleepable calls (and
actually shouldn't be).

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/core.h |    3 ---
 drivers/net/wireless/ath/ath10k/wmi.c  |   44 +-------------------------------
 2 files changed, 1 insertion(+), 46 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index c2b6a76..fcf94ee 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -113,9 +113,6 @@ struct ath10k_wmi {
 	struct completion service_ready;
 	struct completion unified_ready;
 	wait_queue_head_t tx_credits_wq;
-
-	struct sk_buff_head wmi_event_list;
-	struct work_struct wmi_event_work;
 };
 
 struct ath10k_peer_stat {
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index aa7093a..3831694 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -1051,7 +1051,7 @@ static int ath10k_wmi_ready_event_rx(struct ath10k *ar, struct sk_buff *skb)
 	return 0;
 }
 
-static void ath10k_wmi_event_process(struct ath10k *ar, struct sk_buff *skb)
+static void ath10k_wmi_process_rx(struct ath10k *ar, struct sk_buff *skb)
 {
 	struct wmi_cmd_hdr *cmd_hdr;
 	enum wmi_event_id id;
@@ -1170,43 +1170,6 @@ static void ath10k_wmi_event_process(struct ath10k *ar, struct sk_buff *skb)
 	dev_kfree_skb(skb);
 }
 
-static void ath10k_wmi_event_work(struct work_struct *work)
-{
-	struct ath10k *ar = container_of(work, struct ath10k,
-					 wmi.wmi_event_work);
-	struct sk_buff *skb;
-
-	for (;;) {
-		skb = skb_dequeue(&ar->wmi.wmi_event_list);
-		if (!skb)
-			break;
-
-		ath10k_wmi_event_process(ar, skb);
-	}
-}
-
-static void ath10k_wmi_process_rx(struct ath10k *ar, struct sk_buff *skb)
-{
-	struct wmi_cmd_hdr *cmd_hdr = (struct wmi_cmd_hdr *)skb->data;
-	enum wmi_event_id event_id;
-
-	event_id = MS(__le32_to_cpu(cmd_hdr->cmd_id), WMI_CMD_HDR_CMD_ID);
-
-	/* some events require to be handled ASAP
-	 * thus can't be defered to a worker thread */
-	switch (event_id) {
-	case WMI_MGMT_RX_EVENTID:
-	case WMI_HOST_SWBA_EVENTID:
-		ath10k_wmi_event_process(ar, skb);
-		return;
-	default:
-		break;
-	}
-
-	skb_queue_tail(&ar->wmi.wmi_event_list, skb);
-	queue_work(ar->workqueue, &ar->wmi.wmi_event_work);
-}
-
 /* WMI Initialization functions */
 int ath10k_wmi_attach(struct ath10k *ar)
 {
@@ -1214,16 +1177,11 @@ int ath10k_wmi_attach(struct ath10k *ar)
 	init_completion(&ar->wmi.unified_ready);
 	init_waitqueue_head(&ar->wmi.tx_credits_wq);
 
-	skb_queue_head_init(&ar->wmi.wmi_event_list);
-	INIT_WORK(&ar->wmi.wmi_event_work, ath10k_wmi_event_work);
-
 	return 0;
 }
 
 void ath10k_wmi_detach(struct ath10k *ar)
 {
-	cancel_work_sync(&ar->wmi.wmi_event_work);
-	skb_queue_purge(&ar->wmi.wmi_event_list);
 }
 
 int ath10k_wmi_connect_htc_service(struct ath10k *ar)
-- 
1.7.9.5

