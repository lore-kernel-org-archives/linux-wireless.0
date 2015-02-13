Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:60333 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752841AbbBMPgn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Feb 2015 10:36:43 -0500
From: SenthilKumar Jegadeesan <sjegadee@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	SenthilKumar Jegadeesan <sjegadee@qti.qualcomm.com>
Subject: [PATCH v2] ath10k: Increase AST table SKID length limit
Date: Fri, 13 Feb 2015 21:06:16 +0530
Message-ID: <1423841776-16288-1-git-send-email-sjegadee@qti.qualcomm.com> (sfid-20150213_163649_267647_F7E7574B)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The current SKID length configuration causes firmware
to reject peer creation for not able to allocate
AST entries for peers. This issue is observed when
least significant 3 bytes are used ramdomly to create
client MAC addresses.

AST table SKID length configuration is increased to
maximum value to fix this issue.

Signed-off-by: SenthilKumar Jegadeesan <sjegadee@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/hw.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index 460771f..7f04645 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -223,7 +223,7 @@ struct ath10k_pktlog_hdr {
 #define TARGET_10X_NUM_WDS_ENTRIES		32
 #define TARGET_10X_DMA_BURST_SIZE		0
 #define TARGET_10X_MAC_AGGR_DELIM		0
-#define TARGET_10X_AST_SKID_LIMIT		16
+#define TARGET_10X_AST_SKID_LIMIT		128
 #define TARGET_10X_NUM_STATIONS			128
 #define TARGET_10X_NUM_PEERS			((TARGET_10X_NUM_STATIONS) + \
 						 (TARGET_10X_NUM_VDEVS))
--
1.9.1

