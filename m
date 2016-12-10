Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:33009 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753129AbcLJM75 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 10 Dec 2016 07:59:57 -0500
Received: by mail-lf0-f67.google.com with SMTP id y21so2226492lfa.0
        for <linux-wireless@vger.kernel.org>; Sat, 10 Dec 2016 04:59:56 -0800 (PST)
From: Erik Stromdahl <erik.stromdahl@gmail.com>
To: kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Cc: Erik Stromdahl <erik.stromdahl@gmail.com>
Subject: [PATCH 2/2] ath10k: htc: Simplified credit distribution.
Date: Sat, 10 Dec 2016 13:58:41 +0100
Message-Id: <1481374721-16354-2-git-send-email-erik.stromdahl@gmail.com> (sfid-20161210_140000_913448_20E941A5)
In-Reply-To: <1481374721-16354-1-git-send-email-erik.stromdahl@gmail.com>
References: <1481374721-16354-1-git-send-email-erik.stromdahl@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Simplified transmit credit distribution code somewhat.
Since the WMI control service will get assigned all credits
there is no need for having a credit_allocation array in
struct ath10k_htc.

Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
---
 drivers/net/wireless/ath/ath10k/htc.c |   29 +++++------------------------
 drivers/net/wireless/ath/ath10k/htc.h |    1 -
 2 files changed, 5 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htc.c b/drivers/net/wireless/ath/ath10k/htc.c
index f2e0659..9f6a915 100644
--- a/drivers/net/wireless/ath/ath10k/htc.c
+++ b/drivers/net/wireless/ath/ath10k/htc.c
@@ -474,33 +474,16 @@ static void ath10k_htc_reset_endpoint_states(struct ath10k_htc *htc)
 	}
 }
 
-static void ath10k_htc_setup_target_buffer_assignments(struct ath10k_htc *htc)
-{
-	struct ath10k_htc_svc_tx_credits *entry;
-
-	entry = &htc->service_tx_alloc[0];
-
-	/*
-	 * for PCIE allocate all credists/HTC buffers to WMI.
-	 * no buffers are used/required for data. data always
-	 * remains on host.
-	 */
-	entry++;
-	entry->service_id = ATH10K_HTC_SVC_ID_WMI_CONTROL;
-	entry->credit_allocation = htc->total_transmit_credits;
-}
-
 static u8 ath10k_htc_get_credit_allocation(struct ath10k_htc *htc,
 					   u16 service_id)
 {
 	u8 allocation = 0;
-	int i;
 
-	for (i = 0; i < ATH10K_HTC_EP_COUNT; i++) {
-		if (htc->service_tx_alloc[i].service_id == service_id)
-			allocation =
-			    htc->service_tx_alloc[i].credit_allocation;
-	}
+	/* The WMI control service is the only service with flow control.
+	 * Let it have all transmit credits.
+	 */
+	if (service_id == ATH10K_HTC_SVC_ID_WMI_CONTROL)
+		allocation = htc->total_transmit_credits;
 
 	return allocation;
 }
@@ -574,8 +557,6 @@ int ath10k_htc_wait_target(struct ath10k_htc *htc)
 		return -ECOMM;
 	}
 
-	ath10k_htc_setup_target_buffer_assignments(htc);
-
 	/* setup our pseudo HTC control endpoint connection */
 	memset(&conn_req, 0, sizeof(conn_req));
 	memset(&conn_resp, 0, sizeof(conn_resp));
diff --git a/drivers/net/wireless/ath/ath10k/htc.h b/drivers/net/wireless/ath/ath10k/htc.h
index ca150c9..6ababa3 100644
--- a/drivers/net/wireless/ath/ath10k/htc.h
+++ b/drivers/net/wireless/ath/ath10k/htc.h
@@ -337,7 +337,6 @@ struct ath10k_htc {
 	struct completion ctl_resp;
 
 	int total_transmit_credits;
-	struct ath10k_htc_svc_tx_credits service_tx_alloc[ATH10K_HTC_EP_COUNT];
 	int target_credit_size;
 };
 
-- 
1.7.9.5
