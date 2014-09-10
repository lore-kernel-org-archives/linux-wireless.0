Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:33944 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850AbaIJNgD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Sep 2014 09:36:03 -0400
Cc: Dedy Lansky <qca_dlansky@qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>,
	"Vladimir Kondratiev" <qca_vkondrat@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
Subject: [PATCH 17/22] wil6210: introduce separate completion for WMI
Date: Wed, 10 Sep 2014 16:34:46 +0300
Message-ID: <1410356091-19219-18-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20140910_153608_433649_F2CF0B71)
In-Reply-To: <1410356091-19219-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1410356091-19219-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Dedy Lansky <qca_dlansky@qca.qualcomm.com>

re-use of wmi_ready for both FW ready event and for wmi_call was causing
false "FW not ready" indication in case wmi_call() was invoked while reset
took place.
add wmi_call completion variable instead of re-using wmi_ready.

Signed-off-by: Dedy Lansky <qca_dlansky@qca.qualcomm.com>
Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/main.c    | 2 ++
 drivers/net/wireless/ath/wil6210/wil6210.h | 1 +
 drivers/net/wireless/ath/wil6210/wmi.c     | 8 ++++----
 3 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index d2f2c1e..0857853 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -286,6 +286,7 @@ int wil_priv_init(struct wil6210_priv *wil)
 	mutex_init(&wil->wmi_mutex);
 
 	init_completion(&wil->wmi_ready);
+	init_completion(&wil->wmi_call);
 
 	wil->pending_connect_cid = -1;
 	setup_timer(&wil->connect_timer, wil_connect_timer_fn, (ulong)wil);
@@ -536,6 +537,7 @@ int wil_reset(struct wil6210_priv *wil)
 	/* init after reset */
 	wil->pending_connect_cid = -1;
 	reinit_completion(&wil->wmi_ready);
+	reinit_completion(&wil->wmi_call);
 
 	wil6210_enable_irq(wil);
 
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index 1b11934..f8f9988 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -399,6 +399,7 @@ struct wil6210_priv {
 	struct mutex wmi_mutex;
 	struct wil6210_mbox_ctl mbox_ctl;
 	struct completion wmi_ready;
+	struct completion wmi_call;
 	u16 wmi_seq;
 	u16 reply_id; /**< wait for this WMI event */
 	void *reply_buf;
diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index 789c316..bd781c7 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -300,7 +300,7 @@ static void wmi_evt_fw_ready(struct wil6210_priv *wil, int id, void *d,
 	wil_dbg_wmi(wil, "WMI: got FW ready event\n");
 
 	set_bit(wil_status_fwready, &wil->status);
-	/* reuse wmi_ready for the firmware ready indication */
+	/* let the reset sequence continue */
 	complete(&wil->wmi_ready);
 }
 
@@ -764,8 +764,8 @@ int wmi_call(struct wil6210_priv *wil, u16 cmdid, void *buf, u16 len,
 	wil->reply_id = reply_id;
 	wil->reply_buf = reply;
 	wil->reply_size = reply_size;
-	remain = wait_for_completion_timeout(&wil->wmi_ready,
-			msecs_to_jiffies(to_msec));
+	remain = wait_for_completion_timeout(&wil->wmi_call,
+					     msecs_to_jiffies(to_msec));
 	if (0 == remain) {
 		wil_err(wil, "wmi_call(0x%04x->0x%04x) timeout %d msec\n",
 			cmdid, reply_id, to_msec);
@@ -1160,7 +1160,7 @@ static void wmi_event_handle(struct wil6210_priv *wil,
 						     len - sizeof(*wmi));
 			}
 			wil_dbg_wmi(wil, "Complete WMI 0x%04x\n", id);
-			complete(&wil->wmi_ready);
+			complete(&wil->wmi_call);
 			return;
 		}
 		/* unsolicited event */
-- 
1.9.1

