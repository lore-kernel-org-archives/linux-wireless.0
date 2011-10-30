Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh06.mail.saunalahti.fi ([62.142.5.116]:43979 "EHLO
	emh06.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260Ab1J3TQN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Oct 2011 15:16:13 -0400
Subject: [PATCH 1/5] ath6kl: create ath6kl_hif_stop()
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Sun, 30 Oct 2011 21:15:57 +0200
Message-ID: <20111030191556.20466.19407.stgit@localhost6.localdomain6> (sfid-20111030_201622_727387_90FCEB72)
In-Reply-To: <20111030190922.20466.299.stgit@localhost6.localdomain6>
References: <20111030190922.20466.299.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is to reset hif layer for powering down hw.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/hif-ops.h |    7 +++++
 drivers/net/wireless/ath/ath6kl/hif.h     |    1 +
 drivers/net/wireless/ath/ath6kl/sdio.c    |   45 +++++++++++++++++++++++++++++
 3 files changed, 53 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/hif-ops.h b/drivers/net/wireless/ath/ath6kl/hif-ops.h
index 34adc77..50fd3e9 100644
--- a/drivers/net/wireless/ath/ath6kl/hif-ops.h
+++ b/drivers/net/wireless/ath/ath6kl/hif-ops.h
@@ -111,4 +111,11 @@ static inline int ath6kl_hif_power_off(struct ath6kl *ar)
 	return ar->hif_ops->power_off(ar);
 }
 
+static inline void ath6kl_hif_stop(struct ath6kl *ar)
+{
+	ath6kl_dbg(ATH6KL_DBG_HIF, "hif stop\n");
+
+	ar->hif_ops->stop(ar);
+}
+
 #endif
diff --git a/drivers/net/wireless/ath/ath6kl/hif.h b/drivers/net/wireless/ath/ath6kl/hif.h
index 78a6c79..814386d 100644
--- a/drivers/net/wireless/ath/ath6kl/hif.h
+++ b/drivers/net/wireless/ath/ath6kl/hif.h
@@ -246,6 +246,7 @@ struct ath6kl_hif_ops {
 	int (*resume)(struct ath6kl *ar);
 	int (*power_on)(struct ath6kl *ar);
 	int (*power_off)(struct ath6kl *ar);
+	void (*stop)(struct ath6kl *ar);
 };
 
 int ath6kl_hif_setup(struct ath6kl_device *dev);
diff --git a/drivers/net/wireless/ath/ath6kl/sdio.c b/drivers/net/wireless/ath/ath6kl/sdio.c
index 682c47c..c61c512 100644
--- a/drivers/net/wireless/ath/ath6kl/sdio.c
+++ b/drivers/net/wireless/ath/ath6kl/sdio.c
@@ -45,6 +45,8 @@ struct ath6kl_sdio {
 	struct list_head scat_req;
 
 	spinlock_t scat_lock;
+	bool scatter_enabled;
+
 	bool is_disabled;
 	atomic_t irq_handling;
 	const struct sdio_device_id *id;
@@ -651,6 +653,11 @@ static void ath6kl_sdio_cleanup_scatter(struct ath6kl *ar)
 		list_del(&s_req->list);
 		spin_unlock_bh(&ar_sdio->scat_lock);
 
+		/*
+		 * FIXME: should we also call completion handler with
+		 * ath6kl_hif_rw_comp_handler() with status -ECANCELED so
+		 * that the packet is properly freed?
+		 */
 		if (s_req->busrequest)
 			ath6kl_sdio_free_bus_req(ar_sdio, s_req->busrequest);
 		kfree(s_req->virt_dma_buf);
@@ -670,6 +677,11 @@ static int ath6kl_sdio_enable_scatter(struct ath6kl *ar)
 	int ret;
 	bool virt_scat = false;
 
+	if (ar_sdio->scatter_enabled)
+		return 0;
+
+	ar_sdio->scatter_enabled = true;
+
 	/* check if host supports scatter and it meets our requirements */
 	if (ar_sdio->func->card->host->max_segs < MAX_SCATTER_ENTRIES_PER_REQ) {
 		ath6kl_err("host only supports scatter of :%d entries, need: %d\n",
@@ -762,6 +774,38 @@ static int ath6kl_sdio_resume(struct ath6kl *ar)
 	return 0;
 }
 
+static void ath6kl_sdio_stop(struct ath6kl *ar)
+{
+	struct ath6kl_sdio *ar_sdio = ath6kl_sdio_priv(ar);
+	struct bus_request *req, *tmp_req;
+	void *context;
+
+	/* FIXME: make sure that wq is not queued again */
+
+	cancel_work_sync(&ar_sdio->wr_async_work);
+
+	spin_lock_bh(&ar_sdio->wr_async_lock);
+
+	list_for_each_entry_safe(req, tmp_req, &ar_sdio->wr_asyncq, list) {
+		list_del(&req->list);
+
+		if (req->scat_req) {
+			/* this is a scatter gather request */
+			req->scat_req->status = -ECANCELED;
+			req->scat_req->complete(ar_sdio->ar->htc_target,
+						req->scat_req);
+		} else {
+			context = req->packet;
+			ath6kl_sdio_free_bus_req(ar_sdio, req);
+			ath6kl_hif_rw_comp_handler(context, -ECANCELED);
+		}
+	}
+
+	spin_unlock_bh(&ar_sdio->wr_async_lock);
+
+	WARN_ON(get_queue_depth(&ar_sdio->scat_req) != 4);
+}
+
 static const struct ath6kl_hif_ops ath6kl_sdio_ops = {
 	.read_write_sync = ath6kl_sdio_read_write_sync,
 	.write_async = ath6kl_sdio_write_async,
@@ -776,6 +820,7 @@ static const struct ath6kl_hif_ops ath6kl_sdio_ops = {
 	.resume = ath6kl_sdio_resume,
 	.power_on = ath6kl_sdio_power_on,
 	.power_off = ath6kl_sdio_power_off,
+	.stop = ath6kl_sdio_stop,
 };
 
 static int ath6kl_sdio_probe(struct sdio_func *func,

