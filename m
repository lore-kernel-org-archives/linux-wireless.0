Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64910 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754484Ab1IRC5n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Sep 2011 22:57:43 -0400
Received: by fxe4 with SMTP id 4so2868138fxe.19
        for <linux-wireless@vger.kernel.org>; Sat, 17 Sep 2011 19:57:42 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] ath9k: use ACCESS_ONCE_RW for write assignments
Date: Sun, 18 Sep 2011 04:57:36 +0200
Cc: John Linville <linville@tuxdriver.com>, nbd@openwrt.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201109180457.37146.chunkeey@googlemail.com> (sfid-20110918_045750_621744_432AB9CB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes a compiler error which was introduced by 
"ath9k_hw: add a new API for setting tx descriptors" [2b63a4].

ar9002_mac.c:185:2: error: assignment of read-only location
...
ar9003_mac.c:37:2: error: assignment of read-only location
...

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
compile tested...
---
diff --git a/drivers/net/wireless/ath/ath9k/ar9002_mac.c b/drivers/net/wireless/ath/ath9k/ar9002_mac.c
index f7d8e51..0f00e49 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_mac.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_mac.c
@@ -182,8 +182,8 @@ ar9002_set_txdesc(struct ath_hw *ah, void *ds, struct ath_tx_info *i)
 	ads->ds_txstatus6 = ads->ds_txstatus7 = 0;
 	ads->ds_txstatus8 = ads->ds_txstatus9 = 0;
 
-	ACCESS_ONCE(ads->ds_link) = i->link;
-	ACCESS_ONCE(ads->ds_data) = i->buf_addr[0];
+	ACCESS_ONCE_RW(ads->ds_link) = i->link;
+	ACCESS_ONCE_RW(ads->ds_data) = i->buf_addr[0];
 
 	ctl1 = i->buf_len[0] | (i->is_last ? 0 : AR_TxMore);
 	ctl6 = SM(i->keytype, AR_EncrType);
@@ -197,26 +197,26 @@ ar9002_set_txdesc(struct ath_hw *ah, void *ds, struct ath_tx_info *i)
 
 	if ((i->is_first || i->is_last) &&
 	    i->aggr != AGGR_BUF_MIDDLE && i->aggr != AGGR_BUF_LAST) {
-		ACCESS_ONCE(ads->ds_ctl2) = set11nTries(i->rates, 0)
+		ACCESS_ONCE_RW(ads->ds_ctl2) = set11nTries(i->rates, 0)
 			| set11nTries(i->rates, 1)
 			| set11nTries(i->rates, 2)
 			| set11nTries(i->rates, 3)
 			| (i->dur_update ? AR_DurUpdateEna : 0)
 			| SM(0, AR_BurstDur);
 
-		ACCESS_ONCE(ads->ds_ctl3) = set11nRate(i->rates, 0)
+		ACCESS_ONCE_RW(ads->ds_ctl3) = set11nRate(i->rates, 0)
 			| set11nRate(i->rates, 1)
 			| set11nRate(i->rates, 2)
 			| set11nRate(i->rates, 3);
 	} else {
-		ACCESS_ONCE(ads->ds_ctl2) = 0;
-		ACCESS_ONCE(ads->ds_ctl3) = 0;
+		ACCESS_ONCE_RW(ads->ds_ctl2) = 0;
+		ACCESS_ONCE_RW(ads->ds_ctl3) = 0;
 	}
 
 	if (!i->is_first) {
-		ACCESS_ONCE(ads->ds_ctl0) = 0;
-		ACCESS_ONCE(ads->ds_ctl1) = ctl1;
-		ACCESS_ONCE(ads->ds_ctl6) = ctl6;
+		ACCESS_ONCE_RW(ads->ds_ctl0) = 0;
+		ACCESS_ONCE_RW(ads->ds_ctl1) = ctl1;
+		ACCESS_ONCE_RW(ads->ds_ctl6) = ctl6;
 		return;
 	}
 
@@ -241,7 +241,7 @@ ar9002_set_txdesc(struct ath_hw *ah, void *ds, struct ath_tx_info *i)
 		break;
 	}
 
-	ACCESS_ONCE(ads->ds_ctl0) = (i->pkt_len & AR_FrameLen)
+	ACCESS_ONCE_RW(ads->ds_ctl0) = (i->pkt_len & AR_FrameLen)
 		| (i->flags & ATH9K_TXDESC_VMF ? AR_VirtMoreFrag : 0)
 		| SM(i->txpower, AR_XmitPower)
 		| (i->flags & ATH9K_TXDESC_VEOL ? AR_VEOL : 0)
