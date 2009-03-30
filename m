Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:25182 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758160AbZC3KCw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2009 06:02:52 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 30 Mar 2009 03:02:51 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18896.38865.389816.198652@gargle.gargle.HOWL> (sfid-20090330_120256_024926_9509E458)
Date: Mon, 30 Mar 2009 15:28:41 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 09/17] ath9k: Remove unused structures
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

struct aggr_rifs_param and ath_tx_stat are not used anywhere.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/ath9k.h |   20 --------------------
 1 files changed, 0 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/ath9k/ath9k.h b/drivers/net/wireless/ath9k/ath9k.h
index dae0f95..bdd5c6b 100644
--- a/drivers/net/wireless/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath9k/ath9k.h
@@ -298,26 +298,6 @@ struct ath_tx_control {
 #define ATH_TX_XRETRY       0x02
 #define ATH_TX_BAR          0x04
 
-/* All RSSI values are noise floor adjusted */
-struct ath_tx_stat {
-	int rssi;
-	int rssictl[ATH_MAX_ANTENNA];
-	int rssiextn[ATH_MAX_ANTENNA];
-	int rateieee;
-	int rateKbps;
-	int ratecode;
-	int flags;
-	u32 airtime;	/* time on air per final tx rate */
-};
-
-struct aggr_rifs_param {
-	int param_max_frames;
-	int param_max_len;
-	int param_rl;
-	int param_al;
-	struct ath_rc_series *param_rcs;
-};
-
 struct ath_node {
 	struct ath_softc *an_sc;
 	struct ath_atx_tid tid[WME_NUM_TID];
-- 
1.6.2.1

