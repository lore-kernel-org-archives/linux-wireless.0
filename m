Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:35706 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798Ab0DXEh6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Apr 2010 00:37:58 -0400
Received: by pxi17 with SMTP id 17so1093001pxi.19
        for <linux-wireless@vger.kernel.org>; Fri, 23 Apr 2010 21:37:58 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 24 Apr 2010 13:32:04 +0900
Message-ID: <w2x55d522f11004232132ze7fcf8fdk54c2c8bfae72c64@mail.gmail.com>
Subject: [PATCH] ath9k: use spin_lock_bh() instead of spin_lock() in
	ath_tid_drain()
From: Jongman Heo <jongman.heo@gmail.com>
To: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

commit a9f042cb ("ath9k: fix lockdep warning when unloading module")
changed spin_[un]lock() to
spin_[un]lock_bh() in ath_tx_node_cleanup(), but didn't change those
in ath_tid_drain().

Signed-off-by: Jongman Heo <jongman.heo@gmail.com>

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c
b/drivers/net/wireless/ath/ath9k/xmit.c
index 294b486..daf073b 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -235,9 +235,9 @@ static void ath_tid_drain(struct ath_softc *sc,
struct ath_txq *txq,
 		if (bf_isretried(bf))
 			ath_tx_update_baw(sc, tid, bf->bf_seqno);

-		spin_unlock(&txq->axq_lock);
+		spin_unlock_bh(&txq->axq_lock);
 		ath_tx_complete_buf(sc, bf, txq, &bf_head, 0, 0);
-		spin_lock(&txq->axq_lock);
+		spin_lock_bh(&txq->axq_lock);
 	}

 	tid->seq_next = tid->seq_start;
