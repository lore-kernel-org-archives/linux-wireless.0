Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:36134 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348Ab1IZJSy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Sep 2011 05:18:54 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH] ath6kl: Remove unnecessary retrieval of first list entry in ath6kl_htc_tx_setup_scat_list()
Date: Mon, 26 Sep 2011 14:49:03 +0530
Message-ID: <1317028743-18092-1-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20110926_111857_776984_57B18097)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It is unnecessary to take the first list entry from queue again for
transmission. Sometimes it may look racy when the head of the list
changes between subsequent retrival, but should not happen in
practical.

Reported-by: Jouni Malinen <jouni@qca.qualcomm.com>
Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/htc.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/htc.c b/drivers/net/wireless/ath/ath6kl/htc.c
index 9aa2e44..feed985 100644
--- a/drivers/net/wireless/ath/ath6kl/htc.c
+++ b/drivers/net/wireless/ath/ath6kl/htc.c
@@ -389,7 +389,6 @@ static int ath6kl_htc_tx_setup_scat_list(struct htc_target *target,
 
 		rem_scat -= len;
 		/* now remove it from the queue */
-		packet = list_first_entry(queue, struct htc_packet, list);
 		list_del(&packet->list);
 
 		scat_req->scat_list[i].packet = packet;
-- 
1.7.0.4

