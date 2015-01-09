Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f52.google.com ([209.85.218.52]:33536 "EHLO
	mail-oi0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492AbbAITSV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Jan 2015 14:18:21 -0500
Received: by mail-oi0-f52.google.com with SMTP id a3so13232572oib.11
        for <linux-wireless@vger.kernel.org>; Fri, 09 Jan 2015 11:18:20 -0800 (PST)
From: Bob Copeland <me@bobcopeland.com>
To: linux-wireless@vger.kernel.org
Cc: Eugene Krasnikov <k.eugene.e@gmail.com>,
	Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 3/8] wcn36xx: let device generate qos seq numbers
Date: Fri,  9 Jan 2015 14:15:47 -0500
Message-Id: <1420830952-9624-4-git-send-email-me@bobcopeland.com> (sfid-20150109_201847_796962_CCDEF60D)
In-Reply-To: <1420830952-9624-1-git-send-email-me@bobcopeland.com>
References: <1420830952-9624-1-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

wcn36xx currently sends an incorrect sequence number into the BA session
setup firmware command: it should be saving or updating the ssn in the
TX_START ampdu_action callback instead of waiting until TX_OPERATIONAL.
However, we can sidestep the issue by letting the hardware generate the
sequence numbers for QoS frames, as is done in prima, so do that.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/ath/wcn36xx/txrx.c |    1 +
 drivers/net/wireless/ath/wcn36xx/txrx.h |    9 ++++++++-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/txrx.c b/drivers/net/wireless/ath/wcn36xx/txrx.c
index f701873..277bc39 100644
--- a/drivers/net/wireless/ath/wcn36xx/txrx.c
+++ b/drivers/net/wireless/ath/wcn36xx/txrx.c
@@ -93,6 +93,7 @@ static void wcn36xx_set_tx_pdu(struct wcn36xx_tx_bd *bd,
 		bd->pdu.mpdu_header_off;
 	bd->pdu.mpdu_len = len;
 	bd->pdu.tid = tid;
+	bd->pdu.bd_ssn = WCN36XX_TXBD_SSN_FILL_DPU_QOS;
 }
 
 static inline struct wcn36xx_vif *get_vif_by_addr(struct wcn36xx *wcn,
diff --git a/drivers/net/wireless/ath/wcn36xx/txrx.h b/drivers/net/wireless/ath/wcn36xx/txrx.h
index bbfbcf8..032216e 100644
--- a/drivers/net/wireless/ath/wcn36xx/txrx.h
+++ b/drivers/net/wireless/ath/wcn36xx/txrx.h
@@ -32,6 +32,12 @@
 #define WCN36XX_BD_RATE_MGMT 2
 #define WCN36XX_BD_RATE_CTRL 3
 
+enum wcn36xx_txbd_ssn_type {
+	WCN36XX_TXBD_SSN_FILL_HOST = 0,
+	WCN36XX_TXBD_SSN_FILL_DPU_NON_QOS = 1,
+	WCN36XX_TXBD_SSN_FILL_DPU_QOS = 2,
+};
+
 struct wcn36xx_pdu {
 	u32	dpu_fb:8;
 	u32	adu_fb:8;
@@ -50,7 +56,8 @@ struct wcn36xx_pdu {
 	/* 0x0c*/
 	u32	reserved4:8;
 	u32	tid:4;
-	u32	reserved3:4;
+	u32	bd_ssn:2;
+	u32	reserved3:2;
 	u32	mpdu_len:16;
 };
 
-- 
1.7.10.4

