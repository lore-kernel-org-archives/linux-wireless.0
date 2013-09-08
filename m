Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh04.mail.saunalahti.fi ([62.142.5.110]:51977 "EHLO
	emh04.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752498Ab3IHOz6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Sep 2013 10:55:58 -0400
Subject: [PATCH 5/8] ath10k: add boot debug messages to htc.c
To: ath10k@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Sun, 08 Sep 2013 17:55:56 +0300
Message-ID: <20130908145556.3136.94506.stgit@localhost6.localdomain6> (sfid-20130908_165601_314101_AE1FE709)
In-Reply-To: <20130908145435.3136.49168.stgit@localhost6.localdomain6>
References: <20130908145435.3136.49168.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

To unify the boot debug level.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/htc.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htc.c b/drivers/net/wireless/ath/ath10k/htc.c
index 7d445d3..f03fd8d 100644
--- a/drivers/net/wireless/ath/ath10k/htc.c
+++ b/drivers/net/wireless/ath/ath10k/htc.c
@@ -752,8 +752,8 @@ int ath10k_htc_connect_service(struct ath10k_htc *htc,
 	tx_alloc = ath10k_htc_get_credit_allocation(htc,
 						    conn_req->service_id);
 	if (!tx_alloc)
-		ath10k_dbg(ATH10K_DBG_HTC,
-			   "HTC Service %s does not allocate target credits\n",
+		ath10k_dbg(ATH10K_DBG_BOOT,
+			   "boot htc service %s does not allocate target credits\n",
 			   htc_service_name(conn_req->service_id));
 
 	skb = ath10k_htc_build_tx_ctrl_skb(htc->ar);
@@ -873,19 +873,19 @@ setup:
 	if (status)
 		return status;
 
-	ath10k_dbg(ATH10K_DBG_HTC,
-		   "HTC service: %s UL pipe: %d DL pipe: %d eid: %d ready\n",
+	ath10k_dbg(ATH10K_DBG_BOOT,
+		   "boot htc service '%s' ul pipe %d dl pipe %d eid %d ready\n",
 		   htc_service_name(ep->service_id), ep->ul_pipe_id,
 		   ep->dl_pipe_id, ep->eid);
 
-	ath10k_dbg(ATH10K_DBG_HTC,
-		   "EP %d UL polled: %d, DL polled: %d\n",
+	ath10k_dbg(ATH10K_DBG_BOOT,
+		   "boot htc ep %d ul polled %d dl polled %d\n",
 		   ep->eid, ep->ul_is_polled, ep->dl_is_polled);
 
 	if (disable_credit_flow_ctrl && ep->tx_credit_flow_enabled) {
 		ep->tx_credit_flow_enabled = false;
-		ath10k_dbg(ATH10K_DBG_HTC,
-			   "HTC service: %s eid: %d TX flow control disabled\n",
+		ath10k_dbg(ATH10K_DBG_BOOT,
+			   "boot htc service '%s' eid %d TX flow control disabled\n",
 			   htc_service_name(ep->service_id), assigned_eid);
 	}
 

