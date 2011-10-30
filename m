Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:36533 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446Ab1J3TRA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Oct 2011 15:17:00 -0400
Subject: [PATCH 5/5] ath6kl: print seqno in htc debug logs
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Sun, 30 Oct 2011 21:16:49 +0200
Message-ID: <20111030191649.20466.43897.stgit@localhost6.localdomain6> (sfid-20111030_201704_592175_179E69F7)
In-Reply-To: <20111030190922.20466.299.stgit@localhost6.localdomain6>
References: <20111030190922.20466.299.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Makes it easier to debug where frames are going.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/htc.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/htc.c b/drivers/net/wireless/ath/ath6kl/htc.c
index 99220d4..f3b63ca 100644
--- a/drivers/net/wireless/ath/ath6kl/htc.c
+++ b/drivers/net/wireless/ath/ath6kl/htc.c
@@ -439,6 +439,9 @@ static void htc_tx_comp_handler(struct htc_target *target,
 	struct htc_endpoint *endpoint = &target->endpoint[packet->endpoint];
 	struct list_head container;
 
+	ath6kl_dbg(ATH6KL_DBG_HTC, "htc tx complete seqno %d\n",
+		   packet->info.tx.seqno);
+
 	htc_tx_comp_update(target, endpoint, packet);
 	INIT_LIST_HEAD(&container);
 	list_add_tail(&packet->list, &container);
@@ -501,8 +504,8 @@ static int ath6kl_htc_tx_issue(struct htc_target *target,
 	padded_len = CALC_TXRX_PADDED_LEN(target, send_len);
 
 	ath6kl_dbg(ATH6KL_DBG_HTC,
-		   "htc tx issue len %d padded_len %d mbox 0x%X %s\n",
-		   send_len, padded_len,
+		   "htc tx issue len %d seqno %d padded_len %d mbox 0x%X %s\n",
+		   send_len, packet->info.tx.seqno, padded_len,
 		   target->dev->ar->mbox_info.htc_addr,
 		   sync ? "sync" : "async");
 
@@ -705,8 +708,8 @@ static int ath6kl_htc_tx_setup_scat_list(struct htc_target *target,
 		scat_req->len += len;
 		scat_req->scat_entries++;
 		ath6kl_dbg(ATH6KL_DBG_HTC,
-			   "htc tx adding (%d) pkt 0x%p len %d remaining %d\n",
-			   i, packet, len, rem_scat);
+			   "htc tx adding (%d) pkt 0x%p seqno %d len %d remaining %d\n",
+			   i, packet, packet->info.tx.seqno, len, rem_scat);
 	}
 
 	/* Roll back scatter setup in case of any failure */

