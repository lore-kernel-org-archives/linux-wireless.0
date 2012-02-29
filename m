Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:33633 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758184Ab2B2RT7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Feb 2012 12:19:59 -0500
Subject: [PATCH 10/12] ath6kl: document all spinlocks
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath6kl-devel@qualcomm.com, linux-wireless@vger.kernel.org
Date: Wed, 29 Feb 2012 19:19:54 +0200
Message-ID: <20120229171954.24264.42635.stgit@localhost6.localdomain6> (sfid-20120229_182017_227027_BFC44737)
In-Reply-To: <20120229171525.24264.22062.stgit@localhost6.localdomain6>
References: <20120229171525.24264.22062.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Also fixes quite a few checkpatch warnings like this:

ath6kl/hif.h:226: CHECK: spinlock_t definition without comment

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/core.h |   21 +++++++++++++++++++++
 drivers/net/wireless/ath/ath6kl/hif.h  |    1 +
 drivers/net/wireless/ath/ath6kl/htc.h  |    7 +++++++
 drivers/net/wireless/ath/ath6kl/sdio.c |    5 +++++
 drivers/net/wireless/ath/ath6kl/wmi.h  |    2 ++
 5 files changed, 36 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index d80b421..50e2771 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -230,6 +230,12 @@ struct rxtid {
 	u32 hold_q_sz;
 	struct skb_hold_q *hold_q;
 	struct sk_buff_head q;
+
+	/*
+	 * FIXME: No clue what this should protect. Apparently it should
+	 * protect some of the fields above but they are also accessed
+	 * without taking the lock.
+	 */
 	spinlock_t lock;
 };
 
@@ -308,7 +314,10 @@ struct ath6kl_sta {
 	u8 auth;
 	u8 wpa_ie[ATH6KL_MAX_IE];
 	struct sk_buff_head psq;
+
+	/* protects psq, mgmt_psq, apsdq, and mgmt_psq_len fields */
 	spinlock_t psq_lock;
+
 	struct list_head mgmt_psq;
 	size_t mgmt_psq_len;
 	u8 apsd_info;
@@ -565,7 +574,13 @@ struct ath6kl {
 	unsigned int vif_max;
 	u8 max_norm_iface;
 	u8 avail_idx_map;
+
+	/*
+	 * Protects at least amsdu_rx_buffer_queue, ath6kl_alloc_cookie()
+	 * calls, tx_pending and total_tx_data_pend.
+	 */
 	spinlock_t lock;
+
 	struct semaphore sem;
 	u16 listen_intvl_b;
 	u8 lrssi_roam_threshold;
@@ -593,7 +608,13 @@ struct ath6kl {
 	u8 sta_list_index;
 	struct ath6kl_req_key ap_mode_bkey;
 	struct sk_buff_head mcastpsq;
+
+	/*
+	 * FIXME: protects access to mcastpsq but is actually useless as
+	 * all skbe_queue_*() functions provide serialisation themselves
+	 */
 	spinlock_t mcastpsq_lock;
+
 	u8 intra_bss;
 	struct wmi_ap_mode_stat ap_stats;
 	u8 ap_country_code[3];
diff --git a/drivers/net/wireless/ath/ath6kl/hif.h b/drivers/net/wireless/ath/ath6kl/hif.h
index 904458a..20ed6b7 100644
--- a/drivers/net/wireless/ath/ath6kl/hif.h
+++ b/drivers/net/wireless/ath/ath6kl/hif.h
@@ -223,6 +223,7 @@ struct ath6kl_irq_enable_reg {
 } __packed;
 
 struct ath6kl_device {
+	/* protects irq_proc_reg and irq_en_reg below */
 	spinlock_t lock;
 	struct ath6kl_irq_proc_registers irq_proc_reg;
 	struct ath6kl_irq_enable_reg irq_en_reg;
diff --git a/drivers/net/wireless/ath/ath6kl/htc.h b/drivers/net/wireless/ath/ath6kl/htc.h
index 2de4d6f..5027ccc 100644
--- a/drivers/net/wireless/ath/ath6kl/htc.h
+++ b/drivers/net/wireless/ath/ath6kl/htc.h
@@ -523,9 +523,16 @@ struct htc_target {
 	struct ath6kl_htc_credit_info *credit_info;
 	int tgt_creds;
 	unsigned int tgt_cred_sz;
+
+	/* protects free_ctrl_txbuf and free_ctrl_rxbuf */
 	spinlock_t htc_lock;
+
+	/* FIXME: does this protext rx_bufq and endpoint structures or what? */
 	spinlock_t rx_lock;
+
+	/* protects endpoint->txq */
 	spinlock_t tx_lock;
+
 	struct ath6kl_device *dev;
 	u32 htc_flags;
 	u32 rx_st_flags;
diff --git a/drivers/net/wireless/ath/ath6kl/sdio.c b/drivers/net/wireless/ath/ath6kl/sdio.c
index da14ca6..144721e 100644
--- a/drivers/net/wireless/ath/ath6kl/sdio.c
+++ b/drivers/net/wireless/ath/ath6kl/sdio.c
@@ -32,6 +32,7 @@
 struct ath6kl_sdio {
 	struct sdio_func *func;
 
+	/* protects access to bus_req_freeq */
 	spinlock_t lock;
 
 	/* free list */
@@ -53,13 +54,17 @@ struct ath6kl_sdio {
 	/* Avoids disabling irq while the interrupts being handled */
 	struct mutex mtx_irq;
 
+	/* protects access to scat_req */
 	spinlock_t scat_lock;
+
 	bool scatter_enabled;
 
 	bool is_disabled;
 	const struct sdio_device_id *id;
 	struct work_struct wr_async_work;
 	struct list_head wr_asyncq;
+
+	/* protects access to wr_asyncq */
 	spinlock_t wr_async_lock;
 };
 
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.h b/drivers/net/wireless/ath/ath6kl/wmi.h
index 38907f4..9137850 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.h
+++ b/drivers/net/wireless/ath/ath6kl/wmi.h
@@ -111,6 +111,8 @@ struct wmi {
 	u8 fat_pipe_exist;
 	struct ath6kl *parent_dev;
 	u8 pwr_mode;
+
+	/* protects fat_pipe_exist and stream_exist_for_ac */
 	spinlock_t lock;
 	enum htc_endpoint_id ep_id;
 	struct sq_threshold_params

