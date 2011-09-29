Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:50137 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756744Ab1I2PEB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Sep 2011 11:04:01 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/4] ath6kl: Fix htc_packet leak in ath6kl_htc_rx_process_packets()
Date: Thu, 29 Sep 2011 20:31:13 +0530
Message-ID: <1317308476-16204-1-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20110929_170406_170331_E3B18138)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Packet is not reclaimed when ath6kl_htc_rx_process_hdr() fails.
Fix this by deferring the packet deletion from comp_pktq till
ath6kl_htc_rx_process_hdr() returns success.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/htc.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/htc.c b/drivers/net/wireless/ath/ath6kl/htc.c
index f88a7c9..7bc9884 100644
--- a/drivers/net/wireless/ath/ath6kl/htc.c
+++ b/drivers/net/wireless/ath/ath6kl/htc.c
@@ -1643,7 +1643,6 @@ static int ath6kl_htc_rx_process_packets(struct htc_target *target,
 	int status = 0;
 
 	list_for_each_entry_safe(packet, tmp_pkt, comp_pktq, list) {
-		list_del(&packet->list);
 		ep = &target->endpoint[packet->endpoint];
 
 		/* process header for each of the recv packet */
@@ -1652,6 +1651,8 @@ static int ath6kl_htc_rx_process_packets(struct htc_target *target,
 		if (status)
 			return status;
 
+		list_del(&packet->list);
+
 		if (list_empty(comp_pktq)) {
 			/*
 			 * Last packet's more packet flag is set
-- 
1.7.0.4

