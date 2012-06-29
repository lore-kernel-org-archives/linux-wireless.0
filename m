Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.net.t-labs.tu-berlin.de ([130.149.220.252]:60559 "EHLO
	mail.net.t-labs.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750806Ab2F2Onm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jun 2012 10:43:42 -0400
From: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, senthilb@qca.qualcomm.com,
	ath9k-devel@lists.ath9k.org, vthiagar@qca.qualcomm.com,
	jouni@qca.qualcomm.com, mcgrof@qca.qualcomm.com,
	thomas@net.t-labs.tu-berlin.de, nbd@openwrt.org
Subject: [PATCH] ath9k: fixing register bit shift values of control packets to support TPC
Date: Fri, 29 Jun 2012 10:43:10 -0400
Message-Id: <1340980990-81486-1-git-send-email-thomas@net.t-labs.tu-berlin.de> (sfid-20120629_164345_760767_2E7E6B28)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some register values of bit shifts are corrected in order to support the upcoming
transmission power control (tpc) for control packets as well.

Signed-off-by: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
---
 drivers/net/wireless/ath/ath9k/reg.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/reg.h b/drivers/net/wireless/ath/ath9k/reg.h
index 5046b28..dd9c726 100644
--- a/drivers/net/wireless/ath/ath9k/reg.h
+++ b/drivers/net/wireless/ath/ath9k/reg.h
@@ -1643,11 +1643,11 @@ enum {
 
 #define AR_TPC                 0x80e8
 #define AR_TPC_ACK             0x0000003f
-#define AR_TPC_ACK_S           0x00
+#define AR_TPC_ACK_S           0
 #define AR_TPC_CTS             0x00003f00
-#define AR_TPC_CTS_S           0x08
+#define AR_TPC_CTS_S           8
 #define AR_TPC_CHIRP           0x003f0000
-#define AR_TPC_CHIRP_S         0x16
+#define AR_TPC_CHIRP_S         16
 
 #define AR_QUIET1          0x80fc
 #define AR_QUIET1_NEXT_QUIET_S         0
-- 
1.7.10.4

