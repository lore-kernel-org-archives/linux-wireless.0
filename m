Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:47066 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751836Ab3HMF7o (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Aug 2013 01:59:44 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2 1/4] ath10k: fix HTT service setup
Date: Tue, 13 Aug 2013 07:59:35 +0200
Message-ID: <1376373578-2180-2-git-send-email-michal.kazior@tieto.com> (sfid-20130813_075947_046381_6ADEAAE3)
In-Reply-To: <1376373578-2180-1-git-send-email-michal.kazior@tieto.com>
References: <1375949813-10969-1-git-send-email-michal.kazior@tieto.com>
 <1376373578-2180-1-git-send-email-michal.kazior@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The "disable credit flow" flag was set too late
and it never was in the HTC service request
message.

This patch prevents firmware from reporting
(useless) HTC credits for HTT service. HTT service
doesn't use nor need credits.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/htc.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htc.c b/drivers/net/wireless/ath/ath10k/htc.c
index ef3329e..7d445d3 100644
--- a/drivers/net/wireless/ath/ath10k/htc.c
+++ b/drivers/net/wireless/ath/ath10k/htc.c
@@ -772,16 +772,16 @@ int ath10k_htc_connect_service(struct ath10k_htc *htc,
 
 	flags |= SM(tx_alloc, ATH10K_HTC_CONN_FLAGS_RECV_ALLOC);
 
-	req_msg = &msg->connect_service;
-	req_msg->flags = __cpu_to_le16(flags);
-	req_msg->service_id = __cpu_to_le16(conn_req->service_id);
-
 	/* Only enable credit flow control for WMI ctrl service */
 	if (conn_req->service_id != ATH10K_HTC_SVC_ID_WMI_CONTROL) {
 		flags |= ATH10K_HTC_CONN_FLAGS_DISABLE_CREDIT_FLOW_CTRL;
 		disable_credit_flow_ctrl = true;
 	}
 
+	req_msg = &msg->connect_service;
+	req_msg->flags = __cpu_to_le16(flags);
+	req_msg->service_id = __cpu_to_le16(conn_req->service_id);
+
 	INIT_COMPLETION(htc->ctl_resp);
 
 	status = ath10k_htc_send(htc, ATH10K_HTC_EP_0, skb);
-- 
1.7.9.5

