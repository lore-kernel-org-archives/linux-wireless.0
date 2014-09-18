Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:42214 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756036AbaIRNcQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Sep 2014 09:32:16 -0400
Received: by mail-wg0-f52.google.com with SMTP id x13so896378wgg.35
        for <linux-wireless@vger.kernel.org>; Thu, 18 Sep 2014 06:32:14 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 8/9] ath10k: unify wmi event function names
Date: Thu, 18 Sep 2014 15:21:26 +0200
Message-Id: <1411046487-19544-9-git-send-email-michal.kazior@tieto.com> (sfid-20140918_153221_778338_F98DDA1D)
In-Reply-To: <1411046487-19544-1-git-send-email-michal.kazior@tieto.com>
References: <1411046487-19544-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Make all wmi event functions match the same naming
style, i.e. ath10k_wmi_event_<name>.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/wmi.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 592e3af..6819255 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -2266,8 +2266,8 @@ static int ath10k_wmi_10x_pull_svc_rdy_ev(struct sk_buff *skb,
 	return 0;
 }
 
-static void ath10k_wmi_service_ready_event_rx(struct ath10k *ar,
-					      struct sk_buff *skb)
+static void ath10k_wmi_event_service_ready(struct ath10k *ar,
+					   struct sk_buff *skb)
 {
 	struct wmi_svc_rdy_ev_arg arg = {};
 	u32 num_units, req_id, unit_size, num_mem_reqs, num_unit_info, i;
@@ -2380,7 +2380,7 @@ static void ath10k_wmi_service_ready_event_rx(struct ath10k *ar,
 	complete(&ar->wmi.service_ready);
 }
 
-static int ath10k_wmi_ready_event_rx(struct ath10k *ar, struct sk_buff *skb)
+static int ath10k_wmi_event_ready(struct ath10k *ar, struct sk_buff *skb)
 {
 	struct wmi_ready_event *ev = (struct wmi_ready_event *)skb->data;
 
@@ -2503,10 +2503,10 @@ static void ath10k_wmi_main_process_rx(struct ath10k *ar, struct sk_buff *skb)
 		ath10k_wmi_event_vdev_install_key_complete(ar, skb);
 		break;
 	case WMI_SERVICE_READY_EVENTID:
-		ath10k_wmi_service_ready_event_rx(ar, skb);
+		ath10k_wmi_event_service_ready(ar, skb);
 		break;
 	case WMI_READY_EVENTID:
-		ath10k_wmi_ready_event_rx(ar, skb);
+		ath10k_wmi_event_ready(ar, skb);
 		break;
 	default:
 		ath10k_warn(ar, "Unknown eventid: %d\n", id);
@@ -2623,10 +2623,10 @@ static void ath10k_wmi_10x_process_rx(struct ath10k *ar, struct sk_buff *skb)
 		ath10k_wmi_event_vdev_resume_req(ar, skb);
 		break;
 	case WMI_10X_SERVICE_READY_EVENTID:
-		ath10k_wmi_service_ready_event_rx(ar, skb);
+		ath10k_wmi_event_service_ready(ar, skb);
 		break;
 	case WMI_10X_READY_EVENTID:
-		ath10k_wmi_ready_event_rx(ar, skb);
+		ath10k_wmi_event_ready(ar, skb);
 		break;
 	case WMI_10X_PDEV_UTF_EVENTID:
 		/* ignore utf events */
@@ -2734,10 +2734,10 @@ static void ath10k_wmi_10_2_process_rx(struct ath10k *ar, struct sk_buff *skb)
 		ath10k_wmi_event_vdev_resume_req(ar, skb);
 		break;
 	case WMI_10_2_SERVICE_READY_EVENTID:
-		ath10k_wmi_service_ready_event_rx(ar, skb);
+		ath10k_wmi_event_service_ready(ar, skb);
 		break;
 	case WMI_10_2_READY_EVENTID:
-		ath10k_wmi_ready_event_rx(ar, skb);
+		ath10k_wmi_event_ready(ar, skb);
 		break;
 	case WMI_10_2_RTT_KEEPALIVE_EVENTID:
 	case WMI_10_2_GPIO_INPUT_EVENTID:
-- 
1.8.5.3

