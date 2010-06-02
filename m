Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:57545 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755143Ab0FBKWZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jun 2010 06:22:25 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 02 Jun 2010 03:22:25 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19462.12585.520293.43927@gargle.gargle.HOWL>
Date: Wed, 2 Jun 2010 15:53:37 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 4/8] ath9k_common: Move count_streams to common module
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This can be used by ath9k_htc.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/common.c |   13 +++++++++++++
 drivers/net/wireless/ath/ath9k/common.h |    1 +
 drivers/net/wireless/ath/ath9k/init.c   |   16 ++--------------
 3 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/common.c b/drivers/net/wireless/ath/ath9k/common.c
index 27f9ae5..4ae9e34 100644
--- a/drivers/net/wireless/ath/ath9k/common.c
+++ b/drivers/net/wireless/ath/ath9k/common.c
@@ -380,6 +380,19 @@ void ath9k_cmn_key_delete(struct ath_common *common,
 }
 EXPORT_SYMBOL(ath9k_cmn_key_delete);
 
+int ath9k_cmn_count_streams(unsigned int chainmask, int max)
+{
+	int streams = 0;
+
+	do {
+		if (++streams == max)
+			break;
+	} while ((chainmask = chainmask & (chainmask - 1)));
+
+	return streams;
+}
+EXPORT_SYMBOL(ath9k_cmn_count_streams);
+
 static int __init ath9k_cmn_init(void)
 {
 	return 0;
diff --git a/drivers/net/wireless/ath/ath9k/common.h b/drivers/net/wireless/ath/ath9k/common.h
index 283cca8..97809d3 100644
--- a/drivers/net/wireless/ath/ath9k/common.h
+++ b/drivers/net/wireless/ath/ath9k/common.h
@@ -64,3 +64,4 @@ int ath9k_cmn_key_config(struct ath_common *common,
 			 struct ieee80211_key_conf *key);
 void ath9k_cmn_key_delete(struct ath_common *common,
 			  struct ieee80211_key_conf *key);
+int ath9k_cmn_count_streams(unsigned int chainmask, int max);
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index f388dcc..18d76ed 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -175,18 +175,6 @@ static const struct ath_ops ath9k_common_ops = {
 	.write = ath9k_iowrite32,
 };
 
-static int count_streams(unsigned int chainmask, int max)
-{
-	int streams = 0;
-
-	do {
-		if (++streams == max)
-			break;
-	} while ((chainmask = chainmask & (chainmask - 1)));
-
-	return streams;
-}
-
 /**************************/
 /*     Initialization     */
 /**************************/
@@ -227,8 +215,8 @@ static void setup_ht_cap(struct ath_softc *sc,
 
 	/* set up supported mcs set */
 	memset(&ht_info->mcs, 0, sizeof(ht_info->mcs));
-	tx_streams = count_streams(common->tx_chainmask, max_streams);
-	rx_streams = count_streams(common->rx_chainmask, max_streams);
+	tx_streams = ath9k_cmn_count_streams(common->tx_chainmask, max_streams);
+	rx_streams = ath9k_cmn_count_streams(common->rx_chainmask, max_streams);
 
 	ath_print(common, ATH_DBG_CONFIG,
 		  "TX streams %d, RX streams: %d\n",
-- 
1.7.1

