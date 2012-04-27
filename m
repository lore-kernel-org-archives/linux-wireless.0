Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:1333 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754632Ab2D0BSh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Apr 2012 21:18:37 -0400
From: Kevin Fang <chienf@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: [PATCH 2/2] ath6kl: assign Tx packet drop threshold per endpoint on htc pipe layer
Date: Fri, 27 Apr 2012 09:18:02 +0800
Message-ID: <1335489482-15565-2-git-send-email-kevin.fang@qca.qualcomm.com> (sfid-20120427_031839_586944_9691E9CA)
In-Reply-To: <1335489482-15565-1-git-send-email-kevin.fang@qca.qualcomm.com>
References: <1335489482-15565-1-git-send-email-kevin.fang@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

on the htc mbox layer, it will assign each endpoint (AC)
with a different Tx-packet-drop threshold,
so lower priority AC is more likely to drop packets
and the cookies become more available to higher priority AC.

on the htc pipe layer, assign the tx packet drop threshold as well,
it will let AC to drop packets when cookies below the tx packet drop thresho

Signed-off-by: Kevin Fang <kevin.fang@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/htc_pipe.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/htc_pipe.c b/drivers/net/wireless/ath/ath6kl/htc_pipe.c
index b21a69f..f9626c7 100644
--- a/drivers/net/wireless/ath/ath6kl/htc_pipe.c
+++ b/drivers/net/wireless/ath/ath6kl/htc_pipe.c
@@ -1378,6 +1378,9 @@ static int ath6kl_htc_pipe_conn_service(struct htc_target *target,
 	/* copy all the callbacks */
 	ep->ep_cb = conn_req->ep_cb;
 
+	/* initialize tx_drop_packet_threshold */
+	ep->tx_drop_packet_threshold = MAX_HI_COOKIE_NUM;
+
 	status = ath6kl_hif_pipe_map_service(ar, ep->svc_id,
 					     &ep->pipe.pipeid_ul,
 					     &ep->pipe.pipeid_dl);
-- 
1.7.0.4

