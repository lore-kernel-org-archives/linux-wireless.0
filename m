Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40158 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755539AbaCEMLN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Mar 2014 07:11:13 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Pedro Francisco <pedrogfrancisco@gmail.com>
Subject: [RFC/RFT 6/9] iwlegacy: use CMD_COPY_PKT on il3945_send_rxon_assoc
Date: Wed,  5 Mar 2014 13:13:31 +0100
Message-Id: <1394021614-11514-7-git-send-email-sgruszka@redhat.com> (sfid-20140305_131117_860669_74F2A64A)
In-Reply-To: <1394021614-11514-1-git-send-email-sgruszka@redhat.com>
References: <1394021614-11514-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/3945.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/3945.c b/drivers/net/wireless/iwlegacy/3945.c
index d37a6fd..5c1a1cb 100644
--- a/drivers/net/wireless/iwlegacy/3945.c
+++ b/drivers/net/wireless/iwlegacy/3945.c
@@ -1674,13 +1674,13 @@ il3945_hw_reg_set_txpower(struct il_priv *il, s8 power)
 static int
 il3945_send_rxon_assoc(struct il_priv *il)
 {
-	int rc = 0;
+	int rc;
 	struct il_rx_pkt *pkt;
 	struct il3945_rxon_assoc_cmd rxon_assoc;
 	struct il_host_cmd cmd = {
 		.id = C_RXON_ASSOC,
 		.len = sizeof(rxon_assoc),
-		.flags = CMD_WANT_SKB,
+		.flags = CMD_COPY_PKT,
 		.data = &rxon_assoc,
 	};
 	const struct il_rxon_cmd *rxon1 = &il->staging;
@@ -1694,6 +1694,11 @@ il3945_send_rxon_assoc(struct il_priv *il)
 		return 0;
 	}
 
+	pkt = kmalloc(sizeof(*pkt), GFP_KERNEL);
+	if (!pkt)
+		return -ENOMEM;
+	cmd.pkt_ptr = pkt;
+
 	rxon_assoc.flags = il->staging.flags;
 	rxon_assoc.filter_flags = il->staging.filter_flags;
 	rxon_assoc.ofdm_basic_rates = il->staging.ofdm_basic_rates;
@@ -1702,16 +1707,15 @@ il3945_send_rxon_assoc(struct il_priv *il)
 
 	rc = il_send_cmd_sync(il, &cmd);
 	if (rc)
-		return rc;
+		goto out;
 
-	pkt = (struct il_rx_pkt *)cmd.reply_page;
 	if (pkt->hdr.flags & IL_CMD_FAILED_MSK) {
 		IL_ERR("Bad return from C_RXON_ASSOC command\n");
 		rc = -EIO;
 	}
 
-	il_free_pages(il, cmd.reply_page);
-
+out:
+	kfree(pkt);
 	return rc;
 }
 
-- 
1.7.11.7

