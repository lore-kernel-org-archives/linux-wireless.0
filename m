Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:49976 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752587Ab1HWIUS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Aug 2011 04:20:18 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <linux-wireless@vger.kernel.org>
CC: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
Subject: [PATCH 4/7] ath6kl: Fix bug in computing AMSU subframe padding
Date: Tue, 23 Aug 2011 11:16:43 +0300
Message-ID: <1314087406-29188-5-git-send-email-kvalo@qca.qualcomm.com> (sfid-20110823_102021_917216_D4AF0DCD)
In-Reply-To: <1314087406-29188-1-git-send-email-kvalo@qca.qualcomm.com>
References: <1314087406-29188-1-git-send-email-kvalo@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>

This fixes AMSDU rx, otherwise it fails with the following warnings.

"802.3 AMSDU frame bound check failed"

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/txrx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/txrx.c b/drivers/net/wireless/ath/ath6kl/txrx.c
index 5d3d4b6..44bf227 100644
--- a/drivers/net/wireless/ath/ath6kl/txrx.c
+++ b/drivers/net/wireless/ath/ath6kl/txrx.c
@@ -812,7 +812,7 @@ static void aggr_slice_amsdu(struct aggr_info *p_aggr,
 		/* Add the length of A-MSDU subframe padding bytes -
 		 * Round to nearest word.
 		 */
-		frame_8023_len = ALIGN(frame_8023_len + 3, 3);
+		frame_8023_len = ALIGN(frame_8023_len, 4);
 
 		framep += frame_8023_len;
 		amsdu_len -= frame_8023_len;
-- 
1.7.1

