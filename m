Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:33775 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583Ab2DTGnx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Apr 2012 02:43:53 -0400
Date: Fri, 20 Apr 2012 09:43:28 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch 1/2] ath6kl: change || to &&
Message-ID: <20120420064328.GC22649@elgon.mountain> (sfid-20120420_084358_070902_EB945711)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The original conditions are always true.  I think && was intended here,
but I don't have the hardware to test.  Could you take a look?

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/net/wireless/ath/ath6kl/htc_mbox.c b/drivers/net/wireless/ath/ath6kl/htc_mbox.c
index 065e615..086a8e1 100644
--- a/drivers/net/wireless/ath/ath6kl/htc_mbox.c
+++ b/drivers/net/wireless/ath/ath6kl/htc_mbox.c
@@ -758,7 +758,7 @@ static void ath6kl_htc_tx_bundle(struct htc_endpoint *endpoint,
 	u32 txb_mask;
 	u8 ac = WMM_NUM_AC;
 
-	if ((HTC_CTRL_RSVD_SVC != endpoint->svc_id) ||
+	if ((HTC_CTRL_RSVD_SVC != endpoint->svc_id) &&
 	    (WMI_CONTROL_SVC != endpoint->svc_id))
 		ac = target->dev->ar->ep2ac_map[endpoint->eid];
 
@@ -866,7 +866,7 @@ static void ath6kl_htc_tx_from_queue(struct htc_target *target,
 	 */
 	INIT_LIST_HEAD(&txq);
 
-	if ((HTC_CTRL_RSVD_SVC != endpoint->svc_id) ||
+	if ((HTC_CTRL_RSVD_SVC != endpoint->svc_id) &&
 	    (WMI_CONTROL_SVC != endpoint->svc_id))
 		ac = target->dev->ar->ep2ac_map[endpoint->eid];
 
