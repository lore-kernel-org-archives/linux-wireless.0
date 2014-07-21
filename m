Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f177.google.com ([74.125.82.177]:61348 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754561AbaGULUM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jul 2014 07:20:12 -0400
Received: by mail-we0-f177.google.com with SMTP id w62so7412018wes.22
        for <linux-wireless@vger.kernel.org>; Mon, 21 Jul 2014 04:20:11 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Ben Greear <greearb@candelatech.com>, sw@simonwunderlich.de,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 2/2] ath10k: simplify scan debug prints
Date: Mon, 21 Jul 2014 13:11:21 +0200
Message-Id: <1405941081-17359-3-git-send-email-michal.kazior@tieto.com> (sfid-20140721_132022_675331_3CFA98E8)
In-Reply-To: <1405941081-17359-1-git-send-email-michal.kazior@tieto.com>
References: <1405941081-17359-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This also reduces the cruft of printing scan event
names in capitals.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/wmi.c | 66 ++++++++++++++++++++---------------
 1 file changed, 38 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 7ff5280..b4930c4 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -792,6 +792,42 @@ static void ath10k_wmi_event_scan_foreign_chan(struct ath10k *ar, u32 freq)
 	}
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
@@ -809,56 +845,30 @@ static int ath10k_wmi_event_scan(struct ath10k *ar, struct sk_buff *skb)
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
 		ath10k_wmi_event_scan_started(ar);
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
 		ath10k_wmi_event_scan_completed(ar);
 		break;
 	case WMI_SCAN_EVENT_BSS_CHANNEL:
-		ath10k_dbg(ATH10K_DBG_WMI, "SCAN_EVENT_BSS_CHANNEL\n");
 		ath10k_wmi_event_scan_bss_chan(ar);
 		break;
 	case WMI_SCAN_EVENT_FOREIGN_CHANNEL:
-		ath10k_dbg(ATH10K_DBG_WMI, "SCAN_EVENT_FOREIGN_CHANNEL\n");
 		ath10k_wmi_event_scan_foreign_chan(ar, freq);
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

