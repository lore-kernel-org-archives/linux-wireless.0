Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:1352 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757487AbbGGQvJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jul 2015 12:51:09 -0400
From: Peter Oh <poh@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/3] ath10k: redefine rx_ppdu_end_common structure to cover qca99x0
Date: Tue, 7 Jul 2015 09:47:55 -0700
Message-ID: <1436287676-25767-3-git-send-email-poh@qca.qualcomm.com> (sfid-20150707_185116_874114_200D3379)
In-Reply-To: <1436287676-25767-1-git-send-email-poh@qca.qualcomm.com>
References: <1436287676-25767-1-git-send-email-poh@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

rx_ppdu_end_common structure is valid for both of qca998x and
qca6174, but not for qca99x0 since it has new additional members.
Hence update the common structure to cover qca99x0 as well.

Signed-off-by: Peter Oh <poh@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/rx_desc.h | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/rx_desc.h b/drivers/net/wireless/ath/ath10k/rx_desc.h
index 492b5a5..6cb078d 100644
--- a/drivers/net/wireless/ath/ath10k/rx_desc.h
+++ b/drivers/net/wireless/ath/ath10k/rx_desc.h
@@ -891,13 +891,13 @@ struct rx_ppdu_end_common {
 	__le32 evm_p15;
 	__le32 tsf_timestamp;
 	__le32 wb_timestamp;
-	u8 locationing_timestamp;
-	u8 phy_err_code;
-	__le16 flags; /* %RX_PPDU_END_FLAGS_ */
-	__le32 info0; /* %RX_PPDU_END_INFO0_ */
 } __packed;
 
 struct rx_ppdu_end_qca988x {
+	u8 locationing_timestamp;
+	u8 phy_err_code;
+	__le16 flags; /* %RX_PPDU_END_FLAGS_ */
+	__le32 info0; /* %RX_PPDU_END_INFO0_ */
 	__le16 bb_length;
 	__le16 info1; /* %RX_PPDU_END_INFO1_ */
 } __packed;
@@ -909,6 +909,10 @@ struct rx_ppdu_end_qca988x {
 #define RX_PPDU_END_RTT_NORMAL_MODE            BIT(31)
 
 struct rx_ppdu_end_qca6174 {
+	u8 locationing_timestamp;
+	u8 phy_err_code;
+	__le16 flags; /* %RX_PPDU_END_FLAGS_ */
+	__le32 info0; /* %RX_PPDU_END_INFO0_ */
 	__le32 rtt; /* %RX_PPDU_END_RTT_ */
 	__le16 bb_length;
 	__le16 info1; /* %RX_PPDU_END_INFO1_ */
-- 
1.9.1

