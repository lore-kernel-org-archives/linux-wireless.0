Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:10757 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932330Ab3CMMNT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Mar 2013 08:13:19 -0400
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
Subject: [PATCH 06/14] wil6210: refactor connect_worker
Date: Wed, 13 Mar 2013 14:12:43 +0200
Message-ID: <1363176771-10082-7-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20130313_131352_642025_8922E998)
In-Reply-To: <1363176771-10082-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1363176771-10082-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move wmi_connect_worker() to the main.c and change names for consistency.

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/main.c    |   22 +++++++++++++++++++++-
 drivers/net/wireless/ath/wil6210/wil6210.h |    3 +--
 drivers/net/wireless/ath/wil6210/wmi.c     |   23 +----------------------
 3 files changed, 23 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index 761c389..11b6960 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -118,6 +118,26 @@ static void wil_cache_mbox_regs(struct wil6210_priv *wil)
 	wil_mbox_ring_le2cpus(&wil->mbox_ctl.tx);
 }
 
+static void wil_connect_worker(struct work_struct *work)
+{
+	int rc;
+	struct wil6210_priv *wil = container_of(work, struct wil6210_priv,
+						connect_worker);
+	int cid = wil->pending_connect_cid;
+
+	if (cid < 0) {
+		wil_err(wil, "No connection pending\n");
+		return;
+	}
+
+	wil_dbg_wmi(wil, "Configure for connection CID %d\n", cid);
+
+	rc = wil_vring_init_tx(wil, 0, WIL6210_TX_RING_SIZE, cid, 0);
+	wil->pending_connect_cid = -1;
+	if (rc == 0)
+		wil_link_on(wil);
+}
+
 int wil_priv_init(struct wil6210_priv *wil)
 {
 	wil_dbg_misc(wil, "%s()\n", __func__);
@@ -130,7 +150,7 @@ int wil_priv_init(struct wil6210_priv *wil)
 	wil->pending_connect_cid = -1;
 	setup_timer(&wil->connect_timer, wil_connect_timer_fn, (ulong)wil);
 
-	INIT_WORK(&wil->wmi_connect_worker, wmi_connect_worker);
+	INIT_WORK(&wil->connect_worker, wil_connect_worker);
 	INIT_WORK(&wil->disconnect_worker, wil_disconnect_worker);
 	INIT_WORK(&wil->wmi_event_worker, wmi_event_worker);
 
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index bdab0e2..5f500de 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -225,7 +225,7 @@ struct wil6210_priv {
 	struct workqueue_struct *wmi_wq; /* for deferred calls */
 	struct work_struct wmi_event_worker;
 	struct workqueue_struct *wmi_wq_conn; /* for connect worker */
-	struct work_struct wmi_connect_worker;
+	struct work_struct connect_worker;
 	struct work_struct disconnect_worker;
 	struct timer_list connect_timer;
 	int pending_connect_cid;
@@ -311,7 +311,6 @@ int wmi_send(struct wil6210_priv *wil, u16 cmdid, void *buf, u16 len);
 void wmi_recv_cmd(struct wil6210_priv *wil);
 int wmi_call(struct wil6210_priv *wil, u16 cmdid, void *buf, u16 len,
 	     u16 reply_id, void *reply, u8 reply_size, int to_msec);
-void wmi_connect_worker(struct work_struct *work);
 void wmi_event_worker(struct work_struct *work);
 void wmi_event_flush(struct wil6210_priv *wil);
 int wmi_set_ssid(struct wil6210_priv *wil, u8 ssid_len, const void *ssid);
diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index aa642df..dd3b7b1 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -443,7 +443,7 @@ static void wmi_evt_connect(struct wil6210_priv *wil, int id, void *d, int len)
 	memcpy(wil->dst_addr[0], evt->bssid, ETH_ALEN);
 
 	wil->pending_connect_cid = evt->cid;
-	queue_work(wil->wmi_wq_conn, &wil->wmi_connect_worker);
+	queue_work(wil->wmi_wq_conn, &wil->connect_worker);
 }
 
 static void wmi_evt_disconnect(struct wil6210_priv *wil, int id,
@@ -1031,24 +1031,3 @@ void wmi_event_worker(struct work_struct *work)
 		kfree(evt);
 	}
 }
-
-void wmi_connect_worker(struct work_struct *work)
-{
-	int rc;
-	struct wil6210_priv *wil = container_of(work, struct wil6210_priv,
-						wmi_connect_worker);
-
-	if (wil->pending_connect_cid < 0) {
-		wil_err(wil, "No connection pending\n");
-		return;
-	}
-
-	wil_dbg_wmi(wil, "Configure for connection CID %d\n",
-		    wil->pending_connect_cid);
-
-	rc = wil_vring_init_tx(wil, 0, WIL6210_TX_RING_SIZE,
-			       wil->pending_connect_cid, 0);
-	wil->pending_connect_cid = -1;
-	if (rc == 0)
-		wil_link_on(wil);
-}
-- 
1.7.10.4

