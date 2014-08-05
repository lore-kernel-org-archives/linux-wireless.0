Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:35598 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639AbaHENF6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Aug 2014 09:05:58 -0400
Received: by mail-wi0-f175.google.com with SMTP id ho1so6966236wib.2
        for <linux-wireless@vger.kernel.org>; Tue, 05 Aug 2014 06:05:55 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCHv2 1/2] ath10k: simplify scan debug prints
Date: Tue,  5 Aug 2014 14:54:43 +0200
Message-Id: <1407243284-19803-2-git-send-email-michal.kazior@tieto.com> (sfid-20140805_150605_960450_3DEE7C84)
In-Reply-To: <1407243284-19803-1-git-send-email-michal.kazior@tieto.com>
References: <1407243284-19803-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This also reduces the cruft of printing scan event
names in capitals.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/wmi.c | 67 ++++++++++++++++++++---------------
 1 file changed, 38 insertions(+), 29 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index b09661d..98bfffd 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -811,6 +811,42 @@ int ath10k_wmi_mgmt_tx(struct ath10k *ar, struct sk_buff *skb)
 	return ret;
 }
 
+static const char *
+ath10k_wmi_event_scan_type_str(enum wmi_scan_event_type type,
+			       enum wmi_scan_completion_reason reason)
+{
+	switch (type) {
+	case WMI_SCAN_EVENT_STARTED:
+		return "started";
+	case WMI_SCAN_EVENT_COMPLETED:
+		switch (reason) {
+		case WMI_SCAN_REASON_COMPLETED:
+			return "completed";
+		case WMI_SCAN_REASON_CANCELLED:
+			return "completed [cancelled]";
+		case WMI_SCAN_REASON_PREEMPTED:
+			return "completed [preempted]";
+		case WMI_SCAN_REASON_TIMEDOUT:
+			return "completed [timedout]";
+		case WMI_SCAN_REASON_MAX:
+			break;
+		}
+		return "completed [unknown]";
+	case WMI_SCAN_EVENT_BSS_CHANNEL:
+		return "bss channel";
+	case WMI_SCAN_EVENT_FOREIGN_CHANNEL:
+		return "foreign channel";
+	case WMI_SCAN_EVENT_DEQUEUED:
+		return "dequeued";
+	case WMI_SCAN_EVENT_PREEMPTED:
+		return "preempted";
+	case WMI_SCAN_EVENT_START_FAILED:
+		return "start failed";
+	default:
+		return "unknown";
+	}
+}
+
 static int ath10k_wmi_event_scan(struct ath10k *ar, struct sk_buff *skb)
 {
 	struct wmi_scan_event *event = (struct wmi_scan_event *)skb->data;
@@ -828,41 +864,22 @@ static int ath10k_wmi_event_scan(struct ath10k *ar, struct sk_buff *skb)
 	scan_id    = __le32_to_cpu(event->scan_id);
 	vdev_id    = __le32_to_cpu(event->vdev_id);
 
-	ath10k_dbg(ATH10K_DBG_WMI, "WMI_SCAN_EVENTID\n");
 	ath10k_dbg(ATH10K_DBG_WMI,
-		   "scan event type %d reason %d freq %d req_id %d "
+		   "scan event %s type %d reason %d freq %d req_id %d "
 		   "scan_id %d vdev_id %d\n",
+		   ath10k_wmi_event_scan_type_str(event_type, reason),
 		   event_type, reason, freq, req_id, scan_id, vdev_id);
 
 	spin_lock_bh(&ar->data_lock);
 
 	switch (event_type) {
 	case WMI_SCAN_EVENT_STARTED:
-		ath10k_dbg(ATH10K_DBG_WMI, "SCAN_EVENT_STARTED\n");
 		if (ar->scan.in_progress && ar->scan.is_roc)
 			ieee80211_ready_on_channel(ar->hw);
 
 		complete(&ar->scan.started);
 		break;
 	case WMI_SCAN_EVENT_COMPLETED:
-		ath10k_dbg(ATH10K_DBG_WMI, "SCAN_EVENT_COMPLETED\n");
-		switch (reason) {
-		case WMI_SCAN_REASON_COMPLETED:
-			ath10k_dbg(ATH10K_DBG_WMI, "SCAN_REASON_COMPLETED\n");
-			break;
-		case WMI_SCAN_REASON_CANCELLED:
-			ath10k_dbg(ATH10K_DBG_WMI, "SCAN_REASON_CANCELED\n");
-			break;
-		case WMI_SCAN_REASON_PREEMPTED:
-			ath10k_dbg(ATH10K_DBG_WMI, "SCAN_REASON_PREEMPTED\n");
-			break;
-		case WMI_SCAN_REASON_TIMEDOUT:
-			ath10k_dbg(ATH10K_DBG_WMI, "SCAN_REASON_TIMEDOUT\n");
-			break;
-		default:
-			break;
-		}
-
 		ar->scan_channel = NULL;
 		if (!ar->scan.in_progress) {
 			ath10k_warn("no scan requested, ignoring\n");
@@ -883,11 +900,9 @@ static int ath10k_wmi_event_scan(struct ath10k *ar, struct sk_buff *skb)
 		ar->scan.in_progress = false;
 		break;
 	case WMI_SCAN_EVENT_BSS_CHANNEL:
-		ath10k_dbg(ATH10K_DBG_WMI, "SCAN_EVENT_BSS_CHANNEL\n");
 		ar->scan_channel = NULL;
 		break;
 	case WMI_SCAN_EVENT_FOREIGN_CHANNEL:
-		ath10k_dbg(ATH10K_DBG_WMI, "SCAN_EVENT_FOREIGN_CHANNEL\n");
 		ar->scan_channel = ieee80211_get_channel(ar->hw->wiphy, freq);
 		if (ar->scan.in_progress && ar->scan.is_roc &&
 		    ar->scan.roc_freq == freq) {
@@ -895,14 +910,8 @@ static int ath10k_wmi_event_scan(struct ath10k *ar, struct sk_buff *skb)
 		}
 		break;
 	case WMI_SCAN_EVENT_DEQUEUED:
-		ath10k_dbg(ATH10K_DBG_WMI, "SCAN_EVENT_DEQUEUED\n");
-		break;
 	case WMI_SCAN_EVENT_PREEMPTED:
-		ath10k_dbg(ATH10K_DBG_WMI, "WMI_SCAN_EVENT_PREEMPTED\n");
-		break;
 	case WMI_SCAN_EVENT_START_FAILED:
-		ath10k_dbg(ATH10K_DBG_WMI, "WMI_SCAN_EVENT_START_FAILED\n");
-		break;
 	default:
 		break;
 	}
-- 
1.8.5.3

