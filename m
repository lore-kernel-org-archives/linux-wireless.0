Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:35409 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752091Ab0DGF0O (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Apr 2010 01:26:14 -0400
Subject: [PATCH] ath9k: fix compilation without CONFIG_ATH9K_DEBUGFS
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
From: Pavel Roskin <proski@gnu.org>
Cc: Felix Fietkau <nbd@openwrt.org>
Date: Wed, 07 Apr 2010 01:26:11 -0400
Message-ID: <20100407052611.23065.48030.stgit@mj.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Make arguments of ath_debug_stat_tx() and ath_debug_stat_rx() stubs
match those of the same functions with CONFIG_ATH9K_DEBUGFS defined.

Signed-off-by: Pavel Roskin <proski@gnu.org>
---
 drivers/net/wireless/ath/ath9k/debug.h |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/debug.h b/drivers/net/wireless/ath/ath9k/debug.h
index 9551d8e..b2af9de 100644
--- a/drivers/net/wireless/ath/ath9k/debug.h
+++ b/drivers/net/wireless/ath/ath9k/debug.h
@@ -204,12 +204,13 @@ static inline void ath_debug_stat_rc(struct ath_softc *sc,
 
 static inline void ath_debug_stat_tx(struct ath_softc *sc,
 				     struct ath_txq *txq,
-				     struct ath_buf *bf)
+				     struct ath_buf *bf,
+				     struct ath_tx_status *ts)
 {
 }
 
 static inline void ath_debug_stat_rx(struct ath_softc *sc,
-				     struct ath_buf *bf)
+				     struct ath_rx_status *rs)
 {
 }
 
