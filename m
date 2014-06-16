Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f44.google.com ([209.85.160.44]:50412 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752571AbaFPOLv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Jun 2014 10:11:51 -0400
Received: by mail-pb0-f44.google.com with SMTP id md12so3688968pbc.17
        for <linux-wireless@vger.kernel.org>; Mon, 16 Jun 2014 07:11:51 -0700 (PDT)
Received: from localhost.localdomain ([115.248.87.14])
        by mx.google.com with ESMTPSA id fe3sm19023655pbd.66.2014.06.16.07.11.49
        for <linux-wireless@vger.kernel.org>
        (version=TLSv1 cipher=RC4-SHA bits=128/128);
        Mon, 16 Jun 2014 07:11:50 -0700 (PDT)
From: Jahnavi Meher <jahnavi.meher@gmail.com>
To: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 05/16] rsi: Changed the radio caps frame.
Date: Mon, 16 Jun 2014 19:41:41 +0530
Message-Id: <1402927901-3889-1-git-send-email-jahnavi.meher@gmail.com> (sfid-20140616_161153_874236_8D8427A3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Changed the radio caps frame and added the required fields.

Signed-off-by: Jahnavi Meher <jahnavi.meher@gmail.com>
---
 drivers/net/wireless/rsi/rsi_91x_mgmt.c |    7 +++++++
 drivers/net/wireless/rsi/rsi_mgmt.h     |   15 +++++++++++++++
 2 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_mgmt.c b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
index 2cdb36a..c3d8da9 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mgmt.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
@@ -331,6 +331,13 @@ static int rsi_load_radio_caps(struct rsi_common *common)
 		}
 	}
 
+	radio_caps->sifs_tx_11n = cpu_to_le16(SIFS_TX_11N_VALUE);
+	radio_caps->sifs_tx_11b = cpu_to_le16(SIFS_TX_11B_VALUE);
+	radio_caps->slot_rx_11n = cpu_to_le16(SHORT_SLOT_VALUE);
+	radio_caps->ofdm_ack_tout = cpu_to_le16(OFDM_ACK_TOUT_VALUE);
+	radio_caps->cck_ack_tout = cpu_to_le16(CCK_ACK_TOUT_VALUE);
+	radio_caps->preamble_type = cpu_to_le16(LONG_PREAMBLE);
+
 	radio_caps->desc_word[7] |= cpu_to_le16(radio_id << 8);
 
 	for (ii = 0; ii < MAX_HW_QUEUES; ii++) {
diff --git a/drivers/net/wireless/rsi/rsi_mgmt.h b/drivers/net/wireless/rsi/rsi_mgmt.h
index 0641068..6ccf9d9 100644
--- a/drivers/net/wireless/rsi/rsi_mgmt.h
+++ b/drivers/net/wireless/rsi/rsi_mgmt.h
@@ -128,6 +128,15 @@
 #define EP_5GHZ_20MHZ			2
 #define EP_5GHZ_40MHZ			3
 
+#define SIFS_TX_11N_VALUE		580
+#define SIFS_TX_11B_VALUE		346
+#define SHORT_SLOT_VALUE		360
+#define LONG_SLOT_VALUE			640
+#define OFDM_ACK_TOUT_VALUE		2720
+#define CCK_ACK_TOUT_VALUE		9440
+#define LONG_PREAMBLE			0x0000
+#define SHORT_PREAMBLE			0x0001
+
 #define RSI_SUPP_FILTERS	(FIF_ALLMULTI | FIF_PROBE_REQ |\
 				 FIF_BCN_PRBRESP_PROMISC)
 enum opmode {
@@ -243,6 +252,12 @@ struct rsi_radio_caps {
 	u8 num_11n_rates;
 	u8 num_11ac_rates;
 	__le16 gcpd_per_rate[20];
+	__le16 sifs_tx_11n;
+	__le16 sifs_tx_11b;
+	__le16 slot_rx_11n;
+	__le16 ofdm_ack_tout;
+	__le16 cck_ack_tout;
+	__le16 preamble_type;
 } __packed;
 
 static inline u32 rsi_get_queueno(u8 *addr, u16 offset)
-- 
1.7.1

