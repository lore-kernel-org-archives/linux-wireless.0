Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:53703 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755267Ab1A1Qw4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Jan 2011 11:52:56 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH] ath9k: fix compile error in non-debug ath_debug_stat_tx() stub
Date: Fri, 28 Jan 2011 17:52:49 +0100
Message-Id: <1296233569-45244-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"ath9k: fix tx queue index confusion in debugfs code" changed the debug
function but not the stub.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/debug.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/debug.h b/drivers/net/wireless/ath/ath9k/debug.h
index 1bdc6d4..59338de 100644
--- a/drivers/net/wireless/ath/ath9k/debug.h
+++ b/drivers/net/wireless/ath/ath9k/debug.h
@@ -192,7 +192,8 @@ static inline void ath_debug_stat_interrupt(struct ath_softc *sc,
 
 static inline void ath_debug_stat_tx(struct ath_softc *sc,
 				     struct ath_buf *bf,
-				     struct ath_tx_status *ts)
+				     struct ath_tx_status *ts,
+				     struct ath_txq *txq)
 {
 }
 
-- 
1.7.3.2

