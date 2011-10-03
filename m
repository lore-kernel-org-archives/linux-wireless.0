Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:4265 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754226Ab1JCL4Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Oct 2011 07:56:24 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/4] ath6kl: Fix htc_packet leak in ath6kl_htc_rx_process_packets()
Date: Mon, 3 Oct 2011 17:26:24 +0530
Message-ID: <1317642987-16026-1-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20111003_135627_421799_ECAB874E)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Packet is not reclaimed when ath6kl_htc_rx_process_hdr() fails.
Fix this by deferring the packet deletion from comp_pktq till
ath6kl_htc_rx_process_hdr() returns success. This bug is found
in code review, impact is not easily visible as the leak happens
only in failure cases.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/htc.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

V2 --- Commit log change

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