@@ -251,19 +251,19 @@ ar9002_set_txdesc(struct ath_hw *ah, void *ds, struct ath_tx_info *i)
 		| (i->flags & ATH9K_TXDESC_RTSENA ? AR_RTSEnable :
 		   (i->flags & ATH9K_TXDESC_CTSENA ? AR_CTSEnable : 0));
 
-	ACCESS_ONCE(ads->ds_ctl1) = ctl1;
-	ACCESS_ONCE(ads->ds_ctl6) = ctl6;
+	ACCESS_ONCE_RW(ads->ds_ctl1) = ctl1;
+	ACCESS_ONCE_RW(ads->ds_ctl6) = ctl6;
 
 	if (i->aggr == AGGR_BUF_MIDDLE || i->aggr == AGGR_BUF_LAST)
 		return;
 
-	ACCESS_ONCE(ads->ds_ctl4) = set11nPktDurRTSCTS(i->rates, 0)
+	ACCESS_ONCE_RW(ads->ds_ctl4) = set11nPktDurRTSCTS(i->rates, 0)
 		| set11nPktDurRTSCTS(i->rates, 1);
 
-	ACCESS_ONCE(ads->ds_ctl5) = set11nPktDurRTSCTS(i->rates, 2)
+	ACCESS_ONCE_RW(ads->ds_ctl5) = set11nPktDurRTSCTS(i->rates, 2)
 		| set11nPktDurRTSCTS(i->rates, 3);
 
-	ACCESS_ONCE(ads->ds_ctl7) = set11nRateFlags(i->rates, 0)
+	ACCESS_ONCE_RW(ads->ds_ctl7) = set11nRateFlags(i->rates, 0)
 		| set11nRateFlags(i->rates, 1)
 		| set11nRateFlags(i->rates, 2)
 		| set11nRateFlags(i->rates, 3)
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mac.c b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
index 6cabc85..38a13a4 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mac.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
@@ -34,47 +34,47 @@ ar9003_set_txdesc(struct ath_hw *ah, void *ds, struct ath_tx_info *i)
 	      (i->qcu << AR_TxQcuNum_S) | 0x17;
 
 	checksum += val;
-	ACCESS_ONCE(ads->info) = val;
+	ACCESS_ONCE_RW(ads->info) = val;
 
 	checksum += i->link;
-	ACCESS_ONCE(ads->link) = i->link;
+	ACCESS_ONCE_RW(ads->link) = i->link;
 
 	checksum += i->buf_addr[0];
-	ACCESS_ONCE(ads->data0) = i->buf_addr[0];
+	ACCESS_ONCE_RW(ads->data0) = i->buf_addr[0];
 	checksum += i->buf_addr[1];
-	ACCESS_ONCE(ads->data1) = i->buf_addr[1];
+	ACCESS_ONCE_RW(ads->data1) = i->buf_addr[1];
 	checksum += i->buf_addr[2];
-	ACCESS_ONCE(ads->data2) = i->buf_addr[2];
+	ACCESS_ONCE_RW(ads->data2) = i->buf_addr[2];
 	checksum += i->buf_addr[3];
-	ACCESS_ONCE(ads->data3) = i->buf_addr[3];
+	ACCESS_ONCE_RW(ads->data3) = i->buf_addr[3];
 
 	checksum += (val = (i->buf_len[0] << AR_BufLen_S) & AR_BufLen);
-	ACCESS_ONCE(ads->ctl3) = val;
+	ACCESS_ONCE_RW(ads->ctl3) = val;
 	checksum += (val = (i->buf_len[1] << AR_BufLen_S) & AR_BufLen);
-	ACCESS_ONCE(ads->ctl5) = val;
+	ACCESS_ONCE_RW(ads->ctl5) = val;
 	checksum += (val = (i->buf_len[2] << AR_BufLen_S) & AR_BufLen);
-	ACCESS_ONCE(ads->ctl7) = val;
+	ACCESS_ONCE_RW(ads->ctl7) = val;
 	checksum += (val = (i->buf_len[3] << AR_BufLen_S) & AR_BufLen);
-	ACCESS_ONCE(ads->ctl9) = val;
+	ACCESS_ONCE_RW(ads->ctl9) = val;
 
 	checksum = (u16) (((checksum & 0xffff) + (checksum >> 16)) & 0xffff);
