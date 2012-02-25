Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:41722 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755453Ab2BYJLn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Feb 2012 04:11:43 -0500
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: [PATCH V2 4/5] ath6kl: Skip vif index validation in ath6kl_rx() for wmi events
Date: Sat, 25 Feb 2012 14:41:07 +0530
Message-ID: <1330161068-8413-4-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20120225_101208_340744_61DA9735)
In-Reply-To: <1330161068-8413-1-git-send-email-vthiagar@qca.qualcomm.com>
References: <1330161068-8413-1-git-send-email-vthiagar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When the wmi event is vif specific, the validation of vif index
is taken care in ath6kl_wmi_proc_events_iface(). This also avoids
the need for a netdev to be registered while receiving initial events
like "target_ready" and "regulatory domain".

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/txrx.c |   17 ++++++++---------
 1 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/txrx.c b/drivers/net/wireless/ath/ath6kl/txrx.c
index 87d4646..9d18930 100644
--- a/drivers/net/wireless/ath/ath6kl/txrx.c
+++ b/drivers/net/wireless/ath/ath6kl/txrx.c
@@ -1297,7 +1297,15 @@ void ath6kl_rx(struct htc_target *target, struct htc_packet *packet)
 	skb_put(skb, packet->act_len + HTC_HDR_LENGTH);
 	skb_pull(skb, HTC_HDR_LENGTH);
 
+	ath6kl_dbg_dump(ATH6KL_DBG_RAW_BYTES, __func__, "rx ",
+			skb->data, skb->len);
+
 	if (ept == ar->ctrl_ep) {
+		if (test_bit(WMI_ENABLED, &ar->flag)) {
+			ath6kl_check_wow_status(ar);
+			ath6kl_wmi_control_rx(ar->wmi, skb);
+			return;
+		}
 		if_idx =
 		wmi_cmd_hdr_get_if_idx((struct wmi_cmd_hdr *) skb->data);
 	} else {
@@ -1322,10 +1330,6 @@ void ath6kl_rx(struct htc_target *target, struct htc_packet *packet)
 
 	spin_unlock_bh(&vif->if_lock);
 
-
-	ath6kl_dbg_dump(ATH6KL_DBG_RAW_BYTES, __func__, "rx ",
-			skb->data, skb->len);
-
 	skb->dev = vif->ndev;
 
 	if (!test_bit(WMI_ENABLED, &ar->flag)) {
@@ -1337,11 +1341,6 @@ void ath6kl_rx(struct htc_target *target, struct htc_packet *packet)
 
 	ath6kl_check_wow_status(ar);
 
-	if (ept == ar->ctrl_ep) {
-		ath6kl_wmi_control_rx(ar->wmi, skb);
-		return;
-	}
-
 	min_hdr_len = sizeof(struct ethhdr) + sizeof(struct wmi_data_hdr) +
 		      sizeof(struct ath6kl_llc_snap_hdr);
 
-- 
1.7.0.4

