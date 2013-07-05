Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:55645 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757382Ab3GENPX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Jul 2013 09:15:23 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@lists.ath9k.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 13/16] ath10k: embed HTT struct inside ath10k
Date: Fri,  5 Jul 2013 16:15:14 +0300
Message-Id: <1373030117-18077-14-git-send-email-kvalo@qca.qualcomm.com> (sfid-20130705_151538_842902_0071EF53)
In-Reply-To: <1373030117-18077-1-git-send-email-kvalo@qca.qualcomm.com>
References: <1373030117-18077-1-git-send-email-kvalo@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michal Kazior <michal.kazior@tieto.com>

This reduces number of allocations and simplifies
memory managemnt.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.c   |   12 ++++++------
 drivers/net/wireless/ath/ath10k/core.h   |    7 +++----
 drivers/net/wireless/ath/ath10k/htt.c    |   25 +++++++++++++------------
 drivers/net/wireless/ath/ath10k/htt.h    |    3 +--
 drivers/net/wireless/ath/ath10k/htt_rx.c |    3 ++-
 drivers/net/wireless/ath/ath10k/htt_tx.c |    2 +-
 drivers/net/wireless/ath/ath10k/mac.c    |   16 ++++++++--------
 7 files changed, 34 insertions(+), 34 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 4199560..f1312fa 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -556,9 +556,9 @@ int ath10k_core_register(struct ath10k *ar)
 	if (status)
 		goto err_wmi_detach;
 
-	ar->htt = ath10k_htt_attach(ar);
-	if (!ar->htt) {
-		status = -ENOMEM;
+	status = ath10k_htt_attach(ar);
+	if (status) {
+		ath10k_err("could not attach htt (%d)\n", status);
 		goto err_wmi_detach;
 	}
 
@@ -585,7 +585,7 @@ int ath10k_core_register(struct ath10k *ar)
 		goto err_disconnect_htc;
 	}
 
-	status = ath10k_htt_attach_target(ar->htt);
+	status = ath10k_htt_attach_target(&ar->htt);
 	if (status)
 		goto err_disconnect_htc;
 
@@ -606,7 +606,7 @@ err_unregister_mac:
 err_disconnect_htc:
 	ath10k_htc_stop(&ar->htc);
 err_htt_detach:
-	ath10k_htt_detach(ar->htt);
+	ath10k_htt_detach(&ar->htt);
 err_wmi_detach:
 	ath10k_wmi_detach(ar);
 err:
@@ -621,7 +621,7 @@ void ath10k_core_unregister(struct ath10k *ar)
 	 * unhappy about callback failures. */
 	ath10k_mac_unregister(ar);
 	ath10k_htc_stop(&ar->htc);
-	ath10k_htt_detach(ar->htt);
+	ath10k_htt_detach(&ar->htt);
 	ath10k_wmi_detach(ar);
 }
 EXPORT_SYMBOL(ath10k_core_unregister);
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index dfd4fe1..2f7065c 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -23,6 +23,7 @@
 #include <linux/types.h>
 #include <linux/pci.h>
 
+#include "htt.h"
 #include "htc.h"
 #include "hw.h"
 #include "targaddrs.h"
@@ -273,15 +274,13 @@ struct ath10k {
 		const struct ath10k_hif_ops *ops;
 	} hif;
 
-	struct ath10k_wmi wmi;
-
 	wait_queue_head_t event_queue;
 	bool is_target_paused;
 
 	struct ath10k_bmi bmi;
+	struct ath10k_wmi wmi;
 	struct ath10k_htc htc;
-
-	struct ath10k_htt *htt;
+	struct ath10k_htt htt;
 
 	struct ath10k_hw_params {
 		u32 id;
diff --git a/drivers/net/wireless/ath/ath10k/htt.c b/drivers/net/wireless/ath/ath10k/htt.c
index 2bfb9b4..39342c5 100644
--- a/drivers/net/wireless/ath/ath10k/htt.c
+++ b/drivers/net/wireless/ath/ath10k/htt.c
@@ -16,6 +16,7 @@
  */
 
 #include <linux/slab.h>
+#include <linux/if_ether.h>
 
 #include "htt.h"
 #include "core.h"
@@ -47,15 +48,11 @@ static int ath10k_htt_htc_attach(struct ath10k_htt *htt)
 	return 0;
 }
 
-struct ath10k_htt *ath10k_htt_attach(struct ath10k *ar)
+int ath10k_htt_attach(struct ath10k *ar)
 {
-	struct ath10k_htt *htt;
+	struct ath10k_htt *htt = &ar->htt;
 	int ret;
 
-	htt = kzalloc(sizeof(*htt), GFP_KERNEL);
-	if (!htt)
-		return NULL;
-
 	htt->ar = ar;
 	htt->max_throughput_mbps = 800;
 
@@ -65,8 +62,11 @@ struct ath10k_htt *ath10k_htt_attach(struct ath10k *ar)
 	 * since ath10k_htt_rx_attach involves sending a rx ring configure
 	 * message to the target.
 	 */
-	if (ath10k_htt_htc_attach(htt))
+	ret = ath10k_htt_htc_attach(htt);
+	if (ret) {
+		ath10k_err("could not attach htt htc (%d)\n", ret);
 		goto err_htc_attach;
+	}
 
 	ret = ath10k_htt_tx_attach(htt);
 	if (ret) {
@@ -74,8 +74,11 @@ struct ath10k_htt *ath10k_htt_attach(struct ath10k *ar)
 		goto err_htc_attach;
 	}
 
-	if (ath10k_htt_rx_attach(htt))
+	ret = ath10k_htt_rx_attach(htt);
+	if (ret) {
+		ath10k_err("could not attach htt rx (%d)\n", ret);
 		goto err_rx_attach;
+	}
 
 	/*
 	 * Prefetch enough data to satisfy target
@@ -89,13 +92,12 @@ struct ath10k_htt *ath10k_htt_attach(struct ath10k *ar)
 		8 + /* llc snap */
 		2; /* ip4 dscp or ip6 priority */
 
-	return htt;
+	return 0;
 
 err_rx_attach:
 	ath10k_htt_tx_detach(htt);
 err_htc_attach:
-	kfree(htt);
-	return NULL;
+	return ret;
 }
 
 #define HTT_TARGET_VERSION_TIMEOUT_HZ (3*HZ)
