Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:18269 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752690Ab2AJEU3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jan 2012 23:20:29 -0500
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20235.48473.693136.780100@gargle.gargle.HOWL> (sfid-20120110_052033_316603_028D2263)
Date: Tue, 10 Jan 2012 09:53:53 +0530
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 3/4] ath6kl: Initialize a variable properly
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This prevents 'comp_pktq' from being used in an
incorrect manner.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/htc.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/htc.c b/drivers/net/wireless/ath/ath6kl/htc.c
index b017022..2d72190 100644
--- a/drivers/net/wireless/ath/ath6kl/htc.c
+++ b/drivers/net/wireless/ath/ath6kl/htc.c
@@ -2062,6 +2062,7 @@ int ath6kl_htc_rxmsg_pending_handler(struct htc_target *target,
 	enum htc_endpoint_id id;
 	int n_fetched = 0;
 
+	INIT_LIST_HEAD(&comp_pktq);
 	*num_pkts = 0;
 
 	/*
-- 
1.7.8.3