-	ACCESS_ONCE(ads->ctl10) = checksum;
+	ACCESS_ONCE_RW(ads->ctl10) = checksum;
 
 	if (i->is_first || i->is_last) {
-		ACCESS_ONCE(ads->ctl13) = set11nTries(i->rates, 0)
+		ACCESS_ONCE_RW(ads->ctl13) = set11nTries(i->rates, 0)
 			| set11nTries(i->rates, 1)
 			| set11nTries(i->rates, 2)
 			| set11nTries(i->rates, 3)
 			| (i->dur_update ? AR_DurUpdateEna : 0)
 			| SM(0, AR_BurstDur);
 
-		ACCESS_ONCE(ads->ctl14) = set11nRate(i->rates, 0)
+		ACCESS_ONCE_RW(ads->ctl14) = set11nRate(i->rates, 0)
 			| set11nRate(i->rates, 1)
 			| set11nRate(i->rates, 2)
 			| set11nRate(i->rates, 3);
 	} else {
-		ACCESS_ONCE(ads->ctl13) = 0;
-		ACCESS_ONCE(ads->ctl14) = 0;
+		ACCESS_ONCE_RW(ads->ctl13) = 0;
+		ACCESS_ONCE_RW(ads->ctl14) = 0;
 	}
 
 	ads->ctl20 = 0;
@@ -83,17 +83,17 @@ ar9003_set_txdesc(struct ath_hw *ah, void *ds, struct ath_tx_info *i)
 
 	ctl17 = SM(i->keytype, AR_EncrType);
 	if (!i->is_first) {
-		ACCESS_ONCE(ads->ctl11) = 0;
-		ACCESS_ONCE(ads->ctl12) = i->is_last ? 0 : AR_TxMore;
-		ACCESS_ONCE(ads->ctl15) = 0;
-		ACCESS_ONCE(ads->ctl16) = 0;
-		ACCESS_ONCE(ads->ctl17) = ctl17;
-		ACCESS_ONCE(ads->ctl18) = 0;
-		ACCESS_ONCE(ads->ctl19) = 0;
+		ACCESS_ONCE_RW(ads->ctl11) = 0;
+		ACCESS_ONCE_RW(ads->ctl12) = i->is_last ? 0 : AR_TxMore;
+		ACCESS_ONCE_RW(ads->ctl15) = 0;
+		ACCESS_ONCE_RW(ads->ctl16) = 0;
+		ACCESS_ONCE_RW(ads->ctl17) = ctl17;
+		ACCESS_ONCE_RW(ads->ctl18) = 0;
+		ACCESS_ONCE_RW(ads->ctl19) = 0;
 		return;
 	}
 
-	ACCESS_ONCE(ads->ctl11) = (i->pkt_len & AR_FrameLen)
+	ACCESS_ONCE_RW(ads->ctl11) = (i->pkt_len & AR_FrameLen)
 		| (i->flags & ATH9K_TXDESC_VMF ? AR_VirtMoreFrag : 0)
 		| SM(i->txpower, AR_XmitPower)
 		| (i->flags & ATH9K_TXDESC_VEOL ? AR_VEOL : 0)
@@ -129,22 +129,22 @@ ar9003_set_txdesc(struct ath_hw *ah, void *ds, struct ath_tx_info *i)
 	val = (i->flags & ATH9K_TXDESC_PAPRD) >> ATH9K_TXDESC_PAPRD_S;
 	ctl12 |= SM(val, AR_PAPRDChainMask);
 
-	ACCESS_ONCE(ads->ctl12) = ctl12;
-	ACCESS_ONCE(ads->ctl17) = ctl17;
+	ACCESS_ONCE_RW(ads->ctl12) = ctl12;
+	ACCESS_ONCE_RW(ads->ctl17) = ctl17;
 
-	ACCESS_ONCE(ads->ctl15) = set11nPktDurRTSCTS(i->rates, 0)
+	ACCESS_ONCE_RW(ads->ctl15) = set11nPktDurRTSCTS(i->rates, 0)
 		| set11nPktDurRTSCTS(i->rates, 1);
 
-	ACCESS_ONCE(ads->ctl16) = set11nPktDurRTSCTS(i->rates, 2)
+	ACCESS_ONCE_RW(ads->ctl16) = set11nPktDurRTSCTS(i->rates, 2)
 		| set11nPktDurRTSCTS(i->rates, 3);
 
-	ACCESS_ONCE(ads->ctl18) = set11nRateFlags(i->rates, 0)
+	ACCESS_ONCE_RW(ads->ctl18) = set11nRateFlags(i->rates, 0)
 		| set11nRateFlags(i->rates, 1)
 		| set11nRateFlags(i->rates, 2)
 		| set11nRateFlags(i->rates, 3)
 		| SM(i->rtscts_rate, AR_RTSCTSRate);
 
-	ACCESS_ONCE(ads->ctl19) = AR_Not_Sounding;
+	ACCESS_ONCE_RW(ads->ctl19) = AR_Not_Sounding;
 }
 
 static u16 ar9003_calc_ptr_chksum(struct ar9003_txc *ads)