@@ -148,5 +150,4 @@ void ath10k_htt_detach(struct ath10k_htt *htt)
 {
 	ath10k_htt_rx_detach(htt);
 	ath10k_htt_tx_detach(htt);
-	kfree(htt);
 }
diff --git a/drivers/net/wireless/ath/ath10k/htt.h b/drivers/net/wireless/ath/ath10k/htt.h
index a7a7aa0..318be46 100644
--- a/drivers/net/wireless/ath/ath10k/htt.h
+++ b/drivers/net/wireless/ath/ath10k/htt.h
@@ -20,7 +20,6 @@
 
 #include <linux/bug.h>
 
-#include "core.h"
 #include "htc.h"
 #include "rx_desc.h"
 
@@ -1317,7 +1316,7 @@ struct htt_rx_desc {
 #define HTT_LOG2_MAX_CACHE_LINE_SIZE 7	/* 2^7 = 128 */
 #define HTT_MAX_CACHE_LINE_SIZE_MASK ((1 << HTT_LOG2_MAX_CACHE_LINE_SIZE) - 1)
 
-struct ath10k_htt *ath10k_htt_attach(struct ath10k *ar);
+int ath10k_htt_attach(struct ath10k *ar);
 int ath10k_htt_attach_target(struct ath10k_htt *htt);
 void ath10k_htt_detach(struct ath10k_htt *htt);
 
diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index de058d7..04f08d9 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -15,6 +15,7 @@
  * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
+#include "core.h"
 #include "htc.h"
 #include "htt.h"
 #include "txrx.h"
@@ -1036,7 +1037,7 @@ end:
 
 void ath10k_htt_t2h_msg_handler(struct ath10k *ar, struct sk_buff *skb)
 {
-	struct ath10k_htt *htt = ar->htt;
+	struct ath10k_htt *htt = &ar->htt;
 	struct htt_resp *resp = (struct htt_resp *)skb->data;
 
 	/* confirm alignment */
diff --git a/drivers/net/wireless/ath/ath10k/htt_tx.c b/drivers/net/wireless/ath/ath10k/htt_tx.c
index fa568f1..dc3f3e8 100644
--- a/drivers/net/wireless/ath/ath10k/htt_tx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_tx.c
@@ -153,7 +153,7 @@ void ath10k_htt_tx_detach(struct ath10k_htt *htt)
 void ath10k_htt_htc_tx_complete(struct ath10k *ar, struct sk_buff *skb)
 {
 	struct ath10k_skb_cb *skb_cb = ATH10K_SKB_CB(skb);
-	struct ath10k_htt *htt = ar->htt;
+	struct ath10k_htt *htt = &ar->htt;
 
 	if (skb_cb->htt.is_conf) {
 		dev_kfree_skb_any(skb);
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index cdee800..7bc746f 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -1394,15 +1394,15 @@ static void ath10k_tx_htt(struct ath10k *ar, struct sk_buff *skb)
 	int ret;
 
 	if (ieee80211_is_mgmt(hdr->frame_control))
-		ret = ath10k_htt_mgmt_tx(ar->htt, skb);
+		ret = ath10k_htt_mgmt_tx(&ar->htt, skb);
 	else if (ieee80211_is_nullfunc(hdr->frame_control))
 		/* FW does not report tx status properly for NullFunc frames
 		 * unless they are sent through mgmt tx path. mac80211 sends
 		 * those frames when it detects link/beacon loss and depends on
 		 * the tx status to be correct. */
-		ret = ath10k_htt_mgmt_tx(ar->htt, skb);
+		ret = ath10k_htt_mgmt_tx(&ar->htt, skb);
 	else
-		ret = ath10k_htt_tx(ar->htt, skb);
+		ret = ath10k_htt_tx(&ar->htt, skb);
 
 	if (ret) {
 		ath10k_warn("tx failed (%d). dropping packet.\n", ret);
@@ -2656,12 +2656,12 @@ static void ath10k_flush(struct ieee80211_hw *hw, u32 queues, bool drop)
 	if (drop)
 		return;
 
-	ret = wait_event_timeout(ar->htt->empty_tx_wq, ({
+	ret = wait_event_timeout(ar->htt.empty_tx_wq, ({
 			bool empty;
-			spin_lock_bh(&ar->htt->tx_lock);
-			empty = bitmap_empty(ar->htt->used_msdu_ids,
-					     ar->htt->max_num_pending_tx);
-			spin_unlock_bh(&ar->htt->tx_lock);
+			spin_lock_bh(&ar->htt.tx_lock);
+			empty = bitmap_empty(ar->htt.used_msdu_ids,
+					     ar->htt.max_num_pending_tx);
+			spin_unlock_bh(&ar->htt.tx_lock);
 			(empty);
 		}), ATH10K_FLUSH_TIMEOUT_HZ);
 	if (ret <= 0)
-- 
1.7.9.5

