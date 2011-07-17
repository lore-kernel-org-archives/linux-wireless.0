Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:23198 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076Ab1GQGIx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Jul 2011 02:08:53 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH 2/2] ath9k: Fix some smatch warnings
Date: Sun, 17 Jul 2011 11:38:49 +0530
Message-ID: <1310882929-10528-2-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20110717_080859_050686_2ECFE752)
In-Reply-To: <1310882929-10528-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1310882929-10528-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

drivers/net/wireless/ath/ath9k/hif_usb.c +135 hif_usb_mgmt_cb(6) warn:
variable dereferenced before check 'cmd'
drivers/net/wireless/ath/ath9k/btcoex.c +77 ath9k_hw_init_btcoex_hw(38)
error: buffer overflow 'ah->hw_gen_timers.gen_timer_index' 32 <=
2009813776

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/btcoex.c  |    8 +++++---
 drivers/net/wireless/ath/ath9k/hif_usb.c |    4 +++-
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/btcoex.c b/drivers/net/wireless/ath/ath9k/btcoex.c
index 41ce0b1..6635c37 100644
--- a/drivers/net/wireless/ath/ath9k/btcoex.c
+++ b/drivers/net/wireless/ath/ath9k/btcoex.c
@@ -50,7 +50,7 @@ void ath9k_hw_init_btcoex_hw(struct ath_hw *ah, int qnum)
 		.bt_first_slot_time = 5,
 		.bt_hold_rx_clear = true,
 	};
-	u32 i;
+	u32 i, idx;
 	bool rxclear_polarity = ath_bt_config.bt_rxclear_polarity;
 
 	if (AR_SREV_9300_20_OR_LATER(ah))
@@ -73,8 +73,10 @@ void ath9k_hw_init_btcoex_hw(struct ath_hw *ah, int qnum)
 		SM(ATH_BTCOEX_BMISS_THRESH, AR_BT_BCN_MISS_THRESH) |
 		AR_BT_DISABLE_BT_ANT;
 
-	for (i = 0; i < 32; i++)
-		ah->hw_gen_timers.gen_timer_index[(debruijn32 << i) >> 27] = i;
+	for (i = 0; i < 32; i++) {
+		idx = (debruijn32 << i) >> 27;
+		ah->hw_gen_timers.gen_timer_index[idx] = i;
+	}
 }
 EXPORT_SYMBOL(ath9k_hw_init_btcoex_hw);
 
diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index 8028fe9..c5c42c0 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -129,12 +129,14 @@ static int hif_usb_send_regout(struct hif_device_usb *hif_dev,
 static void hif_usb_mgmt_cb(struct urb *urb)
 {
 	struct cmd_buf *cmd = (struct cmd_buf *)urb->context;
-	struct hif_device_usb *hif_dev = cmd->hif_dev;
+	struct hif_device_usb *hif_dev;
 	bool txok = true;
 
 	if (!cmd || !cmd->skb || !cmd->hif_dev)
 		return;
 
+	hif_dev = cmd->hif_dev;
+
 	switch (urb->status) {
 	case 0:
 		break;
-- 
1.7.6

