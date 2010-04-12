Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:19929 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751969Ab0DLHis (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Apr 2010 03:38:48 -0400
Received: from vs3016.wh2.ocn.ne.jp (125.206.180.189)
	by mail30g.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 4-0512737926
	for <linux-wireless@vger.kernel.org>; Mon, 12 Apr 2010 16:38:46 +0900 (JST)
Subject: [PATCH 1/2] ath5k: Use high bitrates for ACK/CTS
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Date: Mon, 12 Apr 2010 16:38:47 +0900
Message-ID: <20100412073847.28215.87571.stgit@tt-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There was a confusion in the usage of the bits AR5K_STA_ID1_ACKCTS_6MB and
AR5K_STA_ID1_BASE_RATE_11B. If they are set (1), we will get lower bitrates for
ACK and CTS. Therefore ath5k_hw_set_ack_bitrate_high(ah, false) actually
resulted in high bitrates, which i think is what we want anyways. Cleared the
confusion and added some documentation.

Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 drivers/net/wireless/ath/ath5k/base.c |    3 +--
 drivers/net/wireless/ath/ath5k/pcu.c  |    4 ++--
 drivers/net/wireless/ath/ath5k/reg.h  |    4 ++--
 3 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index f7f57c1..3f59bc2 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -2558,8 +2558,7 @@ ath5k_init(struct ath5k_softc *sc)
 	for (i = 0; i < AR5K_KEYTABLE_SIZE; i++)
 		ath5k_hw_reset_key(ah, i);
 
-	/* Set ack to be sent at low bit-rates */
-	ath5k_hw_set_ack_bitrate_high(ah, false);
+	ath5k_hw_set_ack_bitrate_high(ah, true);
 	ret = 0;
 done:
 	mmiowb();
diff --git a/drivers/net/wireless/ath/ath5k/pcu.c b/drivers/net/wireless/ath/ath5k/pcu.c
index 710870e..174412f 100644
--- a/drivers/net/wireless/ath/ath5k/pcu.c
+++ b/drivers/net/wireless/ath/ath5k/pcu.c
@@ -154,9 +154,9 @@ void ath5k_hw_set_ack_bitrate_high(struct ath5k_hw *ah, bool high)
 	else {
 		u32 val = AR5K_STA_ID1_BASE_RATE_11B | AR5K_STA_ID1_ACKCTS_6MB;
 		if (high)
-			AR5K_REG_ENABLE_BITS(ah, AR5K_STA_ID1, val);
-		else
 			AR5K_REG_DISABLE_BITS(ah, AR5K_STA_ID1, val);
+		else
+			AR5K_REG_ENABLE_BITS(ah, AR5K_STA_ID1, val);
 	}
 }
 
diff --git a/drivers/net/wireless/ath/ath5k/reg.h b/drivers/net/wireless/ath/ath5k/reg.h
index 45d62e9..55b4ac6 100644
--- a/drivers/net/wireless/ath/ath5k/reg.h
+++ b/drivers/net/wireless/ath/ath5k/reg.h
@@ -1139,8 +1139,8 @@
 #define AR5K_STA_ID1_DEFAULT_ANTENNA	0x00200000	/* Use default antenna */
 #define AR5K_STA_ID1_DESC_ANTENNA	0x00400000	/* Update antenna from descriptor */
 #define AR5K_STA_ID1_RTS_DEF_ANTENNA	0x00800000	/* Use default antenna for RTS */
-#define AR5K_STA_ID1_ACKCTS_6MB		0x01000000	/* Use 6Mbit/s for ACK/CTS */
-#define AR5K_STA_ID1_BASE_RATE_11B	0x02000000	/* Use 11b base rate for ACK/CTS [5211+] */
+#define AR5K_STA_ID1_ACKCTS_6MB		0x01000000	/* Rate to use for ACK/CTS. 0: highest mandatory rate <= RX rate; 1: 1Mbps in B mode */
+#define AR5K_STA_ID1_BASE_RATE_11B	0x02000000	/* 802.11b base rate. 0: 1, 2, 5.5 and 11Mbps; 1: 1 and 2Mbps. [5211+] */
 #define AR5K_STA_ID1_SELFGEN_DEF_ANT	0x04000000	/* Use def. antenna for self generated frames */
 #define AR5K_STA_ID1_CRYPT_MIC_EN	0x08000000	/* Enable MIC */
 #define AR5K_STA_ID1_KEYSRCH_MODE	0x10000000	/* Look up key when key id != 0 */

