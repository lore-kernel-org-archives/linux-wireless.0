Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:52929 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754701Ab3GENPV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Jul 2013 09:15:21 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@lists.ath9k.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 08/16] ath10k: lower print level for a message
Date: Fri,  5 Jul 2013 16:15:09 +0300
Message-Id: <1373030117-18077-9-git-send-email-kvalo@qca.qualcomm.com> (sfid-20130705_152039_301102_245B8DB5)
In-Reply-To: <1373030117-18077-1-git-send-email-kvalo@qca.qualcomm.com>
References: <1373030117-18077-1-git-send-email-kvalo@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michal Kazior <michal.kazior@tieto.com>

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/htc.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htc.c b/drivers/net/wireless/ath/ath10k/htc.c
index 74363c9..7b5c334 100644
--- a/drivers/net/wireless/ath/ath10k/htc.c
+++ b/drivers/net/wireless/ath/ath10k/htc.c
@@ -751,8 +751,9 @@ int ath10k_htc_connect_service(struct ath10k_htc *htc,
 	tx_alloc = ath10k_htc_get_credit_allocation(htc,
 						    conn_req->service_id);
 	if (!tx_alloc)
-		ath10k_warn("HTC Service %s does not allocate target credits\n",
-			    htc_service_name(conn_req->service_id));
+		ath10k_dbg(ATH10K_DBG_HTC,
+			   "HTC Service %s does not allocate target credits\n",
+			   htc_service_name(conn_req->service_id));
 
 	skb = ath10k_htc_build_tx_ctrl_skb(htc->ar);
 	if (!skb) {
-- 
1.7.9.5

