Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:32582 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615Ab1HPFtZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Aug 2011 01:49:25 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <kvalo@adurom.com>
Subject: [PATCH V2] ath6kl: Fix bug in computing AMSU subframe padding
Date: Tue, 16 Aug 2011 11:19:38 +0530
Message-ID: <1313473778-1740-1-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20110816_074928_479567_64140982)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes AMSDU rx, otherwise it fails with the following warnings.

"802.3 AMSDU frame bound check failed"

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/txrx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

V2 -- It is 4-byte aligned not 3, thanks to Kevin for pointing this out.

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
1.7.0.4

