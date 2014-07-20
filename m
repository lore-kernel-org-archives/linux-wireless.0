Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:49773 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751802AbaGTMbc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Jul 2014 08:31:32 -0400
Received: by mail-we0-f174.google.com with SMTP id x48so6554708wes.33
        for <linux-wireless@vger.kernel.org>; Sun, 20 Jul 2014 05:31:30 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@lists.ath9k.org, linville@tuxdriver.com,
	Philippe Duchein <wireless-dev@duchein.net>
Subject: [PATCH 02/10] ath9k: add duration field to ath_tx_status
Date: Sun, 20 Jul 2014 14:31:18 +0200
Message-Id: <1405859486-31414-3-git-send-email-lorenzo.bianconi83@gmail.com> (sfid-20140720_143136_908395_221213E2)
In-Reply-To: <1405859486-31414-1-git-send-email-lorenzo.bianconi83@gmail.com>
References: <1405859486-31414-1-git-send-email-lorenzo.bianconi83@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add duration field to ath_tx_status in order to report frame duration for each
entry in multi-retry chain. These fields will be used in dynamic ack timeout
processing

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
---
 drivers/net/wireless/ath/ath9k/ar9002_mac.c | 7 +++++++
 drivers/net/wireless/ath/ath9k/ar9003_mac.c | 9 +++++++++
 drivers/net/wireless/ath/ath9k/mac.h        | 1 +
 3 files changed, 17 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/ar9002_mac.c b/drivers/net/wireless/ath/ath9k/ar9002_mac.c
index 59af9f9..669cb37 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_mac.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_mac.c
@@ -381,6 +381,13 @@ static int ar9002_hw_proc_txdesc(struct ath_hw *ah, void *ds,
 	ts->evm1 = ads->AR_TxEVM1;
 	ts->evm2 = ads->AR_TxEVM2;
 
+	status = ACCESS_ONCE(ads->ds_ctl4);
+	ts->duration[0] = MS(status, AR_PacketDur0);
+	ts->duration[1] = MS(status, AR_PacketDur1);
+	status = ACCESS_ONCE(ads->ds_ctl5);
+	ts->duration[2] = MS(status, AR_PacketDur2);
+	ts->duration[3] = MS(status, AR_PacketDur3);
+
 	return 0;
 }
 
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mac.c b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
index 71e38e8..e5f7c11 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mac.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
@@ -355,9 +355,11 @@ static int ar9003_hw_proc_txdesc(struct ath_hw *ah, void *ds,
 				 struct ath_tx_status *ts)
 {
 	struct ar9003_txs *ads;
+	struct ar9003_txc *adc;
 	u32 status;
 
 	ads = &ah->ts_ring[ah->ts_tail];
+	adc = (struct ar9003_txc *)ads;
 
 	status = ACCESS_ONCE(ads->status8);
 	if ((status & AR_TxDone) == 0)
@@ -426,6 +428,13 @@ static int ar9003_hw_proc_txdesc(struct ath_hw *ah, void *ds,
 	ts->ts_rssi_ext1 = MS(status, AR_TxRSSIAnt11);
 	ts->ts_rssi_ext2 = MS(status, AR_TxRSSIAnt12);
 
+	status = ACCESS_ONCE(adc->ctl15);
+	ts->duration[0] = MS(status, AR_PacketDur0);
+	ts->duration[1] = MS(status, AR_PacketDur1);
+	status = ACCESS_ONCE(adc->ctl16);
+	ts->duration[2] = MS(status, AR_PacketDur2);
+	ts->duration[3] = MS(status, AR_PacketDur3);
+
 	memset(ads, 0, sizeof(*ads));
 
 	return 0;
diff --git a/drivers/net/wireless/ath/ath9k/mac.h b/drivers/net/wireless/ath/ath9k/mac.h
index 6c56caf..cd05a77 100644
--- a/drivers/net/wireless/ath/ath9k/mac.h
+++ b/drivers/net/wireless/ath/ath9k/mac.h
@@ -121,6 +121,7 @@ struct ath_tx_status {
 	u32 evm0;
 	u32 evm1;
 	u32 evm2;
+	u32 duration[4];
 };
 
 struct ath_rx_status {
-- 
1.9.1

