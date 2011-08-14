Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:62441 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753116Ab1HNLiq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Aug 2011 07:38:46 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 4/4] ath6kl: Fix bug in computing AMSU subframe padding
Date: Sun, 14 Aug 2011 17:08:36 +0530
Message-ID: <1313321916-29685-4-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20110814_133851_412817_AE1BBF42)
In-Reply-To: <1313321916-29685-1-git-send-email-vthiagar@qca.qualcomm.com>
References: <1313321916-29685-1-git-send-email-vthiagar@qca.qualcomm.com>
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

diff --git a/drivers/net/wireless/ath/ath6kl/txrx.c b/drivers/net/wireless/ath/ath6kl/txrx.c
index 5d3d4b6..a55e0b7 100644
--- a/drivers/net/wireless/ath/ath6kl/txrx.c
+++ b/drivers/net/wireless/ath/ath6kl/txrx.c
@@ -812,7 +812,7 @@ static void aggr_slice_amsdu(struct aggr_info *p_aggr,
 		/* Add the length of A-MSDU subframe padding bytes -
 		 * Round to nearest word.
 		 */
-		frame_8023_len = ALIGN(frame_8023_len + 3, 3);
+		frame_8023_len = ALIGN(frame_8023_len, 3);
 
 		framep += frame_8023_len;
 		amsdu_len -= frame_8023_len;
-- 
1.7.0.4

