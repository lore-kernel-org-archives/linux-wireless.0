Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:49871 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751703Ab2ABNNR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jan 2012 08:13:17 -0500
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: Jouni Malinen <jouni@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	Balasubramanian senthilkumar <senthilb@qca.qualcomm.com>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	Vivek Natarajan <nataraja@qca.qualcomm.com>,
	<m.sujith@gmail.com>, Felix Fietkau <nbd@openwrt.org>,
	<ath9k-devel@lists.ath9k.org>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Subject: [RFC] ath9k_hw: make use of ar9003_calc_ptr_chksum
Date: Mon, 2 Jan 2012 18:43:05 +0530
Message-ID: <1325509985-11720-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20120102_141320_979320_93903C5D)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

make use of the already available function 'ar9003_calc_ptr_chksum'
in 'ar9003_set_txdesc'

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_mac.c |   59 ++++++++++-----------------
 1 files changed, 22 insertions(+), 37 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mac.c b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
index 4a31515..3c566de 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mac.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
@@ -22,44 +22,42 @@ static void ar9003_hw_rx_enable(struct ath_hw *hw)
 	REG_WRITE(hw, AR_CR, 0);
 }
 
+static u16 ar9003_calc_ptr_chksum(struct ar9003_txc *ads)
+{
+	int checksum;
+
+	checksum = ads->info + ads->link
+		+ ads->data0 + ads->ctl3
+		+ ads->data1 + ads->ctl5
+		+ ads->data2 + ads->ctl7
+		+ ads->data3 + ads->ctl9;
+
+	return ((checksum & 0xffff) + (checksum >> 16)) & AR_TxPtrChkSum;
+}
+
 static void
 ar9003_set_txdesc(struct ath_hw *ah, void *ds, struct ath_tx_info *i)
 {
 	struct ar9003_txc *ads = ds;
-	int checksum = 0;
 	u32 val, ctl12, ctl17;
 
-	val = (ATHEROS_VENDOR_ID << AR_DescId_S) |
-	      (1 << AR_TxRxDesc_S) |
-	      (1 << AR_CtrlStat_S) |
-	      (i->qcu << AR_TxQcuNum_S) | 0x17;
-
-	checksum += val;
-	ACCESS_ONCE(ads->info) = val;
+	ACCESS_ONCE(ads->info) = (ATHEROS_VENDOR_ID << AR_DescId_S) |
+				 (1 << AR_TxRxDesc_S) |
+				 (1 << AR_CtrlStat_S) |
+				 (i->qcu << AR_TxQcuNum_S) | 0x17;
 
-	checksum += i->link;
 	ACCESS_ONCE(ads->link) = i->link;
-
-	checksum += i->buf_addr[0];
 	ACCESS_ONCE(ads->data0) = i->buf_addr[0];
-	checksum += i->buf_addr[1];
 	ACCESS_ONCE(ads->data1) = i->buf_addr[1];
-	checksum += i->buf_addr[2];
 	ACCESS_ONCE(ads->data2) = i->buf_addr[2];
-	checksum += i->buf_addr[3];
 	ACCESS_ONCE(ads->data3) = i->buf_addr[3];
 
-	checksum += (val = (i->buf_len[0] << AR_BufLen_S) & AR_BufLen);
-	ACCESS_ONCE(ads->ctl3) = val;
-	checksum += (val = (i->buf_len[1] << AR_BufLen_S) & AR_BufLen);
-	ACCESS_ONCE(ads->ctl5) = val;
-	checksum += (val = (i->buf_len[2] << AR_BufLen_S) & AR_BufLen);
-	ACCESS_ONCE(ads->ctl7) = val;
-	checksum += (val = (i->buf_len[3] << AR_BufLen_S) & AR_BufLen);
-	ACCESS_ONCE(ads->ctl9) = val;
+	ACCESS_ONCE(ads->ctl13) = (i->buf_len[0] << AR_BufLen_S) & AR_BufLen;
+	ACCESS_ONCE(ads->ctl15) = (i->buf_len[1] << AR_BufLen_S) & AR_BufLen;
+	ACCESS_ONCE(ads->ctl17) = (i->buf_len[2] << AR_BufLen_S) & AR_BufLen;
+	ACCESS_ONCE(ads->ctl19) = (i->buf_len[3] << AR_BufLen_S) & AR_BufLen;
 
-	checksum = (u16) (((checksum & 0xffff) + (checksum >> 16)) & 0xffff);
-	ACCESS_ONCE(ads->ctl10) = checksum;
+	ACCESS_ONCE(ads->ctl10) = ar9003_calc_ptr_chksum(ads);
 
 	if (i->is_first || i->is_last) {
 		ACCESS_ONCE(ads->ctl13) = set11nTries(i->rates, 0)
@@ -148,19 +146,6 @@ ar9003_set_txdesc(struct ath_hw *ah, void *ds, struct ath_tx_info *i)
 	ACCESS_ONCE(ads->ctl19) = AR_Not_Sounding;
 }
 
-static u16 ar9003_calc_ptr_chksum(struct ar9003_txc *ads)
-{
-	int checksum;
-
-	checksum = ads->info + ads->link
-		+ ads->data0 + ads->ctl3
-		+ ads->data1 + ads->ctl5
-		+ ads->data2 + ads->ctl7
-		+ ads->data3 + ads->ctl9;
-
-	return ((checksum & 0xffff) + (checksum >> 16)) & AR_TxPtrChkSum;
-}
-
 static void ar9003_hw_set_desc_link(void *ds, u32 ds_link)
 {
 	struct ar9003_txc *ads = ds;
-- 
1.7.0.4

