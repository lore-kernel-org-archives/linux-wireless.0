Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx4.wp.pl ([212.77.101.8]:40241 "EHLO mx4.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966175Ab3DQM3z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Apr 2013 08:29:55 -0400
From: stf_xl@wp.pl
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Stanislaw Gruszka <stf_xl@wp.pl>
Subject: [PATCH 2/2] rt2800: nulify all last words of TXWI
Date: Wed, 17 Apr 2013 14:30:48 +0200
Message-Id: <1366201848-18009-3-git-send-email-stf_xl@wp.pl> (sfid-20130417_142959_212274_A2C52382)
In-Reply-To: <1366201848-18009-1-git-send-email-stf_xl@wp.pl>
References: <1366201848-18009-1-git-send-email-stf_xl@wp.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Stanislaw Gruszka <stf_xl@wp.pl>

Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 5c20e98..35f58bb 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -542,6 +542,7 @@ void rt2800_write_tx_data(struct queue_entry *entry,
 {
 	__le32 *txwi = rt2800_drv_get_txwi(entry);
 	u32 word;
+	int i;
 
 	/*
 	 * Initialize TX Info descriptor
@@ -584,14 +585,16 @@ void rt2800_write_tx_data(struct queue_entry *entry,
 	rt2x00_desc_write(txwi, 1, word);
 
 	/*
-	 * Always write 0 to IV/EIV fields, hardware will insert the IV
-	 * from the IVEIV register when TXD_W3_WIV is set to 0.
+	 * Always write 0 to IV/EIV fields (word 2 and 3), hardware will insert
+	 * the IV from the IVEIV register when TXD_W3_WIV is set to 0.
 	 * When TXD_W3_WIV is set to 1 it will use the IV data
 	 * from the descriptor. The TXWI_W1_WIRELESS_CLI_ID indicates which
 	 * crypto entry in the registers should be used to encrypt the frame.
+	 *
+	 * Nulify all remaining words as well, we don't know how to program them.
 	 */
-	_rt2x00_desc_write(txwi, 2, 0 /* skbdesc->iv[0] */);
-	_rt2x00_desc_write(txwi, 3, 0 /* skbdesc->iv[1] */);
+	for (i = 2; i < entry->queue->winfo_size / sizeof(__le32); i++)
+		_rt2x00_desc_write(txwi, i, 0);
 }
 EXPORT_SYMBOL_GPL(rt2800_write_tx_data);
 
-- 
1.7.4.4

