Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:17613 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753423AbaB0OVd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Feb 2014 09:21:33 -0500
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH 06/16] wil6210: Find free vring for Tx
Date: Thu, 27 Feb 2014 16:20:45 +0200
Message-ID: <1393510855-17566-7-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20140227_152148_155912_1C7F1890)
In-Reply-To: <1393510855-17566-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1393510855-17566-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There are 24 possible Tx vrings; when doind multiple connections, more then
one vring has to be used. Search for free one and select it.

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/main.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index 38906f1..5079e49 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -107,12 +107,23 @@ static void wil_connect_timer_fn(ulong x)
 	schedule_work(&wil->disconnect_worker);
 }
 
+static int wil_find_free_vring(struct wil6210_priv *wil)
+{
+	int i;
+	for (i = 0; i < WIL6210_MAX_TX_RINGS; i++) {
+		if (!wil->vring_tx[i].va)
+			return i;
+	}
+	return -EINVAL;
+}
+
 static void wil_connect_worker(struct work_struct *work)
 {
 	int rc;
 	struct wil6210_priv *wil = container_of(work, struct wil6210_priv,
 						connect_worker);
 	int cid = wil->pending_connect_cid;
+	int ringid = wil_find_free_vring(wil);
 
 	if (cid < 0) {
 		wil_err(wil, "No connection pending\n");
@@ -121,7 +132,7 @@ static void wil_connect_worker(struct work_struct *work)
 
 	wil_dbg_wmi(wil, "Configure for connection CID %d\n", cid);
 
-	rc = wil_vring_init_tx(wil, 0, WIL6210_TX_RING_SIZE, cid, 0);
+	rc = wil_vring_init_tx(wil, ringid, WIL6210_TX_RING_SIZE, cid, 0);
 	wil->pending_connect_cid = -1;
 	if (rc == 0) {
 		wil->sta[cid].status = wil_sta_connected;
-- 
1.8.3.2

