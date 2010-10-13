Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:43083 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751763Ab0JMTBb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Oct 2010 15:01:31 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH] ath9k:  Fix potential use-after-free.
Date: Wed, 13 Oct 2010 12:01:23 -0700
Message-Id: <1286996483-4929-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

The ath_debug_stat_tx references bf->bf_mpdu, which
is the skb consumed by 	ath_tx_complete.  So, call
the ath_debug_stat_tx method first.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
:100644 100644 942be55... 6d41d47... M	drivers/net/wireless/ath/ath9k/xmit.c
 drivers/net/wireless/ath/ath9k/xmit.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 942be55..6d41d47 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1926,8 +1926,8 @@ static void ath_tx_complete_buf(struct ath_softc *sc, struct ath_buf *bf,
 		else
 			complete(&sc->paprd_complete);
 	} else {
-		ath_tx_complete(sc, skb, bf->aphy, tx_flags);
 		ath_debug_stat_tx(sc, txq, bf, ts);
+		ath_tx_complete(sc, skb, bf->aphy, tx_flags);
 	}
 
 	/*
-- 
1.7.2.2

