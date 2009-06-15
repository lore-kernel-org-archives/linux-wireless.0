Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga10.intel.com ([192.55.52.92]:28213 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754572AbZFOT6B (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Jun 2009 15:58:01 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>,
	Samuel Ortiz <samuel.ortiz@intel.com>
Subject: [PATCH 06/11 v2][w-t] iwmc3200wifi: handling wifi_if_ntfy responses
Date: Mon, 15 Jun 2009 21:59:51 +0200
Message-Id: <445a117dd08007f653105f41f36f9bbf2ed1e4c6.1245091931.git.samuel@sortiz.org>
In-Reply-To: <4fa0241c41670096a2933b81c7bd32e6a5551faa.1245091931.git.samuel@sortiz.org>
References: <cover.1245091931.git.samuel@sortiz.org>
 <7413d2605b449b8e43bcfe61719ee30fccb592b7.1245091931.git.samuel@sortiz.org>
 <e72e3c0d6b16655fdf4da5dcabc6349be7b5c0a2.1245091931.git.samuel@sortiz.org>
 <4fa0241c41670096a2933b81c7bd32e6a5551faa.1245091931.git.samuel@sortiz.org>
In-Reply-To: <cover.1245091931.git.samuel@sortiz.org>
References: <cover.1245091931.git.samuel@sortiz.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Samuel Ortiz <samuel.ortiz@intel.com>

When we're calling iwm_send_wifi_if_cmd() with the resp flag set, we're
currently waiting on the mlme queue, waiting for some flags here and there to
show up.
This patch adds a wifi_ntfy bitmap, and when we're sending a wifi_if command
expecting an answers, we wait synchronously for it to show up, on a dedicated
queue. The wifi_ntfy bit is set when we receive the corresponding answer.

Signed-off-by: Samuel Ortiz <samuel.ortiz@intel.com>
---
 drivers/net/wireless/iwmc3200wifi/commands.c |   31 +++++++++++++++-----------
 drivers/net/wireless/iwmc3200wifi/iwm.h      |    3 ++
 drivers/net/wireless/iwmc3200wifi/main.c     |    1 +
 drivers/net/wireless/iwmc3200wifi/rx.c       |    9 ++++++-
 drivers/net/wireless/iwmc3200wifi/umac.h     |    2 +
 5 files changed, 31 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/iwmc3200wifi/commands.c b/drivers/net/wireless/iwmc3200wifi/commands.c
index 834a7f5..337a884 100644
--- a/drivers/net/wireless/iwmc3200wifi/commands.c
+++ b/drivers/net/wireless/iwmc3200wifi/commands.c
@@ -70,14 +70,28 @@ static int iwm_send_lmac_ptrough_cmd(struct iwm_priv *iwm,
 int iwm_send_wifi_if_cmd(struct iwm_priv *iwm, void *payload, u16 payload_size,
 			 bool resp)
 {
+	struct iwm_umac_wifi_if *hdr = (struct iwm_umac_wifi_if *)payload;
 	struct iwm_udma_wifi_cmd udma_cmd = UDMA_UMAC_INIT;
 	struct iwm_umac_cmd umac_cmd;
+	int ret;
+	u8 oid = hdr->oid;
 
 	umac_cmd.id = UMAC_CMD_OPCODE_WIFI_IF_WRAPPER;
 	umac_cmd.resp = resp;
 
-	return iwm_hal_send_umac_cmd(iwm, &udma_cmd, &umac_cmd,
-				     payload, payload_size);
+	ret = iwm_hal_send_umac_cmd(iwm, &udma_cmd, &umac_cmd,
+				    payload, payload_size);
+
+	if (resp) {
+		ret = wait_event_interruptible_timeout(iwm->wifi_ntfy_queue,
+				   test_and_clear_bit(oid, &iwm->wifi_ntfy[0]),
+				   3 * HZ);
+
+		if (!ret)
+			ret = -EBUSY;
+	}
+
+	return ret;
 }
 
 static struct coex_event iwm_sta_xor_prio_tbl[COEX_EVENTS_NUM] =
@@ -746,14 +760,6 @@ int iwm_send_mlme_profile(struct iwm_priv *iwm)
 		return ret;
 	}
 
-	/* Wait for the profile to be active */
-	ret = wait_event_interruptible_timeout(iwm->mlme_queue,
-					       iwm->umac_profile_active == 1,
-					       3 * HZ);
-	if (!ret)
-		return -EBUSY;
-
-
 	for (i = 0; i < IWM_NUM_KEYS; i++)
 		if (iwm->keys[i].in_use) {
 			int default_key = 0;
@@ -778,8 +784,8 @@ int iwm_send_mlme_profile(struct iwm_priv *iwm)
 
 int iwm_invalidate_mlme_profile(struct iwm_priv *iwm)
 {
-	int ret;
 	struct iwm_umac_invalidate_profile invalid;
+	int ret;
 
 	invalid.hdr.oid = UMAC_WIFI_IF_CMD_INVALIDATE_PROFILE;
 	invalid.hdr.buf_size =
@@ -793,8 +799,7 @@ int iwm_invalidate_mlme_profile(struct iwm_priv *iwm)
 		return ret;
 
 	ret = wait_event_interruptible_timeout(iwm->mlme_queue,
-				 (iwm->umac_profile_active == 0),
-					       2 * HZ);
+				(iwm->umac_profile_active == 0), 2 * HZ);
 	if (!ret)
 		return -EBUSY;
 
diff --git a/drivers/net/wireless/iwmc3200wifi/iwm.h b/drivers/net/wireless/iwmc3200wifi/iwm.h
index 77c339f..d8d4ae2 100644
--- a/drivers/net/wireless/iwmc3200wifi/iwm.h
+++ b/drivers/net/wireless/iwmc3200wifi/iwm.h
@@ -278,6 +278,9 @@ struct iwm_priv {
 	struct iwm_key keys[IWM_NUM_KEYS];
 	struct iwm_key *default_key;
 
+	DECLARE_BITMAP(wifi_ntfy, WIFI_IF_NTFY_MAX);
+	wait_queue_head_t wifi_ntfy_queue;
+
 	wait_queue_head_t mlme_queue;
 
 	struct iw_statistics wstats;
diff --git a/drivers/net/wireless/iwmc3200wifi/main.c b/drivers/net/wireless/iwmc3200wifi/main.c
index 8be206d..8448722 100644
--- a/drivers/net/wireless/iwmc3200wifi/main.c
+++ b/drivers/net/wireless/iwmc3200wifi/main.c
@@ -191,6 +191,7 @@ int iwm_priv_init(struct iwm_priv *iwm)
 	INIT_LIST_HEAD(&iwm->pending_notif);
 	init_waitqueue_head(&iwm->notif_queue);
 	init_waitqueue_head(&iwm->nonwifi_queue);
+	init_waitqueue_head(&iwm->wifi_ntfy_queue);
 	init_waitqueue_head(&iwm->mlme_queue);
 	memcpy(&iwm->conf, &def_iwm_conf, sizeof(struct iwm_conf));
 	spin_lock_init(&iwm->tx_credit.lock);
diff --git a/drivers/net/wireless/iwmc3200wifi/rx.c b/drivers/net/wireless/iwmc3200wifi/rx.c
index d73cf96..49a8be7 100644
--- a/drivers/net/wireless/iwmc3200wifi/rx.c
+++ b/drivers/net/wireless/iwmc3200wifi/rx.c
@@ -993,12 +993,17 @@ static int iwm_ntf_wifi_if_wrapper(struct iwm_priv *iwm, u8 *buf,
 			(struct iwm_umac_wifi_if *)cmd->buf.payload;
 
 	IWM_DBG_NTF(iwm, DBG, "WIFI_IF_WRAPPER cmd is delivered to UMAC: "
-		    "oid is %d\n", hdr->oid);
+		    "oid is 0x%x\n", hdr->oid);
+
+	if (hdr->oid <= WIFI_IF_NTFY_MAX) {
+		set_bit(hdr->oid, &iwm->wifi_ntfy[0]);
+		wake_up_interruptible(&iwm->wifi_ntfy_queue);
+	} else
+		return -EINVAL;
 
 	switch (hdr->oid) {
 	case UMAC_WIFI_IF_CMD_SET_PROFILE:
 		iwm->umac_profile_active = 1;
-		wake_up_interruptible(&iwm->mlme_queue);
 		break;
 	default:
 		break;
diff --git a/drivers/net/wireless/iwmc3200wifi/umac.h b/drivers/net/wireless/iwmc3200wifi/umac.h
index 4a95cce..0af2a3c 100644
--- a/drivers/net/wireless/iwmc3200wifi/umac.h
+++ b/drivers/net/wireless/iwmc3200wifi/umac.h
@@ -495,6 +495,8 @@ struct iwm_fw_alive_hdr {
 #define WIFI_DBG_IF_NTFY_COEX_HANDLE_ENVELOP		0xE8
 #define WIFI_DBG_IF_NTFY_COEX_HANDLE_RELEASE_ENVELOP	0xE9
 
+#define WIFI_IF_NTFY_MAX 0xff
+
 /* Notification structures */
 struct iwm_umac_notif_wifi_if {
 	struct iwm_umac_wifi_in_hdr hdr;
-- 
1.6.3.1

