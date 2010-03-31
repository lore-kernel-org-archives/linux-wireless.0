Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:55856 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758269Ab0CaWlr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Mar 2010 18:41:47 -0400
Message-ID: <4BB3CFA0.1040604@openwrt.org>
Date: Wed, 31 Mar 2010 15:41:36 -0700
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH] ath9k: fix compile error without debug enabled
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

commits 8e6f5aa250d6013ec0d66f9f45f376678d3fc4ab and
db1a052b73f7c97f9e8b21f3f19a92313ed2acb1 accidentally introduced
compile errors that happens when ath9k debug is not enabled.
This patch fixes the declaration of the inline stubs to resolve this.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
--- a/drivers/net/wireless/ath/ath9k/debug.h
+++ b/drivers/net/wireless/ath/ath9k/debug.h
@@ -209,12 +209,13 @@ static inline void ath_debug_stat_rc(str
 
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
 
