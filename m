Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60855 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030720Ab2CNKQy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Mar 2012 06:16:54 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 4/5] rt2x00: rt2800usb: do not check packedid for aggregated frames
Date: Wed, 14 Mar 2012 11:16:20 +0100
Message-Id: <1331720181-18564-4-git-send-email-sgruszka@redhat.com> (sfid-20120314_111658_909940_D4CBDACD)
In-Reply-To: <1331720181-18564-1-git-send-email-sgruszka@redhat.com>
References: <1331720181-18564-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tx statuses of aggregated subframes contain packetid of first subframe
in the AMPDU. We can not identify AMPDU subframes based on packedid, so
simply assume that status match first pending frame in the queue. Thats
mostly the same what 2800pci do.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
Acked-by: Helmut Schaa <helmut.schaa@googlemail.com>
---
 drivers/net/wireless/rt2x00/rt2800usb.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index eacf94b..8c1d2c0 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -502,7 +502,7 @@ rt2800usb_txdone_entry_check(struct queue_entry *entry, u32 reg)
 	__le32 *txwi;
 	u32 word;
 	int wcid, ack, pid;
-	int tx_wcid, tx_ack, tx_pid;
+	int tx_wcid, tx_ack, tx_pid, is_agg;
 
 	/*
 	 * This frames has returned with an IO error,
@@ -515,6 +515,7 @@ rt2800usb_txdone_entry_check(struct queue_entry *entry, u32 reg)
 	wcid	= rt2x00_get_field32(reg, TX_STA_FIFO_WCID);
 	ack	= rt2x00_get_field32(reg, TX_STA_FIFO_TX_ACK_REQUIRED);
 	pid	= rt2x00_get_field32(reg, TX_STA_FIFO_PID_TYPE);
+	is_agg	= rt2x00_get_field32(reg, TX_STA_FIFO_TX_AGGRE);
 
 	/*
 	 * Validate if this TX status report is intended for
@@ -527,7 +528,7 @@ rt2800usb_txdone_entry_check(struct queue_entry *entry, u32 reg)
 	tx_ack  = rt2x00_get_field32(word, TXWI_W1_ACK);
 	tx_pid  = rt2x00_get_field32(word, TXWI_W1_PACKETID);
 
-	if ((wcid != tx_wcid) || (ack != tx_ack) || (pid != tx_pid)) {
+	if (wcid != tx_wcid || ack != tx_ack || (!is_agg && pid != tx_pid)) {
 		WARNING(entry->queue->rt2x00dev,
 			"TX status report missed for queue %d entry %d\n",
 			entry->queue->qid, entry->entry_idx);
-- 
1.7.1

