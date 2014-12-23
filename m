Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:21161 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755167AbaLWHsf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Dec 2014 02:48:35 -0500
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
To: Kalle Valo <kvalo@qca.qualcomm.com>
Subject: [PATCH 21/22] wil6210: workaround for BACK establishment race
Date: Tue, 23 Dec 2014 09:47:23 +0200
Message-Id: <1419320844-23989-22-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20141223_091349_137223_A63B1F69)
In-Reply-To: <1419320844-23989-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1419320844-23989-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When establishing BACK, WMI may be handled earlier then Rx, in this case
late Rx will be mis-handled.

Detect early Rx and pass it to the stack, bypass reordering

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/rx_reorder.c | 25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/rx_reorder.c b/drivers/net/wireless/ath/wil6210/rx_reorder.c
index 20d65f2..5af8012 100644
--- a/drivers/net/wireless/ath/wil6210/rx_reorder.c
+++ b/drivers/net/wireless/ath/wil6210/rx_reorder.c
@@ -127,13 +127,24 @@ void wil_rx_reorder(struct wil6210_priv *wil, struct sk_buff *skb)
 	 * reported, and data Rx, few packets may be pass up before reorder
 	 * buffer get allocated. Catch up by pretending SSN is what we
 	 * see in the 1-st Rx packet
+	 *
+	 * Another scenario, Rx get delayed and we got packet from before
+	 * BACK. Pass it to the stack and wait.
 	 */
 	if (r->first_time) {
 		r->first_time = false;
 		if (seq != r->head_seq_num) {
-			wil_err(wil, "Error: 1-st frame with wrong sequence"
-				" %d, should be %d. Fixing...\n", seq,
-				r->head_seq_num);
+			if (seq_less(seq, r->head_seq_num)) {
+				wil_err(wil,
+					"Error: frame with early sequence 0x%03x, should be 0x%03x. Waiting...\n",
+					seq, r->head_seq_num);
+				r->first_time = true;
+				wil_netif_rx_any(skb, ndev);
+				goto out;
+			}
+			wil_err(wil,
+				"Error: 1-st frame with wrong sequence 0x%03x, should be 0x%03x. Fixing...\n",
+				seq, r->head_seq_num);
 			r->head_seq_num = seq;
 			r->ssn = seq;
 		}
@@ -279,6 +290,7 @@ static void wil_back_rx_handle(struct wil6210_priv *wil,
 	int ba_policy = req->ba_param_set & BIT(1);
 	u16 agg_timeout = req->ba_timeout;
 	u16 status = WLAN_STATUS_SUCCESS;
+	u16 ssn = req->ba_seq_ctrl >> 4;
 	unsigned long flags;
 	int rc;
 
@@ -297,9 +309,9 @@ static void wil_back_rx_handle(struct wil6210_priv *wil,
 	}
 
 	wil_dbg_wmi(wil,
-		    "ADDBA request for CID %d %pM TID %d size %d timeout %d AMSDU%s policy %d token %d\n",
+		    "ADDBA request for CID %d %pM TID %d size %d timeout %d AMSDU%s policy %d token %d SSN 0x%03x\n",
 		    cid, sta->addr, tid, req_agg_wsize, req->ba_timeout,
-		    agg_amsdu ? "+" : "-", !!ba_policy, req->dialog_token);
+		    agg_amsdu ? "+" : "-", !!ba_policy, req->dialog_token, ssn);
 
 	/* apply policies */
 	if (ba_policy) {
@@ -318,8 +330,7 @@ static void wil_back_rx_handle(struct wil6210_priv *wil,
 	spin_lock_irqsave(&sta->tid_rx_lock, flags);
 
 	wil_tid_ampdu_rx_free(wil, sta->tid_rx[tid]);
-	sta->tid_rx[tid] = wil_tid_ampdu_rx_alloc(wil, agg_wsize,
-						  req->ba_seq_ctrl >> 4);
+	sta->tid_rx[tid] = wil_tid_ampdu_rx_alloc(wil, agg_wsize, ssn);
 
 	spin_unlock_irqrestore(&sta->tid_rx_lock, flags);
 }
-- 
2.1.0

