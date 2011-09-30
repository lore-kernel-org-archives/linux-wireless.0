Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:65079 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756035Ab1I3Nsy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Sep 2011 09:48:54 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/5] ath6kl: Replace spin_lock_irqsave with spin_lock_bh
Date: Fri, 30 Sep 2011 19:18:43 +0530
Message-ID: <1317390526-3442-2-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20110930_154857_043428_2F05DE3B)
In-Reply-To: <1317390526-3442-1-git-send-email-vthiagar@qca.qualcomm.com>
References: <1317390526-3442-1-git-send-email-vthiagar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It is not necessary to use spinlock primitive to
protect data which is accessed in hard irq context as
nothing is running in hard irq with this driver. The
spinlock primitive meant to protect data in softirq
context is more appropriate.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/main.c |   17 ++++-------
 drivers/net/wireless/ath/ath6kl/sdio.c |   51 +++++++++++++------------------
 2 files changed, 27 insertions(+), 41 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/main.c b/drivers/net/wireless/ath/ath6kl/main.c
index 30b5a53..adb1635 100644
--- a/drivers/net/wireless/ath/ath6kl/main.c
+++ b/drivers/net/wireless/ath/ath6kl/main.c
@@ -1025,8 +1025,6 @@ void ath6kl_connect_event(struct ath6kl *ar, u16 channel, u8 *bssid,
 			  u8 assoc_req_len, u8 assoc_resp_len,
 			  u8 *assoc_info)
 {
-	unsigned long flags;
-
 	ath6kl_cfg80211_connect_event(ar, channel, bssid,
 				      listen_int, beacon_int,
 				      net_type, beacon_ie_len,
@@ -1043,11 +1041,11 @@ void ath6kl_connect_event(struct ath6kl *ar, u16 channel, u8 *bssid,
 	netif_wake_queue(ar->net_dev);
 
 	/* Update connect & link status atomically */
-	spin_lock_irqsave(&ar->lock, flags);
+	spin_lock_bh(&ar->lock);
 	set_bit(CONNECTED, &ar->flag);
 	clear_bit(CONNECT_PEND, &ar->flag);
 	netif_carrier_on(ar->net_dev);
-	spin_unlock_irqrestore(&ar->lock, flags);
+	spin_unlock_bh(&ar->lock);
 
 	aggr_reset_state(ar->aggr_cntxt);
 	ar->reconnect_flag = 0;
@@ -1330,8 +1328,6 @@ void ath6kl_disconnect_event(struct ath6kl *ar, u8 reason, u8 *bssid,
 			     u8 assoc_resp_len, u8 *assoc_info,
 			     u16 prot_reason_status)
 {
-	unsigned long flags;
-
 	if (ar->nw_type == AP_NETWORK) {
 		if (!ath6kl_remove_sta(ar, bssid, prot_reason_status))
 			return;
@@ -1390,10 +1386,10 @@ void ath6kl_disconnect_event(struct ath6kl *ar, u8 reason, u8 *bssid,
 	}
 
 	/* update connect & link status atomically */
-	spin_lock_irqsave(&ar->lock, flags);
+	spin_lock_bh(&ar->lock);
 	clear_bit(CONNECTED, &ar->flag);
 	netif_carrier_off(ar->net_dev);
-	spin_unlock_irqrestore(&ar->lock, flags);
+	spin_unlock_bh(&ar->lock);
 
 	if ((reason != CSERV_DISCONNECT) || (ar->reconnect_flag != 1))
 		ar->reconnect_flag = 0;
@@ -1411,9 +1407,8 @@ void ath6kl_disconnect_event(struct ath6kl *ar, u8 reason, u8 *bssid,
 static int ath6kl_open(struct net_device *dev)
 {
 	struct ath6kl *ar = ath6kl_priv(dev);
-	unsigned long flags;
 
-	spin_lock_irqsave(&ar->lock, flags);
+	spin_lock_bh(&ar->lock);
 
 	set_bit(WLAN_ENABLED, &ar->flag);
 
@@ -1423,7 +1418,7 @@ static int ath6kl_open(struct net_device *dev)
 	} else
 		netif_carrier_off(dev);
 
-	spin_unlock_irqrestore(&ar->lock, flags);
+	spin_unlock_bh(&ar->lock);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/ath/ath6kl/sdio.c b/drivers/net/wireless/ath/ath6kl/sdio.c
index f1dc311..2dd7a88 100644
--- a/drivers/net/wireless/ath/ath6kl/sdio.c
+++ b/drivers/net/wireless/ath/ath6kl/sdio.c
@@ -166,12 +166,11 @@ static int ath6kl_sdio_io(struct sdio_func *func, u32 request, u32 addr,
 static struct bus_request *ath6kl_sdio_alloc_busreq(struct ath6kl_sdio *ar_sdio)
 {
 	struct bus_request *bus_req;
-	unsigned long flag;
 
-	spin_lock_irqsave(&ar_sdio->lock, flag);
+	spin_lock_bh(&ar_sdio->lock);
 
 	if (list_empty(&ar_sdio->bus_req_freeq)) {
-		spin_unlock_irqrestore(&ar_sdio->lock, flag);
+		spin_unlock_bh(&ar_sdio->lock);
 		return NULL;
 	}
 
@@ -179,7 +178,7 @@ static struct bus_request *ath6kl_sdio_alloc_busreq(struct ath6kl_sdio *ar_sdio)
 				   struct bus_request, list);
 	list_del(&bus_req->list);
 
-	spin_unlock_irqrestore(&ar_sdio->lock, flag);
+	spin_unlock_bh(&ar_sdio->lock);
 	ath6kl_dbg(ATH6KL_DBG_SCATTER, "%s: bus request 0x%p\n",
 		   __func__, bus_req);
 
@@ -189,14 +188,12 @@ static struct bus_request *ath6kl_sdio_alloc_busreq(struct ath6kl_sdio *ar_sdio)
 static void ath6kl_sdio_free_bus_req(struct ath6kl_sdio *ar_sdio,
 				     struct bus_request *bus_req)
 {
-	unsigned long flag;
-
 	ath6kl_dbg(ATH6KL_DBG_SCATTER, "%s: bus request 0x%p\n",
 		   __func__, bus_req);
 
-	spin_lock_irqsave(&ar_sdio->lock, flag);
+	spin_lock_bh(&ar_sdio->lock);
 	list_add_tail(&bus_req->list, &ar_sdio->bus_req_freeq);
-	spin_unlock_irqrestore(&ar_sdio->lock, flag);
+	spin_unlock_bh(&ar_sdio->lock);
 }
 
 static void ath6kl_sdio_setup_scat_data(struct hif_scatter_req *scat_req,
@@ -424,20 +421,19 @@ static void __ath6kl_sdio_write_async(struct ath6kl_sdio *ar_sdio,
 static void ath6kl_sdio_write_async_work(struct work_struct *work)
 {
 	struct ath6kl_sdio *ar_sdio;
-	unsigned long flags;
 	struct bus_request *req, *tmp_req;
 
 	ar_sdio = container_of(work, struct ath6kl_sdio, wr_async_work);
 	sdio_claim_host(ar_sdio->func);
 
-	spin_lock_irqsave(&ar_sdio->wr_async_lock, flags);
+	spin_lock_bh(&ar_sdio->wr_async_lock);
 	list_for_each_entry_safe(req, tmp_req, &ar_sdio->wr_asyncq, list) {
 		list_del(&req->list);
-		spin_unlock_irqrestore(&ar_sdio->wr_async_lock, flags);
+		spin_unlock_bh(&ar_sdio->wr_async_lock);
 		__ath6kl_sdio_write_async(ar_sdio, req);
-		spin_lock_irqsave(&ar_sdio->wr_async_lock, flags);
+		spin_lock_bh(&ar_sdio->wr_async_lock);
 	}
-	spin_unlock_irqrestore(&ar_sdio->wr_async_lock, flags);
+	spin_unlock_bh(&ar_sdio->wr_async_lock);
 
 	sdio_release_host(ar_sdio->func);
 }
@@ -520,7 +516,6 @@ static int ath6kl_sdio_write_async(struct ath6kl *ar, u32 address, u8 *buffer,
 {
 	struct ath6kl_sdio *ar_sdio = ath6kl_sdio_priv(ar);
 	struct bus_request *bus_req;
-	unsigned long flags;
 
 	bus_req = ath6kl_sdio_alloc_busreq(ar_sdio);
 
@@ -533,9 +528,9 @@ static int ath6kl_sdio_write_async(struct ath6kl *ar, u32 address, u8 *buffer,
 	bus_req->request = request;
 	bus_req->packet = packet;
 
-	spin_lock_irqsave(&ar_sdio->wr_async_lock, flags);
+	spin_lock_bh(&ar_sdio->wr_async_lock);
 	list_add_tail(&bus_req->list, &ar_sdio->wr_asyncq);
-	spin_unlock_irqrestore(&ar_sdio->wr_async_lock, flags);
+	spin_unlock_bh(&ar_sdio->wr_async_lock);
 	queue_work(ar->ath6kl_wq, &ar_sdio->wr_async_work);
 
 	return 0;
@@ -581,9 +576,8 @@ static struct hif_scatter_req *ath6kl_sdio_scatter_req_get(struct ath6kl *ar)
 {
 	struct ath6kl_sdio *ar_sdio = ath6kl_sdio_priv(ar);
 	struct hif_scatter_req *node = NULL;
-	unsigned long flag;
 
-	spin_lock_irqsave(&ar_sdio->scat_lock, flag);
+	spin_lock_bh(&ar_sdio->scat_lock);
 
 	if (!list_empty(&ar_sdio->scat_req)) {
 		node = list_first_entry(&ar_sdio->scat_req,
@@ -591,7 +585,7 @@ static struct hif_scatter_req *ath6kl_sdio_scatter_req_get(struct ath6kl *ar)
 		list_del(&node->list);
 	}
 
-	spin_unlock_irqrestore(&ar_sdio->scat_lock, flag);
+	spin_unlock_bh(&ar_sdio->scat_lock);
 
 	return node;
 }
@@ -600,13 +594,12 @@ static void ath6kl_sdio_scatter_req_add(struct ath6kl *ar,
 					struct hif_scatter_req *s_req)
 {
 	struct ath6kl_sdio *ar_sdio = ath6kl_sdio_priv(ar);
-	unsigned long flag;
 
-	spin_lock_irqsave(&ar_sdio->scat_lock, flag);
+	spin_lock_bh(&ar_sdio->scat_lock);
 
 	list_add_tail(&s_req->list, &ar_sdio->scat_req);
 
-	spin_unlock_irqrestore(&ar_sdio->scat_lock, flag);
+	spin_unlock_bh(&ar_sdio->scat_lock);
 
 }
 
@@ -617,7 +610,6 @@ static int ath6kl_sdio_async_rw_scatter(struct ath6kl *ar,
 	struct ath6kl_sdio *ar_sdio = ath6kl_sdio_priv(ar);
 	u32 request = scat_req->req;
 	int status = 0;
-	unsigned long flags;
 
 	if (!scat_req->len)
 		return -EINVAL;
@@ -631,9 +623,9 @@ static int ath6kl_sdio_async_rw_scatter(struct ath6kl *ar,
 		status = ath6kl_sdio_scat_rw(ar_sdio, scat_req->busrequest);
 		sdio_release_host(ar_sdio->func);
 	} else {
-		spin_lock_irqsave(&ar_sdio->wr_async_lock, flags);
+		spin_lock_bh(&ar_sdio->wr_async_lock);
 		list_add_tail(&scat_req->busrequest->list, &ar_sdio->wr_asyncq);
-		spin_unlock_irqrestore(&ar_sdio->wr_async_lock, flags);
+		spin_unlock_bh(&ar_sdio->wr_async_lock);
 		queue_work(ar->ath6kl_wq, &ar_sdio->wr_async_work);
 	}
 
@@ -645,13 +637,12 @@ static void ath6kl_sdio_cleanup_scatter(struct ath6kl *ar)
 {
 	struct ath6kl_sdio *ar_sdio = ath6kl_sdio_priv(ar);
 	struct hif_scatter_req *s_req, *tmp_req;
-	unsigned long flag;
 
 	/* empty the free list */
-	spin_lock_irqsave(&ar_sdio->scat_lock, flag);
+	spin_lock_bh(&ar_sdio->scat_lock);
 	list_for_each_entry_safe(s_req, tmp_req, &ar_sdio->scat_req, list) {
 		list_del(&s_req->list);
-		spin_unlock_irqrestore(&ar_sdio->scat_lock, flag);
+		spin_unlock_bh(&ar_sdio->scat_lock);
 
 		if (s_req->busrequest)
 			ath6kl_sdio_free_bus_req(ar_sdio, s_req->busrequest);
@@ -659,9 +650,9 @@ static void ath6kl_sdio_cleanup_scatter(struct ath6kl *ar)
 		kfree(s_req->sgentries);
 		kfree(s_req);
 
-		spin_lock_irqsave(&ar_sdio->scat_lock, flag);
+		spin_lock_bh(&ar_sdio->scat_lock);
 	}
-	spin_unlock_irqrestore(&ar_sdio->scat_lock, flag);
+	spin_unlock_bh(&ar_sdio->scat_lock);
 }
 
 /* setup of HIF scatter resources */
-- 
1.7.0.4

