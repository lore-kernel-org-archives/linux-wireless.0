Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:1477 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124Ab1HZFkK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Aug 2011 01:40:10 -0400
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <rodrigue@qca.qualcomm.com>,
	<senthilb@qca.qualcomm.com>, <rmanohar@qca.qualcomm.com>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Subject: [PATCH] ath9k: use appropriate debug mask
Date: Fri, 26 Aug 2011 11:10:01 +0530
Message-ID: <1314337201-3666-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20110826_074014_895775_0B6C021C)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

in the Rx path of the driver it would be better to use ATH_DBG_ANY
rather than ATH_DBG_XMIT for printing debug messages

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/recv.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index ad5f9bd..800e9ee 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -937,7 +937,7 @@ static int ath9k_process_rate(struct ath_common *common,
 	 * No valid hardware bitrate found -- we should not get here
 	 * because hardware has already validated this frame as OK.
 	 */
-	ath_dbg(common, ATH_DBG_XMIT,
+	ath_dbg(common, ATH_DBG_ANY,
 		"unsupported hw bitrate detected 0x%02x using 1 Mbit\n",
 		rx_stats->rs_rate);
 
-- 
1.7.0.4

